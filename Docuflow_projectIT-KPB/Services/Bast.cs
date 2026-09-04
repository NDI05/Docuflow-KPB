namespace Docuflow_projectIT_KPB.Services
{
    /// <summary>
    /// Aturan berita acara serah terima.
    ///
    /// Dua jenis berbagi satu kode "BAST" supaya nomornya satu deret, jadi
    /// kode tidak bisa dipakai membedakan tata letak — sama seperti pada
    /// <see cref="Bapb"/>. Pembedanya jatuh ke nama jenis:
    ///
    ///   "Berita Acara Serah Terima Barang"      tabel perangkat
    ///   "Berita Acara Serah Terima Data CCTV"   tabel rekaman
    ///
    /// Dipanggil formulir Create dan templat cetak. Ditulis sekali di sini
    /// supaya kolom di layar tidak pernah berbeda dengan kolom di kertas.
    /// </summary>
    public static class Bast
    {
        public const string Kode = "BAST";

        /// <summary>
        /// Varian serah terima rekaman CCTV: kolom Tanggal / Jam / Rekaman /
        /// Area menggantikan Serial number / Merk / Pengguna, dan kotak tanda
        /// tangannya tiga, bukan empat — tidak ada "Yang Bertanggung Jawab".
        /// </summary>
        public static bool Cctv(string? namaJenis) =>
            (namaJenis ?? string.Empty).Contains("CCTV", System.StringComparison.OrdinalIgnoreCase);
    }
}
