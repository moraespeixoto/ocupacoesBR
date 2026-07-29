# ============================================================================
# 05_gera_validacao.R — o critério externo contra o qual a medida se afere
# ----------------------------------------------------------------------------
# Todo o resto do pacote é tradução: código do TSE -> ISCO -> ISEI. Nada nessa
# cadeia se afere contra algo FORA dela. Este script constrói o único conjunto
# que permite fazê-lo, com duas variáveis que o próprio TSE coleta e que não
# entram na construção da medida em momento nenhum:
#
#   patrimônio declarado — a declaração de bens da candidatura;
#   escolaridade         — o grau de instrução declarado.
#
# O agregado sai por OCUPAÇÃO, e não por candidatura, porque é nesse nível que
# uma medida de posição ocupacional é definida. Não há microdado aqui: 164
# linhas, nada identificável.
#
# FONTE: DADOS/raw/microdados_classe_v2.rds do projeto vices_do_brasil.
#   Não versionado (51 MB). Ajuste OCUPACOESBR_MICROBASE se estiver noutro lugar.
#
# Rodar: Rscript data-raw/05_gera_validacao.R
# ============================================================================

MICRO <- Sys.getenv("OCUPACOESBR_MICROBASE",
                    "~/vices_do_brasil/DADOS/raw/microdados_classe_v2.rds")
MICRO <- path.expand(MICRO)
# O piso vale para as DUAS contagens, e a segunda é a que importa: a mediana de
# patrimônio precisa de observações COM patrimônio, não de candidaturas. Sem o
# piso sobre `n_com_bens`, entram ocupações cuja mediana de bens se apoia em umas
# poucas declarações, e a correlação com o ISEI cai — não porque a medida piore,
# mas porque o critério externo fica ruidoso.
#
# O QUE MUDOU EM 29/07/2026, e por quê. O piso sobre `n_com_bens` DESCARTAVA a
# linha inteira, e não só a mediana. Isso amputava do conjunto 46 ocupações que
# têm escolaridade e gênero perfeitamente medidos e apenas carecem de declarações
# de bens suficientes. A consequência era que a regressão de gênero documentada
# em ?tse_para_isei (170 códigos com n >= 500) NÃO se reproduzia a partir do dado
# publicado, que só continha 157 — e a divergência atravessava o limiar
# convencional de significância (p = 0,044 contra 0,061). Agora o piso zera a
# MEDIANA e preserva a linha: uma tabela só serve às duas análises, e ambas
# reproduzem. Nenhum número publicado muda.
N_MIN <- 200L

if (!file.exists(MICRO))
  stop("microbase não encontrada em:\n  ", MICRO,
       "\nAponte OCUPACOESBR_MICROBASE para o arquivo.", call. = FALSE)

m <- readRDS(MICRO)
stopifnot(all(c("cod_ocup", "isei", "patrim", "superior", "gen") %in% names(m)))

cod <- as.character(m$cod_ocup)
n_por_cod <- table(cod)
manter <- names(n_por_cod)[n_por_cod >= N_MIN]

agrega <- function(k) {
  s <- cod == k
  pat <- m$patrim[s]
  pat <- pat[!is.na(pat) & pat > 0]
  data.frame(
    cod_tse            = k,
    n                  = sum(s),
    pct_superior       = round(100 * mean(m$superior[s], na.rm = TRUE), 1),
    pct_mulher         = round(100 * mean(m$gen[s] == "Mulher", na.rm = TRUE), 1),
    n_com_bens         = length(pat),
    mediana_patrimonio = if (length(pat)) round(stats::median(pat)) else NA_real_,
    stringsAsFactors = FALSE)
}
tse_validacao <- do.call(rbind, lapply(sort(manter), agrega))
# a linha FICA; o que cai é a mediana onde ela seria ruidosa (ver bloco acima)
tse_validacao$mediana_patrimonio[tse_validacao$n_com_bens < N_MIN] <- NA_real_
rownames(tse_validacao) <- NULL

# ---- as correlações que a vinheta vai reportar ------------------------------
load("data/tse_isco.rda"); load("data/isco88_medidas.rda")
i <- match(tse_isco$isco88[match(tse_validacao$cod_tse, tse_isco$cod_tse)],
           isco88_medidas$isco88)
isei <- isco88_medidas$isei88[i]
cs <- function(a, b, met = "pearson") round(stats::cor(a, b, method = met), 3)
# DOIS crivos distintos: a escolaridade está medida em toda linha do conjunto; a
# mediana de patrimônio, só onde sobreviveu ao piso de declarações de bens.
ok_esc <- !is.na(isei)
ok_pat <- ok_esc & !is.na(tse_validacao$mediana_patrimonio)

message(sprintf("ocupações no conjunto: %d (n >= %d), das quais %d com mediana de bens",
                nrow(tse_validacao), N_MIN,
                sum(!is.na(tse_validacao$mediana_patrimonio))))
message(sprintf("  ISEI x %% superior          : r = %.3f | rho = %.3f  (n = %d)",
                cs(isei[ok_esc], tse_validacao$pct_superior[ok_esc]),
                cs(isei[ok_esc], tse_validacao$pct_superior[ok_esc], "spearman"),
                sum(ok_esc)))
message(sprintf("  ISEI x log mediana patrim. : r = %.3f | rho = %.3f  (n = %d)",
                cs(isei[ok_pat], log(tse_validacao$mediana_patrimonio[ok_pat])),
                cs(isei[ok_pat], log(tse_validacao$mediana_patrimonio[ok_pat]), "spearman"),
                sum(ok_pat)))

# A correlação NO NÍVEL DO INDIVÍDUO é muito menor, e o contraste é o resultado:
# o ISEI explica a variância ENTRE ocupações e quase nada DENTRO de cada uma —
# que é o que uma medida de posição ocupacional deve fazer, e é também o
# argumento contra usá-la como proxy de renda individual.
ind <- !is.na(m$isei) & !is.na(m$patrim) & m$patrim > 0
message(sprintf("  no nível do indivíduo, ISEI x log patrim.: r = %.3f (n = %s)",
                cs(m$isei[ind], log(m$patrim[ind])),
                format(sum(ind), big.mark = " ")))

usethis::use_data(tse_validacao, overwrite = TRUE)
