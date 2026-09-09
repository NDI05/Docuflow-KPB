# PRD — Docuflow

Diperbarui **2026-09-09**, sesudah rilis 1.0.0.

## Masalah yang diselesaikan

Fungsi IT Kilang Pertamina Balikpapan menerbitkan berita acara setiap kali
perangkat diserahkan, dikembalikan, diperbaiki, atau disurvei. Sebelum Docuflow,
nomor suratnya dikelola di sistem lama berbasis MariaDB, dan dokumennya disusun
manual.

Tiga hal yang paling sering salah pada cara itu:

1. **Nomor kembar.** Dua orang menerbitkan pada waktu berdekatan dan mendapat
   nomor yang sama. Dua dokumen resmi dengan nomor identik tidak bisa dibedakan
   di arsip.
2. **Dokumen tidak seragam.** Tiap orang menyalin berkas lama, dan bentuknya
   perlahan menyimpang antar penyusun.
3. **Arsip sulit ditelusuri.** Mencari satu serah terima berarti membuka folder
   satu per satu.

## Lingkup

### Yang dikerjakan

- Menerbitkan nomor surat berurut per kode dan per tahun, **dijamin tidak
  kembar** meski dua orang menyimpan bersamaan.
- Menyimpan isi dokumen: daftar barang atau poin laporan bertingkat, penanda
  tangan, dasar pemenuhan.
- Mencetak PDF dengan tata letak resmi yang berbeda per jenis.
- Mengarsipkan: cari, saring per jenis dan per tahun, urutkan.
- Mencatat jejak audit atas penerbitan nomor, perubahan, dan penghapusan.
- Mendata **SPD** (Sub Pekerjaan Dinas) dengan deret nomornya sendiri.

### Yang sengaja tidak dikerjakan

| | Alasan |
|---|---|
| Halaman registrasi | Akun hanya dibuat Super Admin. Konsekuensinya basis data baru tidak bisa dimasuki sampai satu akun disisipkan lewat skrip |
| Tanda tangan digital | Belum diminta. Kolomnya ada, tidak dipakai |
| CRUD jenis surat | Menambah jenis hampir selalu berarti menambah aturan cetak di kode; CRUD saja akan menghasilkan jenis yang bisa dipilih tapi tercetak salah |
| Alur persetujuan | Persetujuan terjadi di luar sistem, di atas kertas |
| **Mencetak BALP** | Suratnya dibuat vendor. Docuflow hanya menerbitkan nomor dan mengarsipkan berkasnya kembali |

## Pengguna dan peran

Dua peran, **bertingkat bukan terpisah** (diubah 2026-09-03):

| Peran | Jangkauan |
|---|---|
| `Admin` | Berita Acara + SPD |
| `SuperAdmin` | semuanya, ditambah manajemen pengguna dan jejak audit |

Super Admin adalah superset. Satu-satunya pintu yang tetap searah adalah
`Users/*`.

Penjagaannya di filter route (`SessionAuthorizeAttribute`), bukan di menu.
Menyembunyikan menu bukan kontrol akses; menu hanya disesuaikan supaya tidak
menyesatkan.

**Jabatan terpisah dari peran.** `Role` menjawab "boleh membuka apa";
`Jabatan` menjawab "siapa orang ini" dan ikut tercetak di dokumen. Peran tanda
tangan dihitung dari jabatan, tidak disimpan — menyimpan keduanya membuka
peluang keduanya bertentangan.

## Jenis dokumen

| Kode | Jenis | Isi | Kotak tanda tangan |
|---|---|---|---|
| `BAST` | Serah Terima Barang | tabel barang: nama, serial, merk, pengguna | 4 |
| `BAST` | Serah Terima Data CCTV | tabel rekaman: nama, tanggal, jam, rekaman, area | 3 |
| `BA` | Kerusakan | poin laporan bertingkat + gambar | 3 |
| `BA` | Survey | sama, kop berbeda: logo kanan atas, "TENTANG" | 2 |
| `BAPB` | Pengembalian Barang Rusak (IT → vendor) | tabel 7 kolom | 2 |
| `BAPB` | Pengembalian Barang Sewa (IT → vendor) | jumlah, satuan, serial, merk, keterangan | 3 |
| `BAPB` | Pengembalian Barang (User → IT) | sama, **arah terbalik** | 3 |
| `BALP` | Layak Pakai | — | — |

**Beberapa jenis sengaja berbagi satu kode.** Dua BAST, dua BA, dan tiga BAPB
masing-masing satu deret nomor. Memberi kode sendiri-sendiri akan memulai
masing-masing dari 001 dan menghasilkan nomor dokumen kembar.

Aturan per jenis tinggal di `Services/` — `Bapb`, `Bast`, `Ba`, `Balp` — dan
formulir maupun template memanggil sumber yang sama, supaya label di layar tidak
pernah berbeda dengan yang tercetak.

## Alur kerja

### Menerbitkan berita acara

1. Pilih jenis. Formulir menyesuaikan sendiri: bagian yang tidak berlaku
   disembunyikan **dan dikosongkan**, penomoran bagiannya dihitung ulang supaya
   tidak berlubang.
2. Isi tujuan, penanggung jawab, isi dokumen, penanda tangan.
3. Simpan. **Nomor terbit di dalam transaksi yang sama dengan penyimpanan** —
   kalau simpannya gagal, nomornya ikut batal dan tidak hangus.
4. Pratinjau atau cetak PDF.

### Mengubah

Semua isian bisa diubah, **kecuali tiga**: nomor, jenis, dan tanggal. Nomor
sudah tercetak di kertas; kode jenis ada di dalam nomor itu; tanggal menentukan
tahun nomor sekaligus tahun arsip. Formulir mengunci ketiganya dan controller
menolaknya lagi — form bisa dipalsukan.

### BALP

Berbeda dari yang lain karena dokumennya bukan produk Docuflow:

1. Buat entri BALP → nomor terbit.
2. Nomor diberikan ke vendor; vendor menulis suratnya.
3. Berkas jadi diunggah kembali, beserta tanggal yang tertera padanya.

`TanggalBalp` disimpan terpisah dari `Tanggal`: yang satu tanggal pada surat
vendor, yang satu tanggal terbitnya nomor. Menimpanya akan membuat arsip
mengarsipkan dokumen di tahun yang berbeda dengan yang tertulis pada nomornya.

Preview, cetak, dan unduh-tanpa-berkas **ditolak di route**, bukan sekadar
disembunyikan tombolnya — tanpa itu BALP tercetak memakai tata letak BAST:
dokumen yang tampak resmi tapi bukan yang berlaku.

### SPD

Terpisah dari berita acara: menu sendiri, tabel sendiri, deret nomor sendiri,
dan **sengaja tanpa baris `JenisSurat`**. Menambahkannya akan membuat SPD bisa
dipilih di formulir berita acara dan tercetak dengan tata letak yang salah.

Isian: staff pelaksana, kota tujuan (dari daftar 514 kabupaten/kota), keperluan,
tanggal dinas. Tidak ada unggah dokumen.

## Penomoran

```
BAST 146/KPB3240/2026-S0
 │    │      │      │  └── kode akhir, tetap
 │    │      │      └───── tahun, berganti sendiri
 │    │      └──────────── kode kilang, tetap
 │    └─────────────────── urut per kode per tahun
 └──────────────────────── kode jenis
```

Tanpa `No.` di antara kode dan angkanya. Sistem lama menulis
`BAPB 027/KPB3240/2024-S0`, dan Docuflow melanjutkan deret yang sama —
menyisipkan `No.` akan membuat satu deret berkesinambungan tercetak dalam dua
bentuk, terbelah tepat di titik peralihan.

Arsip 2026 dari sistem lama sudah dimasukkan: **251 dokumen**, dengan counter
dilanjutkan dari deret lama (BAST 145, BAPB 96, BALP 15), bukan dimulai ulang.

## Yang belum dikerjakan

- **BAKP** — diminta, format dokumennya belum ditentukan.
- **BAPP** dari arsip lama — 5 dokumen tanpa padanan, deretnya terpisah dari
  BAST dan tidak boleh digabung.
- **HTTPS** — situs masih HTTP polos.

## Keputusan yang butuh pemilik produk

| | |
|---|---|
| Kapan BAKP dibuat, dan bentuk dokumennya seperti apa | belum dijawab |
| Apakah BAPP perlu rumah sendiri di Docuflow | belum dijawab |
| Apakah jabatan `Officer ICS` dan `Jr. Officer ICS` juga salah ketik seperti dua jabatan lain yang sudah diperbaiki jadi "IT" | belum dijawab |
