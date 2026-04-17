using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Docuflow_projectIT_KPB.Migrations
{
    /// <inheritdoc />
    public partial class AddFungsiDirektoratColumn : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "FungsiDirektorat",
                table: "Surat",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "Jumlah",
                table: "BarangSurat",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddColumn<string>(
                name: "SerialNumber",
                table: "BarangSurat",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "FungsiDirektorat",
                table: "Surat");

            migrationBuilder.DropColumn(
                name: "SerialNumber",
                table: "BarangSurat");

            migrationBuilder.AlterColumn<int>(
                name: "Jumlah",
                table: "BarangSurat",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);
        }
    }
}
