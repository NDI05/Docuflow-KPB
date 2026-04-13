using Docuflow_projectIT_KPB.Data;
using Docuflow_projectIT_KPB.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using System.Linq;

namespace Docuflow_projectIT_KPB.Controllers
{
	public class UsersController : Controller
	{
		private readonly ApplicationDbContext _context;

		public UsersController(ApplicationDbContext context)
		{
			_context = context;
		}

		// =========================
		// LIST USERS
		// =========================
		public IActionResult Index()
		{
			// cek login
			var username = HttpContext.Session.GetString("Username");
			var role = HttpContext.Session.GetString("Role");

			if (string.IsNullOrEmpty(username))
			{
				return RedirectToAction("Login", "Account");
			}

			// hanya Admin boleh masuk
			if (role != "Admin")
			{
				return RedirectToAction("Index", "Home");
			}

			var users = _context.Users.ToList();

			return View(users);
		}

		// =========================
		// FORM CREATE
		// =========================
		public IActionResult Create()
		{
			var role = HttpContext.Session.GetString("Role");

			if (role != "Admin")
			{
				return RedirectToAction("Index", "Home");
			}

			return View();
		}

		// =========================
		// SAVE USER
		// =========================
		[HttpPost]
		[ValidateAntiForgeryToken]
		public IActionResult Create(User user)
		{
			var role = HttpContext.Session.GetString("Role");

			if (role != "Admin")
			{
				return RedirectToAction("Index", "Home");
			}

			if (ModelState.IsValid)
			{
				_context.Users.Add(user);
				_context.SaveChanges();

				return RedirectToAction(nameof(Index));
			}

			return View(user);
		}
	}
}