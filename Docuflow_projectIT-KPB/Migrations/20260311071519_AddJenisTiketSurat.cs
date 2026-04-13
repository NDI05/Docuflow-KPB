using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Docuflow_projectIT_KPB.Migrations
{
    /// <inheritdoc />
    public partial class AddJenisTiketSurat : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "JenisTiket",
                table: "Surat",
                type: "nvarchar(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "JenisTiket",
                table: "Surat");
        }
    }
}
