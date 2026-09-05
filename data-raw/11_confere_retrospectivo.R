# ============================================================================
# 11_confere_retrospectivo.R — refaz os numeros de `?isei_retrospectivo`
# ----------------------------------------------------------------------------
# NAO GRAVA NADA. Imprime, para conferencia, todos os valores que a secao
# "O que ele erra, medido" e a secao "O que ele resolve, medido" afirmam.
#
# Por que existe: esses numeros estavam apenas digitados na documentacao, e por
# isso nao acompanharam a troca da microbase v2 -> v3 em 09/2026, que ganhou
# 12.798 candidaturas nas safras fechadas. A auditoria de 05/09/2026 os
# encontrou defasados. Mesma logica de `09b_sensibilidade_isei_br.R`: o numero
# que a prosa afirma tem de ter um lugar de onde sair.
#
# FONTE: ~/dados_ocupacoesBR/microbase_validacao_1998_2026.rds
# Rodar: Rscript data-raw/11_confere_retrospectivo.R
# ============================================================================

MICRO <- path.expand(Sys.getenv("OCUPACOESBR_MICROBASE",
                                "~/dados_ocupacoesBR/microbase_validacao_1998_2026.rds"))
if (!file.exists(MICRO))
  stop("microbase nao encontrada em:\n  ", MICRO, call. = FALSE)

devtools::load_all(quiet = TRUE)
m <- readRDS(MICRO)
stopifnot(all(c("id_pessoa", "ano", "cod_ocup", "isei", "gen") %in% names(m)))

# A janela para em 2024 de proposito: a medicao exige o painel por pessoa, e a
# safra de 2026 ainda nao o tem montado.
p <- as.data.frame(m[m$ano <= 2024 & !is.na(m$id_pessoa),
                     c("id_pessoa", "ano", "cod_ocup", "isei", "gen")])
p <- p[order(p$id_pessoa, p$ano), ]

# pares consecutivos da mesma pessoa
n <- nrow(p)
mesma <- p$id_pessoa[-1] == p$id_pessoa[-n]
ant <- which(mesma); pos <- ant + 1L
par <- data.frame(cod0 = p$cod_ocup[ant], cod1 = p$cod_ocup[pos],
                  isei0 = p$isei[ant],    isei1 = p$isei[pos],
                  lag   = p$ano[pos] - p$ano[ant])
# "observado nas duas pontas": e onde da para conferir o que o carregamento supoe
obs <- par[!is.na(par$isei0) & !is.na(par$isei1), ]

muda_cod  <- obs$cod0 != obs$cod1
muda_isei <- obs$isei0 != obs$isei1
cat("pares consecutivos com ISEI nas duas pontas: ", nrow(obs), "\n", sep = "")
cat("  mudam de codigo de ocupacao: ",
    round(mean(muda_cod)  * 100, 1), "%\n", sep = "")
cat("  mudam de escore ISEI:        ",
    round(mean(muda_isei) * 100, 1), "%\n", sep = "")
cat("  diferenca absoluta media QUANDO muda: ",
    round(mean(abs(obs$isei1 - obs$isei0)[muda_isei]), 1), " pontos\n", sep = "")

# A defasagem e a cobertura sao medidas com a PROPRIA funcao do pacote, e nao
# com uma reimplementacao: o que se quer descrever e o que ela faz, incluindo o
# LOCF que atravessa varias eleicoes — a defasagem de um escore herdado nao e a
# distancia ate a candidatura anterior, e sim ate a ultima OBSERVADA.
r <- isei_retrospectivo(p$isei, p$id_pessoa, p$ano)
h <- r$defasagem[r$herdado]
cat("herdados: ", sum(r$herdado), " (", round(mean(r$herdado) * 100, 1),
    "% das candidaturas)\n", sep = "")
cat("defasagem dos herdados: mediana ", stats::median(h),
    " anos | >= 8 anos: ", round(mean(h >= 8) * 100, 1),
    "% | maximo ", max(h), "\n", sep = "")

# cobertura antes e depois, por genero
for (g in c("Homem", "Mulher")) {
  sel <- !is.na(p$gen) & p$gen == g
  rg <- isei_retrospectivo(p$isei[sel], p$id_pessoa[sel], p$ano[sel])
  cat("cobertura ", g, ": ", round(mean(!is.na(p$isei[sel])) * 100, 1),
      " -> ", round(mean(!is.na(rg$escore)) * 100, 1), "\n", sep = "")
}

# a tendencia geral que `tse_quebra_2002$delta_vs_tendencia` desconta
q <- ocupacoesBR::tse_quebra_2002
cat("tendencia geral descontada em delta_vs_tendencia: ",
    unique(round(q$delta_pp - q$delta_vs_tendencia, 1))[1], " pp\n", sep = "")
