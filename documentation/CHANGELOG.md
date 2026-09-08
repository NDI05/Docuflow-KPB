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

## 1.0.0 — 2026-09-08

Rilis produksi pertama. Yang diserahkan ke tim IT: hasil publish Release,
skrip basis data, dan cadangan penuh.

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
