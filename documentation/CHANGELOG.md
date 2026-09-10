# Riwayat Versi — Docuflow (Sistem Berita Acara Fungsi IT)

Angka versi ditulis di satu tempat: `<Version>` pada
`Docuflow_projectIT-KPB/Docuflow_projectIT-KPB.csproj`. Badge versi di setiap
halaman (`Views/Shared/_Version.cshtml`) membacanya dari assembly, jadi versi
yang tampil selalu versi yang benar-benar di-publish. Menaikkan versi = ubah
baris itu, tambahkan entri di sini, lalu publish ulang. **Setiap publish wajib
menaikkan versi.**

Konvensi ini mengikuti TrackingSystem, sistem sebelah di kilang yang sama,
supaya tim IT membaca versi dengan cara yang sudah mereka kenal.

Riwayat sebelum 1.0.0 tidak dipetakan mundur menjadi nomor versi — sistemnya
belum pernah diserahkan ke produksi, dan riwayat itu sudah utuh di `git log`.

## 1.1.1 — 2026-09-10

Patch: hanya bentuk cetakan, tidak ada perubahan data maupun perilaku.

**Jarak antar huruf**

- Ketiga template kini menyetel `letter-spacing: 0.09em` pada body, plus
  `text-rendering: geometricPrecision`. Sebelumnya tidak menyetelnya sama
  sekali, dan wkhtmltopdf membulatkan lebar tiap huruf ke bawah saat menggambar
  teks ke PDF — hasil cetak jauh lebih rapat daripada pratinjau peramban,
  hurufnya tampak menempel.
- Lima blok dikecualikan ke 0.02–0.04em karena ruangnya pas-pasan dan pada
  0.09em isinya pecah dua baris: alamat kop BAST/BA, seluruh blok tanda tangan
  (lebar selnya tetap 25% / 33% / 50%), kop `Kepada`/`Dari` BAPB, tanggal di
  baris Catatan BAPB, dan lembar ketentuan `.rules`.
- Tanggal tanda tangan dibungkus `white-space: nowrap`. Sel 25% itu selebar
  154,4px sementara "Balikpapan, 07 September 2026" butuh 157,3px pada metrik
  Arial asli — muat hanya karena wkhtmltopdf mencetak lebih rapat, jadi sel itu
  yang pertama pecah kalau spasinya dinaikkan.

**Maksimal dua halaman**

- Surat dicetak bolak-balik, jadi dua halaman adalah batas keras. BAST dan BAST
  CCTV sebelumnya keluar tiga halaman.
- `.paper` tidak lagi punya `min-height` saat mencetak: 297mm menghitung jadi
  1122,52px pada 96 dpi sementara bidang cetak wkhtmltopdf 1122px, jadi lembar
  kedua meleset setengah piksel dan melahirkan halaman ketiga kosong. Nilainya
  dikembalikan di blok `@media screen` supaya lembar di layar tetap setinggi A4.
- Lembar ketentuan halaman 2 dirapatkan (`.rules` 0.02em, `line-height` 1.5,
  jarak butir 6px) karena 0.09em membuat 353 karakter terakhir luber.
- Diuji dengan merender **seluruh 236 dokumen** yang bisa dicetak: 96 satu
  halaman, 140 dua halaman, nol lebih dari dua.
- Batas yang tersisa dan sudah diukur: sisa ruang halaman 1 pada BAST 4,3cm,
  satu baris barang ~30pt, jadi BAST di atas sekitar 6 baris barang akan
  mendorong lembar ketentuan ke halaman ketiga. Dari 140 BAST di arsip,
  terbanyak 3 baris.

## 1.1.0 — 2026-09-10

Minor, bukan patch: yang berubah adalah bunyi setiap dokumen yang dicetak.

**Format tempat-tanggal pada tanda tangan**

- Ketiga template kini memakai satu bentuk: `Balikpapan, 12 Agustus 2026` —
  bulan ditulis penuh. BAST sebelumnya memakai angka (`Balikpapan, 07.09.2026`);
  BA dan BAPB tidak punya baris tempat-tanggal sama sekali.
- Penempatannya mengikuti kotak paling kanan pada tiap ragam, dan itu berbeda
  antar template: BA Survey hanya punya dua kotak sehingga barisnya masuk ke
  Mengetahui, BA Kerusakan tiga sehingga masuk ke Penanggung Jawab, dan BAPB
  selalu di Diterima oleh.
- Diverifikasi pada dokumen sungguhan di keempat jenis yang bisa dicetak.
- Nama bulan datang dari culture `id-ID` di `Program.cs`, bukan tabel yang
  ditulis tangan.

**Logo dan favicon**

- Kertas gaya garis bersudut terlipat, mark Pertamina di dalamnya, bintang
  empat sudut di kanan bawah. Mark Pertamina-nya dipotong dari
  `wwwroot/images/kpb-logo-mark.png` yang sudah ada di repo — bukan digambar
  ulang, karena tiruan logo korporat yang meleset lebih buruk daripada tidak
  memakainya.
- Sebelumnya aplikasi memakai `favicon.ico` bawaan templat ASP.NET, tanpa satu
  pun tag `<link>` yang menunjuknya.
- **Satu logo untuk semua ukuran.** `favicon.ico` memuat enam ukuran (16–256)
  dari gambar yang sama. Versi pertama memakai varian lain untuk 16–48px
  "supaya lebih terbaca" — keputusan yang tidak diminta, dan akibatnya bilah
  tab menampilkan logo yang berbeda dari yang dirancang. Konsekuensi yang
  diterima sadar: delapan garis teksnya setebal 1,6% lebar, jadi pada 16 piksel
  garis-garis itu memang lebur.
- Tag `<link>` dipasang di `_Layout` **dan** di `Login`; halaman masuk memakai
  `Layout = null` jadi tidak mewarisi apa pun.

**Perbaikan**

- Unggah berkas BALP membalas HTTP 500 `UnauthorizedAccessException` karena app
  pool kehilangan izin tulis atas `wwwroot/uploads`. Izin itu dulu disetel
  sekali secara manual; sekarang `deploy.sh` menyetelnya ulang setiap deploy.

## 1.0.0 — 2026-09-09

Rilis produksi pertama. Yang diserahkan ke tim IT: hasil publish Release,
skrip basis data, dan cadangan penuh.

**Menargetkan .NET 8**

- Semula `net10.0`. Diturunkan ke **`net8.0`** dengan EF Core **8.0.11** setelah
  dipastikan server produksi Pertamina hanya punya ASP.NET Core 8 Hosting
  Bundle — kombinasi yang sama persis dengan TrackingSystem, sistem sebelah yang
  sudah berjalan di sana. Dipublish sebagai net10.0, IIS hanya membalas
  HTTP 500.31 tanpa pesan lain.
- Nomor versi tidak dinaikkan: 1.0.0 belum pernah diserahkan ke siapa pun, jadi
  tidak ada dua build berbeda yang beredar dengan angka sama.

**Berita acara**

- Empat kode dokumen dengan delapan jenis: BAST (serah terima barang, serah
  terima data CCTV), BA (kerusakan, survey), BAPB (pengembalian barang rusak /
  sewa ke vendor, dan dari user ke IT), BALP (layak pakai).
- Penomoran aman-konkurensi: `UPDLOCK, HOLDLOCK` di dalam transaksi milik
  pemanggil, ditambah index unik pada `CounterNomorSurat (Kode, Tahun)`. Tanpa
  transaksinya, 11 dari 12 pengiriman bersamaan mendapat nomor yang sama —
  diukur, bukan dikira.
- Tahun pada nomor berganti sendiri saat pergantian tahun; arsip disaring
  menurut tanggal yang tercetak di dokumen, bukan tanggal pembuatan baris,
  supaya arsip dan kertas tidak pernah berbeda tahun.
- Ubah berita acara. `NomorSurat`, jenis, dan tanggal tidak bisa diubah:
  nomor sudah tercetak, kode jenis ada di dalam nomor itu, dan tanggalnya
  menentukan tahun nomor sekaligus tahun arsip.
- Cetak PDF lewat wkhtmltopdf, tata letak mengikuti dokumen aslinya per jenis.

**Sub Pekerjaan Dinas (SPD)**

- Menu, tabel, dan deret nomor sendiri. Sengaja tanpa baris `JenisSurat` supaya
  tidak bisa terpilih di formulir berita acara dan tercetak dengan tata letak
  yang salah.
- Daftar 514 kabupaten/kota. Nama dan provinsi disimpan sebagai teks, bukan
  kunci asing: wilayah bisa dinomori ulang, dan SPD yang sudah terbit tidak
  boleh berubah arti ketika itu terjadi.

**Pengguna dan keamanan**

- Autentikasi sesi dengan password BCrypt. Dua peran bertingkat: `Admin`
  (berita acara + SPD) dan `SuperAdmin` (ditambah manajemen pengguna dan jejak
  audit). Penjagaannya di filter route, bukan di menu.
- Jejak audit untuk penerbitan nomor, perubahan, dan penghapusan.
- Tidak ada halaman pendaftaran. Akun pertama harus disisipkan lewat skrip.

**Data**

- 251 dokumen arsip 2026 diimpor dari sistem lama (MariaDB `ba_2026`):
  BAST 140, BAPB 96, BALP 15. Counter dilanjutkan dari deret lama, bukan
  dimulai ulang, supaya nomor tidak terbit dua kali.
- Rekonsiliasinya terekam di `db/rekonsiliasi-arsip.html`: tiap kolom sumber
  disandingkan dengan hasilnya, dan statusnya diukur — bukan diklaim.

**Catatan pemasangan**

- Aplikasi tidak memuat apa pun dari internet; seluruh aset dari `wwwroot`.
- Tidak ada migration yang berjalan saat startup. Perubahan skema harus
  dijalankan dengan sengaja.
- `wwwroot/uploads` dan folder kunci Data Protection harus bisa ditulisi
  identitas application pool. Langkah lengkapnya di `BACA-DULU.md` pada paket
  penyerahan.
