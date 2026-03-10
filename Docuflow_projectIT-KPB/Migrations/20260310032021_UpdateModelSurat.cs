using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Docuflow_projectIT_KPB.Migrations
{
    /// <inheritdoc />
    public partial class UpdateModelSurat : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Kode",
                table: "JenisSurat",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Kode",
                table: "JenisSurat");
        }
    }
}
