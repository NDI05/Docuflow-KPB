#!/usr/bin/env bash
# =====================================================================
# Deploy Docuflow: Mac (sumber edit) -> IIS di VM Windows
#
#   ./deploy.sh           sync + build + publish + restart + verifikasi
#   ./deploy.sh --clean    sama, tapi hapus bin/obj dulu (build stale)
#
# Mac tidak punya .NET; build selalu terjadi di VM.
#
# Instance Kestrel di port 5090 sudah dipensiunkan (2026-08-06). Satu-satunya
# yang dilayani sekarang adalah IIS di /docflow. start-app.ps1 masih ada di
# VM kalau suatu saat perlu menjalankan Kestrel manual untuk debugging, tapi
# tidak lagi bagian dari alur deploy.
# =====================================================================
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Alamat VM dan akun SSH TIDAK ditulis di berkas ini — repo ini publik.
# Taruh di .deploy.local (diabaikan git):
#
#   VM_IP=10.0.0.5
#   VM_USER='domain\user'
#   SSH_KEY="$HOME/.ssh/kunci"
#
# IP-nya sendiri berasal dari DHCP vmnet8, jadi berubah tiap VM dibuat ulang.
# Cari yang aktif lewat berkas lease VMware, jangan percaya angka yang
# tertulis di mana pun.
[ -f "$REPO/.deploy.local" ] && . "$REPO/.deploy.local"

VM_IP="${VM_IP:?VM_IP belum diset. Isi .deploy.local, atau: VM_IP=x.x.x.x ./deploy.sh}"
VM_USER="${VM_USER:?VM_USER belum diset. Isi .deploy.local}"
KEY="${SSH_KEY:-$HOME/.ssh/id_rsa}"

VM="$VM_USER@$VM_IP"
BASE="http://$VM_IP/docflow"
TGZ="${TMPDIR:-/tmp}/docuflow-sync.tgz"

CLEAN=""
for arg in "$@"; do
    case "$arg" in
        --clean) CLEAN='Remove-Item C:\dev\docuflow\Docuflow_projectIT-KPB\bin,C:\dev\docuflow\Docuflow_projectIT-KPB\obj -Recurse -Force -ErrorAction SilentlyContinue;' ;;
    esac
done

cd "$REPO"

# ---------------------------------------------------------------------
echo "==> 1/5 Paket sumber"
# COPYFILE_DISABLE=1 mencegah file AppleDouble ._* yang bikin build C# gagal
COPYFILE_DISABLE=1 tar czf "$TGZ" \
    --exclude='.git' \
    --exclude='bin' \
    --exclude='obj' \
    --exclude='.DS_Store' \
    --exclude='graphify-out' \
    Docuflow_projectIT-KPB db start-app.ps1

echo "    $(du -h "$TGZ" | cut -f1)"

# ---------------------------------------------------------------------
echo "==> 2/5 Kirim ke VM"
scp -i "$KEY" -q "$TGZ" "$VM:C:/dev/docuflow-sync.tgz"

# ---------------------------------------------------------------------
echo "==> 3/5 Extract + build di VM"
# tar xzf TIDAK menghapus file yang sudah dihapus di Mac - cek sisa file
# lama sendiri setelah refactor.
ssh -i "$KEY" "$VM" "
Get-Process Docuflow_projectIT-KPB -ErrorAction SilentlyContinue | Stop-Process -Force;
Start-Sleep -Seconds 1;
cd C:\dev\docuflow;
tar xzf C:\dev\docuflow-sync.tgz;
Get-ChildItem -Recurse -Force -Filter '._*' | Remove-Item -Force -ErrorAction SilentlyContinue;
$CLEAN
dotnet build 2>&1 | Select-String 'error|Error\(s\)|Elapsed' | Select-Object -Last 3
" 2>&1 | grep -v '^\*\*'

# ---------------------------------------------------------------------
echo "==> 4/5 Publish + restart app pool IIS"
# App pool dihentikan dulu: w3wp mengunci DLL aplikasi, dan publish ke folder
# yang sedang dipakai akan gagal separuh jalan.
ssh -i "$KEY" "$VM" '
  Import-Module WebAdministration;
  if ((Get-WebAppPoolState -Name Docflow).Value -ne "Stopped") { Stop-WebAppPool -Name Docflow };
  Start-Sleep -Seconds 3;
  cd C:\dev\docuflow\Docuflow_projectIT-KPB;
  dotnet publish -c Release -o C:\inetpub\docflow --nologo 2>&1 | Select-String "error|->" | Select-Object -Last 2;

  # Folder unggahan harus ada dan bisa DITULISI app pool. Publish tidak
  # membuatnya, dan izinnya hilang setiap kali folder situs dihapus lalu
  # dibangun ulang - folder baru hanya mewarisi read+execute dari induknya.
  # Itu terjadi 9 September 2026 saat pindah ke net8, dan gejalanya jauh dari
  # sebabnya: unggah BALP membalas HTTP 500 UnauthorizedAccessException,
  # sementara seluruh halaman lain tetap 200. Disetel ulang tiap deploy supaya
  # tidak bergantung pada ingatan siapa pun.
  #
  # Modify HANYA di uploads. Sisa folder situs tetap read+execute: proses web
  # yang bisa menimpa DLL-nya sendiri adalah risiko yang tidak perlu.
  New-Item -ItemType Directory -Path C:\inetpub\docflow\wwwroot\uploads -Force | Out-Null;
  icacls C:\inetpub\docflow\wwwroot\uploads /grant "IIS AppPool\Docflow:(OI)(CI)M" /Q | Out-Null;

  Start-WebAppPool -Name Docflow;
  Start-Sleep -Seconds 2;
  (Get-WebAppPoolState -Name Docflow).Value
' 2>&1 | grep -v '^\*\*'

# ---------------------------------------------------------------------
echo "==> 5/5 Verifikasi"
JAR="$(mktemp)"

code=$(curl -sS -m 15 -o /dev/null -w '%{http_code}' "$BASE/")
echo "    /                    $code"
[ "$code" = "200" ] || { echo "GAGAL: halaman login tidak 200"; exit 1; }

# Login + PDF: regresi paling penting (wkhtmltopdf + working directory)
tok=$(curl -sS -c "$JAR" "$BASE/Account/Login" \
      | grep -oE 'name="__RequestVerificationToken"[^>]*value="[^"]+"' \
      | sed -E 's/.*value="([^"]+)".*/\1/' | head -1)

curl -sS -b "$JAR" -c "$JAR" -o /dev/null \
     -X POST "$BASE/Account/Login" \
     --data-urlencode "Username=${TEST_USERNAME:?TEST_USERNAME belum diset. Isi .deploy.local}" \
     --data-urlencode "Password=${TEST_PASSWORD:?TEST_PASSWORD belum diset. Isi .deploy.local}" \
     --data-urlencode "__RequestVerificationToken=$tok"

# Id surat tidak selalu mulai dari 1 (seed di-reset, surat dihapus), jadi
# ambil yang paling kecil yang benar-benar ada.
SID=$(ssh -i "$KEY" "$VM" 'sqlcmd -S "localhost\SQLEXPRESS" -E -d DocuflowDB -h-1 -W -Q "SET NOCOUNT ON; SELECT ISNULL(MIN(Id),0) FROM Surat"' 2>/dev/null | tr -dc '0-9')

if [ -z "$SID" ] || [ "$SID" = "0" ]; then
    echo "    /Surat/GeneratePdf   DILEWATI (belum ada surat di DB)"
else
    pdf=$(curl -sS -b "$JAR" -o /dev/null -w '%{http_code} %{content_type}' "$BASE/Surat/GeneratePdf/$SID")
    echo "    /Surat/GeneratePdf/$SID $pdf"

    case "$pdf" in
        "200 application/pdf") ;;
        *) rm -f "$JAR"; echo "GAGAL: generate PDF rusak (wkhtmltopdf / working directory)"; exit 1 ;;
    esac
fi

# SPD memakai tabelnya sendiri. Deploy tidak pernah menjalankan migration
# (Program.cs tidak punya Database.Migrate), jadi menerbitkan SpdController
# sebelum migration-nya diterapkan menghasilkan deploy hijau di atas halaman
# yang 500. Probe ini yang menangkapnya.
spd=$(curl -sS -b "$JAR" -o /dev/null -w '%{http_code}' "$BASE/Spd/Index")
echo "    /Spd/Index           $spd"
rm -f "$JAR"

if [ "$spd" != "200" ]; then
    echo "GAGAL: /Spd/Index tidak 200 — migration Spd/Kota kemungkinan belum diterapkan di VM"
    exit 1
fi

# ---------------------------------------------------------------------
graphify update . >/dev/null 2>&1 || true
echo "==> Selesai. $BASE"
