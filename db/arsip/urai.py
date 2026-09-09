"""Urai dump phpMyAdmin/MariaDB jadi dict Python.

Ditulis sebagai pemindai karakter, bukan regex, karena nilai di dump ini
memuat \r\n, tab, dan tanda kutip yang di-escape backslash — regex naif akan
memotong record di tengah.
"""
import json, re, sys

ESCAPE = {'0':'\0','b':'\b','n':'\n','r':'\r','t':'\t','Z':'\x1a',"'":"'",'"':'"','\\':'\\'}

def baca_string(s, i):
    kutip = s[i]; i += 1; buf = []
    while i < len(s):
        c = s[i]
        if c == '\\' and i + 1 < len(s):
            buf.append(ESCAPE.get(s[i+1], s[i+1])); i += 2
        elif c == kutip:
            if i + 1 < len(s) and s[i+1] == kutip:   # '' di dalam string
                buf.append(kutip); i += 2
            else:
                return ''.join(buf), i + 1
        else:
            buf.append(c); i += 1
    raise ValueError('string tidak tertutup')

def baca_tuple(s, i):
    assert s[i] == '('; i += 1; nilai = []
    while True:
        while s[i] in ' \t\r\n': i += 1
        if s[i] in "'\"":
            v, i = baca_string(s, i); nilai.append(v)
        else:
            j = i
            while s[j] not in ',)': j += 1
            tok = s[i:j].strip(); i = j
            nilai.append(None if tok.upper() == 'NULL' else tok)
        while s[i] in ' \t\r\n': i += 1
        if s[i] == ',': i += 1; continue
        if s[i] == ')': return nilai, i + 1

def urai(path):
    s = open(path, encoding='utf-8', errors='replace').read()
    tabel = {}
    for m in re.finditer(r'INSERT INTO `(\w+)` \(([^)]*)\) VALUES', s):
        nama = m.group(1)
        kol = [c.strip('` ') for c in m.group(2).split(',')]
        i = m.end()
        rows = []
        while True:
            while i < len(s) and s[i] in ' \t\r\n': i += 1
            if i >= len(s) or s[i] != '(': break
            v, i = baca_tuple(s, i)
            assert len(v) == len(kol), f'{nama}: {len(v)} nilai vs {len(kol)} kolom'
            rows.append(dict(zip(kol, v)))
            while i < len(s) and s[i] in ' \t\r\n': i += 1
            if i < len(s) and s[i] == ',': i += 1
            else: break
        tabel[nama] = rows
    return tabel

if __name__ == '__main__':
    t = urai(sys.argv[1])
    for n, r in t.items():
        print(f'{n:<12} {len(r):>4} baris', file=sys.stderr)
    json.dump(t, open(sys.argv[2], 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
