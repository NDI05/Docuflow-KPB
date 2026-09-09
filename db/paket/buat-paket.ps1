$ErrorActionPreference = "Stop"
$dist = "C:\dev\dist"

if (Test-Path $dist) { Remove-Item $dist -Recurse -Force }
New-Item -ItemType Directory -Path "$dist\app", "$dist\sql", "$dist\basis-data" | Out-Null

Write-Host "==> 1/5 Publish aplikasi (Release)"
Set-Location "C:\dev\docuflow\Docuflow_projectIT-KPB"
dotnet publish -c Release -o "$dist\app" --nologo | Select-Object -Last 3

# Folder unggahan harus ADA tapi KOSONG: dua berkas yang tersisa di server uji
# adalah sisa percobaan Agustus dan tidak dirujuk satu baris pun di basis data.
New-Item -ItemType Directory -Path "$dist\app\wwwroot\uploads" -Force | Out-Null
Get-ChildItem "$dist\app\wwwroot\uploads" -File -ErrorAction SilentlyContinue | Remove-Item -Force

# appsettings.json hasil publish memuat sambungan basis data mesin uji.
# Diganti contoh berisi placeholder supaya tidak ada yang menyalinnya apa adanya.
# Dihapus, bukan disimpan sebagai contoh: berkasnya memuat sambungan mesin
# uji lengkap, dan sebuah "contoh" berisi sambungan nyata adalah hal yang
# paling mudah disalin apa adanya di server tujuan.
Remove-Item "$dist\app\appsettings.json" -Force
Remove-Item "$dist\app\appsettings.Development.json" -Force -ErrorAction SilentlyContinue

Write-Host "==> 2/5 Skrip skema dari EF migrations"
# --nologo bukan opsi `dotnet ef`; dulu galatnya tertelan Out-Null dan
# 01-skema.sql tidak pernah terbentuk tanpa ada yang memberi tahu.
dotnet ef migrations script --idempotent --output "$dist\sql\01-skema.sql"
if (-not (Test-Path "$dist\sql\01-skema.sql")) { throw "Skrip skema tidak terbentuk" }

Write-Host "==> 3/5 Skrip data inti (jenis surat, pengguna, counter)"
# -y 8000, bukan -W: lebar bawaan sqlcmd memotong baris INSERT di tengah
# string dan hasilnya gagal parse. Sisa spasi dipangkas setelahnya.
sqlcmd -S "localhost\SQLEXPRESS" -d DocuflowDB -E -h -1 -y 8000 -i C:\dev\data-inti.sql -o "$dist\sql\02-data-inti.sql"
(Get-Content "$dist\sql\02-data-inti.sql") | ForEach-Object { $_.TrimEnd() } | Set-Content "$dist\sql\02-data-inti.sql" -Encoding UTF8

Write-Host "==> 4/5 Salin skrip data lain"
Copy-Item "C:\dev\docuflow\db\seed-kota.sql"          "$dist\sql\03-kota.sql"
Copy-Item "C:\dev\docuflow\db\impor-arsip-2026.sql"   "$dist\sql\04-arsip-2026.sql"

Write-Host "==> 5/5 Ekspor basis data (.bacpac)"
# Cadangan .bak sementara, HANYA sebagai sumber salinan bersih untuk ekspor.
# Yang diserahkan adalah .bacpac; .bak dari SQL Server 17 tidak bisa dipulihkan
# di versi yang lebih lama, sedangkan bacpac dari sqlpackage 162 bermodel Sql160
# dan masuk ke SQL Server 2022 ke atas.
$bakSementara = "C:\dev\docuflow-ekspor-sementara.bak"
sqlcmd -S "localhost\SQLEXPRESS" -E -b -Q "BACKUP DATABASE DocuflowDB TO DISK = N'$bakSementara' WITH INIT, COPY_ONLY, NAME = N'sumber ekspor bacpac'" | Out-Null

# Diekspor dari SALINAN, bukan dari basis data hidup. Dua alasan:
#   1. bacpac divalidasi terhadap aturan Azure SQL Database v12, dan login
#      Windows [IIS APPPOOL\Docflow] yang dipakai Trusted_Connection tidak sah
#      di sana - ekspor langsung gagal dengan SQL71627.
#   2. Users_password_lama berisi hash password LAMA dan tidak boleh ikut ke
#      produksi. Dibuang di salinan saja; mesin uji tetap memegangnya.
$S    = "localhost\SQLEXPRESS"
$sp   = 'C:\dev\sp162\sqlpackage.exe'
if (-not (Test-Path $sp)) { throw "sqlpackage 162 tidak ada di $sp. Yang versi 170 akan menulis model Sql170 yang hanya bisa diimpor ke SQL Server 2025." }
$data = ((sqlcmd -S $S -E -h -1 -W -Q "SET NOCOUNT ON; SELECT CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS nvarchar(400));") -join '').Trim()

sqlcmd -S $S -E -b -Q "IF DB_ID('DocuflowExport') IS NOT NULL BEGIN ALTER DATABASE DocuflowExport SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE DocuflowExport; END;" | Out-Null
sqlcmd -S $S -E -b -Q "RESTORE DATABASE DocuflowExport FROM DISK = N'$bakSementara' WITH MOVE 'DocuflowDB' TO N'$data`DocuflowExport.mdf', MOVE 'DocuflowDB_log' TO N'$data`DocuflowExport_log.ldf', RECOVERY" | Out-Null
sqlcmd -S $S -d DocuflowExport -E -b -Q "IF DATABASE_PRINCIPAL_ID('IIS APPPOOL\Docflow') IS NOT NULL DROP USER [IIS APPPOOL\Docflow]; IF OBJECT_ID('Users_password_lama') IS NOT NULL DROP TABLE Users_password_lama;" | Out-Null

& $sp /Action:Export /SourceServerName:$S /SourceDatabaseName:DocuflowExport /SourceTrustServerCertificate:True /TargetFile:"$dist\basis-data\DocuflowDB.bacpac" 2>&1 |
    Select-String -Pattern "Error|Successfully" | Select-Object -Last 3

sqlcmd -S $S -E -b -Q "ALTER DATABASE DocuflowExport SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE DocuflowExport;" | Out-Null
Remove-Item $bakSementara -Force -ErrorAction SilentlyContinue
if (-not (Test-Path "$dist\basis-data\DocuflowDB.bacpac")) { throw "bacpac tidak terbentuk" }

Write-Host ""
Write-Host "Isi paket:"
Get-ChildItem $dist -Recurse -File |
    Group-Object { $_.Directory.Name } |
    ForEach-Object { "{0,-14} {1,4} berkas  {2,8:N1} MB" -f $_.Name, $_.Count, (($_.Group | Measure-Object Length -Sum).Sum / 1MB) }
