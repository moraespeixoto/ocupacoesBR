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
# uma medida de posição ocupacional é definida. Não há microdado aqui: 220
# linhas, nada identificável.
#
# FONTE: /dados/dados_ocupacoesBR/microbase_validacao_1998_2026.rds, produzida por
#   `05a_microbase_2026.R`: as candidaturas de 1998 a 2024 do
#   `microdados_classe_v3.rds` (classe_recrutamento_politico), mais a safra de
#   2026 anexada. A v2 somava cada bem duas vezes; a troca e de 09/2026 e o
#   motivo esta no cabecalho de `05a_microbase_2026.R`.
#   Não versionada. Ajuste OCUPACOESBR_MICROBASE se estiver noutro lugar.
#
#   O PATRIMÔNIO DE 2026 É `NA`, e de propósito: a coluna está deflacionada a
#   reais de outubro de 2024 e outubro de 2026 ainda não aconteceu. A safra
#   entra em `n`, `pct_superior` e `pct_mulher`, e se abstém da mediana de
#   bens — o mesmo que 1998-2004 já fazem, por não haver declaração de bens
#   antes de 2006. O cabeçalho de `05a_microbase_2026.R` desenvolve o ponto.
#
# Rodar: Rscript data-raw/05a_microbase_2026.R && Rscript data-raw/05_gera_validacao.R
# ============================================================================

MICRO <- Sys.getenv("OCUPACOESBR_MICROBASE",
                    "/dados/dados_ocupacoesBR/microbase_validacao_1998_2026.rds")
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
stopifnot(all(c("cod_ocup", "ano", "isei", "patrim", "superior", "gen") %in% names(m)))

cod <- as.character(m$cod_ocup)
n_por_cod <- table(cod)
manter <- names(n_por_cod)[n_por_cod >= N_MIN]

# ---- vigencia: os codigos reutilizados nao podem agregar duas ocupacoes -----
# Auditoria de 05/09/2026. Sete codigos foram reaproveitados para ocupacao
# DIFERENTE depois de 2002 — o 214 e DELEGADO DE POLICIA ate 2000 e ESCULTOR E
# PINTOR depois, o 521 vai de porteiro/cozinheiro a GOVERNANTA. Agregando a
# serie inteira, `pct_superior` e `pct_mulher` misturavam as duas populacoes: o
# escultor saia com 30,6% de superior (sao 2,3%) e a governanta com 42,3% de
# mulheres (sao 97,2%). O pacote manda o usuario passar `ano =` justamente para
# impedir isso, e nao o passava em casa.
#
# A mediana de patrimonio nao era atingida — bens so existem de 2006 em diante,
# ja na vigencia nova —, mas o corte se aplica a ela tambem, por coerencia.
load("data/tse_quebra_2002.rda")
reut <- tse_quebra_2002[tse_quebra_2002$tipo == "reutilizado", ]
piso <- stats::setNames(reut$primeiro_ano_novo, reut$cod_tse)

agrega <- function(k) {
  s <- cod == k
  if (!is.na(piso[k])) s <- s & m$ano >= piso[[k]]
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
# o piso de N_MIN vale sobre a janela EFETIVA: um codigo reutilizado pode
# passar no cadastro inteiro e nao passar so na vigencia nova
antes <- nrow(tse_validacao)
tse_validacao <- tse_validacao[tse_validacao$n >= N_MIN, ]
if (nrow(tse_validacao) < antes)
  message(antes - nrow(tse_validacao),
          " codigo(s) sairam por nao alcancarem n >= ", N_MIN,
          " dentro da propria vigencia.")
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
message(sprintf("  no nível da candidatura, ISEI x log patrim.: r = %.3f (n = %s)",
                cs(m$isei[ind], log(m$patrim[ind])),
                format(sum(ind), big.mark = " ")))

usethis::use_data(tse_validacao, overwrite = TRUE)
