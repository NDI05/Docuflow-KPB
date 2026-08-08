using Docuflow.Services;
using Docuflow_projectIT_KPB.Data;
using Microsoft.AspNetCore.DataProtection;
using Docuflow_projectIT_KPB.Services;
using Microsoft.EntityFrameworkCore;
using Rotativa.AspNetCore;

// Nama bulan pada surat harus bahasa Indonesia ("06 Agustus 2026"), bukan
// "06 August 2026". Disetel sekali di sini, bukan ditambal per pemanggilan
// ToString() di tiap view.
// Aman untuk angka: model aplikasi ini tidak punya kolom desimal, hanya int,
// yang tidak terpengaruh pemisah desimal koma milik id-ID.
var budaya = new System.Globalization.CultureInfo("id-ID");
System.Globalization.CultureInfo.DefaultThreadCurrentCulture = budaya;
System.Globalization.CultureInfo.DefaultThreadCurrentUICulture = budaya;

var builder = WebApplication.CreateBuilder(args);

// =============================
// ADD SERVICES
// =============================
builder.Services.AddControllersWithViews();

// =============================
// DATA PROTECTION
//
// Tanpa ini kunci disimpan di memori (EphemeralXmlRepository), sehingga hilang
// setiap app pool IIS di-recycle — dan IIS me-recycle secara rutin (idle 20
// menit, plus daur harian). Akibatnya token antiforgery dan cookie sesi yang
// dibuat sebelum recycle ditolak sesudahnya: form yang sudah lama terbuka
// gagal disubmit, dan pengguna terlempar keluar tanpa sebab yang jelas.
//
// Disimpan di ProgramData, di luar folder publish, supaya tidak tertimpa
// setiap kali deploy.
// =============================
var folderKunci = Path.Combine(
    Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData),
    "Docuflow", "keys");

Directory.CreateDirectory(folderKunci);

builder.Services.AddDataProtection()
    .PersistKeysToFileSystem(new DirectoryInfo(folderKunci))
    .SetApplicationName("Docuflow");

// SESSION (untuk login & role)
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

// =============================
// REGISTER DATABASE
// =============================
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection")
    )
);

// =============================
// REGISTER SERVICES
// =============================
builder.Services.AddScoped<NomorSuratService>();

// TAMBAHKAN INI
builder.Services.AddScoped<AuditLogService>();

var app = builder.Build();

// =============================
// ROTATIVA CONFIG
// =============================
RotativaConfiguration.Setup(
    builder.Environment.WebRootPath,
    "Rotativa"
);

// =============================
// HTTP PIPELINE
// =============================
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
}

// HSTS dan redirect HTTPS dipisahkan dari environment, dikendalikan setelan
// "UseHttps" di appsettings.json.
//
// Alasannya: aplikasi ini dilayani IIS lewat HTTP polos di jaringan internal.
// Mengaktifkan HSTS di situs HTTP membuat browser pengguna memaksa HTTPS
// secara permanen — situsnya jadi tidak bisa dibuka, dan setelan itu menempel
// di browser masing-masing orang sehingga sulit dibatalkan dari sisi server.
// Sebaliknya, menjalankan mode Development hanya demi menghindari HSTS akan
// menampilkan stack trace ke pengguna. Jadi keduanya dipisah.
//
// Setel "UseHttps": true begitu binding HTTPS sudah terpasang di IIS.
if (app.Configuration.GetValue<bool>("UseHttps"))
{
    app.UseHsts();
    app.UseHttpsRedirection();
}
app.UseStaticFiles();

app.UseRouting();

// SESSION harus sebelum Authorization
app.UseSession();

app.UseAuthorization();

// =============================
// ROUTING
// =============================
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Account}/{action=Login}/{id?}"
);

app.Run();