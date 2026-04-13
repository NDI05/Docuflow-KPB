using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Docuflow_projectIT_KPB.Models
{
    public class Surat
    {
        // ======================
        // PRIMARY KEY
        // ======================

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

        public JenisSurat? JenisSurat { get; set; }


        // ======================
        // TANGGAL
        // ======================

        public DateTime Tanggal { get; set; }

        public DateTime? CreatedAt { get; set; }


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

        public string? NoPekerja { get; set; }

        public string? Alamat { get; set; }

        public string? YangMenerima { get; set; }


        // ======================
        // RELASI USER SYSTEM
        // ======================

        public int? StaffId { get; set; }

        public int? ManagerId { get; set; }

        public int? PenanggungJawabId { get; set; }

        public User? Staff { get; set; }

        public User? Manager { get; set; }

        public User? PenanggungJawab { get; set; }


        // ======================
        // FILE UPLOAD
        // ======================

        public string? FilePath { get; set; }


        // ======================
        // BARANG LIST
        // ======================

        public List<BarangSurat>? BarangList { get; set; }
    }
}