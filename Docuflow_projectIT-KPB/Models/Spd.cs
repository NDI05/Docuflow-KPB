using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Docuflow_projectIT_KPB.Models
{
    /// <summary>
    /// Sub Pekerjaan Dinas.
    ///
    /// Tabel sendiri, BUKAN baris Surat. Yang dibutuhkan dari SPD hanya nomor
    /// suratnya; tidak ada barang, poin, penanda tangan, templat cetak, maupun
    /// berkas unggahan. Menumpangkannya pada Surat berarti menambah satu jenis
    /// yang bisa dipilih di formulir berita acara dan ikut tercetak memakai
    /// tata letak BAST — kegagalan yang sama seperti yang membuat BALP butuh
    /// penjaga route.
    ///
    /// Nomornya tetap keluar dari CounterNomorSurat yang sama dengan kode
    /// "SPD", sehingga bentuk nomor, keamanan konkurensi, dan reset per tahun
    /// tidak ditulis ulang.
    /// </summary>
    public class Spd
    {
        public int Id { get; set; }

        [Required]
        [MaxLength(60)]
        public string NomorSpd { get; set; } = string.Empty;

        /// <summary>Staff yang menjalankan dinas. Relasi, karena orangnya pengguna aplikasi.</summary>
        public int? StaffId { get; set; }

        [ForeignKey("StaffId")]
        public User? Staff { get; set; }

        /// <summary>
        /// Nama kota tujuan, disimpan sebagai teks hasil pencocokan dengan
        /// tabel Kota — bukan foreign key. Kode wilayah bisa berubah; SPD yang
        /// sudah terbit tidak boleh ikut berubah.
        /// </summary>
        [Required]
        [MaxLength(120)]
        public string NamaKota { get; set; } = string.Empty;

        [MaxLength(120)]
        public string? Provinsi { get; set; }

        [Required]
        [MaxLength(500)]
        public string Keperluan { get; set; } = string.Empty;

        public DateTime TanggalDinas { get; set; }

        /// <summary>Waktu nomor diterbitkan. Tahun pada nomor SPD berasal dari sini.</summary>
        public DateTime CreatedAt { get; set; } = DateTime.Now;
    }
}
