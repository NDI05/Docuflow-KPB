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

        /// <summary>
        /// Perihal dokumen, dicetak di bawah label "TENTANG" pada berita acara
        /// yang memakai tata letak judul terpusat (BA Survey).
        ///
        /// Terpisah dari Deskripsi: Tentang adalah JUDUL perkaranya satu baris
        /// ("Survey Ruang Server Lantai 2"), sedangkan Deskripsi adalah paragraf
        /// pembuka. Menggabungkannya membuat judul ikut memanjang jadi paragraf.
        /// </summary>
        [MaxLength(300)]
        public string? Tentang { get; set; }

        /// <summary>
        /// Tanggal pada surat yang dibuat vendor (BALP). Kosong sampai
        /// berkasnya diunggah — nomornya diterbitkan lebih dulu, suratnya
        /// menyusul.
        ///
        /// Kolom sendiri, tidak menimpa <see cref="Tanggal"/>: Tanggal adalah
        /// tanggal PENERBITAN NOMOR, dan tahun pada nomor surat diambil dari
        /// situ. Menimpanya akan membuat arsip menaruh surat pada tahun yang
        /// berbeda dengan tahun yang tercetak di nomornya sendiri.
        /// </summary>
        public DateTime? TanggalBalp { get; set; }


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

        /// <summary>
        /// Jabatan orang yang tercatat di <see cref="YangMenerima"/>, dicetak
        /// tepat di bawah perannya pada BAPB dan BAST. Opsional — pihak lawan
        /// sering hanya diwakili nama, dan kosong berarti barisnya tidak
        /// dicetak sama sekali.
        ///
        /// Perlu kolom sendiri karena orang itu bukan pengguna aplikasi, jadi
        /// jabatannya tidak bisa diambil dari tabel Users seperti Staff dan
        /// Manager. Pada BAPB arah masuk ia justru pihak yang MENYERAHKAN, dan
        /// jabatannya ikut berpindah kotak bersama namanya; pada BAST ia selalu
        /// penerima. BA tidak memakainya — templatnya tidak punya kotak
        /// "Yang Menerima".
        /// </summary>
        [MaxLength(120)]
        public string? JabatanYangMenerima { get; set; }


        // ======================
        // RELASI USER SYSTEM
        // ======================
        public int? StaffId { get; set; }

        public int? ManagerId { get; set; }

        // MATI sejak 2026-09-03. Tidak ada lagi yang mengisinya: posisi
        // "PenanggungJawab" dihapus dari PosisiTtd, dan SuratController tidak
        // lagi menempelkan user mana pun ke sini. Tidak pernah dibaca view
        // atau template cetak — semuanya memakai NamaPenanggungJawab yang
        // berupa teks, karena penanggung jawab biasanya bukan pengguna
        // aplikasi. Kolomnya ditinggal supaya penghapusan ini tidak butuh
        // migration; buang lewat migration kalau memang mau bersih.
        public int? PenanggungJawabId { get; set; }

        [ForeignKey("StaffId")]
        public User? Staff { get; set; }

        [ForeignKey("ManagerId")]
        public User? Manager { get; set; }

        // Ikut mati bersama PenanggungJawabId. Tidak ada Include() yang
        // memuatnya lagi, jadi nilainya selalu null saat dibaca.
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