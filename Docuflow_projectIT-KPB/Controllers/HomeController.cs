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
            // =========================
            // TOTAL USERS
            // =========================
            ViewBag.TotalUsers = _context.Users.Count();

            // =========================
            // TOTAL SURAT
            // =========================
            ViewBag.TotalSurat = _context.Surat.Count();

            // =========================
            // SURAT PER JENIS
            // =========================
            var suratPerJenis = _context.Surat
                .Include(s => s.JenisSurat)
                .GroupBy(s => s.JenisSurat.NamaJenis)
                .Select(g => new
                {
                    NamaJenis = g.Key,
                    Total = g.Count()
                })
                .ToList();

            // Dictionary, not an anonymous type: the view reads it without dynamic binding.
            ViewBag.SuratPerJenis = suratPerJenis
                .ToDictionary(x => x.NamaJenis ?? "Tanpa jenis", x => x.Total);

            // =========================
            // AUDIT LOG TERBARU
            // =========================
            ViewBag.AktivitasTerbaru = _context.AuditLogs
                .OrderByDescending(a => a.Waktu)
                .Take(10)
                .ToList();

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