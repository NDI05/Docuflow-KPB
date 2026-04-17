using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Docuflow_projectIT_KPB.Models
{
    public class BarangSurat
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int SuratId { get; set; }

        // =========================
        // DATA BARANG
        // =========================

        [Required]
        public string NamaBarang { get; set; } = string.Empty;

        // ❌ OPSIONAL (boleh dihapus kalau udah full pindah ke SN)
        public int? Jumlah { get; set; }

        // ✅ BARU (ganti dari Jumlah)
        [Display(Name = "Serial Number")]
        public string SerialNumber { get; set; } = string.Empty;

        public string MerkType { get; set; } = string.Empty;

        public string Pengguna { get; set; } = string.Empty;

        // =========================
        // RELASI KE SURAT
        // =========================

        [ForeignKey("SuratId")]
        public Surat? Surat { get; set; }
    }
}