# =====================================================================
# Menjalankan Docuflow di http://0.0.0.0:5090
# Jalankan: powershell -ExecutionPolicy Bypass -File C:\dev\docuflow\start-app.ps1
#
# Proses dibuat lewat Win32_Process.Create, BUKAN Start-Process, supaya
# tidak ikut mati saat sesi SSH ditutup (Start-Process menaruh child di
# job object milik sesi SSH -> ikut terbunuh saat logout).
# =====================================================================
$ErrorActionPreference = "Stop"

$proj = "C:\dev\docuflow\Docuflow_projectIT-KPB"
$exe  = Join-Path $proj "bin\Debug\net8.0\Docuflow_projectIT-KPB.exe"
$out  = "C:\dev\docuflow\app_out.log"
$err  = "C:\dev\docuflow\app_err.log"

if (-not (Test-Path $exe)) {
    throw "Belum di-build. Jalankan dulu: cd C:\dev\docuflow; dotnet build"
}

# Hentikan instance lama (tidak menyentuh TrackingSystem di port 5080)
Get-Process Docuflow_projectIT-KPB -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 1

# ASPNETCORE_ENVIRONMENT=Development supaya HSTS & HTTPS-redirect tidak aktif
# (aplikasi hanya listen HTTP).
# CurrentDirectory WAJIB folder project: SuratController memakai
# Directory.GetCurrentDirectory() untuk wwwroot\uploads.
$cmd = 'cmd.exe /c set ASPNETCORE_ENVIRONMENT=Development&& "' + $exe +
       '" --urls http://0.0.0.0:5090 1>"' + $out + '" 2>"' + $err + '"'

$r = Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{
    CommandLine      = $cmd
    CurrentDirectory = $proj
}

if ($r.ReturnValue -ne 0) {
    throw "Win32_Process.Create gagal, ReturnValue = $($r.ReturnValue)"
}

Start-Sleep -Seconds 6

$app = Get-Process Docuflow_projectIT-KPB -ErrorAction SilentlyContinue

if (-not $app) {
    "GAGAL start. Isi app_err.log:"
    Get-Content $err -Tail 20 -ErrorAction SilentlyContinue
    "Isi app_out.log:"
    Get-Content $out -Tail 20 -ErrorAction SilentlyContinue
} else {
    # IP dibaca dari adapter, bukan ditulis tetap — alamat DHCP VM berubah-ubah
    $ip = (Get-NetIPAddress -AddressFamily IPv4 |
           Where-Object { $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*" } |
           Select-Object -First 1).IPAddress

    "PID : $($app.Id)"
    "LAN : http://${ip}:5090"
    "Log : $out"
}
