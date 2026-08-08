# Supreme

Typeface merek Pertamina (lihat `asset/Typography.png`).

- Sumber: Fontshare — https://www.fontshare.com/fonts/supreme
- Penerbit: Indian Type Foundry
- Lisensi: Fontshare Free Font License — bebas dipakai untuk keperluan
  pribadi maupun komersial, termasuk web. Boleh dipaketkan bersama aplikasi.
  **Tidak boleh dijual kembali sebagai font.**
- Diunduh: 2026-08-06, empat bobot woff2 (400 / 500 / 700 / 800), total ~74 KB.

Berkas ini di-*self-host* dengan sengaja: aplikasi berjalan di jaringan
internal kilang dan tidak boleh bergantung pada CDN luar saat runtime.

Dirujuk lewat `@font-face` di `wwwroot/css/docuflow.css`. Kalau berkas di
sini hilang, tata letak tetap utuh — stack cadangan di variabel `--font`
yang dipakai, hanya identitas mereknya yang hilang.

Cara mengambil ulang kalau perlu:

```bash
curl -sS "https://api.fontshare.com/v2/css?f%5B%5D=supreme@400,500,700,800"
```

CSS yang dikembalikan berisi URL woff2 untuk tiap bobot, berurutan
400 → 500 → 700 → 800.
