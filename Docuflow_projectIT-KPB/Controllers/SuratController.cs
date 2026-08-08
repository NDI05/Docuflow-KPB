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
    // Berita acara adalah wilayah Admin. Super Admin mengurus akun dan jejak
    // audit, dan sengaja tidak diberi jalan masuk ke sini.
    [SessionAuthorize("Admin")]
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

        public async Task<IActionResult> Index(string search, int page = 1)
        {
            int pageSize = 15;

            var query = _context.Surat
                .Include(s => s.JenisSurat)
                .Include(s => s.Staff)
                .Include(s => s.Manager)
                .Include(s => s.PenanggungJawab)
                .OrderByDescending(s => s.CreatedAt)
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

            var namaBarang = Request.Form["NamaBarang[]"];
            var serialNumber = Request.Form["SerialNumber[]"];
            var merkType = Request.Form["MerkType[]"];
            var pengguna = Request.Form["Pengguna[]"];

            surat.BarangList = new List<BarangSurat>();

            int max = new int[]
            {
                namaBarang.Count,
                serialNumber.Count,
                merkType.Count,
                pengguna.Count
            }.Min();

            for (int i = 0; i < max; i++)
            {
                if (!string.IsNullOrWhiteSpace(namaBarang[i]))
                {
                    surat.BarangList.Add(new BarangSurat
                    {
                        NamaBarang = namaBarang[i],
                        SerialNumber = serialNumber[i],
                        MerkType = merkType[i],
                        Pengguna = pengguna[i]
                    });
                }
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

                // Penanggung jawab sekarang ditandai lewat PosisiTtd, bukan Role.
                // OrderBy ditambahkan supaya pilihannya deterministik — tanpa itu
                // urutan baris ditentukan SQL Server dan bisa berubah sewaktu-waktu.
                var pj = await _context.Users
                    .OrderBy(u => u.Id)
                    .FirstOrDefaultAsync(u => u.PosisiTtd == "PenanggungJawab");

                if (pj != null)
                    surat.PenanggungJawabId = pj.Id;

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
        /// BAST memakai tata letak berita acara serah terima; BA memakai
        /// tata letak laporan.
        /// </summary>
        private static string NamaTemplate(Surat surat)
        {
            var kode = surat.JenisSurat?.Kode?.Trim().ToUpperInvariant();

            return kode switch
            {
                "BA" => "SuratTemplateBa",
                _    => "SuratTemplate"
            };
        }

        public async Task<IActionResult> Details(int id)
        {
            var surat = await _context.Surat
                .Include(s => s.JenisSurat)
                .Include(s => s.Staff)
                .Include(s => s.Manager)
                .Include(s => s.PenanggungJawab)
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
                .Include(s => s.PenanggungJawab)
                .Include(s => s.BarangList)
                // Urutan poin menentukan penomoran 1 / 1.1 / 1.1.1, jadi tidak
                // boleh diserahkan pada urutan bawaan database.
                .Include(s => s.PoinList!.OrderBy(p => p.Urutan))
                    .ThenInclude(p => p.Gambar.OrderBy(g => g.Urutan))
                .FirstOrDefaultAsync(s => s.Id == id);

            if (surat == null)
                return NotFound();

            return View(NamaTemplate(surat), surat);
        }

        public async Task<IActionResult> GeneratePdf(int id)
        {
            var surat = await _context.Surat
                .AsNoTracking()
                .Include(s => s.JenisSurat)
                .Include(s => s.Staff)
                .Include(s => s.Manager)
                .Include(s => s.PenanggungJawab)
                .Include(s => s.BarangList)
                // Urutan poin menentukan penomoran 1 / 1.1 / 1.1.1, jadi tidak
                // boleh diserahkan pada urutan bawaan database.
                .Include(s => s.PoinList!.OrderBy(p => p.Urutan))
                    .ThenInclude(p => p.Gambar.OrderBy(g => g.Urutan))
                .FirstOrDefaultAsync(s => s.Id == id);

            if (surat == null)
                return NotFound();

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
                .Include(s => s.PenanggungJawab)
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

            return RedirectToAction(nameof(GeneratePdf), new { id });
        }

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