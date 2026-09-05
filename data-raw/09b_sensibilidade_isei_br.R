# ============================================================================
# 09b_sensibilidade_isei_br.R — o ISEI-BR depende das escolhas de metodo?
# ----------------------------------------------------------------------------
# `09_gera_isei_br.R` adota UMA especificacao e publica UM angulo. A decisao 7
# daquele cabecalho afirma que a escala e robusta, e a secao Sensibilidade de
# ?isco08_isei_br publica os limites dessa robustez. Este script e o que
# produz esses numeros. Sem ele eles seriam afirmacao sem origem, que e
# exatamente o que a proveniencia deste pacote existe para impedir.
#
# O QUE ELE FAZ
#   Reestima o angulo sob a especificacao adotada e sob sete alternativas,
#   cada uma trocando uma decisao de metodo, e mede quanto o ORDENAMENTO das
#   ocupacoes se move em relacao a adotada. O ordenamento e o que importa: o
#   escore e reescalado para 10 a 90 no fim, entao deslocamento e escala nao
#   mudam nada, e a correlacao de Spearman e a medida certa da diferenca.
#
# ELE NAO GRAVA NADA EM data/. A saida e a tabela impressa, que alimenta a
# secao Sensibilidade de R/dados.R e a entrada correspondente no NEWS.md.
#
# FONTE
#   A mesma de 09_gera_isei_br.R: PNAD Continua trimestral, quatro trimestres
#   de 2025, em OCUPACOESBR_PNAD (com fallback em ~/dados_pnad). Os sha256
#   estao em inst/extdata/PROVENIENCIA.yml, secao microdados_externos.
#
# Rodar: Rscript data-raw/09b_sensibilidade_isei_br.R
# ============================================================================

PNAD <- path.expand(Sys.getenv("OCUPACOESBR_PNAD", "~/dados_pnad"))
arq  <- list.files(PNAD, "^cols_.*csv$", full.names = TRUE)
if (!length(arq))
  stop("microdados da PNAD ausentes em ", PNAD,
       ".\nVeja o cabecalho de data-raw/09_gera_isei_br.R.", call. = FALSE)

suppressMessages(library(data.table))
devtools::load_all(quiet = TRUE)

d <- rbindlist(lapply(arq, fread, colClasses = "character",
                      na.strings = c("", ".")))
d[, `:=`(idade = as.integer(V2009), anos = as.integer(VD3005),
         hrs   = as.integer(V4039), r_hab = as.numeric(VD4016),
         r_ef  = as.numeric(VD4017),
         peso  = as.numeric(V1028) / length(arq), sexo = V2007)]
d[, pessoa := paste(UPA, V1008, V1014, V2003, V20082, sep = "|")]

NMIN <- 30L
zw <- function(x, w) {
  m <- weighted.mean(x, w); (x - m) / sqrt(weighted.mean((x - m)^2, w))
}

# Uma especificacao = uma amostra analitica. Os defaults reproduzem exatamente
# as decisoes 1 a 5 de 09_gera_isei_br.R; cada argumento troca uma delas.
amostra <- function(renda = c("hab", "ef", "hora"), hmin = 30L,
                    so_homens = FALSE, idade_min = 21L,
                    educ = c("anos", "categorias")) {
  renda <- match.arg(renda); educ <- match.arg(educ)
  a <- d[!is.na(V4010) & V4010 != "0000" & idade >= idade_min & idade <= 64]
  if (so_homens)    a <- a[sexo == "1"]
  if (!is.na(hmin)) a <- a[!is.na(hrs) & hrs >= hmin]
  a[, y := switch(renda, hab = r_hab, ef = r_ef, hora = r_hab / (hrs * 4.345))]
  a <- a[!is.na(y) & y > 0]
  if (educ == "anos") {
    a <- a[!is.na(anos)]; a[, e := anos]
  } else {
    # o mapa de nivel de instrucao (VD3004) para anos, usado antes de VD3005
    # entrar na extracao. Serve para medir quanto o erro de medida importava.
    ap <- c(0, 4, 8, 10, 12, 14, 16)
    a <- a[!is.na(VD3004)]; a[, e := ap[as.integer(VD3004)]]
  }
  a[, isco08 := suppressWarnings(cod_para_isco08(V4010))]
  a <- a[!is.na(isco08)]
  a[, ly := log(y)]
  termos <- c("idade", "I(idade^2)")
  if (uniqueN(a$sexo) > 1L) termos <- c(termos, "factor(sexo)")
  if (uniqueN(a$tri)  > 1L) termos <- c(termos, "factor(tri)")
  res <- function(v) residuals(lm(stats::reformulate(termos, v),
                                  data = a, weights = a$peso))
  a[, `:=`(es = zw(res("e"), peso), ys = zw(res("ly"), peso))]
  a[]
}

estima <- function(a) {
  cel <- a[, .(E = weighted.mean(es, peso), Y = weighted.mean(ys, peso),
               n_pessoas = uniqueN(pessoa)), by = isco08]
  est <- cel[n_pessoas >= NMIN]
  am  <- a[isco08 %chin% est$isco08]
  bdir <- function(th) {
    u <- est$E * cos(th) + est$Y * sin(th)
    v <- zw(u[match(am$isco08, est$isco08)], am$peso)
    unname(coef(lm(ys ~ v + es, data = am, weights = am$peso))["es"])
  }
  th   <- optimize(function(t) abs(bdir(t)), c(0, pi / 2), tol = 1e-6)$minimum
  btot <- unname(coef(lm(ys ~ es, data = am, weights = am$peso))["es"])
  list(th = th, bdir = bdir(th), mediada = 100 * (1 - bdir(th) / btot),
       u = setNames(est$E * cos(th) + est$Y * sin(th), est$isco08),
       n = nrow(est))
}

ESPEC <- list(
  "adotada (>= 30h, anos de estudo, ambos os sexos, renda habitual)" = list(),
  "tempo integral a 40 horas"          = list(hmin = 40L),
  "sem restricao de horas"             = list(hmin = NA),
  "renda-hora, sem restricao de horas" = list(renda = "hora", hmin = NA),
  "rendimento efetivo"                 = list(renda = "ef"),
  "so homens, como no artigo de 1992"  = list(so_homens = TRUE),
  "escolaridade em 7 categorias"       = list(educ = "categorias"),
  "idade a partir de 25 anos"          = list(idade_min = 25L))

ref <- estima(do.call(amostra, ESPEC[[1]]))
out <- rbindlist(lapply(names(ESPEC), function(nm) {
  r <- if (nm == names(ESPEC)[1]) ref else estima(do.call(amostra, ESPEC[[nm]]))
  com <- intersect(names(ref$u), names(r$u))
  data.table(especificacao = nm,
             theta       = round(r$th, 3),
             peso_educ   = round(cos(r$th), 3),
             mediada_pct = round(r$mediada, 1),
             celulas     = r$n,
             spearman_vs_adotada = round(
               cor(ref$u[com], r$u[com], method = "spearman"), 4))
}))

# a robustez ao proprio angulo, que 09_gera_isei_br.R tambem calcula
esc <- function(th, e) e$E * cos(th) + e$Y * sin(th)
cel_ref <- do.call(amostra, ESPEC[[1]])[
  , .(E = weighted.mean(es, peso), Y = weighted.mean(ys, peso),
      n_pessoas = uniqueN(pessoa)), by = isco08][n_pessoas >= NMIN]
rob <- min(cor(esc(ref$th, cel_ref), esc(ref$th - 0.15, cel_ref), method = "spearman"),
           cor(esc(ref$th, cel_ref), esc(ref$th + 0.15, cel_ref), method = "spearman"))

cat("\n=== SENSIBILIDADE DO ISEI-BR ===\n\n")
print(out, row.names = FALSE)
cat(sprintf("\nrobustez ao proprio angulo (Spearman theta +- 0,15): %.4f\n", rob))
alt <- out[-1]
cat(sprintf("menor Spearman entre as %d alternativas: %.4f (%s)\n",
            nrow(alt), min(alt$spearman_vs_adotada),
            alt$especificacao[which.min(alt$spearman_vs_adotada)]))
cat(sprintf("parcela mediada: de %.1f%% a %.1f%% entre todas as %d especificacoes\n",
            min(out$mediada_pct), max(out$mediada_pct), nrow(out)))
cat("\nEstes tres numeros sao os que a secao Sensibilidade de ?isco08_isei_br\n",
    "e a entrada do NEWS.md podem afirmar. Nenhum outro.\n", sep = "")
