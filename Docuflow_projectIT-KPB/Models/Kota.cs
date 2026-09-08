using System.ComponentModel.DataAnnotations;

namespace Docuflow_projectIT_KPB.Models
{
    /// <summary>
    /// Daftar kabupaten/kota, dipakai sebagai sumber pilihan kota pada SPD.
    ///
    /// Tabel acuan murni: tidak ada surat yang menyimpan Id-nya. SPD menyimpan
    /// NAMA kotanya sebagai teks, mengikuti pola yang sudah dipakai jabatan.
    /// Alasannya kode wilayah berubah saat daerah dimekarkan atau digabung, dan
    /// SPD yang sudah terbit tidak boleh ikut berubah artinya ketika Kemendagri
    /// menerbitkan penomoran baru.
    ///
    /// Diisi sekali lewat db/seed-kota.sql. Aplikasi tidak pernah memanggil
    /// internet saat berjalan.
    /// </summary>
    public class Kota
    {
        public int Id { get; set; }

        /// <summary>Kode wilayah Kemendagri, mis. "64.71". Untuk penelusuran, bukan kunci.</summary>
        [MaxLength(10)]
        public string? Kode { get; set; }

        [Required]
        [MaxLength(120)]
        public string Nama { get; set; } = string.Empty;

        [MaxLength(120)]
        public string? Provinsi { get; set; }
    }
}
