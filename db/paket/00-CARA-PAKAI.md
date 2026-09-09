# Membangun paket penyerahan produksi

Semuanya dijalankan di VM — Mac tidak punya .NET. Deploy dulu supaya sumber di
VM mutakhir, lalu:

```bash
scp -i ~/.ssh/kpb_win db/paket/buat-paket.ps1 db/paket/data-inti.sql \
    'dhika\andhi@<IP>:C:/dev/'
ssh -i ~/.ssh/kpb_win 'dhika\andhi@<IP>' \
    'powershell -ExecutionPolicy Bypass -File C:\dev\buat-paket.ps1'
```

Hasilnya di `C:\dev\dist`. Lengkapi tiga berkas yang tidak dibuat skrip itu,
lalu tarik dan kemas dari Mac:

```bash
scp -i ~/.ssh/kpb_win db/paket/appsettings.contoh.json \
    'dhika\andhi@<IP>:C:/dev/dist/app/appsettings.json'
scp -i ~/.ssh/kpb_win db/paket/BACA-DULU.md \
    documentation/CHANGELOG.md 'dhika\andhi@<IP>:C:/dev/dist/'
scp -i ~/.ssh/kpb_win documentation/09-Lingkungan-Produksi.md \
    'dhika\andhi@<IP>:C:/dev/dist/LINGKUNGAN.md'

rm -rf dist && mkdir -p dist
scp -r -i ~/.ssh/kpb_win 'dhika\andhi@<IP>:C:/dev/dist' dist/paket
mkdir -p dist/paket/app/wwwroot/uploads
(cd dist/paket && zip -qr ../docuflow-v<versi>.zip .)
```

## Jangan dilewati

**Uji jalur skrip dari basis data kosong sebelum menyerahkan.**

```bash
scp -i ~/.ssh/kpb_win db/paket/uji-jalur-a.ps1 'dhika\andhi@<IP>:C:/dev/'
ssh -i ~/.ssh/kpb_win 'dhika\andhi@<IP>' \
    'powershell -ExecutionPolicy Bypass -File C:\dev\uji-jalur-a.ps1'
```

Harus keluar 251 surat, 569 barang, 10 pengguna, 514 kota, dan counter
BAST 145 / BAPB 96 / BALP 15 / BA 5 / SPD 14. Uji ini pernah menemukan dua hal
yang tidak terlihat dari mesin pengembangan: skema yang **tidak bisa dibangun
dari nol sama sekali** (`migrationBuilder.Sql` menyebut kolom yang baru
ditambahkan di batch yang sama), dan skrip INSERT yang terpotong `sqlcmd -W`.

**Zip dikemas dari Mac, bukan `Compress-Archive`.** PowerShell menulis pemisah
backslash yang tidak sesuai spesifikasi zip.

**`wwwroot/uploads` dikirim kosong**, tapi foldernya harus ada.

**Naikkan `<Version>` di csproj dan tambahkan entri `documentation/CHANGELOG.md`
sebelum publish.** Badge versi membacanya dari assembly, jadi paket tanpa
kenaikan versi tidak bisa dibedakan dari paket sebelumnya.
