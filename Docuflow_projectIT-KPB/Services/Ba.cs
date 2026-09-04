namespace Docuflow_projectIT_KPB.Services
{
    /// <summary>
    /// Aturan berita acara laporan (kode "BA").
    ///
    /// Dua jenis berbagi kode ini supaya nomornya satu deret, jadi kode tidak
    /// bisa dipakai membedakan tata letak — pola yang sama dengan
    /// <see cref="Bast"/> dan <see cref="Bapb"/>. Pembedanya nama jenis:
    ///
    ///   "Berita Acara Kerusakan"   kop lama: logo kiri, blok perusahaan,
    ///                              kotak Nomor/Dari/Tujuan di kanan
    ///   "Berita Acara Survey"      kop kanan atas, judul terpusat, lalu
    ///                              Nomor dan "TENTANG"
    /// </summary>
    public static class Ba
    {
        public const string Kode = "BA";

        /// <summary>
        /// Varian dengan judul terpusat dan baris "TENTANG". Hanya varian ini
        /// yang memakai <c>Surat.Tentang</c>; pada Kerusakan isian itu tidak
        /// ditampilkan supaya tidak ada data yang tersimpan tanpa pernah dicetak.
        /// </summary>
        public static bool Survey(string? namaJenis) =>
            (namaJenis ?? string.Empty).Contains("Survey", System.StringComparison.OrdinalIgnoreCase);
    }
}
