# Docuflow

Sistem penerbitan dan pengarsipan **berita acara** untuk Fungsi IT, Kilang
Pertamina Balikpapan. Menggantikan sistem lama berbasis MariaDB, dan
melanjutkan deret nomor suratnya — bukan memulai dari awal.

ASP.NET Core MVC (net8.0) · SQL Server · IIS · Windows.

---

## Yang dikerjakannya

**Menerbitkan nomor surat.** Berurut per kode dan per tahun, tidak pernah
kembar meski dua orang menyimpan pada detik yang sama, dan berganti tahun
sendiri saat pergantian tahun.

```
BAST 146/KPB3240/2026-S0
```

**Menyimpan isi dokumennya.** Daftar barang beserta serial number, atau poin
laporan bertingkat dengan gambar, tergantung jenisnya. Ditambah penanda tangan
dan jabatannya.

**Mencetak PDF** dengan tata letak resmi yang berbeda per jenis dokumen.

**Mengarsipkan.** Pencarian, saringan per jenis dan per tahun, jejak audit atas
setiap penerbitan nomor, perubahan, dan penghapusan.

## Jenis dokumen

| Kode | Jenis |
|---|---|
| `BAST` | Serah Terima Barang · Serah Terima Data CCTV |
| `BA` | Kerusakan · Survey |
| `BAPB` | Pengembalian Barang Rusak / Sewa (IT ke vendor) · dari User ke IT |
| `BALP` | Layak Pakai — Docuflow menerbitkan nomornya, vendor menulis suratnya, berkasnya diarsipkan kembali di sini |

**SPD** (Sub Pekerjaan Dinas) berdiri terpisah: menu sendiri, tabel sendiri,
deret nomor sendiri. Bukan berita acara, dan sengaja tidak bisa dipilih di
formulir berita acara.

## Isi arsip

251 dokumen tahun 2026 hasil migrasi dari sistem lama — BAST 140, BAPB 96,
BALP 15 — dengan counter dilanjutkan dari deret lama supaya tidak ada nomor
yang terbit dua kali.

---

## Menjalankan

Mac dipakai untuk menyunting, VM Windows untuk membangun dan menjalankan.
Windows wajib: pencetak PDF-nya (`wkhtmltopdf.exe`) hanya ada untuk Windows,
dan sambungan basis datanya memakai Windows Authentication.

```bash
VM_IP=<alamat-vm> ./deploy.sh
```

Setelan pribadi ada di `.deploy.local` (tidak masuk git). Rinciannya di
[AGENTS.md](AGENTS.md).

## Memasang di produksi

Paket penyerahan dibangun lewat [`db/paket/00-CARA-PAKAI.md`](db/paket/00-CARA-PAKAI.md).
Isinya hasil publish, skrip basis data, ekspor `.bacpac`, dan panduan pemasangan
untuk tim IT.

Dua hal yang menentukan berhasil-tidaknya, keduanya soal lingkungan dan bukan
soal kode:

- server butuh **ASP.NET Core 8 Hosting Bundle** — versi lain membuat IIS
  membalas `HTTP 500.31`;
- `.bacpac`-nya bermodel `Sql160`, jadi masuk ke **SQL Server 2022 ke atas**.
  Untuk versi lebih lama, tersedia jalur skrip `.sql` yang tidak terikat versi.

Rinciannya di [`documentation/09-Lingkungan-Produksi.md`](documentation/09-Lingkungan-Produksi.md).

---

## Dokumentasi

| Berkas | Isi |
|---|---|
| [AGENTS.md](AGENTS.md) | **Mulai dari sini kalau akan melanjutkan develop** |
| [CLAUDE.md](CLAUDE.md) | Rincian operasional dan jebakan per fitur |
| [documentation/](documentation/) | PRD, ERD, diagram, keamanan, status, lingkungan produksi |
| [documentation/CHANGELOG.md](documentation/CHANGELOG.md) | Riwayat versi |

---

## Catatan

Repo ini **private dan harus tetap begitu**. Riwayat commit-nya memuat data
pegawai nyata — nama, jabatan, nomor pekerja, serial number perangkat. Berkas
arsipnya sendiri sudah dikeluarkan dari git dan dibangun ulang lewat
[`db/arsip/`](db/arsip/) saat dibutuhkan.

Aplikasi ini **tidak memuat apa pun dari internet** — Bootstrap, font, dan
seluruh ikon disajikan dari `wwwroot`. Jaringan kilang tertutup; satu tautan CDN
akan merusak halaman di sana tanpa terlihat dari mesin pengembangan.
