import re, csv, io, sys, os
q = sys.argv[1]                     # ex: 012025
ALVO = ["UPA","V1008","V1014","V2003","V20082",
        "UF","V1028","V2007","V2009","VD3004","V4010","V4012","VD4008","VD4009",
        "V4016","V40161","V40162","V40163","V4018","VD4016","VD4019","VD4001","VD4002"]
campos = {}
with io.open("input_PNADC_trimestral.txt", encoding="latin1") as f:
    for ln in f:
        m = re.match(r"\s*@(\d+)\s+(\w+)\s+\$?(\d+)\.", ln.strip())
        if m: campos[m.group(2)] = (int(m.group(1))-1, int(m.group(1))-1+int(m.group(3)))
cols = [(v, campos[v][0], campos[v][1]) for v in ALVO]
n = 0
with io.open(f"PNADC_{q}.txt", encoding="latin1") as f, \
     io.open(f"cols_{q}.csv", "w", newline="", encoding="utf-8") as out:
    w = csv.writer(out); w.writerow(["tri"]+[c[0] for c in cols])
    for ln in f:
        w.writerow([q]+[ln[a:b].strip() for _,a,b in cols]); n += 1
print(f"{q}: {n} linhas", flush=True)
