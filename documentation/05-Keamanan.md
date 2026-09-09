# Keamanan Docuflow — kondisi saat ini

Diverifikasi **2026-09-09** dari kode, dari query index langsung ke
`DocuflowDB`, dan dari uji langsung ke aplikasi yang berjalan.

Dokumen ini **bukan** daftar rekomendasi ideal, melainkan catatan apa yang sudah
ada dan apa yang belum, supaya keputusan diambil sadar.

## Yang sudah ada

| Kontrol | Implementasi |
|---|---|
| Hash password | BCrypt (BCrypt.Net-Next), work factor 11, satu salt per akun |
| Session | `HttpContext.Session`, idle 30 menit, cookie `HttpOnly` + `IsEssential` |
| Proteksi route | `Filters/SessionAuthorizeAttribute` pada `HomeController`, `SuratController`, `SpdController`, `UsersController` |
| Pemisahan peran | `Users/*` hanya `SuperAdmin`; `Surat/*` dan `Spd/*` untuk `Admin` **dan** `SuperAdmin` |
| Anti-CSRF | `[ValidateAntiForgeryToken]` pada seluruh POST: Account 1, Surat 4, Users 4, Spd 2 |
| Jejak audit | `AuditLogs` — Login, Logout, Generate Nomor Surat, Ubah Surat, Hapus Surat, Generate Nomor SPD, Hapus SPD |
| Akses basis data | Windows Authentication (`Trusted_Connection=True`) — tidak ada password di berkas konfigurasi |
| Kunci Data Protection | Disimpan di `C:\ProgramData\Docuflow\keys`, di luar folder publish |
| Penjaga path unggahan | `PathUnggahanSah` memagari nilai `GambarLama_*` dengan regex |
| Penjaga kolom terkunci | `Edit` tidak pernah menyalin `NomorSurat`, `JenisSuratId`, `Tanggal` dari form |
| Penjaga jenis dokumen | `TolakKalauBalp` menolak cetak BALP di route, bukan sekadar menyembunyikan tombol |

Tiga penjaga terakhir dibuat karena penyembunyian di UI **bukan** kontrol akses:
form bisa dipalsukan, dan sudah diuji dengan POST yang sengaja memalsukan nomor,
jenis, tanggal, dan path `../../appsettings.json`. Ketiganya ditolak.

## Yang belum ada — dengan dampaknya

### 1. Tidak ada HTTPS

Situs berjalan HTTP polos di IIS port 80. Cookie session dan kredensial login
melintas jaringan dalam bentuk terbaca.

HSTS dan redirect HTTPS ada di `Program.cs` tapi digerbangi setelan `UseHttps`
di `appsettings.json`, dan setelan itu `false`. **Jangan dinyalakan sebelum
binding HTTPS benar-benar terpasang** — HSTS pada situs HTTP polos membuat
browser pengguna memaksa HTTPS secara permanen, dan itu tidak bisa dibatalkan
dari sisi server.

### 2. `Users.Username` tidak punya unique index

Diperiksa langsung: satu-satunya index pada `Users` adalah primary key `Id`.
Duplikasi hanya dicegah di `UsersController.Create`. Insert langsung ke basis
data, atau dua permintaan bersamaan, bisa membuat dua akun dengan username sama
— dan `AccountController` memakai `FirstOrDefault`, jadi yang bisa login selalu
baris pertama.

Bandingkan dengan `CounterNomorSurat (Kode, Tahun)` dan `Kota.Nama` yang sudah
unik. Perbaikannya satu migration.

### 3. Lampiran bisa diambil tanpa login

`wwwroot/uploads` disajikan sebagai static files. Diuji: mengambil berkas di
sana **tanpa sesi sama sekali** membalas **200**.

Nama berkasnya memang panjang dan acak (`timestamp_guid_nama`), jadi tidak bisa
ditebak — tapi satu tautan yang bocor berarti berkasnya terbuka selamanya.
Perbaikan yang benar: pindahkan folder unggahan ke luar `wwwroot` dan sajikan
lewat action yang memeriksa sesi.

### 4. Unggahan tidak divalidasi

`SimpanBerkas` menerima `IFormFile` apa pun: tanpa batas ukuran, tanpa daftar
putih ekstensi, tanpa pemeriksaan tipe isi. Nama berkasnya aman dari path
traversal (`Path.GetFileName` + awalan timestamp dan GUID), tapi isinya tidak
diperiksa sama sekali.

### 5. Tidak ada pembatasan percobaan login

Tidak ada rate limit, lockout, maupun jeda. Penebakan password hanya terhambat
waktu hash BCrypt.

### 6. Password teks biasa masih diterima

`AccountController` sengaja menerima password teks biasa bila nilai tersimpan
tidak diawali `$2`, lalu menaikkannya jadi BCrypt setelah login pertama
berhasil. Praktis untuk penyisipan akun awal, tapi berarti kolom password bisa
memuat teks biasa selama akun itu belum pernah dipakai login.

### 7. Reset password tidak tercatat

Super Admin bisa mereset password akun mana pun tanpa konfirmasi kedua dan tanpa
pemberitahuan ke pemiliknya. Aksi ini **tidak masuk `AuditLogs`** — yang tercatat
hanya tujuh aktivitas di tabel atas.

### 8. Recovery model `SIMPLE`

Mesin uji tidak punya pemulihan ke titik waktu. Pada 8 September 2026 satu
dokumen terhapus dan **tidak bisa dikembalikan** karena hal ini. Untuk produksi
sebaiknya `FULL` dengan cadangan log berkala.

## Data pribadi

Arsip 2026 memuat data pegawai nyata: nama, jabatan, fungsi/direktorat, nomor
pekerja, serial number perangkat, hostname.

- `db/impor-arsip-2026.sql` dan `db/rekonsiliasi-arsip.html` **dikeluarkan dari
  git** (2026-09-09) dan dibangun ulang lewat `db/arsip/` saat dibutuhkan.
- **Riwayat commit lama masih memuat keduanya.** Repo karena itu wajib tetap
  **private**. Menghapusnya dari riwayat butuh penulisan ulang yang mengubah
  seluruh SHA, dan belum dikerjakan.
- Ekspor `.bacpac` untuk penyerahan **tidak** memuat tabel `Users_password_lama`
  maupun pengguna basis data `[IIS APPPOOL\Docflow]`; keduanya dibuang di salinan
  sebelum ekspor.

## Urutan perbaikan yang masuk akal

1. **Unique index pada `Users.Username`** — satu migration, menutup celah nyata.
2. **Pindahkan `uploads` keluar dari `wwwroot`** dan sajikan lewat action
   ber-sesi.
3. **Validasi ekstensi dan ukuran unggahan.**
4. **Catat reset password di `AuditLogs`.**
5. **HTTPS** sebelum dipakai lintas jaringan kantor.
6. **Rate limiting login** — `AddRateLimiter` sudah tersedia di ASP.NET Core.
7. **Recovery model `FULL`** di produksi.
