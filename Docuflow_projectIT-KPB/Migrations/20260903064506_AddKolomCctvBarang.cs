using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Docuflow_projectIT_KPB.Migrations
{
    /// <inheritdoc />
    public partial class AddKolomCctvBarang : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Area",
                table: "BarangSurat",
                type: "nvarchar(200)",
                maxLength: 200,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Jam",
                table: "BarangSurat",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Rekaman",
                table: "BarangSurat",
                type: "nvarchar(300)",
                maxLength: 300,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Tanggal",
                table: "BarangSurat",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Area",
                table: "BarangSurat");

            migrationBuilder.DropColumn(
                name: "Jam",
                table: "BarangSurat");

            migrationBuilder.DropColumn(
                name: "Rekaman",
                table: "BarangSurat");

            migrationBuilder.DropColumn(
                name: "Tanggal",
                table: "BarangSurat");
        }
    }
}
