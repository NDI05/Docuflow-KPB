using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Docuflow_projectIT_KPB.Migrations
{
    /// <inheritdoc />
    public partial class UpdateSuratField : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Alamat",
                table: "Surat",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "FormatSerahTerima",
                table: "Surat",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Jabatan",
                table: "Surat",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NamaPenanggungJawab",
                table: "Surat",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NoPekerja",
                table: "Surat",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "NoTiket",
                table: "Surat",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Tujuan",
                table: "Surat",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "YangMenerima",
                table: "Surat",
                type: "nvarchar(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Alamat",
                table: "Surat");

            migrationBuilder.DropColumn(
                name: "FormatSerahTerima",
                table: "Surat");

            migrationBuilder.DropColumn(
                name: "Jabatan",
                table: "Surat");

            migrationBuilder.DropColumn(
                name: "NamaPenanggungJawab",
                table: "Surat");

            migrationBuilder.DropColumn(
                name: "NoPekerja",
                table: "Surat");

            migrationBuilder.DropColumn(
                name: "NoTiket",
                table: "Surat");

            migrationBuilder.DropColumn(
                name: "Tujuan",
                table: "Surat");

            migrationBuilder.DropColumn(
                name: "YangMenerima",
                table: "Surat");
        }
    }
}
