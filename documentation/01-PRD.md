# PRD Docuflow

> **Peringatan.** Dokumen ini disusun **mundur dari kode yang sudah jadi**, bukan
> dari wawancara kebutuhan. Bagian yang tidak bisa disimpulkan dari kode ditandai
> **[PERLU KONFIRMASI]** dan sengaja dibiarkan kosong daripada ditebak.

## Masalah yang diselesaikan

Fungsi IT Kilang Pertamina Balikpapan menerbitkan berita acara setiap kali
perangkat berpindah tangan — penyerahan, serah terima, pengembalian, peminjaman,
penghapusan. Sebelum ada sistem ini, penomoran dan pengetikan surat dilakukan
manual, sehingga rawan nomor ganda dan format tidak seragam.

Docuflow memusatkan tiga hal: penomoran otomatis per jenis surat per tahun,
pengisian data barang secara terstruktur, dan pencetakan PDF dengan template
resmi.

## Pengguna

| Peran | Yang bisa dilakukan (kondisi kode saat ini) |
|---|---|
| **Admin** | Semua fitur surat + kelola user (tambah, reset password, hapus) |
| **Manager** | Semua fitur surat. Namanya muncul sebagai penanda tangan "Mengetahui" |
| **Staff** | Semua fitur surat. Namanya muncul sebagai penanda tangan pembuat |
| **PenanggungJawab** | Semua fitur surat. Dipilih otomatis oleh sistem saat surat dibuat |

Perlu dicatat: pembedaan hak akses di atas **hanya berlaku untuk menu user**.
Untuk surat, keempat peran punya akses identik — termasuk menghapus. Lihat
`05-Keamanan.md` §2.

## Lingkup yang sudah jadi

1. Login berbasis akun internal aplikasi (bukan Active Directory).
2. Penomoran otomatis: `{KODE} {NNN}/KPB2340/{tahun}/S0`.
3. Pembuatan surat dengan daftar barang dinamis, dengan template isian cepat
   untuk PC, Laptop, dan HT.
4. Lampiran berkas opsional per surat.
5. Cetak PDF dan pratinjau HTML dengan template resmi berkop.
6. Dashboard: jumlah user, jumlah surat, sebaran per jenis, 10 aktivitas terbaru.
7. Audit log untuk login, logout, pembuatan nomor, dan penghapusan surat.

## Di luar lingkup saat ini

Bukan karena diputuskan tidak perlu, melainkan **belum dibuat** — lihat
`07-Status-Implementasi.md`: edit surat, edit user, CRUD jenis surat, tanda
tangan digital, alur persetujuan berjenjang, notifikasi.

## Yang belum bisa dipastikan dari kode

- **[PERLU KONFIRMASI]** Siapa pemilik proses resmi penomoran surat — apakah
  nomor dari sistem ini sudah diakui sebagai nomor agenda resmi, atau masih perlu
  dicatat ulang di sistem persuratan korporat.
- **[PERLU KONFIRMASI]** Apakah `KPB2340` dan `S0` pada format nomor bersifat
  tetap selamanya, atau bisa berubah per unit/tahun. Saat ini keduanya
  di-hardcode di `NomorSuratService.cs:59-60`.
- **[PERLU KONFIRMASI]** Apakah surat perlu status (draft / disetujui / batal).
  Saat ini surat langsung final begitu dibuat.
- **[PERLU KONFIRMASI]** Berapa lama surat dan lampiran harus disimpan, dan
  apakah ada kewajiban retensi/arsip.
- **[PERLU KONFIRMASI]** Target jumlah pengguna dan surat per tahun — menentukan
  apakah utang teknis soal index dan `nvarchar(max)` perlu dibayar sekarang.
