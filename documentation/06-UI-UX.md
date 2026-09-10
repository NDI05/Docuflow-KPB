# UI/UX Docuflow — kondisi saat ini

Menggambarkan antarmuka yang **sudah ada**, bukan pedoman desain yang harus
dicapai. Diverifikasi **2026-09-09**.

## Fondasi

- Razor Views + Bootstrap 5.3.3.
- **Sistem desainnya `wwwroot/css/docuflow.css`** — token warna, jarak, dan
  komponen. Dimuat sesudah Bootstrap dan menimpanya lewat CSS variable milik
  Bootstrap sendiri, jadi markup `form-control` / `btn` / `row` yang sudah ada
  tetap bekerja.
- **Tidak ada aset dari internet.** Bootstrap, webfont Supreme, dan seluruh ikon
  disajikan dari `wwwroot`; ikonnya inline SVG, tidak ada icon font. Jaringan
  kilang tertutup — satu tautan CDN membuat halaman itu rusak di sana tanpa
  terlihat dari mesin pengembangan.
- **Tidak ada JavaScript pihak ketiga sama sekali.** Tabel barang dan poin
  laporan ditulis dengan JS biasa, tanpa jQuery.
  `_ValidationScriptsPartial.cshtml` tidak dirender di mana pun, jadi
  **tidak ada validasi sisi klien** — seluruh validasi di server.
- Satu layout aplikasi (`_Layout.cshtml`). Halaman login berdiri sendiri dengan
  `Layout = null`.

## Halaman

| Halaman | Catatan |
|---|---|
| `Account/Login` | Berdiri sendiri. Badge versi tampil di bawah, sebelum login |
| `Home/Index` | Bercabang menurut peran: Super Admin melihat jejak audit, Admin melihat grafik surat |
| `Surat/Index` | Tabel + cari + saring jenis/tahun + urutkan + paginasi 15 baris. Label jenis berwarna (`RonaJenis`) |
| `Surat/Create` | **Satu formulir untuk Buat dan Ubah**, dibedakan `Model.Id > 0` |
| `Surat/Details` | Ringkasan + barang/poin + tombol Ubah, Pratinjau, Cetak PDF, Unduh |
| `Surat/UnggahBalp` | Unggah berkas vendor + tanggal pada surat itu |
| `Surat/SuratTemplate*` | Tiga template cetak, dipakai Pratinjau maupun PDF |
| `Spd/Index`, `Spd/Create` | Rekap dan formulir SPD |
| `Users/*` | Index, Create, Edit, ResetPassword — hanya Super Admin |

## Interaksi yang perlu diketahui

### Formulir surat menyesuaikan diri

`pilihBagian()` menampilkan atau menyembunyikan bagian menurut jenis yang
dipilih. Tiga hal yang mudah salah:

1. **Bagian yang disembunyikan juga dikosongkan.** Kalau tidak, operator yang
   sempat mengisi lalu berpindah jenis akan menyimpan nilai yang tidak pernah
   tercetak.
2. **`required` ikut dilepas saat sebuah input disembunyikan.** Peramban menolak
   mengirim formulir yang memuat kontrol wajib tersembunyi dan hanya mencatat
   "not focusable" di konsol — tombol Simpan tampak mati tanpa penjelasan.
3. **`nomoriBagian()` harus jadi panggilan terakhir.** Ia menomori ulang bagian
   yang tampak; dipanggil lebih awal, ia membaca flag `hidden` yang belum
   disetel baris di bawahnya dan penomorannya berlubang (01, 02, 03, **05**).

### Satu tabel barang, tiga bentuk

Kolom disembunyikan lewat kelas varian pada tabel (`barang--bast`,
`barang--cctv`, `barang--bapb`). **Kelas pada `<th>` dan `<td>` harus sama** —
kalau tidak, judul kolom tetap terlihat di atas sel yang disembunyikan. Itu
pernah terjadi di sini.

Kelas kolomnya menamai **isi**, bukan varian (`k-nama`, `k-alat`, `k-waktu`, …),
karena beberapa kolom dipakai lebih dari satu varian. Urutan kolom di DOM
dipilih supaya satu urutan menghasilkan susunan yang benar untuk ketiga varian
setelah penyembunyian — menambah kolom berarti memeriksa ketiganya, bukan hanya
milik sendiri.

Setiap baris tetap mengirim **seluruh** array kolom, termasuk yang sedang
disembunyikan; controller memasangkannya menurut indeks, jadi array yang
panjangnya berbeda akan menggeser data satu baris ke baris lain.

### Poin laporan

Daftar bertingkat dengan tombol panah untuk menaik-turunkan level. Penomoran
1 / 1.1 / 1.1.1 dihitung ulang dari seluruh daftar setiap ada perubahan dan
tidak pernah disimpan.

Gambar diunggah per baris dengan nama `Gambar_<kunci>`, memakai kunci acak dari
sisi klien — **bukan indeks**, supaya menghapus satu baris tidak memindahkan
gambar milik baris lain. Saat mengubah, gambar yang sudah ada tampil sebagai
thumbnail dengan tombol silang; yang dibiarkan dikirim balik lewat input
tersembunyi.

### Pencarian kota pada SPD

`<input list>` + `<datalist>` berisi 514 pilihan — fitur bawaan peramban, tanpa
JS dan tanpa pustaka. Yang harus diingat: **datalist mengirim teks yang diketik,
bukan id**, jadi `SpdController.Create` mencocokkan teksnya ke tabel `Kota` dan
menolak yang tidak cocok. Itu pemeriksaan batas kepercayaan, bukan kenyamanan.

## Cetak

Ketiga template memakai Arial 12px, `line-height` 1.5, `letter-spacing`
0.09em, dan logo `/images/kpb-logo.png`.

**`letter-spacing` bukan hiasan.** wkhtmltopdf membulatkan lebar tiap huruf ke
bawah saat menggambar teks ke PDF, jadi hasil cetaknya jauh lebih rapat daripada
pratinjau peramban — huruf tampak menempel. Diukur: sel tanggal tanda tangan
selebar 25% (154,4px) memuat "Balikpapan, 07 September 2026" yang pada metrik
Arial asli butuh 157,3px, dan tetap muat satu baris. Selisih itulah kerapatan
yang dikeluhkan.

Empat blok **dikecualikan ke 0.03–0.04em** karena ruangnya pas-pasan dan pada
0.09em isinya pecah dua baris: alamat pada kop BAST/BA, seluruh blok tanda
tangan (lebar selnya tetap 25% / 33% / 50%), kop `Kepada`/`Dari` pada BAPB, dan
tanggal di baris Catatan BAPB. Tanggal tanda tangan juga `white-space: nowrap`
— bentuknya baku dan tidak boleh terbelah. Batas terukur per blok:

| Blok | Ruang | Sisa pada 0 | Maks `letter-spacing` |
|---|---|---|---|
| Alamat kop baris 1 | 249,6px | 28,8px | 0,064em |
| Sel tanggal ttd (25%) | 154,4px | −2,9px | ~0 |
| "Yang Bertanggung Jawab" | 154,4px | 27,7px | 0,115em |
| Nomor di kotak kop | 190,0px | 43,2px | 0,164em |
| Judul surat | 657,6px | 375,2px | 0,838em |

Menaikkan angka global di atas 0.09em berarti melebarkan sel-sel itu dulu, bukan
sekadar mengganti satu nilai.

**CSS bawaannya adalah bentuk cetak.** Hiasan layar — latar abu, bayangan, jarak
di sekeliling kertas — dirender terpisah dan hanya saat bukan mencetak. Sebelum
dipisahkan, ketiganya ikut masuk PDF dan hasilnya tampak seperti hasil pindai:
bidang abu satu halaman penuh dengan lembar putih bergaris bayangan di tengah.

Hasil cetak diukur, bukan dilihat sekilas: A4, margin 18mm kiri-kanan dan 20mm
atas, kertas putih penuh sampai tepi.

## Masalah yang tersisa

1. **Tanda tangan hanya nama tercetak.** Kolom `Users.TtdImagePath` ada tapi
   tidak dirender view mana pun.
2. **Konfirmasi hapus hanya di sisi klien.** `onsubmit="return confirm(...)"`;
   server tidak meminta konfirmasi kedua.
3. **Tabel barang lebar belum diuji di layar kecil.** Bootstrap responsif secara
   bawaan, tapi tabel dengan sebelas kolom belum diperiksa di ponsel.

## Yang belum diputuskan

- **[PERLU KONFIRMASI]** Apakah aplikasi perlu dipakai dari ponsel. Kalau ya,
  tabel barang butuh perlakuan tersendiri.
- **[PERLU KONFIRMASI]** Apakah tanda tangan gambar jadi dipakai. Kolomnya sudah
  ada sejak awal tapi tidak pernah diminta.

## Sudah selesai

Tiga masalah yang tercatat pada versi Juli 2026 sudah tidak berlaku:

| | |
|---|---|
| jQuery ditarik dari `code.jquery.com` | Dihapus — tidak ada JS pihak ketiga lagi |
| Formulir tanpa `enctype="multipart/form-data"` | Sudah ada; lampiran bisa diunggah lewat UI |
| Nomor baris barang melompat setelah hapus | Dihitung ulang dari posisi baris, bukan dari penghitung yang hanya naik |
