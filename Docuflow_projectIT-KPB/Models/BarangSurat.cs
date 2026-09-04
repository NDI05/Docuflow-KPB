using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Docuflow_projectIT_KPB.Models
{
    /// <summary>
    /// Satu baris barang pada berita acara.
    ///
    /// Dipakai tiga bentuk dokumen yang menampilkan kolom berbeda:
    ///   BAST         — Nama barang, Serial number, Merk/type, Pengguna
    ///   BAST CCTV    — Nama barang, Tanggal, Jam, Rekaman, Area
    ///   BAPB         — Jumlah, Satuan, Serial number, Merk/type, Keterangan
    ///
    /// Kolomnya digabung dalam satu tabel, bukan dipecah dua, karena isinya
    /// memang barang yang sama; yang berbeda hanya kolom mana yang dicetak.
    /// Kolom yang tidak dipakai satu jenis dibiarkan kosong.
    /// </summary>
    public class BarangSurat
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int SuratId { get; set; }

        // =========================
        // DATA BARANG
        // =========================

        // Kosong pada BAPB: dokumen pengembalian tidak punya kolom nama barang,
        // barangnya dikenali lewat nomor serial dan merk/type.
        public string NamaBarang { get; set; } = string.Empty;

        // Dipakai BAPB pada kolom "JUMLAH". Angka tercetak apa adanya, dan
        // versi hurufnya dihitung saat cetak lewat Terbilang — tidak disimpan,
        // supaya tidak pernah berbeda dengan angkanya.
        public int? Jumlah { get; set; }

        // Satuan BAPB ("pcs", "unit", "set"). Kosong dicetak sebagai "pcs".
        [MaxLength(20)]
        public string? Satuan { get; set; }

        [Display(Name = "Serial Number")]
        public string SerialNumber { get; set; } = string.Empty;

        public string MerkType { get; set; } = string.Empty;

        public string Pengguna { get; set; } = string.Empty;

        // Kolom "KETERANGAN" pada BAPB — misalnya "Perangkat Rusak".
        [MaxLength(300)]
        public string? Keterangan { get; set; }

        // =========================
        // KOLOM KHUSUS BAST CCTV
        //
        // Teks, bukan DateTime/TimeSpan: pada berita acara serah terima
        // rekaman, satu baris sering memuat RENTANG ("1 - 15 Agustus 2026",
        // "08:00 - 17:00 WITA") dan kadang catatan seperti "seharian".
        // Tipe tanggal akan menolak semua bentuk itu dan memaksa operator
        // memecah satu rekaman jadi banyak baris tanpa alasan.
        // =========================

        [MaxLength(100)]
        public string? Tanggal { get; set; }

        [MaxLength(100)]
        public string? Jam { get; set; }

        // Isi rekamannya — nama berkas, durasi, atau nomor kamera.
        [MaxLength(300)]
        public string? Rekaman { get; set; }

        // Lokasi kamera, misal "Gate 3" atau "Area Tangki 41".
        [MaxLength(200)]
        public string? Area { get; set; }

        // =========================
        // RELASI KE SURAT
        // =========================

        [ForeignKey("SuratId")]
        public Surat? Surat { get; set; }
    }
}
