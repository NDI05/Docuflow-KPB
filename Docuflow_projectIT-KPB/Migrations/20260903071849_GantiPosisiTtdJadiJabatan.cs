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
            // umum. Nilainya harus sama persis dengan JabatanUser.Pilihan —
            // kalau tidak, penggunanya hilang dari dropdown penanda tangan.
            migrationBuilder.Sql(@"
                UPDATE Users SET Jabatan =
                    CASE PosisiTtd
                        WHEN 'Manager' THEN N'AST. Manager ICS | PT. KPB'
                        WHEN 'Staff'   THEN N'Staff ICS | PT. KPB'
                        ELSE NULL
                    END;");

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
            migrationBuilder.Sql(@"
                UPDATE Users SET PosisiTtd =
                    CASE
                        WHEN Jabatan IS NULL THEN NULL
                        WHEN Jabatan = N'AST. Manager ICS | PT. KPB' THEN N'Manager'
                        ELSE N'Staff'
                    END;");

            migrationBuilder.DropColumn(
                name: "Jabatan",
                table: "Users");
        }
    }
}
