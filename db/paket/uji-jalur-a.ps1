$ErrorActionPreference = "Stop"
$S = "localhost\SQLEXPRESS"
sqlcmd -S $S -E -b -Q "IF DB_ID('DocuflowUjiProd') IS NOT NULL BEGIN ALTER DATABASE DocuflowUjiProd SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE DocuflowUjiProd; END; CREATE DATABASE DocuflowUjiProd;" | Out-Null
foreach ($f in @("01-skema","02-data-inti","03-kota","04-arsip-2026")) {
    $out = sqlcmd -S $S -d DocuflowUjiProd -E -b -i "C:\dev\dist\sql\$f.sql" 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "GAGAL $f :"
        $out | Select-String -Pattern "Msg |Invalid|Incorrect" | Select-Object -First 3
        exit 1
    }
    Write-Host "OK   $f"
}
sqlcmd -S $S -d DocuflowUjiProd -E -h -1 -W -Q "SET NOCOUNT ON; SELECT 'Surat=' + CAST(COUNT(*) AS varchar) FROM Surat; SELECT 'Barang=' + CAST(COUNT(*) AS varchar) FROM BarangSurat; SELECT 'Users=' + CAST(COUNT(*) AS varchar) FROM Users; SELECT 'JenisSurat=' + CAST(COUNT(*) AS varchar) FROM JenisSurat; SELECT 'Kota=' + CAST(COUNT(*) AS varchar) FROM Kota; SELECT 'Counter ' + Kode + '=' + CAST(NomorTerakhir AS varchar) FROM CounterNomorSurat ORDER BY Kode;"
sqlcmd -S $S -E -b -Q "ALTER DATABASE DocuflowUjiProd SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE DocuflowUjiProd;" | Out-Null
Write-Host "basis data uji dihapus"
