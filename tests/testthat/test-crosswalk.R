test_that("a tradução TSE -> ISCO cobre o dicionário e respeita NA", {
  expect_equal(tse_para_isco(111), "2221")
  expect_equal(tse_para_isco("111"), "2221")   # texto e número dão o mesmo
  expect_equal(tse_para_isco("0111"), "2221")  # zero à esquerda não atrapalha
  expect_true(is.na(tse_para_isco(0)))         # "não informada" não é ocupação
  expect_length(tse_para_isco(c(111, 169, 257)), 3)
})

test_that("todo ISCO do dicionário tem ISEI e ponte para a ISCO-08", {
  isco <- stats::na.omit(tse_isco$isco88)
  expect_true(all(isco %in% isco88_medidas$isco88))
  expect_true(all(isco %in% isco88_isco08$isco88))
  expect_false(any(is.na(
    isco88_medidas$isei88[match(isco, isco88_medidas$isco88)])))
})

test_that("checa_cobertura falha em voz alta com código desconhecido", {
  expect_invisible(checa_cobertura(c(111, 169), silencioso = TRUE))
  expect_error(checa_cobertura(c(111, 99999)), "sem entrada no dicion")
})

test_that("a tabua do ISMF mantem a hierarquia esperada", {
  # Complementa test-armadilha.R, que testa o DICIONARIO. Aqui so a tabua.
  elementares <- isco88_medidas[substr(isco88_medidas$isco88, 1, 1) == "9", ]
  expect_lt(mean(elementares$isei88, na.rm = TRUE), 35)
  expect_gt(mean(isco88_medidas$isei88[
    substr(isco88_medidas$isco88, 1, 1) == "2"], na.rm = TRUE), 60)
})

test_that("checa_cobertura recusa entrada vazia", {
  expect_error(checa_cobertura(NULL), "NULL")
  expect_error(checa_cobertura(character(0)), "vazio")
  expect_error(checa_cobertura(c(NA, NA)), "NA")
})

test_that("crosswalk_tse devolve o dicionário inteiro e é consistente", {
  cw <- crosswalk_tse()
  expect_equal(nrow(cw), nrow(tse_isco))
  expect_equal(cw$isei88, tse_para_isei(tse_isco$cod_tse))
  # a particao da classe alta so existe dentro da classe alta
  expect_true(all(is.na(cw$componente_alta[cw$estrato != "Classe alta"])))
  # um unico aviso por codigo desconhecido, nao um por coluna
  w <- character()
  withCallingHandlers(invisible(crosswalk_tse(c(111, 99999))),
    warning = function(x) { w <<- c(w, conditionMessage(x))
                            invokeRestart("muffleWarning") })
  expect_length(w, 1)
  expect_false(any(is.na(cw$componente_alta[cw$estrato == "Classe alta"])))
})

test_that("classes e estratos são mutuamente coerentes", {
  cw <- crosswalk_tse()
  alta <- unique(cw$classe[cw$estrato == "Classe alta"])
  expect_setequal(alta, c("Proprietários e empregadores",
                          "Dirigentes e políticos",
                          "Profissionais de nível superior"))
})

test_that("o corte por escolaridade só move o vínculo público", {
  cod <- c("291", "291", "111")
  sup <- c(TRUE, FALSE, TRUE)
  r <- tse_para_classe(cod, superior = sup)
  expect_equal(r[1], "Vínculo público, superior")
  expect_equal(r[2], "Vínculo público, médio ou menos")
  expect_equal(r[3], tse_para_classe("111"))
  expect_error(tse_para_classe(cod, superior = c(TRUE)), "comprimento")
})

test_that("o residuo esta partido em tres, e todos ficam fora dos estratos", {
  cw <- crosswalk_tse()
  res <- c("Não informado", "Fora da PEA por posição",
           "Inativo com trajetória")
  expect_true(all(res %in% cw$classe))
  # os tres continuam no mesmo estrato residual: a particao nao move nenhuma
  # proporcao de classe alta, media ou popular
  expect_setequal(unique(cw$estrato[cw$classe %in% res]),
                  "Fora da PEA / não informado")
  # todo codigo sem ISCO cai num dos tres residuais OU numa das duas categorias
  # proprias do registro eleitoral (vinculo publico, seguranca) -- nunca fica
  # sem rotulo
  sem_isco <- cw$classe[is.na(cw$isco88)]
  proprias <- c("Vínculo público não especificado",
                "Militares e segurança pública")
  expect_true(all(sem_isco %in% c(res, proprias)))
  # e nenhum codigo COM ISCO cai no residuo
  expect_false(any(cw$classe[!is.na(cw$isco88)] %in% res))
})
