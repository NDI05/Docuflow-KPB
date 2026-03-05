using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Docuflow_projectIT_KPB.Migrations
{
    /// <inheritdoc />
    public partial class AddNomorPegawai : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "JenisSurat",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NamaJenis = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_JenisSurat", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Nama = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Role = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    TtdImagePath = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    NomorPegawai = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "CounterNomorSurat",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    JenisSuratId = table.Column<int>(type: "int", nullable: false),
                    Tahun = table.Column<int>(type: "int", nullable: false),
                    NomorTerakhir = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CounterNomorSurat", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CounterNomorSurat_JenisSurat_JenisSuratId",
                        column: x => x.JenisSuratId,
                        principalTable: "JenisSurat",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Surat",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NomorSurat = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    JenisSuratId = table.Column<int>(type: "int", nullable: false),
                    Tanggal = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Deskripsi = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    StaffId = table.Column<int>(type: "int", nullable: true),
                    ManagerId = table.Column<int>(type: "int", nullable: true),
                    PenanggungJawabId = table.Column<int>(type: "int", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    FilePath = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Surat", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Surat_JenisSurat_JenisSuratId",
                        column: x => x.JenisSuratId,
                        principalTable: "JenisSurat",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Surat_Users_ManagerId",
                        column: x => x.ManagerId,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Surat_Users_PenanggungJawabId",
                        column: x => x.PenanggungJawabId,
                        principalTable: "Users",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Surat_Users_StaffId",
                        column: x => x.StaffId,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_CounterNomorSurat_JenisSuratId",
                table: "CounterNomorSurat",
                column: "JenisSuratId");

            migrationBuilder.CreateIndex(
                name: "IX_Surat_JenisSuratId",
                table: "Surat",
                column: "JenisSuratId");

            migrationBuilder.CreateIndex(
                name: "IX_Surat_ManagerId",
                table: "Surat",
                column: "ManagerId");

            migrationBuilder.CreateIndex(
                name: "IX_Surat_PenanggungJawabId",
                table: "Surat",
                column: "PenanggungJawabId");

            migrationBuilder.CreateIndex(
                name: "IX_Surat_StaffId",
                table: "Surat",
                column: "StaffId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "CounterNomorSurat");

            migrationBuilder.DropTable(
                name: "Surat");

            migrationBuilder.DropTable(
                name: "JenisSurat");

            migrationBuilder.DropTable(
                name: "Users");
        }
    }
}
