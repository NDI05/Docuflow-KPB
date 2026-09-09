# Spesifikasi lingkungan — Docuflow v1.0.0

Lembar ini untuk dikirim ke tim IT Pertamina **sebelum** pemasangan, supaya
ketidakcocokan lingkungan ketahuan sebelum publish, bukan sesudahnya.

TrackingSystem (KPB IT Care) dipakai sebagai pembanding: sistem itu sudah
berjalan di lingkungan Pertamina, jadi kebutuhannya adalah yang sudah terbukti
diterima di sana.

## Yang dibutuhkan

| | **Docuflow 1.0.0** | TrackingSystem 1.7.1 (pembanding) |
|---|---|---|
| Target framework | **net8.0** | net8.0 |
| Runtime di server | **ASP.NET Core 8 Hosting Bundle** | ASP.NET Core 8 Hosting Bundle |
| EF Core | 8.0.11 | 8.0.11 |
| Modul IIS | AspNetCoreModuleV2 | AspNetCoreModuleV2 |
| Hosting model | `inprocess` | `inprocess` |
| App pool | No Managed Code, 64-bit, Load User Profile = True | sama |
| Arsitektur | 64-bit wajib (`wkhtmltopdf.exe`) | 64-bit |
| Sambungan basis data | **Windows Authentication** (`Trusted_Connection=True`) | SQL login |
| SQL Server minimum | 2019 (15.x) untuk jalur skrip | — |

Lingkungan tempat paket ini dibangun dan diuji:

| | |
|---|---|
| Windows | Windows 11 Pro build 26200 |
| IIS | 10.0 |
| ASP.NET Core Module V2 | 20.0.26177.10 |
| .NET runtime terpasang | ASP.NET Core 8.0.29 dan 10.0.10 |
| SDK | 10.0.302 |
| SQL Server | 17.0.1000.7 RTM, Express Edition, `compatibility_level 170` |
| Collation server | `SQL_Latin1_General_CP1_CI_AS` |

## Tiga hal yang perlu dipastikan lebih dulu

### 1. Runtime .NET — sudah disamakan dengan TrackingSystem

Docuflow semula dibangun untuk **net10.0**. Setelah dipastikan server produksi
hanya punya **ASP.NET Core 8 Hosting Bundle**, targetnya diturunkan ke
**net8.0** dengan EF Core **8.0.11** — kombinasi yang sama persis dengan
TrackingSystem, jadi sudah terbukti diterima di lingkungan itu.

Kalau ini tidak dilakukan, IIS akan membalas **HTTP 500.31 — Failed to load
ASP.NET Core runtime**, tanpa pesan lain yang menjelaskan sebabnya.

Cara memastikan di server produksi:

```
dotnet --list-runtimes
```

Harus ada baris `Microsoft.AspNetCore.App 8.x`.

### 2. Versi SQL Server — menentukan jalur pemasangan basis data

`basis-data/DocuflowDB.bak` dibuat di **SQL Server 17.0 (2025)**. SQL Server
tidak bisa memulihkan cadangan dari versi yang lebih baru daripada dirinya,
jadi kalau produksi memakai versi lebih lama, jalur cadangan gagal.

Karena itu paket ini menyertakan jalur skrip (`sql/01` sampai `sql/04`) yang
tidak terikat versi dan **sudah diuji dari basis data kosong**. Jalur itu yang
disarankan, apa pun versi produksinya.

Cara memastikan:

```sql
SELECT SERVERPROPERTY('ProductVersion'), SERVERPROPERTY('Edition');
```

### 3. Windows Authentication ke SQL Server

Berbeda dengan TrackingSystem yang memakai SQL login, Docuflow menyambung
sebagai **identitas application pool** (`Trusted_Connection=True`) dan tidak
menyimpan password sama sekali. Konsekuensinya identitas itu perlu login
sendiri di SQL Server:

```sql
CREATE LOGIN [IIS APPPOOL\Docflow] FROM WINDOWS;
USE DocuflowDB;
CREATE USER [IIS APPPOOL\Docflow] FOR LOGIN [IIS APPPOOL\Docflow];
ALTER ROLE db_datareader ADD MEMBER [IIS APPPOOL\Docflow];
ALTER ROLE db_datawriter ADD MEMBER [IIS APPPOOL\Docflow];
```

Kalau kebijakan di sana mengharuskan SQL login, sambungannya bisa diganti —
tapi itu berarti password tersimpan di `appsettings.json`, dan sebaiknya lewat
User Secrets atau variabel lingkungan, bukan berkas biasa.

## Pertanyaan untuk tim IT Pertamina

1. Versi dan edisi **SQL Server** produksi?
2. Apakah **Windows Authentication** dari application pool ke SQL Server
   diizinkan, atau harus SQL login?
3. Boleh membuat folder `C:\ProgramData\Docuflow\keys` yang bisa ditulisi
   application pool? Tanpa itu sesi dan token antiforgery hangus setiap daur
   ulang app pool, dan gejalanya halaman putih tanpa pesan galat.
4. Situsnya HTTP atau HTTPS? Selama masih HTTP, `UseHttps` wajib tetap `false` —
   menyalakannya di HTTP polos memaksa browser pengguna ke HTTPS secara
   permanen dan tidak bisa dibatalkan dari sisi server.
