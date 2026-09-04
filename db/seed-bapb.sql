-- =====================================================================
-- Tiga jenis Berita Acara Pengembalian Barang.
--
-- Ketiganya berbagi satu Kode "BAPB". Itu disengaja: CounterNomorSurat
-- di-key pada Kode, jadi satu kode berarti SATU deret nomor untuk seluruh
-- BAPB — persis seperti "Serah Terima Barang" dan "Serah Terima Data CCTV"
-- yang sama-sama BAST. Memberi kode berbeda per jenis akan memulai deret
-- baru dari 001 untuk masing-masing dan melahirkan nomor dokumen kembar.
--
-- Nama jenis BUKAN sekadar label. Services/Bapb.cs mencocokkan kata
-- "Rusak" dan "User" di dalamnya untuk menentukan tata letak cetak dan
-- arah dokumen. Kalau nama di bawah diubah, sesuaikan kelas itu juga.
--
-- Aman dijalankan berulang: tiap baris dijaga IF NOT EXISTS.
--
-- Jalankan di VM:
--   sqlcmd -S localhost\SQLEXPRESS -d DocuflowDB -E -i C:\dev\seed-bapb.sql
-- =====================================================================

SET NOCOUNT ON;

DECLARE @jenis TABLE (Nama nvarchar(400), Kode nvarchar(20));

INSERT INTO @jenis (Nama, Kode) VALUES
    (N'Berita Acara Pengembalian Barang Rusak (IT KPB ke Vendor)', N'BAPB'),
    (N'Berita Acara Pengembalian Barang Sewa (IT KPB ke Vendor)',  N'BAPB'),
    (N'Berita Acara Pengembalian Barang (User ke IT KPB)',         N'BAPB');

INSERT INTO JenisSurat (NamaJenis, Kode)
SELECT j.Nama, j.Kode
FROM @jenis j
WHERE NOT EXISTS (SELECT 1 FROM JenisSurat s WHERE s.NamaJenis = j.Nama);

SELECT Id, Kode, NamaJenis FROM JenisSurat ORDER BY Kode, Id;
