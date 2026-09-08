-- Jabatan Ast. Manajer salah ketik sejak awal: tertulis "ICS", seharusnya "IT".
-- Nilainya ikut tercetak di kotak "Mengetahui" pada seluruh dokumen, dan
-- Services/JabatanUser.AstManager memakainya sebagai daftar putih — kalau
-- hanya salah satu yang diubah, orangnya hilang dari pilihan "Mengetahui".
SET NOCOUNT ON;
SET XACT_ABORT ON;

UPDATE Users SET Jabatan = N'Ast. Manajer IT | KPB'
WHERE Jabatan IN (N'AST. Manager ICS | PT. KPB', N'Ast Manager IT | PT. KPB');

-- Salah ketik yang sama pada jabatan staf: "ICS", seharusnya "IT" (2026-09-08).
-- Nilainya ikut tercetak di kotak "Diterima oleh" pada BAPB dan di kotak staf
-- pada BAST, dan juga ada di JabatanUser.Pilihan sebagai daftar putih.
UPDATE Users SET Jabatan = N'Staff IT | PT. KPB'
WHERE Jabatan = N'Staff ICS | PT. KPB';

SELECT CAST(Id AS varchar) + ' | ' + Nama + ' | ' + ISNULL(Jabatan,'-') FROM Users ORDER BY Id;
