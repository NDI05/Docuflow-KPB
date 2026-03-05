using Docuflow_projectIT_KPB.Models;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Docuflow_projectIT_KPB.Models
{
    public class Surat
    {
        public int Id { get; set; }

        public string NomorSurat { get; set; } = string.Empty;

        public int JenisSuratId { get; set; }

        public DateTime Tanggal { get; set; }

        public string? Deskripsi { get; set; }

        public int? StaffId { get; set; }

        public int? ManagerId { get; set; }

        public int? PenanggungJawabId { get; set; }

        // Navigation properties
        public JenisSurat? JenisSurat { get; set; }
        public User? Staff { get; set; }
        public User? Manager { get; set; }
        public User? PenanggungJawab { get; set; }
        public DateTime? CreatedAt { get; set; }

        public string? FilePath { get; set; }
    }
}