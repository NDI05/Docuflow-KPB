-- =====================================================================
-- Impor arsip berita acara dari sistem lama (MariaDB `ba_2026`).
--
-- 251 dokumen: BAST 140, BAPB 96, BALP 15.
-- BAKP (8), BAPP (5) dan BA_Generic (1) SENGAJA tidak diimpor — dua yang
-- pertama jenisnya tidak dibuat, yang terakhir isinya kosong total di sumber
-- sehingga hanya akan mencetak berita acara resmi tanpa isi.
--
-- Nomor surat ditulis APA ADANYA dari arsip lama, termasuk kode unit dan
-- akhiran aslinya (KPB2000, KPB2200-S9). Docuflow menulis KPB3240/S0 sebagai
-- konstanta hanya saat MENERBITKAN nomor baru; arsip harus menunjukkan yang
-- benar-benar tercetak di kertas.
--
-- Counter TIDAK disentuh — sudah dimigrasikan terpisah.
--
-- Menghapus lalu menulis ulang arsipnya. Dijaga di awal: menolak kalau ada
-- SATU pun surat yang nomornya tidak ada di daftar arsip ini.
--
-- Penjaga sebelumnya hanya memeriksa awalan nomor ("BAST %", "BAPB %", ...)
-- dan itu tidak cukup — surat yang dibuat lewat aplikasi juga bernomor
-- "BAST ...". Pada 8 September 2026 penjagaan itu meloloskan penghapusan
-- BAST 146, dokumen yang baru dibuat operator, dan isinya tidak bisa
-- dikembalikan karena database memakai recovery model SIMPLE. Daftar nomor di
-- bawah adalah persis yang akan ditulis ulang; apa pun di luar itu membuat
-- skrip berhenti tanpa menghapus apa-apa.
-- =====================================================================

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @arsip TABLE (Nomor nvarchar(100) PRIMARY KEY);
INSERT INTO @arsip (Nomor) VALUES (N'BALP 001/KPB3240/2026-S0'), (N'BALP 002/KPB3240/2026-S0'), (N'BALP 003/KPB3240/2026-S0'), (N'BALP 004/KPB3240/2026-S0'), (N'BALP 005/KPB3240/2026-S0'), (N'BALP 006/KPB3240/2026-S0'), (N'BALP 007/KPB3240/2026-S0'), (N'BALP 008/KPB3240/2026-S0'), (N'BALP 009/KPB3240/2026-S0'), (N'BALP 010/KPB3240/2026-S0'), (N'BALP 011/KPB3240/2026-S0'), (N'BALP 012/KPB3240/2026-S0'), (N'BALP 013/KPB3240/2026-S0'), (N'BALP 014/KPB3240/2026-S0'), (N'BALP 015/KPB3240/2026-S0'), (N'BAPB 001/KPB3240/2026-S0'), (N'BAPB 002/KPB3240/2026-S0'), (N'BAPB 003/KPB3240/2026-S0'), (N'BAPB 004/KPB3240/2026-S0'), (N'BAPB 005/KPB3240/2026-S0');
INSERT INTO @arsip (Nomor) VALUES (N'BAPB 006/KPB3240/2026-S0'), (N'BAPB 007/KPB3240/2026-S0'), (N'BAPB 008/KPB3240/2026-S0'), (N'BAPB 009/KPB3240/2026-S0'), (N'BAPB 010/KPB3240/2026-S0'), (N'BAPB 011/KPB3240/2026-S0'), (N'BAPB 012/KPB3240/2026-S0'), (N'BAPB 013/KPB3240/2026-S0'), (N'BAPB 014/KPB3240/2026-S0'), (N'BAPB 015/KPB3240/2026-S0'), (N'BAPB 016/KPB3240/2026-S0'), (N'BAPB 017/KPB3240/2026-S0'), (N'BAPB 018/KPB3240/2026-S0'), (N'BAPB 019/KPB3240/2026-S0'), (N'BAPB 020/KPB3240/2026-S0'), (N'BAPB 021/KPB3240/2026-S0'), (N'BAPB 022/KPB3240/2026-S0'), (N'BAPB 023/KPB3240/2026-S0'), (N'BAPB 024/KPB3240/2026-S0'), (N'BAPB 025/KPB3240/2026-S0');
INSERT INTO @arsip (Nomor) VALUES (N'BAPB 026/KPB3240/2026-S0'), (N'BAPB 027/KPB3240/2026-S0'), (N'BAPB 028/KPB3240/2026-S0'), (N'BAPB 029/KPB3240/2026-S0'), (N'BAPB 030/KPB3240/2026-S0'), (N'BAPB 031/KPB3240/2026-S0'), (N'BAPB 032/KPB3240/2026-S0'), (N'BAPB 033/KPB3240/2026-S0'), (N'BAPB 034/KPB3240/2026-S0'), (N'BAPB 035/KPB3240/2026-S0'), (N'BAPB 036/KPB3240/2026-S0'), (N'BAPB 037/KPB3240/2026-S0'), (N'BAPB 038/KPB3240/2026-S0'), (N'BAPB 039/KPB3240/2026-S0'), (N'BAPB 040/KPB3240/2026-S0'), (N'BAPB 041/KPB3240/2026-S0'), (N'BAPB 042/KPB3240/2026-S0'), (N'BAPB 043/KPB3240/2026-S0'), (N'BAPB 044/KPB3240/2026-S0'), (N'BAPB 045/KPB3240/2026-S0');
INSERT INTO @arsip (Nomor) VALUES (N'BAPB 046/KPB3240/2026-S0'), (N'BAPB 047/KPB3240/2026-S0'), (N'BAPB 048/KPB3240/2026-S0'), (N'BAPB 049/KPB3240/2026-S0'), (N'BAPB 050/KPB3240/2026-S0'), (N'BAPB 051/KPB3240/2026-S0'), (N'BAPB 052/KPB3240/2026-S0'), (N'BAPB 053/KPB3240/2026-S0'), (N'BAPB 054/KPB3240/2026-S0'), (N'BAPB 055/KPB3240/2026-S0'), (N'BAPB 056/KPB3240/2026-S0'), (N'BAPB 057/KPB3240/2026-S0'), (N'BAPB 058/KPB3240/2026-S0'), (N'BAPB 059/KPB3240/2026-S0'), (N'BAPB 060/KPB3240/2026-S0'), (N'BAPB 061/KPB3240/2026-S0'), (N'BAPB 062/KPB3240/2026-S0'), (N'BAPB 063/KPB3240/2026-S0'), (N'BAPB 064/KPB3240/2026-S0'), (N'BAPB 065/KPB3240/2026-S0');
INSERT INTO @arsip (Nomor) VALUES (N'BAPB 066/KPB3240/2026-S0'), (N'BAPB 067/KPB3240/2026-S0'), (N'BAPB 068/KPB3240/2026-S0'), (N'BAPB 069/KPB3240/2026-S0'), (N'BAPB 070/KPB3240/2026-S0'), (N'BAPB 071/KPB3240/2026-S0'), (N'BAPB 072/KPB3240/2026-S0'), (N'BAPB 073/KPB3240/2026-S0'), (N'BAPB 074/KPB3240/2026-S0'), (N'BAPB 075/KPB3240/2026-S0'), (N'BAPB 076/KPB3240/2026-S0'), (N'BAPB 077/KPB3240/2026-S0'), (N'BAPB 078/KPB3240/2026-S0'), (N'BAPB 079/KPB3240/2026-S0'), (N'BAPB 080/KPB3240/2026-S0'), (N'BAPB 081/KPB3240/2026-S0'), (N'BAPB 082/KPB3240/2026-S0'), (N'BAPB 083/KPB3240/2026-S0'), (N'BAPB 084/KPB3240/2026-S0'), (N'BAPB 085/KPB3240/2026-S0');
INSERT INTO @arsip (Nomor) VALUES (N'BAPB 086/KPB3240/2026-S0'), (N'BAPB 087/KPB3240/2026-S0'), (N'BAPB 088/KPB3240/2026-S0'), (N'BAPB 089/KPB3240/2026-S0'), (N'BAPB 090/KPB3240/2026-S0'), (N'BAPB 091/KPB3240/2026-S0'), (N'BAPB 092/KPB3240/2026-S0'), (N'BAPB 093/KPB3240/2026-S0'), (N'BAPB 094/KPB3240/2026-S0'), (N'BAPB 095/KPB3240/2026-S0'), (N'BAPB 096/KPB3240/2026-S0'), (N'BAST 001/KPB3240/2026-S0'), (N'BAST 002/KPB3240/2026-S0'), (N'BAST 003/KPB3240/2026-S0'), (N'BAST 004/KPB3240/2026-S0'), (N'BAST 005/KPB3240/2026-S0'), (N'BAST 006/KPB3240/2026-S0'), (N'BAST 007/KPB3240/2026-S0'), (N'BAST 008/KPB3240/2026-S0'), (N'BAST 009/KPB3240/2026-S0');
INSERT INTO @arsip (Nomor) VALUES (N'BAST 010/KPB3240/2026-S0'), (N'BAST 013/KPB3240/2026-S0'), (N'BAST 014/KPB3240/2026-S0'), (N'BAST 015/KPB3240/2026-S0'), (N'BAST 016/KPB3240/2026-S0'), (N'BAST 017/KPB2200/2026-S9'), (N'BAST 018/KPB2200/2026-S9'), (N'BAST 019/KPB2200/2026-S9'), (N'BAST 020/KPB3240/2026-S0'), (N'BAST 021/KPB3240/2026-S0'), (N'BAST 022/KPB3240/2026-S0'), (N'BAST 023/KPB3240/2026-S0'), (N'BAST 024/KPB3240/2026-S0'), (N'BAST 025/KPB3240/2026-S0'), (N'BAST 026/KPB3240/2026-S0'), (N'BAST 027/KPB3240/2026-S0'), (N'BAST 028/KPB3240/2026-S0'), (N'BAST 029/KPB3240/2026-S0'), (N'BAST 030/KPB3240/2026-S0'), (N'BAST 031/KPB3240/2026-S0');
INSERT INTO @arsip (Nomor) VALUES (N'BAST 032/KPB3240/2026-S0'), (N'BAST 033/KPB3240/2026-S0'), (N'BAST 034/KPB3240/2026-S0'), (N'BAST 035/KPB3240/2026-S0'), (N'BAST 036/KPB3240/2026-S0'), (N'BAST 037/KPB3240/2026-S0'), (N'BAST 038/KPB3240/2026-S0'), (N'BAST 039/KPB3240/2026-S0'), (N'BAST 040/KPB3240/2026-S0'), (N'BAST 041/KPB3240/2026-S0'), (N'BAST 042/KPB3240/2026-S0'), (N'BAST 043/KPB3240/2026-S0'), (N'BAST 044/KPB3240/2026-S0'), (N'BAST 045/KPB3240/2026-S0'), (N'BAST 046/KPB3240/2026-S0'), (N'BAST 047/KPB3240/2026-S0'), (N'BAST 048/KPB3240/2026-S0'), (N'BAST 049/KPB3240/2026-S0'), (N'BAST 050/KPB3240/2026-S0'), (N'BAST 051/KPB3240/2026-S0');
INSERT INTO @arsip (Nomor) VALUES (N'BAST 052/KPB3240/2026-S0'), (N'BAST 053/KPB3240/2026-S0'), (N'BAST 054/KPB3240/2026-S0'), (N'BAST 055/KPB3240/2026-S0'), (N'BAST 056/KPB3240/2026-S0'), (N'BAST 057/KPB3240/2026-S0'), (N'BAST 059/KPB3240/2026-S0'), (N'BAST 060/KPB3240/2026-S0'), (N'BAST 061/KPB3240/2026-S0'), (N'BAST 062/KPB3240/2026-S0'), (N'BAST 064/KPB3240/2026-S0'), (N'BAST 065/KPB3240/2026-S0'), (N'BAST 066/KPB3240/2026-S0'), (N'BAST 068/KPB2000/2026-S0'), (N'BAST 069/KPB2000/2026-S0'), (N'BAST 070/KPB2000/2026-S0'), (N'BAST 071/KPB2000/2026-S0'), (N'BAST 072/KPB2000/2026-S0'), (N'BAST 073/KPB2000/2026-S0'), (N'BAST 074/KPB2000/2026-S0');
INSERT INTO @arsip (Nomor) VALUES (N'BAST 075/KPB2000/2026-S0'), (N'BAST 076/KPB2000/2026-S0'), (N'BAST 077/KPB2000/2026-S0'), (N'BAST 078/KPB2000/2026-S0'), (N'BAST 079/KPB2000/2026-S0'), (N'BAST 080/KPB2000/2026-S0'), (N'BAST 081/KPB2000/2026-S0'), (N'BAST 082/KPB3240/2026-S0'), (N'BAST 083/KPB2000/2026-S0'), (N'BAST 084/KPB3240/2026-S0'), (N'BAST 085/KPB3240/2026-S0'), (N'BAST 086/KPB3240/2026-S0'), (N'BAST 087/KPB3240/2026-S0'), (N'BAST 088/KPB3240/2026-S0'), (N'BAST 089/KPB3240/2026-S0'), (N'BAST 090/KPB3240/2026-S0'), (N'BAST 091/KPB3240/2026-S0'), (N'BAST 092/KPB3240/2026-S0'), (N'BAST 093/KPB3240/2026-S0'), (N'BAST 094/KPB3240/2026-S0');
INSERT INTO @arsip (Nomor) VALUES (N'BAST 095/KPB3240/2026-S0'), (N'BAST 096/KPB3240/2026-S0'), (N'BAST 097/KPB3240/2026-S0'), (N'BAST 098/KPB3240/2026-S0'), (N'BAST 099/KPB3240/2026-S0'), (N'BAST 100/KPB3240/2026-S0'), (N'BAST 101/KPB2000/2026-S0'), (N'BAST 102/KPB2000/2026-S0'), (N'BAST 103/KPB2000/2026-S0'), (N'BAST 104/KPB3240/2026-S0'), (N'BAST 105/KPB3240/2026-S0'), (N'BAST 106/KPB3240/2026-S0'), (N'BAST 107/KPB3240/2026-S0'), (N'BAST 108/KPB3240/2026-S0'), (N'BAST 109/KPB3240/2026-S0'), (N'BAST 110/KPB2000/2026-S0'), (N'BAST 111/KPB2200/2026-S9'), (N'BAST 112/KPB2000/2026-S0'), (N'BAST 113/KPB3240/2026-S0'), (N'BAST 114/KPB2000/2026-S0');
INSERT INTO @arsip (Nomor) VALUES (N'BAST 115/KPB3240/2026-S0'), (N'BAST 116/KPB3240/2026-S0'), (N'BAST 117/KPB2000/2026-S0'), (N'BAST 118/KPB3240/2026-S0'), (N'BAST 119/KPB3240/2026-S0'), (N'BAST 120/KPB3240/2026-S0'), (N'BAST 121/KPB2000/2026-S0'), (N'BAST 122/KPB3240/2026-S0'), (N'BAST 123/KPB3240/2026-S0'), (N'BAST 124/KPB2000/2026-S0'), (N'BAST 125/KPB3240/2026-S0'), (N'BAST 126/KPB3240/2026-S0'), (N'BAST 127/KPB3240/2026-S0'), (N'BAST 128/KPB2000/2026-S0'), (N'BAST 129/KPB3240/2026-S0'), (N'BAST 130/KPB3240/2026-S0'), (N'BAST 131/KPB3240/2026-S0'), (N'BAST 132/KPB3240/2026-S0'), (N'BAST 133/KPB3240/2026-S0'), (N'BAST 134/KPB3240/2026-S0');
INSERT INTO @arsip (Nomor) VALUES (N'BAST 135/KPB3240/2026-S0'), (N'BAST 136/KPB3240/2026-S0'), (N'BAST 137/KPB3240/2026-S0'), (N'BAST 138/KPB3240/2026-S0'), (N'BAST 139/KPB3240/2026-S0'), (N'BAST 140/KPB3240/2026-S0'), (N'BAST 141/KPB3240/2026-S0'), (N'BAST 142/KPB3240/2026-S0'), (N'BAST 143/KPB3240/2026-S0'), (N'BAST 144/KPB3240/2026-S0'), (N'BAST 145/KPB3240/2026-S0');

DECLARE @asing nvarchar(100) = (
    SELECT TOP 1 s.NomorSurat FROM Surat s
    WHERE NOT EXISTS (SELECT 1 FROM @arsip a WHERE a.Nomor = s.NomorSurat));

IF @asing IS NOT NULL
    THROW 50001, 'Ada surat di luar daftar arsip (mis. dibuat lewat aplikasi) — skrip dihentikan, tidak ada yang dihapus.', 1;

BEGIN TRANSACTION;

DELETE g FROM GambarPoin g JOIN PoinSurat p ON p.Id = g.PoinSuratId
    JOIN Surat s ON s.Id = p.SuratId WHERE s.NomorSurat IN (SELECT Nomor FROM @arsip);
DELETE b FROM BarangSurat b JOIN Surat s ON s.Id = b.SuratId
    WHERE s.NomorSurat IN (SELECT Nomor FROM @arsip);
DELETE p FROM PoinSurat p JOIN Surat s ON s.Id = p.SuratId
    WHERE s.NomorSurat IN (SELECT Nomor FROM @arsip);
DELETE FROM Surat WHERE NomorSurat IN (SELECT Nomor FROM @arsip);

DECLARE @id int;

INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 001/KPB3240/2026-S0', 1, N'2026-01-02', N'2026-01-02', 2, N'Nauva Astarina - Sub Fire Station', N'PC SM KPB + Dongle Wifi
Hostname: KPB01CR4218004');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'PC SM KPB + Dongle Wifi', N'4CE202CKC1', N'', N'Nauva Astarina - Sub Fire Station');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'3CQ20200G6', N'', N'Nauva Astarina - Sub Fire Station');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 002/KPB3240/2026-S0', 1, N'2026-01-02', N'2026-01-02', 2, N'Rayhan Mubarok', N'Tiket MySSC', N'REQ000007932476', N'1 box all colour 7740');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'1 box all colour 7740', N'', N'Rayhan Mubarok', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 003/KPB3240/2026-S0', 1, N'2026-01-05', N'2026-01-05', 2, N'Azwirandi (CSU Non Process)', N'Nomor Memo', N'176/KPB2200/2025-S0', N'Absensi Tapping Card Hikvision');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Absensi Tapping Card Hikvision', N'', N'Azwirandi (CSU Non Process)', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 004/KPB3240/2026-S0', 1, N'2026-01-06', N'2026-01-06', 2, N'Otniel Christianto', N'Tiket MySSC', N'REQ000007735540', N'Hostname: KPB01CR4210130');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'4CE202CKCX', N'', N'Otniel Christianto');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'3CQ20118ZF', N'', N'Otniel Christianto');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 005/KPB3240/2026-S0', 1, N'2026-01-06', N'2026-01-06', 2, N'Alwi Aprisha', N'Tiket MySSC', N'REQ000007795251', N'LENOVO THINKPAD L13 GEN 4
Hostname: KPB01CO2240164');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'LENOVO THINKPAD L13 GEN 4', N'PW0BYRAF', N'', N'Alwi Aprisha');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'8SSA10R16921C2TJ44A0BZ5', N'', N'Alwi Aprisha');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 006/KPB3240/2026-S0', 1, N'2026-01-06', N'2026-01-06', 2, N'Nikko Aditiya Yudha Kusuma', N'Tiket MySSC', N'REQ000007888758', N'LENOVO THINKPAD L13 GEN 4
Hostname: KPB01CO2240165');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'LENOVO THINKPAD L13 GEN 4', N'PW0BYNKJ', N'', N'Nikko Aditiya Yudha Kusuma');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'8SSA10R16961A1WH45D06X6', N'', N'Nikko Aditiya Yudha Kusuma');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 007/KPB3240/2026-S0', 1, N'2026-01-06', N'2026-01-06', 2, N'Hadi Nur Ubaedilah', N'Tiket MySSC', N'REQ000007879557', N'LENOVO THINKPAD L13 GEN 4
Hostname: KPB01CO2240166');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'LENOVO THINKPAD L13 GEN 4', N'PW0BYRA8', N'', N'Hadi Nur Ubaedilah');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'8SSA10R16921C2TJ44A0FNM', N'', N'Hadi Nur Ubaedilah');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 008/KPB3240/2026-S0', 1, N'2026-01-06', N'2026-01-06', 2, N'Sugeng Priambodo', N'Tiket MySSC', N'REQ000007963428', N'Tinta 7740 YCK @1 box');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Tinta 7740 YCK @1 box', N'', N'Sugeng Priambodo', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 009/KPB3240/2026-S0', 1, N'2026-01-14', N'2026-01-14', 2, N'Achmad Riza Pamula', N'Tiket MySSC', N'REQ000007971153', N'Tinta 7740 YMCK @2 box');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Tinta 7740 YMCK @2 box', N'', N'Achmad Riza Pamula', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan)
VALUES (N'BAST 010/KPB3240/2026-S0', 1, N'2026-01-15', N'2026-01-15', 2, N'Warmin', N'Sr Engineer I Stationary');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'871TVW1057', N'', N'Warmin');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, Deskripsi)
VALUES (N'BAST 013/KPB3240/2026-S0', 2, N'2026-01-15', N'2026-01-15', 2, N'Rekaman CCTV 09-12-2025 s/d 11-12-2025', N'Supervisor Security OSBL', N'Security', N'88009448', N'NSO LT4 Lorong Kanan
Hostname: -');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, Tanggal, Area, Rekaman, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Rekaman CCTV', N'09-12-2025 s/d 11-12-2025', N'NSO LT4 Lorong Kanan', NULL, N'', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, Deskripsi)
VALUES (N'BAST 014/KPB3240/2026-S0', 1, N'2026-01-22', N'2026-01-22', 2, N'Monitoring CCTV di Ruang Dir Ops', N'Direktur Operasi', N'NSO LT4
Hostname: KPB01CR4230082');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'NSO LT4', N'', N'Monitoring CCTV di Ruang Dir Ops', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, Deskripsi)
VALUES (N'BAST 015/KPB3240/2026-S0', 1, N'2026-01-22', N'2026-01-22', 2, N'Monitoring CCTV di Ruang Dir Keu', N'Direktur Keuangan dan Penunjang Bisnis', N'NSO LT4
Hostname: KPB01CR4230018');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'NSO LT4', N'', N'Monitoring CCTV di Ruang Dir Keu', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, Deskripsi)
VALUES (N'BAST 016/KPB3240/2026-S0', 1, N'2026-01-22', N'2026-01-22', 2, N'Monitoring CCTV Detection HSSE', N'Dessy Chaterina Ullyma Gultom', N'NSO LT4
Hostname: KPB01CR4230019');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'NSO LT4', N'', N'Monitoring CCTV Detection HSSE', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, Deskripsi)
VALUES (N'BAST 017/KPB2200/2026-S9', 1, N'2026-01-23', N'2026-01-23', 2, N'Mohammad Taufiq Ridho', N'Manager CSU Proses', N'NSO LT4
Hostname: M. TAUFIQ RIDHO');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'NSO LT4', N'', N'Mohammad Taufiq Ridho', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 018/KPB2200/2026-S9', 1, N'2026-01-05', N'2026-01-05', 2, N'Jemingan', N'Supervisor Security OSBL', N'Nomor Memo', N'230/KPB0110/2025-S0', N'NSO LT2
Hostname: KPB01CR4230047');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'NSO LT2', N'KPB01CR4230047', N'', N'Jemingan');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 019/KPB2200/2026-S9', 1, N'2026-01-05', N'2026-01-05', 2, N'Gustiawarman', N'Nomor Memo', N'034/KPB2200/2026-S9', N'CN98FPC1T8 HP-2530-8-PoEP CNK7K51369 Aruba IAP-345');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'CN98FPC1T8 HP-2530-8-PoEP CNK7K51369 Aruba IAP-345', N'', N'Gustiawarman', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab)
VALUES (N'BAST 020/KPB3240/2026-S0', 1, N'2026-02-03', N'2026-02-03', 2, N'Heru Kisworo');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'871TVK0554', N'', N'Heru Kisworo');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 021/KPB3240/2026-S0', 1, N'2026-02-04', N'2026-02-04', 2, N'Achmad Riza Pamula', N'Analyst II HSSE Study & Tech. Service', N'HSSE', N'7749232', N'Tiket MySSC', N'REQ000007997508', N'Pemenuhan Permintaan Berdasarkan Tiket MySSC Blank Card Blank Card Non Mag');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Pemenuhan Permintaan Berdasarkan Tiket MySSC Blank Card Blank Card Non Mag', N'Blank Card', N'Achmad Riza Pamula', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab)
VALUES (N'BAST 022/KPB3240/2026-S0', 1, N'2026-02-04', N'2026-02-04', 2, N'Alfakemal');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Perangkat', N'', N'Alfakemal', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 023/KPB3240/2026-S0', 1, N'2026-02-05', N'2026-02-05', 2, N'Ahmad Ridha Akbar', N'Nomor Memo', N'213/KPB2200/2025-S9', N'KPB02CR1210020 HP PROBOOK 440 G8 PWTT Ahmad Ridha Akbar peminjamna sementara
Hostname: KPB02CR1210020');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'5CD2041WQJ', N'', N'Ahmad Ridha Akbar');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 024/KPB3240/2026-S0', 1, N'2026-02-05', N'2026-02-05', 2, N'Donny Albar Parlindungan', N'Tiket MySSC', N'REQ000008037152', N'Hostname: KPB01CR4210003');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'4CE202CKD4', N'', N'Donny Albar Parlindungan');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'3CQ20119SR', N'', N'Donny Albar Parlindungan');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 025/KPB3240/2026-S0', 1, N'2026-02-05', N'2026-02-05', 2, N'Dewi Sri Apriliyanti', N'Nomor Memo', N'009/KPB2200/2026-S9', N'.
Hostname: KPB02CR1230120');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'.', N'5CD347BBQ6', N'', N'Dewi Sri Apriliyanti');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'WHGRL0DVSIOCPF', N'', N'Dewi Sri Apriliyanti');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab)
VALUES (N'BAST 026/KPB3240/2026-S0', 1, N'2026-02-05', N'2026-02-05', 2, N'Arafat Bayu');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'2531GY400076', N'', N'Arafat Bayu');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 027/KPB3240/2026-S0', 1, N'2026-02-05', N'2026-02-05', 2, N'Andhika Eka Putra', N'PSPS', N'Tiket MySSC', N'REQ000007925703', N'Hostname: KPB01CO2240170');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'PW0BYNFC', N'', N'Andhika Eka Putra');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'8SSA10R16961A1WH45D06T9', N'', N'Andhika Eka Putra');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 028/KPB3240/2026-S0', 1, N'2026-02-06', N'2026-02-06', 2, N'Fahrun', N'penukaran 10 ht nawakaran dengan ht nexcom');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'penukaran 10 ht nawakaran dengan ht nexcom', N'', N'Fahrun', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 029/KPB3240/2026-S0', 1, N'2026-02-06', N'2026-02-06', 2, N'Illyina RDP 71', N'Tiket MySSC', N'REQ000008017809', N'TInta 7740 black blue @1box');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Perangkat', N'', N'Illyina RDP 71', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 030/KPB3240/2026-S0', 1, N'2026-02-06', N'2026-02-06', 2, N'Alfakemal Medi Priawan', N'Nomor Memo', N'008/KPB2200/2026-S5', N'WWTP');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'UDVWNSD03A325002600601', N'', N'Alfakemal Medi Priawan');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'MMLXKSS007245122D14248', N'', N'Alfakemal Medi Priawan');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 031/KPB3240/2026-S0', 1, N'2026-02-06', N'2026-02-06', 2, N'M. Fahrun Richardsa L.', N'Sr Supervisor Facility & Quality', N'Nomor Memo', N'031/KPB2200/2026-S9', N'untuk kegiatan ISS dan OSS unit RFCC NHT 053
GAST
Hostname: KPB01CR4230016');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'untuk kegiatan ISS dan OSS unit RFCC NHT 053', N'UDVWNSD023308018D30601', N'', N'M. Fahrun Richardsa L.');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'MMLXKSS007245123F64248', N'', N'M. Fahrun Richardsa L.');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 032/KPB3240/2026-S0', 1, N'2026-02-06', N'2026-02-06', 2, N'M. Fahrun Richardsa L.', N'Sr Supervisor Facility & Quality', N'Nomor Memo', N'031/KPB2200/2026-S9', N'untuk kegiatan ISS dan OSS unit RFCC NHT 053
GAST
Hostname: KPB01CR4230058');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'untuk kegiatan ISS dan OSS unit RFCC NHT 053', N'UDVWNSD03A325002380601', N'', N'M. Fahrun Richardsa L.');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'MMLXKSS007245122D04248', N'', N'M. Fahrun Richardsa L.');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 033/KPB3240/2026-S0', 1, N'2026-02-06', N'2026-02-06', 2, N'M. Fahrun Richardsa L.', N'Sr Supervisor Facility & Quality', N'Nomor Memo', N'031/KPB2200/2026-S9', N'untuk kegiatan ISS dan OSS unit RFCC NHT 053
GAST
Hostname: KPB01CR4230053');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'untuk kegiatan ISS dan OSS unit RFCC NHT 053', N'UDVWNSD03A325002250601', N'', N'M. Fahrun Richardsa L.');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'MMLXKSS007245122CE4248', N'', N'M. Fahrun Richardsa L.');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 034/KPB3240/2026-S0', 1, N'2026-02-06', N'2026-02-06', 2, N'M. Fahrun Richardsa L.', N'Sr Supervisor Facility & Quality', N'Nomor Memo', N'031/KPB2200/2026-S9', N'untuk kegiatan ISS dan OSS unit RFCC NHT 053
GAST
Hostname: KPB01CR4230048');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'untuk kegiatan ISS dan OSS unit RFCC NHT 053', N'UDVWNSD03A325002530601', N'', N'M. Fahrun Richardsa L.');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'MMLXKSS007245122F14248', N'', N'M. Fahrun Richardsa L.');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 035/KPB3240/2026-S0', 1, N'2026-02-18', N'2026-02-18', 2, N'Roland Joshua', N'@1 box all colour 7740
GAST');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'@1 box all colour 7740', N'', N'Roland Joshua', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 036/KPB3240/2026-S0', 1, N'2026-02-18', N'2026-02-18', 2, N'Nathania Verinda P', N'Tiket MySSC', N'REQ000008064399', N'@1 box Black magenta 7740');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'@1 box Black magenta 7740', N'', N'Nathania Verinda P', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 037/KPB3240/2026-S0', 1, N'2026-02-18', N'2026-02-18', 2, N'Dhiya Arifa', N'Hostname: KPB01CR4210010');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'4CE202CK8S', N'', N'Dhiya Arifa');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'3CQ20118Z1', N'', N'Dhiya Arifa');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 038/KPB3240/2026-S0', 1, N'2026-02-20', N'2026-02-20', 2, N'Handriyadi', N'Tiket MySSC', N'REQ000007946145', N'Organik pada arsip lama: REQ000007946145
Hostname: KPB01CR4230017');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'UDVWNSD02330801A870601', N'', N'Handriyadi');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'MMLXKSS007245122F14248', N'', N'Handriyadi');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 039/KPB3240/2026-S0', 1, N'2026-02-20', N'2026-02-20', 2, N'Mohammad Ainun Firdaus', N'Tiket MySSC', N'REQ000007992325', N'Organik pada arsip lama: REQ000007992325
Hostname: KPB01CR4230016');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'UDVWNSD023308018D30601', N'', N'Mohammad Ainun Firdaus');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'MMLXKSS007245123F64248', N'', N'Mohammad Ainun Firdaus');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 040/KPB3240/2026-S0', 1, N'2026-02-20', N'2026-02-20', 2, N'Medi Saputra', N'Tiket MySSC', N'REQ000007992325', N'Organik pada arsip lama: REQ000007992325
Hostname: KPB01CR4230015');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'UDVWNSD02330801A650601', N'', N'Medi Saputra');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'MMLXKSS007245126564248', N'', N'Medi Saputra');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 041/KPB3240/2026-S0', 1, N'2026-02-20', N'2026-02-20', 2, N'Arief Rahman Hakim', N'Tiket MySSC', N'REQ000007755131', N'Organik pada arsip lama: REQ000007755131
Hostname: KPB01CR4230058');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'UDVWNSD03A325002380601', N'', N'Arief Rahman Hakim');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'MMLXKSS007245122D04248', N'', N'Arief Rahman Hakim');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 042/KPB3240/2026-S0', 1, N'2026-02-20', N'2026-02-20', 2, N'Epul Saepul Ramadan', N'Tiket MySSC', N'REQ000007756999', N'Organik pada arsip lama: REQ000007756999
Hostname: KPB01CR4230053');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'UDVWNSD03A325002250601', N'', N'Epul Saepul Ramadan');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'MMLXKSS007245122CE4248', N'', N'Epul Saepul Ramadan');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 043/KPB3240/2026-S0', 1, N'2026-02-28', N'2026-02-28', 2, N'Gialng PRatama', N'3 HT RFCC');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'3 HT RFCC', N'', N'Gialng PRatama', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 044/KPB3240/2026-S0', 1, N'2026-03-04', N'2026-03-04', 2, N'Farida Hayati', N'3 baterai');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'3 baterai', N'', N'Farida Hayati', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 045/KPB3240/2026-S0', 1, N'2026-03-04', N'2026-03-04', 2, N'Sela', N'3 tinta 7740');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'3 tinta 7740', N'', N'Sela', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 046/KPB3240/2026-S0', 1, N'2026-03-17', N'2026-03-17', 2, N'Bagas Hermanto', N'PSPS', N'Nomor Memo', N'084/KPB3210/2026-S9', N'Organik pada arsip lama: Ardian Eko Handoko, Ast Manager Offsite, Lawe-Lawe & EW, PSPS, 749811
Hostname: KPB02CR1210069');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD201DCRF', N'HP PROBOOK 430 G8', N'Bagas Hermanto');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHHWK0CCXFZ9AA', N'', N'Bagas Hermanto');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 047/KPB3240/2026-S0', 1, N'2026-03-17', N'2026-03-17', 2, N'Achmad Riza Pamula', N'Tinta HITI 3 box, Blank Card (200), Tinta HP 955 XL semua warna (1)
Tanggal serah terima tidak tercatat pada arsip lama; dipakai tanggal dokumen sebelumnya.');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Tinta HITI 3 box, Blank Card (200), Tinta HP 955 XL semua warna (1)', N'', N'Achmad Riza Pamula', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 048/KPB3240/2026-S0', 1, N'2026-03-17', N'2026-03-17', 2, N'Asep Sulaeman', N'Pjs. Manager Legal & Compliance', N'Legal & Relation', N'88006426', N'Nomor Memo', N'034/KPB0200/2026-S9', N'TV 50 Inch Samsung 50U8000
Memo
Tanggal serah terima tidak tercatat pada arsip lama; dipakai tanggal dokumen sebelumnya.');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'TV 50 Inch Samsung 50U8000', N'0ZMW3NFY404705', N'Samsung TV 50 Inch', N'Asep Sulaeman');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 049/KPB3240/2026-S0', 1, N'2026-03-17', N'2026-03-17', 2, N'PT NAWAKARA BANGUN NUSANTARA', N'PT NAWAKARA BANGUN NUSANTARA 9 HT
Tanggal serah terima tidak tercatat pada arsip lama; dipakai tanggal dokumen sebelumnya.');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'PT NAWAKARA BANGUN NUSANTARA 9 HT', N'', N'PT NAWAKARA BANGUN NUSANTARA', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 050/KPB3240/2026-S0', 1, N'2026-03-17', N'2026-03-17', 2, N'Shaffa Aulia Yasmin', N'Nomor Memo', N'093/KPB1400/2026-S9', N'Tanggal serah terima tidak tercatat pada arsip lama; dipakai tanggal dokumen sebelumnya.
Hostname: KPB02CR1210037');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'5CD2041WYB', N'', N'Shaffa Aulia Yasmin');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'G22O0', N'', N'Shaffa Aulia Yasmin');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 051/KPB3240/2026-S0', 1, N'2026-03-17', N'2026-03-17', 2, N'Qonaaha Noor Maajid', N'Nomor Memo', N'093/KPB1400/2026-S9', N'Tanggal serah terima tidak tercatat pada arsip lama; dipakai tanggal dokumen sebelumnya.
Hostname: KPB02CR1219057');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'5CD201DCT6', N'', N'Qonaaha Noor Maajid');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'L80LG', N'', N'Qonaaha Noor Maajid');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 052/KPB3240/2026-S0', 1, N'2026-04-08', N'2026-04-08', 2, N'Sarah Salsabila Putritama', N'Tiket MySSC', N'REQ000008044523', N'Hostname: KPB01CR4230013');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'UDVWNSD02330801A510601', N'', N'Sarah Salsabila Putritama');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'L80LG', N'', N'Sarah Salsabila Putritama');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 053/KPB3240/2026-S0', 1, N'2026-04-08', N'2026-04-08', 2, N'Nabiyla Nadhir', N'Nomor Memo', N'051/KPB0200/2026-S8', N'Hostname: KPB02CR1210009');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'5CD2041WQ7', N'', N'Nabiyla Nadhir');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'G234R', N'', N'Nabiyla Nadhir');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket)
VALUES (N'BAST 054/KPB3240/2026-S0', 1, N'2026-04-14', N'2026-04-14', 2, N'Achmad Riza Pamula', N'Tiket MySSC', N'REQ000008178409');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Blank Card', N'', N'Achmad Riza Pamula', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab)
VALUES (N'BAST 055/KPB3240/2026-S0', 1, N'2026-01-02', N'2026-01-02', 2, N'Hendy Augustama');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'SSD 512', N'', N'Hendy Augustama', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 056/KPB3240/2026-S0', 1, N'2026-01-02', N'2026-01-02', 2, N'Gusti Mega', N'yellow & cyan 7740');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'yellow & cyan 7740', N'', N'Gusti Mega', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, Deskripsi)
VALUES (N'BAST 057/KPB3240/2026-S0', 1, N'2026-01-02', N'2026-01-02', 2, N'Erfano Bhakti', N'Pjs Manager Legal', N'Hostname: KPBMON229385QN');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'MMLY7SN0032080139385QN', N'', N'Erfano Bhakti');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 059/KPB3240/2026-S0', 1, N'2026-01-02', N'2026-01-02', 2, N'Meiryn Nurlinda', N'Tinta Kuning 7740');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Tinta Kuning 7740', N'', N'Meiryn Nurlinda', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 060/KPB3240/2026-S0', 1, N'2026-04-21', N'2026-04-21', 2, N'Monica Sari', N'Nomor Memo', N'114/KPB2200/2026-S9', N'SM5
Hostname: KPB01CO2240109');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'PW0BYRAG', N'', N'Monica Sari');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Baterai', N'8SSA10R16921C2TJ44A0AKM', N'', N'Monica Sari');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 061/KPB3240/2026-S0', 1, N'2026-04-23', N'2026-04-23', 2, N'Dedy Heriyanto Sembiring', N'Tiket MySSC', N'REQ000008251209', N'SM5
Hostname: KPB01CR4230085');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'UDVWNSD03P33400C0A0601', N'', N'Dedy Heriyanto Sembiring');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'URTYESD002335005170601', N'', N'Dedy Heriyanto Sembiring');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 062/KPB3240/2026-S0', 1, N'2026-04-23', N'2026-04-23', 2, N'Kusnandar', N'Tiket MySSC', N'REQ000008251180', N'SM5
Hostname: KPB01CR4230015');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'UDVWNSD02330801A650601', N'', N'Kusnandar');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'MMLXKSS007245126564248', N'', N'Kusnandar');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 064/KPB3240/2026-S0', 1, N'2026-04-23', N'2026-04-23', 2, N'Sela Puspita Sari', N'Tinta 7740 All Colour');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Tinta 7740 All Colour', N'', N'Sela Puspita Sari', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 065/KPB3240/2026-S0', 1, N'2026-04-24', N'2026-04-24', 2, N'Siti Ayu', N'Tinta GT52 All Colour');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Tinta GT52 All Colour', N'', N'Siti Ayu', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 066/KPB3240/2026-S0', 1, N'2026-04-27', N'2026-04-27', 2, N'PT RDMP JO', N'Kartu HID MIFARE 4K = 50 PCS');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Kartu HID MIFARE 4K = 50 PCS', N'', N'PT RDMP JO', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, Deskripsi)
VALUES (N'BAST 068/KPB2000/2026-S0', 1, N'2026-04-28', N'2026-04-28', 2, N'Arafat Bayu Nugroho', N'Direktur Operasi', N'Orbit MiFi H2 Model E5586-926 IMEI : 866938070894211 SN : 2TUFG25220012691 No SimCard Orbit : 0821 249 246 27
Organik pada arsip lama: 88027606');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Orbit MiFi H2 Model E5586-926 IMEI : 866938070894211 SN : 2TUFG25220012691 No SimCard Orbit : 0821 249 246 27', N'', N'Arafat Bayu Nugroho', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 069/KPB2000/2026-S0', 1, N'2026-04-28', N'2026-04-28', 2, N'Nur Raihan Jasmin Firdausi', N'Mitra Kerja', N'Tiket MySSC', N'REQ000007896320', N'Hostname: KPB01CR4230071');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'UDVWNSD03P33400B090601', N'', N'Nur Raihan Jasmin Firdausi');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'MMLXKSS007245122E14248', N'', N'Nur Raihan Jasmin Firdausi');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 070/KPB2000/2026-S0', 1, N'2026-04-10', N'2026-04-10', 2, N'Mu''ti Fahmi', N'Manager OSBL - Offsite & Lawe-Lawe', N'Tiket MySSC', N'REQ000008242823', N'057/KPB2200/2026/S9
Hostname: KPBMPST9Q6FJ');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'057/KPB2200/2026/S9', N'CNB2T9Q6FJ', N'', N'Mu''ti Fahmi');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 071/KPB2000/2026-S0', 1, N'2026-05-04', N'2026-05-04', 2, N'Rachma Ullya', N'Hostname: KPB01CO2240068');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'PW0BYRBD', N'', N'Rachma Ullya');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'8SSA10R16921C2TJ44A0BBJ', N'', N'Rachma Ullya');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 072/KPB2000/2026-S0', 1, N'2026-05-05', N'2026-05-05', 2, N'Mutiara Allam', N'Peminjaman laptop backup finance');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Peminjaman laptop backup finance', N'5CG0112SFP', N'', N'Mutiara Allam');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, Deskripsi)
VALUES (N'BAST 073/KPB2000/2026-S0', 1, N'2026-04-23', N'2026-04-23', 2, N'Asep Sulaeman', N'Pjs. Manager Legal', N'Monitor ex. Pak Iwan');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor ex. Pak Iwan', N'MMLY7SN0032080139385QN', N'', N'Asep Sulaeman');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket)
VALUES (N'BAST 074/KPB2000/2026-S0', 1, N'2026-05-07', N'2026-05-07', 2, N'Aurra Amalia Dwiputri', N'Tiket MySSC', N'REQ000008257695');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'UDVWNSD023308019150601', N'', N'Aurra Amalia Dwiputri');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'MMLXKSS007245122D54248', N'', N'Aurra Amalia Dwiputri');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 075/KPB2000/2026-S0', 1, N'2026-05-07', N'2026-05-07', 2, N'Ayomi Wulandari', N'Tiket MySSC', N'REQ000008254756', N'Hostname: KPB01CR4230037');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'UDVWNSD03A325002750601', N'', N'Ayomi Wulandari');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'MMLXKSS007245122E14248', N'', N'Ayomi Wulandari');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 076/KPB2000/2026-S0', 1, N'2026-05-08', N'2026-05-08', 2, N'Illyiana', N'REQ%8077753
tinta 7740 hitam biru');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'REQ%8077753', N'', N'Illyiana', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 077/KPB2000/2026-S0', 1, N'2026-05-08', N'2026-05-08', 2, N'Akhmad Ali Sonaka', N'Hostname: KPB02CR1210052');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'5CD201DCV6', N'', N'Akhmad Ali Sonaka');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 078/KPB2000/2026-S0', 1, N'2026-05-08', N'2026-05-08', 2, N'Mutiara Allam', N'Hostname: KPB02CR1230075');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'5CD329BJ0W', N'', N'Mutiara Allam');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 079/KPB2000/2026-S0', 1, N'2026-05-08', N'2026-05-08', 2, N'Lestari Rosdiana', N'Peminjaman laptop ENG');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Peminjaman laptop ENG', N'5CG0112SFC', N'', N'Lestari Rosdiana');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 080/KPB2000/2026-S0', 1, N'2026-05-12', N'2026-05-12', 2, N'Dean Patria Kayuwanan', N'Peminjaman laptop backup proc');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Peminjaman laptop backup proc', N'5CG1056326', N'', N'Dean Patria Kayuwanan');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 081/KPB2000/2026-S0', 1, N'2026-05-12', N'2026-05-12', 2, N'Akhmad Nurfais', N'Peminjaman laptop backup proc');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Peminjaman laptop backup proc', N'5CG0112SFP', N'', N'Akhmad Nurfais');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab)
VALUES (N'BAST 082/KPB3240/2026-S0', 1, N'2026-05-13', N'2026-05-13', 2, N'Gibran Rayhan T');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'871TZRS116', N'', N'Gibran Rayhan T');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 083/KPB2000/2026-S0', 1, N'2026-05-13', N'2026-05-13', 2, N'Ayomi Wulandari', N'Nomor Memo', N'140/KPB2200/2026/S9', N'Pemberian Printer A4 HP Color LaserJet Enterprise MFP X57945dn
Memo');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Pemberian Printer A4 HP Color LaserJet Enterprise MFP X57945dn', N'JPBRS2029K', N'', N'Ayomi Wulandari');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 084/KPB3240/2026-S0', 1, N'2026-05-19', N'2026-05-19', 2, N'Eko Tjahjono', N'Serah terima Sound System PJOT
Organik pada arsip lama: Eko Tjahjono, Sekretaris Dewan Komisaris, Dekom');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Serah terima Sound System PJOT', N'', N'Eko Tjahjono', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 085/KPB3240/2026-S0', 1, N'2026-05-20', N'2026-05-20', 2, N'Darwis Mulasit', N'Serah terima L13 Gen 4
Organik pada arsip lama: Darwis Mulasit, Production II
Hostname: KPB01CO2240172');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Serah terima L13 Gen 4', N'', N'Darwis Mulasit', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, Deskripsi)
VALUES (N'BAST 086/KPB3240/2026-S0', 1, N'2026-05-26', N'2026-05-26', 2, N'Monica Sari (Ali Fahdian)', N'Jr Engineer II Instrument', N'Organik pada arsip lama: Ali Fahdian');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'871TVB2657', N'', N'Monica Sari (Ali Fahdian)');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Baterai', N'500001EF95BA', N'', N'Monica Sari (Ali Fahdian)');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan)
VALUES (N'BAST 087/KPB3240/2026-S0', 1, N'2026-05-26', N'2026-05-26', 2, N'Elisa Filyani', N'Hiti 4 box');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Perangkat', N'', N'Elisa Filyani', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 088/KPB3240/2026-S0', 1, N'2026-06-02', N'2026-06-02', 2, N'Junaida Zamzami', N'MK', N'Nomor Memo', N'114/KPB2200/2026-S9', N'Hostname: KPB01CO2230038');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'PW05ZKJ0', N'L13 Gen 3', N'Junaida Zamzami');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 089/KPB3240/2026-S0', 1, N'2026-06-02', N'2026-06-02', 2, N'Rizqi Alhamidy Abdullah', N'MK', N'Nomor Memo', N'114/KPB2200/2026-S9', N'Hostname: KPB01CO2240056');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'PW0BYR8J', N'L13 Gen 4', N'Rizqi Alhamidy Abdullah');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 090/KPB3240/2026-S0', 1, N'2026-06-08', N'2026-06-08', 2, N'Meiryn Nurlinda', N'Tinta 7740 hitam');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Perangkat', N'', N'Meiryn Nurlinda', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 091/KPB3240/2026-S0', 1, N'2026-06-08', N'2026-06-08', 2, N'Yaldi Umar', N'ACS Card No 000862658489');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Perangkat', N'', N'Yaldi Umar', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 092/KPB3240/2026-S0', 1, N'2026-06-09', N'2026-06-09', 2, N'Deri Pradana', N'Nomor Memo', N'123/KPB2210/2026-S2', N'HP Pavilion Gaming Model 15-dk0043TX, Logitech BCC-950 memo');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Perangkat', N'', N'Deri Pradana', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 093/KPB3240/2026-S0', 1, N'2026-06-09', N'2026-06-09', 2, N'Mohammad Choirul Mu''an', N'Req Tinta warna Hitam
Printer HP Smart Tank 580 All-in-One Printer');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Req Tinta warna Hitam', N'HP', N'Mohammad Choirul Mu''an', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 094/KPB3240/2026-S0', 1, N'2026-05-12', N'2026-05-12', 2, N'Suroso', N'Peminjaman laptop backup rusak sm5');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Peminjaman laptop backup rusak sm5', N'5CD2041WYR', N'', N'Suroso');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 095/KPB3240/2026-S0', 1, N'2026-06-18', N'2026-06-18', 2, N'Chandra Jhonliasi Gultom', N'Tiket MySSC', N'REQ000008351175', N'Hostname: KPB01CR4230027');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'UDVWNSD03A325002560601', N'', N'Chandra Jhonliasi Gultom');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'MMLXKSS007245122FB4248', N'', N'Chandra Jhonliasi Gultom');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, Deskripsi)
VALUES (N'BAST 096/KPB3240/2026-S0', 1, N'2026-06-18', N'2026-06-18', 2, N'Hamida Nuur Masetya', N'Junior Auditor I', N'Internal Audit', N'2906661', N'Mockup Aplikasi Monitoring Tindak Lanjut
BERITA ACARA KESEPAKATAN PENGEMBANGAN APLIKASI MONITORING TINDAK LANJUT DI PT KILANG PERTAMINA BALIKPAPAN
Organik pada arsip lama: Hamida Nuur Masetya, Junior Auditor I, Internal Audit, 2906661');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Mockup Aplikasi Monitoring Tindak Lanjut', N'', N'Hamida Nuur Masetya', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 097/KPB3240/2026-S0', 1, N'2026-06-18', N'2026-06-18', 2, N'Dean Kayuwanan', N'Procurement', N'Tiket MySSC', N'REQ000008381715', N'216/KPB3230/2026-S9
Organik pada arsip lama: Mohammad Allvick Yusuf, Manager Procurement, Procurement, 749526
Hostname: KPB02CR1210084');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD201DCT7', N'HP PROBOOK 430 G8', N'Dean Kayuwanan');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHHRE0A5RFYOL3', N'', N'Dean Kayuwanan');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 098/KPB3240/2026-S0', 1, N'2026-06-18', N'2026-06-18', 2, N'Akhmad Nurfaiz', N'Procurement', N'Tiket MySSC', N'REQ000008381629', N'216/KPB3230/2026-S9
Organik pada arsip lama: Mohammad Allvick Yusuf, Manager Procurement, Procurement, 749526
Hostname: KPB02CR1210075');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD201DCSR', N'HP PROBOOK 430 G8', N'Akhmad Nurfaiz');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHHWK0CCXFZ994', N'', N'Akhmad Nurfaiz');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 099/KPB3240/2026-S0', 1, N'2026-06-19', N'2026-06-19', 2, N'Tatang Jainudin Arbain', N'QA/QC', N'Nomor Memo', N'254/KPB1400/2026-S0', N'Organik pada arsip lama: David P Nainggolan, Manager QA/QC, QA/QC, 747525
Hostname: KPB02CR1230016');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD329BJ1C', N'HP EliteBook 630 G9', N'Tatang Jainudin Arbain');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHGRE0D3GI7X3D', N'', N'Tatang Jainudin Arbain');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 100/KPB3240/2026-S0', 1, N'2026-06-19', N'2026-06-19', 2, N'Johan Mickael', N'QA/QC', N'Nomor Memo', N'254/KPB1400/2026-S0', N'Organik pada arsip lama: David P Nainggolan, Manager QA/QC, QA/QC, 747525
Hostname: KPB02CR1210035');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD2041WZJ', N'HP PROBOOK 440 G8', N'Johan Mickael');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'G22RH', N'', N'Johan Mickael');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 101/KPB2000/2026-S0', 1, N'2026-06-24', N'2026-06-24', 2, N'Muhammad Haryono', N'Operator II DHT', N'System Completion - Production II', N'29007563', N'Tiket MySSC', N'REQ000008344037', N'Pemberian Printer Supplies tinta 2 set hitam, merah, biru, kuning merek HP Office jet Pro 7720
Sesuai request ticket');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Pemberian Printer Supplies tinta 2 set hitam, merah, biru, kuning merek HP Office jet Pro 7720', N'Printer Supplies', N'Muhammad Haryono', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 102/KPB2000/2026-S0', 1, N'2026-06-26', N'2026-06-26', 2, N'Edward Gustaf', N'Jr Engineer II Proc.Unit GSH,Al.&SourTr.', N'System Completion - ISBL & Revamp', N'13107618', N'Tiket MySSC', N'REQ000008422447', N'Pemberian Printer Supplies tinta 1 set hitam, merah, biru, kuning merek HP Office jet Pro 7720 di RDP no.30
Sesuai request ticket');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Pemberian Printer Supplies tinta 1 set hitam, merah, biru, kuning merek HP Office jet Pro 7720 di RDP no.30', N'Printer Supplies', N'Edward Gustaf', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 103/KPB2000/2026-S0', 1, N'2026-06-29', N'2026-06-29', 2, N'Dian Lestarianto', N'Officer II Field HSSE ISBL', N'HSSE - HSSE Balikpapan', N'13107516', N'Tiket MySSC', N'REQ000008429510', N'Pemberian Printer Supplies tinta 1 warna hitam merek HP Office jet Pro 7720 di RDP Langkat no.69
Sesuai request ticket');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Pemberian Printer Supplies tinta 1 warna hitam merek HP Office jet Pro 7720 di RDP Langkat no.69', N'Printer Supplies', N'Dian Lestarianto', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 104/KPB3240/2026-S0', 1, N'2026-06-29', N'2026-06-29', 2, N'Yahya Nur Rohman', N'System Completion', N'Tiket MySSC', N'REQ000008247930', N'114/KPB2200/2026-S9
Organik pada arsip lama: Lis Sugiantoro, Manager Technical Support, System Completion, 747536
Hostname: KPB02CR1230074');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD329BJ0V', N'HP EliteBook 630 G9', N'Yahya Nur Rohman');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHGRE0D3GI7X4A', N'', N'Yahya Nur Rohman');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 105/KPB3240/2026-S0', 1, N'2026-06-30', N'2026-06-30', 2, N'Alya Rynata Moniqueca Azzahra', N'System Completion', N'Tiket MySSC', N'REQ000007924885', N'150/KPB2200/2026-S9
Organik pada arsip lama: Mu''ti Fahmi, Manager OSBL Offsite & Lawe Lawe, System Completion, 747896
Hostname: KPB02CR1230036');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD329BJ2N', N'HP EliteBook 630 G9', N'Alya Rynata Moniqueca Azzahra');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHGRE0D3GI7X90', N'', N'Alya Rynata Moniqueca Azzahra');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 106/KPB3240/2026-S0', 1, N'2026-06-30', N'2026-06-30', 2, N'Cahyo Basuki', N'System Completion', N'Tiket MySSC', N'REQ000007924885', N'150/KPB2200/2026-S9
Organik pada arsip lama: Mu''ti Fahmi, Manager OSBL Offsite & Lawe Lawe, System Completion, 747896
Hostname: KPB02CR1230039');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD329BJ13', N'HP EliteBook 630 G9', N'Cahyo Basuki');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHGRE0DVKI7FPM', N'', N'Cahyo Basuki');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 107/KPB3240/2026-S0', 1, N'2026-07-01', N'2026-07-01', 2, N'Muhammad Awaluddin', N'Construction Lawe-Lawe', N'Nomor Memo', N'070/KPB1300/2025-S9', N'Organik pada arsip lama: Simon Siregar, Manager Construction Off.,UTL,& Tech Sup, Construction Lawe-Lawe, 746586
Hostname: KPB02CR1230006');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD329BJ1T', N'HP EliteBook 630 G9', N'Muhammad Awaluddin');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHGRE0D3GI7X8G', N'', N'Muhammad Awaluddin');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, Deskripsi)
VALUES (N'BAST 108/KPB3240/2026-S0', 1, N'2026-06-30', N'2026-06-30', 2, N'Suroso', N'Section Head Utilities II', N'System Completion_Direktur Operasi', N'731546', N'Organik pada arsip lama: Suroso, Section Head Utilities II, System Completion/Direktur Operasi, 731546
Hostname: Suroso');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Perangkat Jaringan', N'', N'Suroso', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, Deskripsi)
VALUES (N'BAST 109/KPB3240/2026-S0', 1, N'2026-07-07', N'2026-07-07', 2, N'Sugeng Priambodo', N'Sr Officer II Field HSSE Onshore', N'Direktur Utama', N'725277', N'Tinta Printer 7740 (CMYK)
Hostname: -');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Tinta Printer 7740 (CMYK)', N'', N'Sugeng Priambodo', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 110/KPB2000/2026-S0', 1, N'2026-07-13', N'2026-07-13', 2, N'Ahmad Ridha Akbar', N'Operator I Platforming-CCR-Gas Process.', N'System Completion - Production II', N'756402', N'Tiket MySSC', N'REQ000008472143', N'Pemberian Printer Supplies tinta 1 warna hitam merek HP Office jet Pro 7720 di RDP Langkat no.71
Sesuai request ticket');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Pemberian Printer Supplies tinta 1 warna hitam merek HP Office jet Pro 7720 di RDP Langkat no.71', N'Printer Supplies', N'Ahmad Ridha Akbar', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 111/KPB2200/2026-S9', 1, N'2026-07-13', N'2026-07-13', 2, N'Jared Athar', N'Webcam Camera
Organik pada arsip lama: Anindita Mahendra, Sr Officer III Board Support');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Webcam Camera', N'', N'Jared Athar', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 112/KPB2000/2026-S0', 1, N'2026-07-13', N'2026-07-13', 2, N'Ahmad Ridha Akbar', N'Operator I Platforming-CCR-Gas Process.', N'System Completion - Production II', N'756402', N'Tiket MySSC', N'REQ000008472143', N'Pemberian Printer Supplies tinta 1 warna Cyan, Magenta, Yellow merek HP Office jet Pro 7720 di RDP Langkat no.71
Sesuai request ticket');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Pemberian Printer Supplies tinta 1 warna Cyan, Magenta, Yellow merek HP Office jet Pro 7720 di RDP Langkat no.71', N'Printer Supplies', N'Ahmad Ridha Akbar', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 113/KPB3240/2026-S0', 1, N'2026-07-14', N'2026-07-14', 2, N'Riyan Adiputra', N'System Completion', N'Tiket MySSC', N'REQ000008477426', N'Peminjaman Perangkat tgl 14-27 Juli 2026
Organik pada arsip lama: Aditya Novianto, Sr Supervisor Facility & Quality, System Completion, 748528
Hostname: KPB02CR1230021');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD329BJ1R', N'HP EliteBook 630 G9', N'Riyan Adiputra');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHGRE0D3GI7X5V', N'', N'Riyan Adiputra');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 114/KPB2000/2026-S0', 1, N'2026-07-17', N'2026-07-17', 2, N'Ahmad Banadib', N'Sr Engineer II Process Unit Revamp', N'System Completion - ISBL & Revamp', N'750358', N'Tiket MySSC', N'REQ000008490034', N'Pemberian Printer Supplies tinta 2 set all colour merek HP Office jet Pro 7720 di RDP Langkat no.30
Sesuai request ticket');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Pemberian Printer Supplies tinta 2 set all colour merek HP Office jet Pro 7720 di RDP Langkat no.30', N'Printer Supplies', N'Ahmad Banadib', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 115/KPB3240/2026-S0', 1, N'2026-07-17', N'2026-07-17', 2, N'Fahmi Akbar', N'PBCCM', N'Tiket MySSC', N'REQ000008451190', N'355/KPB1400/2026-S9
Organik pada arsip lama: Mayapati, Pjs. Manager PBCCM, PBCCM, 749524
Hostname: KPB02CR1210174');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD201DCSM', N'HP PROBOOK 430 G8', N'Fahmi Akbar');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHHWK0CCXFZ996', N'', N'Fahmi Akbar');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 116/KPB3240/2026-S0', 1, N'2026-07-17', N'2026-07-17', 2, N'Herman', N'PBCCM', N'Tiket MySSC', N'REQ000008457136', N'355/KPB1400/2026-S9
Organik pada arsip lama: Mayapati, Pjs. Manager PBCCM, PBCCM, 749524
Hostname: KPB02CR1210092');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD201DCV5', N'HP PROBOOK 430 G8', N'Herman');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHHRE0A1RG2B0O', N'', N'Herman');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 117/KPB2000/2026-S0', 1, N'2026-07-21', N'2026-07-21', 2, N'Yoga Agustian Herlambang', N'Jr Assistant I Material & Analyst Data', N'System Completion - Production II', N'756396', N'Tiket MySSC', N'REQ000008471274', N'Pemberian Printer Supplies tinta Yellow 1 pcs untuk RDP 28
Sesuai request ticket');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Pemberian Printer Supplies tinta Yellow 1 pcs untuk RDP 28', N'Printer Supplies', N'Yoga Agustian Herlambang', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 118/KPB3240/2026-S0', 1, N'2026-07-22', N'2026-07-22', 2, N'Muhammad Firmansyah', N'HSSE Lawe-Lawe', N'Nomor Memo', N'243/KPB0100/2026-S0', N'Organik pada arsip lama: Febriardy, Manager HSSE Lawe-Lawe, HSSE Lawe-Lawe, 19020187
Hostname: KPB02CR1230058');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD329BJ0R', N'HP EliteBook 630 G9', N'Muhammad Firmansyah');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHGRE0D3GI7X3L', N'', N'Muhammad Firmansyah');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 119/KPB3240/2026-S0', 1, N'2026-07-22', N'2026-07-22', 2, N'Efran Hanif Piawang', N'HSSE Lawe-Lawe', N'Nomor Memo', N'243/KPB0100/2026-S0', N'Organik pada arsip lama: Febriardy, Manager HSSE Lawe-Lawe, HSSE Lawe-Lawe, 19020187
Hostname: KPB02CR1219078');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD201DCS0', N'HP PROBOOK 430 G8', N'Efran Hanif Piawang');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHHRE0A5RFYTWF', N'', N'Efran Hanif Piawang');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 120/KPB3240/2026-S0', 1, N'2026-07-24', N'2026-07-24', 2, N'Bayu Setiawan', N'System Completion', N'Nomor Memo', N'095/KPB2200/2026-S9', N'Organik pada arsip lama: Roland Joshua Panjaitan, Manager ISBL & Revamp, System Completion, 746582
Hostname: KPB02CR1219003');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD2041WZ5', N'HP PROBOOK 440 G8', N'Bayu Setiawan');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'G22RU', N'', N'Bayu Setiawan');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 121/KPB2000/2026-S0', 1, N'2026-07-17', N'2026-07-17', 2, N'Sugeng Priambodo', N'Sr Officer II Field HSSE Onshore', N'HSSE Lawe Lawe', N'725277', N'Tiket MySSC', N'REQ000008525564', N'Pemberian Printer Supplies tinta Hitam 1 merek HP Office jet Pro 7720 Untuk HSSE Lawe Lawe
Sesuai request ticket');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Pemberian Printer Supplies tinta Hitam 1 merek HP Office jet Pro 7720 Untuk HSSE Lawe Lawe', N'Printer Supplies', N'Sugeng Priambodo', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 122/KPB3240/2026-S0', 1, N'2026-07-30', N'2026-07-30', 2, N'Laura Ayu Berlian Hutagalung', N'System Completion', N'Nomor Memo', N'218/KPB2200/2026-S9', N'Organik pada arsip lama: Mohammad Taufiq Ridho, Manager CSU Process, System Completion, 746578
Hostname: KPB02CR1230086');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD347BBQT', N'HP EliteBook 630 G9', N'Laura Ayu Berlian Hutagalung');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHHWK0CDDIO336', N'', N'Laura Ayu Berlian Hutagalung');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, Deskripsi)
VALUES (N'BAST 123/KPB3240/2026-S0', 1, N'2026-07-31', N'2026-07-31', 2, N'Mochammad Helmy Aditya', N'Engineer I Process Unit RFCC Complex', N'System Completion - RFCC', N'754988', N'Email by ATD Dir. Ops.
Hostname: KPB - AnkerPowerConf');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Email by ATD Dir. Ops.', N'AFNNNB0E35100745', N'', N'Mochammad Helmy Aditya');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 124/KPB2000/2026-S0', 1, N'2026-08-03', N'2026-08-03', 2, N'Abdul Rachman Saleh', N'Sr Supervisor Steam & Power Generation', N'RU V Balikpapan. Utilities Office', N'747097', N'Tiket MySSC', N'REQ000008523197', N'Pemberian Printer Supplies tinta 1 Hitam dan 1 Merah merek HP Office jet Pro 7720
Sesuai request ticket');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Pemberian Printer Supplies tinta 1 Hitam dan 1 Merah merek HP Office jet Pro 7720', N'Printer Supplies', N'Abdul Rachman Saleh', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 125/KPB3240/2026-S0', 1, N'2026-08-03', N'2026-08-03', 2, N'Gabriel Jeremia Mardolina', N'System Completion', N'Nomor Memo', N'218/KPB2200/2026-S9', N'Organik pada arsip lama: Lis Sugiantoro, Manager Technical Support, System Completion, 747536
Hostname: KPB02CR1210027');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD2041WQK', N'HP PROBOOK 440 G8', N'Gabriel Jeremia Mardolina');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'G2PVI', N'', N'Gabriel Jeremia Mardolina');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 126/KPB3240/2026-S0', 1, N'2026-08-04', N'2026-08-04', 2, N'Putri Sherina Amelia', N'Legal & Compliance', N'Nomor Memo', N'117/KPB0200/2026-S8', N'Organik pada arsip lama: Asep Sulaeman, Pjs. Manager Legal & Compliance, Legal & Compliance, 744591
Hostname: KPB02CR1210127');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD201DCVH', N'HP PROBOOK 440 G8', N'Putri Sherina Amelia');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'KG2PVI', N'', N'Putri Sherina Amelia');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 127/KPB3240/2026-S0', 1, N'2026-08-04', N'2026-08-04', 2, N'Kurniawan', N'VP SC', N'System Completion - DHT & HMU', N'746576', N'Nomor Memo', N'235/KPB2200/2025-S9', N'Organik pada arsip lama: Kurniawan, VP SC, 746576
Hostname: KPB/MODEM/DHT-HMU');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'22493J4000968', N'TPLINK 4g LTE ROUTER', N'Kurniawan');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'', N'TL-MR6400(APAC)', N'Kurniawan');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 128/KPB2000/2026-S0', 1, N'2026-08-06', N'2026-08-06', 2, N'Heru Kisworo', N'Ast Manager HSSE Const. & Pre-Comm. ISBL', N'HSSE', N'732518', N'Tiket MySSC', N'REQ000008550384', N'Pemberian Printer Supplies tinta merek HP 995XL Dan Blank Card 200pcs
Sesuai request ticket');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Pemberian Printer Supplies tinta merek HP 995XL Dan Blank Card 200pcs', N'Printer Supplies', N'Heru Kisworo', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 129/KPB3240/2026-S0', 1, N'2026-08-18', N'2026-08-18', 2, N'Mohammad Allvick Yusuf', N'Manager Procurement', N'HCCS - Procurement', N'749526', N'Nomor Memo', N'311/KPB3230/2026-S9', N'Organik pada arsip lama: Mohammad Allvick Yusuf, Manager Procurement, 749526
Hostname: KPB/MODEM/PROC');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'224A1L8003353', N'TPLINK 4g LTE ROUTER', N'Mohammad Allvick Yusuf');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Perangkat', N'224A1L8003249', N'TPLINK 4g LTE ROUTER', N'Mohammad Allvick Yusuf');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Monitor', N'', N'TL-MR6400(APAC)', N'Mohammad Allvick Yusuf');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 130/KPB3240/2026-S0', 1, N'2026-08-19', N'2026-08-19', 2, N'Bramastra Banuboro', N'System Completion', N'Nomor Memo', N'106/KPB2200/2025-S9', N'Organik pada arsip lama: Lis Sugiantoro, Manager Technical Support, System Completion, 747536
Hostname: KPB02CR1210059');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD201DCT4', N'HP PROBOOK 430 G8', N'Bramastra Banuboro');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'G233Z', N'', N'Bramastra Banuboro');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 131/KPB3240/2026-S0', 1, N'2026-08-19', N'2026-08-19', 2, N'Aldela Hariyanniko', N'System Completion', N'Nomor Memo', N'124/KPB2200/2026-S9', N'Organik pada arsip lama: Roland Joshua Panjaitan, Manager ISBL & Revamp, System Completion, 746582
Hostname: KPB02CR1210076');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD201DCW2', N'HP PROBOOK 430 G8', N'Aldela Hariyanniko');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHHRE0A1RG2AO7', N'', N'Aldela Hariyanniko');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 132/KPB3240/2026-S0', 1, N'2026-08-22', N'2026-08-22', 2, N'Reservasi BAST Fahmi', N'Kode unit pada nomor tidak tercatat pada arsip lama.');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Perangkat', N'', N'Reservasi BAST Fahmi', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab)
VALUES (N'BAST 133/KPB3240/2026-S0', 1, N'2026-08-26', N'2026-08-26', 2, N'Tinta Printer 7740 Yellow & Black');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Perangkat', N'', N'Tinta Printer 7740 Yellow & Black', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, Deskripsi)
VALUES (N'BAST 134/KPB3240/2026-S0', 1, N'2026-08-26', N'2026-08-26', 2, N'Yoga Agustian Herlambang', N'Jr Assistant I Material & Analyst Data', N'System Completion - Production II', N'756396', N'Tinta Printer 7740 Black, Red, Cyan 1Pcs');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Tinta Printer 7740 Black, Red, Cyan 1Pcs', N'', N'Yoga Agustian Herlambang', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, Deskripsi)
VALUES (N'BAST 135/KPB3240/2026-S0', 1, N'2026-08-26', N'2026-08-26', 2, N'Inshanu Ghalih Wibowo', N'Engineer I Field Mechanical & Piping', N'Construction Balikpapan OSBL', N'755346', N'Tinta Printer 7740 Magenta 1 Pcs');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Tinta Printer 7740 Magenta 1 Pcs', N'', N'Inshanu Ghalih Wibowo', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Jabatan, FungsiDirektorat, NoPekerja, Deskripsi)
VALUES (N'BAST 136/KPB3240/2026-S0', 1, N'2026-08-26', N'2026-08-26', 2, N'Edward Gustaf', N'Jr Engineer II Proc.Unit GSH,Al.&SourTr.', N'System Completion - ISBL & Revamp', N'13107618', N'Tinta Printer 7740 Black 2 Pcs Langkat 30');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Tinta Printer 7740 Black 2 Pcs Langkat 30', N'', N'Edward Gustaf', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, Deskripsi)
VALUES (N'BAST 137/KPB3240/2026-S0', 1, N'2026-08-28', N'2026-08-28', 2, N'Subiyantoro', N'HP KILANG DIRKEU
Kode unit pada nomor tidak tercatat pada arsip lama.');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'HP KILANG DIRKEU', N'KKSTEX201230267', N'', N'Subiyantoro');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 138/KPB3240/2026-S0', 1, N'2026-08-31', N'2026-08-31', 2, N'Andre Antonius', N'System Completion', N'Nomor Memo', N'256/KPB2200/2026-S9', N'Organik pada arsip lama: Lis Sugiantoro, Pjs. Manager Comm.&Start Up (CSU) Non-Process, System Completion, 747536
Hostname: KPB02CR1230001');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD329BJ22', N'HP EliteBook 630 G9', N'Andre Antonius');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHGRE0D3GI7X9K', N'', N'Andre Antonius');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 139/KPB3240/2026-S0', 1, N'2026-08-31', N'2026-08-31', 2, N'M. Febri Setio Wajib', N'System Completion', N'Nomor Memo', N'256/KPB2200/2026-S9', N'Organik pada arsip lama: Lis Sugiantoro, Pjs. Manager Comm.&Start Up (CSU) Non-Process, System Completion, 747536
Hostname: KPB02CR1230003');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD329BJ2Z', N'HP EliteBook 630 G9', N'M. Febri Setio Wajib');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHGRE0D3GI7X6H', N'', N'M. Febri Setio Wajib');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 140/KPB3240/2026-S0', 1, N'2026-08-31', N'2026-08-31', 2, N'Lukman Wahyu Firmansyach', N'System Completion', N'Nomor Memo', N'256/KPB2200/2026-S9', N'Organik pada arsip lama: Lis Sugiantoro, Pjs. Manager Comm.&Start Up (CSU) Non-Process, System Completion, 747536
Hostname: KPB02CR1210146');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD201DCS1', N'HP PROBOOK 430 G8', N'Lukman Wahyu Firmansyach');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHHWK0CCXFZ985', N'', N'Lukman Wahyu Firmansyach');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 141/KPB3240/2026-S0', 1, N'2026-08-31', N'2026-08-31', 2, N'Audia Ardi Nugraha', N'System Completion', N'Nomor Memo', N'256/KPB2200/2026-S9', N'Organik pada arsip lama: Lis Sugiantoro, Pjs. Manager Comm.&Start Up (CSU) Non-Process, System Completion, 747536
Hostname: KPB02CR1210058');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD201DCS2', N'HP PROBOOK 430 G8', N'Audia Ardi Nugraha');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'5RFYTPX', N'', N'Audia Ardi Nugraha');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket, Deskripsi)
VALUES (N'BAST 142/KPB3240/2026-S0', 1, N'2026-08-31', N'2026-08-31', 2, N'Valentino Ardianto', N'System Completion', N'Nomor Memo', N'256/KPB2200/2026-S9', N'Organik pada arsip lama: Lis Sugiantoro, Pjs. Manager Comm.&Start Up (CSU) Non-Process, System Completion, 747536
Hostname: KPB02CR1219003');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD2041WZ5', N'HP PROBOOK 440 G8', N'Valentino Ardianto');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'G22RU', N'', N'Valentino Ardianto');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket)
VALUES (N'BAST 143/KPB3240/2026-S0', 1, N'2026-09-02', N'2026-09-02', 2, N'HSSE Langkat 69', N'HSSE', N'Tiket MySSC', N'REQ000008550384');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Tinta 7740', N'HP Tinta 7740', N'HSSE Langkat 69', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, JenisTiket, NoTiket)
VALUES (N'BAST 144/KPB3240/2026-S0', 1, N'2026-09-02', N'2026-09-02', 2, N'NATHANIA', N'HSSE LAWE', N'Tiket MySSC', N'REQ000008621091');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, MerkType, Pengguna, SerialNumber) VALUES (@id, N'Tinta 7740', N'HP Tinta 7740', N'NATHANIA', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, NamaPenanggungJawab, FungsiDirektorat, Deskripsi)
VALUES (N'BAST 145/KPB3240/2026-S0', 1, N'2026-09-07', N'2026-09-07', 2, N'Muhammad Al Fahri', N'IT', N'Organik pada arsip lama: Dias Natawan Gita, Ast Manager IT, IT, 749574
Hostname: KPB02CR1210121');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Notebook / PC', N'5CD201DCSV', N'HP PROBOOK 430 G8', N'Muhammad Al Fahri');
INSERT INTO BarangSurat (SuratId, NamaBarang, SerialNumber, MerkType, Pengguna) VALUES (@id, N'Adaptor', N'WHHWK0CCXFZ98Q', N'', N'Muhammad Al Fahri');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 001/KPB3240/2026-S0', 7, N'2026-01-05', N'2026-01-05', 2, N'Zakki Firdaus', N'Zakki Firdaus', 3, N'Hostname: KPB02CR1230120');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Tas', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'LAN Connector', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 002/KPB3240/2026-S0', 7, N'2026-01-05', N'2026-01-05', 2, N'Defiani Putri Denanti', N'Defiani Putri Denanti', 3, N'Hostname: KPB01CR4210067');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CKC4', N'HP Prodesk G7 Micro Tower', N'PC Desktop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ20200FY', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 003/KPB3240/2026-S0', 7, N'2026-01-05', N'2026-01-05', 2, N'Defiani Putri Denanti', N'Defiani Putri Denanti', 3, N'Hostname: KPB02CR1210145');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CKC4', N'HP Prodesk G7 Micro Tower', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ20200FY', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Tas', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Charger', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 004/KPB3240/2026-S0', 7, N'2026-01-07', N'2026-01-07', 2, N'Nikko Aditya Yudha Kusuma', N'Nikko Aditya Yudha Kusuma', 1, N'Hostname: KPB01CR4230015');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'UDVWNSD02330801A650601', N'Acer Veriton X2690G', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'MMLXKSS007245123E04248', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 005/KPB3240/2026-S0', 7, N'2026-01-07', N'2026-01-07', 2, N'Alwi Aprisha', N'Alwi Aprisha', 1, N'Hostname: KPB01CR4230017');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'UDVWNSD02330801A870601', N'Acer Veriton X2690G', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'MMLXKSS007245126564248', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 006/KPB3240/2026-S0', 7, N'2026-01-07', N'2026-01-07', 2, N'Hadi Nur Ubaedilah', N'Hadi Nur Ubaedilah', 3, N'Hostname: KPB01CR4210002');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CKDQ', N'HP Prodesk G7 Micro Tower', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ20118YY', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 007/KPB3240/2026-S0', 7, N'2026-01-14', N'2026-01-14', 2, N'Jihad Syaifulloh Satyagama', N'Jihad Syaifulloh Satyagama', 3, N'Hostname: KPB02CR1230036');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD329BJ2N', N'', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'WHGRE0D3GI7X90', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Chainlock', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'HP EliteBook 630 G9', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId)
VALUES (N'BAPB 008/KPB3240/2026-S0', 5, N'2026-01-14', N'2026-01-14', 2, N'Berca', N'Berca', 3);
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD2041WQB', N'', NULL, N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId)
VALUES (N'BAPB 009/KPB3240/2026-S0', 5, N'2026-01-20', N'2026-01-20', 2, N'Berca', N'Berca', 3);
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD329BJ0L', N'', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 010/KPB3240/2026-S0', 7, N'2026-01-20', N'2026-01-20', 2, N'Achmad Wahyu Rizky Widharyanto', N'Achmad Wahyu Rizky Widharyanto', 1, N'Hostname: KPB02CR1210020');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD2041WQJ', N'', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 011/KPB3240/2026-S0', 7, N'2026-01-30', N'2026-01-30', 2, N'Muhammad Reza Marendha', N'Muhammad Reza Marendha', 1, N'Hostname: KPB01CO2240118');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'PW0BYRBT', N'', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'8SSA10R16921C2TJ44A0B9E', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Konektor LAN', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 012/KPB3240/2026-S0', 7, N'2026-01-30', N'2026-01-30', 2, N'Olgha Meitha Tambayong', N'Olgha Meitha Tambayong', 1, N'Hostname: KPB01CO2240118');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCTF', N'', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'WHHRE0A1RG2B0Y', N'', N'Adaptor', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 013/KPB3240/2026-S0', 7, N'2026-01-30', N'2026-01-30', 2, N'Ahmad Ridha Akbar', N'Ahmad Ridha Akbar', 1, N'Hostname: KPB01CR4230013');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'UDVWNSD02330801A510601', N'', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'MMLXKSS007245123F94248', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 014/KPB3240/2026-S0', 7, N'2026-02-19', N'2026-02-19', 2, N'M. Fahrun Richardsa L.', N'M. Fahrun Richardsa L.', 1, N'Hostname: KPB01CR4230016');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'UDVWNSD023308018D30601', N'', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'MMLXKSS007245123F64248', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 015/KPB3240/2026-S0', 7, N'2026-02-19', N'2026-02-19', 2, N'M. Fahrun Richardsa L.', N'M. Fahrun Richardsa L.', 1, N'Hostname: KPB01CR4230053');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'UDVWNSD03A325002250601', N'', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'MMLXKSS007245122CE4248', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 016/KPB3240/2026-S0', 7, N'2026-02-19', N'2026-02-19', 2, N'M. Fahrun Richardsa L.', N'M. Fahrun Richardsa L.', 1, N'Hostname: KPB01CR4230058');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'UDVWNSD03A325002380601', N'', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'MMLXKSS007245122D04248', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 017/KPB3240/2026-S0', 7, N'2026-02-19', N'2026-02-19', 2, N'M. Fahrun Richardsa L.', N'M. Fahrun Richardsa L.', 1, N'Hostname: KPB01CR4230048');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'UDVWNSD03A325002530601', N'', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'MMLXKSS007245122F14248', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId)
VALUES (N'BAPB 018/KPB3240/2026-S0', 5, N'2026-02-23', N'2026-02-23', 2, N'berca', N'berca', 3);
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCRQ', N'', N'laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD2041WV4', N'', N'laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'perbaikan', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'backpack', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima)
VALUES (N'BAPB 019/KPB3240/2026-S0', 7, N'2026-02-24', N'2026-02-24', 2, N'Fadli Efendi', N'Fadli Efendi');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CKCK', N'', N'PC Desktop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CKDP', N'', N'PC Desktop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CK8W', N'', N'PC Desktop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CK9Q', N'', N'PC Desktop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ201190V', N'', NULL, N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ20119WN', N'', NULL, N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ2011919', N'', NULL, N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ20200G1', N'', NULL, N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 020/KPB3240/2026-S0', 7, N'2026-03-02', N'2026-03-02', 2, N'Bernando', N'Bernando', 1, N'Hostname: -');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', NULL, N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 021/KPB3240/2026-S0', 7, N'2026-02-24', N'2026-02-24', 2, N'Fadli Efendi', N'Fadli Efendi', N'Hostname: KPB02CR1210127');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCVH', N'', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'WHHRE0A1RG2AP3', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'chainlock', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 022/KPB3240/2026-S0', 7, N'2026-02-24', N'2026-02-24', 2, N'Fadli Efendi', N'Fadli Efendi', N'Hostname: KPB02CR1210127');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD2041WQK', N'', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'G235I', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'adaptor', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 023/KPB3240/2026-S0', 7, N'2026-02-24', N'2026-02-24', 2, N'Yens Mody Keint', N'Yens Mody Keint', N'Hostname: KPB01CR4210091');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CKD2', N'', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ20118ZD', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 024/KPB3240/2026-S0', 7, N'2026-02-27', N'2026-02-27', 2, N'Agus Bhudiman', N'Agus Bhudiman', N'Hostname: KPB02CR1210037');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD2041WYB', N'', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'G22O0', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Chainlock', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 025/KPB3240/2026-S0', 7, N'2026-02-27', N'2026-02-27', 2, N'Hari Cahyono Basuki', N'Hari Cahyono Basuki', N'Hostname: KPB02CR1230086');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD347BBQT', N'', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'WHHWK0CDDIO336', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Chainlock', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 026/KPB3240/2026-S0', 7, N'2026-03-11', N'2026-03-11', 2, N'Samuel LB. Parura', N'Samuel LB. Parura', N'Hostname: KPB02CR1210069');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCRF', N'', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'WHHWK0CCXFZ9AA', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Chainlock', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 027/KPB3240/2026-S0', 7, N'2026-03-17', N'2026-03-17', 2, N'Albert Sitanggang', N'Albert Sitanggang', N'Hostname: KPB01CO2240127');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'PW0BYNDH', N'', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'8SSA10R16961A1WH45D06LC', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Chainlock', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 028/KPB3240/2026-S0', 7, N'2026-03-17', N'2026-03-17', 2, N'Aria Rahmadin', N'Aria Rahmadin', N'Hostname: KPB01CO2240112');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'PW0BYNHA', N'', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'8SSA10R16961A1WH45D06S7', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Chainlock', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 029/KPB3240/2026-S0', 7, N'2026-03-26', N'2026-03-26', 2, N'Arjul Sanota Misri', N'Arjul Sanota Misri', N'Hostname: KPB01CR4230023');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'UDVWNSD03A325002880601', N'', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'MMLXKSS007245122EB4248', N'', N'Monitro', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 030/KPB3240/2026-S0', 7, N'2026-03-26', N'2026-03-26', 2, N'M Akzan Eka Saputra', N'M Akzan Eka Saputra', N'Hostname: KPB01CR4210041');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CKBQ', N'', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ20118Z7', N'', N'Monitro', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 031/KPB3240/2026-S0', 7, N'2026-03-26', N'2026-03-26', 2, N'Deybi Teneh', N'Deybi Teneh', N'Hostname: KPB02CR1210075');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCSR', N'', N'notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'WHHWK0CCXFZ994', N'', N'tas', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'charger', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'chainlock', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 032/KPB3240/2026-S0', 7, N'2026-03-26', N'2026-03-26', 2, N'Muhammad Reyhan Syaban', N'Muhammad Reyhan Syaban', N'Hostname: KPB02CR1219026');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD2041WZ3', N'', N'notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'G232J/WHGRE0FGCK7A9F', N'', N'tas', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'charger', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'chainlock', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId)
VALUES (N'BAPB 033/KPB3240/2026-S0', 5, N'2026-04-07', N'2026-04-07', 2, N'Berca', N'Berca', 3);
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD2041WPY', N'', N'notebook 5', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD2041WW4', N'', N'pc 1', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD2041WZ3', N'', NULL, N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD329BJ2N', N'', NULL, N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CKBR', N'', NULL, N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId)
VALUES (N'BAPB 034/KPB3240/2026-S0', 7, N'2026-04-08', N'2026-04-08', 2, N'Sarah Putirtama', N'Sarah Putirtama', 3);
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CKBD', N'', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Kabel', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId)
VALUES (N'BAPB 035/KPB3240/2026-S0', 7, N'2026-04-14', N'2026-04-14', 2, N'Desmon Irpanta Ropiktus Tambunan', N'Desmon Irpanta Ropiktus Tambunan', 3);
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'UDVWNSD03A325002530601', N'', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'MMLXKSS007245122F64248', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Kabel', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 036/KPB3240/2026-S0', 5, N'2026-04-20', N'2026-04-20', 2, N'PT Berca Hardayaperkasa', N'PT Berca Hardayaperkasa', N'3 laptop rusak dan 1 mouse');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Laptop', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 037/KPB3240/2026-S0', 7, N'2026-04-20', N'2026-04-20', 2, N'Dinda Fadhya Darmidjas', N'Dinda Fadhya Darmidjas', 1, N'Pengalihan ke Monica Sari');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'PW0BYRAG', N'', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'8SSA10R16921C2TJ44A0AKM', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keylock', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 038/KPB3240/2026-S0', 7, N'2026-04-22', N'2026-04-22', 2, N'Medi Saputra', N'Medi Saputra', 1, N'Pengembalian
Hostname: KPB01CR4230015');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'UDVWNSD02330801A650601', N'Veriton X2690G', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'MMLXKSS007245126564248', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 039/KPB3240/2026-S0', 7, N'2026-04-22', N'2026-04-22', 2, N'Irfan Zidny Hanief', N'Irfan Zidny Hanief', 1, N'Pengembalian
Hostname: KPB01CR4230085');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'UDVWNSD03P33400C0A0601', N'Veriton X2690G', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'URTYESD002335005170601', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 040/KPB3240/2026-S0', 7, N'2026-04-22', N'2026-04-22', 2, N'Ayub Siswantoro', N'Ayub Siswantoro', 1, N'Pengembalian
Hostname: KPB01CR4230009');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'UDVWNSD023308019150601', N'Veriton X2690G', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'MMLXKSS007245126524248', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 041/KPB3240/2026-S0', 7, N'2026-04-22', N'2026-04-22', 2, N'Risma Reni Juwita', N'Risma Reni Juwita', 1, N'Pengembalian
Hostname: KPB01CR4230037');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'UDVWNSD03A325002750601', N'Veriton X2690G', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'MMLXKSS007245122D54248', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 042/KPB3240/2026-S0', 7, N'2026-04-22', N'2026-04-22', 2, N'Makhruji', N'Makhruji', 1, N'Pengembalian
Hostname: KPB01CR4230071');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'UDVWNSD03P33400B090601', N'Veriton X2690G', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'MMLXKSS007245122E14248', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 043/KPB3240/2026-S0', 7, N'2026-02-27', N'2026-02-27', 2, N'Noor Ida Hayati', N'Noor Ida Hayati', N'Hostname: KPB02CR1210009');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD2041WQ7', N'', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'G234R', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Chainlock', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 044/KPB3240/2026-S0', 5, N'2026-04-30', N'2026-04-30', 2, N'PT Berca Hardayaperkasa', N'PT Berca Hardayaperkasa', N'2 laptop rusak, 1 kabel sata, 1 kabel power adapter');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Laptop', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 045/KPB3240/2026-S0', 7, N'2026-04-30', N'2026-04-30', 2, N'Rifqi Rahmadani H', N'Rifqi Rahmadani H', 5, N'Balikin karna tidak lanjut kontrak');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'871TUZ5681', N'', N'HT', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5900911', N'', NULL, N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 046/KPB3240/2026-S0', 7, N'2026-05-04', N'2026-05-04', 2, N'Dhodik Widyanto', N'Dhodik Widyanto', 1, N'Hostname: KPB01CO2240068');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'PW0BYRBD', N'', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Ethernet C', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 047/KPB3240/2026-S0', 7, N'2026-05-04', N'2026-05-04', 2, N'Rifqi Rahmadani Husda', N'Rifqi Rahmadani Husda', 1, N'Hostname: KPB01CO2240068');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'PW09KDNM', N'', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Ethernet C', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 048/KPB3240/2026-S0', 7, N'2026-05-05', N'2026-05-05', 2, N'Bernando', N'Bernando', N'kembali laptop backup sm5');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Laptop', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 049/KPB3240/2026-S0', 7, N'2026-04-23', N'2026-04-23', 2, N'iwan dwi nurcahyo', N'iwan dwi nurcahyo', N'kembali monitor');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Laptop', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 050/KPB3240/2026-S0', 7, N'2026-05-06', N'2026-05-06', 2, N'I Ketut Warsa', N'I Ketut Warsa', N'Kembali perangkat sm kpb');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Laptop', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 051/KPB3240/2026-S0', 7, N'2026-05-06', N'2026-05-06', 2, N'Ronny Kumendong', N'Ronny Kumendong', N'Kembali perangkat sm kpb');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Laptop', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 052/KPB3240/2026-S0', 7, N'2026-05-25', N'2026-05-25', 2, N'Zainal Ariffin', N'Zainal Ariffin', N'Kembali perangkat sm kpb
Hostname: KPB02CR1230021');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD329BJ1R', N'HP EliteBook 630 G9', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'KPB02CR1230021', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 053/KPB3240/2026-S0', 7, N'2026-05-25', N'2026-05-25', 2, N'Najib Rahman', N'Najib Rahman', N'Kembali perangkat sm kpb
Hostname: KPB02CR1219078');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCS0', N'HP PROBOOK 430 G8', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'WHHRE0A5RFYTWF', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 054/KPB3240/2026-S0', 7, N'2026-05-26', N'2026-05-26', 2, N'Alfi Fadillah', N'Alfi Fadillah', N'Kembali perangkat sm kpb
Hostname: KPB02CR1210106');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCVB', N'HP PROBOOK 430 G8', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'WHHRE0A1RG2B13', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 055/KPB3240/2026-S0', 7, N'2026-05-29', N'2026-05-29', 2, N'Wahyu Ari Sudiatmoko', N'Wahyu Ari Sudiatmoko', N'Kembali perangkat sm kpb
Hostname: KPB02CR1230074');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD329BJ0V', N'HP EliteBook 630 G9', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 056/KPB3240/2026-S0', 7, N'2026-05-29', N'2026-05-29', 2, N'Aditya Yusuf Mahardika', N'Aditya Yusuf Mahardika', N'Kembali perangkat sm kpb
Hostname: KPB02CR1210174');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCSM', N'HP PROBOOK 430 G8', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima)
VALUES (N'BAPB 057/KPB3240/2026-S0', 7, N'2026-05-29', N'2026-05-29', 2, N'Aditya Yusuf Mahardika', N'Aditya Yusuf Mahardika');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'871TVK0497', N'', N'HT MOtorola', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'592014', N'', NULL, N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 058/KPB3240/2026-S0', 5, N'2026-06-02', N'2026-06-02', 2, N'PT Berca Hardayaperkasa', N'PT Berca Hardayaperkasa', N'1 laptop rusak, 2 mouse');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCS0', N'HP PROBOOK 430 G8', N'Laptop', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 059/KPB3240/2026-S0', 7, N'2026-06-02', N'2026-06-02', 2, N'Muhammad Nur Islami', N'Muhammad Nur Islami', 1, N'pengembalian laptop dihandover ke pekerja lainnya');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'PW05ZKJ0', N'L13 Gen 3', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Charger', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Wireless Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Ethernet C', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 060/KPB3240/2026-S0', 7, N'2026-06-02', N'2026-06-02', 2, N'Agus Syahroni', N'Agus Syahroni', 1, N'pengembalian laptop dihandover ke pekerja lainnya');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'PW0BYR8J', N'L13 Gen 4', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Charger', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Wireless Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Ethernet C', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 061/KPB3240/2026-S0', 7, N'2026-06-02', N'2026-06-02', 2, N'Anggi Ramadan', N'Anggi Ramadan', 1, N'pengembalian laptop dihandover ke pekerja lainnya');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'PW09BHTJ', N'L13 Gen 4', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Charger', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Wireless Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Ethernet C', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 062/KPB3240/2026-S0', 7, N'2026-06-10', N'2026-06-10', 2, N'Ilyas Fatih Ramadhan', N'Ilyas Fatih Ramadhan', 3, N'Resign');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCW2', N'HP PROBOOK 430 G8', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Charger', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Chainlock', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 063/KPB3240/2026-S0', 7, N'2026-06-12', N'2026-06-12', 2, N'Anggi Budiono Putro', N'Anggi Budiono Putro', 3, N'Hostname: KPB02CR1230006');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD329BJ1T', N'HP EliteBook 630 G9', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'WHGRE0D3GI7X8G', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Chainlock', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 064/KPB3240/2026-S0', 7, N'2026-06-17', N'2026-06-17', 2, N'Rian Hidayatullah Kasuma', N'Rian Hidayatullah Kasuma', 3, N'Perangkat IT dikembalikan karena user Resign
Hostname: KPB02CR1210096');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCR8', N'HP PROBOOK 430 G8', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'WHHWK0CCXFZ97T', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Chainlock', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima)
VALUES (N'BAPB 065/KPB3240/2026-S0', 7, N'2026-06-17', N'2026-06-17', 2, N'Rian Hidayatullah Kasuma', N'Rian Hidayatullah Kasuma');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'871TTP8565', N'', NULL, N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'590036', N'', NULL, N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 066/KPB3240/2026-S0', 7, N'2026-06-18', N'2026-06-18', 2, N'Vicky Husein Sirait', N'Vicky Husein Sirait', N'Penarikan & Perangkat dialihkan
Hostname: KPB01CR4230027');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'PC', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 067/KPB3240/2026-S0', 7, N'2026-06-18', N'2026-06-18', 2, N'Dean Kayuwanan', N'Dean Kayuwanan', 3, N'laptop backup proc balik');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CG1056326', N'', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Charger', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 068/KPB3240/2026-S0', 7, N'2026-06-18', N'2026-06-18', 2, N'Akhmad Nurfaiz', N'Akhmad Nurfaiz', 3, N'laptop backup proc balik');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CG0112SFP', N'', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Charger', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 069/KPB3240/2026-S0', 5, N'2026-06-19', N'2026-06-19', 2, N'PT Berca Hardayaperkasa', N'PT Berca Hardayaperkasa', N'2 laptop rusak, 1 mouse');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCW2', N'HP PROBOOK 430 G8', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCR8', N'', NULL, N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 070/KPB3240/2026-S0', 7, N'2026-06-19', N'2026-06-19', 2, N'Farid Rawung', N'Farid Rawung', 3, N'Perangkat IT dikembalikan karena user resign
Hostname: KPB02CR1210007');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD2041WYR', N'HP PROBOOK 440 G8', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'G233Z', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Chainlock', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 071/KPB3240/2026-S0', 7, N'2026-06-19', N'2026-06-19', 2, N'Alham Ade Kurniawan', N'Alham Ade Kurniawan', 3, N'Perangkat IT dikembalikan karena perangkat dialihkan ke user lain
Hostname: KPB02CR1210035');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD2041WZJ', N'HP PROBOOK 440 G8', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'G22RH', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Chainlock', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 072/KPB3240/2026-S0', 7, N'2026-06-19', N'2026-06-19', 2, N'Hasan Basri', N'Hasan Basri', 3, N'Perangkat IT dikembalikan karena perangkat dialihkan ke user lain
Hostname: KPB02CR1230016');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD329BJ1C', N'HP EliteBook 630 G9', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'WHGRE0D3GI7X3D', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Chainlock', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 073/KPB3240/2026-S0', 7, N'2026-06-19', N'2026-06-19', 2, N'Heri Sulaiman', N'Heri Sulaiman', 3, N'Perangkat IT dikembalikan karena user resign
Hostname: KPB01CR4210049');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CKC0', N'HP Prodesk G7 Micro Tower', N'PC Desktop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ2011RNM', N'HP P204v', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 074/KPB3240/2026-S0', 7, N'2026-06-19', N'2026-06-19', 2, N'Muhammad Halmi', N'Muhammad Halmi', 3, N'Perangkat IT dikembalikan karena user resign
Hostname: KPB01CR4210048');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CKCZ', N'HP Prodesk G7 Micro Tower', N'PC Desktop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ20118D3', N'HP P204v', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 075/KPB3240/2026-S0', 7, N'2026-06-19', N'2026-06-19', 2, N'Fahtur Rahman', N'Fahtur Rahman', 3, N'Perangkat IT dikembalikan karena user resign
Hostname: KPB01CR4210042');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CKB4', N'HP Prodesk G7 Micro Tower', N'PC Desktop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ20118Z9', N'HP P204v', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 076/KPB3240/2026-S0', 7, N'2026-06-19', N'2026-06-19', 2, N'Miftahus Syifa', N'Miftahus Syifa', 3, N'Perangkat IT dikembalikan karena user resign
Hostname: KPB01CR4210017');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CKB0', N'HP Prodesk G7 Micro Tower', N'PC Desktop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ20118ZZ', N'HP P204v', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 077/KPB3240/2026-S0', 7, N'2026-06-19', N'2026-06-19', 2, N'Ekka Nurwana', N'Ekka Nurwana', 3, N'Perangkat IT dikembalikan karena user resign
Hostname: KPB01CR4210020');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CKCN', N'HP Prodesk G7 Micro Tower', N'PC Desktop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ20118ZM', N'HP P204v', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 078/KPB3240/2026-S0', 7, N'2026-06-19', N'2026-06-19', 2, N'Syarif Hidayatullah', N'Syarif Hidayatullah', 3, N'Perangkat IT dikembalikan karena user resign
Hostname: KPB01CR4210043');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CKB9', N'HP Prodesk G7 Micro Tower', N'PC Desktop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ20118D4', N'HP P204v', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 079/KPB3240/2026-S0', 7, N'2026-06-19', N'2026-06-19', 2, N'Ichsan Chairudin', N'Ichsan Chairudin', 3, N'Perangkat IT dikembalikan karena user resign
Hostname: KPB01CR4210021');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CKD1', N'HP Prodesk G7 Micro Tower', N'PC Desktop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ201190D', N'HP P204v', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 080/KPB3240/2026-S0', 7, N'2026-06-23', N'2026-06-23', 2, N'Sandi Fauzan Rachmat', N'Sandi Fauzan Rachmat', 1, N'tidak digunakna lagi
Hostname: KPB01CR4210021');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'UDVWNSD023308019150601', N'Veriton X2690G', N'PC Desktop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'MMLXKSS007245122D14248', N'', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 081/KPB3240/2026-S0', 7, N'2026-06-23', N'2026-06-23', 2, N'Mohammad Choirul Mu''an', N'Mohammad Choirul Mu''an', 3, N'Perangkat IT dikembalikan karena tidak digunakan
Hostname: KPB01CR4210124');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CK95', N'HP Prodesk G7 Micro Tower', N'PC Desktop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ20200G9', N'HP P204v', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 082/KPB3240/2026-S0', 7, N'2026-06-26', N'2026-06-26', 2, N'Kardiman Rahardjo', N'Kardiman Rahardjo', 3, N'Perangkat IT dikembalikan karena user resign
Hostname: KPB02CR1210059');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCT4', N'HP PROBOOK 430 G8', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'XFZ9AH', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Chainlock', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 083/KPB3240/2026-S0', 7, N'2026-06-26', N'2026-06-26', 2, N'Willy Andrew', N'Willy Andrew', 3, N'Perangkat IT dikembalikan karena user resign
Hostname: KPB02CR1210058');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCS2', N'HP PROBOOK 430 G8', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5RFYTPX', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Chainlock', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 084/KPB3240/2026-S0', 5, N'2026-06-29', N'2026-06-29', 2, N'PT Berca Hardayaperkasa', N'PT Berca Hardayaperkasa', N'2 laptop rusak, 1 mouse');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCS2', N'HP PROBOOK 430 G8', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCT4', N'', NULL, N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 085/KPB3240/2026-S0', 7, N'2026-06-30', N'2026-06-30', 2, N'Suko Rahardjo', N'Suko Rahardjo', 3, N'Perangkat IT dikembalikan karena user resign
Hostname: KPB2011024');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CG0114T90', N'HP 240 G7', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'WHHWK0CCXGWN4Q', N'', N'Adaptor', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 086/KPB3240/2026-S0', 5, N'2026-07-14', N'2026-07-14', 2, N'PT Berca Hardayaperkasa', N'PT Berca Hardayaperkasa', N'1 laptop rusak,2 mouse');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCVM', N'HP PROBOOK 430 G8', N'Laptop', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 087/KPB3240/2026-S0', 7, N'2026-07-14', N'2026-07-14', 2, N'Arif Gunawan', N'Arif Gunawan', 3, N'Perangkat IT dikembalikan karena user resign
Hostname: KPB01CR4210007');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CKDW', N'HP Prodesk G7 Micro Tower', N'PC Desktop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ20200G2', N'HP P204v', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 088/KPB3240/2026-S0', 7, N'2026-07-22', N'2026-07-22', 2, N'Roland Joshua Panjaitan', N'Roland Joshua Panjaitan', 3, N'Pengembalian Perangkat
Hostname: -');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'CND9377419', N'HP Pavilion Gaming 15-dk0043TX', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'2121LZ90U6G8', N'HP', N'Adaptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'Logitech BCC-950', N'Camera', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 089/KPB3240/2026-S0', 5, N'2026-08-10', N'2026-08-10', 2, N'PT Berca Hardayaperkasa', N'PT Berca Hardayaperkasa', N'2 laptop rusak,3 mouse');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD329BJ0X', N'HP PROBOOK 430 G8', N'Laptop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD201DCRG', N'HP EliteBook 630 G9', NULL, N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 090/KPB3240/2026-S0', 7, N'2026-08-20', N'2026-08-20', 2, N'YOPPI SUTRISNA', N'YOPPI SUTRISNA', N'Pengembalian HT Rusak');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'871TVVF707', N'', NULL, N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima)
VALUES (N'BAPB 091/KPB3240/2026-S0', 7, N'2026-08-24', N'2026-08-24', 2, N'Aries purijatmiko', N'Aries purijatmiko');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'871TXF9124', N'', NULL, N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'80045', N'', NULL, N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 092/KPB3240/2026-S0', 7, N'2026-08-26', N'2026-08-26', 2, N'Bayu Mardhika Atmadi', N'Bayu Mardhika Atmadi', N'Hostname: KPB02CR1230001');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD329BJ22', N'', NULL, N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 093/KPB3240/2026-S0', 7, N'2026-08-28', N'2026-08-28', 2, N'Munadi Ihsan', N'Munadi Ihsan', 3, N'Perangkat IT dikembalikan karena user resign
Hostname: KPB02CR1230003');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'5CD329BJ2Z', N'HP EliteBook 630 G9', N'Notebook', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'WHGRE0D3GI7X6H', N'', N'Adaptor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Backpack', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, StaffId, Deskripsi)
VALUES (N'BAPB 094/KPB3240/2026-S0', 7, N'2026-08-28', N'2026-08-28', 2, N'Cerry Chentia Putri', N'Cerry Chentia Putri', 3, N'Perangkat IT dikembalikan karena pergantian
Hostname: KPB01CR4210082');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'4CE202CKCP', N'HP Prodesk G7 Micro Tower', N'PC Desktop', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'3CQ201190L', N'HP P204v', N'Monitor', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'VGA', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Mouse', N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'', N'', N'Keyboard', N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima)
VALUES (N'BAPB 095/KPB3240/2026-S0', 7, N'2026-08-28', N'2026-08-28', 2, N'Munadi Ihsan', N'Munadi Ihsan');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'871TWT7306', N'', NULL, N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, YangMenerima, Deskripsi)
VALUES (N'BAPB 096/KPB3240/2026-S0', 7, N'2026-09-01', N'2026-09-01', 2, N'M. Fachrudin Fadillah', N'M. Fachrudin Fadillah', N'ht rusak punya ru');
SET @id = SCOPE_IDENTITY();
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'871TVDP582', N'', NULL, N'', N'');
INSERT INTO BarangSurat (SuratId, Jumlah, Satuan, SerialNumber, MerkType, Keterangan, NamaBarang, Pengguna) VALUES (@id, 1, N'pcs', N'594030', N'', NULL, N'', N'');
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Deskripsi, TanggalBalp)
VALUES (N'BALP 001/KPB3240/2026-S0', 8, N'2026-12-06', N'2026-12-06', 2, N'BALP Sewa CCTV Periode Desember 2025', N'2026-12-06');
SET @id = SCOPE_IDENTITY();
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Deskripsi, TanggalBalp)
VALUES (N'BALP 002/KPB3240/2026-S0', 8, N'2026-02-03', N'2026-02-03', 2, N'BALP Sewa CCTV Periode Januari 2026', N'2026-02-03');
SET @id = SCOPE_IDENTITY();
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Deskripsi, TanggalBalp)
VALUES (N'BALP 003/KPB3240/2026-S0', 8, N'2026-02-23', N'2026-02-23', 2, N'BALP Berca Sm5 Periode Januari 2026', N'2026-02-23');
SET @id = SCOPE_IDENTITY();
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Deskripsi, TanggalBalp)
VALUES (N'BALP 004/KPB3240/2026-S0', 8, N'2026-02-03', N'2026-02-03', 2, N'BALP Sewa CCTV Periode Februari 2026', N'2026-02-03');
SET @id = SCOPE_IDENTITY();
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, Deskripsi, TanggalBalp)
VALUES (N'BALP 005/KPB3240/2026-S0', 8, N'2026-04-01', N'2026-04-01', 2, N'HUJ', N'BALP CCTV HUJ Periode Maret 2026', N'2026-04-01');
SET @id = SCOPE_IDENTITY();
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, Deskripsi, TanggalBalp)
VALUES (N'BALP 006/KPB3240/2026-S0', 8, N'2026-04-07', N'2026-04-07', 2, N'Berca Hardayaperkasa', N'BALP Berca Sm5 Periode Februari 2026', N'2026-04-07');
SET @id = SCOPE_IDENTITY();
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, Deskripsi, TanggalBalp)
VALUES (N'BALP 007/KPB3240/2026-S0', 8, N'2026-04-14', N'2026-04-14', 2, N'Berca Hardayaperkasa', N'BALP Berca Sm5 Periode Maret 2026', N'2026-04-14');
SET @id = SCOPE_IDENTITY();
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, Deskripsi, TanggalBalp)
VALUES (N'BALP 008/KPB3240/2026-S0', 8, N'2026-05-11', N'2026-05-11', 2, N'HUJ', N'BALP CCTV RDMP Sewa Bulan April 2026', N'2026-05-11');
SET @id = SCOPE_IDENTITY();
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, Deskripsi, TanggalBalp)
VALUES (N'BALP 009/KPB3240/2026-S0', 8, N'2026-05-18', N'2026-05-18', 2, N'Berca Hardayaperkasa', N'BALP Berca Hardayaperkasa SM5 April 2026', N'2026-05-18');
SET @id = SCOPE_IDENTITY();
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, Deskripsi, TanggalBalp)
VALUES (N'BALP 010/KPB3240/2026-S0', 8, N'2026-06-02', N'2026-06-02', 2, N'HUJ', N'BALP CCTV RDMP Sewa Bulan Mei 2026', N'2026-06-02');
SET @id = SCOPE_IDENTITY();
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, Deskripsi, TanggalBalp)
VALUES (N'BALP 011/KPB3240/2026-S0', 8, N'2026-07-01', N'2026-07-01', 2, N'Berca Hardayaperkasa', N'BALP CCTV RDMP Sewa Bulan Mei 2026', N'2026-07-01');
SET @id = SCOPE_IDENTITY();
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, Deskripsi, TanggalBalp)
VALUES (N'BALP 012/KPB3240/2026-S0', 8, N'2026-07-01', N'2026-07-01', 2, N'HUJ', N'BALP CCTV RDMP Sewa Bulan Juni 2026', N'2026-07-01');
SET @id = SCOPE_IDENTITY();
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, Deskripsi, TanggalBalp)
VALUES (N'BALP 013/KPB3240/2026-S0', 8, N'2026-07-31', N'2026-07-31', 2, N'Berca Hardayaperkasa', N'BALP Berca Juni 2026', N'2026-07-31');
SET @id = SCOPE_IDENTITY();
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, Deskripsi, TanggalBalp)
VALUES (N'BALP 014/KPB3240/2026-S0', 8, N'2026-08-03', N'2026-08-03', 2, N'HUJ', N'BALP CCTV Bulan Juli 2026', N'2026-08-03');
SET @id = SCOPE_IDENTITY();
INSERT INTO Surat (NomorSurat, JenisSuratId, Tanggal, CreatedAt, ManagerId, Tujuan, Deskripsi, TanggalBalp)
VALUES (N'BALP 015/KPB3240/2026-S0', 8, N'2026-09-01', N'2026-09-01', 2, N'HUJ', N'Sewa CCTV bulan Agustus 2026', N'2026-09-01');
SET @id = SCOPE_IDENTITY();

COMMIT;

SELECT j.Kode, j.NamaJenis, COUNT(*) AS Jml
FROM Surat s JOIN JenisSurat j ON j.Id = s.JenisSuratId
GROUP BY j.Kode, j.NamaJenis ORDER BY j.Kode, j.NamaJenis;

SELECT (SELECT COUNT(*) FROM Surat) AS Surat, (SELECT COUNT(*) FROM BarangSurat) AS Barang;
SELECT COUNT(*) AS NomorPakaiTitikNo FROM Surat WHERE NomorSurat LIKE '%No.%';
SELECT COUNT(*) AS TanpaManajer FROM Surat WHERE ManagerId IS NULL;
SELECT COUNT(*) AS BapbTanpaPenyerah FROM Surat WHERE JenisSuratId IN (5,7) AND YangMenerima IS NULL;
SELECT COUNT(*) AS BastPakaiJabatanOrangLain FROM Surat s JOIN JenisSurat j ON j.Id = s.JenisSuratId
WHERE j.Kode = 'BAST' AND s.NamaPenanggungJawab = s.YangMenerima
  AND ISNULL(s.Jabatan,'') <> ISNULL(s.JabatanYangMenerima,'');
