using Docuflow_projectIT_KPB.Models;
using Docuflow_projectIT_KPB.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;
using System.Linq;

namespace Docuflow_projectIT_KPB.Controllers
{
    public class HomeController : Controller
    {
        private readonly ApplicationDbContext _context;

        public HomeController(ApplicationDbContext context)
        {
            _context = context;
        }

        public IActionResult Index()
        {
            // Total keseluruhan
            ViewBag.TotalUsers = _context.Users.Count();
            ViewBag.TotalSurat = _context.Surat.Count();

            // Total surat per jenis
            var suratPerJenis = _context.Surat
                .Include(s => s.JenisSurat)
                .GroupBy(s => s.JenisSurat.NamaJenis)
                .Select(g => new
                {
                    NamaJenis = g.Key,
                    Total = g.Count()
                })
                .ToList();

            ViewBag.SuratPerJenis = suratPerJenis;

            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel
            {
                RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier
            });
        }
    }
}