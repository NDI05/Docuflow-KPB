using Docuflow_projectIT_KPB.Models;
using Microsoft.EntityFrameworkCore;
using Docuflow_projectIT_KPB.Models;

namespace Docuflow_projectIT_KPB.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<JenisSurat> JenisSurat { get; set; }
        public DbSet<Surat> Surat { get; set; }
        public DbSet<CounterNomorSurat> CounterNomorSurat { get; set; }
    }
}