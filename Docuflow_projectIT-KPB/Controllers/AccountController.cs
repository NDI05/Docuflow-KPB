using Microsoft.AspNetCore.Mvc;
using Docuflow_projectIT_KPB.Data;
using Docuflow_projectIT_KPB.Models;
using Microsoft.AspNetCore.Http;
using System.Linq;

namespace Docuflow_projectIT_KPB.Controllers
{
    public class AccountController : Controller
    {
        private readonly ApplicationDbContext _context;

        public AccountController(ApplicationDbContext context)
        {
            _context = context;
        }

        // =========================
        // LOGIN PAGE
        // =========================
        public IActionResult Login()
        {
            // kalau sudah login, langsung ke dashboard
            if (HttpContext.Session.GetString("Username") != null)
            {
                return RedirectToAction("Index", "Home");
            }

            return View();
        }

        // =========================
        // LOGIN PROCESS
        // =========================
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Login(LoginViewModel model)
        {
            if (model == null || string.IsNullOrWhiteSpace(model.Username) || string.IsNullOrWhiteSpace(model.Password))
            {
                ViewBag.Error = "Username dan Password wajib diisi";
                return View();
            }

            var user = _context.Users.FirstOrDefault(x => x.Username == model.Username);

            if (user == null)
            {
                ViewBag.Error = "Username atau Password salah";
                return View();
            }

            bool validPassword = false;

            // =========================
            // CEK PASSWORD (HASH / PLAIN)
            // =========================
            if (!string.IsNullOrEmpty(user.Password) && user.Password.StartsWith("$2"))
            {
                // PASSWORD SUDAH HASH BCRYPT
                validPassword = BCrypt.Net.BCrypt.Verify(model.Password, user.Password);
            }
            else
            {
                // PASSWORD MASIH PLAIN TEXT
                validPassword = (user.Password == model.Password);

                // kalau cocok, langsung ubah jadi hash supaya aman
                if (validPassword)
                {
                    user.Password = BCrypt.Net.BCrypt.HashPassword(model.Password);
                    _context.Users.Update(user);
                    _context.SaveChanges();
                }
            }

            if (!validPassword)
            {
                ViewBag.Error = "Username atau Password salah";
                return View();
            }

            // =========================
            // SIMPAN SESSION
            // =========================
            HttpContext.Session.SetString("Username", user.Username ?? "");
            HttpContext.Session.SetString("Nama", user.Nama ?? "");
            HttpContext.Session.SetString("Role", user.Role ?? "");
            HttpContext.Session.SetString("NomorPegawai", user.NomorPegawai ?? "");

            return RedirectToAction("Index", "Home");
        }

        // =========================
        // LOGOUT
        // =========================
        public IActionResult Logout()
        {
            HttpContext.Session.Clear();
            return RedirectToAction("Login", "Account");
        }
    }
}