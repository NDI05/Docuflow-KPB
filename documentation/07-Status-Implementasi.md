# Status Implementasi Docuflow

Diverifikasi **2026-09-09** lewat uji langsung ke `http://<IP-VM>/docflow` pada
build net8.0 versi 1.0.0, dan lewat query langsung ke `DocuflowDB`.

## Jalan dan sudah diuji

| Fitur | Route | Bukti |
|---|---|---|
| Login / logout | `/Account/Login`, `/Account/Logout` | 302 ke `/Home/Index`; BCrypt, dan password teks biasa otomatis dinaikkan jadi BCrypt saat login pertama |
| Dashboard | `/Home/Index` | 200 — bercabang menurut peran: Super Admin melihat jejak audit, Admin melihat grafik surat |
| Arsip + paginasi | `/Surat/Index?page=n` | 200, 15 baris/halaman, 251 dokumen |
| Cari, saring, urutkan | `/Surat/Index?search=&jenis=&tahun=&sort=&dir=` | 200; kolom pengurut lewat daftar putih |
| Detail | `/Surat/Details/{id}` | 200 |
| **Buat** | `/Surat/Create` | 200; nomor terbit dalam satu transaksi bersama simpan |
| **Ubah** | `/Surat/Edit/{id}` | 200; memakai kembali `Create.cshtml` |
| Pratinjau HTML | `/Surat/Preview/{id}` | 200 |
| **Cetak PDF** | `/Surat/GeneratePdf/{id}` | 200 `application/pdf`; diukur: A4, margin 18/18/20mm, kertas putih penuh |
| Unduh lampiran | `/Surat/Download/{id}` | 200 |
| Unggah berkas BALP | `/Surat/UnggahBalp/{id}` | 302 ke Details, `FilePath` + `TanggalBalp` tersimpan, `Download` 200 `application/pdf`; berkas lama dihapus saat diganti |
| Hapus | `POST /Surat/Delete` | 302; gambar poin ikut dihapus dari disk |
| **SPD** | `/Spd/Index`, `/Spd/Create` | 200; deret nomor sendiri, 514 kota bisa dicari |
| Manajemen user | `/Users/*` | 200 untuk SuperAdmin, 302 untuk Admin |
| **Ubah user** | `/Users/Edit/{id}` | 200; `Password` sengaja tidak disentuh — itu milik `ResetPassword` |
| Penomoran bersamaan | `db/test-nomor-concurrent.sh 20` | 20 pengiriman serentak, nol nomor kembar |
| Angka jadi huruf | `db/test-terbilang.sh` | kaidah "sepuluh", "sebelas", "seratus", "seribu" |
| **Cetak maksimal 2 halaman** | render seluruh 236 dokumen yang bisa dicetak | 96 satu halaman, 140 dua halaman, nol lebih dari dua |
| Pasang dari nol | `db/paket/uji-jalur-a.ps1` | basis data kosong → 251 surat, 569 barang, 10 pengguna, 514 kota, counter benar |

### Penjagaan yang diuji, bukan diasumsikan

| Penjagaan | Cara diuji | Hasil |
|---|---|---|
| BALP tidak bisa dicetak | `GET /Surat/Preview` dan `/GeneratePdf` | 302 ke Details, bukan dokumen berlayout BAST |
| Nomor/jenis/tanggal terkunci saat Ubah | POST memalsukan ketiganya | ketiganya diabaikan, nilai asli utuh |
| Path unggahan dari form | POST `GambarLama_p1[]=/uploads/../../appsettings.json` | ditolak; `appsettings.json` terbukti masih ada |
| Skrip impor arsip | baris di luar daftar 251 nomor | skrip berhenti, tidak menghapus apa pun |

## Belum diimplementasi

- **BAKP** (Berita Acara Kemajuan Pekerjaan). Diminta bersamaan dengan BALP,
  tapi format dokumennya belum ditentukan. Jenis yang bisa dipilih tapi tidak
  punya keluaran yang benar lebih buruk daripada tidak ada.
- **BAPP** dari arsip lama. Lima dokumen tanpa padanan; deretnya terpisah dari
  BAST dan tidak boleh digabung.
- **Halaman registrasi.** Disengaja — akun hanya dibuat Super Admin. Akibatnya
  basis data baru tidak bisa dimasuki sampai satu akun disisipkan lewat skrip
  (`sql/02-data-inti.sql` pada paket penyerahan).
- **Manajemen JenisSurat.** Tidak ada CRUD; baris hanya lahir lewat SQL.
- **Tanda tangan digital.** Kolom `Users.TtdImagePath` ada tapi tidak dipakai
  view mana pun. Template hanya mencetak nama dan jabatan.
- **CRUD BarangSurat tersendiri.** Baris hanya lahir dari `Surat/Create` dan
  `Surat/Edit`.
- **Validasi sisi klien.** Tidak ada, dan itu konsekuensi sadar dari larangan
  memuat JavaScript pihak ketiga. Seluruh validasi di server.

## Utang teknis

| Hal | Dampak | Lokasi |
|---|---|---|
| Seluruh kolom teks `nvarchar(max)` | Tidak bisa di-index, boros. `CounterNomorSurat.Kode` sudah dipersempit karena kunci index tidak boleh `max` | seluruh model |
| `Surat.PenanggungJawabId` + navigasinya | Kolom mati sejak 2026-09-03; disisakan supaya penghapusannya tidak butuh migration | `Models/Surat.cs` |
| `Surat.FormatSerahTerima` | Tidak dibaca siapa pun | `Models/Surat.cs` |
| Peringatan nullable saat build | Menyamarkan peringatan baru | `Models/LoginViewModel.cs` dan beberapa controller |
| `db/seed-testing.sql` basi | Masih memakai nama jenis lama dan menaruh `Staff`/`Manager` di kolom `Role`, yang sekarang kolom akses. Menjalankannya menghasilkan user yang bisa login tapi tidak bisa membuka apa pun | `db/seed-testing.sql` |
| `Officer ICS \| PT. KPB` dan `Jr. Officer ICS \| PT. KPB` | Masih tertulis "ICS" padahal jabatan lain sudah diperbaiki jadi "IT". Belum ada yang memakainya, jadi tidak ada nama yang terdampak | `Services/JabatanUser.cs` |

### Sudah lunas

| Hal | Selesai |
|---|---|
| CI GitHub Actions gagal | 2026-09-09 — project turun ke `net8.0`, cocok dengan SDK `8.0.x` yang dipasang workflow |
| Counter naik sebelum surat tersimpan | 2026-08-05 — penerbitan nomor dan simpan dalam satu transaksi |
| Tidak ada kunci saat generate nomor | 2026-08-05 — `UPDLOCK, HOLDLOCK` + index unik `(Kode, Tahun)` |
| PenanggungJawab dipilih non-deterministik | 2026-09-03 — konsepnya dihapus seluruhnya |
| `JenisSurat.Kode` tidak dipakai | 2026-08-06 — kode diambil dari kolomnya, bukan diurai dari nama |
| Edit surat tidak ada | 2026-09-08 |
| Edit user tidak ada | 2026-09-03 |
| Skema tidak bisa dibangun dari nol | 2026-09-08 — `migrationBuilder.Sql` dibungkus `EXEC(N'...')` |

## Catatan lingkungan

- Target **net8.0**, disamakan dengan TrackingSystem supaya cocok dengan server
  produksi Pertamina. Lihat `09-Lingkungan-Produksi.md`.
- Situs berjalan **HTTP polos**. `UseHttps` di `appsettings.json` menyalakan HSTS
  — jangan dinyalakan sebelum binding HTTPS ada, karena HSTS di HTTP polos
  memaksa browser ke HTTPS secara permanen dan tidak bisa dibatalkan dari server.
- Recovery model mesin uji **`SIMPLE`** — tidak ada pemulihan ke titik waktu.
  Itu sebabnya `BAST 146` yang terhapus 2026-09-08 tidak bisa dikembalikan.
  Untuk produksi sebaiknya `FULL` dengan cadangan log berkala.
- Tidak ada migration yang berjalan saat startup. Deploy tidak pernah mengubah
  skema.
