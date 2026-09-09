# Docuflow v1.0.0 — paket pemasangan produksi

Aplikasi pendataan berita acara Fungsi IT, Kilang Pertamina Balikpapan.
ASP.NET Core (net8.0) + SQL Server, dijalankan di IIS.

Paket ini disiapkan dari server uji `C:\inetpub\docflow` pada 8 September 2026.

**Versi: 1.0.0.** Angkanya tercetak sebagai badge di kanan bawah setiap halaman,
termasuk halaman masuk — jadi versi yang terpasang bisa dipastikan tanpa perlu
punya akun. Nilainya dibaca dari assembly, bukan diketik di halaman, sehingga
tidak bisa berbeda dengan yang benar-benar di-publish. Riwayat tiap versi ada di
`CHANGELOG.md`.

Setiap publish berikutnya **wajib menaikkan versi** — ubah `<Version>` pada
`Docuflow_projectIT-KPB.csproj`, tambahkan entri di `CHANGELOG.md`, lalu publish
ulang. Konvensi ini sama dengan TrackingSystem.

```
app/          hasil publish Release — salin apa adanya ke folder situs
sql/          skrip basis data, dijalankan berurutan (jalur A)
basis-data/   DocuflowDB.bacpac — ekspor skema + data (jalur B)
CHANGELOG.md  riwayat versi
```

---

## 1. Prasyarat di server

| | |
|---|---|
| Windows Server + IIS | dengan modul **ASP.NET Core** |
| **ASP.NET Core 8 Hosting Bundle** | wajib, dan harus versi 8 — bukan 9 atau 10. Tanpa runtime yang cocok IIS membalas 500.19 / 502.5 / 500.31, bukan galat aplikasi. Versi yang sama dipakai TrackingSystem, jadi kemungkinan besar sudah terpasang; pastikan dengan `dotnet --list-runtimes` — harus ada `Microsoft.AspNetCore.App 8.x` |
| SQL Server | lihat catatan versi di bagian 2 |
| Arsitektur | **64-bit**. `wwwroot/Rotativa/wkhtmltopdf.exe` hanya ada versi Windows 64-bit |

Aplikasi ini **hanya jalan di Windows**. Dua hal mengunci itu: `wkhtmltopdf.exe`
untuk mencetak PDF, dan `Trusted_Connection=True` (Windows Authentication) ke
SQL Server.

---

## 2. Basis data — pilih SATU jalur

### Jalur A — jalankan skrip (disarankan)

Berlaku di **semua versi SQL Server 2019 ke atas**. Buat basis data kosong
bernama `DocuflowDB`, lalu jalankan berurutan:

```
sqlcmd -S <SERVER> -d DocuflowDB -E -b -i sql\01-skema.sql
sqlcmd -S <SERVER> -d DocuflowDB -E -b -i sql\02-data-inti.sql
sqlcmd -S <SERVER> -d DocuflowDB -E -b -i sql\03-kota.sql
sqlcmd -S <SERVER> -d DocuflowDB -E -b -i sql\04-arsip-2026.sql
```

| berkas | isi |
|---|---|
| `01-skema.sql` | seluruh tabel, dari EF migrations. Idempoten — aman diulang |
| `02-data-inti.sql` | 8 jenis surat, 10 akun pengguna, counter nomor surat |
| `03-kota.sql` | 514 kabupaten/kota untuk formulir SPD |
| `04-arsip-2026.sql` | 251 berita acara hasil migrasi dari sistem lama (MariaDB `ba_2026`) |

`04-arsip-2026.sql` menolak jalan kalau tabel `Surat` sudah memuat surat di
luar daftar arsipnya. Itu disengaja: skrip ini menulis ulang arsipnya, dan
tanpa penjagaan itu ia pernah menghapus dokumen yang dibuat lewat aplikasi.

### Jalur B — impor bacpac

`basis-data\DocuflowDB.bacpac` berisi skema **dan** data, satu berkas.

```
sqlpackage /Action:Import ^
           /TargetServerName:"<SERVER>" ^
           /TargetDatabaseName:DocuflowDB ^
           /TargetTrustServerCertificate:True ^
           /SourceFile:"...\DocuflowDB.bacpac"
```

Basis data tujuan harus **belum ada** — sqlpackage yang membuatnya.

**Batas versi:** berkas ini ditulis sqlpackage **162.5.57.1** sehingga modelnya
`Sql160DatabaseSchemaProvider`. Artinya masuk ke **SQL Server 2022 (16.x) ke
atas**. Kalau produksi SQL Server 2019 atau lebih lama, pakai jalur A — skrip
`.sql` tidak terikat versi engine sama sekali.

Sumbernya SQL Server 2025 (17.0), jadi ekspornya sengaja memakai sqlpackage 162,
bukan yang 170: yang 170 menulis model `Sql170` dan hanya bisa diimpor kembali
ke SQL Server 2025.

Dua hal sengaja **tidak** ikut di dalamnya: pengguna basis data
`[IIS APPPOOL\Docflow]` (identitas application pool di produksi bernama lain —
lihat bagian hak akses di bawah), dan tabel `Users_password_lama` (jaring
pengaman saat password disetel ulang di mesin uji).

### Hak akses basis data

Aplikasi menyambung sebagai **identitas application pool**, bukan sebagai orang
yang memasang. Identitas itu perlu login sendiri:

```sql
CREATE LOGIN [IIS APPPOOL\Docflow] FROM WINDOWS;
USE DocuflowDB;
CREATE USER [IIS APPPOOL\Docflow] FOR LOGIN [IIS APPPOOL\Docflow];
ALTER ROLE db_datareader ADD MEMBER [IIS APPPOOL\Docflow];
ALTER ROLE db_datawriter ADD MEMBER [IIS APPPOOL\Docflow];
```

`db_datareader` + `db_datawriter` saja, **bukan** `db_owner`: tidak ada satu pun
bagian aplikasi yang mengubah skema saat berjalan.

---

## 3. Aplikasi

1. Salin isi `app\` ke folder situs, misalnya `C:\inetpub\docflow`.
2. Sunting `appsettings.json` — ganti `<SERVER>` pada `DefaultConnection`.
   Biarkan `UseHttps: false` sampai binding HTTPS benar-benar terpasang
   (lihat peringatan di bagian 5).
3. Buat application pool **`Docflow`**:
   - .NET CLR version: **No Managed Code**
   - Enable 32-Bit Applications: **False**
   - Load User Profile: **True**
4. Buat aplikasi/situs yang menunjuk ke folder itu dengan pool `Docflow`.
5. Hak folder:

```
icacls "C:\inetpub\docflow"                /grant "IIS AppPool\Docflow:(OI)(CI)RX"
icacls "C:\inetpub\docflow\wwwroot\uploads" /grant "IIS AppPool\Docflow:(OI)(CI)M"
```

**Hanya `wwwroot\uploads` yang boleh ditulisi.** Proses web yang bisa menimpa
DLL-nya sendiri adalah risiko yang tidak perlu.

6. Buat folder kunci Data Protection dan beri hak tulis ke pool:

```
mkdir C:\ProgramData\Docuflow\keys
icacls "C:\ProgramData\Docuflow\keys" /grant "IIS AppPool\Docflow:(OI)(CI)M"
```

Ini **bukan opsional**. Tanpanya ASP.NET Core menyimpan kunci di memori, dan
setiap daur ulang application pool (idle 20 menit, jadwal harian, atau setiap
deploy) membatalkan semua token antiforgery dan cookie sesi yang sudah terbit.
Gejalanya sulit dilacak: halaman login yang dibuka sebelum daur ulang, saat
dikirim, membalas **400 dengan badan kosong** — pengguna melihat halaman putih.

---

## 4. Akun

Aplikasi ini **tidak punya halaman pendaftaran**. Akun hanya bisa dibuat oleh
Super Admin dari dalam aplikasi, jadi sepuluh baris di `02-data-inti.sql`
adalah satu-satunya pintu masuk pertama.

Password awal untuk **kesepuluh akun** adalah:

```
Pertamina#2026
```

Tersimpan sebagai hash BCrypt (work factor 11), satu salt per akun — jadi
sepuluh hash itu tidak kembar meski passwordnya sama, dan tabel `Users` tidak
mengumumkan bahwa semuanya memakai password yang sama.

**Minta setiap pengguna menggantinya pada hari pertama.** Satu password awal
untuk sepuluh orang aman selama hari pemasangan, tidak lebih. Penggantian lewat
Super Admin: menu Users, tombol Reset Password.

Dua peran, bertingkat bukan terpisah:

| Peran | Jangkauan |
|---|---|
| `Admin` | Berita Acara + SPD |
| `SuperAdmin` | semuanya, termasuk manajemen pengguna dan jejak audit |

---

## 5. Yang harus diperhatikan

- **Jangan setel `UseHttps: true` sebelum HTTPS benar-benar ada.** Setelan itu
  menyalakan HSTS. Di situs HTTP polos, HSTS membuat browser pengguna memaksa
  HTTPS secara permanen — dan itu tidak bisa dibatalkan dari sisi server.
- **Tidak ada migration yang jalan saat startup.** `Program.cs` sengaja tidak
  memanggil `Database.Migrate()`. Perubahan skema di masa depan harus dijalankan
  dengan sengaja, bukan sebagai efek samping deploy.
- **Aplikasi tidak memuat apa pun dari internet.** Bootstrap, font, dan ikon
  semuanya dari `wwwroot`. Aman di jaringan tertutup, dan jangan tambahkan
  tautan CDN.
- **Recovery model.** Server uji memakai `SIMPLE`, artinya tidak ada pemulihan
  ke titik waktu. Untuk produksi sebaiknya `FULL` dengan cadangan log berkala —
  di server uji, satu penghapusan tidak sengaja tidak bisa dibatalkan karena hal
  ini.
- **`wwwroot\uploads` ikut dicadangkan terpisah.** Lampiran dan gambar poin
  tersimpan sebagai berkas di sana, bukan di dalam basis data; mencadangkan
  basis data saja tidak cukup.

---

## 6. Uji setelah pasang

| Langkah | Hasil yang benar |
|---|---|
| Buka `http://<host>/<app>/` | halaman login, HTTP 200, badge **v1.0.0** di bawah |
| Masuk sebagai Super Admin | beranda berisi jejak audit |
| Buka menu Berita Acara | 251 dokumen arsip 2026 terdaftar |
| Buka satu BAST lalu **Cetak PDF** | berkas PDF terbuka, A4, margin ±18mm kiri-kanan |
| Buka menu SPD lalu Buat SPD | daftar kota bisa dicari, 514 pilihan |
| Buat satu berita acara percobaan | nomornya lanjut dari deret yang ada, bukan mulai dari 001 |

Langkah PDF adalah yang paling penting: itu satu-satunya yang membuktikan
`wkhtmltopdf.exe` bisa dijalankan oleh identitas application pool.

Setelah uji, hapus berita acara percobaan itu. Perhatikan nomornya hangus —
counter tidak ikut turun, dan itu memang disengaja.
