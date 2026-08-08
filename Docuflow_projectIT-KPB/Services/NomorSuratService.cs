using Docuflow_projectIT_KPB.Data;
using Docuflow_projectIT_KPB.Models;
using Microsoft.EntityFrameworkCore;

namespace Docuflow_projectIT_KPB.Services
{
    public class NomorSuratService
    {
        private readonly ApplicationDbContext _context;

        // Bagian nomor yang tidak berubah. Kalau suatu saat berbeda per unit
        // atau per tahun, dua konstanta inilah yang pindah ke konfigurasi.
        private const string KodeKilang = "KPB3240";
        private const string KodeAkhir = "S0";

        public NomorSuratService(ApplicationDbContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Menaikkan counter dan mengembalikan nomor surat berikutnya dengan
        /// bentuk <c>{KODE} No.{NNN}/KPB3240/{tahun}-S0</c>.
        ///
        /// WAJIB dipanggil di dalam transaksi milik pemanggil (lihat
        /// SuratController.Create). Di luar transaksi, UPDLOCK/HOLDLOCK di bawah
        /// dilepas begitu statement selesai dan dua submit bersamaan kembali bisa
        /// mendapat nomor yang sama.
        /// </summary>
        public async Task<string> GenerateNomorSurat(int jenisSuratId)
        {
            var tahun = DateTime.Now.Year;

            // Kode diambil dari kolom Kode, bukan dipotong dari NamaJenis.
            // Dengan begitu nama jenis boleh ditulis manusiawi, dan beberapa
            // jenis boleh berbagi satu kode.
            var kode = await _context.JenisSurat
                .Where(j => j.Id == jenisSuratId)
                .Select(j => j.Kode)
                .FirstOrDefaultAsync();

            if (string.IsNullOrWhiteSpace(kode))
                kode = "BA";

            kode = kode.Trim().ToUpperInvariant();

            // UPDLOCK: transaksi lain yang menjalankan SELECT yang sama akan
            // menunggu, bukan ikut membaca nilai lama (update lock tidak
            // kompatibel dengan update lock).
            // HOLDLOCK: kunci ditahan sampai transaksi commit — termasuk
            // key-range lock kalau baris counter belum ada, sehingga dua
            // transaksi tidak bisa sama-sama menyisipkan counter baru.
            var counter = await _context.CounterNomorSurat
                .FromSqlInterpolated($@"
                    SELECT * FROM CounterNomorSurat WITH (UPDLOCK, HOLDLOCK)
                    WHERE Kode = {kode} AND Tahun = {tahun}")
                .FirstOrDefaultAsync();

            if (counter == null)
            {
                counter = new CounterNomorSurat
                {
                    Kode = kode,
                    Tahun = tahun,
                    NomorTerakhir = 1
                };

                _context.CounterNomorSurat.Add(counter);
            }
            else
            {
                counter.NomorTerakhir += 1;
            }

            await _context.SaveChangesAsync();

            var nomorUrut = counter.NomorTerakhir.ToString("D3");

            return $"{kode} No.{nomorUrut}/{KodeKilang}/{tahun}-{KodeAkhir}";
        }
    }
}
