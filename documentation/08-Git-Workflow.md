# Alur Kerja Git & Deploy Docuflow

## Pembagian peran mesin

| Mesin | Peran |
|---|---|
| **Mac** | Sumber kebenaran edit. Kode, `graphify-out/`, dokumentasi, commit & push. |
| **VM Windows** | Build, run, SQL Server. **Tidak pernah diedit langsung.** |

Alasannya: agent berjalan di Mac, jadi graph dan hook harus di Mac. Graph kedua
di Windows hanya akan drift. Sebaliknya, aplikasi wajib jalan di Windows karena
`wkhtmltopdf.exe` dan Windows Authentication ke SQL Server.

Repo di VM (`C:\dev\docuflow`) adalah clone dari remote yang sama, tapi
diperlakukan sebagai **target deploy**, bukan working copy. Isinya ditimpa tiap
kali `deploy.sh` jalan.

## Deploy

```bash
./deploy.sh            # sync + build + restart + verifikasi
./deploy.sh --clean    # sama, tapi hapus bin/obj dulu (kalau build stale)
```

Yang dikerjakan:

1. `tar czf` dengan `COPYFILE_DISABLE=1`, mengecualikan `.git bin obj .DS_Store graphify-out`.
2. `scp` ke `C:/dev/docuflow-sync.tgz`.
3. Di VM: hentikan app → `tar xzf` → hapus file AppleDouble `._*` → `dotnet build`.
4. Restart lewat `start-app.ps1`.
5. Verifikasi: `/` harus 200, dan `/Surat/GeneratePdf/1` harus 200 `application/pdf`.
   Skrip keluar dengan status gagal kalau salah satu meleset.
6. `graphify update .` di Mac.

Dua jebakan yang sudah pernah menggigit:

- **`tar xzf` tidak menghapus file yang sudah dihapus di Mac.** Setelah refactor
  yang membuang file, cek sisa file lama di VM secara manual.
- **File `._*` bikin build C# gagal.** Sudah ditangani `COPYFILE_DISABLE=1` di
  Mac dan penghapusan di VM, jadi dua lapis.

## Git

- Branch utama: `master`. Remote: `github.com/mrpochinowell20/Docuflow_projectIT-KPB`.
- Commit dan push **dari Mac**. Repo VM tidak pernah di-commit.
- `graphify-out/` sebaiknya masuk `.gitignore` — isinya artefak turunan dan
  berubah tiap `graphify update`, jadi hanya bikin diff berisik.

## Berkas yang belum masuk git (per 2026-07-27)

| Berkas | Saran |
|---|---|
| `db/seed-testing.sql` | commit — berguna untuk siapa pun yang setup ulang DB |
| `start-app.ps1` | commit — bagian dari cara menjalankan sistem |
| `deploy.sh` | commit |
| `CLAUDE.md`, `.claude/settings.json` | commit — konfigurasi agent bersama |
| `.claude/settings.local.json` | jangan commit — izin lokal per mesin |
| `documentation/` | commit |
| `graphify-out/` | gitignore |
| `.agents/`, `skills-lock.json` | commit kalau skill ponytail mau dipakai bersama |
