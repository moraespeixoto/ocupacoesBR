# ============================================================================
# 07b_gera_populacao.R — o denominador que o pacote prometia e nao entregava
# ----------------------------------------------------------------------------
# O indice de referencia promete, na porta do IBGE: "A COD, usada na PNAD
# Continua e no Censo, e quase a ISCO-08 com outro nome. E por aqui que se
# compara candidatura com populacao." A comparacao nao estava demonstrada em
# lugar nenhum, e nao podia estar: faltava o outro lado. `tse_universo` diz de
# que e feita a base das candidaturas; esta tabela diz de que e feita a base da
# populacao, na MESMA forma, para que a comparacao seja uma juncao de duas
# linhas em vez de uma reconstrucao a partir de microdado.
#
# DE ONDE VEM O ESCOPO. O pacote e um tradutor, e uma distribuicao populacional
# e outro tipo de objeto — a decisao foi do autor, em 08/09/2026, com o
# precedente nos dois sentidos: `isco_posicao_br` ja deriva da populacao e
# `tse_validacao` ja deriva das candidaturas, e nenhuma das duas e tabua de
# conversao.
#
# FONTE: PNAD Continua trimestral, os QUATRO trimestres de 2025, os mesmos
#   arquivos de `07_gera_posicao.R`. Ficam em ~/dados_pnad (ou OCUPACOESBR_PNAD)
#   e NAO viajam com o pacote. O que entra e a tabela agregada, ~27 KB, sem
#   individuo e sem identificador.
#
# QUATRO DECISOES DE METODO
#
# 1. PAINEL ROTATIVO, igual ao 07: o peso e dividido pelo numero de trimestres,
#    de modo que as estimativas sejam a media do ano civil e os pesos somem a
#    populacao, e nao quatro vezes ela. `n_pessoas` conta pessoas distintas na
#    chave do painel, e e a coluna honesta de precisao.
#
# 2. OS QUATRO PISOS SAO OS DA CONSTITUICAO, art. 14 §3º: 18 anos para
#    vereador, 21 para prefeito e deputado, 30 para governador e 35 para
#    senador e presidente. Nao sao faixas etarias e sim PISOS — cada um e a
#    populacao inteira daquela idade em diante, e por isso se sobrepoem. O
#    piso e a decisao que mais move o denominador: a parcela de nao ocupados
#    vai de 38,0% aos 18 anos a 42,0% aos 35, e quem compara candidato a
#    senador com "a populacao" sem escolher o piso erra por quatro pontos.
#
# 3. "NAO OCUPADO" E UMA LINHA, e nao a ausencia dela. Se a tabela so trouxesse
#    os ocupados, o leitor calcularia proporcoes sobre um denominador que nao e
#    o que ele pensa que e — que e exatamente o erro que o artigo
#    `comparar-fontes` existe para impedir. Com a linha, `pct` fecha em 100
#    dentro de cada (piso, sexo) e o universo esta declarado no proprio objeto.
#
# 4. QUATRO DIGITOS, COM A AMOSTRA A VISTA. Agregar a dois digitos eliminaria
#    as celulas finas, e tambem a unica figura que precisa do codigo fino: o
#    5162 (policia) e o 5161 (bombeiro), que e onde `cod_para_isco()` desfaz a
#    adaptacao da COD e onde os codigos 232, 233, 258 e 145 do TSE aterrissam.
#    O preco e que 704 das 3.811 linhas tem menos de 30 pessoas na amostra. A
#    coluna `n_pessoas` existe para denunciar isso, e a ajuda diz para nao ler
#    celula fina sem olhar para ela.
#
# Rodar: Rscript data-raw/07b_gera_populacao.R
# ============================================================================

PNAD <- path.expand(Sys.getenv("OCUPACOESBR_PNAD", "~/dados_pnad"))
arq  <- list.files(PNAD, "^cols_.*csv$", full.names = TRUE)
if (!length(arq))
  stop("microdados da PNAD ausentes em ", PNAD,
       ".\nVeja o cabecalho deste arquivo: eles ficam fora do repositorio.",
       call. = FALSE)

suppressMessages(library(data.table))
devtools::load_all(quiet = TRUE)

d <- rbindlist(lapply(arq, fread, colClasses = "character",
                      na.strings = c("", ".")))
d[, peso   := as.numeric(V1028)]
d[, pessoa := paste(UPA, V1008, V1014, V2003, V20082, sep = "|")]
d[, p      := peso / length(arq)]          # media do ano civil (decisao 1)
d[, idade  := as.integer(V2009)]
d[, sexo   := fifelse(V2007 == "1", "Homem", "Mulher")]
d <- d[!is.na(idade) & idade >= 18 & !is.na(sexo)]

# VD4002 e a condicao de ocupacao, e so existe para quem esta NA forca de
# trabalho: para quem esta fora dela o campo vem vazio. Comparar `VD4002 == 1`
# sem tratar o NA joga os 38% de nao ocupados no balde errado — foi o primeiro
# resultado deste script, e estava errado por isso.
d[, ocupado := !is.na(VD4002) & VD4002 == "1"]
d[, isco88  := suppressWarnings(isco08_para_isco88(
                 suppressWarnings(cod_para_isco08(V4010))))]
d[, situacao := fcase(
  !ocupado,        "Não ocupado",
  is.na(isco88),   "Ocupado sem endereço na ISCO-88",
  default =        "Ocupado")]
d[situacao != "Ocupado", isco88 := NA_character_]

PISOS <- c(18L, 21L, 30L, 35L)   # CF art. 14 §3º — ver decisao 2
SEXOS <- c("Todos", "Homem", "Mulher")

celula <- function(piso, sx) {
  x <- d[idade >= piso]
  if (sx != "Todos") x <- x[sexo == sx]
  r <- x[, .(pop = sum(p), n_pessoas = uniqueN(pessoa)),
         by = .(isco88, situacao)]
  r[, `:=`(piso = piso, sexo = sx, pct = round(100 * pop / sum(pop), 3))]
  r[]
}
g <- rbindlist(lapply(PISOS, function(pi)
       rbindlist(lapply(SEXOS, function(s) celula(pi, s)))))
setorder(g, piso, sexo, situacao, isco88, na.last = TRUE)

cod_populacao_br <- as.data.frame(
  g[, .(piso, sexo, isco88, situacao, pop = round(pop), n_pessoas, pct)])

stopifnot(
  # o universo fecha: e a propriedade que faz a tabela um denominador e nao
  # uma lista de contagens
  all(abs(tapply(cod_populacao_br$pct,
                 list(cod_populacao_br$piso, cod_populacao_br$sexo),
                 sum) - 100) < 0.02),
  setequal(cod_populacao_br$piso, PISOS),
  setequal(cod_populacao_br$sexo, SEXOS),
  setequal(cod_populacao_br$situacao,
           c("Ocupado", "Não ocupado", "Ocupado sem endereço na ISCO-88")),
  # `isco88` so existe onde ha ocupacao com endereco, e sempre com 4 digitos
  all(is.na(cod_populacao_br$isco88[cod_populacao_br$situacao != "Ocupado"])),
  all(!is.na(cod_populacao_br$isco88[cod_populacao_br$situacao == "Ocupado"])),
  all(nchar(stats::na.omit(cod_populacao_br$isco88)) == 4L),
  all(cod_populacao_br$pop > 0), all(cod_populacao_br$n_pessoas > 0),
  # a chave e unica dentro de (piso, sexo)
  !anyDuplicated(cod_populacao_br[, c("piso", "sexo", "isco88", "situacao")]),
  # o piso mais alto tem menos gente que o mais baixo, em toda a tabela
  sum(cod_populacao_br$pop[cod_populacao_br$piso == 35 &
                           cod_populacao_br$sexo == "Todos"]) <
  sum(cod_populacao_br$pop[cod_populacao_br$piso == 18 &
                           cod_populacao_br$sexo == "Todos"]))

usethis::use_data(cod_populacao_br, overwrite = TRUE)

# ---- o que a tabela diz, impresso para conferencia -------------------------
p <- as.data.table(cod_populacao_br)
message(sprintf("populacao: %d linhas | %d celulas com n_pessoas < 30",
                nrow(p), sum(p$n_pessoas < 30)))
message("nao ocupados, por piso e sexo:")
print(dcast(p[situacao == "Não ocupado"], piso ~ sexo, value.var = "pct"))
message("cobertura do ISEI sobre a populacao do piso (o par que o artigo usa):")
p[, isei := isco88_para_isei(isco88)]
print(p[, .(pct_com_isei = round(sum(pct[!is.na(isei)]), 1)), by = .(piso, sexo)][
        order(piso, sexo)])
