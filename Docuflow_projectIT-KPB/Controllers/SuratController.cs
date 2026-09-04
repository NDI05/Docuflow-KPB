using Docuflow.Services;
using Docuflow_projectIT_KPB.Data;
using Docuflow_projectIT_KPB.Filters;
using Docuflow_projectIT_KPB.Models;
using Docuflow_projectIT_KPB.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Rotativa.AspNetCore;
using Rotativa.AspNetCore.Options;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Docuflow_projectIT_KPB.Controllers
{
    // Admin dan Super Admin sama-sama boleh mengurus berita acara.
    //
    // Sebelumnya kedua peran ini terpisah penuh dan Super Admin ditolak di
    // sini. Pemisahan itu dilonggarkan menjadi bertingkat: Super Admin kini
    // superset — ia mengurus akun dan jejak audit, DAN berita acara. Yang
    // tetap satu arah adalah Users/*, yang masih hanya untuk Super Admin.
    [SessionAuthorize("Admin", "SuperAdmin")]
    public class SuratController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly NomorSuratService _nomorService;
        private readonly AuditLogService _auditLog;
        private readonly IWebHostEnvironment _env;

        public SuratController(
            ApplicationDbContext context,
            NomorSuratService nomorService,
            AuditLogService auditLog,
            IWebHostEnvironment env)
        {
            _context = context;
            _nomorService = nomorService;
            _auditLog = auditLog;
            _env = env;
        }

        /// <summary>
        /// Folder wwwroot/uploads, diselesaikan lewat IWebHostEnvironment.
        ///
        /// JANGAN kembali memakai Directory.GetCurrentDirectory(): di bawah IIS
        /// working directory-nya bukan folder aplikasi (biasanya
        /// C:\Windows\System32\inetsrv), sehingga unggah dan unduh menulis serta
        /// mencari berkas di tempat yang salah tanpa memunculkan error.
        /// </summary>
        private string FolderUploads =>
            Path.Combine(_env.WebRootPath, "uploads");

        private string PathFisik(string relatif) =>
            Path.Combine(_env.WebRootPath, relatif.TrimStart('/').Replace('/', Path.DirectorySeparatorChar));

        /// <summary>
        /// Kolom yang boleh dipakai mengurutkan arsip.
        ///
        /// Daftar putih, bukan pemetaan bebas: nilainya datang dari query
        /// string, dan kolom yang tidak dikenal harus jatuh ke bawaan alih-alih
        /// melempar. Bawaannya "tanggal" menurun — arsip dibaca dari yang
        /// terbaru.
        /// </summary>
        private static readonly string[] KolomUrut = { "nomor", "jenis", "tanggal", "staff" };

        public async Task<IActionResult> Index(string search, int? jenis, int? tahun, string sort, string dir, int page = 1)
        {
            int pageSize = 15;

            var query = _context.Surat
                .Include(s => s.JenisSurat)
                .Include(s => s.Staff)
                .Include(s => s.Manager)
                .AsQueryable();

            if (!string.IsNullOrWhiteSpace(search))
            {
                search = search.Trim();

                query = query.Where(s =>
                    s.NomorSurat.Contains(search) ||
                    s.JenisSurat.NamaJenis.Contains(search) ||
                    s.Staff.Nama.Contains(search)
                );
            }

            if (jenis.HasValue && jenis.Value > 0)
            {
                query = query.Where(s => s.JenisSuratId == jenis.Value);
            }

            // Disaring pada Tanggal, bukan CreatedAt: tahun yang tercetak pada
            // nomor surat berasal dari tahun pembuatan, dan Tanggal-lah yang
            // ikut tercetak di dokumen. Memakai CreatedAt akan membuat arsip
            // dan kertas menyebut tahun yang berbeda kalau keduanya berbeda.
            if (tahun.HasValue && tahun.Value > 0)
            {
                query = query.Where(s => s.Tanggal.Year == tahun.Value);
            }

            sort = (sort ?? string.Empty).Trim().ToLowerInvariant();
            if (Array.IndexOf(KolomUrut, sort) < 0) sort = "tanggal";

            bool naik = string.Equals(dir, "asc", StringComparison.OrdinalIgnoreCase);

            // ThenBy CreatedAt menurun dipasang pada kolom yang banyak nilai
            // kembarnya: tanpa itu urutan baris dengan jenis atau staff yang
            // sama ditentukan SQL Server dan bisa berubah antar halaman,
            // sehingga satu surat muncul dua kali atau hilang saat dipaginasi.
            query = sort switch
            {
                "nomor" => naik
                    ? query.OrderBy(s => s.NomorSurat)
                    : query.OrderByDescending(s => s.NomorSurat),

                "jenis" => naik
                    ? query.OrderBy(s => s.JenisSurat.NamaJenis).ThenByDescending(s => s.CreatedAt)
                    : query.OrderByDescending(s => s.JenisSurat.NamaJenis).ThenByDescending(s => s.CreatedAt),

                "staff" => naik
                    ? query.OrderBy(s => s.Staff.Nama).ThenByDescending(s => s.CreatedAt)
                    : query.OrderByDescending(s => s.Staff.Nama).ThenByDescending(s => s.CreatedAt),

                _ => naik
                    ? query.OrderBy(s => s.CreatedAt).ThenBy(s => s.Id)
                    : query.OrderByDescending(s => s.CreatedAt).ThenByDescending(s => s.Id),
            };

            int totalData = await query.CountAsync();
            int totalPages = (int)Math.Ceiling((double)totalData / pageSize);

            if (totalPages == 0) totalPages = 1;
            if (page < 1) page = 1;
            if (page > totalPages) page = totalPages;

            var suratList = await query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.Search = search;
            ViewBag.JenisId = jenis;
            ViewBag.Tahun = tahun;
            ViewBag.Sort = sort;
            ViewBag.Dir = naik ? "asc" : "desc";

            // Daftar saringan diambil dari JenisSurat, bukan dari surat yang
            // tampil: kalau diambil dari hasil, jenis yang sedang tersaring
            // habis akan menghilang dari pilihannya sendiri.
            ViewBag.DaftarJenis = await _context.JenisSurat
                .OrderBy(j => j.Kode)
                .ThenBy(j => j.NamaJenis)
                .ToListAsync();

            // Tahun diambil dari SELURUH arsip, bukan dari hasil yang tersaring:
            // kalau diambil dari hasil, tahun yang sedang dipilih akan hilang
            // dari pilihannya sendiri begitu hasilnya kosong.
            ViewBag.DaftarTahun = await _context.Surat
                .Select(s => s.Tanggal.Year)
                .Distinct()
                .OrderByDescending(t => t)
                .ToListAsync();

            return View(suratList);
        }

        public async Task<IActionResult> Create()
        {
            ViewBag.JenisSurat = await _context.JenisSurat
                .OrderBy(j => j.NamaJenis)
                .ToListAsync();

            ViewBag.Users = await _context.Users
                .OrderBy(u => u.Nama)
                .ToListAsync();

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Surat surat, IFormFile file)
        {
            var now = DateTime.Now;

            surat.Tanggal = now;
            surat.CreatedAt = now;

            // Satu tabel barang melayani dua jenis dokumen. BAST mengisi nama
            // barang dan pengguna; BAPB mengisi jumlah, satuan, dan keterangan.
            // Kolom milik jenis yang lain dikirim kosong oleh form.
            var namaBarang = Request.Form["NamaBarang[]"];
            var jumlah = Request.Form["Jumlah[]"];
            var satuan = Request.Form["Satuan[]"];
            var serialNumber = Request.Form["SerialNumber[]"];
            var merkType = Request.Form["MerkType[]"];
            var pengguna = Request.Form["Pengguna[]"];
            var keteranganBarang = Request.Form["Keterangan[]"];
            var tanggalBarang = Request.Form["TanggalBarang[]"];
            var jamBarang = Request.Form["JamBarang[]"];
            var rekaman = Request.Form["Rekaman[]"];
            var area = Request.Form["Area[]"];

            surat.BarangList = new List<BarangSurat>();

            // Max, bukan Min: array yang tidak dikirim sama sekali panjangnya
            // nol, dan Min akan membuat SELURUH baris barang hilang tanpa
            // pesan apa pun. Itu terjadi pada setiap klien yang belum tahu
            // kolom baru — termasuk db/test-nomor-concurrent.sh, yang hanya
            // mengirim empat array. Indeks yang lewat batas dibaca kosong.
            int max = new int[]
            {
                namaBarang.Count,
                jumlah.Count,
                satuan.Count,
                serialNumber.Count,
                merkType.Count,
                pengguna.Count,
                keteranganBarang.Count,
                tanggalBarang.Count,
                jamBarang.Count,
                rekaman.Count,
                area.Count
            }.Max();

            static string Kolom(Microsoft.Extensions.Primitives.StringValues v, int i) =>
                i < v.Count ? (v[i] ?? string.Empty) : string.Empty;

            for (int i = 0; i < max; i++)
            {
                // Baris dianggap terisi kalau kolom apa pun ada isinya, bukan
                // hanya kalau nama barangnya terisi: pada BAPB tidak ada kolom
                // nama barang sama sekali, dan syarat lama membuang seluruh
                // barisnya tanpa pesan apa pun.
                var vNama = Kolom(namaBarang, i);
                var vJumlah = Kolom(jumlah, i);
                var vSatuan = Kolom(satuan, i);
                var vSerial = Kolom(serialNumber, i);
                var vMerk = Kolom(merkType, i);
                var vPengguna = Kolom(pengguna, i);
                var vKeterangan = Kolom(keteranganBarang, i);
                var vTanggal = Kolom(tanggalBarang, i);
                var vJam = Kolom(jamBarang, i);
                var vRekaman = Kolom(rekaman, i);
                var vArea = Kolom(area, i);

                bool kosong =
                    string.IsNullOrWhiteSpace(vNama) &&
                    string.IsNullOrWhiteSpace(vJumlah) &&
                    string.IsNullOrWhiteSpace(vSerial) &&
                    string.IsNullOrWhiteSpace(vMerk) &&
                    string.IsNullOrWhiteSpace(vPengguna) &&
                    string.IsNullOrWhiteSpace(vKeterangan) &&
                    string.IsNullOrWhiteSpace(vTanggal) &&
                    string.IsNullOrWhiteSpace(vJam) &&
                    string.IsNullOrWhiteSpace(vRekaman) &&
                    string.IsNullOrWhiteSpace(vArea);

                if (kosong) continue;

                surat.BarangList.Add(new BarangSurat
                {
                    NamaBarang = vNama,
                    Jumlah = int.TryParse(vJumlah, out var n) ? n : null,
                    Satuan = string.IsNullOrWhiteSpace(vSatuan) ? null : vSatuan.Trim(),
                    SerialNumber = vSerial,
                    MerkType = vMerk,
                    Pengguna = vPengguna,
                    Keterangan = string.IsNullOrWhiteSpace(vKeterangan) ? null : vKeterangan.Trim(),
                    Tanggal = string.IsNullOrWhiteSpace(vTanggal) ? null : vTanggal.Trim(),
                    Jam = string.IsNullOrWhiteSpace(vJam) ? null : vJam.Trim(),
                    Rekaman = string.IsNullOrWhiteSpace(vRekaman) ? null : vRekaman.Trim(),
                    Area = string.IsNullOrWhiteSpace(vArea) ? null : vArea.Trim()
                });
            }

            surat.FilePath = await SimpanBerkas(file);

            // ---------------------------------------------------------------
            // POIN LAPORAN (jenis surat berkode BA)
            //
            // Tiap baris membawa kunci acak buatan sisi klien. Gambar dinamai
            // "Gambar_<kunci>", bukan "Gambar_<indeks>", supaya menghapus satu
            // baris tidak menggeser berkas milik baris lain.
            // ---------------------------------------------------------------
            var poinKey = Request.Form["PoinKey[]"];
            var poinLevel = Request.Form["PoinLevel[]"];
            var poinJudul = Request.Form["PoinJudul[]"];
            var poinKeterangan = Request.Form["PoinKeterangan[]"];

            surat.PoinList = new List<PoinSurat>();

            int jumlahPoin = new[]
            {
                poinKey.Count, poinLevel.Count, poinJudul.Count, poinKeterangan.Count
            }.Min();

            for (int i = 0; i < jumlahPoin; i++)
            {
                if (string.IsNullOrWhiteSpace(poinJudul[i]))
                    continue;

                var poin = new PoinSurat
                {
                    Level = int.TryParse(poinLevel[i], out var lv) ? Math.Clamp(lv, 0, 2) : 0,
                    Urutan = surat.PoinList.Count,
                    Judul = poinJudul[i]!.Trim(),
                    Keterangan = poinKeterangan[i]
                };

                var berkasGambar = Request.Form.Files.GetFiles($"Gambar_{poinKey[i]}");

                foreach (var g in berkasGambar)
                {
                    var path = await SimpanBerkas(g);
                    if (path != null)
                    {
                        poin.Gambar.Add(new GambarPoin
                        {
                            FilePath = path,
                            Urutan = poin.Gambar.Count
                        });
                    }
                }

                surat.PoinList.Add(poin);
            }

            // Satu transaksi untuk generate nomor + insert surat. Dua alasan:
            // 1. Kunci baris counter di NomorSuratService baru bertahan sampai
            //    commit kalau ada transaksi — tanpa ini dua submit bersamaan
            //    bisa dapat nomor sama.
            // 2. Kalau insert surat gagal, counter ikut di-rollback dan nomor
            //    tidak hangus.
            await using (var tx = await _context.Database.BeginTransactionAsync())
            {
                surat.NomorSurat = await _nomorService.GenerateNomorSurat(surat.JenisSuratId);

                _context.Surat.Add(surat);
                await _context.SaveChangesAsync();

                await tx.CommitAsync();
            }

            // AUDIT LOG — sengaja di luar transaksi supaya gagalnya pencatatan
            // audit tidak ikut membatalkan surat yang sudah tersimpan.
            _auditLog.Log(
                HttpContext.Session.GetString("Username") ?? "-",
                "Generate Nomor Surat",
                $"Membuat surat nomor {surat.NomorSurat}"
            );

            return RedirectToAction(nameof(Details), new { id = surat.Id });
        }

        /// <summary>
        /// Menyimpan satu berkas unggahan ke wwwroot/uploads dan mengembalikan
        /// path relatifnya. Mengembalikan null kalau tidak ada berkas.
        ///
        /// Nama berkas diberi awalan waktu + acak: dua orang yang mengunggah
        /// "foto.jpg" pada detik yang sama tidak boleh saling menimpa.
        /// </summary>
        private async Task<string?> SimpanBerkas(IFormFile? berkas)
        {
            if (berkas == null || berkas.Length == 0)
                return null;

            var folder = FolderUploads;

            if (!Directory.Exists(folder))
                Directory.CreateDirectory(folder);

            var namaAman = Path.GetFileName(berkas.FileName);
            var nama = $"{DateTime.Now:yyyyMMddHHmmss}_{Guid.NewGuid():N}_{namaAman}";

            using (var stream = new FileStream(Path.Combine(folder, nama), FileMode.Create))
            {
                await berkas.CopyToAsync(stream);
            }

            return "/uploads/" + nama;
        }

        /// <summary>
        /// Memilih berkas template cetak berdasarkan kode jenis surat.
        /// BAST memakai tata letak berita acara serah terima, BA tata letak
        /// laporan, BAPB tata letak pengembalian barang.
        ///
        /// Preview dan GeneratePdf sama-sama lewat sini, jadi keduanya tidak
        /// bisa memakai template yang berbeda.
        /// </summary>
        private static string NamaTemplate(Surat surat)
        {
            var kode = surat.JenisSurat?.Kode?.Trim().ToUpperInvariant();

            return kode switch
            {
                "BA"   => "SuratTemplateBa",
                "BAPB" => "SuratTemplateBapb",
                _      => "SuratTemplate"
            };
        }

        /// <summary>
        /// BALP tidak dicetak Docuflow — suratnya dibuat vendor. Tanpa penjaga
        /// ini NamaTemplate akan jatuh ke cabang bawaan dan merender BALP
        /// memakai tata letak BAST, menghasilkan dokumen yang tampak resmi tapi
        /// bukan dokumen yang sebenarnya berlaku.
        ///
        /// Tombolnya memang disembunyikan di Details, tapi menyembunyikan
        /// tombol bukan penjagaan — routenya yang harus menolak.
        /// </summary>
        private IActionResult? TolakKalauBalp(Surat surat)
        {
            if (!Balp.Adalah(surat.JenisSurat?.Kode))
                return null;

            TempData["Error"] = "Berita Acara Layak Pakai dibuat oleh vendor, bukan dicetak dari sistem. Unggah berkasnya dari halaman detail.";
            return RedirectToAction(nameof(Details), new { id = surat.Id });
        }

        public async Task<IActionResult> Details(int id)
        {
            var surat = await _context.Surat
                .Include(s => s.JenisSurat)
                .Include(s => s.Staff)
                .Include(s => s.Manager)
                .Include(s => s.BarangList)
                // Urutan poin menentukan penomoran 1 / 1.1 / 1.1.1, jadi tidak
                // boleh diserahkan pada urutan bawaan database.
                .Include(s => s.PoinList!.OrderBy(p => p.Urutan))
                    .ThenInclude(p => p.Gambar.OrderBy(g => g.Urutan))
                .FirstOrDefaultAsync(s => s.Id == id);

            if (surat == null)
                return NotFound();

            return View(surat);
        }

        public async Task<IActionResult> Preview(int id)
        {
            var surat = await _context.Surat
                .AsNoTracking()
                .Include(s => s.JenisSurat)
                .Include(s => s.Staff)
                .Include(s => s.Manager)
                .Include(s => s.BarangList)
                // Urutan poin menentukan penomoran 1 / 1.1 / 1.1.1, jadi tidak
                // boleh diserahkan pada urutan bawaan database.
                .Include(s => s.PoinList!.OrderBy(p => p.Urutan))
                    .ThenInclude(p => p.Gambar.OrderBy(g => g.Urutan))
                .FirstOrDefaultAsync(s => s.Id == id);

            if (surat == null)
                return NotFound();

            var tolak = TolakKalauBalp(surat);
            if (tolak != null) return tolak;

            return View(NamaTemplate(surat), surat);
        }

        public async Task<IActionResult> GeneratePdf(int id)
        {
            var surat = await _context.Surat
                .AsNoTracking()
                .Include(s => s.JenisSurat)
                .Include(s => s.Staff)
                .Include(s => s.Manager)
                .Include(s => s.BarangList)
                // Urutan poin menentukan penomoran 1 / 1.1 / 1.1.1, jadi tidak
                // boleh diserahkan pada urutan bawaan database.
                .Include(s => s.PoinList!.OrderBy(p => p.Urutan))
                    .ThenInclude(p => p.Gambar.OrderBy(g => g.Urutan))
                .FirstOrDefaultAsync(s => s.Id == id);

            if (surat == null)
                return NotFound();

            var tolak = TolakKalauBalp(surat);
            if (tolak != null) return tolak;

            return new ViewAsPdf(NamaTemplate(surat), surat)
            {
                FileName = $"Surat_{surat.NomorSurat}.pdf",
                PageSize = Size.A4,
                PageOrientation = Orientation.Portrait
            };
        }

        public async Task<IActionResult> Download(int id)
        {
            var surat = await _context.Surat
                .AsNoTracking()
                .Include(s => s.JenisSurat)
                .Include(s => s.Staff)
                .Include(s => s.Manager)
                .Include(s => s.BarangList)
                // Urutan poin menentukan penomoran 1 / 1.1 / 1.1.1, jadi tidak
                // boleh diserahkan pada urutan bawaan database.
                .Include(s => s.PoinList!.OrderBy(p => p.Urutan))
                    .ThenInclude(p => p.Gambar.OrderBy(g => g.Urutan))
                .FirstOrDefaultAsync(s => s.Id == id);

            if (surat == null)
                return NotFound();

            if (!string.IsNullOrEmpty(surat.FilePath))
            {
                var fullPath = PathFisik(surat.FilePath);

                if (!System.IO.File.Exists(fullPath))
                    return NotFound();

                var bytes = await System.IO.File.ReadAllBytesAsync(fullPath);

                var ext = Path.GetExtension(fullPath).ToLower();

                var contentType = ext switch
                {
                    ".pdf" => "application/pdf",
                    ".doc" => "application/msword",
                    ".docx" => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                    _ => "application/octet-stream"
                };

                return File(bytes, contentType, $"{surat.NomorSurat}{ext}");
            }

            // Jenis lain punya templat, jadi "unduh" tanpa lampiran wajar
            // diartikan "cetak dokumennya". BALP tidak punya templat: kalau
            // berkas vendornya belum diunggah, memang belum ada yang bisa
            // diunduh.
            var tolak = TolakKalauBalp(surat);
            if (tolak != null) return tolak;

            return RedirectToAction(nameof(GeneratePdf), new { id });
        }

        // =========================
        // UNGGAH BERKAS BALP
        //
        // Langkah kedua BALP. Nomor terbit lebih dulu dan diberikan ke vendor;
        // berkas dan tanggal suratnya baru ada setelah vendor menyusunnya, jadi
        // keduanya tidak bisa diminta di formulir pembuatan.
        // =========================
        public async Task<IActionResult> UnggahBalp(int id)
        {
            var surat = await _context.Surat
                .Include(s => s.JenisSurat)
                .FirstOrDefaultAsync(s => s.Id == id);

            if (surat == null)
                return NotFound();

            if (!Balp.Adalah(surat.JenisSurat?.Kode))
            {
                TempData["Error"] = "Unggah berkas hanya berlaku untuk Berita Acara Layak Pakai.";
                return RedirectToAction(nameof(Details), new { id });
            }

            return View(surat);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UnggahBalp(int id, IFormFile berkas, DateTime? tanggalBalp)
        {
            var surat = await _context.Surat
                .Include(s => s.JenisSurat)
                .FirstOrDefaultAsync(s => s.Id == id);

            if (surat == null)
                return NotFound();

            // Diperiksa di server, bukan hanya disembunyikan di Details: aksi
            // ini mengubah FilePath, dan jenis lain memakai kolom itu untuk
            // lampiran yang diunggah saat pembuatan.
            if (!Balp.Adalah(surat.JenisSurat?.Kode))
            {
                TempData["Error"] = "Unggah berkas hanya berlaku untuk Berita Acara Layak Pakai.";
                return RedirectToAction(nameof(Details), new { id });
            }

            var pathBaru = await SimpanBerkas(berkas);

            if (pathBaru == null && !tanggalBalp.HasValue)
            {
                TempData["Error"] = "Pilih berkas atau isi tanggal BALP lebih dulu.";
                return RedirectToAction(nameof(UnggahBalp), new { id });
            }

            if (pathBaru != null)
            {
                // Berkas lama dibuang supaya unggah ulang tidak meninggalkan
                // sampah yang tidak dirujuk baris mana pun.
                if (!string.IsNullOrEmpty(surat.FilePath))
                {
                    var lama = PathFisik(surat.FilePath);
                    if (System.IO.File.Exists(lama)) System.IO.File.Delete(lama);
                }

                surat.FilePath = pathBaru;
            }

            if (tanggalBalp.HasValue)
                surat.TanggalBalp = tanggalBalp.Value;

            await _context.SaveChangesAsync();

            TempData["Message"] = "Berkas BALP tersimpan.";
            return RedirectToAction(nameof(Details), new { id });
        }

        // =========================
        // DELETE SURAT
        // =========================
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            var surat = await _context.Surat
                .Include(s => s.PoinList!)
                    .ThenInclude(p => p.Gambar)
                .FirstOrDefaultAsync(s => s.Id == id);

            if (surat == null)
                return NotFound();

            // Baris database ikut terhapus lewat cascade, tapi berkas fisiknya
            // tidak — tanpa ini gambar poin menumpuk sebagai sampah di disk.
            var berkas = new List<string>();

            if (!string.IsNullOrEmpty(surat.FilePath))
                berkas.Add(surat.FilePath);

            if (surat.PoinList != null)
            {
                foreach (var poin in surat.PoinList)
                    foreach (var gambar in poin.Gambar)
                        berkas.Add(gambar.FilePath);
            }

            foreach (var path in berkas)
            {
                var fullPath = PathFisik(path);

                if (System.IO.File.Exists(fullPath))
                    System.IO.File.Delete(fullPath);
            }

            // AUDIT LOG
            _auditLog.Log(
                HttpContext.Session.GetString("Username") ?? "-",
                "Hapus Surat",
                $"Menghapus surat nomor {surat.NomorSurat}"
            );

            _context.Surat.Remove(surat);
            await _context.SaveChangesAsync();

            TempData["Message"] = "Surat berhasil dihapus.";

            return RedirectToAction(nameof(Index));
        }
    }
}