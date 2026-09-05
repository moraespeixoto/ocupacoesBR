# ============================================================================
# 09_gera_isei_br.R — a regua de status ocupacional estimada em dado brasileiro
# ----------------------------------------------------------------------------
# O ISEI que o pacote carrega e importado. Ganzeboom, De Graaf e Treiman (1992)
# escalonaram a ISCO sobre dado de dezesseis paises, nenhum deles o Brasil, e
# Ganzeboom (2010) repetiu o procedimento para a ISCO-08. A vinheta de validacao
# mostrava que a medida ORDENA bem as ocupacoes no universo eleitoral, e dizia
# em seguida que nao mostrava que os escores estao CALIBRADOS para o Brasil.
# Calibra-los era, nas palavras da propria vinheta, a melhoria de maior valor
# que o pacote ainda nao tinha. Este script a faz.
#
# O QUE E O ISEI-BR
#   O procedimento de 1992 refeito sobre a PNAD Continua. A ocupacao entra como
#   variavel interveniente entre escolaridade e renda, e o escore de cada
#   ocupacao e a combinacao das medias de escolaridade e de renda dos seus
#   ocupantes que MINIMIZA o efeito direto da escolaridade sobre a renda. Nao e
#   uma traducao de escala nem uma recalibragem do ISEI-08: e o mesmo metodo,
#   estimado do zero em dado brasileiro. Ele nao substitui o ISEI-08, que segue
#   sendo a ancora internacional e o unico caminho para comparacao entre paises.
#
# FONTE
#   PNAD Continua trimestral, microdados, os QUATRO trimestres de 2025.
#   https://ftp.ibge.gov.br/Trabalho_e_Rendimento/
#     Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Trimestral/Microdados/2025/
#   Acesso em 05/09/2026. Variaveis: V4010 (COD da ocupacao), VD3005 (anos de
#   estudo), VD4016 (rendimento habitual do trabalho principal), V4039 (horas
#   habituais no trabalho principal), V2009 (idade), V2007 (sexo), V1028 (peso),
#   mais UPA/V1008/V1014/V2003/V20082 como chave da pessoa no painel.
#
# OS MICRODADOS NAO ESTAO NESTE REPOSITORIO e nao devem estar. Ficam em
# ~/dados_pnad (ou OCUPACOESBR_PNAD), extraidos em colunas por
# data-raw/extrai_tri.py. O que entra no pacote e a tabela AGREGADA — sem
# individuo, sem identificador. Os sha256 dos zips estao em
# inst/extdata/PROVENIENCIA.yml, secao microdados_externos.
#
# DECISOES DE METODO
#
# 1. AMOSTRA. Idade 21 a 64, como em Ganzeboom, De Graaf e Treiman (1992).
#    Ambos os sexos, com sexo entre os controles. Restringir a homens, como o
#    artigo de 1992 fez, reproduziria dentro da regua o vies de genero que a
#    vinheta de validacao denuncia na regua importada. O ISEI-08 de Ganzeboom
#    (2010) tambem ja usa ambos.
#
# 2. RENDA. Rendimento HABITUAL do trabalho PRINCIPAL (VD4016), em log. Tem de
#    ser do trabalho principal porque a ocupacao V4010 e a do trabalho
#    principal. Habitual, e nao efetivo, porque o efetivo tem 22.614 zeros de
#    quem nao trabalhou no mes de referencia. Sem deflator: os residuos sao
#    tomados dentro de trimestre, o que absorve a inflacao do ano.
#
# 3. TEMPO INTEGRAL. V4039 >= 30 horas semanais. O artigo de 1992 restringe a
#    tempo integral, e 30 horas e a convencao da OCDE. Sem a restricao, a renda
#    mensal de uma ocupacao mistura preco da hora com quantidade de horas.
#
# 4. ESCOLARIDADE. VD3005, anos de estudo, contínua de 0 a 16. Entre os
#    ocupados nao ha faltante nenhum nesta variavel.
#
# 5. COMPOSICAO. Escolaridade e log-renda entram residualizadas em idade,
#    idade ao quadrado, sexo e trimestre, ponderadas. Sem isso o escore de uma
#    ocupacao premiaria ter ocupantes velhos ou homens.
#
# 6. PAINEL ROTATIVO. A PNAD reentrevista o mesmo domicilio por cinco
#    trimestres. O peso e dividido pelo numero de trimestres, como em
#    07_gera_posicao.R, e a tabela publica `n_pessoas` alem de `n_obs`.
#
# 7. O RESIDUO, QUE E ACHADO E NAO DEFEITO. O procedimento de 1992 supoe que a
#    ocupacao medeia INTEGRALMENTE a relacao entre escolaridade e renda, e
#    escolhe o angulo onde o efeito direto zera. No Brasil ele nao zera: a
#    curva tem minimo interior e para em torno de 0,21, com cerca de 58% do
#    efeito total mediado pela ocupacao. Os outros 42% sao escolaridade que
#    paga DENTRO da ocupacao, o que se le como heterogeneidade intraocupacional
#    e informalidade. Adota-se o angulo de minimo, e o residuo se publica.
#    A decisao e segura porque o ORDENAMENTO nao depende do angulo exato: a
#    correlacao de Spearman entre a escala em theta* e em theta* +- 0,15 passa
#    de 0,999, e nenhuma das sete especificacoes alternativas testadas move o
#    ordenamento abaixo de 0,99. Ver a secao Sensibilidade em ?isco08_isei_br.
#
# 8. AS 590 LINHAS. A porta do TSE aterrissa em codigos ISCO-08 AGREGADOS de
#    dois e tres digitos, porque a ocupacao declarada ao TSE e grossa. Uma
#    tabela so com celulas de quatro digitos devolveria NA para a maioria dos
#    candidatos. Por isso a tabela cobre as mesmas 590 chaves de
#    `isco08_medidas`, e cada agregado e apurado juntando os INDIVIDUOS da sua
#    subarvore, nao a media das medias.
#
# 9. CELULAS FINAS. Codigo de quatro digitos com menos de 30 pessoas herda o
#    escore do pai de tres digitos, depois de dois, depois de um. A coluna
#    `nivel` diz em que nivel o escore foi apurado, e `n_pessoas` e o da celula
#    QUE FORNECEU o escore, nao o da celula pedida.
#
# 10. O QUE SE PERDE. A COD funde oficiais e pracas de policia e bombeiro
#    militar em dois codigos ISCO-08 (5411 e 5412), entao a escala nao
#    distingue oficial de praca. Ha ainda codigos da ISCO-08 em que nenhuma COD
#    aterrissa, como 6222 e 6223 (pesca em agua doce e pesca costeira, que a
#    COD junta em 6225 e a tabua leva a 6220): esses herdam do pai. O script
#    calcula essa lista da propria tabua e trava que todos vieram herdados.
#
# Este cabecalho traz numeros da ultima execucao. Se reexecutar, atualize-os.
# Rodar: Rscript data-raw/09_gera_isei_br.R
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

precisa <- c("V4010", "VD3005", "VD4016", "V4039", "V2009", "V2007", "V1028")
if (!all(precisa %in% names(d)))
  stop("faltam colunas na extracao: ",
       paste(setdiff(precisa, names(d)), collapse = ", "),
       ".\nReextraia com data-raw/extrai_tri.py, que ja as inclui.",
       call. = FALSE)

d[, `:=`(idade = as.integer(V2009), anos = as.integer(VD3005),
         hrs   = as.integer(V4039), renda = as.numeric(VD4016),
         peso  = as.numeric(V1028) / length(arq), sexo = V2007)]
d[, pessoa := paste(UPA, V1008, V1014, V2003, V20082, sep = "|")]

# --- amostra analitica (decisoes 1 a 4) -------------------------------------
a <- d[!is.na(V4010) & V4010 != "0000" &
       idade >= 21 & idade <= 64 &
       !is.na(hrs) & hrs >= 30 &
       !is.na(renda) & renda > 0 & !is.na(anos)]
a[, isco08 := suppressWarnings(cod_para_isco08(V4010))]
a <- a[!is.na(isco08)]
a[, ly := log(renda)]

# --- residualizacao por composicao (decisao 5) ------------------------------
zw <- function(x, w) {
  m <- weighted.mean(x, w); (x - m) / sqrt(weighted.mean((x - m)^2, w))
}
res <- function(v)
  residuals(lm(stats::reformulate(
    c("idade", "I(idade^2)", "factor(sexo)", "factor(tri)"), v),
    data = a, weights = a$peso))
a[, `:=`(es = zw(res("anos"), peso), ys = zw(res("ly"), peso))]

# --- o angulo (decisao 7) ---------------------------------------------------
NMIN <- 30L
cel4 <- a[, .(E = weighted.mean(es, peso), Y = weighted.mean(ys, peso),
              n_pessoas = uniqueN(pessoa)), by = isco08]
est  <- cel4[n_pessoas >= NMIN]
am   <- a[isco08 %chin% est$isco08]

beta_direto <- function(th) {
  u <- est$E * cos(th) + est$Y * sin(th)
  v <- zw(u[match(am$isco08, est$isco08)], am$peso)
  unname(coef(lm(ys ~ v + es, data = am, weights = am$peso))["es"])
}
theta <- optimize(function(t) abs(beta_direto(t)), c(0, pi / 2), tol = 1e-6)$minimum
bdir  <- beta_direto(theta)
btot  <- unname(coef(lm(ys ~ es, data = am, weights = am$peso))["es"])
mediada <- 100 * (1 - bdir / btot)

escore <- function(th) est$E * cos(th) + est$Y * sin(th)
robustez <- min(cor(escore(theta), escore(theta - 0.15), method = "spearman"),
                cor(escore(theta), escore(theta + 0.15), method = "spearman"))

# o minimo tem de ser interior (pesos positivos nas duas variaveis) e o
# ordenamento tem de ser insensivel ao angulo. Sem isso o metodo nao se sustenta.
stopifnot(theta > 0.02, theta < (pi / 2 - 0.02), robustez >= 0.98)

# --- as 590 celulas (decisoes 8 e 9) ----------------------------------------
# Agrega por prefixo de 1 a 4 caracteres. Juntar individuos, e nao medias de
# medias, e o que faz o agregado ser a estimativa do grupo e nao a media
# aritmetica das suas subocupacoes, que teria peso errado.
por_prefixo <- function(n) {
  a[, .(E = weighted.mean(es, peso), Y = weighted.mean(ys, peso),
        anos_estudo = round(weighted.mean(anos, peso), 2),
        log_renda   = round(weighted.mean(ly, peso), 4),
        n_obs = .N, n_pessoas = uniqueN(pessoa)),
    by = .(p = substr(isco08, 1L, n))]
}
pref <- rbindlist(lapply(1:4, por_prefixo))
setkey(pref, p)

chaves <- ocupacoesBR::isco08_medidas$isco08
# prefixo significativo: "1200" e o agregado "12"; "2211" e ele mesmo;
# "0000" (forcas armadas sem especificacao) e o agregado "0".
significativo <- function(k) if (k == "0000") "0" else sub("0+$", "", k)

linha <- function(k) {
  cand <- significativo(k)
  cand <- unique(c(cand, substr(k, 1L, 3L), substr(k, 1L, 2L), substr(k, 1L, 1L)))
  cand <- cand[nchar(cand) <= nchar(significativo(k))]
  cand <- cand[order(-nchar(cand))]
  for (pp in cand) {
    # `pp`, e nao `p`: dentro de `[.data.table` o nome `p` resolveria para a
    # coluna da propria tabela, e a busca devolveria a tabela inteira.
    r <- pref[.(pp), nomatch = 0L]
    if (nrow(r) == 1L && r$n_pessoas >= NMIN)
      return(data.table(isco08 = k, u = r$E * cos(theta) + r$Y * sin(theta),
                        n_pessoas = r$n_pessoas, n_obs = r$n_obs,
                        nivel = nchar(pp), anos_estudo = r$anos_estudo,
                        log_renda = r$log_renda))
  }
  data.table(isco08 = k, u = NA_real_, n_pessoas = 0L, n_obs = 0L,
             nivel = NA_integer_, anos_estudo = NA_real_, log_renda = NA_real_)
}
tab <- rbindlist(lapply(chaves, linha))

# --- reescala para 10 a 90 sobre as celulas de estimacao --------------------
r <- range(escore(theta))
tab[, isei_br := round(pmin(pmax(10 + 80 * (u - r[1]) / (r[2] - r[1]), 10), 90), 1)]

isco08_isei_br <- as.data.frame(
  tab[, .(isco08, isei_br, n_pessoas, n_obs, nivel, anos_estudo, log_renda)])
attr(isco08_isei_br, "theta")           <- round(theta, 4)
attr(isco08_isei_br, "beta_direto")     <- round(bdir, 4)
attr(isco08_isei_br, "beta_total")      <- round(btot, 4)
attr(isco08_isei_br, "parcela_mediada") <- round(mediada, 1)
# O n da amostra de estimacao nao se recupera das colunas: `n_obs` por linha
# conta a subarvore inteira, nao a amostra que estimou o angulo. Sem estes
# dois atributos ele so existiria digitado na documentacao.
attr(isco08_isei_br, "n_obs")           <- nrow(am)
attr(isco08_isei_br, "n_pessoas")       <- data.table::uniqueN(am$pessoa)

# --- invariantes ------------------------------------------------------------
i8 <- ocupacoesBR::isco08_medidas$isei08[
        match(isco08_isei_br$isco08, ocupacoesBR::isco08_medidas$isco08)]
fino <- isco08_isei_br$nivel == 4L & !is.na(i8)
pega <- function(k) isco08_isei_br$isei_br[isco08_isei_br$isco08 == k]
# codigos de 4 digitos em que nenhuma COD aterrissa: sem individuo proprio,
# tem de herdar. Calculado, e nao listado a mao, porque a lista muda com a tabua.
orfaos <- setdiff(isco08_isei_br$isco08[sub("0+$", "", isco08_isei_br$isco08) ==
                                        isco08_isei_br$isco08],
                  unique(ocupacoesBR::cod_isco08$isco08))

stopifnot(
  nrow(isco08_isei_br) == nrow(ocupacoesBR::isco08_medidas),
  setequal(isco08_isei_br$isco08, ocupacoesBR::isco08_medidas$isco08),
  !anyNA(isco08_isei_br$isei_br),
  all(isco08_isei_br$isei_br >= 10 & isco08_isei_br$isei_br <= 90),
  all(isco08_isei_br$n_pessoas <= isco08_isei_br$n_obs),
  all(isco08_isei_br$nivel %in% 1:4),
  all(isco08_isei_br$n_pessoas[isco08_isei_br$nivel == 4L] >= NMIN),
  # validade de face, em desigualdades folgadas
  pega("2211") > pega("9211"),   # medico acima de trabalhador rural elementar
  pega("1120") > pega("5223"),   # dirigente acima de vendedor de loja
  pega("2310") > pega("9112"),   # professor universitario acima de faxineiro
  # concorda com a ancora internacional sem ser copia dela
  cor(isco08_isei_br$isei_br[fino], i8[fino], method = "spearman") > 0.8,
  # codigo ISCO-08 em que a COD nunca aterrissa nao pode ter escore proprio
  all(isco08_isei_br$nivel[isco08_isei_br$isco08 %in% orfaos] < 4L)
)

usethis::use_data(isco08_isei_br, overwrite = TRUE)

message(sprintf(paste0(
  "isei_br: %d celulas | %d obs, %d pessoas | %d codigos de 4 digitos com n >= %d\n",
  "  theta = %.4f rad (peso educ %.3f / renda %.3f)\n",
  "  beta_direto = %.4f | beta_total = %.4f | parcela mediada = %.1f%%\n",
  "  robustez do ordenamento (Spearman theta +- 0,15) = %.4f\n",
  "  contra o ISEI-08 importado, nas %d celulas de 4 digitos:\n",
  "  Pearson = %.3f | Spearman = %.3f | desvio absoluto medio = %.1f pontos\n",
  "  linhas herdadas de nivel mais grosso: %d de %d"),
  nrow(isco08_isei_br), nrow(am), uniqueN(am$pessoa), nrow(est), NMIN,
  theta, cos(theta), sin(theta), bdir, btot, mediada, robustez,
  sum(fino), cor(isco08_isei_br$isei_br[fino], i8[fino]),
  cor(isco08_isei_br$isei_br[fino], i8[fino], method = "spearman"),
  mean(abs(isco08_isei_br$isei_br[fino] - i8[fino])),
  sum(isco08_isei_br$nivel < 4L), nrow(isco08_isei_br)))
