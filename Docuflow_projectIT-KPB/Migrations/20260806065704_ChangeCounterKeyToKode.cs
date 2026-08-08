using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Docuflow_projectIT_KPB.Migrations
{
    /// <inheritdoc />
    public partial class ChangeCounterKeyToKode : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_CounterNomorSurat_JenisSurat_JenisSuratId",
                table: "CounterNomorSurat");

            migrationBuilder.DropIndex(
                name: "IX_CounterNomorSurat_JenisSuratId_Tahun",
                table: "CounterNomorSurat");

            migrationBuilder.DropColumn(
                name: "JenisSuratId",
                table: "CounterNomorSurat");

            migrationBuilder.AddColumn<string>(
                name: "Kode",
                table: "CounterNomorSurat",
                type: "nvarchar(20)",
                maxLength: 20,
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateIndex(
                name: "IX_CounterNomorSurat_Kode_Tahun",
                table: "CounterNomorSurat",
                columns: new[] { "Kode", "Tahun" },
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_CounterNomorSurat_Kode_Tahun",
                table: "CounterNomorSurat");

            migrationBuilder.DropColumn(
                name: "Kode",
                table: "CounterNomorSurat");

            migrationBuilder.AddColumn<int>(
                name: "JenisSuratId",
                table: "CounterNomorSurat",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_CounterNomorSurat_JenisSuratId_Tahun",
                table: "CounterNomorSurat",
                columns: new[] { "JenisSuratId", "Tahun" },
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_CounterNomorSurat_JenisSurat_JenisSuratId",
                table: "CounterNomorSurat",
                column: "JenisSuratId",
                principalTable: "JenisSurat",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
