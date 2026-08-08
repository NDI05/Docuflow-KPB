# Dokumentasi Docuflow — Sistem Persuratan IT, Kilang Pertamina Balikpapan

Versi 1.0 · Dokumen dipecah per topik.

| Berkas | Isi | Untuk siapa |
|---|---|---|
| `01-PRD.md` | Lingkup produk, peran, alur kerja | Semua pihak |
| `02-PRFAQ.md` | Press release internal + FAQ | Manajemen & sosialisasi |
| `03-ERD.md` | Model data, kamus data, DDL aktual | Developer & DBA |
| `04-Diagram.md` | Diagram konteks, alur login, alur pembuatan surat, deployment | Developer & reviewer |
| `05-Keamanan.md` | Kontrol keamanan yang ada dan yang belum ada | IT Security |
| `06-UI-UX.md` | Kondisi antarmuka saat ini | Developer & UI |
| `07-Status-Implementasi.md` | Apa yang jalan, apa yang belum, utang teknis | Developer |
| `08-Git-Workflow.md` | Alur Mac-edit / VM-run dan deploy | Developer |

## Prinsip dokumen ini

1. **Hanya mencatat yang terverifikasi.** Setiap angka, nama kolom, dan perilaku
   di sini diambil dari kode atau dari query langsung ke `DocuflowDB`, bukan dari
   asumsi. Tanggal verifikasi terakhir: **2026-07-27**.
2. **Yang belum diketahui ditulis sebagai lubang, bukan ditebak.** Bagian yang
   butuh keputusan bisnis diberi tanda **[PERLU KONFIRMASI]**. Dokumen yang
   menebak kebutuhan produk lebih berbahaya daripada dokumen yang mengaku kosong.
3. **Dokumen ini untuk menghemat token.** Agent yang membaca `03-ERD.md` tidak
   perlu membuka 6 file model dan menjalankan query skema. Kalau isinya jadi
   basi, nilainya negatif — perbarui saat struktur berubah.

## Untuk agent

Baca `CLAUDE.md` di root lebih dulu — di sana ada aturan graphify (pakai
`graphify query` sebelum grep) dan seluruh jebakan operasional VM.
