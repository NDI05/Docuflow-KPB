#!/usr/bin/env bash
# Uji race condition penomoran surat.
#
# Menembak N POST /Surat/Create secara bersamaan, lalu memastikan tidak ada
# NomorSurat ganda. Sebelum perbaikan (counter tanpa kunci, tanpa transaksi)
# uji ini gagal; sesudahnya harus bersih.
#
# Jalankan dari Mac:  ./db/test-nomor-concurrent.sh [jumlah]
#
# Surat yang dibuat selama uji dihapus lagi di akhir.

set -euo pipefail

# Alamat VM, akun SSH, dan kredensial uji diambil dari .deploy.local yang
# diabaikan git — repo ini publik, jadi tidak ada yang di-hardcode di sini.
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[ -f "$REPO/.deploy.local" ] && . "$REPO/.deploy.local"

VM_IP="${VM_IP:?VM_IP belum diset. Isi .deploy.local}"
VM_USER="${VM_USER:?VM_USER belum diset. Isi .deploy.local}"

# Aplikasi dilayani IIS di /docflow; Kestrel port 5090 sudah dipensiunkan.
HOST="${HOST:-http://$VM_IP/docflow}"
SSH_TARGET="$VM_USER@$VM_IP"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/id_rsa}"
USERNAME="${TEST_USERNAME:?TEST_USERNAME belum diset. Isi .deploy.local}"
PASSWORD="${TEST_PASSWORD:?TEST_PASSWORD belum diset. Isi .deploy.local}"
N="${1:-10}"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

sqlq() {
  ssh -i "$SSH_KEY" "$SSH_TARGET" \
    "sqlcmd -S \"localhost\\SQLEXPRESS\" -E -d DocuflowDB -h-1 -W -Q \"SET NOCOUNT ON; $1\""
}

token() { # ekstrak antiforgery token dari halaman HTML
  grep -o 'name="__RequestVerificationToken"[^>]*value="[^"]*"' "$1" \
    | head -1 | sed 's/.*value="\([^"]*\)".*/\1/'
}

echo "== login sebagai $USERNAME =="
curl -sS -c "$WORK/cookies" -o "$WORK/login.html" "$HOST/Account/Login"
curl -sS -b "$WORK/cookies" -c "$WORK/cookies" -o /dev/null \
  -d "Username=$USERNAME" \
  -d "Password=$PASSWORD" \
  --data-urlencode "__RequestVerificationToken=$(token "$WORK/login.html")" \
  "$HOST/Account/Login"

echo "== ambil form Create =="
curl -sS -b "$WORK/cookies" -c "$WORK/cookies" -o "$WORK/create.html" "$HOST/Surat/Create"
FORM_TOKEN="$(token "$WORK/create.html")"
if [ -z "$FORM_TOKEN" ]; then
  echo "GAGAL: tidak dapat token — login kemungkinan gagal" >&2
  exit 1
fi

# jenis surat pertama yang tersedia
# [0-9][0-9]* — bukan [0-9]*, supaya placeholder <option value=""> tidak ikut cocok
JENIS_ID="$(grep -o '<option value="[0-9][0-9]*"' "$WORK/create.html" | head -1 \
  | sed 's/.*value="\([0-9]*\)".*/\1/')"
: "${JENIS_ID:?tidak ada JenisSurat di form}"

MAX_ID_BEFORE="$(sqlq 'SELECT ISNULL(MAX(Id),0) FROM Surat' | tr -d '[:space:]')"
echo "== tembak $N POST bersamaan (JenisSuratId=$JENIS_ID, MAX Id awal=$MAX_ID_BEFORE) =="

for i in $(seq 1 "$N"); do
  # -b tanpa -c: cookie jar dibaca saja, tidak ditulis paralel
  curl -sS -b "$WORK/cookies" -o /dev/null -w '%{http_code}\n' \
    -d "JenisSuratId=$JENIS_ID" \
    -d "Deskripsi=uji-concurrent-$i" \
    -d "NamaBarang[]=UjiRace" \
    -d "SerialNumber[]=SN$i" \
    -d "MerkType[]=-" \
    -d "Pengguna[]=-" \
    --data-urlencode "__RequestVerificationToken=$FORM_TOKEN" \
    "$HOST/Surat/Create" >> "$WORK/codes" &
done
wait

echo "   kode HTTP: $(sort "$WORK/codes" | uniq -c | tr '\n' ' ')"

echo "== periksa nomor ganda =="
DUP="$(sqlq "SELECT NomorSurat + ' x' + CAST(COUNT(*) AS varchar) FROM Surat WHERE Id > $MAX_ID_BEFORE GROUP BY NomorSurat HAVING COUNT(*) > 1")"
CREATED="$(sqlq "SELECT COUNT(*) FROM Surat WHERE Id > $MAX_ID_BEFORE" | tr -d '[:space:]')"

echo "== bersihkan $CREATED surat uji =="
sqlq "DELETE FROM BarangSurat WHERE SuratId > $MAX_ID_BEFORE; DELETE FROM Surat WHERE Id > $MAX_ID_BEFORE" > /dev/null

if echo "$DUP" | grep -q 'x[0-9]'; then
  echo "GAGAL: ada nomor surat ganda"
  echo "$DUP"
  exit 1
fi

echo "LULUS: $CREATED surat dibuat, semua nomor unik"
