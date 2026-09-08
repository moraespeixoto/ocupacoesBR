# ============================================================================
# 07_gera_posicao.R — a posicao na ocupacao que o TSE nao pergunta
# ----------------------------------------------------------------------------
# O EGP nao e funcao so da ocupacao: as regras do ISMF pedem a posicao no
# emprego (SEMPL) e a supervisao (SUPVIS). O formulario do TSE nao pergunta
# nenhuma das duas, e por isso o esquema sai degradado — IVa, IVb e IVc
# estruturalmente vazias, V subestimada.
#
# A PNAD Continua pergunta as duas. Como ela usa a COD, e a COD e a ISCO-08,
# a perna `cod_para_isco08()` deste pacote leva a PNAD ao mesmo espaco em que
# o TSE aterrissa. Daqui sai a distribuicao BRASILEIRA de posicao na ocupacao
# por codigo ISCO-88 — um prior empirico, nao uma imputacao individual.
#
# FONTE
#   PNAD Continua trimestral, microdados, os QUATRO trimestres de 2025.
#   https://ftp.ibge.gov.br/Trabalho_e_Rendimento/
#     Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Trimestral/Microdados/2025/
#   Acesso em 28/07/2026. Variaveis: V4010 (COD), V4012 (posicao na ocupacao),
#   V4016 (n de empregados, em faixas), V1028 (peso), mais os identificadores
#   de painel UPA/V1008/V1014/V2003/V20082.
#
# OS MICRODADOS NAO ESTAO NESTE REPOSITORIO e nao devem estar: sao 212 MB
# comprimidos por trimestre. Ficam em ~/dados_pnad (ou OCUPACOESBR_PNAD), extraidos em
# colunas por data-raw/extrai_tri.py. O que entra no pacote e a tabela
# AGREGADA — sem individuo, sem identificador, ~15 KB.
#
# DUAS DECISOES DE METODO
#
# 1. PAINEL ROTATIVO. A PNAD reentrevista o mesmo domicilio por cinco
#    trimestres. Somar quatro trimestres como amostras independentes inflaria
#    o n sem acrescentar informacao na mesma proporcao: sao 864.870
#    observacoes de 437.880 pessoas distintas (1,98x). Por isso o peso e
#    dividido pelo numero de trimestres — as estimativas sao a media do ano
#    civil, com os pesos somando a populacao e nao quatro vezes ela — e a
#    tabela publica `n_pessoas`, nao `n_obs`, como medida de precisao.
#
# 2. POR QUE O ANO INTEIRO. A hipotese era sazonalidade agricola. Ela NAO
#    aparece nesta variavel: a amplitude entre trimestres e de 2,5 pp na
#    ISCO 61 e 2,6 pp na 92, e o volume de ocupados na 61 e estavel. A
#    sazonalidade brasileira esta em horas e renda, nao na composicao por
#    posicao — o proprietario continua proprietario na entressafra. O ganho
#    do ano completo foi PRECISAO nas celulas finas (codigos de 4 digitos com
#    n >= 100 pessoas passaram de 197 para 258), nao correcao de vies.
#
# 3. AS DUAS COLUNAS ACRESCENTADAS EM 08/09/2026, e o aviso que uma delas
#    exige. `pct_setor_publico` sai de V4012 == 4 (empregado do setor publico,
#    inclusive economia mista) e existe porque e a variavel que falta para
#    medir a maior assimetria entre o TSE e a PNAD Continua: o formulario do
#    Tribunal oferece quatro rotulos de vinculo publico que SUBSTITUEM a
#    ocupacao, e a PNAD Continua pergunta as duas coisas em separado.
#
#    `pct_militar` sai de V4012 == 2 e custa a mesma passada, mas nao mede o
#    que o nome sugere. O dicionario do IBGE define V4012 = 2 como "militar do
#    exercito, da marinha, da aeronautica, DA POLICIA MILITAR OU DO CORPO DE
#    BOMBEIROS MILITAR". Nao e o grande grupo 0 da ISCO-88: a pergunta sobre
#    POSICAO e a pergunta sobre OCUPACAO discordam sobre quem e militar no
#    Brasil, e a discordancia e a mesma que a COD registra ao alocar a policia
#    militar ao grande grupo 0. O script mede a discordancia e a imprime ao
#    fim, para que `?isco_posicao_br` a documente com numero apurado.
#
# Rodar: Rscript data-raw/07_gera_posicao.R
# ============================================================================

# Mesmo padrao dos scripts 05/05a: variavel de ambiente com fallback local
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
d[, peso := as.numeric(V1028)]
# a mesma pessoa reaparece entre trimestres; esta e a chave do painel
d[, pessoa := paste(UPA, V1008, V1014, V2003, V20082, sep = "|")]

o <- d[!is.na(V4010) & V4010 != ""]
o[, isco88 := suppressWarnings(isco08_para_isco88(
                suppressWarnings(cod_para_isco08(V4010))))]
o <- o[!is.na(isco88)]

o[, p   := peso / length(arq)]        # media do ano civil (ver decisao 1)
o[, cp  := V4012 %in% c("5", "6")]    # conta propria + empregador = SEMPL 2
o[, emp := V4012 == "5"]              # empregador
o[, g11 := V4016 %in% c("3", "4")]    # 11+ empregados: o limiar da ISCO 12
o[, pub := V4012 == "4"]              # empregado do setor publico (economia mista inclusa)
o[, mil := V4012 == "2"]              # militar E policia/bombeiro militar — ver decisao 3

resume <- function(x, chave) {
  x[, .(n_obs = .N, n_pessoas = uniqueN(pessoa),
        pct_conta_propria = round(100 * sum(p[cp])  / sum(p), 1),
        pct_empregador    = round(100 * sum(p[emp]) / sum(p), 1),
        pct_setor_publico = round(100 * sum(p[pub]) / sum(p), 1),
        pct_militar       = round(100 * sum(p[mil]) / sum(p), 1),
        # so afirmado onde ha empregadores suficientes para a proporcao valer
        pct_emp_11mais    = if (sum(emp) >= 25)
          round(100 * sum(p[emp & g11]) / sum(p[emp]), 1) else NA_real_),
    by = .(chave = chave)][order(chave)]
}
t4 <- resume(o, o$isco88)
t2 <- resume(o, substr(o$isco88, 1, 2))

# Cada linha carrega a sua propria estimativa E a do grupo de 2 digitos. Quem
# cair numa celula fina usa o grupo sem ter de fazer o `substr` na mao — e ve,
# lado a lado, com que n cada uma foi apurada.
i <- match(substr(t4$chave, 1, 2), t2$chave)
isco_posicao_br <- data.frame(
  isco88                   = t4$chave,
  n_pessoas                = t4$n_pessoas,
  n_obs                    = t4$n_obs,
  pct_conta_propria        = t4$pct_conta_propria,
  pct_empregador           = t4$pct_empregador,
  pct_emp_11mais           = t4$pct_emp_11mais,
  pct_setor_publico        = t4$pct_setor_publico,
  pct_militar              = t4$pct_militar,
  grupo                    = t2$chave[i],
  n_pessoas_grupo          = t2$n_pessoas[i],
  pct_conta_propria_grupo  = t2$pct_conta_propria[i],
  pct_empregador_grupo     = t2$pct_empregador[i],
  pct_setor_publico_grupo  = t2$pct_setor_publico[i],
  pct_militar_grupo        = t2$pct_militar[i],
  stringsAsFactors = FALSE)

stopifnot(
  nrow(isco_posicao_br) > 250,
  !anyDuplicated(isco_posicao_br$isco88),
  all(nchar(isco_posicao_br$isco88) == 4L),
  all(isco_posicao_br$pct_conta_propria >= 0 &
      isco_posicao_br$pct_conta_propria <= 100),
  # o que a tabela existe para dizer: a 61 e conta propria, a 92 nao
  isco_posicao_br$pct_conta_propria_grupo[isco_posicao_br$grupo == "61"][1] > 60,
  isco_posicao_br$pct_conta_propria_grupo[isco_posicao_br$grupo == "92"][1] < 25,
  # as quatro marcas de posicao sao MUTUAMENTE EXCLUSIVAS no dicionario do
  # IBGE — V4012 vale 2, 4 ou {5,6}, nunca duas —, e por isso a soma das tres
  # colunas disjuntas nunca passa de 100. `pct_empregador` NAO entra na soma:
  # ela e subconjunto de `pct_conta_propria` (V4012 == 5 esta dentro de {5,6}),
  # e some-la seria contar o empregador duas vezes.
  all(isco_posicao_br$pct_conta_propria + isco_posicao_br$pct_setor_publico +
      isco_posicao_br$pct_militar <= 100 + 1e-9),
  all(isco_posicao_br$pct_empregador <= isco_posicao_br$pct_conta_propria),
  all(isco_posicao_br$pct_setor_publico >= 0 &
      isco_posicao_br$pct_setor_publico <= 100),
  all(isco_posicao_br$pct_militar >= 0 & isco_posicao_br$pct_militar <= 100)
)

# ---- a discordancia da decisao 3, medida e nao suposta ---------------------
# Entre quem declara POSICAO militar (V4012 == 2), onde o codigo de OCUPACAO
# o coloca? Se as duas perguntas concordassem, tudo cairia no grande grupo 0.
disc <- o[mil == TRUE, .(pct = 100 * sum(p) / sum(o$p[o$mil])),
          by = .(g1 = substr(isco88, 1, 1))][order(-pct)]
pub_g1 <- o[pub == TRUE, .(pct = round(100 * sum(p) / sum(o$p[o$pub]), 1)),
            by = .(g1 = substr(isco88, 1, 1))][order(g1)]

usethis::use_data(isco_posicao_br, overwrite = TRUE)
message(sprintf("posicao: %d codigos ISCO-88 | %d com n_pessoas >= 100 | %d trimestres",
                nrow(isco_posicao_br), sum(isco_posicao_br$n_pessoas >= 100),
                length(arq)))
message("setor publico: ", round(100 * sum(o$p[o$pub]) / sum(o$p), 1),
        "% dos ocupados | militar (V4012 == 2): ",
        round(100 * sum(o$p[o$mil]) / sum(o$p), 2), "%")
message("onde a OCUPACAO poe quem declara POSICAO militar:")
print(disc[, .(grande_grupo = g1, pct = round(pct, 1))])
message("distribuicao do setor publico pelo grande grupo da ISCO-88:")
print(pub_g1)
