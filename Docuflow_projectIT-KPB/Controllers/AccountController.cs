using Microsoft.AspNetCore.Mvc;
using Docuflow_projectIT_KPB.Data;
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
        public IActionResult Login(string username, string password)
        {
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                ViewBag.Error = "Username dan Password wajib diisi";
                return View();
            }

            var user = _context.Users
                .FirstOrDefault(x => x.Username == username && x.Password == password);

            if (user != null)
            {
                // SIMPAN SESSION
                HttpContext.Session.SetString("Username", user.Username ?? "");
                HttpContext.Session.SetString("Nama", user.Nama ?? "");
                HttpContext.Session.SetString("Role", user.Role ?? "");
                HttpContext.Session.SetString("NomorPegawai", user.NomorPegawai ?? "");

                // redirect ke dashboard
                return RedirectToAction("Index", "Home");
            }

            ViewBag.Error = "Username atau Password salah";
            return View();
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