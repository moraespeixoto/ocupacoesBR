# ============================================================================
# 02_gera_cbo.R — a perna CBO: CBO-2002 e CBO-94 -> ISCO-88
# ----------------------------------------------------------------------------
# FONTE: tábua oficial de conversão CBO2002-CBO94-CIUO88 do Ministério do
# Trabalho, consultada em
#   http://www.mtecbo.gov.br/cbosite/pages/tabua/FiltroConversao_CBO2002_CBO94_CIUO88.jsf
# A própria página informa que, sem código, devolve a tábua inteira; mas o
# paginador do site repete páginas e a varredura global sai incompleta. A cópia
# em inst/extdata/fontes/tabua_oficial.csv foi obtida consultando **família por
# família** (as 616 famílias de 4 dígitos da CBO-2002), o que torna a cobertura
# verificável: toda linha devolvida pertence à família pedida.
#
# LIMITE DA FONTE, não do pacote: a tábua é uma conversão CBO2002<->CBO94, de
# modo que só cobre as ocupações da CBO-2002 que têm contraparte na CBO-94.
# Ocupações criadas na revisão de 2002 não têm correspondência oficial com a
# CIUO-88 e ficam de fora. O script mede essa cobertura e a documenta.
#
# Rodar DEPOIS de 01_gera_dados.R (precisa de isco88_medidas):
#   Rscript data-raw/02_gera_cbo.R
# ============================================================================

FONTES <- "inst/extdata/fontes"

.e_sentinela_gera <- function(v) grepl("^0*-\\s*1$", v) | v == "999999"
load("data/isco88_medidas.rda")

tb <- read.csv(file.path(FONTES, "tabua_oficial.csv"),
               colClasses = "character", encoding = "UTF-8")
stopifnot(all(c("cbo2002", "titulo_cbo2002", "cbo94", "ciuo88") %in% names(tb)),
          nrow(tb) > 1000)

# ---- normalização dos códigos ----------------------------------------------
# CBO-2002 aparece como "1111-05" no site e como "111105" nos microdados
# (RAIS, CAGED, eSocial). Guardamos a forma sem hífen, de seis dígitos.
tb$cbo2002 <- gsub("\\D", "", tb$cbo2002)
tb$isco88  <- sprintf("%04d", as.integer(tb$ciuo88))
tb$familia <- substr(tb$cbo2002, 1, 4)
# CBO-94 é "2-11.20" no site; nos microdados antigos, "21120".
tb$cbo94   <- gsub("\\D", "", tb$cbo94)

stopifnot(all(nchar(tb$cbo2002) == 6), !anyDuplicated(tb$cbo2002))

# ---- validação dura contra a tabela de medidas ------------------------------
fora <- setdiff(unique(tb$isco88), isco88_medidas$isco88)
if (length(fora))
  stop("CIUO-88 da tábua do MTE ausente da tabela do ISMF: ",
       paste(fora, collapse = ", "),
       "\nIsso indica erro de leitura da tábua, não uma lacuna real.")

# ---- nível de ocupação (6 dígitos) ------------------------------------------
cbo2002_isco88 <- data.frame(
  cbo2002 = tb$cbo2002, titulo = tb$titulo_cbo2002,
  familia = tb$familia, cbo94 = tb$cbo94, isco88 = tb$isco88,
  stringsAsFactors = FALSE)
cbo2002_isco88 <- cbo2002_isco88[order(cbo2002_isco88$cbo2002), ]
rownames(cbo2002_isco88) <- NULL

# ---- nível de família (4 dígitos) -------------------------------------------
# Muito microdado só publica a família. A tábua é por ocupação, então a família
# recebe o ISCO MAJORITÁRIO entre as suas ocupações — e o pacote devolve junto a
# concordância, para que ninguém use uma família dividida sem saber.
# O DENOMINADOR tem de ser o tamanho REAL da familia, nao o numero de ocupacoes
# que a tabua do MTE por acaso cobre. Sem isso, 131 das 436 familias tinham UMA
# ocupacao vista e reportavam concordancia = 1.000 — o valor que sinaliza
# "sem ambiguidade nenhuma" — quando a evidencia era de um caso so.
# Fonte do denominador: dominio oficial da aba `cbo2002ocupacao` do layout do
# Novo CAGED, 2.777 ocupacoes (o sentinela 999999 ja excluido).
dominio <- readLines(file.path(FONTES, "cbo2002_dominio.txt"), warn = FALSE)
dominio <- trimws(dominio); dominio <- dominio[nzchar(dominio)]
# 999999 = "Nao Identificado" no Novo CAGED. E sentinela, nao ocupacao: contado
# como ocupacao ele inflaria o denominador e inventaria a familia "9999".
dominio <- dominio[!.e_sentinela_gera(dominio)]
stopifnot(length(dominio) > 2700, all(nchar(dominio) == 6L))
tam_real <- table(substr(dominio, 1, 4))

agg <- split(cbo2002_isco88$isco88, cbo2002_isco88$familia)
cbo2002_familia_isco88 <- do.call(rbind, lapply(names(agg), function(f) {
  v <- agg[[f]]; tt <- sort(table(v), decreasing = TRUE)
  n_cbo <- as.integer(tam_real[f])
  cob   <- if (is.na(n_cbo)) NA_real_ else round(min(1, length(v) / n_cbo), 3)
  vista <- round(as.integer(tt[1]) / length(v), 3)
  # `empate` marca as familias em que a moda NAO e maioria: o codigo escolhido
  # so venceu por ordem alfabetica, e tratar a familia como uma posicao unica e
  # arbitrario. Sem esta coluna, `concordancia = 0.5` nao distingue "dividida"
  # de "cara ou coroa".
  data.frame(familia = f, isco88 = names(tt)[1],
             n_ocupacoes = length(v), n_ocupacoes_cbo = n_cbo,
             cobertura_familia = cob, n_isco_distintos = length(tt),
             # a concordancia so e afirmavel quando a familia foi vista INTEIRA;
             # a parcial fica em `concordancia_vista`, sem posar de diagnostico
             concordancia = if (!is.na(cob) && cob >= 1) vista else NA_real_,
             concordancia_vista = vista,
             empate = length(tt) > 1L && tt[1] == tt[2],
             stringsAsFactors = FALSE)
}))
rownames(cbo2002_familia_isco88) <- NULL

# ---- CBO-94 -> ISCO-88 (de brinde, para microdado anterior a 2003) ----------
# CBO-94: a tabua e 1:1 com a CBO-2002 (cada linha traz um par), de modo que
# nao ha o que agregar. A versao anterior calculava uma "concordancia" que era
# constante 1 por construcao e sugeria um diagnostico inexistente.
c94 <- tb[tb$cbo94 != "", c("cbo94", "isco88")]
c94 <- c94[!duplicated(c94$cbo94), ]
cbo94_isco88 <- data.frame(cbo94 = c94$cbo94, isco88 = c94$isco88,
                           stringsAsFactors = FALSE)
cbo94_isco88 <- cbo94_isco88[order(cbo94_isco88$cbo94), ]
rownames(cbo94_isco88) <- NULL

# ---- escada hierarquica da CBO (6d -> 4d -> 3d -> 2d) -----------------------
# A tabua do MTE so cobre ocupacoes presentes TAMBEM na CBO-94, o que deixa
# metade da CBO-2002 sem correspondencia — e o buraco nao e aleatorio: cai sobre
# o que foi CRIADO em 2002 (TI em peso, pesquisadores) e sobre todo o grande
# grupo 0. Um vinculo de RAIS nesses codigos volta NA hoje.
#
# A escada sobe a hierarquia da propria CBO: se a ocupacao de 6 digitos nao esta
# na tabua, olha-se a familia de 4; depois o subgrupo de 3; depois o subgrupo
# principal de 2. Em cada nivel, se as ocupacoes MAPEADAS sob aquele prefixo nao
# concordam num unico ISCO, usa-se o ancestral comum delas na hierarquia da
# ISCO — que e a forma "arredondada" que o proprio ISMF publica (2211 e 2212
# viram 2210; 2210 e 2230 viram 2200). Nao ha invencao: so se sobe ate onde a
# fonte permite afirmar.
.isco_comum <- function(v) {
  v <- unique(v[!is.na(v)])
  if (!length(v)) return(NA_character_)
  if (length(v) == 1L) return(v)
  pre <- ""
  for (k in seq_len(min(nchar(v)))) {
    pk <- substr(v, 1, k)
    if (length(unique(pk)) > 1L) break
    pre <- pk[1]
  }
  if (!nzchar(pre)) return(NA_character_)
  formatC(as.integer(pre) * 10L^(4L - nchar(pre)), width = 4, flag = "0",
          format = "d")
}

cbo2002_escada <- do.call(rbind, lapply(c(4L, 3L, 2L), function(k) {
  pre <- substr(cbo2002_isco88$cbo2002, 1, k)
  ag  <- split(cbo2002_isco88$isco88, pre)
  data.frame(prefixo = names(ag), nivel = k,
             isco88  = vapply(ag, .isco_comum, character(1), USE.NAMES = FALSE),
             n_base  = lengths(ag), stringsAsFactors = FALSE)
}))
# so vale o destino que existe na tabua de medidas: sem ISEI, o degrau nao serve
load("data/isco88_medidas.rda")
cbo2002_escada <- cbo2002_escada[
  !is.na(cbo2002_escada$isco88) &
  cbo2002_escada$isco88 %in% isco88_medidas$isco88, ]
rownames(cbo2002_escada) <- NULL

usethis::use_data(cbo2002_isco88, cbo2002_familia_isco88, cbo94_isco88,
                  cbo2002_escada,
                  overwrite = TRUE)

# ---- relatório de cobertura, para a documentação ----------------------------
message(sprintf("CBO-2002: %d ocupações mapeadas em %d famílias",
                nrow(cbo2002_isco88), nrow(cbo2002_familia_isco88)))
message(sprintf("famílias homogêneas (um só ISCO): %d de %d (%.0f%%)",
                sum(cbo2002_familia_isco88$n_isco_distintos == 1),
                nrow(cbo2002_familia_isco88),
                100 * mean(cbo2002_familia_isco88$n_isco_distintos == 1)))
message(sprintf("famílias vistas INTEIRAS (concordância afirmável): %d de %d",
                sum(cbo2002_familia_isco88$cobertura_familia >= 1, na.rm = TRUE),
                nrow(cbo2002_familia_isco88)))
message(sprintf("CBO-94: %d códigos mapeados", nrow(cbo94_isco88)))
