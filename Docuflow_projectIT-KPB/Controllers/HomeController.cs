using Docuflow_projectIT_KPB.Models;
using Docuflow_projectIT_KPB.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;
using System.Linq;
using Docuflow_projectIT_KPB.Filters;

namespace Docuflow_projectIT_KPB.Controllers
{
    [SessionAuthorize]
    public class HomeController : Controller
    {
        private readonly ApplicationDbContext _context;

        public HomeController(ApplicationDbContext context)
        {
            _context = context;
        }

        public IActionResult Index()
        {
            var role = HttpContext.Session.GetString("Role");
            var superAdmin = role == "SuperAdmin";

            ViewBag.Role = role;

            ViewBag.TotalUsers = _context.Users.Count();
            ViewBag.TotalSurat = _context.Surat.Count();

            if (superAdmin)
            {
                // Beranda Super Admin: siapa melakukan apa, terbaru di atas.
                ViewBag.AktivitasTerbaru = _context.AuditLogs
                    .OrderByDescending(a => a.Waktu)
                    .Take(15)
                    .ToList();

                ViewBag.TotalAktivitas = _context.AuditLogs.Count();

                return View();
            }

            // =========================
            // BERANDA ADMIN
            // =========================
            ViewBag.SuratPerJenis = _context.Surat
                .Include(s => s.JenisSurat)
                .GroupBy(s => s.JenisSurat.NamaJenis)
                .Select(g => new
                {
                    NamaJenis = g.Key,
                    Total = g.Count()
                })
                .ToList();

            // Sebaran per bulan untuk tahun berjalan: jenis apa yang paling
            // sering dibuat, dan kapan.
            var tahun = DateTime.Now.Year;
            ViewBag.Tahun = tahun;

            var perBulan = _context.Surat
                .Include(s => s.JenisSurat)
                .Where(s => s.Tanggal.Year == tahun)
                .GroupBy(s => new { Bulan = s.Tanggal.Month, Jenis = s.JenisSurat.NamaJenis })
                .Select(g => new { g.Key.Bulan, g.Key.Jenis, Total = g.Count() })
                .ToList();

            // Dibentuk jadi matriks jenis x 12 bulan di sini, bukan di view.
            // View cukup menggambar, tidak perlu mengaduk data.
            var matriks = new Dictionary<string, int[]>();
            foreach (var baris in perBulan)
            {
                if (!matriks.ContainsKey(baris.Jenis))
                    matriks[baris.Jenis] = new int[12];

                matriks[baris.Jenis][baris.Bulan - 1] = baris.Total;
            }

            ViewBag.MatriksBulan = matriks;
            ViewBag.PuncakBulan = matriks.Count == 0
                ? 0
                : Enumerable.Range(0, 12).Max(b => matriks.Values.Sum(v => v[b]));

            ViewBag.JenisTerbanyak = matriks.Count == 0
                ? null
                : matriks.OrderByDescending(m => m.Value.Sum()).First().Key;

            ViewBag.TotalTahunIni = perBulan.Sum(p => p.Total);

            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(
            Duration = 0,
            Location = ResponseCacheLocation.None,
            NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel
            {
                RequestId = Activity.Current?.Id
                            ?? HttpContext.TraceIdentifier
            });
        }
    }
}