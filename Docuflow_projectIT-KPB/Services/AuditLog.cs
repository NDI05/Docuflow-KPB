using Docuflow_projectIT_KPB.Data;
using Docuflow_projectIT_KPB.Models;

namespace Docuflow.Services
{
    public class AuditLogService
    {
        private readonly ApplicationDbContext _context;

        public AuditLogService(ApplicationDbContext context)
        {
            _context = context;
        }

        public void Log(string username,
                        string aktivitas,
                        string deskripsi)
        {
            var log = new AuditLog
            {
                Username = username,
                Aktivitas = aktivitas,
                Deskripsi = deskripsi,
                Waktu = DateTime.Now
            };

            _context.AuditLogs.Add(log);
            _context.SaveChanges();
        }
    }
}