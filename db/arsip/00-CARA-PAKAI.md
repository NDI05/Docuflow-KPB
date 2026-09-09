# Membangun ulang arsip 2026 dari dump sistem lama

Berkas hasilnya — `db/impor-arsip-2026.sql` dan `db/rekonsiliasi-arsip.html` —
**sengaja tidak dilacak git**. Keduanya memuat data pegawai nyata: nama,
jabatan, fungsi/direktorat, nomor pekerja, serial number perangkat, dan
hostname. Yang disimpan di repo adalah perkakas pembangkitnya; datanya dibangun
ulang saat dibutuhkan.

Alasannya sederhana: satu kesalahan setelan visibilitas repo tidak boleh
berarti data pegawai ikut terbuka.

## Bahan

`ba_2026.sql` — dump MariaDB sistem lama. **Tidak ada di repo.** Minta ke
pemilik arsip.

## Langkah

```bash
# 1. Dump MySQL -> JSON
python3 db/arsip/urai.py ~/Downloads/ba_2026.sql /tmp/ba2026.json

# 2. JSON -> skrip impor SQL Server
python3 db/arsip/impor.py /tmp/ba2026.json db/impor-arsip-2026.sql
```

Hasilnya harus 251 surat dan 569 baris barang. Angka lain berarti dump-nya
berbeda dari yang dipakai September 2026 — periksa dulu, jangan langsung
dijalankan.

## Halaman rekonsiliasi

Untuk memeriksa hasil impor kolom per kolom, ekspor isi DB baru sebagai JSON
lebih dulu (lihat `db/paket/buat-paket.ps1` untuk bentuk kueri `FOR JSON PATH`),
simpan sebagai `baru.json` di samping skripnya, lalu:

```bash
python3 db/arsip/banding.py
```

Status tiap kolom **diukur**, bukan diklaim: nilai sumber dicari di seluruh isi
baris hasil. Uji ini pernah menemukan tiga cacat pemetaan nyata yang tidak
terlihat dari membaca kode.

## Kenapa perlu diingat

`impor-arsip-2026.sql` menghapus lalu menulis ulang arsipnya, dan penjaganya
memuat daftar 251 nomor secara tegas. Penjaga versi pertama hanya memeriksa
awalan nomor, dan itu tidak cukup — pada 8 September 2026 penjagaan longgar itu
ikut menghapus BAST 146, dokumen yang baru dibuat operator, dan isinya tidak
bisa dikembalikan.
