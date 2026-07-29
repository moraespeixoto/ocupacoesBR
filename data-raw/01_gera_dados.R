# ============================================================================
# 01_gera_dados.R — gera TODOS os objetos de dados do pacote a partir das fontes
# ----------------------------------------------------------------------------
# REGRA DO PACOTE: nenhuma tabela é digitada à mão. Tudo é parseado dos arquivos
# originais guardados em inst/extdata/fontes/, para que qualquer valor possa ser
# rastreado até a sua fonte e reconferido.
#
# FONTES
#   inst/extdata/fontes/ganzeboom/*.sps
#     Sintaxes SPSS do International Stratification and Mobility File (ISMF),
#     de Harry B. G. Ganzeboom e Donald J. Treiman, distribuídas publicamente em
#     http://www.harryganzeboom.nl/ismf/index.htm
#       iskoroot.sps  ISCO-88 -> EGP (tabela-base)
#       iskopromo.sps ajustes de ISCO por status/supervisão (pré-EGP)
#       iskoegp.sps   regras finais do EGP (usa SEMPL e SUPVIS)
#       iskoisei.sps  ISCO-88 -> ISEI-88
#       iskotrei.sps  ISCO-88 -> SIOPS (prestígio de Treiman)
#       iskolab.sps   rótulos de ISCO-88
#       isco8808.sps  ISCO-88 -> ISCO-08 (a parte decimal = nº de alternativas
#                     definidas pela OIT; ambiguidade da ponte, preservada aqui)
#       isqoisei08.sps ISCO-08 -> ISEI-08
#       isqotrei08.sps ISCO-08 -> SIOPS-08
#
#   inst/extdata/fontes/isei_ocupacao.R, classe_ocupacao.R
#     Dicionário TSE -> ISCO-88 e o esquema de classes/estratos, construídos no
#     projeto de origem e documentados em PARECERES/MEMO_DECISOES_MEDIDA.md.
#
# Rodar:  Rscript data-raw/01_gera_dados.R
# ============================================================================

FONTES <- "inst/extdata/fontes"
G      <- file.path(FONTES, "ganzeboom")

# ---- utilitários de parse ---------------------------------------------------
# Todos os módulos do ISMF têm a mesma forma:
#   recode @<origem> ( <codigo> = <valor> ) into @<destino>.
le_recode <- function(arquivo, nome_valor = "valor", numerico = TRUE) {
  l <- readLines(file.path(G, arquivo), warn = FALSE, encoding = "UTF-8")
  m <- regmatches(l, regexec(
    "^\\s*recode\\s+@\\w+\\s*\\(\\s*([0-9]+)\\s*=\\s*([0-9.]+)\\s*\\)", l))
  ok <- lengths(m) == 3
  if (!any(ok)) stop("nenhuma linha 'recode' reconhecida em ", arquivo)
  d <- data.frame(codigo = sprintf("%04d", as.integer(sapply(m[ok], `[`, 2))),
                  valor  = sapply(m[ok], `[`, 3), stringsAsFactors = FALSE)
  if (numerico) d$valor <- as.numeric(d$valor)
  names(d)[2] <- nome_valor
  d[!duplicated(d$codigo), ]
}

le_rotulos <- function(arquivo) {
  l <- readLines(file.path(G, arquivo), warn = FALSE, encoding = "UTF-8")
  # o `.` final da ultima linha do .sps (`9333 'freight handlers'.`) fazia o
  # ancoramento em `'$` descartar o rotulo em silencio
  m <- regmatches(l, regexec("^\\s*([0-9]{3,4})\\s+'(.*)'\\s*\\.?\\s*$", l))
  ok <- lengths(m) == 3
  data.frame(codigo = sprintf("%04d", as.integer(sapply(m[ok], `[`, 2))),
             rotulo = trimws(sapply(m[ok], `[`, 3)), stringsAsFactors = FALSE)
}

# ---- 1. ISCO-88: ISEI, SIOPS, EGP-base, rótulos -----------------------------
isei88_tab  <- le_recode("iskoisei.sps", "isei88")
siops88_tab <- le_recode("iskotrei.sps", "siops88")
egp_base    <- le_recode("iskoroot.sps", "egp")
egp_base$egp <- as.integer(egp_base$egp)
rot88       <- le_rotulos("iskolab.sps")

isco88 <- merge(isei88_tab, siops88_tab, by = "codigo", all = TRUE)
isco88 <- merge(isco88, egp_base, by = "codigo", all = TRUE)
# all = TRUE tambem no lado dos rotulos: com all.x, codigos que so existem em
# iskolab.sps (0110, forcas armadas) desapareciam da tabela por completo.
isco88 <- merge(isco88, rot88, by = "codigo", all = TRUE)
names(isco88)[1] <- "isco88"

# ---- 2. ponte ISCO-88 -> ISCO-08, preservando a ambiguidade da OIT ----------
# "DECIMAL DENOTES NUMBER OF ALTERNATIVES DEFINED BY ILO. IF NO FURTHER
# INFORMATION AVAILABLE, TRUNCATE DECIMAL." Guardamos as duas coisas: o código
# truncado e quantas alternativas a OIT admitia — quem usa a ponte precisa saber
# onde ela é ambígua.
l  <- readLines(file.path(G, "isco8808.sps"), warn = FALSE, encoding = "UTF-8")
m  <- regmatches(l, regexec(
  "^\\s*recode\\s+@isko\\s*\\(\\s*([0-9]+)\\s*=\\s*([0-9]+)(?:\\.([0-9]+))?\\s*\\)", l))
ok <- lengths(m) >= 3
ponte <- data.frame(
  isco88 = sprintf("%04d", as.integer(sapply(m[ok], `[`, 2))),
  isco08 = sprintf("%04d", as.integer(sapply(m[ok], `[`, 3))),
  n_alternativas = suppressWarnings(as.integer(sapply(m[ok], `[`, 4))),
  stringsAsFactors = FALSE)
ponte$n_alternativas[is.na(ponte$n_alternativas)] <- 1L
ponte <- ponte[!duplicated(ponte$isco88), ]

# codigos que so aparecem na ponte (0100, 2470) tambem entram na tabela de
# medidas, com valores NA, para que `isco88_medidas` seja o universo de codigos
# ISCO-88 que o pacote conhece e nao um subconjunto silencioso dele.
so_ponte <- setdiff(ponte$isco88, isco88$isco88)
if (length(so_ponte))
  isco88 <- rbind(isco88, data.frame(isco88 = so_ponte, isei88 = NA_real_,
                                     siops88 = NA_real_, egp = NA_integer_,
                                     rotulo = NA_character_))
isco88 <- isco88[order(isco88$isco88), ]
rownames(isco88) <- NULL

# ---- 3. ISCO-08: ISEI-08 e SIOPS-08 -----------------------------------------
isco08 <- merge(le_recode("isqoisei08.sps", "isei08"),
                le_recode("isqotrei08.sps", "siops08"), by = "codigo", all = TRUE)
names(isco08)[1] <- "isco08"

# ---- 4. dicionário TSE -> ISCO-88 e o esquema de classes --------------------
# Carrega os arquivos do projeto de origem num ambiente isolado e extrai os
# objetos, em vez de duplicar as listas aqui.
# `classe_ocupacao.R` faz source("R/isei_ocupacao.R"); por isso as fontes ficam
# em inst/extdata/fontes/R/ e a leitura roda com o diretório de trabalho ali.
env <- new.env()
suppressMessages(local({
  old <- getwd(); on.exit(setwd(old), add = TRUE)
  setwd(FONTES)
  sys.source("R/classe_ocupacao.R", envir = env)
}))
mapa <- env$.TSE_PARA_ISCO_V2
tse <- data.frame(cod_tse = names(mapa),
                  isco88_raw = unname(mapa), stringsAsFactors = FALSE)
# padroniza o ISCO para 4 dígitos: os códigos de 2 e 3 dígitos são as formas
# "arredondadas" que as tabelas do ISMF já contêm (24 -> 2400, 242 -> 2420).
tse$isco88 <- ifelse(is.na(tse$isco88_raw), NA_character_,
                     formatC(as.integer(tse$isco88_raw) *
                             10^(4 - nchar(tse$isco88_raw)),
                             width = 4, flag = "0", format = "d"))
tse$nivel <- ifelse(is.na(tse$isco88_raw), NA_integer_, nchar(tse$isco88_raw))
tse$politico     <- tse$cod_tse %in% env$.COD_POLITICO_V2
# duas marcas distintas, que ate 07/2026 eram uma so (ver .COD_CONTA_PROPRIA):
#   proprietario  = pertence a classe proprietaria (esquema de classes)
#   conta_propria = trabalha por conta propria (o SEMPL do ISMF, para o EGP)
# O agricultor familiar e a segunda sem ser a primeira.
tse$proprietario  <- tse$cod_tse %in% env$.COD_PROPRIETARIO
tse$conta_propria <- tse$cod_tse %in% env$.COD_CONTA_PROPRIA
tse$classe  <- env$classe_v2(tse$cod_tse)
tse$estrato <- env$estrato_v2(tse$cod_tse)
tse$componente_alta <- env$componente_alta_v2(tse$cod_tse)
tse <- tse[order(tse$cod_tse), c("cod_tse", "isco88", "nivel", "classe",
                                 "estrato", "componente_alta",
                                 "politico", "proprietario", "conta_propria")]
rownames(tse) <- NULL

# ---- 5. checagens que travam a geração se algo quebrar ----------------------
stopifnot(
  nrow(isco88) > 500, nrow(isco08) > 400, nrow(ponte) > 400, nrow(tse) > 250,
  !anyDuplicated(isco88$isco88), !anyDuplicated(isco08$isco08),
  !anyDuplicated(tse$cod_tse),
  all(na.omit(tse$isco88)  %in% isco88$isco88),
  all(na.omit(ponte$isco08) %in% isco08$isco08)
)
faltam <- setdiff(na.omit(tse$isco88), ponte$isco88)
if (length(faltam)) stop("ISCO-88 do TSE sem ponte para ISCO-08: ",
                         paste(faltam, collapse = ", "))

# lacunas conhecidas da FONTE, relatadas em vez de propagadas em silencio
sem_isei <- isco88$isco88[is.na(isco88$isei88)]
sem_ponte <- setdiff(isco88$isco88, ponte$isco88)
message(sprintf("lacunas da fonte: %d ISCO-88 sem ISEI (%s); %d sem ponte 08 (%s)",
                length(sem_isei), paste(sem_isei, collapse = ", "),
                length(sem_ponte), paste(sem_ponte, collapse = ", ")))

tse_isco       <- tse
isco88_medidas <- isco88
isco08_medidas <- isco08
isco88_isco08  <- ponte

usethis::use_data(tse_isco, isco88_medidas, isco08_medidas, isco88_isco08,
                  overwrite = TRUE, internal = FALSE)

message(sprintf(paste0("gerado: %d códigos do TSE | %d ISCO-88 | %d ISCO-08 | ",
                       "%d pares na ponte"),
                nrow(tse), nrow(isco88), nrow(isco08), nrow(ponte)))
message(sprintf("ponte ambígua (>1 alternativa da OIT): %d de %d pares",
                sum(ponte$n_alternativas > 1), nrow(ponte)))
