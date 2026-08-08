# Keamanan Docuflow — kondisi saat ini

Diverifikasi 2026-07-27 dari kode dan dari uji langsung ke aplikasi yang berjalan.
Dokumen ini **bukan** daftar rekomendasi ideal, melainkan catatan apa yang sudah
ada dan apa yang belum, supaya keputusan diambil sadar.

## Yang sudah ada

| Kontrol | Implementasi |
|---|---|
| Hash password | BCrypt (BCrypt.Net-Next), cost 11 pada data yang ada |
| Session | `HttpContext.Session`, idle timeout 30 menit, cookie `HttpOnly` + `IsEssential` |
| Proteksi route | `Filters/SessionAuthorizeAttribute.cs` pada `HomeController`, `SuratController`, `UsersController` |
| Anti-CSRF | `[ValidateAntiForgeryToken]` pada Login, Users/Create, ResetPassword, Users/Delete, Surat/Create, Surat/Delete |
| Audit trail | Tabel `AuditLogs` — Login, Logout, Generate Nomor Surat, Hapus Surat |
| Akses DB | Windows Authentication (`Trusted_Connection=True`), tanpa password di file konfigurasi |

## Yang belum ada — dengan dampaknya

### 1. Tidak ada HTTPS
Aplikasi hanya listen HTTP di `0.0.0.0:5090`. Cookie session dan kredensial
login lewat jaringan dalam bentuk terbaca. Selama masih di LAN lab ini risikonya
terbatas, tapi **tidak layak dipakai lintas jaringan kantor apa adanya**.

`Program.cs` memanggil `app.UseHttpsRedirection()`, namun karena tidak ada port
HTTPS yang dikonfigurasi, ASP.NET hanya mencatat peringatan dan melewatinya.
Aplikasi dijalankan dengan `ASPNETCORE_ENVIRONMENT=Development` sehingga
`UseHsts()` juga tidak aktif.

### 2. Otorisasi hanya membedakan Admin vs bukan Admin
`SuratController` tidak mengecek peran sama sekali. Artinya siapa pun yang bisa
login — termasuk `Staff` — dapat **menghapus surat milik siapa pun**
(`POST /Surat/Delete/{id}`) dan mengunduh seluruh lampiran. Cek peran hanya ada
di `UsersController` lewat perbandingan string `Session["Role"] == "Admin"`.

### 3. Tidak ada unique constraint pada Username
Duplikasi hanya dicegah di `UsersController.Create`. Insert langsung ke DB, atau
dua request bersamaan, bisa membuat dua user dengan username sama — dan
`AccountController` memakai `FirstOrDefault`, jadi yang login selalu baris
pertama.

### 4. Tidak ada rate limiting pada login
Tidak ada pembatasan percobaan, lockout, atau jeda. Serangan tebak password
tidak menemui hambatan selain waktu hash BCrypt.

### 5. Upload file tidak divalidasi
`SuratController.Create` menerima `IFormFile` apa pun: tanpa batas ukuran, tanpa
whitelist ekstensi, tanpa pemeriksaan tipe. Nama file memakai
`Path.GetFileName` (aman dari path traversal) dan diberi awalan timestamp, tapi
isi file tidak diperiksa. Folder `wwwroot/uploads` disajikan sebagai static
files, sehingga file yang diunggah bisa diakses langsung lewat URL **tanpa
login**.

### 6. Password plaintext masih diterima
`AccountController` sengaja menerima password plaintext yang tersimpan di kolom
`Password` (bila tidak diawali `$2`), lalu meng-upgrade-nya ke BCrypt setelah
login pertama berhasil. Praktis untuk seeding, tapi berarti kolom password bisa
berisi plaintext untuk waktu yang tidak terbatas kalau user tersebut tidak
pernah login.

### 7. Reset password tanpa verifikasi identitas
Admin dapat mereset password user mana pun tanpa konfirmasi kedua dan tanpa
pemberitahuan ke user bersangkutan. Aksi ini juga **tidak tercatat di AuditLogs**
— hanya Login, Logout, Generate Nomor Surat, dan Hapus Surat yang dicatat.

## Paparan jaringan saat ini

Port 5090 dibuka ke seluruh LAN lewat rule firewall `KPB Docuflow 5090` dengan
Profile `Any`. Kalau perlu dipersempit ke Mac saja:

```powershell
Set-NetFirewallRule -DisplayName "KPB Docuflow 5090" -RemoteAddress <IP-KLIEN>
```

Alternatif paling ketat: hapus rule tersebut dan kembali memakai SSH tunnel saja.

## Urutan perbaikan yang masuk akal

1. Cek peran di `SuratController.Delete` — celah terbesar, perbaikannya paling kecil.
2. Unique index pada `Users.Username`.
3. Validasi ekstensi + ukuran upload, dan pindahkan `uploads` keluar dari `wwwroot`
   supaya lampiran tidak bisa diambil tanpa login.
4. HTTPS sebelum dipakai di luar LAN lab.
5. Rate limiting login (`AddRateLimiter` sudah tersedia di ASP.NET Core).
