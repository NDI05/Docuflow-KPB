using System;

namespace Docuflow_projectIT_KPB.Services
{
    /// <summary>
    /// Angka menjadi huruf bahasa Indonesia, untuk kolom "JUMLAH — HURUF"
    /// pada berita acara pengembalian barang.
    ///
    /// Tidak disimpan di database: kalau angkanya disunting sementara hurufnya
    /// tidak, dokumen resmi akan menyebut dua jumlah yang berbeda. Dihitung
    /// saat cetak, selalu.
    ///
    /// Kaidah yang membuat bahasa Indonesia tidak bisa ditangani tabel biasa:
    ///   - 1x  = "sebelas".."sembilan belas", bukan "satu puluh satu"
    ///   - 10  = "sepuluh", 100 = "seratus", 1000 = "seribu" (bukan "satu ...")
    ///   - selain itu pola berulang: {satuan} {pengali} {sisa}
    ///
    /// Diuji lewat db/test-terbilang.sh (dijalankan di VM; Mac tidak punya
    /// .NET). Kalau kaidah di atas diubah, jalankan ulang skrip itu.
    /// </summary>
    public static class Terbilang
    {
        private static readonly string[] Satuan =
        {
            "nol", "satu", "dua", "tiga", "empat",
            "lima", "enam", "tujuh", "delapan", "sembilan"
        };

        /// <summary>
        /// Contoh: 1 → "satu", 11 → "sebelas", 21 → "dua puluh satu",
        /// 100 → "seratus", 1000 → "seribu", 2500 → "dua ribu lima ratus".
        ///
        /// Angka negatif diawali "minus". Batas atas triliun; di atas itu
        /// dikembalikan angkanya sendiri, karena dokumen pengembalian barang
        /// tidak akan pernah sampai ke sana dan menebak lebih buruk daripada
        /// mengaku tidak tahu.
        /// </summary>
        public static string Ubah(long n)
        {
            if (n < 0) return "minus " + Ubah(-n);
            if (n < 10) return Satuan[n];
            if (n == 10) return "sepuluh";
            if (n == 11) return "sebelas";
            if (n < 20) return Satuan[n % 10] + " belas";
            if (n < 100) return Ubah(n / 10) + " puluh" + Sisa(n % 10);
            if (n < 200) return "seratus" + Sisa(n % 100);
            if (n < 1000) return Ubah(n / 100) + " ratus" + Sisa(n % 100);
            if (n < 2000) return "seribu" + Sisa(n % 1000);
            if (n < 1_000_000) return Ubah(n / 1000) + " ribu" + Sisa(n % 1000);
            if (n < 1_000_000_000) return Ubah(n / 1_000_000) + " juta" + Sisa(n % 1_000_000);
            if (n < 1_000_000_000_000) return Ubah(n / 1_000_000_000) + " miliar" + Sisa(n % 1_000_000_000);
            if (n < 1_000_000_000_000_000) return Ubah(n / 1_000_000_000_000) + " triliun" + Sisa(n % 1_000_000_000_000);

            return n.ToString();
        }

        /// <summary>Huruf berkapital di awal, untuk dicetak dalam sel tabel.</summary>
        public static string Kapital(long n)
        {
            var s = Ubah(n);
            return s.Length == 0 ? s : char.ToUpperInvariant(s[0]) + s.Substring(1);
        }

        // Sisa nol tidak dibunyikan: 100 adalah "seratus", bukan "seratus nol".
        private static string Sisa(long n) => n == 0 ? string.Empty : " " + Ubah(n);
    }
}
