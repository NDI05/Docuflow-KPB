# UI/UX Docuflow — kondisi saat ini

Catatan ini menggambarkan antarmuka yang **sudah ada**, bukan pedoman desain yang
harus dicapai. Diverifikasi 2026-07-27.

## Fondasi

- Razor Views + Bootstrap + jQuery + jQuery Validation Unobtrusive.
- Dua layout: `_Layout.cshtml` (aplikasi) dan `_LoginLayout.cshtml` (login).
- Aset lokal di `wwwroot/lib`, kecuali `Surat/Create.cshtml` yang menarik jQuery
  dari `code.jquery.com` — **satu-satunya dependensi eksternal saat runtime**.
  Kalau VM tidak punya akses internet, tabel barang dinamis di halaman itu mati.

## Halaman

| Halaman | Catatan |
|---|---|
| `Account/Login` | Dua kolom: panel kiri bergambar, form kanan |
| `Home/Index` | Kartu ringkasan + sebaran surat per jenis + 10 aktivitas terbaru |
| `Surat/Index` | Tabel + kotak cari + pagination 15 baris |
| `Surat/Create` | Terbagi jadi `section-box`: Jenis & Tujuan, Data PJ, Jenis Perangkat, Daftar Barang, Catatan, Tanda Tangan |
| `Surat/Details` | Ringkasan surat + daftar barang + tombol Preview/PDF/Download |
| `Surat/SuratTemplate` | Template cetak berkop, dipakai untuk Preview maupun PDF |
| `Users/Index` | Tabel + cari + pagination 15 baris |
| `Users/Create`, `Users/ResetPassword` | Form sederhana |

## Interaksi yang perlu diketahui

**Pemilih jenis perangkat** di `Surat/Create` mengisi tabel barang otomatis:

- PC → PC, Monitor, VGA, Keyboard, Mouse, Hostname
- Laptop → Notebook, Adaptor, Backpack, Mouse, Ethernet, Chainlock, Hostname
- HT → HT, Charger, Battery, Antenna

Baris juga bisa ditambah manual. Nama input berbentuk array (`NamaBarang[]`,
`SerialNumber[]`, `MerkType[]`, `Pengguna[]`) dan dipasangkan berdasarkan indeks
di controller — jumlah baris yang dipakai adalah **yang terpendek** di antara
keempat array.

## Masalah yang terlihat

1. **Form Create tidak punya `enctype="multipart/form-data"`.** Komentar di view
   menyebut "upload dihapus", tapi `SuratController.Create` masih menerima
   `IFormFile file`. Akibatnya lampiran tidak bisa diunggah lewat UI — jalur
   upload hanya hidup lewat request manual. Ini kemungkinan besar bug, bukan
   keputusan desain.
2. **Nomor urut baris barang tidak dihitung ulang setelah baris dihapus.**
   Variabel `rowNumber` hanya bertambah, jadi kolom "No" bisa melompat.
3. **Tidak ada konfirmasi hapus yang terlihat di server.** Penghapusan surat
   bergantung pada konfirmasi sisi klien saja.
4. **Tanda tangan hanya berupa nama tercetak.** Kolom `TtdImagePath` tersedia di
   tabel `Users` tapi tidak dirender.

## Yang belum diputuskan

- **[PERLU KONFIRMASI]** Rentang usia dan kebiasaan pengguna sasaran. Di project
  tracking-system hal ini dipakai untuk menentukan ukuran huruf dan kepadatan
  tabel; untuk Docuflow belum ada acuan serupa.
- **[PERLU KONFIRMASI]** Apakah aplikasi perlu dipakai dari ponsel. Tata letak
  Bootstrap responsif secara default, tapi tabel barang yang lebar belum diuji di
  layar kecil.
