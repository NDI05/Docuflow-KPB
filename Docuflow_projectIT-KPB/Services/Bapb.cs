using System;

namespace Docuflow_projectIT_KPB.Services
{
    /// <summary>
    /// Aturan berita acara pengembalian barang.
    ///
    /// Tiga jenis BAPB berbagi satu kode "BAPB" — disengaja, supaya nomornya
    /// satu deret. Akibatnya kode tidak bisa dipakai membedakan tata letak,
    /// dan pembedanya jatuh ke nama jenis:
    ///
    ///   "BAPB Barang Rusak Dari IT KPB ke Vendor"   arah IT→lawan, ragam rusak
    ///   "BAPB Barang Sewa Dari IT KPB Ke Vendor"    arah IT→lawan, ragam sewa
    ///   "BAPB Dari User Ke IT KPB"                  arah lawan→IT, ragam sewa
    ///
    /// Arah menempel pada JENIS, bukan pada surat, jadi tidak disimpan per
    /// baris: menyimpannya berarti satu surat bisa punya arah yang bertentangan
    /// dengan jenisnya sendiri.
    ///
    /// Kelas ini satu-satunya tempat aturan itu ditulis. Template cetak dan
    /// formulir Create sama-sama memanggilnya; kalau dijawab sendiri-sendiri,
    /// label di layar dan hasil cetak bisa berbeda arah.
    ///
    /// Kalau nama jenis di tabel JenisSurat diubah lewat SQL, kata kunci di
    /// bawah ini yang harus ikut disesuaikan.
    /// </summary>
    public static class Bapb
    {
        public const string Kode = "BAPB";

        /// <summary>
        /// Pihak IT, salah satu ujung dokumen ini. Ditulis sekali supaya
        /// ejaannya tidak bercabang: dua dokumen contoh menuliskannya berbeda
        /// ("IT Kilang Pertamina Balikpapan" dan "IT PT Kilang Pertamina
        /// Balikpapan").
        /// </summary>
        public const string PihakIt = "IT Kilang Pertamina Balikpapan";

        /// <summary>
        /// Ragam "Barang Rusak": tabel tujuh kolom dengan MERK TYPE tersendiri,
        /// dan dua kotak tanda tangan tanpa baris Mengetahui.
        /// </summary>
        public static bool Rusak(string? namaJenis) =>
            (namaJenis ?? string.Empty).Contains("Rusak", StringComparison.OrdinalIgnoreCase);

        /// <summary>
        /// Arah masuk: barang dikembalikan user kepada IT. Kebalikannya
        /// (sewa dan rusak) berjalan dari IT ke vendor.
        /// </summary>
        public static bool DariUser(string? namaJenis) =>
            (namaJenis ?? string.Empty).Contains("User", StringComparison.OrdinalIgnoreCase);

        /// <summary>
        /// Apakah bagian "Dasar pemenuhan" (jenis dan nomor tiket) ditampilkan
        /// pada formulir untuk jenis BAPB ini.
        ///
        /// Dua BAPB yang berjalan dari IT ke vendor — barang rusak dan barang
        /// sewa — tidak memakainya, jadi bagian itu disembunyikan di sana.
        ///
        /// Catatan: TIDAK ADA templat cetak BAPB yang mencetak JenisTiket
        /// maupun NoTiket; hanya SuratTemplate (BAST) yang memakainya. Jadi
        /// bagian itu sebenarnya juga tidak terpakai pada BAPB arah masuk,
        /// pada BA Kerusakan, dan pada BA Survey. Yang disembunyikan di sini
        /// baru dua jenis yang diminta — bukan karena dua lainnya berbeda.
        /// </summary>
        public static bool PakaiDasarPemenuhan(string? namaJenis) => DariUser(namaJenis);

        /// <summary>Pihak pengirim, sesuai arah jenisnya.</summary>
        public static string Dari(string? namaJenis, string? lawan) =>
            DariUser(namaJenis) ? Lawan(lawan) : PihakIt;

        /// <summary>
        /// Pihak penerima, sesuai arah jenisnya.
        ///
        /// Pada arah masuk (user mengembalikan ke IT) yang dicetak adalah NAMA
        /// STAFF IT yang menerima, bukan nama organisasinya: dokumen ini
        /// diserahkan kepada orang tertentu, dan "IT Kilang Pertamina
        /// Balikpapan" tidak memberi tahu siapa yang memegang barangnya.
        /// Nama organisasi tetap dipakai kalau staff belum dipilih, supaya
        /// barisnya tidak pernah kosong.
        /// </summary>
        public static string Kepada(string? namaJenis, string? lawan, string? namaStaff) =>
            DariUser(namaJenis)
                ? (string.IsNullOrWhiteSpace(namaStaff) ? PihakIt : namaStaff.Trim())
                : Lawan(lawan);

        /// <summary>
        /// Label untuk kolom Tujuan pada formulir. Kolom itu menampung pihak
        /// lawan, dan arahnya menentukan apakah ia pengirim atau penerima —
        /// tanpa label yang ikut berubah, operator mengisi ujung yang salah.
        /// </summary>
        public static string LabelLawan(string? namaJenis) =>
            DariUser(namaJenis) ? "Dari (yang mengembalikan)" : "Kepada (penerima)";

        /// <summary>
        /// Label pilihan staff. Pada arah masuk, pilihan itu bukan sekadar
        /// penanda tangan — ia yang tercetak pada baris "Kepada", jadi
        /// labelnya harus mengatakannya.
        /// </summary>
        public static string LabelStaff(string? namaJenis) =>
            DariUser(namaJenis) ? "Kepada (staff IT penerima)" : "Staff";

        /// <summary>
        /// Pada arah masuk, isian bebas ini memuat orang dari sisi user yang
        /// MENYERAHKAN barang, bukan yang menerima. Label yang tidak ikut
        /// bertukar akan membuat operator menuliskan orang yang salah.
        /// </summary>
        public static string LabelYangMenerima(string? namaJenis) =>
            DariUser(namaJenis) ? "Yang menyerahkan" : "Yang menerima";

        /// <summary>
        /// Label isian jabatan yang menemani <see cref="LabelYangMenerima"/>.
        /// Ikut bertukar arah bersama isian namanya.
        /// </summary>
        public static string LabelJabatanYangMenerima(string? namaJenis) =>
            DariUser(namaJenis) ? "Jabatan yang menyerahkan" : "Jabatan penerima";

        private static string Lawan(string? lawan) =>
            string.IsNullOrWhiteSpace(lawan) ? "—" : lawan.Trim();
    }
}
