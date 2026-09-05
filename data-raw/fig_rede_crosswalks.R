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
  texto    = "#212F3D", fraco       = "#7F8C8D")

# ---- nós: x, y, rótulo, sublinha, tipo ------------------------------------
no <- function(id, x, y, rot, sub, tipo)
  data.frame(id, x, y, rot, sub, tipo, stringsAsFactors = FALSE)

N <- rbind(
  # origens — por onde o dado entra
  no("tse",   1.0, 5.05, "TSE",       "CD_OCUPACAO · 275", "origem"),
  no("cbo02", 1.0, 3.55, "CBO-2002",  "RAIS · CAGED · eSocial", "origem"),
  no("cbo94", 1.0, 2.25, "CBO-94",    "RAIS até 2002", "origem"),
  no("cod",   1.0, 0.95, "COD",       "PNAD Contínua · Censo · 434", "origem"),
  # hubs — as classificações internacionais
  no("i88",   3.1, 3.90, "ISCO-88",   "537 códigos", "hub"),
  no("i08",   3.1, 1.70, "ISCO-08",   "590 códigos", "hub"),
  # medidas ancoradas na ISCO-88
  no("isei88",  5.3, 5.15, "ISEI-88",    "status socioeconômico", "medida"),
  no("prest88", 5.3, 4.30, "Prestígio",  "Treiman 1977", "medida"),
  no("egp",     5.3, 3.45, "EGP",        "11 · 7 · 5 · 3 classes", "medida"),
  # medidas ancoradas na ISCO-08
  no("isei08",  5.3, 2.30, "ISEI-08",    "status, âncora 2008", "medida"),
  no("prest08", 5.3, 1.50, "Prestígio-08", "Treiman, âncora 2008", "medida"),
  # a única medida que o pacote ESTIMA em vez de importar
  no("iseibr",  5.3, 0.70, "ISEI-BR",    "PNAD Contínua 2025", "estimada"),
  # esquema próprio — não passa pela ISCO
  no("classe",  3.1, 5.75, "Classe · Estrato", "esquema do pacote · 10 cat.", "autoral")
)
rownames(N) <- N$id

# ---- arestas: de, para, situação, rótulo, curvatura ------------------------
ar <- function(de, para, sit, rot = "", curva = 0)
  data.frame(de, para, sit, rot, curva, stringsAsFactors = FALSE)

A <- rbind(
  ar("tse",   "classe", "existe",   "mapeamento autoral", 0),
  ar("tse",   "i88",    "existe",   "autoral · 2 a 4 díg.", 0),
  ar("cbo02", "i88",    "existe",   "tábua MTE · 49,8%", 0),
  ar("cbo02", "cbo94",  "existe",   "tábua MTE", 0),
  ar("cbo94", "i88",    "existe",   "tábua MTE", 0),
  ar("i88",   "i08",    "existe",   "OIT · 1/3 ambíguo", 0),
  ar("i88",   "isei88",  "existe",  "ISMF", 0),
  ar("i88",   "prest88", "existe",  "ISMF", 0),
  ar("i88",   "egp",     "existe",  "ISMF", 0),
  ar("i08",   "isei08",  "existe",  "ISMF", 0),
  ar("i08",   "prest08", "existe",  "ISMF", 0),
  ar("i08",   "iseibr",  "estimada", "estimado aqui, na PNAD", 0),
  ar("cod",   "i08",     "existe",   "IBGE · 428 de 434 idênticos", 0),
  ar("i08",   "i88",     "existe",   "ISMF · volta fecha em 69%", -0.42)
)

# ---- desenho ---------------------------------------------------------------
png(SAIDA, width = 2100, height = 1350, res = 190)
op <- par(mar = c(0.4, 0.4, 2.6, 0.4), family = "sans")
plot(NA, xlim = c(0.25, 6.35), ylim = c(0.4, 6.35), axes = FALSE,
     xlab = "", ylab = "", asp = 0.72)

LARG <- 0.78; ALT <- 0.30

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
    text(mx, my, A$rot[i], cex = 0.5, col = cor, font = 3, pos = 4, offset = 0.2)
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
      text((ini[1] + fim[1]) / 2 + ox, (ini[2] + fim[2]) / 2 + oy, A$rot[i],
           cex = 0.5, col = if (A$sit[i] == "existe") COR$fraco else cor,
           font = 3)
    }
  }
}

for (i in seq_len(nrow(N))) {
  n <- N[i, ]
  cf <- COR[[paste0(n$tipo, "_bg")]]; cb <- COR[[n$tipo]]
  rect(n$x - LARG/2, n$y - ALT/2, n$x + LARG/2, n$y + ALT/2,
       col = cf, border = cb, lwd = 1.9)
  text(n$x, n$y + 0.055, n$rot, cex = 0.72, font = 2, col = cb)
  text(n$x, n$y - 0.085, n$sub, cex = 0.44, col = COR$texto)
}

title(main = "ocupacoesBR — as traduções possíveis",
      cex.main = 1.02, col.main = COR$texto, font.main = 2, line = 1.0)
mtext("nós: classificações e medidas   ·   setas: correspondências, com a fonte de cada uma",
      side = 3, line = 0.05, cex = 0.5, col = COR$fraco)

legend("bottomright", bty = "n", cex = 0.52, seg.len = 2.4, lty = 1, lwd = 2.1,
       col = COR$existe, legend = "implementado — toda seta tem fonte declarada")
legend("bottomleft", bty = "n", cex = 0.52, pch = 22, pt.cex = 1.5,
       pt.bg = c(COR$origem_bg, COR$hub_bg, COR$medida_bg, COR$autoral_bg,
                 COR$estimada_bg),
       col   = c(COR$origem,    COR$hub,    COR$medida,    COR$autoral,
                 COR$estimada),
       legend = c("origem (o dado entra aqui)", "classificação internacional",
                  "medida importada", "esquema próprio do pacote",
                  "medida estimada pelo pacote"))
par(op); dev.off()
message("figura em ", SAIDA)
