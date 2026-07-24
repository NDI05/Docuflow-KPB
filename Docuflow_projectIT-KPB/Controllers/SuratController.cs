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
    [SessionAuthorize]
    public class SuratController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly NomorSuratService _nomorService;
        private readonly AuditLogService _auditLog;

        public SuratController(
            ApplicationDbContext context,
            NomorSuratService nomorService,
            AuditLogService auditLog)
        {
            _context = context;
            _nomorService = nomorService;
            _auditLog = auditLog;
        }

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

            if (file != null && file.Length > 0)
            {
                var uploadsFolder = Path.Combine(
                    Directory.GetCurrentDirectory(),
                    "wwwroot",
                    "uploads"
                );

                if (!Directory.Exists(uploadsFolder))
                    Directory.CreateDirectory(uploadsFolder);

                var fileName = $"{DateTime.Now:yyyyMMddHHmmss}_{Path.GetFileName(file.FileName)}";
                var filePath = Path.Combine(uploadsFolder, fileName);

                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await file.CopyToAsync(stream);
                }

                surat.FilePath = "/uploads/" + fileName;
            }

            surat.NomorSurat = await _nomorService.GenerateNomorSurat(surat.JenisSuratId);

            var pj = await _context.Users
                .FirstOrDefaultAsync(u => u.Role == "PenanggungJawab");

            if (pj != null)
                surat.PenanggungJawabId = pj.Id;

            _context.Surat.Add(surat);
            await _context.SaveChangesAsync();

            // AUDIT LOG
            _auditLog.Log(
                HttpContext.Session.GetString("Username") ?? "-",
                "Generate Nomor Surat",
                $"Membuat surat nomor {surat.NomorSurat}"
            );

            return RedirectToAction(nameof(Details), new { id = surat.Id });
        }

        public async Task<IActionResult> Details(int id)
        {
            var surat = await _context.Surat
                .Include(s => s.JenisSurat)
                .Include(s => s.Staff)
                .Include(s => s.Manager)
                .Include(s => s.PenanggungJawab)
                .Include(s => s.BarangList)
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
                .FirstOrDefaultAsync(s => s.Id == id);

            if (surat == null)
                return NotFound();

            return View("SuratTemplate", surat);
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
                .FirstOrDefaultAsync(s => s.Id == id);

            if (surat == null)
                return NotFound();

            return new ViewAsPdf("SuratTemplate", surat)
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
                .FirstOrDefaultAsync(s => s.Id == id);

            if (surat == null)
                return NotFound();

            if (!string.IsNullOrEmpty(surat.FilePath))
            {
                var fullPath = Path.Combine(
                    Directory.GetCurrentDirectory(),
                    "wwwroot",
                    surat.FilePath.TrimStart('/')
                );

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
            var surat = await _context.Surat.FindAsync(id);

            if (surat == null)
                return NotFound();

            if (!string.IsNullOrEmpty(surat.FilePath))
            {
                var fullPath = Path.Combine(
                    Directory.GetCurrentDirectory(),
                    "wwwroot",
                    surat.FilePath.TrimStart('/')
                );

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