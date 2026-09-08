using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Docuflow_projectIT_KPB.Migrations
{
    /// <inheritdoc />
    public partial class AddSpdDanKota : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Kota",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Kode = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: true),
                    Nama = table.Column<string>(type: "nvarchar(120)", maxLength: 120, nullable: false),
                    Provinsi = table.Column<string>(type: "nvarchar(120)", maxLength: 120, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Kota", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Spd",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NomorSpd = table.Column<string>(type: "nvarchar(60)", maxLength: 60, nullable: false),
                    StaffId = table.Column<int>(type: "int", nullable: true),
                    NamaKota = table.Column<string>(type: "nvarchar(120)", maxLength: 120, nullable: false),
                    Provinsi = table.Column<string>(type: "nvarchar(120)", maxLength: 120, nullable: true),
                    Keperluan = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),
                    TanggalDinas = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Spd", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Spd_Users_StaffId",
                        column: x => x.StaffId,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Kota_Nama",
                table: "Kota",
                column: "Nama",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Spd_StaffId",
                table: "Spd",
                column: "StaffId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Kota");

            migrationBuilder.DropTable(
                name: "Spd");
        }
    }
}
