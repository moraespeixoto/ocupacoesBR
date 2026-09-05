# ============================================================================
# 04_gera_rotulos.R — a história do cadastro de ocupações do TSE
# ----------------------------------------------------------------------------
# O TSE publica, ao lado do CD_OCUPACAO, o DS_OCUPACAO: o rótulo da ocupação
# tal como vigia NAQUELA eleição. Ele está 100% preenchido nas 15 eleições de
# 1998 a 2026. Esta é a fonte que o `03_gera_quebra_2002.R` supunha não existir.
#
# O que este script produz:
#
#   tse_ocupacao_rotulos — uma linha por VIGÊNCIA (cod, de, ate, rotulo).
#     Um código que nunca mudou de nome tem uma linha; um que mudou tem uma por
#     período. É a diferença entre um dicionário e a história de um cadastro.
#
#   tse_quebra_2002 — reconstruída a partir dos rótulos, com a coluna `tipo`.
#     A versão anterior tinha 3 códigos, achados por heurística de escolaridade,
#     e seis números digitados à mão. Esta tem todos os que os rótulos revelam.
#
# POR QUE A HEURÍSTICA ANTIGA ERA CEGA: ela comparava a proporção de candidatos
# com ensino superior antes e depois da quebra, e só enxergava reutilização que
# cruzasse a linha do diploma. O código 215 era "OCUPANTE DE CARGO DE DIREÇÃO E
# ASSESSORAMENTO SUPERIOR" até 2000 e virou "ARTISTA PLÁSTICO" a partir de 2006,
# com variação de escolaridade de UM ponto percentual. Invisível para ela.
#
# FONTE: microdados de candidaturas do TSE (consulta_cand), uma safra por
#   arquivo, em `bancos/candidaturas/candidaturas_AAAA.rds` do projeto
#   `novissimos_dados_tse`. Não versionados. Ajuste OCUPACOESBR_TSE_DIR.
#
#   POR QUE UMA SAFRA POR ARQUIVO, e não o `.Rda` monolítico que este script
#   lia até 0.2.1: o monolítico é um agregado que se reconstrói de tempos em
#   tempos e pode estar defasado em relação às safras individuais sem que nada
#   no arquivo o denuncie — em 17/08/2026 ele trazia 15.866 candidaturas de
#   2026 contra as 20.506 do arquivo da safra. Ler as safras é ler a fonte.
#   Custa quatro colunas de memória em vez de 108, e o ano fica explícito no
#   nome do arquivo, de modo que acrescentar uma eleição é acrescentar um
#   arquivo. OCUPACOESBR_TSE_RDA continua honrado, para quem tiver só o .Rda.
#
#   ENCODING: as safras vêm com as strings marcadas `latin1`. Os rótulos são
#   convertidos a UTF-8 na leitura, porque é o que o pacote declara e o que a
#   tabela publicada precisa carregar.
#
#   A SAFRA DE 2026 É ABERTA. O prazo de registro encerrou em 15/08/2026, mas o
#   Tribunal ainda julga e publica candidaturas: DS_SITUACAO_CANDIDATURA é
#   "#NE" em todas as linhas e o volume dos cargos proporcionais está em torno
#   de dois terços do de 2022. Para o que este script faz — qual rótulo cada
#   código levava em cada eleição — isso não atrapalha, porque o rótulo é
#   propriedade do cadastro e não da candidatura. Mas o `n` da tabela é
#   contagem de candidaturas, e o de 2026 há de crescer.
#
# Rodar: Rscript data-raw/04_gera_rotulos.R
# ============================================================================

TSE_DIR <- path.expand(Sys.getenv("OCUPACOESBR_TSE_DIR",
                                  "~/novissimos_dados_tse/bancos/candidaturas"))
TSE_RDA <- Sys.getenv("OCUPACOESBR_TSE_RDA", "")

COLS <- c("ANO_ELEICAO", "CD_OCUPACAO", "DS_OCUPACAO", "DS_GRAU_INSTRUCAO")

if (nzchar(TSE_RDA)) {
  # caminho legado: um único .Rda com todas as safras
  TSE_RDA <- path.expand(TSE_RDA)
  if (!file.exists(TSE_RDA))
    stop("microdados do TSE não encontrados em:\n  ", TSE_RDA, call. = FALSE)
  env <- new.env()
  load(TSE_RDA, envir = env)
  d <- get(ls(env)[1], envir = env)
  fonte <- TSE_RDA
} else {
  if (!dir.exists(TSE_DIR))
    stop("safras do TSE não encontradas em:\n  ", TSE_DIR,
         "\nEste script depende delas e elas não estão no repositório.",
         "\nAponte OCUPACOESBR_TSE_DIR para o diretório das safras",
         " (ou OCUPACOESBR_TSE_RDA para o .Rda agregado).", call. = FALSE)
  arqs <- sort(list.files(TSE_DIR, pattern = "^candidaturas_[0-9]{4}\\.rds$",
                          full.names = TRUE))
  if (!length(arqs)) stop("nenhum candidaturas_AAAA.rds em ", TSE_DIR, call. = FALSE)
  d <- do.call(rbind, lapply(arqs, function(a) {
    x <- readRDS(a)
    falta <- setdiff(COLS, names(x))
    if (length(falta))
      stop("faltam colunas em ", basename(a), ": ", paste(falta, collapse = ", "),
           call. = FALSE)
    x <- as.data.frame(x)[, COLS]
    # latin1 -> UTF-8; ver ENCODING no cabeçalho
    for (k in COLS) if (is.character(x[[k]])) x[[k]] <- enc2utf8(x[[k]])
    x
  }))
  fonte <- TSE_DIR
  message(sprintf("safras lidas: %d (%s)", length(arqs),
                  paste(range(sub(".*_([0-9]{4})\\.rds$", "\\1", arqs)),
                        collapse = "-")))
}
stopifnot(all(c("ANO_ELEICAO", "CD_OCUPACAO", "DS_OCUPACAO") %in% names(d)))

ano <- as.integer(d$ANO_ELEICAO)
cod <- sub("^0+(?=[0-9])", "", trimws(as.character(d$CD_OCUPACAO)), perl = TRUE)
ds  <- trimws(as.character(d$DS_OCUPACAO))
ok  <- !is.na(ano) & !is.na(cod) & nzchar(cod) & nzchar(ds) & ds != "#NULO#"
ano <- ano[ok]; cod <- cod[ok]; ds <- ds[ok]

message(sprintf("fonte: %s", fonte))
message(sprintf("candidaturas com rótulo: %s de %s (%.1f%%)",
                format(sum(ok), big.mark = "."), format(length(ok), big.mark = "."),
                100 * mean(ok)))
message(sprintf("eleições: %d (%s)", length(unique(ano)),
                paste(range(ano), collapse = "-")))

# ---- normalização, só para COMPARAR ----------------------------------------
# O rótulo original é preservado; esta forma existe porque o TSE alterna
# acentuação e caixa entre eleições ("DIRECAO" e "DIREÇÃO" são o mesmo cargo) e
# essas variações não são mudança de cadastro.
norm <- function(x) {
  x <- toupper(iconv(x, to = "ASCII//TRANSLIT"))
  x <- gsub("[^A-Z0-9 ]", " ", x)
  trimws(gsub("\\s+", " ", x))
}
dsn <- norm(ds)

# ---- rótulo modal por (código, ano) ----------------------------------------
# Modal, e não único: há erro de digitação esparso no dado. A moda de milhares
# de candidaturas é robusta a ele.
chave <- paste(cod, ano, sep = "\r")
tab <- table(chave, dsn)
modal <- colnames(tab)[max.col(tab, ties.method = "first")]
part <- do.call(rbind, strsplit(rownames(tab), "\r", fixed = TRUE))
orig <- ds[match(paste(part[, 1], part[, 2], modal, sep = "\r"),
                 paste(cod, ano, dsn, sep = "\r"))]

por_ano <- data.frame(cod = part[, 1], ano = as.integer(part[, 2]),
                      rotulo_n = modal, rotulo = orig,
                      n = as.integer(rowSums(tab)),
                      stringsAsFactors = FALSE)
por_ano <- por_ano[order(por_ano$cod, por_ano$ano), ]

# ---- colapsa anos consecutivos com o mesmo rótulo em VIGÊNCIAS --------------
vig <- do.call(rbind, lapply(split(por_ano, por_ano$cod), function(g) {
  muda <- c(TRUE, g$rotulo_n[-1] != g$rotulo_n[-nrow(g)])
  bloco <- cumsum(muda)
  do.call(rbind, lapply(split(g, bloco), function(b) data.frame(
    cod = b$cod[1], de = min(b$ano), ate = max(b$ano),
    rotulo = b$rotulo[1], rotulo_n = b$rotulo_n[1], n = sum(b$n),
    stringsAsFactors = FALSE)))
}))
rownames(vig) <- NULL
vig <- vig[order(vig$cod, vig$de), ]
tse_ocupacao_rotulos <- vig[, c("cod", "de", "ate", "rotulo", "n")]
names(tse_ocupacao_rotulos)[1] <- "cod_tse"
rownames(tse_ocupacao_rotulos) <- NULL

message(sprintf("vigências: %d, para %d códigos distintos",
                nrow(tse_ocupacao_rotulos),
                length(unique(tse_ocupacao_rotulos$cod_tse))))

# ---- a quebra de 2002, pelos rótulos ---------------------------------------
# Compara o rótulo do último ano ATÉ 2000 com o do primeiro ano A PARTIR de
# 2002, para os códigos presentes nos dois períodos.
jaccard <- function(a, b) {
  A <- unique(strsplit(a, " ")[[1]]); B <- unique(strsplit(b, " ")[[1]])
  length(intersect(A, B)) / length(union(A, B))
}

velho <- por_ano[por_ano$ano <= 2000, ]
novo  <- por_ano[por_ano$ano >= 2002, ]
velho <- velho[!duplicated(velho$cod, fromLast = TRUE), ]   # último até 2000
novo  <- novo[!duplicated(novo$cod), ]                      # primeiro após 2002
m <- merge(velho, novo, by = "cod", suffixes = c("_ate2000", "_apos2002"))
# ATENCAO ao denominador, de novo: `velho` guarda UM ano por codigo (o ultimo
# ate 2000), entao o `n` que veio no merge conta so aquela eleicao. A coluna
# publicada `n_ate_2000` diz "candidaturas com esse codigo ate 2000", que e a
# SOMA de 1998 e 2000 — e ate a auditoria de 05/09/2026 ela trazia so 2000,
# subestimando em 7,8% o total dos reutilizados (1.628 em vez de 1.755) e
# contradizendo o proprio cabecalho deste script, que documenta 52.090 para o
# 601 enquanto a coluna carregava 51.953.
soma_ate2000 <- tapply(por_ano$n[por_ano$ano <= 2000],
                       por_ano$cod[por_ano$ano <= 2000], sum)
m$n_ate2000 <- as.integer(soma_ate2000[as.character(m$cod)])
m$jac <- mapply(jaccard, m$rotulo_n_ate2000, m$rotulo_n_apos2002)
mudou <- m[m$rotulo_n_ate2000 != m$rotulo_n_apos2002, ]

# ---- o segundo sinal: a população sob o código mudou? -----------------------
# A escolaridade das candidaturas SOBE ao longo do período (expansão do ensino
# superior). Um código que acompanha a tendência geral guardou a mesma
# população; um que DESABA passou a designar outra gente.
sup <- grepl("SUPERIOR COMPLETO", toupper(as.character(d$DS_GRAU_INSTRUCAO)))[ok]
per <- ifelse(ano <= 2000, 1L, ifelse(ano >= 2002, 2L, NA_integer_))
tend <- 100 * (mean(sup[per %in% 2L]) - mean(sup[per %in% 1L]))
pct <- function(cs, p) vapply(cs, function(c)
  100 * mean(sup[per %in% p & cod == c]), numeric(1))
mudou$pct_superior_ate_2000  <- round(pct(mudou$cod, 1L), 1)
mudou$pct_superior_apos_2002 <- round(pct(mudou$cod, 2L), 1)
mudou$delta_pp <- round(mudou$pct_superior_apos_2002 -
                        mudou$pct_superior_ate_2000, 1)
# o que importa não é o delta bruto, e sim o quanto ele se afasta da tendência
mudou$delta_vs_tendencia <- round(mudou$delta_pp - tend, 1)
message(sprintf("tendência geral de ensino superior, 1998-2000 -> 2002-2026: %+.1f pp",
                tend))

# ---- `tipo`: JULGAMENTO CURADO, com as duas evidências ao lado --------------
# NENHUM dos dois sinais basta, e a interseção deles também não:
#
#   601 "TRABALHADOR AGRÍCOLA" -> "AGRICULTOR" muda todo o léxico e é o MESMO
#       ofício; a população sob o código nem se mexe (+2,2 pp, abaixo da
#       tendência). Marcá-lo como reutilizado mandaria descartar 50.139
#       candidaturas válidas.
#
#   215 "OCUPANTE DE CARGO DE DIREÇÃO E ASSESSORAMENTO SUPERIOR" -> "ARTISTA
#       PLÁSTICO" é reutilização inequívoca e NÃO move a escolaridade (+6,5 pp):
#       um DAS e um artista plástico têm perfil de diploma parecido. É por isso
#       que a heurística anterior, que só olhava escolaridade, não o via.
#
# A distinção é SEMÂNTICA, e nenhuma métrica automática a alcança. São 44 casos:
# poucos o bastante para julgar um a um. O julgamento é editorial e está
# declarado como tal — mas é auditável linha a linha, porque os dois rótulos
# viajam na própria tabela, ao lado das duas evidências.
#
#   reutilizado — o código passou a designar OUTRA ocupação. Classificar o
#                 período antigo pelo dicionário novo está errado.
#   renomeado   — mesma ocupação, nome novo. Não é problema; está aqui para que
#                 ninguém a confunda com reutilização ao comparar rótulos.
#   redefinido  — o escopo mudou (fundiu-se, dividiu-se, deslocou-se). Cautela.
#   refinado    — mesmo posto, rótulo mais preciso.
REUTILIZADOS <- c(
  "211",  # PROCURADOR/ADVOGADO DE OFICIO -> ESTIVADOR        (-83,9 pp)
  "214",  # DELEGADO DE POLICIA           -> ESCULTOR E PINTOR (-84,7 pp)
  "216",  # OFICIAIS DAS FORCAS ARMADAS   -> EMBALADOR         (-64,1 pp)
  "215",  # DAS SUPERIOR -> ARTISTA PLASTICO   (escolaridade nao denuncia)
  "391",  # CHEFE INTERMEDIARIO -> TAQUIGRAFO E ESTENOGRAFO
  "158",  # DESENHISTA TECNICO  -> TECNICO EM INFORMATICA
  "521")  # GOVERNANTA DE HOTEL, CAMAREIRO, PORTEIRO, COZINHEIRO, GARCOM
          #   -> GOVERNANTA  (o codigo perdeu quatro das cinco ocupacoes)
RENOMEADOS <- c(
  "601",  # TRABALHADOR AGRICOLA    -> AGRICULTOR
  "602",  # TRABALHADOR DA PECUARIA -> PECUARISTA
  "604",  # TRABALHADOR DA PESCA    -> PESCADOR
  "295")  # MILITAR EM GERAL        -> MEMBRO DAS FORCAS ARMADAS
mudou$tipo <- ifelse(mudou$cod %in% REUTILIZADOS, "reutilizado",
              ifelse(mudou$cod %in% RENOMEADOS,   "renomeado",
              ifelse(mudou$jac < 0.50,            "redefinido", "refinado")))

# Trava: um colapso de escolaridade que NAO esteja marcado como reutilizado e
# quase certamente um caso que a curadoria deixou passar.
#
# O piso de 30 candidaturas em CADA periodo nao e decorativo. Sem ele a trava
# disparou no codigo 128 ("ASTRONOMO E METEOROLOGISTA" -> "ASTRONOMO"), que tem
# n = 1 em 1998 e n = 1 em 2000: um caso de 100% para outro de 0% nao e colapso,
# e ruido. E o mesmo piso que a versao anterior deste script ja usava.
mudou$n_apos2002 <- vapply(mudou$cod,
                           function(c) sum(per %in% 2L & cod == c), numeric(1))
avaliavel <- mudou$n_ate2000 >= 30 & mudou$n_apos2002 >= 30
susp <- mudou$cod[avaliavel & mudou$delta_vs_tendencia < -40 &
                  mudou$tipo != "reutilizado"]
if (length(susp))
  stop("codigo(s) com colapso de escolaridade fora da curadoria: ",
       paste(susp, collapse = ", "), call. = FALSE)
# onde o sinal nao e avaliavel, o proprio dado tem de dizer isso
mudou$delta_vs_tendencia[!avaliavel] <- NA_real_

tse_quebra_2002 <- data.frame(
  cod_tse                = mudou$cod,
  rotulo_ate_2000        = mudou$rotulo_ate2000,
  rotulo_apos_2002       = mudou$rotulo_apos2002,
  ultimo_ano_antigo      = mudou$ano_ate2000,
  primeiro_ano_novo      = mudou$ano_apos2002,
  n_ate_2000             = mudou$n_ate2000,
  similaridade           = round(mudou$jac, 3),
  pct_superior_ate_2000  = mudou$pct_superior_ate_2000,
  pct_superior_apos_2002 = mudou$pct_superior_apos_2002,
  delta_pp               = mudou$delta_pp,
  delta_vs_tendencia     = mudou$delta_vs_tendencia,
  tipo                   = mudou$tipo,
  stringsAsFactors = FALSE)
tse_quebra_2002 <- tse_quebra_2002[order(tse_quebra_2002$similaridade,
                                         -tse_quebra_2002$n_ate_2000), ]
rownames(tse_quebra_2002) <- NULL

message(sprintf("quebra de 2002: %d códigos com rótulo alterado (%s)",
                nrow(tse_quebra_2002),
                paste(sprintf("%s: %d", names(table(tse_quebra_2002$tipo)),
                              table(tse_quebra_2002$tipo)), collapse = ", ")))
message(sprintf("  candidaturas até 2000 atingidas: %s",
                format(sum(tse_quebra_2002$n_ate_2000), big.mark = ".")))

# ---- inventário: o que sumiu e o que nasceu em 2002 ------------------------
# Esta é a parte que a versão anterior não tratava, e que atinge MUITO mais
# candidaturas do que a reutilização: quem monta série 1998-2024 mede
# "Proprietários e empregadores" com dois vocabulários incomensuráveis.
so_velho <- setdiff(velho$cod, novo$cod)
so_novo  <- setdiff(novo$cod, velho$cod)
# ATENÇÃO ao denominador: `velho`/`novo` guardam só um ano por código (o último
# até 2000, o primeiro após 2002). Para dizer quantas CANDIDATURAS o inventário
# atinge é preciso somar o período inteiro, e não esse ano isolado.
n_ate2000 <- sum(por_ano$n[por_ano$ano <= 2000])
n_apos    <- sum(por_ano$n[por_ano$ano >= 2002])
n_ext <- sum(por_ano$n[por_ano$ano <= 2000 & por_ano$cod %in% so_velho])
n_nov <- sum(por_ano$n[por_ano$ano >= 2002 & por_ano$cod %in% so_novo])
message(sprintf("  códigos extintos após 2000: %d, com %s candidaturas até 2000 (%.1f%% do período)",
                length(so_velho), format(n_ext, big.mark = " "),
                100 * n_ext / n_ate2000))
message(sprintf("  códigos criados em 2002+: %d, com %s candidaturas depois (%.1f%% do período)",
                length(so_novo), format(n_nov, big.mark = " "),
                100 * n_nov / n_apos))

usethis::use_data(tse_ocupacao_rotulos, tse_quebra_2002, overwrite = TRUE)
