using Docuflow.Services;
using Docuflow_projectIT_KPB.Data;
using Docuflow_projectIT_KPB.Services;
using Microsoft.EntityFrameworkCore;
using Rotativa.AspNetCore;

var builder = WebApplication.CreateBuilder(args);

// =============================
// ADD SERVICES
// =============================
builder.Services.AddControllersWithViews();

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
    app.UseHsts();
}

app.UseHttpsRedirection();
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