using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Docuflow_projectIT_KPB.Models
{
    /// <summary>
    /// Satu poin laporan pada berita acara berkode BA.
    ///
    /// Strukturnya <b>outline</b>, bukan pohon ber-ParentId: induk sebuah poin
    /// adalah baris terdekat di atasnya yang <see cref="Level"/>-nya lebih
    /// kecil. Dokumen aslinya memang berbentuk daftar berjenjang, jadi
    /// Level + Urutan sudah memuat seluruh informasinya — tanpa relasi
    /// melingkar yang mungkin terbentuk, dan tanpa query rekursif.
    ///
    /// Penomoran tampilan (1, 1.1, 1.1.1) dihitung dari urutan ini dan
    /// sengaja tidak disimpan, supaya tidak pernah basi setelah poin
    /// disisipkan atau dihapus.
    /// </summary>
    public class PoinSurat
    {
        public int Id { get; set; }

        [Required]
        public int SuratId { get; set; }

        [ForeignKey("SuratId")]
        public Surat? Surat { get; set; }

        /// <summary>Kedalaman: 0 = poin utama, 1 = sub-poin, 2 = sub-sub-poin.</summary>
        public int Level { get; set; }

        /// <summary>Posisi dalam daftar, dihitung dari 0 dan berlaku menyeluruh.</summary>
        public int Urutan { get; set; }

        [Required]
        [MaxLength(300)]
        public string Judul { get; set; } = string.Empty;

        public string? Keterangan { get; set; }

        public List<GambarPoin> Gambar { get; set; } = new();
    }
}
