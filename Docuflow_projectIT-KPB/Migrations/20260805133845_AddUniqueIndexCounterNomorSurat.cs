using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Docuflow_projectIT_KPB.Migrations
{
    /// <inheritdoc />
    public partial class AddUniqueIndexCounterNomorSurat : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_CounterNomorSurat_JenisSuratId",
                table: "CounterNomorSurat");

            migrationBuilder.CreateIndex(
                name: "IX_CounterNomorSurat_JenisSuratId_Tahun",
                table: "CounterNomorSurat",
                columns: new[] { "JenisSuratId", "Tahun" },
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_CounterNomorSurat_JenisSuratId_Tahun",
                table: "CounterNomorSurat");

            migrationBuilder.CreateIndex(
                name: "IX_CounterNomorSurat_JenisSuratId",
                table: "CounterNomorSurat",
                column: "JenisSuratId");
        }
    }
}
