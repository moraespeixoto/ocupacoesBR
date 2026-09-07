# ============================================================================
# 12_gera_reguas.R — a tabela que diz qual régua responde a qual pergunta
# ----------------------------------------------------------------------------
# O risco central deste pacote não é errar uma tradução: é o usuário trocar uma
# régua por outra sem perceber, porque trocar custa uma letra no nome da função.
# O aviso existe desde sempre, mas mora em prosa — na vinheta `qual-regua` e nas
# seções dos .Rd. Prosa é o último formato que um leitor apressado consulta, e
# é o último que um modelo de linguagem pondera.
#
# Esta tabela põe a mesma informação em forma consultável: uma linha por régua,
# uma coluna para a pergunta que ela responde e outra para quando NÃO usá-la.
# Quem quiser filtrar por tipo, por âncora ou por porta de entrada, filtra.
#
# PROVENIÊNCIA: esta é a única tabela do pacote que NÃO deriva de fonte
# externa. As demais vêm das sintaxes do ISMF, da tábua do Ministério do
# Trabalho ou dos microdados, e por isso o `00_confere_proveniencia.R` as
# audita contra `inst/extdata/fontes/`. Esta é destilada da documentação do
# próprio pacote, e a auditoria de proveniência não se aplica a ela — o que a
# mantém honesta é o `tests/testthat/test-reguas.R`, que amarra as funções
# citadas aqui aos exports reais, nas duas direções.
#
# ONDE CADA CÉLULA FOI BUSCADA (nada aqui é digitado de memória):
#   ISEI-88, viés de gênero e r = 0,207 ....... R/tse.R, seção da escala
#   ISEI-08, ponte ambígua em um terço ........ R/isco08.R
#   ISEI-BR, 2025, não forma série ............ R/isei_br.R
#   prestígio x ISEI, magistrado e enfermeiro . vignettes/qual-regua.Rmd §1
#   EGP degradado sem subordinados ............ R/egp.R, qual-regua §5
#   estrato e residuais ....................... R/tse.R, qual-regua §4
#   componente da classe alta, OAB x 257 ...... R/tse.R
#
# Rodar: Rscript data-raw/12_gera_reguas.R
# ============================================================================

reguas <- data.frame(
  stringsAsFactors = FALSE,

  medida = c(
    "ISEI-88", "ISEI-08", "ISEI-BR",
    "Prestigio-88", "Prestigio-08",
    "EGP", "Classe", "Estrato", "Componente da classe alta"),

  tipo = c("continua", "continua", "continua",
           "continua", "continua",
           "categorica", "categorica", "ordinal", "categorica"),

  ancora = c("ISCO-88", "ISCO-08", "PNAD Continua 2025 (ISCO-08)",
             "ISCO-88", "ISCO-08",
             "ISCO-88", "cadastro do TSE", "cadastro do TSE",
             "cadastro do TSE"),

  # Os intervalos das réguas contínuas NÃO são digitados: saem das próprias
  # tabelas do pacote, logo abaixo, para que não possam envelhecer em silêncio.
  escala = c(NA, NA, NA, NA, NA,
             "11, 7, 5 ou 3 classes", "12 categorias",
             "3 estratos e 2 residuais a parte",
             "3 componentes, NA fora da classe alta"),

  funcao_tse = c(
    "tse_para_isei", "tse_para_isei08", "tse_para_isei_br",
    "tse_para_prestigio", "tse_para_prestigio08",
    "tse_para_egp", "tse_para_classe", "tse_para_estrato",
    "tse_para_componente_alta"),

  outras_portas = c(
    "cbo2002_para_isei, cbo94_para_isei, cod_para_isei, isco88_para_isei",
    "cbo2002_para_isei08, cod_para_isei08",
    "cbo2002_para_isei_br, cod_para_isei_br, isco08_para_isei_br",
    "cbo2002_para_prestigio, cbo94_para_prestigio, cod_para_prestigio, isco88_para_prestigio",
    "cbo2002_para_prestigio08, cod_para_prestigio08",
    "cbo2002_para_egp, cbo94_para_egp, cod_para_egp, isco88_para_egp",
    NA, NA, NA),

  pergunta = c(
    "quanto uma posição converte educação em renda",
    "a mesma do ISEI-88, para juntar o dado eleitoral a fontes que já usam ISCO-08, e para análise de gênero",
    "como o mercado de trabalho brasileiro de hoje ordena as ocupações, em vez de um escalonamento único de dezesseis países com dado brasileiro de 1973 e 1982",
    "o quanto uma ocupação é socialmente estimada",
    "a mesma do prestígio-88, sobre a ISCO-08",
    "a relação de emprego: quem contrata, quem é contratado",
    "a estrutura de classes do dado eleitoral brasileiro",
    "de onde vem o sustento: de um diploma, de um patrimônio, de um salário, da terra",
    "de que recurso a classe alta se compõe: capital ou credencial"),

  mede = c(
    "status socioeconômico",
    "status socioeconômico, na revisão que promoveu a enfermagem e reavaliou o comércio",
    "status socioeconômico estimado em dado brasileiro, não importado",
    "prestígio, isto é, reputação e não recurso",
    "prestígio na âncora de 2008",
    "classe relacional",
    "esquema próprio, que cobre os 17 códigos sem ISCO",
    "posição, não status: a régua se cruza com o ISEI por desenho",
    "a espécie de recurso, não a sua quantidade"),

  quando_nao_usar = c(
    paste("não use como proxy de renda ou patrimônio individual (r = 0,207 no nível da candidatura);",
          "a escala é enviesada contra ocupações femininas, que perdem 6,2 pontos a credencial constante,",
          "e para análise de gênero prefira o ISEI-08; nunca na mesma série que o ISEI-08 ou o ISEI-BR"),
    paste("para comparar candidaturas entre si prefira o ISEI-88, onde o pacote está ancorado:",
          "a ponte ISCO-88 para ISCO-08 é ambígua em cerca de um terço dos códigos;",
          "uma série não troca de âncora no meio"),
    paste("comparação internacional, que continua exigindo a âncora internacional;",
          "qualquer série longa, porque a escala vem de um ano só, 2025;",
          "não substitui o ISEI-08, e não há porta pela CBO-94"),
    paste("onde a ocupação mudou de posição desde os anos 1960-70, como bancário, professor e tecnologia;",
          "não é intercambiável com o ISEI: o magistrado tem ISEI 90 e prestígio 76, o enfermeiro 43 e 54"),
    "a mesma ressalva da ponte do ISEI-08, somada à do prestígio-88",
    paste("não publique onze classes a partir do TSE: sem número de subordinados, IVa e IVb não se separam;",
          "colapse em 5 ou 3 para publicar; pela CBO e pela COD o esquema sai degradado;",
          "com dado que tem as variáveis, como a PNAD, funciona por inteiro"),
    paste("fora da porta do TSE, porque depende de categorias que só o registro eleitoral cria;",
          "não é o EGP e não deve ser lido como tal"),
    paste("não some as duas residuais, 'Fora da PEA / não informado' e 'Vínculo público não especificado',",
          "às classes populares: elas ficam à parte de propósito;",
          "não é uma fatia do ISEI, e discordância entre as duas é achado, não erro"),
    paste("as duas metades não têm a mesma confiabilidade: 'advogado' (131) pressupõe inscrição na OAB,",
          "'empresário' (257) é autodeclaração e cobre patrimônios que distam 76 vezes entre si;",
          "se a conclusão depender do tamanho relativo, rode também sem tse_codigos_autorrotulo")),

  fonte = c(
    "Ganzeboom, De Graaf e Treiman (1992); ISMF, iskoisei.sps",
    "Ganzeboom e Treiman; ISMF, isqoisei08.sps",
    "estimada pelo pacote sobre a PNAD Contínua 2025, método de Ganzeboom, De Graaf e Treiman (1992)",
    "Treiman (1977); ISMF, iskotrei.sps",
    "Treiman; ISMF, isqotrei08.sps",
    "Erikson e Goldthorpe (1992); ISMF, iskoegp.sps; Carvalhaes (2015)",
    "autoral, construída sobre o cadastro de ocupações do TSE",
    "autoral, agregação das classes de tse_para_classe()",
    "autoral, partição da classe alta"),

  ver = c(
    "?tse_para_isei",
    "?tse_para_isei08",
    "?tse_para_isei_br",
    "?tse_para_prestigio",
    "?tse_para_prestigio08",
    "?tse_para_egp",
    "?tse_para_classe",
    "?tse_para_estrato",
    "?tse_para_componente_alta")
)

# ----------------------------------------------------------------------------
# Os intervalos observados, lidos das tabelas do pacote
# ----------------------------------------------------------------------------
faixa <- function(x) {
  r <- range(x, na.rm = TRUE)
  sprintf("%g a %g", round(r[1]), round(r[2]))
}
m88 <- local({ load("data/isco88_medidas.rda"); isco88_medidas })
m08 <- local({ load("data/isco08_medidas.rda"); isco08_medidas })
br  <- local({ load("data/isco08_isei_br.rda"); isco08_isei_br })

reguas$escala[reguas$medida == "ISEI-88"]      <- faixa(m88$isei88)
reguas$escala[reguas$medida == "ISEI-08"]      <- faixa(m08$isei08)
reguas$escala[reguas$medida == "ISEI-BR"]      <- faixa(br$isei_br)
reguas$escala[reguas$medida == "Prestigio-88"] <- faixa(m88$siops88)
reguas$escala[reguas$medida == "Prestigio-08"] <- faixa(m08$siops08)

stopifnot(!anyNA(reguas$escala))

# A acentuação precisa viajar marcada como UTF-8, senão o `R CMD check` acusa
# dado não-ASCII sem codificação declarada. Mesmo tratamento de 04_gera_rotulos.R.
for (col in names(reguas)) {
  if (is.character(reguas[[col]])) reguas[[col]] <- enc2utf8(reguas[[col]])
}

stopifnot(nrow(reguas) == 9, !anyDuplicated(reguas$medida))

message("reguas: ", nrow(reguas), " linhas, ", ncol(reguas), " colunas")

usethis::use_data(reguas, overwrite = TRUE)
