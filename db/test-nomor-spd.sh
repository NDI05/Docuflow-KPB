#!/usr/bin/env bash
# Uji race condition penomoran SPD.
#
# Salinan db/test-nomor-concurrent.sh yang diarahkan ke /Spd/Create. SENGAJA
# disalin, bukan diparameterkan: kedua endpoint mengirim isian form yang
# berbeda dan memeriksa tabel yang berbeda, jadi versi bersama akan lebih
# banyak percabangan daripada kode.
#
# Kenapa perlu sendiri: skrip aslinya memeriksa duplikat dengan
# "SELECT NomorSurat FROM Surat" dan membersihkan tabel Surat. Diarahkan ke
# /Spd/Create tanpa mengganti kueri itu, ia akan melaporkan "LULUS: 0 surat
# dibuat, semua nomor unik" berapa pun rusaknya transaksi SPD — hijau sambil
# tidak menguji apa pun.
#
# Jalankan dari Mac:  ./db/test-nomor-spd.sh [jumlah]
#
# SPD yang dibuat selama uji dihapus lagi di akhir.

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
curl -sS -b "$WORK/cookies" -c "$WORK/cookies" -o "$WORK/create.html" "$HOST/Spd/Create"
FORM_TOKEN="$(token "$WORK/create.html")"
if [ -z "$FORM_TOKEN" ]; then
  echo "GAGAL: tidak dapat token — login kemungkinan gagal" >&2
  exit 1
fi

# staff pertama yang tersedia, dibaca dari <select id="StaffId"> — bukan dari
# <option> pertama di halaman, karena datalist kota juga penuh <option>.
STAFF_ID="$(sed -n '/id="StaffId"/,/<\/select>/p' "$WORK/create.html" \
  | grep -o '<option value="[0-9][0-9]*"' | head -1 \
  | sed 's/.*value="\([0-9]*\)".*/\1/')"
: "${STAFF_ID:?tidak ada staff di form}"

# kota apa pun yang benar-benar ada; nama harus cocok persis dengan tabel Kota
KOTA="$(sqlq "SELECT TOP 1 Nama FROM Kota ORDER BY Nama" | sed 's/[[:space:]]*$//')"
: "${KOTA:?tabel Kota kosong — jalankan db/seed-kota.sql dulu}"

MAX_ID_BEFORE="$(sqlq 'SELECT ISNULL(MAX(Id),0) FROM Spd' | tr -d '[:space:]')"
echo "== tembak $N POST bersamaan (StaffId=$STAFF_ID, kota=$KOTA, MAX Id awal=$MAX_ID_BEFORE) =="

for i in $(seq 1 "$N"); do
  # -b tanpa -c: cookie jar dibaca saja, tidak ditulis paralel
  curl -sS -b "$WORK/cookies" -o /dev/null -w '%{http_code}\n' \
    -d "StaffId=$STAFF_ID" \
    --data-urlencode "NamaKota=$KOTA" \
    -d "Keperluan=uji-concurrent-$i" \
    -d "TanggalDinas=2026-01-15" \
    --data-urlencode "__RequestVerificationToken=$FORM_TOKEN" \
    "$HOST/Spd/Create" >> "$WORK/codes" &
done
wait

echo "   kode HTTP: $(sort "$WORK/codes" | uniq -c | tr '\n' ' ')"

echo "== periksa nomor ganda =="
DUP="$(sqlq "SELECT NomorSpd + ' x' + CAST(COUNT(*) AS varchar) FROM Spd WHERE Id > $MAX_ID_BEFORE GROUP BY NomorSpd HAVING COUNT(*) > 1")"
CREATED="$(sqlq "SELECT COUNT(*) FROM Spd WHERE Id > $MAX_ID_BEFORE" | tr -d '[:space:]')"

echo "== bersihkan $CREATED SPD uji =="
sqlq "DELETE FROM Spd WHERE Id > $MAX_ID_BEFORE" > /dev/null

if echo "$DUP" | grep -q 'x[0-9]'; then
  echo "GAGAL: ada nomor surat ganda"
  echo "$DUP"
  exit 1
fi

echo "LULUS: $CREATED SPD dibuat, semua nomor unik"
