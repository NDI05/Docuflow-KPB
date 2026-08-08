# Diagram Docuflow

Semua diagram di bawah menggambarkan **kondisi kode saat ini**, bukan rancangan
ideal. Diverifikasi 2026-07-27.

## 1. Konteks & deployment

```mermaid
flowchart LR
    subgraph Mac["Mac (sumber edit)"]
        A[Claude Code + graphify-out]
        B[deploy.sh]
    end
    subgraph VM["VM Windows 11 ARM"]
        C["C:\dev\docuflow<br/>ASP.NET Core net10.0"]
        D[("SQL Server Express<br/>DocuflowDB")]
        E[wkhtmltopdf.exe<br/>Rotativa]
        F["C:\dev\tracking-system<br/>port 5080 — sistem lain"]
    end
    G[Browser pegawai]

    A --> B
    B -->|tar + scp + dotnet build| C
    C -->|Trusted_Connection| D
    C --> E
    G -->|http :5090| C
```

Windows wajib karena dua hal: `wkhtmltopdf.exe` (binary Windows-only) dan
`Trusted_Connection=True` (Windows Authentication ke SQL Server).

## 2. Alur login

```mermaid
sequenceDiagram
    actor U as User
    participant A as AccountController
    participant DB as DocuflowDB
    participant S as Session

    U->>A: POST /Account/Login
    A->>DB: cari Users by Username
    alt password diawali "$2"
        A->>A: BCrypt.Verify
    else plaintext
        A->>A: bandingkan langsung
        A->>DB: simpan ulang sebagai hash BCrypt
    end
    A->>S: set Username, Nama, Role, NomorPegawai
    A->>DB: AuditLog "Login"
    A-->>U: 302 /Home/Index
```

Proteksi route lewat `Filters/SessionAuthorizeAttribute.cs`. Cek admin dilakukan
dengan membandingkan string `Session["Role"] == "Admin"` di dalam action, bukan
lewat atribut.

## 3. Alur pembuatan surat

```mermaid
sequenceDiagram
    actor S as Staff
    participant C as SuratController
    participant N as NomorSuratService
    participant DB as DocuflowDB

    S->>C: POST /Surat/Create (+ NamaBarang[] dst)
    C->>C: rakit BarangList dari form array
    opt ada file
        C->>C: simpan ke wwwroot/uploads
    end
    C->>N: GenerateNomorSurat(jenisSuratId)
    N->>DB: ambil/naikkan CounterNomorSurat
    N-->>C: "BAPB 007/KPB2340/2026/S0"
    C->>DB: cari user pertama Role = PenanggungJawab
    C->>DB: INSERT Surat + BarangSurat
    C->>DB: AuditLog "Generate Nomor Surat"
    C-->>S: 302 /Surat/Details/{id}
```

**Format nomor:** `{KODE} {NNN}/KPB2340/{tahun}/S0`, dengan `KODE` = teks sebelum
`-` pada `JenisSurat.NamaJenis`, dan `NNN` = `NomorTerakhir` 3 digit.

Titik rapuh yang sudah terlihat:
- Nomor diambil **sebelum** `SaveChanges` surat. Kalau insert gagal, counter
  sudah terlanjur naik dan satu nomor hilang.
- Tidak ada penguncian; dua staff yang submit bersamaan bisa dapat nomor sama.
- Penanggung jawab diambil dengan `FirstOrDefaultAsync` tanpa urutan — user
  `PenanggungJawab` mana yang terpilih tidak deterministik.

## 4. Alur cetak PDF

```mermaid
flowchart LR
    A["/Surat/GeneratePdf/{id}"] --> B[ambil Surat + relasi]
    B --> C["ViewAsPdf(SuratTemplate)"]
    C --> D[Rotativa]
    D --> E["wwwroot/Rotativa/wkhtmltopdf.exe"]
    E --> F[PDF A4 portrait]
```

`/Surat/Preview/{id}` merender template yang sama sebagai HTML — berguna untuk
mengecek tata letak tanpa memanggil wkhtmltopdf.

`/Surat/Download/{id}` mengembalikan lampiran asli kalau `FilePath` terisi;
kalau kosong, redirect ke `GeneratePdf`. Path lampiran diselesaikan lewat
`Directory.GetCurrentDirectory()`, jadi **working directory aplikasi harus folder
project**.

## 5. Peran dan hak akses

```mermaid
flowchart TD
    Admin -->|Users/Index, Create, ResetPassword, Delete| U[Manajemen User]
    Admin --> Surat
    Manager --> Surat
    Staff --> Surat
    PJ[PenanggungJawab] --> Surat
    Surat[Surat: Index, Create, Details, Preview, PDF, Download, Delete]
```

Semua peran yang sudah login punya akses **sama persis** ke seluruh menu Surat —
termasuk `Delete`. Tidak ada pembatasan per peran di `SuratController`.
