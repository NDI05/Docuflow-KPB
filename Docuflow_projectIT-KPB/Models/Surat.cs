using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Docuflow_projectIT_KPB.Models
{
    public class Surat
    {
        // ======================
        // PRIMARY KEY
        // ======================
        [Key]
        public int Id { get; set; }


        // ======================
        // NOMOR SURAT
        // ======================
        [Required]
        public string NomorSurat { get; set; } = string.Empty;


        // ======================
        // JENIS SURAT
        // ======================
        [Required]
        public int JenisSuratId { get; set; }

        [ForeignKey("JenisSuratId")]
        public JenisSurat? JenisSurat { get; set; }


        // ======================
        // TANGGAL
        // ======================
        public DateTime Tanggal { get; set; } = DateTime.Now;

        public DateTime? CreatedAt { get; set; } = DateTime.Now;


        // ======================
        // INFORMASI SURAT
        // ======================
        public string? Deskripsi { get; set; }

        public string? Tujuan { get; set; }

        public string? FormatSerahTerima { get; set; }


        // ======================
        // CATATAN TIKET
        // ======================
        public string? JenisTiket { get; set; }

        public string? NoTiket { get; set; }


        // ======================
        // DATA PENANGGUNG JAWAB
        // ======================
        public string? NamaPenanggungJawab { get; set; }

        public string? Jabatan { get; set; }

        // ✅ TAMBAHAN BARU
        public string? FungsiDirektorat { get; set; }

        public string? NoPekerja { get; set; }

        public string? Alamat { get; set; }

        public string? YangMenerima { get; set; }


        // ======================
        // RELASI USER SYSTEM
        // ======================
        public int? StaffId { get; set; }

        public int? ManagerId { get; set; }

        public int? PenanggungJawabId { get; set; }

        [ForeignKey("StaffId")]
        public User? Staff { get; set; }

        [ForeignKey("ManagerId")]
        public User? Manager { get; set; }

        [ForeignKey("PenanggungJawabId")]
        public User? PenanggungJawab { get; set; }


        // ======================
        // FILE UPLOAD
        // ======================
        public string? FilePath { get; set; }


        // ======================
        // BARANG LIST — dipakai jenis surat berkode BAST
        // ======================
        public List<BarangSurat>? BarangList { get; set; } = new List<BarangSurat>();

        // ======================
        // POIN LAPORAN — dipakai jenis surat berkode BA
        //
        // BAST mencatat daftar barang, BA mencatat poin laporan berjenjang.
        // Keduanya menempel pada Surat yang sama; yang terisi ditentukan
        // oleh kode jenis suratnya.
        // ======================
        public List<PoinSurat>? PoinList { get; set; } = new List<PoinSurat>();
    }
}