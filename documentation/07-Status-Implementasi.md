# Status Implementasi Docuflow

Diverifikasi 2026-07-27 lewat uji langsung ke `http://<IP-VM>/docflow`
dengan akun seed.

## Jalan dan sudah diuji

| Fitur | Route | Bukti |
|---|---|---|
| Login / logout | `/Account/Login`, `/Account/Logout` | 302 ke `/Home/Index`, BCrypt & plaintext-upgrade keduanya jalan |
| Dashboard | `/Home/Index` | 200 — total user, total surat, surat per jenis, 10 audit log terbaru |
| Daftar surat + pagination | `/Surat/Index?page=n` | 200, 15 baris/halaman, 18 surat → 2 halaman |
| Pencarian surat | `/Surat/Index?search=` | 200, mencari di NomorSurat, NamaJenis, Staff.Nama |
| Detail surat | `/Surat/Details/{id}` | 200 |
| Preview HTML | `/Surat/Preview/{id}` | 200, render `SuratTemplate` |
| **Cetak PDF** | `/Surat/GeneratePdf/{id}` | 200 `application/pdf`, 57 KB — Rotativa + wkhtmltopdf |
| Unduh lampiran | `/Surat/Download/{id}` | 200, PDF dan PNG keduanya terkirim |
| Manajemen user | `/Users/*` | 200 untuk Admin, 302 untuk non-Admin |
| Generate nomor surat | `NomorSuratService` | counter lanjut dari data seed, format benar |

## Belum diimplementasi

- **Edit surat.** Tidak ada action `Edit`/`Update` di `SuratController`. Surat
  yang salah hanya bisa dihapus lalu dibuat ulang — dan nomornya akan berbeda.
- **Edit user.** `UsersController` hanya punya Index, Create, ResetPassword,
  Delete. Nama, peran, dan NPK tidak bisa diubah lewat UI.
- **Halaman registrasi.** Disengaja: user hanya dibuat oleh Admin. Konsekuensinya
  database baru tidak bisa dimasuki sampai satu Admin di-insert manual.
- **Manajemen JenisSurat.** Tidak ada CRUD; baris hanya bisa dibuat lewat SQL.
- **Tanda tangan digital.** Kolom `Users.TtdImagePath` ada tapi tidak dipakai
  view mana pun. `SuratTemplate` hanya mencetak nama.
- **CRUD BarangSurat.** Tabel ada di DbContext dan database, tapi tidak ada
  controller/view. Baris hanya lahir dari `Surat/Create`.

## Utang teknis

| Hal | Dampak | Lokasi |
|---|---|---|
| CI GitHub Actions gagal | Workflow memasang SDK `8.0.x`, project menargetkan `net10.0` | `.github/workflows/dotnet.yml` |
| Counter naik sebelum surat tersimpan | Nomor bisa hilang kalau insert gagal | `SuratController.cs:151` |
| Tidak ada kunci pada generate nomor | Dua submit bersamaan bisa dapat nomor sama | `NomorSuratService.cs:37-56` |
| PenanggungJawab dipilih non-deterministik | `FirstOrDefaultAsync` tanpa `OrderBy` | `SuratController.cs:153` |
| Data PJ ganda (teks + relasi) | Bisa tidak sinkron | `Models/Surat.cs` |
| Semua kolom teks `nvarchar(max)` | Tidak bisa di-index, boros | seluruh model |
| `JenisSurat.Kode` tidak dipakai | Kode diambil dari `NamaJenis` | `NomorSuratService.cs:32` |
| 12 warning nullable saat build | Berisik, menyamarkan warning baru | `SuratController.cs` |

## Catatan lingkungan

- Aplikasi berjalan sebagai `Development`. Kalau nanti dipindah ke `Production`,
  `UseHsts()` aktif dan halaman error diganti `/Home/Error` — perlu diuji ulang.
- Data uji dari `db/seed-testing.sql`. Menjalankan ulang dengan `@Reset = 1`
  menghapus seluruh Surat/BarangSurat/JenisSurat/CounterNomorSurat dan semua user
  kecuali `admin`.
