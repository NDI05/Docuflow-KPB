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
            string kodeTetap = "KPB2340"; // nanti bisa kita buat setting
            string kodeJenis = "S0"; // nanti bisa kita mapping per jenis

            return $"{nomorUrut}/{kodeTetap}/{tahun}/{kodeJenis}";
        }
    }
}