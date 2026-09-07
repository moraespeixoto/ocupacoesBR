# Numeros digitados na ajuda envelhecem calados.
#
# O pacote tem a regra de nao publicar valor que nao tenha saido de execucao
# propria, e ela ja pegou varios erros. O que ela nao cobre e o DEPOIS: um numero
# correto no dia em que foi escrito continua na pagina de ajuda quando a tabela
# de onde ele saiu muda. Foi assim que "80 vezes (p90/p10) entre os que declaram
# empresario" sobreviveu a correcao do patrimonio dobrado de 09/2026 — a
# agregacao antiga somava cada bem duas vezes, o valor certo e 76, e nada
# reprovava.
#
# Estes testes recomputam da tabela e conferem contra o texto da ajuda. Nao
# travam o valor: travam a IDENTIDADE entre o que a ajuda diz e o que o dado
# produz. Se a tabela mudar de novo, aqui reprova, e e para reprovar.

texto_rd <- function(nome) {
  f <- testthat::test_path("..", "..", "man", paste0(nome, ".Rd"))
  if (file.exists(f)) {
    return(paste(readLines(f, warn = FALSE, encoding = "UTF-8"), collapse = " "))
  }
  # no `R CMD check` o pacote esta instalado e a fonte nao acompanha
  db <- tools::Rd_db("ocupacoesBR")
  chave <- paste0(nome, ".Rd")
  expect_true(chave %in% names(db),
              info = paste("pagina de ajuda ausente:", nome))
  paste(utils::capture.output(tools::Rd2txt(db[[chave]])), collapse = " ")
}

# vírgula decimal, como o texto em português escreve
num_br <- function(x, casas = 0) {
  formatC(round(x, casas), format = "f", digits = casas, decimal.mark = ",")
}

test_that("a dispersao por autorrotulo na ajuda e a que a tabela produz", {
  a <- tse_autorrotulo_patrimonio
  a <- a[a$cargo == "TODOS", ]
  razao <- function(cod) {
    l <- a[a$cod_tse == cod, ]
    expect_equal(nrow(l), 1L, info = cod)
    l$p90 / l$p10
  }
  emp <- razao("257"); com <- razao("169"); adv <- razao("131")

  # o argumento da ajuda depende desta ordem: o comerciante, que e autorrotulo,
  # fica ENTRE o advogado (ancorado) e o empresario. Se a ordem inverter, o
  # paragrafo passa a afirmar o contrario do que o dado mostra.
  expect_lt(adv, com)
  expect_lt(com, emp)

  txt <- texto_rd("tse_codigos_autorrotulo")
  expect_match(txt, paste0(num_br(emp), " vezes"), fixed = TRUE)
  expect_match(txt, paste0("de ", num_br(com), "\n?"), fixed = FALSE)
  expect_match(txt, paste0("de ", num_br(adv), " entre os advogados"), fixed = TRUE)

  # e o 131 nao pode entrar na lista de autorrotulos sem que o texto mude
  expect_false("131" %in% tse_codigos_autorrotulo)
  expect_true(all(c("169", "257") %in% tse_codigos_autorrotulo))
})

test_that("os quantis do 257 na ajuda sao os da tabela", {
  a <- tse_autorrotulo_patrimonio
  l <- a[a$cargo == "TODOS" & a$cod_tse == "257", ]
  txt <- texto_rd("tse_para_componente_alta")
  expect_match(txt, paste0(num_br(l$p90 / l$p10), " vezes"), fixed = TRUE)
})

test_that("a regressao de genero citada em ?tse_para_isei e a que roda", {
  v <- tse_validacao
  v$isei <- tse_para_isei(v$cod_tse)
  w <- v[!is.na(v$isei) & v$n > 500, ]
  w$fem <- w$pct_mulher > 50
  co <- summary(stats::lm(isei ~ pct_superior + fem, data = w,
                          weights = w$n))$coefficients

  txt <- texto_rd("tse_para_isei")
  expect_match(txt, paste0(nrow(w), " "), fixed = TRUE)
  expect_match(txt, num_br(abs(co["femTRUE", "Estimate"]), 2), fixed = TRUE)
  expect_match(txt, num_br(mean(w$isei[w$fem]), 1), fixed = TRUE)
  expect_match(txt, num_br(mean(w$isei[!w$fem]), 1), fixed = TRUE)
})

test_that("a parcela mediada citada em ?isco08_isei_br e a do atributo", {
  pm <- attr(isco08_isei_br, "parcela_mediada")
  expect_true(is.numeric(pm) && length(pm) == 1)
  txt <- texto_rd("isco08_isei_br")
  expect_match(txt, num_br(pm, 1), fixed = TRUE)
})
