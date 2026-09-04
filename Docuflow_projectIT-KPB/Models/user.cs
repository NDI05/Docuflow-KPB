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
        /// Jabatan orang ini, mis. "AST. Manager ICS | PT. KPB". Kosong berarti
        /// ia tidak pernah menandatangani berita acara.
        ///
        /// Dipisahkan dari <see cref="Role"/> karena keduanya menjawab
        /// pertanyaan berbeda: Role menentukan apa yang boleh dibuka di
        /// aplikasi, Jabatan menentukan di kolom mana namanya tercetak dan
        /// jabatan apa yang tercetak di bawahnya.
        ///
        /// Peran tanda tangannya TIDAK disimpan — dihitung dari jabatan lewat
        /// <see cref="Services.JabatanUser"/>. Menyimpan keduanya membuka
        /// peluang jabatan dan peran saling bertentangan.
        /// </summary>
        [MaxLength(120)]
        public string? Jabatan { get; set; }

        public string? TtdImagePath { get; set; }

        public string NomorPegawai { get; set; } = string.Empty;

        public string? Npk { get; set; }

        // LOGIN
        public string Username { get; set; } = string.Empty;

        public string Password { get; set; } = string.Empty;
    }
}