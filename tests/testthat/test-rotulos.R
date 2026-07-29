# A história do cadastro do TSE: vigências, rótulos e a quebra de 2002.

test_that("as vigências cobrem o dicionário inteiro e não se sobrepõem", {
  r <- tse_ocupacao_rotulos
  expect_equal(nrow(r), 334L)
  expect_setequal(unique(r$cod_tse), tse_isco$cod_tse)   # 275 códigos
  expect_true(all(r$de <= r$ate))
  expect_true(all(r$de >= 1998 & r$ate <= 2024))
  # dentro de um código, as vigências são disjuntas e ordenadas
  for (g in split(r, r$cod_tse))
    if (nrow(g) > 1) {
      g <- g[order(g$de), ]
      expect_true(all(g$de[-1] > g$ate[-nrow(g)]), info = g$cod_tse[1])
    }
})

test_that("o código 215 é o caso que a heurística de escolaridade não vê", {
  # Foi este que motivou reconstruir a tabela: "OCUPANTE DE CARGO DE DIREÇÃO E
  # ASSESSORAMENTO SUPERIOR" até 2000, "ARTISTA PLÁSTICO" a partir de 2006, com
  # variação de escolaridade de ~1 pp. Se este teste cair, ou o dado do TSE
  # mudou, ou alguém trocou a curadoria de `tipo` por uma fórmula.
  v <- tse_vigencia(215)
  expect_equal(nrow(v), 2L)
  expect_match(v$rotulo[1], "ASSESSORAMENTO SUPERIOR")
  expect_match(v$rotulo[2], "ARTISTA PL")
  q <- tse_quebra_2002[tse_quebra_2002$cod_tse == "215", ]
  expect_equal(q$tipo, "reutilizado")
  # e o sinal de escolaridade, sozinho, NÃO o denunciaria
  expect_gt(q$delta_vs_tendencia, -20)
})

test_that("renome não é reutilização", {
  # 601 "TRABALHADOR AGRÍCOLA" -> "AGRICULTOR": mesmo ofício, 50 mil
  # candidaturas. Marcá-lo como reutilizado mandaria descartá-las.
  q <- tse_quebra_2002
  expect_equal(q$tipo[q$cod_tse == "601"], "renomeado")
  expect_gt(q$n_ate_2000[q$cod_tse == "601"], 40000)
  for (cod in c("601", "602", "604", "295"))
    expect_equal(q$tipo[q$cod_tse == cod], "renomeado", info = cod)
  # checa_periodo e o argumento `ano` só reagem a reutilização de verdade
  expect_silent(r <- checa_periodo(c("601", "601"), c(1998, 2020)))
  expect_false(any(r))
  expect_silent(tse_para_classe("601", ano = 1998))
})

test_that("os três códigos da versão anterior continuam marcados", {
  q <- tse_quebra_2002
  for (cod in c("211", "214", "216"))
    expect_true(cod %in% q$cod_tse, info = cod)
  # e agora há mais: quatro das sete reutilizações são invisíveis ao sinal
  # de escolaridade, que era o único método antes
  reut <- q[q$tipo == "reutilizado", ]
  expect_gte(nrow(reut), 7L)
  invisiveis <- sum(is.na(reut$delta_vs_tendencia) |
                    reut$delta_vs_tendencia > -40)
  expect_gte(invisiveis, 4L)
})

test_that("`ano` anula o que estava sob outra ocupação, e só isso", {
  expect_warning(x <- tse_para_classe(c("215", "215"), ano = c(2000, 2020)),
                 "REUTILIZOU")
  expect_true(is.na(x[1]))
  expect_false(is.na(x[2]))
  # sem `ano`, o comportamento antigo é preservado
  expect_silent(y <- tse_para_classe(c("215", "215")))
  expect_false(any(is.na(y)))
  # o mesmo vale para as demais portas
  expect_warning(tse_para_isco("215", ano = 2000), "REUTILIZOU")
  expect_warning(tse_para_estrato("215", ano = 2000), "REUTILIZOU")
  expect_error(tse_para_isco(c("111", "215"), ano = 2000), "comprimento")
})

test_that("tse_diff_cadastro descreve a troca de inventário de 2002", {
  d <- tse_diff_cadastro(2000, 2002)
  expect_setequal(unique(d$mudanca), c("extinto", "criado", "rotulo"))
  expect_gt(sum(d$mudanca == "criado"), sum(d$mudanca == "extinto"))
  # todo extinto tem rótulo do ano 1 e nenhum do ano 2, e vice-versa
  ext <- d[d$mudanca == "extinto", ]
  expect_true(all(!is.na(ext$rotulo_ano1) & is.na(ext$rotulo_ano2)))
  cri <- d[d$mudanca == "criado", ]
  expect_true(all(is.na(cri$rotulo_ano1) & !is.na(cri$rotulo_ano2)))
  expect_error(tse_diff_cadastro(1990, 2002), "sem cadastro")
})

test_that("o rótulo entra no crosswalk e volta ao código", {
  cw <- crosswalk_tse()
  expect_true("rotulo" %in% names(cw))
  expect_false(any(is.na(cw$rotulo)))          # todas as 275 linhas
  expect_equal(cw$rotulo[cw$cod_tse == "169"], "COMERCIANTE")
  # ida e volta
  r <- tse_rotulo_para_cod("Comerciante")
  expect_equal(r$cod_tse, "169")
  expect_gt(nrow(tse_rotulo_para_cod("advogado", exato = FALSE)), 0L)
  expect_true(is.na(tse_rotulo_para_cod("ocupação que não existe")$cod_tse))
})

test_that("tse_para_rotulo respeita o ano", {
  expect_match(tse_para_rotulo(215, 2000), "ASSESSORAMENTO")
  expect_match(tse_para_rotulo(215, 2020), "ARTISTA")
  expect_match(tse_para_rotulo(215), "ARTISTA")       # sem ano: o mais recente
  expect_true(is.na(tse_para_rotulo(215, 2004)))      # fora de vigência
})
