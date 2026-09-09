SET NOCOUNT ON;
PRINT '-- Data inti Docuflow: jenis surat, pengguna, dan counter nomor.';
PRINT '-- Dihasilkan otomatis dari basis data yang berjalan. Jalankan SETELAH 01-skema.sql.';
PRINT '-- Aman diulang: tiap baris hanya dimasukkan kalau belum ada.';
PRINT '';
PRINT 'SET NOCOUNT ON;';
PRINT 'SET XACT_ABORT ON;';
PRINT 'BEGIN TRANSACTION;';
PRINT '';
PRINT '-- ---------- JenisSurat ----------';
PRINT '-- Id ditulis tegas: CounterNomorSurat dan template cetak tidak memakai Id,';
PRINT '-- tapi Surat.JenisSuratId memakainya, jadi urutannya tidak boleh bergeser.';
PRINT 'SET IDENTITY_INSERT JenisSurat ON;';
SELECT 'IF NOT EXISTS (SELECT 1 FROM JenisSurat WHERE Id = ' + CAST(Id AS varchar) + ') INSERT INTO JenisSurat (Id, Kode, NamaJenis) VALUES ('
     + CAST(Id AS varchar) + ', N''' + REPLACE(Kode, '''', '''''') + ''', N''' + REPLACE(NamaJenis, '''', '''''') + ''');'
FROM JenisSurat ORDER BY Id;
PRINT 'SET IDENTITY_INSERT JenisSurat OFF;';
PRINT '';
PRINT '-- ---------- Users ----------';
PRINT '-- Password tersimpan sebagai hash BCrypt, bukan teks biasa. Tidak ada';
PRINT '-- halaman pendaftaran di aplikasi ini, jadi tanpa baris-baris ini basis';
PRINT '-- data yang baru tidak bisa dimasuki siapa pun.';
PRINT 'SET IDENTITY_INSERT Users ON;';
SELECT 'IF NOT EXISTS (SELECT 1 FROM Users WHERE Id = ' + CAST(Id AS varchar) + ') INSERT INTO Users (Id, Nama, Username, Password, Role, Jabatan, NomorPegawai) VALUES ('
     + CAST(Id AS varchar)
     + ', N''' + REPLACE(Nama, '''', '''''') + ''''
     + ', N''' + REPLACE(Username, '''', '''''') + ''''
     + ', N''' + REPLACE(Password, '''', '''''') + ''''
     + ', N''' + REPLACE(Role, '''', '''''') + ''''
     + ', ' + CASE WHEN Jabatan IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(Jabatan, '''', '''''') + '''' END
     + ', ' + CASE WHEN NomorPegawai IS NULL THEN 'NULL' ELSE 'N''' + REPLACE(NomorPegawai, '''', '''''') + '''' END
     + ');'
FROM Users ORDER BY Id;
PRINT 'SET IDENTITY_INSERT Users OFF;';
PRINT '';
PRINT '-- ---------- CounterNomorSurat ----------';
PRINT '-- NomorTerakhir = nomor TERAKHIR YANG TERPAKAI, bukan nomor berikutnya.';
PRINT '-- Salah menaruh angka di sini menerbitkan ulang nomor yang sudah dicetak.';
SELECT 'IF NOT EXISTS (SELECT 1 FROM CounterNomorSurat WHERE Kode = N''' + Kode + ''' AND Tahun = ' + CAST(Tahun AS varchar) + ')'
     + ' INSERT INTO CounterNomorSurat (Kode, Tahun, NomorTerakhir) VALUES (N''' + Kode + ''', ' + CAST(Tahun AS varchar) + ', ' + CAST(NomorTerakhir AS varchar) + ');'
FROM CounterNomorSurat ORDER BY Kode, Tahun;
PRINT '';
PRINT 'COMMIT;';
PRINT 'GO';
