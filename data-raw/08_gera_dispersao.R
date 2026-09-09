# ============================================================================
# 08_gera_dispersao.R — o que a medida NÃO explica, em forma publicável
# ----------------------------------------------------------------------------
# O artigo de método afirma que a correlação entre status e patrimônio cai de
# ~0,68 no nível da OCUPAÇÃO para ~0,21 no nível do INDIVÍDUO, e que essa queda
# é a definição operacional do que uma escala de posição ocupacional faz. Era o
# único número do texto que o leitor não podia recalcular: dependia da
# microbase, que não acompanha o pacote e não vai acompanhar.
#
# ESTE SCRIPT RESOLVE ISSO SEM PUBLICAR MICRODADO. A correlação de Pearson é
# função apenas de somatórios; agrupando por valor de ISEI — que é discreto,
# porque cada código do dicionário tem um escore só — e publicando n, soma e
# soma dos quadrados do log do patrimônio em cada grupo, o coeficiente sai
# EXATO. Nada aqui é identificável: são umas poucas dezenas de linhas de
# somatórios, sem candidatura, sem ocupação, sem ano.
#
# O agrupamento não é uma escolha de conveniência: ele preserva exatamente a
# informação necessária e descarta o resto. E a tabela é mais que um insumo do
# coeficiente, porque `sd_log` mostra a dispersão DENTRO de cada nível de
# status — que é o fenômeno que o artigo discute, e que a correlação só resume.
#
# FONTE: /dados/dados_ocupacoesBR/microbase_validacao_1998_2026.rds (mesma de
#   `05_gera_validacao.R`). Não versionada. Ajuste OCUPACOESBR_MICROBASE.
#
# Rodar: Rscript data-raw/08_gera_dispersao.R
# ============================================================================

MICRO <- path.expand(Sys.getenv("OCUPACOESBR_MICROBASE",
                                "/dados/dados_ocupacoesBR/microbase_validacao_1998_2026.rds"))
if (!file.exists(MICRO))
  stop("microbase não encontrada em:\n  ", MICRO,
       "\nAponte OCUPACOESBR_MICROBASE para o arquivo.", call. = FALSE)

devtools::load_all(quiet = TRUE)
m <- readRDS(MICRO)
stopifnot(all(c("cod_ocup", "patrim") %in% names(m)))

isei <- tse_para_isei(as.character(m$cod_ocup))
# o patrimônio entra em log, como no nível da ocupação: a distribuição é
# fortemente assimétrica e a correlação em nível bruto mede a cauda, não a
# relação (r = 0,046 contra 0,208 em log)
pat  <- m$patrim
ok   <- !is.na(isei) & !is.na(pat) & pat > 0
x <- isei[ok]; y <- log(pat[ok])

g <- split(y, x)
tse_dispersao_patrimonio <- data.frame(
  isei88     = as.numeric(names(g)),
  n          = vapply(g, length, 0L),
  soma_log   = vapply(g, sum, 0),
  soma_log2  = vapply(g, function(v) sum(v^2), 0),
  media_log  = round(vapply(g, mean, 0), 4),
  sd_log     = round(vapply(g, stats::sd, 0), 4),
  stringsAsFactors = FALSE)
rownames(tse_dispersao_patrimonio) <- NULL
tse_dispersao_patrimonio <-
  tse_dispersao_patrimonio[order(tse_dispersao_patrimonio$isei88), ]

# ---- a trava: o agregado tem de devolver o coeficiente do microdado ---------
r_micro <- stats::cor(x, y)
r_agreg <- with(tse_dispersao_patrimonio, {
  N <- sum(n); sx <- sum(isei88 * n); sy <- sum(soma_log)
  sxx <- sum(isei88^2 * n); syy <- sum(soma_log2); sxy <- sum(isei88 * soma_log)
  (N * sxy - sx * sy) / sqrt((N * sxx - sx^2) * (N * syy - sy^2))
})
stopifnot(
  nrow(tse_dispersao_patrimonio) > 20,
  sum(tse_dispersao_patrimonio$n) == length(x),
  abs(r_micro - r_agreg) < 1e-12,   # exato, não aproximado
  all(tse_dispersao_patrimonio$n > 0))

usethis::use_data(tse_dispersao_patrimonio, overwrite = TRUE)
message(sprintf(
  "dispersão: %d níveis de ISEI | %s candidaturas | r individual = %.4f (agregado bate a %.0e)",
  nrow(tse_dispersao_patrimonio), format(sum(tse_dispersao_patrimonio$n), big.mark = ".", decimal.mark = ","),
  r_agreg, abs(r_micro - r_agreg)))
