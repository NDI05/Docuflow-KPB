using System.ComponentModel.DataAnnotations;

namespace Docuflow_projectIT_KPB.Models
{
    public class AuditLog
    {
        [Key]
        public int Id { get; set; }

        public string Username { get; set; }

        public string Aktivitas { get; set; }

        public string Deskripsi { get; set; }

        public DateTime Waktu { get; set; } = DateTime.Now;
    }
}