#!/usr/bin/env python3
"""Sonda a tabua do MTE para familias especificas, com a MESMA logica do raspador do pacote."""
import html, re, sys, time, urllib.parse, urllib.request, http.cookiejar

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


def familia(cod, tentativas=2):
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
            # guarda um trecho da resposta para diagnostico de mensagem de erro
            msg = re.findall(r'class="[^"]*(?:erro|mensagem|message)[^"]*"[^>]*>(.*?)<',
                             pg, re.S | re.I)
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
            return list(vistos.values()), [m.strip()[:120] for m in msg if m.strip()]
        except Exception as e:
            if t == tentativas - 1:
                return None, [f"EXC {e}"]
            time.sleep(1.5)


for f in sys.argv[1:]:
    r, msg = familia(f)
    if r is None:
        print(f"{f}: FALHA  {msg}")
    else:
        print(f"{f}: {len(r)} linha(s)  {msg[:2]}")
        for x in r[:6]:
            print("    ", x)
    time.sleep(0.3)
