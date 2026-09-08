using Docuflow_projectIT_KPB.Data;
using Docuflow_projectIT_KPB.Models;
using Microsoft.EntityFrameworkCore;

namespace Docuflow_projectIT_KPB.Services
{
    public class NomorSuratService
    {
        private readonly ApplicationDbContext _context;

        // Bagian nomor yang tidak berubah.
        //
        // KodeAkhir memang selalu "S0" — dikonfirmasi terhadap data lama, yang
        // memuat 259 dokumen berakhiran S0 dan 4 berakhiran S9. Empat itu
        // penyimpangan, bukan aturan, jadi tetap konstanta.
        //
        // KodeKilang juga konstanta, tapi data lama menunjukkan BAST pernah
        // memakai KPB2000 (25 dokumen) dan KPB2200 (4) pada DERET NOMOR YANG
        // SAMA. Bentuk itu tidak bisa dihasilkan di sini; kalau suatu saat
        // perlu, kolom inilah yang pindah ke data, bukan ke konfigurasi.
        private const string KodeKilang = "KPB3240";
        private const string KodeAkhir = "S0";

        public NomorSuratService(ApplicationDbContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Menaikkan counter dan mengembalikan nomor surat berikutnya dengan
        /// bentuk <c>{KODE} {NNN}/KPB3240/{tahun}-S0</c>.
        ///
        /// WAJIB dipanggil di dalam transaksi milik pemanggil (lihat
        /// SuratController.Create). Di luar transaksi, UPDLOCK/HOLDLOCK di bawah
        /// dilepas begitu statement selesai dan dua submit bersamaan kembali bisa
        /// mendapat nomor yang sama.
        /// </summary>
        public async Task<string> GenerateNomorSurat(int jenisSuratId)
        {
            // Kode diambil dari kolom Kode, bukan dipotong dari NamaJenis.
            // Dengan begitu nama jenis boleh ditulis manusiawi, dan beberapa
            // jenis boleh berbagi satu kode.
            var kode = await _context.JenisSurat
                .Where(j => j.Id == jenisSuratId)
                .Select(j => j.Kode)
                .FirstOrDefaultAsync();

            // Cadangan "BA" sengaja ditinggal DI SINI, bukan dipindah ke
            // kelebihan-beban di bawah. Ini nilai bawaan untuk baris JenisSurat
            // yang kolom Kode-nya kosong. Kalau ikut pindah, pemanggil lain
            // yang mengirim kode kosong akan diam-diam mendapat nomor BA pada
            // dokumen yang bukan BA, alih-alih gagal dengan jelas.
            return await GenerateNomorSurat(string.IsNullOrWhiteSpace(kode) ? "BA" : kode);
        }

        /// <summary>
        /// Menaikkan counter untuk sebuah KODE dan mengembalikan nomor
        /// berikutnya. Dipakai dokumen yang tidak punya baris JenisSurat —
        /// SPD, misalnya, yang bukan berita acara dan sengaja tidak boleh
        /// muncul di formulir maupun arsip berita acara.
        ///
        /// WAJIB dipanggil di dalam transaksi milik pemanggil, sama seperti
        /// kelebihan-beban di atas. Di luar transaksi, UPDLOCK/HOLDLOCK di
        /// bawah dilepas begitu statement selesai dan dua submit bersamaan
        /// kembali bisa mendapat nomor yang sama.
        /// </summary>
        public async Task<string> GenerateNomorSurat(string kode)
        {
            var tahun = DateTime.Now.Year;

            kode = (kode ?? string.Empty).Trim().ToUpperInvariant();

            if (kode.Length == 0)
                throw new ArgumentException("Kode nomor surat tidak boleh kosong.", nameof(kode));

            // UPDLOCK: transaksi lain yang menjalankan SELECT yang sama akan
            // menunggu, bukan ikut membaca nilai lama (update lock tidak
            // kompatibel dengan update lock).
            // HOLDLOCK: kunci ditahan sampai transaksi commit — termasuk
            // key-range lock kalau baris counter belum ada, sehingga dua
            // transaksi tidak bisa sama-sama menyisipkan counter baru.
            var counter = await _context.CounterNomorSurat
                .FromSqlInterpolated($@"
                    SELECT * FROM CounterNomorSurat WITH (UPDLOCK, HOLDLOCK)
                    WHERE Kode = {kode} AND Tahun = {tahun}")
                .FirstOrDefaultAsync();

            if (counter == null)
            {
                counter = new CounterNomorSurat
                {
                    Kode = kode,
                    Tahun = tahun,
                    NomorTerakhir = 1
                };

                _context.CounterNomorSurat.Add(counter);
            }
            else
            {
                counter.NomorTerakhir += 1;
            }

            await _context.SaveChangesAsync();

            var nomorUrut = counter.NomorTerakhir.ToString("D3");

            // Tanpa "No." di antara kode dan nomor. Sistem lama menulis
            // "BAPB 027/KPB3240/2024-S0", dan deret nomornya DILANJUTKAN di
            // sini — bukan dimulai ulang. Menyisipkan "No." akan membuat satu
            // deret yang sama tertulis dua bentuk, terpotong tepat di titik
            // pergantian sistem.
            return $"{kode} {nomorUrut}/{KodeKilang}/{tahun}-{KodeAkhir}";
        }
    }
}
