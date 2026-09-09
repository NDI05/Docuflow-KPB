"""Bangun db/impor-arsip-2026.sql dari dump lama.

Prinsip: data lama dituang apa adanya ke kolom baru yang artinya paling dekat.
Tidak ada kolom yang ditafsirkan ulang, tidak ada nilai yang dikarang. Di mana
sumbernya tidak mencatat sesuatu, kolomnya dibiarkan kosong dan alasannya
ditulis di Deskripsi — bukan ditebak.

Dua aturan yang datang dari pemilik arsip, bukan dari data:

  Dokumen BAST lama hanya memuat empat hal: nomor, blok penanggung jawab di
  atas tabel barang, barangnya, dan tanda tangan penanggung jawab itu — nama
  yang sama dengan yang di atas tabel. Kotak "Yang Menerima" dan "Yang
  Menyerahkan" SELALU kosong, dan "Mengetahui" SELALU Ast. Manajer IT, tidak
  pernah orang lain. Jadi:

    Nama/Jabatan/Fungsi_Direktorat/Nopek -> blok penanggung jawab (terisi 140/140)
    Tujuan, YangMenerima, JabatanYangMenerima -> dibiarkan kosong
    StaffId                              -> dibiarkan kosong
    ManagerId                            -> Ast. Manajer IT, selalu

  Kolom *_Organik tidak pernah tercetak pada dokumen lamanya, jadi tidak
  boleh menempati kotak tanda tangan mana pun. Isinya turun ke Deskripsi
  sebagai catatan supaya tetap terekam.

  BA_Generic TIDAK diimpor. Satu-satunya barisnya kosong total (kolom
  Tentang kosong, tidak ada kolom isi lain), jadi mengimpornya berarti
  mencetak berita acara resmi tanpa isi, dengan jenis yang harus ditebak.
  Nomornya tetap aman: counter BA sudah di 5, jadi BA 001 tidak akan
  diterbitkan ulang.
"""
import json, re, sys

t = json.load(open(sys.argv[1], encoding='utf-8'))
out = []
W = out.append

def q(v):
    """Literal T-SQL. Kutip tunggal digandakan; baris baru dibiarkan apa adanya
    (T-SQL memperbolehkannya di dalam N'...')."""
    if v is None: return 'NULL'
    s = str(v).replace("'", "''")
    return "N'" + s + "'"

def rapi(v):
    if v is None: return None
    s = ' '.join(str(v).split())          # CR/LF/tab jadi satu spasi
    return s or None

def teks(v):
    """Untuk kolom panjang: rapikan spasi berlebih tapi pertahankan baris baru."""
    if v is None: return None
    s = re.sub(r'[ \t]+', ' ', str(v).replace('\r\n', '\n').replace('\r', '\n')).strip()
    return s or None

def ekor(kbo, cadangan='/KPB3240/2026-S0'):
    """KBO menyimpan ekor nomor. Garis miring depan tidak konsisten di sumber."""
    if not kbo or not kbo.strip(): return cadangan, True
    return '/' + kbo.strip().lstrip('/'), False

def nomor(kode, n, kbo):
    e, dikarang = ekor(kbo)
    return f'{kode} {int(n):03d}{e}', dikarang

def gabung(*bagian):
    isi = [b for b in bagian if b]
    return '\n'.join(isi) if isi else None

def pecah(v):
    """Satu sel sumber kadang memuat lebih dari satu serial."""
    if not v: return []
    return [x.strip() for x in re.split(r'[\r\n\t,;&]+|\s+dan\s+', str(v))
            if x.strip() and x.strip() != '-']

# Nama staff -> Id di tabel Users. Alias pendek ikut didaftarkan karena arsip
# lama menulis nama panggilan ("Hendy A.", "Mutiara") di kolom penerima.
STAF = {'hendy augustama': 3, 'hendy agustama': 3, 'hendy a.': 3, 'hendy a': 3, 'hendy': 3,
        'mutiara annisa': 1, 'mutiara nur annisa': 1, 'mutiara': 1,
        'fahmi': 5, 'khairul fahmi': 5}

# Ast. Manager ICS yang menjabat sepanjang arsip ini; arsip BAST 145 sendiri
# menyebutnya "Dias Natawan Gita - Ast Manager IT". Tanpa ini kotak
# "Mengetahui" mencetak jabatan tanpa nama di seluruh 251 dokumen.
MANAJER = 2

# "Dasar pemenuhan": kolom Tambahan memuat salah satu dari dua bentuk —
# nomor tiket MySSC, atau nomor memo. Formulir Docuflow menyediakan persis
# dua pilihan itu, jadi keduanya bisa dipulihkan tanpa menebak.
POLA_REQ = re.compile(r'\b(?:REQ|INC)[-\s]?\d{5,}\b', re.I)
POLA_MEMO = re.compile(r'\b(?:No\.?\s*)?(\d{1,4}/[A-Z]{3}\d{3,4}/\d{4}[-/][A-Z]\d)\b', re.I)

def tanpa_dasar(v, dipindah):
    """Buang dari teks bebas HANYA nomor yang benar-benar pindah ke NoTiket.
    Ket kadang hanya berisi nomor itu, dan memakainya apa adanya membuat nama
    barang tercetak 'REQ000008381715'. Tapi satu dokumen bisa memuat tiket DAN
    memo sekaligus sementara hanya satu yang jadi dasar pemenuhan; membuang
    keduanya menghapus yang kedua tanpa memberinya rumah."""
    if not v: return None
    s = v.replace(dipindah, ' ') if dipindah else v
    s = ' '.join(s.replace('No.', ' ').split()).strip(' -,;:/')
    return s or None

def dasar(*bagian):
    """(JenisTiket, NoTiket) dari teks bebas. Tiket menang atas memo: kalau
    keduanya ada, tiket yang menjadi dasar pemenuhan formalnya."""
    blob = ' '.join(x for x in bagian if x)
    m = POLA_REQ.search(blob)
    if m: return 'Tiket MySSC', m.group(0).upper().replace(' ', '').replace('-', '')
    m = POLA_MEMO.search(blob)
    if m: return 'Nomor Memo', m.group(1)
    return None, None

W("""-- =====================================================================
-- Impor arsip berita acara dari sistem lama (MariaDB `ba_2026`).
--
-- 251 dokumen: BAST 140, BAPB 96, BALP 15.
-- BAKP (8), BAPP (5) dan BA_Generic (1) SENGAJA tidak diimpor — dua yang
-- pertama jenisnya tidak dibuat, yang terakhir isinya kosong total di sumber
-- sehingga hanya akan mencetak berita acara resmi tanpa isi.
--
-- Nomor surat ditulis APA ADANYA dari arsip lama, termasuk kode unit dan
-- akhiran aslinya (KPB2000, KPB2200-S9). Docuflow menulis KPB3240/S0 sebagai
-- konstanta hanya saat MENERBITKAN nomor baru; arsip harus menunjukkan yang
-- benar-benar tercetak di kertas.
--
-- Counter TIDAK disentuh — sudah dimigrasikan terpisah.
--
-- Menghapus lalu menulis ulang arsipnya. Dijaga di awal: menolak kalau ada
-- SATU pun surat yang nomornya tidak ada di daftar arsip ini.
--
-- Penjaga sebelumnya hanya memeriksa awalan nomor ("BAST %", "BAPB %", ...)
-- dan itu tidak cukup — surat yang dibuat lewat aplikasi juga bernomor
-- "BAST ...". Pada 8 September 2026 penjagaan itu meloloskan penghapusan
-- BAST 146, dokumen yang baru dibuat operator, dan isinya tidak bisa
-- dikembalikan karena database memakai recovery model SIMPLE. Daftar nomor di
-- bawah adalah persis yang akan ditulis ulang; apa pun di luar itu membuat
-- skrip berhenti tanpa menghapus apa-apa.
-- =====================================================================

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @arsip TABLE (Nomor nvarchar(100) PRIMARY KEY);
__DAFTAR_NOMOR__

DECLARE @asing nvarchar(100) = (
    SELECT TOP 1 s.NomorSurat FROM Surat s
    WHERE NOT EXISTS (SELECT 1 FROM @arsip a WHERE a.Nomor = s.NomorSurat));

IF @asing IS NOT NULL
    THROW 50001, 'Ada surat di luar daftar arsip (mis. dibuat lewat aplikasi) — skrip dihentikan, tidak ada yang dihapus.', 1;

BEGIN TRANSACTION;

DELETE g FROM GambarPoin g JOIN PoinSurat p ON p.Id = g.PoinSuratId
    JOIN Surat s ON s.Id = p.SuratId WHERE s.NomorSurat IN (SELECT Nomor FROM @arsip);
DELETE b FROM BarangSurat b JOIN Surat s ON s.Id = b.SuratId
    WHERE s.NomorSurat IN (SELECT Nomor FROM @arsip);
DELETE p FROM PoinSurat p JOIN Surat s ON s.Id = p.SuratId
    WHERE s.NomorSurat IN (SELECT Nomor FROM @arsip);
DELETE FROM Surat WHERE NomorSurat IN (SELECT Nomor FROM @arsip);

DECLARE @id int;
""")

jml = {'surat': 0, 'barang': 0}
catatan_karang = []
dipakai = []          # nomor yang ditulis skrip ini — jadi daftar putih penjaga

def surat(jenis, nomor_str, tanggal, **kol):
    """Satu INSERT Surat + tangkap identity-nya."""
    jml['surat'] += 1
    dipakai.append(nomor_str)
    kolom = ['NomorSurat', 'JenisSuratId', 'Tanggal', 'CreatedAt', 'ManagerId']
    nilai = [q(nomor_str), str(jenis), q(tanggal), q(tanggal), str(MANAJER)]
    for k, v in kol.items():
        if v is not None:
            kolom.append(k)
            # Kolom angka ditulis tanpa kutip: konversi implisit dari nvarchar
            # memang jalan, tapi menulisnya sebagai angka membuat nilai yang
            # bukan angka gagal saat dibangun, bukan saat dijalankan.
            nilai.append(str(int(v)) if k in ('StaffId', 'ManagerId') else q(v))
    W(f"INSERT INTO Surat ({', '.join(kolom)})")
    W(f"VALUES ({', '.join(nilai)});")
    W("SET @id = SCOPE_IDENTITY();")

def barang(**kol):
    jml['barang'] += 1
    # NamaBarang, SerialNumber, MerkType, Pengguna NOT NULL -> '' bukan NULL.
    for w in ('NamaBarang', 'SerialNumber', 'MerkType', 'Pengguna'):
        kol.setdefault(w, '')
        if kol[w] is None: kol[w] = ''
    kolom = ['SuratId'] + list(kol.keys())
    nilai = ['@id'] + [str(int(v)) if k == 'Jumlah' else q(v) for k, v in kol.items()]
    W(f"INSERT INTO BarangSurat ({', '.join(kolom)}) VALUES ({', '.join(nilai)});")

# ---------------------------------------------------------------- BAST
LABEL_SN = [
    ('Serial_Number',         'Perangkat'),
    ('Serial_Number_NB_PC',   'Notebook / PC'),
    ('Serial_Number_Monitor', 'Monitor'),
    ('Serial_Number_Adaptor', 'Adaptor'),
    ('SN_Baterai',            'Baterai'),
]
TGL_CADANGAN = '2026-03-17'   # batas bawah sejati: nomor 46 bertanggal ini

for r in sorted(t['BAST'], key=lambda x: int(x['No_BAST'])):
    no = int(r['No_BAST'])
    pemegang = rapi(r.get('Nama'))
    jenis = 2 if (pemegang or '').lower().startswith('rekaman cctv') else 1
    nom, karang = nomor('BAST', no, r.get('KBO'))
    if karang: catatan_karang.append(f'BAST {no:03d}: kode unit tidak tercatat')

    tgl = r.get('Tgl_Serah_Terima')
    nota = []
    if not tgl:
        tgl = TGL_CADANGAN
        nota.append('Tanggal serah terima tidak tercatat pada arsip lama; dipakai tanggal dokumen sebelumnya.')
    if karang:
        nota.append('Kode unit pada nomor tidak tercatat pada arsip lama.')

    # Blok penanggung jawab adalah blok yang tercetak di atas tabel barang, dan
    # orang itu juga yang menandatangani. Satu-satunya blok yang terisi di
    # seluruh 140 baris.
    pj, pj_jab = pemegang, rapi(r.get('Jabatan'))
    pj_fungsi, pj_nopek = rapi(r.get('Fungsi_Direktorat')), rapi(r.get('Nopek'))

    # Blok organik tidak pernah tercetak pada dokumen lamanya. Diturunkan ke
    # catatan: tidak boleh mengisi kotak tanda tangan, tidak boleh hilang.
    org = [x for x in (rapi(r.get('Nama_Organik')), rapi(r.get('Jabatan_Organik')),
                       rapi(r.get('Fungsi_Direktorat_Organik')),
                       rapi(r.get('Nopek_Organik'))) if x]
    if org:
        nota.append('Organik pada arsip lama: ' + ', '.join(org))

    ket, tambahan = teks(r.get('Ket')), teks(r.get('Tambahan'))
    jenis_tiket, no_tiket = dasar(ket, tambahan, rapi(r.get('Fungsi_Direktorat_Organik')))
    # Nomor yang sudah pindah ke NoTiket dibuang dari teks bebas: kalau tidak,
    # dokumen mencetaknya dua kali (baris Catatan dan catatan isi).
    ket_bersih, tambahan_bersih = tanpa_dasar(ket, no_tiket), tanpa_dasar(tambahan, no_tiket)
    if r.get('Hostname'): nota.append('Hostname: ' + rapi(r['Hostname']))

    surat(jenis, nom, tgl,
          # Tujuan tidak diisi: dokumen BAST lama tidak punya baris itu, dan
          # menyalin nama penanggung jawab ke sana membuat kop surat menyebut
          # orang yang sama dua kali.
          NamaPenanggungJawab=pj, Jabatan=pj_jab,
          FungsiDirektorat=pj_fungsi, NoPekerja=pj_nopek,
          # Kotak "Yang Menerima" dan "Yang Menyerahkan" memang kosong pada
          # dokumen lamanya, jadi kolomnya tidak diisi sama sekali.
          JenisTiket=jenis_tiket, NoTiket=no_tiket,
          Deskripsi=gabung(ket_bersih, tambahan_bersih, *nota))

    # Brand sering sudah menjadi kata pertama Type ("HP" + "HP PROBOOK 430 G8").
    brand, tipe = rapi(r.get('Brand')), rapi(r.get('Type'))
    if tipe and brand and tipe.lower().startswith(brand.lower()):
        merk = tipe
    else:
        merk = ' '.join(x for x in (brand, tipe) if x) or ''
    merk_monitor = rapi(r.get('Type_Monitor')) or ''

    if jenis == 2:
        # CCTV: kolomnya Nama/Tanggal/Jam/Rekaman/Area. Judul dokumen memuat
        # rentang tanggalnya; awalan "Rekaman CCTV" dibuang supaya kolom
        # Tanggal berisi tanggal, bukan mengulang nama barang.
        rentang = re.sub(r'^\s*rekaman\s+cctv\s*', '', pemegang or '', flags=re.I).strip()
        barang(NamaBarang='Rekaman CCTV', Tanggal=rentang or None,
               Area=ket_bersih, Rekaman=tambahan_bersih)
        continue

    baris = []
    for kol, label in LABEL_SN:
        for sn in pecah(r.get(kol)):
            baris.append((label, sn))
    if merk_monitor and not any(l == 'Monitor' for l, _ in baris):
        baris.append(('Monitor', ''))          # Type_Monitor ada tapi serialnya tidak

    # Merk hanya menempel pada perangkat yang memilikinya: monitor memakai
    # Type_Monitor, adaptor dan baterai tidak punya merk sendiri di sumber.
    def merk_untuk(label):
        if label == 'Monitor': return merk_monitor
        if label in ('Perangkat', 'Notebook / PC'): return merk
        return ''

    if baris:
        for i, (label, sn) in enumerate(baris):
            barang(NamaBarang=(ket_bersih if i == 0 and ket_bersih else label),
                   SerialNumber=sn, MerkType=merk_untuk(label),
                   Pengguna=pemegang or '')
    else:
        # Tanpa satu pun serial, tabel barang tetap butuh satu baris —
        # kalau tidak, dokumennya mencetak "Tidak ada data barang".
        nama = ket_bersih or tipe or 'Perangkat'
        barang(NamaBarang=nama,
               MerkType=('' if nama == merk else merk),
               Pengguna=pemegang or '')

# ---------------------------------------------------------------- BAPB
SN_BAPB = ['SN_NB_PC', 'SN_NB_PC_2', 'SN_NB_PC_3', 'SN_Monitor', 'SN_Adaptor', 'SN_HT', 'ID_HT']
for r in sorted(t['BAPB'], key=lambda x: int(x['NO_BAPB'])):
    no = int(r['NO_BAPB'])
    jenis = 5 if 'berca' in (r.get('Kepada') or '').lower() else 7
    nom, _ = nomor('BAPB', no, r.get('KBO'))

    # Sumber memakai dua pasang kolom untuk peran yang sama; formulirnya
    # berganti kolom di tengah tahun (BAPB 001-062 memakai Dari/Kepada,
    # 064 dan seterusnya Diserahkan/Diterima), jadi keduanya harus dibaca.
    penyerah = rapi(r.get('Diserahkan')) or rapi(r.get('Dari'))
    penerima = rapi(r.get('Diterima')) or rapi(r.get('Kepada'))

    if jenis == 5:
        lawan, staf = penerima, STAF.get((penyerah or '').lower())
        pihak_lawan = penerima          # vendor menerima
    else:
        lawan, staf = penyerah, STAF.get((penerima or '').lower())
        pihak_lawan = penyerah          # user menyerahkan

    nama_brg = [rapi(r.get(f'Nama_Barang_{i}')) for i in range(1, 6)]
    nama_brg = [x for x in nama_brg if x and x != '-']

    nota = []
    if r.get('Hostname'): nota.append('Hostname: ' + rapi(r['Hostname']))

    surat(jenis, nom, r.get('Tgl_BA'),
          Tujuan=lawan,
          YangMenerima=pihak_lawan,
          StaffId=staf,
          Deskripsi=gabung(teks(r.get('Keterangan')), *nota))

    serial = [sn for kol in SN_BAPB for sn in pecah(r.get(kol))]
    merk = [rapi(r.get(k)) for k in ('Merk_1', 'Merk_2', 'Merk_3')]
    cadangan_merk = rapi(r.get('Merk_Type_Brand')) or ''

    # Satu baris per BARANG, bukan per serial: kolom JUMLAH pada dokumen
    # menghitung unit, dan sumber tidak pernah mencatat Jumlah_Unit (0/96).
    # Serial dipasangkan menurut urutan, urutan yang sama dengan nama barang
    # di sumbernya.
    # ponytail: pasangan serial<->barang murni posisional; kalau ternyata
    # sering meleset, cocokkan lewat kata kunci kolom (SN_Monitor -> "Monitor").
    n = max(len(nama_brg), len(serial), 1)
    for i in range(n):
        barang(Jumlah=1, Satuan='pcs',
               SerialNumber=(serial[i] if i < len(serial) else ''),
               MerkType=((merk[i] if i < 3 and merk[i] else '') or (cadangan_merk if i == 0 else '')),
               Keterangan=(nama_brg[i] if i < len(nama_brg) else None))

# ---------------------------------------------------------------- BALP
for r in sorted(t['BALP'], key=lambda x: int(x['NO_BALP'])):
    nom, _ = nomor('BALP', int(r['NO_BALP']), r.get('KBO'))
    # Sumber hanya punya SATU tanggal. Tgl_BA arsip lama adalah tanggal pada
    # surat vendor, dan itu juga satu-satunya tanggal terbit yang tercatat.
    surat(8, nom, r.get('Tgl_BA'),
          Tujuan=rapi(r.get('Dari')) or rapi(r.get('Kepada')),
          Deskripsi=teks(r.get('Keterangan')),
          TanggalBalp=r.get('Tgl_BA'))

W("""
COMMIT;

SELECT j.Kode, j.NamaJenis, COUNT(*) AS Jml
FROM Surat s JOIN JenisSurat j ON j.Id = s.JenisSuratId
GROUP BY j.Kode, j.NamaJenis ORDER BY j.Kode, j.NamaJenis;

SELECT (SELECT COUNT(*) FROM Surat) AS Surat, (SELECT COUNT(*) FROM BarangSurat) AS Barang;
SELECT COUNT(*) AS NomorPakaiTitikNo FROM Surat WHERE NomorSurat LIKE '%No.%';
SELECT COUNT(*) AS TanpaManajer FROM Surat WHERE ManagerId IS NULL;
SELECT COUNT(*) AS BapbTanpaPenyerah FROM Surat WHERE JenisSuratId IN (5,7) AND YangMenerima IS NULL;
SELECT COUNT(*) AS BastPakaiJabatanOrangLain FROM Surat s JOIN JenisSurat j ON j.Id = s.JenisSuratId
WHERE j.Kode = 'BAST' AND s.NamaPenanggungJawab = s.YangMenerima
  AND ISNULL(s.Jabatan,'') <> ISNULL(s.JabatanYangMenerima,'');
""")

nomor_arsip = sorted(dipakai)
baris = []
for i in range(0, len(nomor_arsip), 20):
    potong = ', '.join('(' + q(x) + ')' for x in nomor_arsip[i:i + 20])
    baris.append('INSERT INTO @arsip (Nomor) VALUES ' + potong + ';')

teks = '\n'.join(out).replace('__DAFTAR_NOMOR__', '\n'.join(baris))
assert '__DAFTAR_NOMOR__' not in teks
open(sys.argv[2], 'w', encoding='utf-8').write(teks)
print(f"Surat  : {jml['surat']}", file=sys.stderr)
print(f"Barang : {jml['barang']}", file=sys.stderr)
print(f"nomor dengan kode unit dikarang: {len(catatan_karang)} -> {catatan_karang}", file=sys.stderr)
