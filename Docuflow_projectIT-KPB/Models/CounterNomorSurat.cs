using Docuflow_projectIT_KPB.Models;

namespace Docuflow_projectIT_KPB.Models
{
    public class CounterNomorSurat
    {
        public int Id { get; set; }

        public int JenisSuratId { get; set; }

        public int Tahun { get; set; }

        public int NomorTerakhir { get; set; }

        public JenisSurat? JenisSurat { get; set; }
    }
}