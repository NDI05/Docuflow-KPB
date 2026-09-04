namespace Docuflow_projectIT_KPB.Services
{
    /// <summary>
    /// Berita Acara Layak Pakai.
    ///
    /// Alurnya berbeda dari seluruh jenis lain: Docuflow TIDAK mencetak
    /// dokumennya. Kita hanya menerbitkan nomor surat, nomor itu diberikan ke
    /// vendor, vendor yang menyusun suratnya, lalu berkas jadinya diarsipkan
    /// kembali ke sini.
    ///
    /// Akibatnya, dan ini yang membedakannya dari BAST/BA/BAPB:
    ///   - tidak ada templat cetak; Pratinjau dan Cetak PDF ditolak
    ///   - formulir hanya meminta nama perusahaan dan keterangan
    ///   - berkas dan tanggal surat vendor diisi BELAKANGAN, lewat halaman
    ///     unggah tersendiri, karena keduanya belum ada saat nomor terbit
    /// </summary>
    public static class Balp
    {
        public const string Kode = "BALP";

        public static bool Adalah(string? kode) =>
            string.Equals((kode ?? string.Empty).Trim(), Kode, System.StringComparison.OrdinalIgnoreCase);
    }
}
