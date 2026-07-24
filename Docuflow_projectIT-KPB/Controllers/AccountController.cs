using Docuflow.Services;
using Docuflow_projectIT_KPB.Data;
using Docuflow_projectIT_KPB.Models;
using Docuflow_projectIT_KPB.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Linq;

namespace Docuflow_projectIT_KPB.Controllers
{
    public class AccountController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly AuditLogService _auditLog;

        public AccountController(
            ApplicationDbContext context,
            AuditLogService auditLog)
        {
            _context = context;
            _auditLog = auditLog;
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
            if (model == null ||
                string.IsNullOrWhiteSpace(model.Username) ||
                string.IsNullOrWhiteSpace(model.Password))
            {
                ViewBag.Error = "Username dan Password wajib diisi";
                return View();
            }

            var user = _context.Users
                .FirstOrDefault(x => x.Username == model.Username);

            if (user == null)
            {
                ViewBag.Error = "Username atau Password salah";
                return View();
            }

            bool validPassword = false;

            // =========================
            // CEK PASSWORD (HASH / PLAIN)
            // =========================
            if (!string.IsNullOrEmpty(user.Password) &&
                user.Password.StartsWith("$2"))
            {
                validPassword = BCrypt.Net.BCrypt.Verify(
                    model.Password,
                    user.Password
                );
            }
            else
            {
                validPassword = (user.Password == model.Password);

                if (validPassword)
                {
                    user.Password = BCrypt.Net.BCrypt.HashPassword(
                        model.Password
                    );

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
            HttpContext.Session.SetString(
                "Username",
                user.Username ?? ""
            );

            HttpContext.Session.SetString(
                "Nama",
                user.Nama ?? ""
            );

            HttpContext.Session.SetString(
                "Role",
                user.Role ?? ""
            );

            HttpContext.Session.SetString(
                "NomorPegawai",
                user.NomorPegawai ?? ""
            );

            // =========================
            // AUDIT LOG LOGIN
            // =========================
            _auditLog.Log(
                user.Username ?? "-",
                "Login",
                "User berhasil login ke sistem"
            );

            return RedirectToAction("Index", "Home");
        }

        // =========================
        // LOGOUT
        // =========================
        public IActionResult Logout()
        {
            var username =
                HttpContext.Session.GetString("Username") ?? "-";

            // =========================
            // AUDIT LOG LOGOUT
            // =========================
            _auditLog.Log(
                username,
                "Logout",
                "User logout dari sistem"
            );

            HttpContext.Session.Clear();

            return RedirectToAction(
                "Login",
                "Account"
            );
        }
    }
}