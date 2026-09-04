#!/usr/bin/env bash
# =====================================================================
# Uji Services/Terbilang.cs.
#
# Terbilang mencetak jumlah barang dalam huruf pada dokumen resmi, jadi
# salah satu digit saja sudah cukup untuk membuat berita acara menyebut
# dua jumlah yang berbeda. Kaidah bahasa Indonesia yang mudah salah:
# "sepuluh" bukan "satu puluh", "sebelas" bukan "satu belas", "seratus"
# dan "seribu" tanpa "satu" di depannya.
#
# Mac tidak punya .NET, jadi pengujian dijalankan di VM lewat proyek
# konsol sementara di C:\dev\tmp-terbilang. Proyek itu dihapus setelah
# selesai dan tidak pernah masuk repo.
#
#   ./db/test-terbilang.sh
# =====================================================================
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
. "$REPO/.deploy.local"

SSH="ssh -i $SSH_KEY $VM_USER@$VM_IP"
REMOTE='C:\dev\tmp-terbilang'

SUMBER="$REPO/Docuflow_projectIT-KPB/Services/Terbilang.cs"
[ -f "$SUMBER" ] || { echo "Tidak menemukan $SUMBER"; exit 1; }

echo "==> Siapkan proyek uji di VM"
$SSH "powershell -Command \"if (Test-Path '$REMOTE') { Remove-Item '$REMOTE' -Recurse -Force }; dotnet new console -o '$REMOTE' --force | Out-Null\"" >/dev/null

scp -q -i "$SSH_KEY" "$SUMBER" "$VM_USER@$VM_IP:C:/dev/tmp-terbilang/Terbilang.cs"

# Program uji ditulis di sini, bukan di-scp sebagai berkas terpisah,
# supaya daftar kasusnya berada tepat di sebelah alasan pengujiannya.
cat > /tmp/terbilang-program.cs <<'EOF'
using System;
using Docuflow_projectIT_KPB.Services;

class Uji
{
    static int gagal = 0;

    static void Cek(long n, string harap)
    {
        var dapat = Terbilang.Ubah(n);
        if (dapat != harap)
        {
            Console.WriteLine($"GAGAL {n}: harap \"{harap}\", dapat \"{dapat}\"");
            gagal++;
        }
    }

    static int Main()
    {
        Cek(0, "nol");
        Cek(1, "satu");
        Cek(4, "empat");
        Cek(9, "sembilan");
        Cek(10, "sepuluh");
        Cek(11, "sebelas");
        Cek(12, "dua belas");
        Cek(15, "lima belas");
        Cek(19, "sembilan belas");
        Cek(20, "dua puluh");
        Cek(21, "dua puluh satu");
        Cek(50, "lima puluh");
        Cek(99, "sembilan puluh sembilan");
        Cek(100, "seratus");
        Cek(101, "seratus satu");
        Cek(110, "seratus sepuluh");
        Cek(111, "seratus sebelas");
        Cek(199, "seratus sembilan puluh sembilan");
        Cek(200, "dua ratus");
        Cek(250, "dua ratus lima puluh");
        Cek(999, "sembilan ratus sembilan puluh sembilan");
        Cek(1000, "seribu");
        Cek(1001, "seribu satu");
        Cek(1100, "seribu seratus");
        Cek(2000, "dua ribu");
        Cek(2500, "dua ribu lima ratus");
        Cek(10000, "sepuluh ribu");
        Cek(11000, "sebelas ribu");
        Cek(100000, "seratus ribu");
        Cek(1000000, "satu juta");
        Cek(1500000, "satu juta lima ratus ribu");
        Cek(-3, "minus tiga");

        // Kapital hanya menaikkan huruf pertama, tidak mengubah kaidahnya.
        if (Terbilang.Kapital(11) != "Sebelas") { Console.WriteLine("GAGAL Kapital(11)"); gagal++; }

        Console.WriteLine(gagal == 0 ? "LULUS: seluruh kasus benar" : $"TOTAL GAGAL: {gagal}");
        return gagal == 0 ? 0 : 1;
    }
}
EOF

scp -q -i "$SSH_KEY" /tmp/terbilang-program.cs "$VM_USER@$VM_IP:C:/dev/tmp-terbilang/Program.cs"
rm -f /tmp/terbilang-program.cs

echo "==> Jalankan"
set +e
$SSH "powershell -Command \"cd '$REMOTE'; dotnet run --nologo\"" | tr -d '\r'
hasil=${PIPESTATUS[0]}
set -e

$SSH "powershell -Command \"Remove-Item '$REMOTE' -Recurse -Force\"" >/dev/null

exit $hasil
