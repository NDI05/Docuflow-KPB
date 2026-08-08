using System.ComponentModel.DataAnnotations;

namespace Docuflow_projectIT_KPB.Models
{
    public class User
    {
        public int Id { get; set; }

        public string Nama { get; set; } = string.Empty;

        /// <summary>
        /// Hak akses aplikasi. Hanya dua nilai: "SuperAdmin" atau "Admin".
        /// SuperAdmin mengurus pengguna dan melihat jejak audit; Admin membuat
        /// berita acara. Keduanya saling terpisah — lihat SessionAuthorizeAttribute.
        /// </summary>
        public string Role { get; set; } = string.Empty;

        /// <summary>
        /// Posisi orang ini saat menandatangani berita acara:
        /// "Staff", "Manager", "PenanggungJawab", atau kosong kalau tidak
        /// pernah menandatangani.
        ///
        /// Dipisahkan dari <see cref="Role"/> karena keduanya menjawab
        /// pertanyaan berbeda: Role menentukan apa yang boleh dibuka di
        /// aplikasi, PosisiTtd menentukan di kolom mana namanya tercetak.
        /// Sebelumnya keduanya menumpang satu kolom, sehingga seorang Manager
        /// tidak bisa sekaligus diberi hak mengelola pengguna.
        /// </summary>
        public string? PosisiTtd { get; set; }

        public string? TtdImagePath { get; set; }

        public string NomorPegawai { get; set; } = string.Empty;

        public string? Npk { get; set; }

        // LOGIN
        public string Username { get; set; } = string.Empty;

        public string Password { get; set; } = string.Empty;
    }
}