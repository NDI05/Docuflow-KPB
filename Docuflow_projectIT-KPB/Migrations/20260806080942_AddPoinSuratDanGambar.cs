using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Docuflow_projectIT_KPB.Migrations
{
    /// <inheritdoc />
    public partial class AddPoinSuratDanGambar : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "PoinSurat",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SuratId = table.Column<int>(type: "int", nullable: false),
                    Level = table.Column<int>(type: "int", nullable: false),
                    Urutan = table.Column<int>(type: "int", nullable: false),
                    Judul = table.Column<string>(type: "nvarchar(300)", maxLength: 300, nullable: false),
                    Keterangan = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PoinSurat", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PoinSurat_Surat_SuratId",
                        column: x => x.SuratId,
                        principalTable: "Surat",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "GambarPoin",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    PoinSuratId = table.Column<int>(type: "int", nullable: false),
                    FilePath = table.Column<string>(type: "nvarchar(400)", maxLength: 400, nullable: false),
                    Urutan = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_GambarPoin", x => x.Id);
                    table.ForeignKey(
                        name: "FK_GambarPoin_PoinSurat_PoinSuratId",
                        column: x => x.PoinSuratId,
                        principalTable: "PoinSurat",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_GambarPoin_PoinSuratId",
                table: "GambarPoin",
                column: "PoinSuratId");

            migrationBuilder.CreateIndex(
                name: "IX_PoinSurat_SuratId",
                table: "PoinSurat",
                column: "SuratId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "GambarPoin");

            migrationBuilder.DropTable(
                name: "PoinSurat");
        }
    }
}
