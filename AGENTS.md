# AGENTS.md — panduan bagi yang melanjutkan

Untuk developer berikutnya, manusia maupun agent AI. Dibaca **sebelum** menyentuh
kode. Isinya bukan pengulangan kode, melainkan hal-hal yang tidak terlihat dari
membaca kode dan sudah pernah memakan waktu atau merusak data.

- **`CLAUDE.md`** di root memuat rincian operasional lengkapnya — jebakan per
  fitur, per template, per migration. Berkas ini adalah pintu masuknya.
- **`documentation/`** memuat PRD, ERD, diagram, keamanan, dan status.

---

## 1. Apa ini

Sistem penerbitan dan pengarsipan **berita acara** untuk Fungsi IT, Kilang
Pertamina Balikpapan. Menggantikan sistem lama berbasis MariaDB.

Yang dikerjakannya:

- menerbitkan **nomor surat** yang berurut dan tidak pernah kembar;
- menyimpan isi dokumennya (barang, poin laporan, penanda tangan);
- **mencetak PDF** dengan tata letak resmi per jenis dokumen;
- mengarsipkan dan mencarinya per tahun.

Empat kode dokumen, delapan jenis:

| Kode | Jenis |
|---|---|
| `BAST` | Serah Terima Barang · Serah Terima Data CCTV |
| `BA` | Kerusakan · Survey |
| `BAPB` | Pengembalian Barang Rusak / Sewa (ke vendor) · dari User ke IT |
| `BALP` | Layak Pakai — **nomornya saja**, suratnya dibuat vendor |

Ditambah **SPD** (Sub Pekerjaan Dinas): menu sendiri, tabel sendiri, deret nomor
sendiri. Bukan berita acara.

Format nomor: `{KODE} {NNN}/KPB3240/{tahun}-S0`, mis. `BAST 146/KPB3240/2026-S0`.

---

## 2. Menjalankannya

**Mac tidak punya .NET sama sekali.** Mac dipakai untuk menyunting, VM Windows
untuk membangun dan menjalankan. Ini bukan preferensi — `wkhtmltopdf.exe`
(pencetak PDF) hanya ada untuk Windows, dan sambungan basis datanya memakai
Windows Authentication.

```bash
VM_IP=<alamat-vm> ./deploy.sh
```

Skrip itu mengemas sumber, mengirimnya, membangun, mem-publish ke IIS, lalu
memverifikasi tiga hal: halaman utama 200, cetak PDF 200 `application/pdf`, dan
`/Spd/Index` 200.

**Alamat VM berpindah-pindah** (DHCP). Cari yang hidup:

```bash
grep -A2 '^lease' /var/db/vmware/vmnet-dhcpd-vmnet8.leases | tail -20
"/Applications/VMware Fusion.app/Contents/Public/vmrun" -T fusion list
```

Setelan pribadi (alamat VM, kunci SSH, akun uji) ada di `.deploy.local`, tidak
masuk git.

---

## 3. Peta kode

```
Controllers/
  SuratController    Index Create Edit Details Preview GeneratePdf Download UnggahBalp Delete
  SpdController      Index Create Delete
  UsersController    Index Create Edit ResetPassword Delete     (hanya SuperAdmin)
  AccountController  Login Logout
  HomeController     Index (dashboard, bercabang menurut peran)

Services/            aturan yang TIDAK boleh disalin ke view
  NomorSuratService  penerbitan nomor, aman terhadap penerbitan bersamaan
  Bapb Bast Ba Balp  aturan per jenis: arah, label, tata letak
  JabatanUser        daftar jabatan + siapa yang menandatangani apa
  Terbilang          angka -> huruf, untuk kolom JUMLAH pada BAPB
  RonaJenis          warna label per jenis
  AuditLog           jejak audit

Views/Surat/
  Create.cshtml         SATU formulir untuk Buat DAN Ubah, dibedakan Model.Id > 0
  SuratTemplate         cetak BAST
  SuratTemplateBa       cetak BA (dua bentuk kop: Kerusakan dan Survey)
  SuratTemplateBapb     cetak BAPB

db/
  paket/    perkakas membangun paket penyerahan produksi
  arsip/    perkakas membangun ulang arsip 2026 dari dump sistem lama
  *.sql     seed dan migrasi data
  *.sh      uji penomoran bersamaan, terbilang, SPD
```

---

## 4. Delapan hal yang akan menggigit

Urut menurut seberapa mahal akibatnya.

### 4.1 Skrip impor arsip pernah menghapus dokumen operator

`db/impor-arsip-2026.sql` **menghapus lalu menulis ulang** arsipnya. Penjaga
versi pertama hanya memeriksa awalan nomor (`NomorSurat NOT LIKE 'BAST %'`) —
padahal surat yang dibuat lewat aplikasi juga berawalan `BAST `. Pada 8
September 2026 penjagaan longgar itu menghapus `BAST 146`, dokumen yang baru
dibuat operator, dan **isinya tidak bisa dikembalikan** karena basis datanya
memakai recovery model `SIMPLE`.

Sekarang penjaganya memuat daftar 251 nomor secara tegas. **Jangan pernah
melonggarkannya lagi.** Ambil cadangan sebelum menjalankan skrip apa pun yang
menghapus.

### 4.2 Penomoran aman-bersamaan, dan mudah dirusak tanpa sadar

Tiga bagian, hilang satu saja balapannya terbuka lagi:

1. `NomorSuratService` membaca counter dengan `FromSqlInterpolated` +
   `WITH (UPDLOCK, HOLDLOCK)`;
2. pemanggilnya membungkus **penerbitan nomor dan penyimpanan surat dalam satu
   transaksi** — tanpa itu kuncinya lepas di akhir statement dan hint-nya jadi
   hiasan. Diukur, bukan dikira: 11 dari 12 pengiriman bersamaan mendapat nomor
   yang sama;
3. index unik pada `CounterNomorSurat (Kode, Tahun)`.

Uji regresinya: `./db/test-nomor-concurrent.sh 20`.

Counter dikunci pada **`Kode`**, bukan `JenisSuratId` — dua jenis berbagi satu
kode, jadi counter per jenis akan memberi keduanya `001`.

### 4.3 Hiasan layar ikut tercetak

Ketiga template menggambar lembar kertas untuk dilihat di layar (latar abu,
bayangan, jarak luar). Ketiganya ikut masuk PDF dan hasilnya tampak seperti
hasil pindai. Sekarang CSS bawaannya bentuk cetak; hiasannya hanya dirender saat
`ViewData["Cetak"]` tidak diset.

Tiga hal yang membuatnya benar, dan semuanya diperlukan:

- `new ViewAsPdf(view, model, ViewData)` — **`ViewAsPdf` tidak mewarisi
  `ViewData` milik controller**. Gejalanya diam: PDF tetap terbit, bentuknya
  saja yang salah;
- `PageMargins = new Margins(0,0,0,0)` + `@page { margin: 0 }` — kalau tidak,
  jarak tepinya bertumpuk dua kali;
- `--disable-smart-shrinking` — bawaannya wkhtmltopdf menata halaman pada lebar
  semunya lalu mengecilkan seluruhnya, sehingga `18mm` tercetak jadi `~35mm`.

### 4.4 Formulir dipakai dua kali

`Create.cshtml` melayani Buat dan Ubah sekaligus. Menyalinnya jadi `Edit.cshtml`
berarti setiap aturan per jenis ditulis dua kali, dan yang terlupa hanya
ketahuan dari dokumen yang salah cetak.

Pada Ubah, **`NomorSurat`, `JenisSuratId`, dan `Tanggal` tidak pernah disalin
dari form** — nomor sudah tercetak di kertas, kode jenis ada di dalam nomor itu,
dan tanggalnya menentukan tahun nomor sekaligus tahun arsip. Formulirnya
mengunci ketiganya, tapi **penjagaan sebenarnya di controller** — form bisa
dipalsukan.

### 4.5 Nilai dari form berakhir di File.Delete

Gambar poin yang dipertahankan dikirim balik sebagai `GambarLama_<kunci>[]`
berisi path-nya, dan `SuratController.Edit` memakai daftar itu untuk memutuskan
berkas mana yang **dihapus dari disk**. `PathUnggahanSah` memagari bentuknya
dengan regex — `PathFisik` hanya membuang garis miring depan, jadi
`/uploads/../../appsettings.json` akan keluar dari folder unggahan.

### 4.6 Skema sempat tidak bisa dibangun dari nol

`migrationBuilder.Sql` yang menyebut kolom hasil `AddColumn` di migration yang
**sama** harus dibungkus `EXEC(N'...')`. SQL Server mengompilasi seluruh batch
sebelum menjalankannya, jadi `UPDATE Users SET Jabatan = ...` gagal dengan
`Invalid column name`.

Tidak terlihat di mesin pengembangan karena `dotnet ef database update`
menjalankan tiap operasi sebagai batch sendiri. Yang gagal adalah
`dotnet ef migrations script` — satu-satunya cara membangun skema di produksi.

### 4.7 Kunci Data Protection

Tanpa `C:\ProgramData\Docuflow\keys` yang bisa ditulisi application pool,
ASP.NET Core menyimpan kuncinya di memori. Setiap daur ulang app pool (idle 20
menit, jadwal harian, atau setiap deploy) membatalkan seluruh token antiforgery
dan cookie sesi. Gejalanya: halaman login yang dibuka sebelum daur ulang, saat
dikirim, membalas **400 dengan badan kosong** — pengguna melihat halaman putih.

### 4.8 Aplikasi tidak boleh memuat apa pun dari internet

Bootstrap, font, dan seluruh ikon dari `wwwroot`; ikonnya inline SVG. Jaringan
kilang tertutup — satu tautan CDN membuat halaman itu rusak di sana, dan
rusaknya tidak terlihat dari mesin pengembangan. **Tidak ada JavaScript pihak
ketiga sama sekali**, dan karena itu tidak ada validasi sisi klien.

---

## 5. Cara mengubah sesuatu

1. **Sunting di Mac.** Jangan pernah menyunting di VM — tertimpa sinkronisasi
   berikutnya.
2. `graphify query "<pertanyaan>"` sebelum grep. Grafnya ada di `graphify-out/`.
3. `VM_IP=<ip> ./deploy.sh`
4. **Uji yang terdampak.** Kalau menyentuh cetak, ukur PDF-nya — jangan hanya
   melihat status 200. Kalau menyentuh penomoran, jalankan
   `db/test-nomor-concurrent.sh`.
5. `graphify update .` sebelum mengakhiri.

### Menambah kolom pada model

Migration hanya bisa dibuat di VM (Mac tidak punya .NET):

```
cd C:\dev\docuflow\Docuflow_projectIT-KPB
dotnet ef migrations add <Nama>
dotnet ef database update
```

Lalu **salin balik ke Mac** berkas migration-nya, `.Designer.cs`-nya, **dan**
`ApplicationDbContextModelSnapshot.cs`. Tanpa yang terakhir, Mac berhenti
menjadi sumber kebenaran dan scaffold berikutnya membandingkan dengan snapshot
basi.

Tidak ada yang menerapkan migration saat startup. Deploy tidak pernah mengubah
skema.

### Menambah jenis surat

1. Baris di `JenisSurat` (`Kode` + `NamaJenis`).
2. Kalau aturannya berbeda (arah, label, tata letak), taruh di `Services/` —
   **bukan** di view. Formulir dan template harus memanggil sumber yang sama,
   supaya label di layar tidak pernah berbeda dengan yang tercetak.
3. Kalau tata letak cetaknya berbeda, tambahkan template dan cabangnya di
   `SuratController.NamaTemplate()`.
4. Periksa `Create.cshtml`: `pilihBagian()` menentukan bagian mana yang tampil,
   dan `nomoriBagian()` **harus menjadi panggilan terakhir** di dalamnya.

---

## 6. Penyerahan ke produksi

`db/paket/00-CARA-PAKAI.md` memuat langkahnya. Ringkasnya:

- Aplikasi menargetkan **net8.0** — disamakan dengan TrackingSystem, sistem
  sebelah yang sudah berjalan di lingkungan Pertamina. Server di sana hanya
  punya ASP.NET Core 8 Hosting Bundle; dipublish sebagai net10.0, IIS membalas
  **HTTP 500.31** tanpa pesan lain.
- Basis data diserahkan sebagai **`.bacpac`**, diekspor dengan **sqlpackage
  162** (bukan 170) supaya modelnya `Sql160` dan masuk ke SQL Server 2022 ke
  atas.
- **Naikkan `<Version>` di csproj dan tambahkan entri `CHANGELOG.md` setiap
  publish.** Badge versi di setiap halaman membacanya dari assembly.

---

## 7. Yang sengaja tidak ada di git

| | Kenapa | Dibangun ulang lewat |
|---|---|---|
| `dist/` | paket 21 MB | `db/paket/00-CARA-PAKAI.md` |
| `db/impor-arsip-2026.sql` | data pegawai nyata | `db/arsip/00-CARA-PAKAI.md` |
| `db/rekonsiliasi-arsip.html` | data pegawai nyata | `db/arsip/00-CARA-PAKAI.md` |
| `.deploy.local` | alamat VM, kunci, password uji | disalin manual |

Repo ini **private**, dan harus tetap begitu: riwayat commit lamanya masih
memuat data pegawai.

---

## 8. Yang belum dikerjakan

- **BAKP** (Berita Acara Kemajuan Pekerjaan) — diminta, tapi format dokumennya
  belum ditentukan. Jenis yang bisa dipilih tapi tidak punya keluaran yang benar
  lebih buruk daripada tidak ada.
- **BAPP** dari arsip lama — 5 dokumen tanpa padanan. Kolom kuncinya bernama
  `No_BAST` dan strukturnya sama persis dengan BAST, **tapi deretnya terpisah**:
  BAPP 1–5 dan BAST 1–5 adalah sepuluh dokumen berbeda. Jangan pernah digabung.
- **Tanda tangan digital** — kolom `Users.TtdImagePath` ada tapi tidak dipakai.
- **HTTPS** — situs masih HTTP polos. `UseHttps` di `appsettings.json` menyalakan
  HSTS; **jangan** dinyalakan sebelum binding HTTPS benar-benar ada, karena HSTS
  di HTTP polos memaksa browser ke HTTPS secara permanen dan tidak bisa
  dibatalkan dari sisi server.
- **Recovery model `SIMPLE`** di mesin uji — tidak ada pemulihan ke titik waktu.
  Itu sebabnya `BAST 146` tidak bisa dikembalikan. Untuk produksi sebaiknya
  `FULL` dengan cadangan log berkala.
