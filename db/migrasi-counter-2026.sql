-- =====================================================================
-- Melanjutkan deret nomor surat dari sistem lama (MariaDB `ba_2026`).
--
-- Sumber angka: dump ba_2026.sql, diekspor 7 September 2026. Nilai di bawah
-- adalah NOMOR TERAKHIR YANG TERPAKAI di tiap deret, bukan nomor berikutnya.
--
-- KENAPA "terakhir terpakai", bukan AUTO_INCREMENT dari dump:
--   CounterNomorSurat.NomorTerakhir menyimpan nomor TERAKHIR; NomorSuratService
--   menaikkannya lebih dulu baru mencetak. AUTO_INCREMENT MySQL menyimpan
--   nomor BERIKUTNYA. Menyalin AUTO_INCREMENT apa adanya membakar satu nomor
--   di setiap deret.
--
-- KENAPA BUKAN jumlah baris:
--   BAST punya 140 baris tapi nomor terakhirnya 145 — lima nomor (11, 12, 58,
--   63, 67) barisnya sudah dihapus, tapi nomornya SUDAH TERBIT dan suratnya
--   ada di kertas. Menyetel dari COUNT(*) akan menerbitkan ulang 141 sampai
--   145. Dipastikan tiga arah: MAX() hasil parsing, AUTO_INCREMENT=146 di
--   dump, dan himpunan nomor yang bolong.
--
-- Deret yang TIDAK dimigrasikan, karena belum punya rumah di Docuflow:
--   BAKP  terakhir 8   — jenisnya sengaja belum dibuat, format dokumennya
--                        belum ditentukan
--   BAPP  terakhir 5   — tidak ada padanannya sama sekali. Kolom kuncinya
--                        bernama No_BAST dan strukturnya sama persis dengan
--                        BAST, tapi deretnya TERPISAH: BAPP 1..5 dan BAST 1..5
--                        adalah sepuluh dokumen berbeda. Jangan pernah
--                        digabung.
--   SPD                — modul baru, tidak ada di sistem lama, mulai dari 0.
--
-- UPSERT, bukan INSERT: baris (Kode, Tahun) mungkin sudah ada, dan index
-- uniknya akan menolak INSERT buta. Counter juga tidak pernah DITURUNKAN —
-- menurunkannya berarti menerbitkan ulang nomor yang sudah dipakai.
--
-- Jalankan di VM:
--   sqlcmd -S localhost\SQLEXPRESS -d DocuflowDB -E -i C:\dev\docuflow\db\migrasi-counter-2026.sql
-- =====================================================================

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @tahun int = 2026;

DECLARE @lama TABLE (Kode nvarchar(20), Terakhir int);
INSERT INTO @lama (Kode, Terakhir) VALUES
    (N'BAST', 145),
    (N'BAPB',  96),
    (N'BALP',  15),
    (N'BA',     1);

PRINT '=== sebelum ===';
SELECT Kode, Tahun, NomorTerakhir FROM CounterNomorSurat WHERE Tahun = @tahun ORDER BY Kode;

BEGIN TRANSACTION;

-- Hanya menaikkan. GREATEST tidak ada di SQL Server ini, jadi dijaga lewat
-- syarat WHERE pada UPDATE dan NOT EXISTS pada INSERT.
UPDATE c
SET NomorTerakhir = l.Terakhir
FROM CounterNomorSurat c
JOIN @lama l ON l.Kode = c.Kode
WHERE c.Tahun = @tahun
  AND c.NomorTerakhir < l.Terakhir;

INSERT INTO CounterNomorSurat (Kode, Tahun, NomorTerakhir)
SELECT l.Kode, @tahun, l.Terakhir
FROM @lama l
WHERE NOT EXISTS (
    SELECT 1 FROM CounterNomorSurat c WHERE c.Kode = l.Kode AND c.Tahun = @tahun
);

COMMIT;

PRINT '=== sesudah ===';
SELECT c.Kode, c.Tahun, c.NomorTerakhir,
       CASE WHEN l.Terakhir IS NULL THEN N'(tidak dimigrasikan)'
            WHEN c.NomorTerakhir = l.Terakhir THEN N'cocok dengan sistem lama'
            ELSE N'TIDAK COCOK — periksa' END AS Status
FROM CounterNomorSurat c
LEFT JOIN @lama l ON l.Kode = c.Kode
WHERE c.Tahun = @tahun
ORDER BY c.Kode;
