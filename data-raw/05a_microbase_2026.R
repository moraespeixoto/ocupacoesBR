# ============================================================================
# 05a_microbase_2026.R — acrescenta a safra de 2026 à microbase de validação
# ----------------------------------------------------------------------------
# `05_gera_validacao.R` afere a medida contra dois critérios externos —
# escolaridade e patrimônio declarados — e para isso lê uma microbase por
# candidatura que vive FORA deste repositório. Até 0.2.1 essa microbase era
# `microdados_classe_v2.rds`, do projeto `vices_do_brasil`, e parava em 2024.
#
# Este script produz a microbase que vai até 2026, e o faz por ANEXAÇÃO: as
# linhas de 1998 a 2024 são copiadas sem tocar, e as de 2026 são construídas
# aqui. A escolha é deliberada. Se as linhas antigas fossem recalculadas junto,
# toda diferença em `tse_validacao` teria duas causas possíveis e nenhuma
# separável; anexando, qualquer número que se mova é atribuível a 2026 e só.
#
# AS CONVENÇÕES DE RECODIFICAÇÃO SÃO AS DO `vices_do_brasil`, e não novas:
# `SCRIPTS/constroi_microbase_v2.R` e `constroi_microbase_v3.R` daquele projeto
# definem `gen`, `superior`, `raca`/`raca_bin`, `regiao` e o recorte de turno.
# Reproduzi-las é o que faz a safra nova comparável às antigas.
#
# ---------------------------------------------------------------------------
# POR QUE O PATRIMÔNIO DE 2026 FICA `NA`
#
# Na microbase, `patrim` não é o valor declarado: é o valor DEFLACIONADO a
# reais de outubro de 2024, pelo número-índice do IPCA do mês de OUTUBRO de
# cada eleição (IBGE/SIDRA, tabela 1737, variável 2266). É o que torna
# legítimo agregar 1998 e 2024 na mesma mediana.
#
# Outubro de 2026 não aconteceu. Não há índice para deflacionar a safra, e
# inventar um — usando o índice de um mês qualquer de 2026 no lugar do de
# outubro — colocaria na coluna um valor que a própria definição da coluna
# desmente. Então 2026 entra com `tem_bens = FALSE` e `patrim = NA`.
#
# Isso NÃO é um buraco novo na tabela: é exatamente o tratamento que 1998,
# 2000, 2002 e 2004 já recebem, porque o TSE só publica bens de candidato a
# partir de 2006. `tse_validacao` sempre teve `n` cobrindo um período mais
# largo do que `n_com_bens`, e o piso `N_MIN` sobre `n_com_bens` existe para
# essa assimetria. A safra de 2026 contribui, portanto, para `n`,
# `pct_superior` e `pct_mulher`, e se abstém da mediana de patrimônio.
#
# Quando o IPCA de outubro de 2026 existir, acrescentar o índice ao vetor
# `ipca_out` do `vices_do_brasil` e regerar dá a coluna de graça.
# ---------------------------------------------------------------------------
#
# A SAFRA DE 2026 É ABERTA: o prazo de registro encerrou em 15/08/2026, mas o
# Tribunal ainda julga e publica. `eleito` e `votos` são NA em toda linha — e
# ficam NA, não FALSE. Nenhuma coluna que `05_gera_validacao.R` consome
# depende de apuração, que é o que torna a safra utilizável aqui.
#
# CORREÇÃO DE 03/09/2026 — A FONTE DE 1998-2024 MUDOU, E O MOTIVO IMPORTA.
# Até aqui este script lia `microdados_classe_v2.rds`, cuja agregação de bens
# (`bens_por_cand_2006_2024.rds`) SOMAVA CADA BEM DUAS VEZES. Medido contra o
# CSV bruto do TSE (`bem_candidato_2024_AC.csv`, 1.206 candidaturas): a v2 bate
# em 2 delas, a fonte nova bate em 1.206, e a razão v2/nova é exatamente 2,0 em
# 100% das 296.096 candidaturas de 2024. Todo valor de patrimônio que saiu
# daqui até a versão 0.4.0 do pacote estava, portanto, dobrado.
#
# A fonte passa a ser `microdados_classe_v3.rds`, construída pelo projeto
# `classe_recrutamento_politico` a partir de `~/novissimos_dados_tse/bancos/`,
# cuja chave tripla de bens já está corrigida. O que NÃO muda com isso: toda
# quantidade invariante a escala — a correlação de Pearson com o LOG do
# patrimônio (log(2x) difere de log(x) por uma constante), o Spearman, o desvio
# padrão do log, o Gini e qualquer razão entre grupos. O que muda: todo valor
# absoluto em reais.
#
# FONTES (nenhuma versionada):
#   ~/classe_recrutamento_politico/DADOS/raw/microdados_classe_v3.rds (1998-2024)
#   ~/novissimos_dados_tse/bancos/candidaturas/candidaturas_2026.rds
#
# SAÍDA: /dados/dados_ocupacoesBR/microbase_validacao_1998_2026.rds
#   Nome próprio, e fora da árvore do `vices_do_brasil`, para não colidir com
#   a microbase que aquele projeto gera para o artigo dele.
#
# Rodar: Rscript data-raw/05a_microbase_2026.R
# ============================================================================

MICRO_V2 <- path.expand(Sys.getenv("OCUPACOESBR_MICROBASE_V2",
                        "/dados/classe_recrutamento_politico/DADOS/raw/microdados_classe_v3.rds"))
SAFRA    <- path.expand(Sys.getenv("OCUPACOESBR_SAFRA_2026",
                        "~/novissimos_dados_tse/bancos/candidaturas/candidaturas_2026.rds"))
SAIDA    <- path.expand(Sys.getenv("OCUPACOESBR_MICROBASE",
                        "/dados/dados_ocupacoesBR/microbase_validacao_1998_2026.rds"))

for (f in c(MICRO_V2, SAFRA))
  if (!file.exists(f)) stop("não encontrado:\n  ", f, call. = FALSE)

if (requireNamespace("pkgload", quietly = TRUE)) {
  pkgload::load_all(".", quiet = TRUE)
} else {
  library(ocupacoesBR)
}

m <- readRDS(MICRO_V2)
m <- as.data.frame(m)
stopifnot(max(m$ano) == 2024L)
message(sprintf("microbase 1998-2024: %s linhas, %d colunas",
                format(nrow(m), big.mark = " "), ncol(m)))

z <- as.data.frame(readRDS(SAFRA))
cat(sprintf("safra 2026: geração do TSE em %s %s\n",
            unique(z$DT_GERACAO)[1], unique(z$HH_GERACAO)[1]))

# ---- mesmo recorte do vices_do_brasil: 1o turno, gênero declarado ----------
sel <- z$NR_TURNO == "1" & z$DS_GENERO %in% c("MASCULINO", "FEMININO")
message(sprintf("2026: %d de %d linhas no recorte", sum(sel), nrow(z)))
z <- z[sel, ]

utf <- function(x) enc2utf8(trimws(as.character(x)))

n26 <- nrow(z)
novo <- data.frame(
  ano       = 2026L,
  cargo     = utf(z$DS_CARGO),
  uf        = utf(z$SG_UF),
  regiao    = NA_character_,
  sg_ue     = sub("^0+", "", utf(z$SG_UE)),
  id_pessoa = NA_integer_,
  gen       = ifelse(utf(z$DS_GENERO) == "FEMININO", "Mulher", "Homem"),
  partido   = utf(z$SG_PARTIDO),
  cod_ocup  = utf(z$CD_OCUPACAO),
  superior  = utf(z$DS_GRAU_INSTRUCAO) == "SUPERIOR COMPLETO",
  raca      = toupper(utf(z$DS_COR_RACA)),
  stringsAsFactors = FALSE)

regiao_uf <- c(
  AC="Norte", AP="Norte", AM="Norte", PA="Norte", RO="Norte", RR="Norte", TO="Norte",
  AL="Nordeste", BA="Nordeste", CE="Nordeste", MA="Nordeste", PB="Nordeste",
  PE="Nordeste", PI="Nordeste", RN="Nordeste", SE="Nordeste",
  DF="Centro-Oeste", GO="Centro-Oeste", MT="Centro-Oeste", MS="Centro-Oeste",
  ES="Sudeste", MG="Sudeste", RJ="Sudeste", SP="Sudeste",
  PR="Sul", RS="Sul", SC="Sul")
novo$regiao <- unname(regiao_uf[novo$uf])

novo$raca[novo$raca %in% c("", "NÃO INFORMADO", "NAO INFORMADO", "NA", "#NULO#")] <- NA
novo$raca_bin <- ifelse(novo$raca == "BRANCA", "Branca",
                 ifelse(novo$raca %in% c("PRETA", "PARDA"), "Negra", NA_character_))

# ---- a medida, pelo próprio pacote -----------------------------------------
# `checa_cobertura()` ERRA se algum código de 2026 não estiver no dicionário.
# É o guarda desenhado para isso, e é aqui que ele tem de disparar: um código
# novo do TSE precisa de curadoria, não de contorno.
checa_cobertura(novo$cod_ocup)

novo$classe    <- tse_para_classe(novo$cod_ocup, ano = rep(2026L, n26))
novo$estrato   <- tse_para_estrato(novo$cod_ocup, ano = rep(2026L, n26))
novo$comp_alta <- tse_para_componente_alta(novo$cod_ocup, ano = rep(2026L, n26))
novo$isei      <- tse_para_isei(novo$cod_ocup, ano = rep(2026L, n26))
novo$isei08    <- tse_para_isei08(novo$cod_ocup, ano = rep(2026L, n26))
novo$pol_ocup  <- tse_para_politico(novo$cod_ocup, ano = rep(2026L, n26))
novo$classe[is.na(novo$classe)]   <- "Não informado"
novo$estrato[is.na(novo$estrato)] <- "Fora da PEA / não informado"

# ---- o que a safra aberta não tem, e o patrimônio (ver cabeçalho) ----------
novo$eleito          <- NA
# `eleito_v1`, `eleito_1t` e `prest_contas` saíram do contrato de colunas na
# migração para a v3: os dois primeiros eram artefato do reparo manual de
# segundo turno, que a base nova resolve por linha, e o terceiro não tem fonte
# na base nova. Nenhum era consumido por `05_gera_validacao.R`.
novo$ja_eleito_antes <- NA
novo$estreante       <- NA
novo$reeleicao_tse   <- utf(z$cc_st_reeleicao)
novo$votos           <- NA_real_
novo$zero_votos      <- NA
novo$laranja_flag    <- NA
novo$patrim          <- NA_real_
novo$patrim_w        <- NA_real_
novo$tem_bens        <- FALSE

# ---- alinha ao contrato de colunas da microbase antiga ---------------------
falta <- setdiff(names(m), names(novo))
if (length(falta)) {
  message("colunas preenchidas com NA em 2026: ", paste(falta, collapse = ", "))
  for (k in falta) novo[[k]] <- m[[k]][NA_integer_][seq_len(n26)]
}
sobra <- setdiff(names(novo), names(m))
if (length(sobra)) stop("2026 tem coluna que a microbase não tem: ",
                        paste(sobra, collapse = ", "), call. = FALSE)
novo <- novo[, names(m), drop = FALSE]
for (k in names(m)) {
  if (is.logical(m[[k]]) && !is.logical(novo[[k]])) novo[[k]] <- as.logical(novo[[k]])
  if (is.integer(m[[k]]) && !is.integer(novo[[k]])) novo[[k]] <- as.integer(novo[[k]])
  if (is.character(m[[k]]) && !is.character(novo[[k]])) novo[[k]] <- as.character(novo[[k]])
  if (is.numeric(m[[k]]) && !is.numeric(novo[[k]])) novo[[k]] <- as.numeric(novo[[k]])
}

saida <- rbind(m, novo)
stopifnot(nrow(saida) == nrow(m) + n26, identical(names(saida), names(m)))

dir.create(dirname(SAIDA), showWarnings = FALSE, recursive = TRUE)
saveRDS(saida, SAIDA)

message(sprintf("gravado: %s", SAIDA))
message(sprintf("  %s linhas (%s de 1998-2024 + %s de 2026)",
                format(nrow(saida), big.mark = " "), format(nrow(m), big.mark = " "),
                format(n26, big.mark = " ")))
message(sprintf("  2026: %.1f%% mulheres, %.1f%% superior completo, patrimônio NA por construção",
                100 * mean(novo$gen == "Mulher"),
                100 * mean(novo$superior, na.rm = TRUE)))
