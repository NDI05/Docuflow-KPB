using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Http;
using Docuflow_projectIT_KPB.Data;
using Docuflow_projectIT_KPB.Models;
using Docuflow_projectIT_KPB.Services;
using System.IO;
using System.Linq;
using System.Text;

namespace Docuflow_projectIT_KPB.Controllers
{
    public class SuratController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly NomorSuratService _nomorService;

        public SuratController(ApplicationDbContext context, NomorSuratService nomorService)
        {
            _context = context;
            _nomorService = nomorService;
        }

        public async Task<IActionResult> Index()
        {
            var suratList = await _context.Surat
                .Include(s => s.JenisSurat)
                .Include(s => s.Staff)
                .Include(s => s.Manager)
                .Include(s => s.PenanggungJawab)
                .OrderByDescending(s => s.CreatedAt ?? s.Tanggal)
                .ToListAsync();

            return View(suratList);
        }

        public async Task<IActionResult> Create()
        {
            ViewBag.JenisSurat = await _context.JenisSurat.ToListAsync();
            ViewBag.Users = await _context.Users.ToListAsync();
            ViewBag.UploadedFile = TempData["UploadedFile"];

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UploadPreview(IFormFile file)
        {
            if (file == null || file.Length == 0)
            {
                TempData["Message"] = "File tidak valid.";
                return RedirectToAction(nameof(Create));
            }

            var allowedExtensions = new[] { ".pdf", ".doc", ".docx" };
            var ext = Path.GetExtension(file.FileName).ToLowerInvariant();

            if (!allowedExtensions.Contains(ext))
            {
                TempData["Message"] = "Format file harus PDF atau DOC.";
                return RedirectToAction(nameof(Create));
            }

            var uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "uploads");

            if (!Directory.Exists(uploadsFolder))
                Directory.CreateDirectory(uploadsFolder);

            var fileName = $"{DateTime.Now:yyyyMMddHHmmss}_{Path.GetFileName(file.FileName)}";
            var filePath = Path.Combine(uploadsFolder, fileName);

            await using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }

            TempData["UploadedFile"] = $"/uploads/{fileName}";
            return RedirectToAction(nameof(Create));
        }



        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Surat surat, IFormFile file)
        {
            var now = DateTime.Now;

            surat.Tanggal = now;
            surat.CreatedAt = now;

            // ===== PROSES UPLOAD FILE LANGSUNG DI SINI =====
            if (file != null && file.Length > 0)
            {
                var uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "uploads");

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

            return RedirectToAction(nameof(Details), new { id = surat.Id });
        }

        public async Task<IActionResult> Download(int id)
        {
            var surat = await _context.Surat
                .Include(s => s.JenisSurat)
                .Include(s => s.Staff)
                .Include(s => s.Manager)
                .Include(s => s.PenanggungJawab)
                .FirstOrDefaultAsync(s => s.Id == id);

            if (surat == null)
                return NotFound();

            // =============================
            // JIKA ADA FILE UPLOAD
            // =============================
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
                var ext = Path.GetExtension(fullPath).ToLowerInvariant();

                var contentType = ext switch
                {
                    ".pdf" => "application/pdf",
                    ".doc" => "application/msword",
                    ".docx" => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                    _ => "application/octet-stream"
                };

                var downloadName = $"{surat.NomorSurat}{ext}";
                return File(bytes, contentType, downloadName);
            }

            // =============================
            // JIKA SURAT MANUAL (UPDATED)
            // =============================
            var htmlContent = $@"
<html>
<head>
<meta charset='UTF-8'>
<style>
    body {{
        font-family: Arial, sans-serif;
        padding: 40px;
    }}
    h2 {{
        text-align: center;
        margin-bottom: 5px;
    }}
    hr {{
        margin-bottom: 25px;
    }}
    .label {{
        font-weight: bold;
    }}
    .section {{
        margin-bottom: 12px;
    }}
    .signature {{
        margin-top: 100px;
        display: flex;
        justify-content: space-between;
        text-align: center;
    }}
    .signature div {{
        width: 30%;
    }}
</style>
</head>
<body>

<h2>SURAT RESMI</h2>
<hr/>

<div class='section'>
    <span class='label'>Nomor:</span> {surat.NomorSurat}
</div>

<div class='section'>
    <span class='label'>Jenis Surat:</span> {surat.JenisSurat?.NamaJenis}
</div>

<div class='section'>
    <span class='label'>Tanggal:</span> {surat.Tanggal:dd MMMM yyyy}
</div>

<div class='section'>
    <span class='label'>Deskripsi:</span><br/>
    {surat.Deskripsi}
</div>

<div class='signature'>
    <div>
        Staff<br/><br/><br/>
        <b>{surat.Staff?.Nama}</b>
    </div>
    <div>
        Manager<br/><br/><br/>
        <b>{surat.Manager?.Nama}</b>
    </div>
    <div>
        Penanggung Jawab<br/><br/><br/>
        <b>{surat.PenanggungJawab?.Nama}</b>
    </div>
</div>

</body>
</html>";

            var bytesManual = Encoding.UTF8.GetBytes(htmlContent);
            var downloadNameManual = $"{surat.NomorSurat}.doc";

            return File(bytesManual, "application/msword", downloadNameManual);
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

            _context.Surat.Remove(surat);
            await _context.SaveChangesAsync();

            TempData["Message"] = "Surat berhasil dihapus.";
            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> Details(int id)
        {
            var surat = await _context.Surat
                .Include(s => s.JenisSurat)
                .Include(s => s.Staff)
                .Include(s => s.Manager)
                .Include(s => s.PenanggungJawab)
                .FirstOrDefaultAsync(s => s.Id == id);

            if (surat == null)
                return NotFound();

            return View(surat);
        }
    }
}