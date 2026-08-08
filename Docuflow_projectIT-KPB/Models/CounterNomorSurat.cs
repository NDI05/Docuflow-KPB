using System.ComponentModel.DataAnnotations;

namespace Docuflow_projectIT_KPB.Models
{
    /// <summary>
    /// Penghitung nomor surat, satu baris per (kode, tahun).
    ///
    /// Kuncinya <b>kode</b>, bukan jenis surat: beberapa jenis berbagi kode yang
    /// sama — "Serah Terima Barang" dan "Serah Terima Data CCTV" sama-sama BAST.
    /// Kalau dihitung per jenis, keduanya akan sama-sama mulai dari 001 dan
    /// menghasilkan dua dokumen bernomor identik.
    /// </summary>
    public class CounterNomorSurat
    {
        public int Id { get; set; }

        /// <summary>
        /// Singkatan jenis surat: "BAST", "BA". Panjangnya dibatasi karena
        /// kolom ini masuk unique index, dan nvarchar(max) tidak bisa jadi
        /// bagian kunci index di SQL Server.
        /// </summary>
        [Required]
        [MaxLength(20)]
        public string Kode { get; set; } = string.Empty;

        public int Tahun { get; set; }

        public int NomorTerakhir { get; set; }
    }
}
