# ============================================================================
# 06_gera_cod.R — a perna do IBGE, e a ponte que faltava de volta
# ----------------------------------------------------------------------------
# Duas tabelas, que juntas abrem a PNAD Contínua e o Censo:
#
#   isco08_isco88 — a ponte REVERSA, de isco0888.sps. O arquivo está no
#     repositório desde sempre e nunca havia sido lido: o parser do 01_ espera
#     `recode @isko (X=Y)` uma vez por linha, e este arquivo traz o `recode` uma
#     única vez seguido de 596 pares soltos, com sinal negativo (marca do SPSS
#     para valor já recodificado). Sem ela, quem entra pela COD alcança o
#     ISEI-08 mas não o ISEI-88 nem o EGP.
#
#   cod_isco08 — a COD (Classificação de Ocupações para Pesquisas Domiciliares)
#     do IBGE, 434 grupos de base. Como a COD é construída sobre a ISCO-08, a
#     correspondência é quase sempre IDENTIDADE: 428 dos 434 códigos existem tal
#     e qual em `isco08_medidas`. Os 6 restantes são adaptações brasileiras e
#     estão decididos abaixo, um a um.
#
# Rodar: Rscript data-raw/06_gera_cod.R
# ============================================================================

FONTES <- "inst/extdata/fontes"

# ---- 1. ponte reversa ISCO-08 -> ISCO-88 -----------------------------------
l <- readLines(file.path(FONTES, "ganzeboom", "isco0888.sps"), warn = FALSE)
m <- regmatches(l, gregexpr("\\(-([0-9]+)=([0-9]+)\\)", l))
pares <- unlist(m)
stopifnot(length(pares) > 500)
num <- regmatches(pares, regexec("\\(-([0-9]+)=([0-9]+)\\)", pares))
isco08_isco88 <- data.frame(
  isco08 = sprintf("%04d", as.integer(vapply(num, `[`, "", 2))),
  isco88 = sprintf("%04d", as.integer(vapply(num, `[`, "", 3))),
  stringsAsFactors = FALSE)
isco08_isco88 <- isco08_isco88[!duplicated(isco08_isco88$isco08), ]
isco08_isco88 <- isco08_isco88[order(isco08_isco88$isco08), ]
rownames(isco08_isco88) <- NULL
message(sprintf("ponte reversa: %d códigos ISCO-08", nrow(isco08_isco88)))

# quantos fecham a ida-e-volta? é propriedade da concordância da OIT, não bug —
# mas precisa aparecer, porque quem faz 88 -> 08 -> 88 não volta ao ponto de
# partida em um terço dos casos.
load("data/isco88_isco08.rda")
volta <- isco08_isco88$isco88[match(isco88_isco08$isco08, isco08_isco88$isco08)]
fecha <- !is.na(volta) & volta == isco88_isco08$isco88
message(sprintf("  ida-e-volta fecha em %d de %d (%.1f%%)",
                sum(fecha), sum(!is.na(volta)), 100 * mean(fecha[!is.na(volta)])))

# ---- 2. COD do IBGE --------------------------------------------------------
if (!requireNamespace("readxl", quietly = TRUE))
  stop("readxl é necessário para reler a estrutura da COD.", call. = FALSE)
x <- as.data.frame(readxl::read_excel(
  file.path(FONTES, "Estrutura_Ocupacao_COD.xls"), col_names = FALSE))
base <- !is.na(x[[4]]) & !is.na(suppressWarnings(as.integer(x[[4]])))
cod <- data.frame(cod = sprintf("%04d", as.integer(x[[4]][base])),
                  titulo = trimws(as.character(x[[5]][base])),
                  stringsAsFactors = FALSE)
stopifnot(!anyDuplicated(cod$cod), nrow(cod) > 400)

load("data/isco08_medidas.rda")
cod$isco08 <- ifelse(cod$cod %in% isco08_medidas$isco08, cod$cod, NA_character_)
cod$correspondencia <- ifelse(!is.na(cod$isco08), "identidade", NA_character_)

# ---- as seis adaptações brasileiras ----------------------------------------
# A COD acrescenta códigos que a ISCO-08 não tem. Cada decisão abaixo é
# editorial e está aqui para ser contestada, não para ser tomada como dado.
#
# POLÍCIA E BOMBEIRO MILITAR (0411, 0412, 0511, 0512). A ISCO-08 põe polícia em
# 5412 e bombeiro em 5411, ambos no grande grupo 5 (serviços protetivos); o
# grande grupo 0 é das forças armadas propriamente ditas. A PM e o BM
# brasileiros são militarizados em ESTATUTO, mas exercem serviço protetivo
# civil — é a função que a classificação mede, não a natureza jurídica do
# vínculo. Daí 54xx e não 0xxx.
#
#   O QUE SE PERDE, e é preciso dizer: a ISCO-08 não distingue oficial de
#   praça dentro de 5411/5412. A COD distingue, e no Brasil essa é uma
#   diferença de status real. Quem precisar dela tem de tratá-la fora do ISEI.
#
# TRABALHADORES DO SEXO (5168) -> 5169, serviços pessoais não classificados
# em outra parte, que é onde a ISCO-08 os aloja.
#
# PESCADORES (6225) -> 6220, o SUBGRUPO. A COD funde numa só rubrica o que a
# ISCO-08 reparte em 6221 (aquicultura), 6222 (pesca costeira), 6223 (pesca de
# alto-mar) e 6224 (caça). Esses quatro vão de ISEI 11 a 21: escolher um seria
# arbitrário, e o subgrupo é a forma arredondada que o próprio ISMF publica.
ADAPTACOES <- data.frame(rbind(
  c("0411", "5412", "adaptacao"),   # oficiais de polícia militar
  c("0412", "5412", "adaptacao"),   # praças de polícia militar
  c("0511", "5411", "adaptacao"),   # oficiais de bombeiro militar
  c("0512", "5411", "adaptacao"),   # praças de bombeiro militar
  c("5168", "5169", "adaptacao"),   # trabalhadores do sexo
  c("6225", "6220", "agregacao")),  # pescadores: subgrupo, não grupo de base
  stringsAsFactors = FALSE)
names(ADAPTACOES) <- c("cod", "isco08", "correspondencia")

i <- match(ADAPTACOES$cod, cod$cod)
stopifnot(!anyNA(i), all(is.na(cod$isco08[i])))
cod$isco08[i]          <- ADAPTACOES$isco08
cod$correspondencia[i] <- ADAPTACOES$correspondencia
stopifnot(all(cod$isco08 %in% isco08_medidas$isco08))

cod_isco08 <- cod[order(cod$cod), c("cod", "titulo", "isco08", "correspondencia")]
rownames(cod_isco08) <- NULL

message(sprintf("COD: %d grupos de base, %d por identidade, %d adaptados",
                nrow(cod_isco08), sum(cod_isco08$correspondencia == "identidade"),
                sum(cod_isco08$correspondencia != "identidade")))
message(sprintf("  com ISEI-08: %d (%.1f%%)",
                sum(cod_isco08$isco08 %in% isco08_medidas$isco08),
                100 * mean(cod_isco08$isco08 %in% isco08_medidas$isco08)))
alc <- sum(cod_isco08$isco08 %in% isco08_isco88$isco08)
message(sprintf("  alcançando a ISCO-88 (e portanto o EGP): %d (%.1f%%)",
                alc, 100 * alc / nrow(cod_isco08)))

usethis::use_data(isco08_isco88, cod_isco08, overwrite = TRUE)
