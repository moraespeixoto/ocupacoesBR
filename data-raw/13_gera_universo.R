# ============================================================================
# 13_gera_universo.R — quem o formulario do TSE deixa de fora, ano a ano
# ----------------------------------------------------------------------------
# O pacote ja publica a COBERTURA como propriedade das tabelas de conversao:
# `checa_cobertura()` diz que fracao de um vetor recebe escore. O que ele nao
# publicava e a decomposicao do RESIDUO — de que e feita a parte que nao
# recebe. E ela nao e uma constante: o buraco muda de tamanho e de composicao
# ao longo do tempo, e uma serie que o trate como fixo mede o cadastro em vez
# do recrutamento.
#
# POR QUE A DECOMPOSICAO IMPORTA MAIS QUE O TOTAL
#
# As rubricas residuais nao sao a mesma coisa. `999 OUTROS` e ausencia de
# informacao. `296 SERVIDOR PUBLICO ESTADUAL` e uma escolha de rotulo que
# SUBSTITUI a ocupacao — a pessoa tem ocupacao e nao a declarou. `581 DONA DE
# CASA` e uma posicao fora da forca de trabalho, e nao ausencia de resposta.
# `921 MILITAR REFORMADO` e trajetoria passada. Descartar as quatro juntas
# como "sem escore" trata como ruido o que e, em tres dos quatro casos,
# informacao.
#
# E o preco do descarte nao e distribuido por igual: a diferenca de cobertura
# entre os sexos esta quase toda numa linha, a de FORA DA FORCA DE TRABALHO.
# Por isso o recorte por sexo nao e enfeite — e o que torna a tabela capaz de
# mostrar o que a vinheta `qual-regua` hoje so afirma em prosa.
#
# FONTE: a mesma microbase de `05_gera_validacao.R`,
#   /dados/dados_ocupacoesBR/microbase_validacao_1998_2026.rds (env
#   OCUPACOESBR_MICROBASE). NAO versionada. O que entra no pacote e esta
#   tabela agregada: sem individuo, sem identificador.
#
# DUAS DECISOES DE METODO
#
# 1. O ESCORE SAI DO PROPRIO PACOTE, COM `ano =`. A microbase traz uma coluna
#    `isei` pronta, herdada do pipeline que a construiu. Ela nao e usada aqui:
#    a tabela chama `tse_para_isei(cod, ano = ano)`, que e a resposta do
#    pacote, e passa o ano — que e o que impede os sete codigos reutilizados
#    depois de 2002 de receberem o escore da ocupacao errada. Uma tabela sobre
#    cobertura que nao passasse o ano mediria a cobertura de um bug.
#
# 2. AS RUBRICAS TEM PRECEDENCIA SOBRE O ESCORE, e a ordem e a do formulario.
#    Um codigo residual e residual mesmo que por acidente tivesse escore; o
#    que decide e o que o rotulo diz. Depois disso, e so depois, o que sobra
#    se divide entre quem recebe escore e quem nao recebe.
#
# Rodar: Rscript data-raw/13_gera_universo.R
# ============================================================================

MICRO <- path.expand(Sys.getenv("OCUPACOESBR_MICROBASE",
                                "/dados/dados_ocupacoesBR/microbase_validacao_1998_2026.rds"))
if (!file.exists(MICRO))
  stop("microbase nao encontrada em:\n  ", MICRO,
       "\nAponte OCUPACOESBR_MICROBASE para o arquivo.", call. = FALSE)

suppressMessages(library(data.table))
devtools::load_all(quiet = TRUE)

m <- as.data.table(readRDS(MICRO))
stopifnot(all(c("cod_ocup", "ano", "gen") %in% names(m)))
m <- m[, .(ano = as.integer(ano), cod = as.character(cod_ocup),
           sexo = as.character(gen))]

# ---- as rubricas, na ordem de precedencia do formulario --------------------
# As listas nao sao digitadas: saem de `tse_isco$classe`, que e o julgamento
# curado do pacote. O `999` e separado do resto do "Nao informado" porque as
# duas coisas sao diferentes — um e recusa de nomear, o outro e ausencia de
# registro — e porque e o `999` que cresce.
cls <- function(x) tse_isco$cod_tse[tse_isco$classe == x]
VINC  <- cls("Vínculo público não especificado")
FORA  <- cls("Fora da PEA por posição")
INAT  <- cls("Inativo com trajetória")
NINF  <- setdiff(cls("Não informado"), "999")
stopifnot(length(VINC) == 4L, "999" %in% cls("Não informado"),
          "581" %in% FORA, "921" %in% INAT)

m[, isei := suppressWarnings(tse_para_isei(cod, ano = ano))]

m[, rubrica := fcase(
  is.na(cod) | cod == "" | cod %in% NINF, "Não informada",
  cod == "999",                           "Outros (999)",
  cod %in% VINC,                          "Vínculo público",
  cod %in% FORA,                          "Fora da força de trabalho",
  cod %in% INAT,                          "Inativo com trajetória",
  !is.na(isei),                           "Com escore",
  default =                               "Ocupação sem escore")]

NIVEIS <- c("Com escore", "Ocupação sem escore", "Vínculo público",
            "Fora da força de trabalho", "Inativo com trajetória",
            "Outros (999)", "Não informada")
m[, rubrica := factor(rubrica, levels = NIVEIS)]
stopifnot(!anyNA(m$rubrica))

# ---- o agregado: ano x sexo x rubrica, com a linha "Todos" ----------------
# "Todos" e uma LINHA da coluna `sexo`, e nao a ausencia dela, porque quem le
# a tabela sem se interessar por sexo nao deve ter de somar nada — e porque a
# soma correta nao e obvia quando o sexo e desconhecido em algumas safras.
conta <- function(x) x[, .(n = .N), by = .(ano, sexo, rubrica)]
todos <- copy(m)[, sexo := "Todos"]
u <- rbind(conta(m[!is.na(sexo) & sexo != ""]), conta(todos))
u <- u[CJ(ano = unique(u$ano), sexo = unique(u$sexo), rubrica = NIVEIS,
          unique = TRUE), on = .(ano, sexo, rubrica)]
u[is.na(n), n := 0L]
u[, pct := round(100 * n / sum(n), 2), by = .(ano, sexo)]
setorder(u, ano, sexo, rubrica)

tse_universo <- as.data.frame(u)
tse_universo$rubrica <- as.character(tse_universo$rubrica)

# ---- travas ---------------------------------------------------------------
p <- as.data.table(tse_universo)
stopifnot(
  # a soma fecha em 100 por (ano, sexo) — e a propriedade que faz da tabela um
  # universo e nao uma lista de contagens soltas
  all(abs(p[, sum(pct), by = .(ano, sexo)]$V1 - 100) < 0.02),
  nrow(tse_universo) == length(unique(u$ano)) * 3L * length(NIVEIS),
  all(tse_universo$n >= 0))

# a linha "Todos" tem de conter homens e mulheres
tot <- p[sexo == "Todos", .(t = sum(n)), by = ano]
hm  <- p[sexo != "Todos", .(hm = sum(n)), by = ano]
stopifnot(all(merge(tot, hm, by = "ano")[, t >= hm]))

usethis::use_data(tse_universo, overwrite = TRUE)

# ---- o que a tabela diz, impresso para conferencia ------------------------
message(sprintf("universo: %d linhas | %d safras | %s",
                nrow(tse_universo), length(unique(tse_universo$ano)),
                paste(NIVEIS, collapse = " / ")))
d04 <- p[ano >= 2004]
message("de 2004 em diante, sobre o total de candidaturas:")
print(d04[sexo == "Todos", .(pct = round(100 * sum(n) / sum(d04[sexo == "Todos"]$n), 2)),
          by = rubrica][order(-pct)])
message("fora da forca de trabalho, por sexo, de 2004 em diante:")
print(d04[rubrica == "Fora da força de trabalho" & sexo != "Todos",
          .(pct = round(100 * sum(n) / sum(d04[sexo == .BY$sexo]$n), 2)), by = sexo])
message("2024, todos:")
print(p[ano == 2024 & sexo == "Todos", .(rubrica, n, pct)])
