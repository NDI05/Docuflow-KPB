using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Docuflow_projectIT_KPB.Data;
using Docuflow_projectIT_KPB.Models;
using Docuflow_projectIT_KPB.Filters;
using BCrypt.Net;
using Docuflow_projectIT_KPB.Services;

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

            // "PenanggungJawab" dihapus 2026-09-03. Penanggung jawab pada
            // berita acara adalah penerima perangkat — pekerja kilang yang
            // umumnya bukan pengguna aplikasi — dan datanya diketik sebagai
            // teks di Surat/Create, bukan diambil dari tabel ini.
            // Jabatan ikut tercetak di dokumen resmi, jadi nilainya diperiksa
            // terhadap daftar putih di server. Isi <select> hanya petunjuk.
            if (!string.IsNullOrWhiteSpace(user.Jabatan) && !JabatanUser.Dikenal(user.Jabatan))
            {
                TempData["Error"] = "Jabatan tidak dikenali.";
                return View(user);
            }

            Rapikan(user);

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

        /// <summary>
        /// Merapikan isian sebelum disimpan.
        ///
        /// Model binding MVC mengubah isian kosong menjadi <c>null</c> untuk
        /// properti string (ConvertEmptyStringToNull, bawaan framework), padahal
        /// NomorPegawai non-nullable di model sehingga kolomnya NOT NULL di
        /// database. Membiarkan pengguna mengosongkan "Nomor pegawai" karena itu
        /// melempar SqlException "Cannot insert the value NULL" dan berakhir
        /// sebagai halaman error — bukan pesan validasi.
        ///
        /// Dikosongkan menjadi string kosong, bukan dijadikan wajib diisi: sepuluh
        /// akun yang sudah ada memang tidak punya nomor pegawai, dan memaksakan
        /// syarat baru akan membuat data lama tidak bisa disunting.
        /// </summary>
        private static void Rapikan(User user)
        {
            user.Nama = user.Nama?.Trim() ?? string.Empty;
            user.Username = user.Username?.Trim() ?? string.Empty;
            user.NomorPegawai = user.NomorPegawai?.Trim() ?? string.Empty;

            // Npk dan Jabatan memang nullable — kosong disimpan sebagai NULL,
            // bukan string kosong, supaya "tidak diisi" dan "diisi kosong" tidak
            // jadi dua keadaan berbeda di database.
            user.Npk = string.IsNullOrWhiteSpace(user.Npk) ? null : user.Npk.Trim();
            user.Jabatan = string.IsNullOrWhiteSpace(user.Jabatan) ? null : user.Jabatan.Trim();
        }

        /// <summary>
        /// Benar kalau menurunkan atau menghapus user ini akan menyisakan NOL
        /// Super Admin.
        ///
        /// Aplikasi tidak punya halaman pendaftaran mandiri. Kehilangan Super
        /// Admin terakhir berarti menu kelola pengguna tidak bisa dimasuki siapa
        /// pun lagi, dan pemulihannya hanya lewat INSERT/UPDATE SQL langsung ke
        /// database. Dipakai Edit maupun Delete — dua jalan menuju lubang yang
        /// sama, jadi penjaganya satu.
        /// </summary>
        private async Task<bool> SuperAdminTerakhir(User user) =>
            user.Role == "SuperAdmin" &&
            await _context.Users.CountAsync(u => u.Role == "SuperAdmin") <= 1;

        // =========================
        // EDIT USER FORM
        // =========================
        public async Task<IActionResult> Edit(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
                return NotFound();

            return View(user);
        }

        // =========================
        // EDIT USER POST
        //
        // Kata sandi TIDAK disentuh di sini — ada halaman Atur ulang sandi
        // tersendiri. Menggabungkannya berarti setiap penyuntingan nama ikut
        // meminta sandi, dan sandi kosong jadi ambigu: dibiarkan atau dikosongkan?
        // =========================
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, User form)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
                return NotFound();

            form.Id = id;

            if (string.IsNullOrWhiteSpace(form.Nama) ||
                string.IsNullOrWhiteSpace(form.Username) ||
                string.IsNullOrWhiteSpace(form.Role))
            {
                TempData["Error"] = "Nama, username, dan peran wajib diisi.";
                return View(form);
            }

            // Sama seperti Create: nilainya datang dari form dan menentukan hak
            // akses, jadi diperiksa di server. Isi <select> hanya petunjuk.
            if (form.Role != "SuperAdmin" && form.Role != "Admin")
            {
                TempData["Error"] = "Peran tidak dikenali.";
                return View(form);
            }

            // Jabatan ikut tercetak di dokumen resmi, jadi nilainya diperiksa
            // terhadap daftar putih di server. Isi <select> hanya petunjuk.
            if (!string.IsNullOrWhiteSpace(form.Jabatan) && !JabatanUser.Dikenal(form.Jabatan))
            {
                TempData["Error"] = "Jabatan tidak dikenali.";
                return View(form);
            }

            // Username tetap harus unik, tapi baris ini sendiri dikecualikan —
            // tanpa itu menyimpan tanpa mengubah username akan ditolak.
            bool bentrok = await _context.Users
                .AnyAsync(x => x.Id != id && x.Username == form.Username);

            if (bentrok)
            {
                TempData["Error"] = "Username sudah digunakan.";
                return View(form);
            }

            // Diperiksa SEBELUM nilai lama ditimpa, selagi Role di memori masih
            // sama dengan yang tersimpan.
            if (form.Role != "SuperAdmin" && await SuperAdminTerakhir(user))
            {
                TempData["Error"] = "Ini Super Admin terakhir. Angkat Super Admin lain dulu sebelum menurunkan perannya, kalau tidak menu pengguna tidak bisa dimasuki siapa pun.";
                return View(form);
            }

            Rapikan(form);

            user.Nama = form.Nama;
            user.Username = form.Username;
            user.NomorPegawai = form.NomorPegawai;
            user.Npk = form.Npk;
            user.Role = form.Role;
            user.Jabatan = form.Jabatan;

            await _context.SaveChangesAsync();

            TempData["Message"] = $"Data {user.Nama} berhasil diperbarui.";
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

            if (await SuperAdminTerakhir(user))
            {
                TempData["Error"] = "Ini Super Admin terakhir dan tidak bisa dihapus. Angkat Super Admin lain dulu.";
                return RedirectToAction(nameof(Index));
            }

            try
            {
                _context.Users.Remove(user);
                await _context.SaveChangesAsync();

                TempData["Message"] = "User berhasil dihapus.";
            }
            catch
            {
                TempData["Error"] = "User tidak bisa dihapus karena masih dipakai di data dokumen.";
            }

            return RedirectToAction(nameof(Index));
        }
    }
}