using System;
using System.Linq;

namespace Docuflow_projectIT_KPB.Services
{
    /// <summary>
    /// Jabatan pengguna, dan peran tanda tangannya.
    ///
    /// Menggantikan kolom PosisiTtd yang isinya "Staff"/"Manager" (dihapus
    /// 2026-09-03). Dua alasan:
    ///
    ///   1. PosisiTtd bukan data yang ada di dunia nyata — orang punya jabatan,
    ///      bukan "posisi tanda tangan". Menyimpan jabatan sekaligus membuat
    ///      dokumen bisa mencetak jabatan yang sebenarnya.
    ///   2. Peran tanda tangan bisa DIHITUNG dari jabatan, jadi menyimpan
    ///      keduanya membuka peluang keduanya bertentangan.
    ///
    /// Satu jabatan berperan manajer — namanya yang muncul di kolom
    /// "Mengetahui" pada seluruh jenis surat. Sisanya berperan staf.
    /// </summary>
    public static class JabatanUser
    {
        /// <summary>Satu-satunya jabatan yang berperan manajer.</summary>
        public const string AstManager = "AST. Manager ICS | PT. KPB";

        /// <summary>
        /// Isi dropdown. Daftar putih: nilainya datang dari form dan ikut
        /// tercetak di dokumen resmi, jadi diperiksa di server — isi
        /// &lt;select&gt; hanya petunjuk untuk manusia.
        /// </summary>
        public static readonly string[] Pilihan =
        {
            AstManager,
            "Officer ICS | PT. KPB",
            "Jr. Officer ICS | PT. KPB",
            "Staff ICS | PT. KPB"
        };

        public static bool Dikenal(string? jabatan) =>
            Pilihan.Contains((jabatan ?? string.Empty).Trim(), StringComparer.OrdinalIgnoreCase);

        /// <summary>Berperan manajer: muncul di pilihan "Mengetahui".</summary>
        public static bool Manajer(string? jabatan) =>
            string.Equals((jabatan ?? string.Empty).Trim(), AstManager, StringComparison.OrdinalIgnoreCase);

        /// <summary>
        /// Berperan staf: muncul di pilihan penanda tangan Staff. Jabatan
        /// kosong berarti orang itu tidak pernah menandatangani, jadi tidak
        /// masuk pilihan mana pun.
        /// </summary>
        public static bool Staf(string? jabatan) =>
            !string.IsNullOrWhiteSpace(jabatan) && !Manajer(jabatan);
    }
}
