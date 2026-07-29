#!/usr/bin/env python3
"""Raspa a tábua oficial CBO2002-CBO94-CIUO88 do MTE, família por família.

A varredura pela paginação global se mostrou incompleta (o dataScroller repete
páginas e a varredura para cedo). Aqui, cada família de 4 dígitos é consultada
diretamente, e a paginação é percorrida DENTRO da família, o que torna a
cobertura verificável: toda linha devolvida tem de pertencer à família pedida.

O índice de famílias vem de um espelho público da estrutura da CBO; os DADOS
de correspondência vêm sempre da fonte oficial (mtecbo.gov.br).
"""
import csv, html, re, sys, time, urllib.parse, urllib.request, http.cookiejar

BASE = "http://www.mtecbo.gov.br"
PATH = "/cbosite/pages/tabua/FiltroConversao_CBO2002_CBO94_CIUO88.jsf"
UA = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/120 Safari/537.36"
cj = http.cookiejar.CookieJar()
op = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))
op.addheaders = [("User-Agent", UA), ("Referer", BASE + PATH)]


def campo(s, nome, last=False):
    m = re.findall(r'name="%s"[^>]*value="([^"]*)"' % re.escape(nome), s)
    return (m[-1] if last else m[0]) if m else ""


def linhas(s):
    out = []
    for tr in re.findall(r"<tr[^>]*>(.*?)</tr>", s, re.S):
        c = [re.sub(r"\s+", " ", html.unescape(re.sub(r"<[^>]+>", "", x))).strip()
             for x in re.findall(r"<t[dh][^>]*>(.*?)</t[dh]>", tr, re.S)]
        if len(c) >= 4 and re.fullmatch(r"\d{4}-\d{2}", c[0]):
            out.append(c[:4])
    return out


def abre():
    with op.open(BASE + PATH, timeout=60) as r:
        return r.read().decode("latin-1")


def envia(act, dados):
    req = urllib.request.Request(
        BASE + act, data=urllib.parse.urlencode(dados).encode("latin-1"), method="POST")
    req.add_header("Content-Type", "application/x-www-form-urlencoded")
    with op.open(req, timeout=120) as r:
        return r.read().decode("latin-1")


def familia(cod, tentativas=3):
    """Todas as linhas da família `cod`, percorrendo a paginação interna."""
    for t in range(tentativas):
        try:
            pg = abre()
            act = re.search(r'action="([^"]*FiltroConversao_CBO2002[^"]*)"', pg).group(1)
            pg = envia(act, {
                "formSite038": "formSite038",
                "DTPINFRA_TOKEN": campo(pg, "DTPINFRA_TOKEN", last=True),
                "formSite038:j_idt83": cod,
                "formSite038:j_idt85": "Consultar",
                "javax.faces.ViewState": campo(pg, "javax.faces.ViewState")})
            vistos, pag = {}, 0
            while True:
                novas = 0
                for r in linhas(pg):
                    if r[0] not in vistos:
                        vistos[r[0]] = r; novas += 1
                pag += 1
                if novas == 0 or pag > 40:
                    break
                pg = envia(act, {
                    "formSite038": "formSite038",
                    "DTPINFRA_TOKEN": campo(pg, "DTPINFRA_TOKEN", last=True),
                    "formSite038:j_idt83": cod,
                    "javax.faces.ViewState": campo(pg, "javax.faces.ViewState"),
                    "formSite038:scroller": "next",
                    "formSite038:scrollernext": "formSite038:scrollernext"})
                time.sleep(0.15)
            return list(vistos.values())
        except Exception as e:
            if t == tentativas - 1:
                print(f"  ! {cod} falhou: {e}", file=sys.stderr)
                return None
            time.sleep(1.5)


fams = [l.strip() for l in open("familias.txt") if l.strip()]
todas, vazias, falhas, fora = [], [], [], []
for i, f in enumerate(fams, 1):
    r = familia(f)
    if r is None:
        falhas.append(f)
    elif not r:
        vazias.append(f)
    else:
        for x in r:
            if x[0][:4] != f:
                fora.append((f, x[0]))
        todas.extend(r)
    if i % 50 == 0:
        print(f"  {i}/{len(fams)} famílias | {len(todas)} pares | "
              f"{len(vazias)} sem correspondência | {len(falhas)} falhas",
              file=sys.stderr, flush=True)
    time.sleep(0.2)

print(f"\npares: {len(todas)} | códigos únicos: {len({x[0] for x in todas})}")
print(f"famílias consultadas: {len(fams)} | com correspondência: "
      f"{len({x[0][:4] for x in todas})} | sem: {len(vazias)} | falhas: {len(falhas)}")

# ---------------------------------------------------------------------------
# ABORTAR ANTES DE GRAVAR.
#
# A versão anterior escrevia tabua_oficial.csv e só DEPOIS imprimia as falhas.
# Uma rodada em que o mtecbo.gov.br estivesse instável sobrescrevia o cache bom
# por um truncado que parece bom — e o `stopifnot(nrow(tb) > 1000)` do
# 02_gera_cbo.R deixa passar perda de até ~28%. O arquivo gravado é a única
# fonte da perna CBO do pacote; gravá-lo pela metade é pior que não gravar.
#
# `fora` são linhas de uma família que NÃO foi pedida (o MyFaces devolve
# vizinhas): entram no CSV sem procedência e precisam de decisão humana.
# ---------------------------------------------------------------------------
if falhas or fora:
    print("\nABORTADO SEM GRAVAR — o cache atual foi preservado.", file=sys.stderr)
    if falhas:
        print(f"  {len(falhas)} família(s) sem resposta após 3 tentativas: "
              f"{falhas[:10]}", file=sys.stderr)
    if fora:
        print(f"  {len(fora)} linha(s) fora da família pedida: {fora[:5]}",
              file=sys.stderr)
    print("  Repita a raspagem. Se a divergência for real e deliberada, "
          "atualize inst/extdata/PROVENIENCIA.yml e regere os dados.",
          file=sys.stderr)
    sys.exit(1)

todas.sort(key=lambda x: x[0])
with open("tabua_oficial.csv", "w", newline="", encoding="utf-8") as fh:
    w = csv.writer(fh)
    w.writerow(["cbo2002", "titulo_cbo2002", "cbo94", "ciuo88"])
    w.writerows(todas)
print("tabua_oficial.csv gravado.")
print("Atualize o sha256 em inst/extdata/PROVENIENCIA.yml e regere os dados.")
