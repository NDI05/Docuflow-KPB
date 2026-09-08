using Docuflow.Services;
using Docuflow_projectIT_KPB.Data;
using Docuflow_projectIT_KPB.Filters;
using Docuflow_projectIT_KPB.Models;
using Docuflow_projectIT_KPB.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace Docuflow_projectIT_KPB.Controllers
{
    /// <summary>
    /// Pendataan dan rekap Sub Pekerjaan Dinas.
    ///
    /// Terpisah dari berita acara: tabelnya sendiri, menunya sendiri, dan
    /// SENGAJA tidak punya baris JenisSurat. Menambahkan baris JenisSurat
    /// berkode "SPD" akan membuat SPD bisa dipilih di formulir berita acara
    /// dan ikut tercetak memakai tata letak BAST lewat cabang bawaan
    /// SuratController.NamaTemplate — dokumen yang tampak resmi tapi bukan
    /// yang berlaku. Itu kegagalan yang sama seperti yang membuat BALP butuh
    /// penjaga route.
    ///
    /// Yang dibagi dengan berita acara hanya CounterNomorSurat, lewat
    /// NomorSuratService.GenerateNomorSurat(string kode).
    /// </summary>
    [SessionAuthorize("Admin", "SuperAdmin")]
    public class SpdController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly NomorSuratService _nomorService;
        private readonly AuditLogService _auditLog;

        /// <summary>
        /// Ditulis tetap di sini, bukan diambil dari form atau dari tabel.
        /// Kode menentukan deret nomor mana yang dinaikkan; nilai nyasar akan
        /// diam-diam membuka deret baru yang tidak ada yang mengawasi.
        /// </summary>
        private const string KodeSpd = "SPD";

        public SpdController(
            ApplicationDbContext context,
            NomorSuratService nomorService,
            AuditLogService auditLog)
        {
            _context = context;
            _nomorService = nomorService;
            _auditLog = auditLog;
        }

        /// <summary>
        /// Kolom yang boleh dipakai mengurutkan rekap. Daftar putih: nilainya
        /// datang dari query string, dan kolom tak dikenal harus jatuh ke
        /// bawaan alih-alih melempar.
        /// </summary>
        private static readonly string[] KolomUrut = { "nomor", "staff", "kota", "tanggal" };

        public async Task<IActionResult> Index(string search, int? tahun, string sort, string dir, int page = 1)
        {
            int pageSize = 15;

            var query = _context.Spd
                .Include(s => s.Staff)
                .AsQueryable();

            if (!string.IsNullOrWhiteSpace(search))
            {
                search = search.Trim();

                query = query.Where(s =>
                    s.NomorSpd.Contains(search) ||
                    s.NamaKota.Contains(search) ||
                    s.Keperluan.Contains(search) ||
                    s.Staff.Nama.Contains(search)
                );
            }

            // Disaring pada TanggalDinas, tanggal yang tertera pada dokumennya,
            // bukan CreatedAt. Sama seperti arsip berita acara.
            if (tahun.HasValue && tahun.Value > 0)
            {
                query = query.Where(s => s.TanggalDinas.Year == tahun.Value);
            }

            sort = (sort ?? string.Empty).Trim().ToLowerInvariant();
            if (Array.IndexOf(KolomUrut, sort) < 0) sort = "tanggal";

            bool naik = string.Equals(dir, "asc", StringComparison.OrdinalIgnoreCase);

            // ThenBy Id dipasang pada setiap kolom yang bisa punya nilai kembar:
            // tanpa urutan kedua yang pasti, SQL Server bebas mengurutkan baris
            // kembar sesukanya dan satu baris bisa muncul dua kali atau hilang
            // saat dipaginasi.
            query = sort switch
            {
                "nomor" => naik
                    ? query.OrderBy(s => s.NomorSpd).ThenBy(s => s.Id)
                    : query.OrderByDescending(s => s.NomorSpd).ThenByDescending(s => s.Id),

                "staff" => naik
                    ? query.OrderBy(s => s.Staff.Nama).ThenByDescending(s => s.Id)
                    : query.OrderByDescending(s => s.Staff.Nama).ThenByDescending(s => s.Id),

                "kota" => naik
                    ? query.OrderBy(s => s.NamaKota).ThenByDescending(s => s.Id)
                    : query.OrderByDescending(s => s.NamaKota).ThenByDescending(s => s.Id),

                _ => naik
                    ? query.OrderBy(s => s.TanggalDinas).ThenBy(s => s.Id)
                    : query.OrderByDescending(s => s.TanggalDinas).ThenByDescending(s => s.Id),
            };

            int totalData = await query.CountAsync();
            int totalPages = (int)Math.Ceiling((double)totalData / pageSize);

            if (totalPages == 0) totalPages = 1;
            if (page < 1) page = 1;
            if (page > totalPages) page = totalPages;

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.Search = search;
            ViewBag.Tahun = tahun;
            ViewBag.Sort = sort;
            ViewBag.Dir = naik ? "asc" : "desc";

            // Tahun diambil dari SELURUH tabel, bukan dari hasil yang tersaring:
            // kalau diambil dari hasil, tahun yang sedang dipilih akan hilang
            // dari pilihannya sendiri begitu hasilnya kosong.
            ViewBag.DaftarTahun = await _context.Spd
                .Select(s => s.TanggalDinas.Year)
                .Distinct()
                .OrderByDescending(t => t)
                .ToListAsync();

            return View(await query.Skip((page - 1) * pageSize).Take(pageSize).ToListAsync());
        }

        public async Task<IActionResult> Create()
        {
            await IsiPilihan();
            return View(new Spd { TanggalDinas = DateTime.Today });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Spd spd)
        {
            spd.CreatedAt = DateTime.Now;

            // NomorSpd bertanda [Required] tapi diterbitkan server SETELAH
            // validasi, jadi model binding selalu menandainya kosong dan
            // ModelState.IsValid selalu false. Tanpa baris ini formulir
            // dikembalikan tanpa pesan apa pun — tidak ada span validasi untuk
            // kolom yang memang tidak ada di formulir, jadi kegagalannya diam.
            ModelState.Remove(nameof(Spd.NomorSpd));

            if (spd.StaffId == null)
                ModelState.AddModelError(nameof(spd.StaffId), "Pilih staff yang menjalankan dinas.");

            if (string.IsNullOrWhiteSpace(spd.Keperluan))
                ModelState.AddModelError(nameof(spd.Keperluan), "Keperluan dinas wajib diisi.");

            if (spd.TanggalDinas == default)
                ModelState.AddModelError(nameof(spd.TanggalDinas), "Tanggal dinas wajib diisi.");

            // Pilihan kota memakai <datalist>, yang MENGIRIM TEKS yang diketik —
            // bukan id. Peramban dengan senang hati mengirim "Balikpapn". Jadi
            // teksnya dicocokkan ke tabel Kota di server; ini pemeriksaan batas
            // kepercayaan, bukan kenyamanan.
            var namaKota = (spd.NamaKota ?? string.Empty).Trim();
            var kota = string.IsNullOrEmpty(namaKota)
                ? null
                : await _context.Kota.AsNoTracking().FirstOrDefaultAsync(k => k.Nama == namaKota);

            if (kota == null)
                ModelState.AddModelError(nameof(spd.NamaKota), "Kota tidak dikenali. Pilih dari daftar yang tersedia.");

            if (!ModelState.IsValid)
            {
                await IsiPilihan();
                return View(spd);
            }

            spd.NamaKota = kota!.Nama;
            spd.Provinsi = kota.Provinsi;
            spd.Keperluan = spd.Keperluan.Trim();

            // Satu transaksi untuk generate nomor + insert baris. Sama persis
            // dengan SuratController.Create, dan wajib karena alasan yang sama:
            // kunci baris counter di NomorSuratService baru bertahan sampai
            // commit kalau ada transaksi, dan kalau insert gagal counter ikut
            // di-rollback sehingga nomor tidak hangus.
            //
            // Urutannya juga tidak boleh dibalik: NomorSuratService memanggil
            // SaveChangesAsync pada DbContext yang SAMA, jadi Add() sebelum
            // generate akan menulis baris SPD saat nomornya masih kosong.
            await using (var tx = await _context.Database.BeginTransactionAsync())
            {
                spd.NomorSpd = await _nomorService.GenerateNomorSurat(KodeSpd);

                _context.Spd.Add(spd);
                await _context.SaveChangesAsync();

                await tx.CommitAsync();
            }

            // Di luar transaksi, seperti pada SuratController: gagalnya
            // pencatatan audit tidak boleh ikut membatalkan baris yang sudah
            // tersimpan. AuditLogService.Log memanggil SaveChanges pada context
            // yang sama, jadi ia hanya aman di posisi ini — setelah commit,
            // tanpa entitas tertunda.
            _auditLog.Log(
                HttpContext.Session.GetString("Username") ?? "-",
                "Generate Nomor SPD",
                $"Membuat SPD nomor {spd.NomorSpd} untuk dinas ke {spd.NamaKota}");

            TempData["Message"] = $"SPD {spd.NomorSpd} berhasil dibuat.";
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            var spd = await _context.Spd.FindAsync(id);

            if (spd == null)
                return NotFound();

            var nomor = spd.NomorSpd;

            _context.Spd.Remove(spd);
            await _context.SaveChangesAsync();

            // Dicatat karena counter TIDAK ikut turun saat baris dihapus:
            // nomornya hangus, dan jejak inilah satu-satunya keterangan kenapa
            // ada lompatan pada deret SPD.
            _auditLog.Log(
                HttpContext.Session.GetString("Username") ?? "-",
                "Hapus SPD",
                $"Menghapus SPD nomor {nomor}. Nomor tidak dipakai ulang.");

            TempData["Message"] = "SPD berhasil dihapus.";
            return RedirectToAction(nameof(Index));
        }

        /// <summary>
        /// Isi kedua pilihan pada formulir. Kota dibaca AsNoTracking karena
        /// 514 baris hanya dirender sebagai daftar dan tidak pernah disunting.
        /// </summary>
        private async Task IsiPilihan()
        {
            ViewBag.Staff = await _context.Users
                .AsNoTracking()
                .OrderBy(u => u.Nama)
                .ToListAsync();

            ViewBag.Kota = await _context.Kota
                .AsNoTracking()
                .OrderBy(k => k.Nama)
                .ToListAsync();
        }
    }
}
