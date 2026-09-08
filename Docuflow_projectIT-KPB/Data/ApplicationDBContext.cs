using Docuflow_projectIT_KPB.Models;
using Microsoft.EntityFrameworkCore;

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

        // Sub Pekerjaan Dinas. Tabel sendiri, tidak menumpang Surat — lihat
        // Models/Spd.cs. Kota hanya tabel acuan pengisi pilihan kota.
        public DbSet<Spd> Spd { get; set; }
        public DbSet<Kota> Kota { get; set; }
        public DbSet<AuditLog> AuditLogs { get; set; }
        public DbSet<BarangSurat> BarangSurat { get; set; }
        public DbSet<PoinSurat> PoinSurat { get; set; }
        public DbSet<GambarPoin> GambarPoin { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Satu counter per (kode, tahun) — bukan per jenis surat, karena
            // beberapa jenis berbagi kode yang sama (BAST dipakai dua jenis).
            // Selain mencegah baris ganda, index ini yang membuat HOLDLOCK di
            // NomorSuratService mengunci key-range saat baris counter belum ada.
            modelBuilder.Entity<CounterNomorSurat>()
                .HasIndex(c => new { c.Kode, c.Tahun })
                .IsUnique();

            // Nama kota dipakai sebagai kunci pencocokan: pilihan kota pada SPD
            // memakai <datalist>, yang MENGIRIM TEKS yang diketik, bukan id.
            // Controller mencari baris Kota berdasarkan nama itu, jadi nama
            // ganda akan membuat pencocokannya menebak. Data sumber sudah
            // diperiksa: 514 kabupaten/kota, nol nama ganda.
            modelBuilder.Entity<Kota>()
                .HasIndex(k => k.Nama)
                .IsUnique();
        }
    }
}