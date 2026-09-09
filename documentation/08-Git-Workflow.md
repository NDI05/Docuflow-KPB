# Alur Kerja Git & Deploy Docuflow

Diperbarui **2026-09-09**.

## Branch

**`master` adalah trunk, dan satu-satunya branch.** Itu yang di-build, dikemas,
dan diserahkan ke produksi. Juga default branch di GitHub.

Sampai 9 September 2026 ada tiga branch, dan trunk sebenarnya bukan `master`:

| Branch | Nasib |
|---|---|
| `integrasi-tracking-system` | trunk sesungguhnya sejak Agustus; `master` di-fast-forward ke sini lalu branch-nya dihapus |
| `master` | tertinggal 9 commit tanpa satu pun commit khas; sekarang menyusul dan menjadi trunk |
| `worktree-pertamina-redesign` | redesain UI 28 Juli 2026 dari titik cabang yang jauh tertinggal, tidak jadi dipakai; dihapus |

Penggabungannya **fast-forward**, bukan merge commit — `master` memang tidak
punya apa pun yang khas (`git rev-list --count integrasi-tracking-system..master`
= 0), jadi tidak ada yang perlu digabungkan.

Dua commit redesain UI itu tidak hilang. Disimpan sebagai tag sebelum branch-nya
dihapus:

```bash
git show arsip/pertamina-redesign        # 598f7cb
git checkout -b coba arsip/pertamina-redesign
```

Desain yang berlaku sekarang adalah `wwwroot/css/docuflow.css`, yang lahir
belakangan lewat jalur lain — jadi tag itu arsip, bukan pekerjaan tertunda.

### Aturan ke depan

Kerjakan di branch bertopik, lalu gabungkan ke `master`. Jangan biarkan sebuah
branch topik berubah jadi trunk bayangan seperti yang terjadi pada
`integrasi-tracking-system`: begitu `master` tertinggal berminggu-minggu, tidak
ada lagi yang tahu mana yang dirilis tanpa membandingkan commit satu per satu.

## Remote

| Remote | Tujuan | Catatan |
|---|---|---|
| `origin` | `NDI05/Docuflow-KPB` | **private**, milik sendiri, bukan fork |
| `fork-lama` | `NDI05/Docuflow_projectIT-KPB` | fork lama, sudah private, tertinggal |
| `teman` | `mrpochinowell20/Docuflow_projectIT-KPB` | repo asal, rujukan saja |

Repo wajib tetap **private**: riwayat commit-nya memuat data pegawai nyata.
Berkas arsipnya sendiri sudah dikeluarkan dari git sejak 2026-09-09.


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
