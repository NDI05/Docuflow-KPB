using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Docuflow_projectIT_KPB.Data;
using Docuflow_projectIT_KPB.Models;
using Docuflow_projectIT_KPB.Filters;
using BCrypt.Net;

namespace Docuflow_projectIT_KPB.Controllers
{
    // Seluruh menu pengguna milik Super Admin. Admin biasa mengurus berita
    // acara dan tidak berkepentingan menambah atau menghapus akun.
    [SessionAuthorize("SuperAdmin")]
    public class UsersController : Controller
    {
        private readonly ApplicationDbContext _context;

        public UsersController(ApplicationDbContext context)
        {
            _context = context;
        }

        // =========================
        // LIST USERS (SEARCH + PAGINATION)
        // =========================
        public async Task<IActionResult> Index(string search, int page = 1)
        {
            int pageSize = 15;

            var query = _context.Users.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search))
            {
                search = search.Trim();

                query = query.Where(u =>
                    u.Nama.Contains(search) ||
                    u.Role.Contains(search) ||
                    u.NomorPegawai.Contains(search) ||
                    u.Username.Contains(search)
                );
            }

            int totalData = await query.CountAsync();
            int totalPages = (int)Math.Ceiling((double)totalData / pageSize);

            if (totalPages == 0) totalPages = 1;
            if (page < 1) page = 1;
            if (page > totalPages) page = totalPages;

            var users = await query
                .OrderBy(u => u.Nama)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.Search = search;

            return View(users);
        }

        // =========================
        // CREATE USER FORM
        // =========================
        public IActionResult Create()
        {
            return View();
        }

        // =========================
        // CREATE USER POST
        // =========================
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(User user, string password)
        {
            if (string.IsNullOrWhiteSpace(user.Nama) ||
                string.IsNullOrWhiteSpace(user.Username) ||
                string.IsNullOrWhiteSpace(password) ||
                string.IsNullOrWhiteSpace(user.Role))
            {
                TempData["Error"] = "Nama, username, peran, dan kata sandi wajib diisi.";
                return View(user);
            }

            // Role menentukan hak akses dan datang dari form, jadi tidak boleh
            // dipercaya begitu saja. Isi <select> hanya petunjuk untuk manusia;
            // siapa pun bisa mengirim nilai lain.
            if (user.Role != "SuperAdmin" && user.Role != "Admin")
            {
                TempData["Error"] = "Peran tidak dikenali.";
                return View(user);
            }

            if (!string.IsNullOrWhiteSpace(user.PosisiTtd) &&
                user.PosisiTtd != "Staff" &&
                user.PosisiTtd != "Manager" &&
                user.PosisiTtd != "PenanggungJawab")
            {
                TempData["Error"] = "Posisi tanda tangan tidak dikenali.";
                return View(user);
            }

            if (string.IsNullOrWhiteSpace(user.PosisiTtd))
                user.PosisiTtd = null;

            // cek username duplicate
            bool usernameExist = await _context.Users.AnyAsync(x => x.Username == user.Username);
            if (usernameExist)
            {
                TempData["Error"] = "Username sudah digunakan.";
                return View(user);
            }

            // hash password
            user.Password = BCrypt.Net.BCrypt.HashPassword(password);

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            TempData["Message"] = "User berhasil ditambahkan.";
            return RedirectToAction(nameof(Index));
        }

        // =========================
        // RESET PASSWORD FORM
        // =========================
        public async Task<IActionResult> ResetPassword(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
                return NotFound();

            return View(user);
        }

        // =========================
        // RESET PASSWORD POST
        // =========================
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ResetPassword(int id, string newPassword, string confirmPassword)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
                return NotFound();

            if (string.IsNullOrWhiteSpace(newPassword))
            {
                TempData["Error"] = "Password tidak boleh kosong.";
                return RedirectToAction(nameof(ResetPassword), new { id });
            }

            if (newPassword.Length < 6)
            {
                TempData["Error"] = "Password minimal 6 karakter.";
                return RedirectToAction(nameof(ResetPassword), new { id });
            }

            if (newPassword != confirmPassword)
            {
                TempData["Error"] = "Konfirmasi password tidak sama.";
                return RedirectToAction(nameof(ResetPassword), new { id });
            }

            user.Password = BCrypt.Net.BCrypt.HashPassword(newPassword);

            _context.Users.Update(user);
            await _context.SaveChangesAsync();

            TempData["Message"] = $"Password user {user.Nama} berhasil direset.";
            return RedirectToAction(nameof(Index));
        }

        // =========================
        // DELETE USER
        // =========================
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
                return NotFound();

            try
            {
                _context.Users.Remove(user);
                await _context.SaveChangesAsync();

                TempData["Message"] = "User berhasil dihapus.";
            }
            catch
            {
                TempData["Error"] = "User tidak bisa dihapus karena masih dipakai di data Surat.";
            }

            return RedirectToAction(nameof(Index));
        }
    }
}