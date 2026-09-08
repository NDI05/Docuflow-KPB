using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Docuflow_projectIT_KPB.Migrations
{
    /// <inheritdoc />
    public partial class GantiPosisiTtdJadiJabatan : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Urutan dibalik dari hasil scaffold, yang menghapus PosisiTtd LEBIH
            // DULU dan membuang isinya. Kolom baru dibuat, datanya dipindahkan,
            // baru kolom lama dibuang.
            migrationBuilder.AddColumn<string>(
                name: "Jabatan",
                table: "Users",
                type: "nvarchar(120)",
                maxLength: 120,
                nullable: true);

            // "Manager" jadi jabatan manajer, "Staff" jadi jabatan staf paling
            // umum. Kedua teks di bawah SENGAJA dibiarkan pada ejaan lamanya
            // ("ICS", diperbaiki jadi "IT" pada 8 September 2026 lewat
            // db/perbaiki-jabatan-manajer.sql): migration mencatat sejarah, dan
            // basis data yang sudah menerapkannya tidak akan menjalankannya lagi.
            // Pada basis data baru tabel Users masih kosong, jadi nilai ini
            // tidak pernah benar-benar tersimpan.
            // Dibungkus EXEC, bukan ditulis langsung: SQL Server mengompilasi
            // seluruh batch sebelum menjalankannya, jadi UPDATE yang menyebut
            // kolom hasil AddColumn di migration yang SAMA gagal dengan
            // "Invalid column name" — kolomnya belum ada saat kompilasi. Di
            // mesin pengembangan hal ini tidak terlihat karena `dotnet ef
            // database update` menjalankan tiap operasi sebagai batch sendiri;
            // yang gagal adalah `dotnet ef migrations script`, yakni satu-satunya
            // cara membangun skema ini dari nol di server produksi.
            migrationBuilder.Sql(@"
                EXEC(N'
                    UPDATE Users SET Jabatan =
                        CASE PosisiTtd
                            WHEN ''Manager'' THEN N''AST. Manager ICS | PT. KPB''
                            WHEN ''Staff''   THEN N''Staff ICS | PT. KPB''
                            ELSE NULL
                        END;');");

            migrationBuilder.DropColumn(
                name: "PosisiTtd",
                table: "Users");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "PosisiTtd",
                table: "Users",
                type: "nvarchar(max)",
                nullable: true);

            // Pemetaan balik. Tidak lossless: jabatan staf yang berbeda-beda
            // semuanya kembali menjadi "Staff", karena kolom lama memang hanya
            // mengenal dua nilai.
            // Dibungkus EXEC dengan alasan yang sama seperti pada Up().
            migrationBuilder.Sql(@"
                EXEC(N'
                    UPDATE Users SET PosisiTtd =
                        CASE
                            WHEN Jabatan IS NULL THEN NULL
                            WHEN Jabatan = N''AST. Manager ICS | PT. KPB'' THEN N''Manager''
                            ELSE N''Staff''
                        END;');");

            migrationBuilder.DropColumn(
                name: "Jabatan",
                table: "Users");
        }
    }
}
