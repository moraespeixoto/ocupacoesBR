# ============================================================================
# fig_rede_crosswalks.R — o mapa das traduções que o pacote faz, e das que não
# ----------------------------------------------------------------------------
# Nós  = classificações e medidas.
# Setas = correspondências, com a FONTE de cada uma.
#
# O desenho é traçado à mão, e não por layout automático, porque a estrutura é
# em camadas — origens, hubs, medidas — e um force-directed a embaralharia.
#
# Rodar: Rscript data-raw/fig_rede_crosswalks.R
# ============================================================================

SAIDA <- "man/figures/rede_crosswalks.png"
dir.create(dirname(SAIDA), showWarnings = FALSE, recursive = TRUE)

# ---- paleta ---------------------------------------------------------------
COR <- list(
  origem   = "#1B4F72", origem_bg   = "#D6EAF8",
  hub      = "#7D6608", hub_bg      = "#FCF3CF",
  medida   = "#4A235A", medida_bg   = "#E8DAEF",
  autoral  = "#B03A2E", autoral_bg  = "#FADBD8",
  estimada = "#1E8449", estimada_bg = "#D5F5E3",
  existe   = "#34495E", proposta    = "#1E8449", falta = "#C0392B",
  texto    = "#212F3D", fraco       = "#7F8C8D",
  # `fraco` continua servindo a subtitulo e legenda, onde o fundo e limpo.
  # Rotulo de seta precisa de outro tom: ele cai sobre linhas e as vezes
  # sobre outra seta, e a 30% do tamanho nativo o #7F8C8D some.
  rotulo   = "#48606E")

# ---- nós: x, y, rótulo, sublinha, tipo ------------------------------------
no <- function(id, x, y, rot, sub, tipo)
  data.frame(id, x, y, rot, sub, tipo, stringsAsFactors = FALSE)

N <- rbind(
  # origens — por onde o dado entra
  no("tse",   1.10, 5.05, "TSE",       "CD_OCUPACAO · 275", "origem"),
  no("cbo02", 1.10, 3.55, "CBO-2002",  "RAIS · CAGED · eSocial", "origem"),
  no("cbo94", 1.10, 2.25, "CBO-94",    "RAIS até 2002", "origem"),
  no("cod",   1.10, 0.95, "COD",       "PNAD Contínua · Censo · 434", "origem"),
  # hubs — as classificações internacionais
  no("i88",   3.35, 3.90, "ISCO-88",   "537 códigos", "hub"),
  no("i08",   3.35, 1.70, "ISCO-08",   "590 códigos", "hub"),
  # medidas ancoradas na ISCO-88
  no("isei88",  5.65, 5.15, "ISEI-88",    "status socioeconômico", "medida"),
  no("prest88", 5.65, 4.30, "Prestígio",  "Treiman 1977", "medida"),
  no("egp",     5.65, 3.45, "EGP",        "11 · 7 · 5 · 3 classes", "medida"),
  # medidas ancoradas na ISCO-08
  no("isei08",  5.65, 2.30, "ISEI-08",    "status, âncora 2008", "medida"),
  no("prest08", 5.65, 1.50, "Prestígio-08", "Treiman, âncora 2008", "medida"),
  # a única medida que o pacote ESTIMA em vez de importar
  no("iseibr",  5.65, 0.70, "ISEI-BR",    "PNAD Contínua 2025", "estimada"),
  # esquema próprio — não passa pela ISCO
  no("classe",  3.35, 5.85, "Classe · Estrato", "esquema do pacote · 10 cat.", "autoral")
)
rownames(N) <- N$id

# ---- arestas: de, para, situação, rótulo, curvatura ------------------------
# ajx/ajy deslocam o rotulo daquela aresta. Existem porque o deslocamento
# perpendicular automatico poe os rotulos das duas setas ISCO-88 <-> ISCO-08
# no mesmo lugar: uma e reta e a outra e um arco, e ambos caem a direita.
ar <- function(de, para, sit, rot = "", curva = 0, ajx = 0, ajy = 0)
  data.frame(de, para, sit, rot, curva, ajx, ajy, stringsAsFactors = FALSE)

A <- rbind(
  ar("tse",   "classe", "existe",   "mapeamento autoral", 0, ajx = -0.22),
  ar("tse",   "i88",    "existe",   "autoral · 2 a 4 díg.", 0),
  ar("cbo02", "i88",    "existe",   "tábua MTE · 49,8%", 0),
  ar("cbo02", "cbo94",  "existe",   "tábua MTE", 0),
  ar("cbo94", "i88",    "existe",   "tábua MTE", 0),
  ar("i88",   "i08",    "existe",   "OIT · 1/3 ambíguo", 0, ajx = -0.62),
  ar("i88",   "isei88",  "existe",  "ISMF", 0),
  ar("i88",   "prest88", "existe",  "ISMF", 0),
  ar("i88",   "egp",     "existe",  "ISMF", 0),
  ar("i08",   "isei08",  "existe",  "ISMF", 0),
  ar("i08",   "prest08", "existe",  "ISMF", 0),
  ar("i08",   "iseibr",  "estimada", "estimado aqui, na PNAD", 0, ajx = -0.30, ajy = -0.20),
  ar("cod",   "i08",     "existe",   "IBGE · 428 de 434 idênticos", 0, ajx = -0.30, ajy = 0.16),
  ar("i08",   "i88",     "existe",   "ISMF · volta fecha em 69%", -0.42, ajx = 0.72)
)

# ---- desenho ---------------------------------------------------------------
# O `res` governa a razao entre o texto (em pontos) e o desenho (em
# coordenadas): subi-lo aumenta a tipografia em relacao as caixas, sem mexer
# no layout. A figura e exibida no site com cerca de 620px de largura, menos
# de um terco do nativo, e era ai que os rotulos sumiam.
png(SAIDA, width = 2100, height = 1350, res = 250)
op <- par(mar = c(0.4, 0.4, 2.6, 0.4), family = "sans")
plot(NA, xlim = c(0.35, 6.35), ylim = c(0.30, 6.45), axes = FALSE,
     xlab = "", ylab = "", asp = 0.72)

# As caixas acompanham a tipografia: com o texto no tamanho que se le a
# 620px, a sublinha de "CD_OCUPACAO - 275" transbordava a caixa do TSE.
LARG <- 1.18; ALT <- 0.40

# Rotulo de seta cai sobre linhas, e em diagonal chega a cruzar outra seta.
# Desenhar o texto oito vezes em branco, deslocado, antes de desenha-lo na cor
# certa abre um vao claro em volta das letras. E o truque padrao de mapa, e
# custa menos que reposicionar rotulo a mao.
texto_halo <- function(x, y, rot, cex, col, font = 1, halo = "white") {
  d <- 0.006 * diff(par("usr")[1:2])
  for (a in seq(0, 2 * pi, length.out = 9)[-9])
    text(x + cos(a) * d, y + sin(a) * d * 0.72, rot, cex = cex, col = halo, font = font)
  text(x, y, rot, cex = cex, col = col, font = font)
}

borda <- function(x0, y0, x1, y1) {
  # encurta a seta até a borda da caixa de destino, não até o seu centro
  dx <- x1 - x0; dy <- y1 - y0
  if (dx == 0 && dy == 0) return(c(x1, y1))
  tx <- if (dx != 0) (LARG / 2 + 0.05) / abs(dx) else Inf
  ty <- if (dy != 0) (ALT  / 2 + 0.05) / abs(dy) else Inf
  t <- min(tx, ty)
  c(x1 - dx * t, y1 - dy * t)
}

for (i in seq_len(nrow(A))) {
  d <- N[A$de[i], ]; p <- N[A$para[i], ]
  cor <- COR[[A$sit[i]]]
  lty <- switch(A$sit[i], existe = 1, estimada = 1, proposta = 2, falta = 3)
  lwd <- switch(A$sit[i], existe = 2.1, estimada = 2.6, proposta = 2.1, falta = 1.7)
  ini <- borda(p$x, p$y, d$x, d$y); fim <- borda(d$x, d$y, p$x, p$y)
  if (A$curva[i] != 0) {
    # arco para a aresta de volta, que senão se sobreporia à de ida
    t  <- seq(0, 1, length.out = 60)
    mx <- (ini[1] + fim[1]) / 2 - A$curva[i] * (fim[2] - ini[2]) * 0.9
    my <- (ini[2] + fim[2]) / 2 + A$curva[i] * (fim[1] - ini[1]) * 0.9
    bx <- (1-t)^2 * ini[1] + 2*(1-t)*t*mx + t^2 * fim[1]
    by <- (1-t)^2 * ini[2] + 2*(1-t)*t*my + t^2 * fim[2]
    lines(bx, by, col = cor, lty = lty, lwd = lwd)
    arrows(bx[58], by[58], bx[60], by[60], length = 0.09, col = cor, lwd = lwd)
    texto_halo(mx + A$ajx[i], my + A$ajy[i], A$rot[i], cex = 0.60, col = cor, font = 3)
  } else {
    arrows(ini[1], ini[2], fim[1], fim[2], length = 0.09, col = cor,
           lty = lty, lwd = lwd)
    if (nzchar(A$rot[i])) {
      # desloca PERPENDICULARMENTE a aresta: em diagonal, deslocar so em y
      # deixa o rotulo em cima da propria seta
      dx <- fim[1] - ini[1]; dy <- fim[2] - ini[2]
      h  <- sqrt(dx^2 + (dy * 0.72)^2)                # 0.72 e o asp do plot
      ox <- if (h > 0) -(dy * 0.72) / h * 0.17 else 0
      oy <- if (h > 0)  (dx / h) * 0.17 / 0.72 else 0.16
      if (oy < 0) { ox <- -ox; oy <- -oy }            # rotulo sempre por cima
      texto_halo((ini[1] + fim[1]) / 2 + ox + A$ajx[i],
                 (ini[2] + fim[2]) / 2 + oy + A$ajy[i], A$rot[i], cex = 0.60,
                 col = if (A$sit[i] == "existe") COR$rotulo else cor, font = 3)
    }
  }
}

for (i in seq_len(nrow(N))) {
  n <- N[i, ]
  cf <- COR[[paste0(n$tipo, "_bg")]]; cb <- COR[[n$tipo]]
  rect(n$x - LARG/2, n$y - ALT/2, n$x + LARG/2, n$y + ALT/2,
       col = cf, border = cb, lwd = 1.9)
  text(n$x, n$y + 0.058, n$rot, cex = 0.80, font = 2, col = cb)
  text(n$x, n$y - 0.095, n$sub, cex = 0.47, col = COR$texto)
}

title(main = "ocupacoesBR — as traduções possíveis",
      cex.main = 1.10, col.main = COR$texto, font.main = 2, line = 1.0)
mtext("nós: classificações e medidas   ·   setas: correspondências, com a fonte de cada uma",
      side = 3, line = 0.05, cex = 0.58, col = COR$fraco)

legend("bottomright", bty = "n", cex = 0.60, seg.len = 2.4, lty = 1, lwd = 2.1,
       col = COR$existe, legend = "implementado — toda seta tem fonte declarada")
# No canto de baixo a esquerda esta a caixa COD. O vazio real do desenho e
# em cima a esquerda, acima do TSE.
legend("topleft", bty = "n", cex = 0.60, y.intersp = 1.25, pch = 22, pt.cex = 1.5,
       pt.bg = c(COR$origem_bg, COR$hub_bg, COR$medida_bg, COR$autoral_bg,
                 COR$estimada_bg),
       col   = c(COR$origem,    COR$hub,    COR$medida,    COR$autoral,
                 COR$estimada),
       legend = c("origem (o dado entra aqui)", "classificação internacional",
                  "medida importada", "esquema próprio do pacote",
                  "medida estimada pelo pacote"))
par(op); dev.off()
message("figura em ", SAIDA)
