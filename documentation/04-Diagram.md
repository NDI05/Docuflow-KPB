# Diagram Docuflow

Diperbarui **2026-09-09**.

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
        C["C:\inetpub\docflow<br/>ASP.NET Core net8.0"]
        I["IIS — app pool Docflow<br/>/docflow"]
        D[("SQL Server Express<br/>DocuflowDB")]
        E[wkhtmltopdf.exe<br/>Rotativa]
        F["C:\dev\tracking-system<br/>port 8080 — sistem lain, JANGAN disentuh"]
    end
    G[Browser pegawai]

    A --> B
    B -->|tar + scp + dotnet build| C
    C -->|Trusted_Connection| D
    C --> E
    G -->|http :80 /docflow| I
    I --> C
```

Windows wajib karena dua hal: `wkhtmltopdf.exe` (binary Windows-only) dan
`Trusted_Connection=True` (Windows Authentication ke SQL Server).

**Kestrel di port 5090 sudah pensiun** (2026-08-06). IIS satu-satunya jalur.
Dulu keduanya berbagi satu basis data tapi punya `wwwroot/uploads` masing-masing,
sehingga lampiran yang diunggah lewat satu jalur jadi gambar rusak di jalur
lainnya.

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

Proteksi route lewat `Filters/SessionAuthorizeAttribute.cs`, yang menerima
`params string[]` — memperluas sebuah controller cukup menambah satu argumen.
Pemeriksaan peran ada di atribut controller, **bukan** di `if` per action.

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
    N-->>C: "BAPB 097/KPB3240/2026-S0"
    C->>DB: cari user pertama Role = PenanggungJawab
    C->>DB: INSERT Surat + BarangSurat
    C->>DB: AuditLog "Generate Nomor Surat"
    C-->>S: 302 /Surat/Details/{id}
```

**Format nomor:** `{KODE} {NNN}/KPB3240/{tahun}-S0` — mis.
`BAST 146/KPB3240/2026-S0`. `KODE` diambil dari **kolom** `JenisSurat.Kode`
(sejak 2026-08-06 tidak lagi diurai dari `NamaJenis`), dan `NNN` adalah
`NomorTerakhir + 1` dalam 3 digit.

Tanpa `No.` di antara kode dan angkanya: sistem lama menulis
`BAPB 027/KPB3240/2024-S0`, dan Docuflow melanjutkan deret yang sama.

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
    SA[SuperAdmin] --> U["Users: Index, Create, Edit, ResetPassword, Delete"]
    SA --> Surat
    SA --> Spd
    SA --> Audit[Jejak audit]
    Admin --> Surat
    Admin --> Spd
    Surat["Surat: Index, Create, Edit, Details, Preview, PDF, Download, UnggahBalp, Delete"]
    Spd["SPD: Index, Create, Delete"]
```

Dua peran, **bertingkat bukan terpisah** (diubah 2026-09-03). Super Admin adalah
superset; satu-satunya pintu yang tetap searah adalah `Users/*`.

`Jabatan` berbeda dari `Role`: `Role` menjawab "boleh membuka apa", `Jabatan`
menjawab "siapa orang ini" dan ikut tercetak. Peran tanda tangan **dihitung**
dari jabatan lewat `Services/JabatanUser`, tidak disimpan.
