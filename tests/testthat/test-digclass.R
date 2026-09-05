# Conferencia cruzada contra o DIGCLASS.
#
# Este arquivo NAO viaja no tarball: esta em .Rbuildignore. O DIGCLASS nao e
# distribuido por repositorio nenhum — nem CRAN, nem Bioconductor, nem
# r-universe —, e o R CMD check com _R_CHECK_FORCE_SUGGESTS_ no padrao devolve
# ERROR ("Package suggested but not available") em qualquer maquina que nao o
# tenha instalado. Manter o DIGCLASS em Suggests reprovaria o pacote na entrada
# do CRAN; retirar o teste perderia a unica validacao contra uma implementacao
# independente. A saida e esta: o teste fica no repositorio, roda no
# devtools::test() e no CI, e nao entra no pacote distribuido.
#
# A referencia esta fixada em inst/extdata/PROVENIENCIA.yml, secao
# `conferencia_cruzada`, e data-raw/00_confere_proveniencia.R avisa quando o
# instalado diverge do registrado.

# Versao do DIGCLASS contra a qual a conferencia cruzada foi feita, lida do
# registro de proveniencia — nao digitada aqui, para nao haver duas verdades.
.digclass_registrado <- function() {
  yml <- system.file("extdata", "PROVENIENCIA.yml", package = "ocupacoesBR")
  if (!nzchar(yml)) return(NA_character_)
  l <- readLines(yml, warn = FALSE, encoding = "UTF-8")
  i <- grep("^conferencia_cruzada:", l)
  if (!length(i)) return(NA_character_)
  v <- grep("^\\s*versao:\\s*", l[seq(i, length(l))], value = TRUE)
  if (!length(v)) return(NA_character_)
  trimws(sub("^\\s*versao:\\s*", "", v[1]))
}

test_that("o EGP bate com o DIGCLASS nas OITO celulas de posicao e supervisao", {
  # Validação cruzada contra uma implementação independente da mesma fonte.
  # DIGCLASS é GPL e NÃO é dependência do pacote: entra só como conferência.
  #
  # Antes esta comparação usava só a coluna EGP(0,0) — empregado, sem
  # subordinados —, que é justamente o ramo em que `iskopromo.sps` inteiro é
  # inerte. Todas as regras de supervisão e de posição no emprego, que são o
  # grosso de R/egp.R, ficavam sem validação nenhuma.
  skip_if_not_installed("DIGCLASS")
  # A referencia desta conferencia esta FIXADA em inst/extdata/PROVENIENCIA.yml,
  # secao `conferencia_cruzada`. O DIGCLASS nao vem de repositorio: instala-se
  # do HEAD do GitHub, e portanto pode mudar sob o teste. Se a versao instalada
  # nao for a registrada, a mensagem de falha diz isso — em vez de deixar
  # parecer que foi o ocupacoesBR que mudou.
  ref  <- .digclass_registrado()
  inst <- as.character(utils::packageVersion("DIGCLASS"))
  ctx  <- if (identical(ref, inst)) "" else sprintf(
    " [DIGCLASS instalado %s; a conferencia registrada e contra %s]", inst, ref)
  tab   <- DIGCLASS::all_schemas$isco88_to_egp11
  chave <- sprintf("%04d", as.integer(tab[[1]]))
  # (coluna do DIGCLASS, conta_propria, n_supervisionados)
  celulas <- list(
    list("EGP(0,0)",   FALSE,  0), list("EGP(1,0)",   TRUE,  0),
    list("EGB(0,1)",   FALSE,  1), list("EGB(1,1)",   TRUE,  1),
    list("EGP(0,2-9)", FALSE,  5), list("EGP(1,2-9)", TRUE,  5),
    list("EGP(0,10+)", FALSE, 11), list("EGP(1,10+)", TRUE, 11))
  for (cel in celulas) {
    esperado <- as.integer(tab[[cel[[1]]]])
    obtido <- isco88_para_egp(chave, rotulo = FALSE, avisar = FALSE,
                              conta_propria     = rep(cel[[2]], length(chave)),
                              n_supervisionados = rep(cel[[3]], length(chave)))
    comum <- !is.na(esperado) & !is.na(obtido)
    expect_gt(sum(comum), 500)
    expect_equal(obtido[comum], esperado[comum],
                 info = paste0("celula ", cel[[1]], ctx))
  }
})

test_that("a referencia da conferencia cruzada esta registrada", {
  # Sem este teste, apagar a secao `conferencia_cruzada` do registro nao
  # quebraria nada, e a unica validacao contra implementacao independente
  # voltaria a apontar para um HEAD movel.
  ref <- .digclass_registrado()
  expect_false(is.na(ref))
  expect_match(ref, "^[0-9]+\\.[0-9]+")
  if (requireNamespace("DIGCLASS", quietly = TRUE))
    expect_equal(as.character(utils::packageVersion("DIGCLASS")), ref,
                 info = paste("o DIGCLASS instalado mudou desde a conferencia;",
                              "reveja o teste do EGP e atualize",
                              "inst/extdata/PROVENIENCIA.yml"))
})
