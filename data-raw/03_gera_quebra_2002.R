# ============================================================================
# 03_gera_quebra_2002.R — APOSENTADO. Não gera mais nada.
# ----------------------------------------------------------------------------
# ATENÇÃO: este script NÃO deve ser executado. Ele não escreve nenhum dado.
#
# Até a auditoria de 27/07/2026 ele montava `tse_quebra_2002` a partir de uma
# tabela de TRÊS linhas (211, 214, 216) DIGITADA À MÃO — a única tabela do
# pacote que violava a regra "nada é digitado à mão" — e chamava
# `usethis::use_data(tse_quebra_2002, overwrite = TRUE)`.
#
# POR QUE FOI DESLIGADO. O dataset publicado tem hoje 44 linhas, com as colunas
# `tipo` e `primeiro_ano_novo`, e é gerado por `04_gera_rotulos.R` a partir dos
# rótulos reais do TSE (DS_OCUPACAO, 1998-2024). Rodar este script isolado
# REGRAVAVA o `.rda` no schema antigo, sem `tipo` — e então `.fora_de_vigencia()`
# (R/rotulos.R) filtrava `q$tipo == "reutilizado"` sobre um `NULL`, achava zero
# linhas, e o parâmetro `ano =` das funções de tradução deixava de anular as
# candidaturas reutilizadas, EM SILÊNCIO. O pipeline só acertava porque `04`
# rodava depois e sobrescrevia. Era código morto que degradava um dado publicado.
#
# O método antigo (comparar a queda de escolaridade antes/depois de 2002) era
# CEGO POR CONSTRUÇÃO: só via reutilizações que cruzam a linha do diploma. O 215
# (OCUPANTE DE CARGO DE DIREÇÃO E ASSESSORAMENTO SUPERIOR até 2000 → ARTISTA
# PLÁSTICO a partir de 2006) variou UM ponto percentual de escolaridade e passava
# inteiro. Comparando rótulos, são 44 códigos e não 3.
#
# A geração de `tse_quebra_2002` vive em `04_gera_rotulos.R`. Este arquivo fica
# como registro histórico da decisão.
# ============================================================================

stop("03_gera_quebra_2002.R foi aposentado; tse_quebra_2002 e' gerado por ",
     "04_gera_rotulos.R. Veja o cabecalho deste arquivo.", call. = FALSE)
