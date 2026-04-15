using Docuflow_projectIT_KPB.Data;
using Docuflow_projectIT_KPB.Models;
using Microsoft.EntityFrameworkCore;

namespace Docuflow_projectIT_KPB.Services
{
    public class NomorSuratService
    {
        private readonly ApplicationDbContext _context;

        public NomorSuratService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<string> GenerateNomorSurat(int jenisSuratId)
        {
            var tahun = DateTime.Now.Year;

            // AMBIL NAMA JENIS SURAT
            var namaJenisFull = await _context.JenisSurat
                .Where(j => j.Id == jenisSuratId)
                .Select(j => j.NamaJenis)
                .FirstOrDefaultAsync();

            if (string.IsNullOrEmpty(namaJenisFull))
                namaJenisFull = "SURAT";

            // AMBIL SINGKATAN SAJA (SEBELUM "-")
            string singkatan = namaJenisFull;

            if (namaJenisFull.Contains("-"))
            {
                singkatan = namaJenisFull.Split('-')[0].Trim();
            }

            var counter = await _context.CounterNomorSurat
                .FirstOrDefaultAsync(x => x.JenisSuratId == jenisSuratId && x.Tahun == tahun);

            if (counter == null)
            {
                counter = new CounterNomorSurat
                {
                    JenisSuratId = jenisSuratId,
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

            string nomorUrut = counter.NomorTerakhir.ToString("D3");
            string kodeTetap = "KPB2340";
            string kodeJenis = "S0";

            // FORMAT BARU: BAPB 004/KPB2340/2026/S0
            return $"{singkatan} {nomorUrut}/{kodeTetap}/{tahun}/{kodeJenis}";
        }
    }
}