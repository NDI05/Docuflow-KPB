using Microsoft.EntityFrameworkCore;
using Docuflow_projectIT_KPB.Data;
using Docuflow_projectIT_KPB.Services;
using Rotativa.AspNetCore;
using Rotativa.AspNetCore.Options;

var builder = WebApplication.CreateBuilder(args);

// =============================
// ADD SERVICES
// =============================
builder.Services.AddControllersWithViews();

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

var app = builder.Build();

// =============================
// ROTATIVA CONFIGURATION
// wkhtmltopdf harus ada di:
// wwwroot/Rotativa/wkhtmltopdf.exe
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

// WAJIB supaya Rotativa bisa akses wkhtmltopdf
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

// =============================
// ROUTING
// =============================
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}"
);

app.Run();