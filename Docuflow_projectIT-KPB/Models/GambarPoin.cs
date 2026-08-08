using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Docuflow_projectIT_KPB.Models
{
    /// <summary>
    /// Gambar yang melekat pada satu poin laporan. Satu poin boleh punya
    /// lebih dari satu gambar.
    /// </summary>
    public class GambarPoin
    {
        public int Id { get; set; }

        [Required]
        public int PoinSuratId { get; set; }

        [ForeignKey("PoinSuratId")]
        public PoinSurat? Poin { get; set; }

        /// <summary>Path relatif, contoh <c>/uploads/20260806_foto.jpg</c>.</summary>
        [Required]
        [MaxLength(400)]
        public string FilePath { get; set; } = string.Empty;

        public int Urutan { get; set; }
    }
}
