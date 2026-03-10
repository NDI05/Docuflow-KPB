using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Docuflow_projectIT_KPB.Migrations
{
    /// <inheritdoc />
    public partial class AddNpkToUser : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Npk",
                table: "Users",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "BarangSurat",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SuratId = table.Column<int>(type: "int", nullable: false),
                    NamaBarang = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Jumlah = table.Column<int>(type: "int", nullable: false),
                    MerkType = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Pengguna = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BarangSurat", x => x.Id);
                    table.ForeignKey(
                        name: "FK_BarangSurat_Surat_SuratId",
                        column: x => x.SuratId,
                        principalTable: "Surat",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_BarangSurat_SuratId",
                table: "BarangSurat",
                column: "SuratId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "BarangSurat");

            migrationBuilder.DropColumn(
                name: "Npk",
                table: "Users");
        }
    }
}
