-- Jenis Berita Acara Layak Pakai.
--
-- Docuflow hanya menerbitkan nomornya; suratnya dibuat vendor dan berkas
-- jadinya diunggah kembali sebagai arsip. Karena itu tidak ada templat cetak
-- untuk kode ini — lihat Services/Balp.cs.
--
-- Aman dijalankan berulang.
--
-- Jalankan di VM:
--   sqlcmd -S localhost\SQLEXPRESS -d DocuflowDB -E -i C:\dev\seed-balp.sql

SET NOCOUNT ON;

INSERT INTO JenisSurat (NamaJenis, Kode)
SELECT N'Berita Acara Layak Pakai', N'BALP'
WHERE NOT EXISTS (SELECT 1 FROM JenisSurat WHERE Kode = N'BALP');

SELECT Id, Kode, NamaJenis FROM JenisSurat ORDER BY Kode, Id;
