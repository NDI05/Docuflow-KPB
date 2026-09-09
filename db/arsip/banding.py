"""Pasangkan tiap baris arsip lama dengan baris hasil impor di DB baru, lalu
tentukan untuk SETIAP kolom sumber apakah nilainya benar-benar sampai.

Status tidak dideklarasikan, tapi diukur: nilai sumber dicari di seluruh nilai
baris baru (termasuk baris barang dan nama staff/manajer hasil join). Kalau
cocok persis -> "sampai". Kalau mirip (ejaan atau singkatan berbeda, mis.
"Hendy A." vs "Hendy Agustama") -> "mirip", karena itu perlu mata manusia.
Selain itu -> "hilang".
"""
import json, re, os, sys, difflib, collections

SC = os.path.dirname(os.path.abspath(__file__))

raw = open(f"{SC}/baru.json", encoding='utf-8-sig').read()
i = raw.find('[')
baru = json.loads(''.join(l.rstrip('\n') for l in raw[i:].split('\n')
                          if not re.match(r'^-{5,}$', l.strip())))
lama = json.load(open(f"{SC}/ba2026.json", encoding='utf-8'))

def bersih(v):
    if v is None: return None
    s = str(v).replace('\r\n', '\n').replace('\r', '\n').strip()
    return s or None

def norm(s):
    return re.sub(r'\s+', ' ', str(s or '')).strip().lower()

# Kolom yang kosong di SELURUH tabelnya bukan kelalaian pemetaan — ditandai
# terpisah supaya tidak terbaca sebagai data yang hilang.
kosong_total = {t: {k for k in rows[0] if not any((r.get(k) or '').strip() for r in rows)}
                for t, rows in lama.items()}

SASARAN = {
 'BAST': {'No_BAST':'NomorSurat','KBO':'NomorSurat (ekor)','Tgl_Serah_Terima':'Tanggal + CreatedAt',
  'Nama':'NamaPenanggungJawab','Jabatan':'Jabatan',
  'Fungsi_Direktorat':'FungsiDirektorat','Nopek':'NoPekerja',
  'Nama_Organik':'Deskripsi (catatan organik)','Jabatan_Organik':'Deskripsi (catatan organik)','Fungsi_Direktorat_Organik':'Deskripsi (catatan organik)',
  'Nopek_Organik':'Deskripsi (catatan organik)','Ket':'BarangSurat.NamaBarang + Deskripsi',
  'Tambahan':'NoTiket / JenisTiket + Deskripsi','Hostname':'Deskripsi (catatan)',
  'Serial_Number':'BarangSurat.SerialNumber — Perangkat','Serial_Number_NB_PC':'BarangSurat.SerialNumber — Notebook / PC',
  'Serial_Number_Monitor':'BarangSurat.SerialNumber — Monitor','Serial_Number_Adaptor':'BarangSurat.SerialNumber — Adaptor',
  'SN_Baterai':'BarangSurat.SerialNumber — Baterai','Type':'BarangSurat.MerkType','Brand':'BarangSurat.MerkType',
  'Type_Monitor':'BarangSurat.MerkType — Monitor','IMEI_1':'kosong di seluruh arsip','IMEI_2':'kosong di seluruh arsip',
  'SN_Safe_Protector_2_0':'kosong di seluruh arsip','SN_Safe_Protector_3_0':'kosong di seluruh arsip'},
 'BAPB': {'NO_BAPB':'NomorSurat','KBO':'NomorSurat (ekor)','Tgl_BA':'Tanggal + CreatedAt',
  'Dari':'Tujuan + YangMenerima','Diserahkan':'Tujuan + YangMenerima','Kepada':'StaffId / Tujuan (jenis Rusak)',
  'Diterima':'StaffId','Hostname':'Deskripsi (catatan)','Keterangan':'Deskripsi',
  'Nama_Barang_1':'BarangSurat.Keterangan','Nama_Barang_2':'BarangSurat.Keterangan',
  'Nama_Barang_3':'BarangSurat.Keterangan','Nama_Barang_4':'BarangSurat.Keterangan',
  'Nama_Barang_5':'BarangSurat.Keterangan','Merk_1':'BarangSurat.MerkType','Merk_2':'BarangSurat.MerkType',
  'Merk_3':'BarangSurat.MerkType','Merk_Type_Brand':'BarangSurat.MerkType (cadangan)',
  'SN_NB_PC':'BarangSurat.SerialNumber','SN_NB_PC_2':'BarangSurat.SerialNumber','SN_NB_PC_3':'BarangSurat.SerialNumber',
  'SN_Monitor':'BarangSurat.SerialNumber','SN_Adaptor':'BarangSurat.SerialNumber','SN_HT':'BarangSurat.SerialNumber',
  'ID_HT':'BarangSurat.SerialNumber','Jumlah_Unit':'kosong di seluruh arsip','SN_HP':'kosong di seluruh arsip',
  'SN_Baterai':'kosong di seluruh arsip'},
 'BALP': {'NO_BALP':'NomorSurat','KBO':'NomorSurat (ekor)','Tgl_BA':'Tanggal + TanggalBalp',
  'Keterangan':'Deskripsi','Dari':'Tujuan','Kepada':'Tujuan (cadangan)'},
 'BA_Generic': {'No_BA':'tidak diimpor','KBO':'tidak diimpor','Tanggal_BA':'tidak diimpor','Tentang':'tidak diimpor'},
}

idx = {}
for b in baru:
    m = re.match(r'^([A-Z]+) (\d+)/', b['NomorSurat'])
    idx[(m.group(1), int(m.group(2)))] = b

pasang, lewat = [], []
for tabel, kode, kunci in (('BAST','BAST','No_BAST'), ('BAPB','BAPB','NO_BAPB'),
                           ('BALP','BALP','NO_BALP'), ('BA_Generic','BA','No_BA')):
    for r in lama[tabel]:
        n = int(r[kunci])
        b = idx.get((kode, n))
        src = {k: bersih(v) for k, v in r.items() if bersih(v)}
        if b is None:
            lewat.append({'tabel': tabel, 'no': n, 'kolom': [{'k': k, 'v': v} for k, v in src.items()]})
            continue

        barang = [{k: v for k, v in x.items() if v not in (None, '')} for x in (b.get('Barang') or [])]
        baru_kol = {k: v for k, v in b.items() if k not in ('Barang', 'Id') and v not in (None, '')}

        nilai = [norm(v) for v in baru_kol.values()] + [norm(v) for x in barang for v in x.values()]
        nilai = [x for x in nilai if x]
        blob = ' | '.join(nilai)

        kolom = []
        for k, v in src.items():
            nv = norm(v)
            keping = [norm(x) for x in re.split(r'[\n\r\t,;&]+|\s+dan\s+', str(v)) if norm(x)]
            kata = [w for w in re.findall(r'[\w./-]+', nv) if len(w) > 1]
            if (nv in blob
                    or (len(keping) > 1 and all(x in blob for x in keping))
                    or (kata and all(w in blob for w in kata))):
                s = 'sampai'
            else:
                rasio = max((difflib.SequenceMatcher(None, nv, x).ratio() for x in nilai), default=0)
                s = 'mirip' if rasio >= 0.72 else 'hilang'
            kolom.append({'k': k, 'v': v, 't': SASARAN.get(tabel, {}).get(k, '?'), 's': s})
        for k in lama[tabel][0]:
            if k not in src:
                kolom.append({'k': k, 'v': None, 't': SASARAN.get(tabel, {}).get(k, '?'),
                              's': 'kosongSemua' if k in kosong_total[tabel] else 'kosong'})

        pasang.append({
            'nomor': b['NomorSurat'], 'kode': kode, 'jenis': b['NamaJenis'],
            'tabelLama': tabel, 'noLama': n, 'baru': baru_kol, 'barang': barang, 'kolom': kolom,
            'gagal': sum(1 for c in kolom if c['s'] == 'hilang'),
            'mirip': sum(1 for c in kolom if c['s'] == 'mirip'),
        })

for tabel, kunci in (('BAKP','NO_BAKP'), ('BAPP','No_BAST')):
    for r in lama[tabel]:
        lewat.append({'tabel': tabel, 'no': int(r[kunci]),
                      'kolom': [{'k': k, 'v': bersih(v)} for k, v in r.items() if bersih(v)]})

pasang.sort(key=lambda x: (x['kode'], x['noLama']))
lewat.sort(key=lambda x: (x['tabel'], x['no']))

d = {'pasang': pasang, 'lewat': lewat, 'ringkas': {
    'dokumen': len(pasang),
    'barang': sum(len(p['barang']) for p in pasang),
    'tidakDiimpor': len(lewat),
    'dokumenAdaGagal': sum(1 for p in pasang if p['gagal']),
    'kolomGagal': sum(p['gagal'] for p in pasang),
    'kolomMirip': sum(p['mirip'] for p in pasang),
    'kolomSampai': sum(sum(1 for c in p['kolom'] if c['s'] == 'sampai') for p in pasang),
}}
json.dump(d, open(f"{SC}/artefak-data.json", 'w', encoding='utf-8'),
          ensure_ascii=False, separators=(',', ':'))

print(json.dumps(d['ringkas'], indent=1))
print('ukuran:', os.path.getsize(f"{SC}/artefak-data.json") // 1024, 'KB')
c = collections.Counter((p['tabelLama'], x['k']) for p in pasang for x in p['kolom'] if x['s'] == 'hilang')
print('\n-- kolom yang hilang --')
for (t, k), n in c.most_common():
    print(f'  {n:4}  {t}.{k}')
