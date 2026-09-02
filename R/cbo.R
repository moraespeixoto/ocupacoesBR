# ---------------------------------------------------------------------------
# a perna CBO: Classificacao Brasileira de Ocupacoes -> ISCO-88 -> medidas
# ---------------------------------------------------------------------------

#' Normaliza um codigo da CBO-2002
#'
#' Aceita "1111-05", "111105" e 111105. Devolve seis digitos sem hifen, que e a
#' forma dos microdados (RAIS, CAGED, eSocial).
#'
#' @section Entrada numerica:
#' O Novo CAGED grava a CBO como numero na propria planilha de dominio, de modo
#' que `010105` ("Oficial General da Aeronautica") chega como `10105`. O menor
#' codigo de seis digitos da CBO-2002 e `010105` \u2014 o primeiro digito e o grande
#' grupo, o segundo o subgrupo principal, e nenhum dos dois e zero ao mesmo
#' tempo \u2014, logo uma origem numerica perde **no maximo um** zero a esquerda. A
#' largura observada determina o alvo sem ambiguidade: 3 digitos completam a
#' familia de 4, 5 digitos completam a ocupacao de 6.
#' @noRd
.norm_cbo2002 <- function(cbo) {
  .checa_vetor(cbo, "cbo")
  if (is.factor(cbo)) cbo <- as.character(cbo)
  # so a leitura NUMERICA pode ter comido zero a esquerda. "111" como texto e
  # um codigo malformado, nao a familia "0111" — e deve falhar como antes.
  num <- is.numeric(cbo)
  if (num) cbo[!is.finite(cbo)] <- NA
  cbo <- as.character(cbo)
  if (!length(cbo)) return(character(0))
  .por_unico(cbo, function(u) {
    x <- trimws(u)
    x[is.na(x) | x == ""] <- NA_character_
    # sentinela ANTES da limpeza: depois do gsub, "000-1" vira a familia "0001"
    x[.e_sentinela(x)] <- NA_character_
    # o hifen e separador legitimo ("1111-05"); qualquer outro nao-digito nao e
    lim <- gsub("[-.[:space:]]", "", x)
    sujo <- !is.na(lim) & grepl("\\D", lim)
    lim[sujo] <- NA_character_
    n <- nchar(lim)
    if (num) {
      # `formatC` NAO vetoriza `width`: com um vetor ali, a chamada morre em
      # "the condition has length > 1" — o que acontecia sempre que dois ou
      # mais codigos distintos precisavam de zero, isto e, no caso normal de
      # ler a RAIS com read.csv. Os dois comprimentos vao em chamadas
      # separadas, cada uma com o seu `width` escalar.
      tres  <- !is.na(lim) & n == 3L
      cinco <- !is.na(lim) & n == 5L
      lim[tres]  <- formatC(as.integer(lim[tres]),  width = 4L,
                            flag = "0", format = "d")
      lim[cinco] <- formatC(as.integer(lim[cinco]), width = 6L,
                            flag = "0", format = "d")
      n <- nchar(lim)
    }
    mau <- (!is.na(lim) & !(n %in% c(4L, 6L))) | sujo
    .trata_invalidos(lim, mau, u, "CBO-2002",
                     "deve ter 4 (fam\u00edlia) ou 6 (ocupa\u00e7\u00e3o) d\u00edgitos")
  })
}

#' Sobe a hierarquia da CBO ate achar um degrau com correspondencia
#'
#' Devolve uma lista com o ISCO preenchido e o nivel de CBO que o produziu
#' (6 = a propria ocupacao, 4 = familia, 3 = subgrupo, 2 = subgrupo principal).
#' Para em 2 DE PROPOSITO: traduzir por um digito inverte classes inteiras, que
#' e a armadilha que este pacote existe para impedir.
#' @noRd
.escada_cbo <- function(x, out) {
  nivel <- ifelse(is.na(out), NA_integer_, nchar(x))
  for (k in c(4L, 3L, 2L)) {
    falta <- !is.na(x) & is.na(out) & nchar(x) >= k
    if (!any(falta)) next
    j <- match(substr(x[falta], 1, k),
               ocupacoesBR::cbo2002_escada$prefixo[
                 ocupacoesBR::cbo2002_escada$nivel == k])
    v <- ocupacoesBR::cbo2002_escada$isco88[
      ocupacoesBR::cbo2002_escada$nivel == k][j]
    o <- out[falta]; n <- nivel[falta]
    n[!is.na(v)] <- k; o[!is.na(v)] <- v[!is.na(v)]
    out[falta] <- o; nivel[falta] <- n
  }
  list(isco88 = out, nivel = nivel)
}

#' Traduz a CBO-2002 em ISCO-88
#'
#' Converte o codigo da Classificacao Brasileira de Ocupacoes de 2002 — o que
#' aparece na RAIS, no CAGED e no eSocial — no codigo ISCO-88 de quatro digitos,
#' porta de entrada para o ISEI, o SIOPS e o EGP.
#'
#' @section De onde vem a correspondencia:
#' Da tabua oficial de conversao CBO2002--CBO94--CIUO88 do Ministerio do
#' Trabalho, consultada familia por familia. Nao e uma equivalencia construida
#' por nos.
#'
#' @section O que a fonte nao cobre:
#' A tabua e, por construcao, uma conversao entre a CBO-2002 e a CBO-94: so
#' inclui as ocupacoes que existem nas duas. As ocupacoes criadas na revisao de
#' 2002 — e o grande grupo 0, das forcas armadas — nao tem correspondencia
#' oficial com a CIUO-88 e voltam `NA`. Isso e limite da fonte, e a funcao
#' prefere devolver `NA` a inventar um destino plausivel.
#'
#' @section Familia de quatro digitos:
#' Muito microdado publica so a familia. Nesse caso o pacote devolve o ISCO
#' **majoritario** entre as ocupacoes da familia. Use
#' [cbo2002_concordancia()] para saber se a familia e homogenea antes de
#' confiar no valor: uma familia dividida ao meio nao deve ser tratada como uma
#' posicao unica.
#'
#' @section A escada hierarquica:
#' A tabua do MTE cobre metade da CBO-2002, e o buraco NAO e aleatorio: cai
#' sobre o que foi criado na revisao de 2002 — tecnologia da informacao em peso,
#' pesquisadores — e sobre todo o grande grupo 0. Um vinculo de RAIS nesses
#' codigos volta `NA`.
#'
#' Com `escada = TRUE`, a funcao sobe a hierarquia da propria CBO ate achar um
#' nivel com correspondencia. Onde as ocupacoes mapeadas sob aquele prefixo nao
#' concordam num unico ISCO, usa-se o ancestral comum delas na hierarquia da
#' ISCO — que e a forma arredondada que o proprio ISMF publica (2211 e 2212
#' viram 2210). Nao ha destino inventado: so se sobe ate onde a fonte permite
#' afirmar. Cobertura do dominio oficial (2.777 ocupacoes):
#'
#' | nivel usado | ocupacoes | acumulado |
#' |---|---|---|
#' | 6 (a ocupacao) | 1.384 | 49,8% |
#' | 4 (familia) | 760 | 77,2% |
#' | 3 (subgrupo) | 306 | 88,2% |
#' | 2 (subgrupo principal) | 44 | 89,8% |
#' | sem rota | 283 | — |
#'
#' **A escada para em dois digitos de proposito.** Descer a um fecharia o
#' buraco restante e cometeria exatamente a armadilha que este pacote existe
#' para impedir: o grande grupo 9 da CBO e reparacao e manutencao, o da ISCO e
#' ocupacoes elementares. As 283 ocupacoes sem rota — em peso o bloco de
#' diretores 12xx e as forcas armadas — nao tem correspondencia oficial
#' nenhuma, e continuam `NA`.
#'
#' @section Familias empatadas:
#' Em 19 familias a moda NAO e maioria: duas ocupacoes dividem o topo. O
#' desempate anterior era mudo e ia sempre para o **menor** codigo ISCO —
#' consequencia da ordenacao lexicografica de `table()` —, e como a hierarquia
#' da ISCO e ordenada por status, o menor codigo tem o maior ISEI em 16 dos 19
#' casos. Isso e vies, nao ruido: nao desaparece com N.
#'
#' Por isso `empate = "na"` e o padrao. Um empate 1:1 nao tem destino
#' majoritario, e devolver `NA` e mais honesto que escolher por ordem
#' alfabetica. Use `empate = "moda"` para reproduzir o comportamento antigo.
#'
#' @param cbo Vetor de codigos da CBO-2002, com 6 digitos (ocupacao) ou 4
#'   (familia). Aceita "1111-05", "111105" ou 111105.
#' @param empate O que fazer quando a familia nao tem ISCO majoritario:
#'   `"na"` (padrao) devolve `NA`; `"moda"` devolve o vencedor do desempate
#'   por menor codigo, como nas versoes anteriores.
#' @param escada Se `TRUE`, sobe a hierarquia da CBO quando a ocupacao de seis
#'   digitos nao esta na tabua: tenta a familia de 4, depois o subgrupo de 3,
#'   depois o subgrupo principal de 2. Leva a cobertura do dominio oficial de
#'   **49,8% para 89,8%**. Padrao `FALSE`, porque o resultado deixa de ser a
#'   ocupacao declarada e passa a ser o seu grupo. Use
#'   [crosswalk_cbo2002()] para ver `nivel_usado` caso a caso.
#' @return Vetor de texto com o ISCO-88 de quatro digitos, ou `NA`.
#' @seealso [cbo2002_para_isei()], [cbo2002_concordancia()], [cbo94_para_isco()]
#' @examples
#' cbo2002_para_isco(c("1111-05", "225120", "5211"))
#' @export
cbo2002_para_isco <- function(cbo, empate = c("na", "moda"),
                              escada = FALSE) {
  empate <- match.arg(empate)
  x <- .norm_cbo2002(cbo)
  seis  <- !is.na(x) & nchar(x) == 6L
  quatro <- !is.na(x) & nchar(x) == 4L
  out <- rep(NA_character_, length(x))
  if (any(seis))
    out[seis] <- .busca(x[seis], ocupacoesBR::cbo2002_isco88, "cbo2002",
                        "isco88", o_que = "cbo2002_isco88")
  if (any(quatro)) {
    out[quatro] <- .busca(x[quatro], ocupacoesBR::cbo2002_familia_isco88,
                          "familia", "isco88",
                          o_que = "cbo2002_familia_isco88")
    if (empate == "na") {
      j  <- match(x[quatro], ocupacoesBR::cbo2002_familia_isco88$familia)
      emp <- ocupacoesBR::cbo2002_familia_isco88$empate[j] %in% TRUE
      if (any(emp)) {
        v <- out[quatro]; v[emp] <- NA_character_; out[quatro] <- v
        .aviso(sprintf(paste0("%d c\u00f3digo(s) em fam\u00edlia sem ISCO ",
                              "majorit\u00e1rio devolvido(s) como NA: %s%s.\n",
                              "Use empate = \"moda\" para o desempate por ",
                              "menor c\u00f3digo; veja ?cbo2002_para_isco."),
                       sum(emp),
                       paste(utils::head(unique(x[quatro][emp]), 5),
                             collapse = ", "),
                       if (length(unique(x[quatro][emp])) > 5) ", ..." else ""),
               "familia_empatada")
      }
    }
  }
  if (isTRUE(escada)) out <- .escada_cbo(x, out)$isco88
  out
}

#' Quao homogenea e a familia da CBO-2002?
#'
#' Devolve a proporcao das ocupacoes da familia que compartilham o ISCO
#' majoritario. Vale 1 quando a familia inteira cai num unico ISCO; abaixo
#' disso, traduzir pela familia mistura posicoes distintas.
#'
#' @section Concordancia so e afirmavel sobre familia vista inteira:
#' A tabua do MTE cobre metade da CBO-2002, e a concordancia era calculada
#' sobre as ocupacoes **vistas**, nao sobre a familia real. O efeito: 131
#' familias tinham UMA unica ocupacao na tabua e reportavam `concordancia = 1`
#' — o valor que sinaliza "sem ambiguidade nenhuma" — e em 87 delas a familia
#' de fato tem mais de uma ocupacao. Era certeza maxima onde a evidencia era
#' minima.
#'
#' Agora `concordancia` so recebe valor quando `cobertura_familia` vale 1, isto
#' e, quando a familia foi vista por inteiro (175 das 436). Nas demais fica
#' `NA`, e a proporcao entre as ocupacoes vistas segue disponivel em
#' `concordancia_vista`, sem posar de diagnostico. O denominador vem do dominio
#' oficial da CBO-2002 no Novo CAGED, 2.777 ocupacoes.
#'
#' @param cbo Vetor de codigos da CBO-2002 (familia ou ocupacao; a ocupacao e
#'   reduzida a sua familia).
#' @return `data.frame` com a familia, o ISCO majoritario, quantas ocupacoes
#'   foram vistas, quantas a familia tem de fato, a cobertura, quantos ISCO
#'   distintos aparecem, a concordancia (ou `NA`) e a marca de empate.
#' @examples
#' cbo2002_concordancia(c("5211", "4121"))
#' cbo2002_concordancia("3171")  # vista em 1/4: concordancia NA
#' @export
cbo2002_concordancia <- function(cbo) {
  f <- substr(.norm_cbo2002(cbo), 1, 4)
  i <- match(f, ocupacoesBR::cbo2002_familia_isco88$familia)
  # era a unica funcao de consulta do pacote que devolvia uma linha inteira de
  # NA em silencio para familia inexistente, contra a filosofia declarada em
  # ?checa_cobertura de falhar em voz alta
  .avisa_ausentes(f, i, "cbo2002_familia_isco88")
  out <- ocupacoesBR::cbo2002_familia_isco88[i, ]
  out$familia <- f
  rownames(out) <- NULL
  out
}

#' Indice socioeconomico ISEI a partir da CBO-2002
#'
#' @inheritParams cbo2002_para_isco
#' @return Vetor numerico com o escore ISEI-88.
#' @examples
#' cbo2002_para_isei(c("1111-05", "225120"))
#' @export
cbo2002_para_isei <- function(cbo, empate = c("na", "moda"), escada = FALSE) {
  .busca(cbo2002_para_isco(cbo, empate, escada), ocupacoesBR::isco88_medidas,
         "isco88", "isei88")
}

#' Prestigio ocupacional SIOPS a partir da CBO-2002
#'
#' @inheritParams cbo2002_para_isco
#' @return Vetor numerico com o escore SIOPS.
#' @examples
#' cbo2002_para_siops(c("1111-05", "225120"))
#' @export
cbo2002_para_siops <- function(cbo, empate = c("na", "moda"), escada = FALSE) {
  .busca(cbo2002_para_isco(cbo, empate, escada), ocupacoesBR::isco88_medidas,
         "isco88", "siops88")
}

#' Classe EGP a partir da CBO-2002
#'
#' Ao contrario do dado do TSE, o microdado que traz CBO costuma trazer tambem
#' posicao na ocupacao e supervisao — a RAIS e o eSocial identificam vinculo, e
#' varias pesquisas perguntam quantas pessoas o respondente chefia. Quando esses
#' campos existirem, passe-os: o EGP so sai completo com eles.
#'
#' @inheritParams cbo2002_para_isco
#' @inheritParams isco88_para_egp
#' @return Vetor de texto (ou inteiro, se `rotulo = FALSE`).
#' @examples
#' cbo2002_para_egp("521110", avisar = FALSE)
#' cbo2002_para_egp("521110", conta_propria = TRUE, n_supervisionados = 0)
#' @export
cbo2002_para_egp <- function(cbo, conta_propria = NULL, n_supervisionados = NULL,
                             n_classes = 11, rotulo = TRUE, avisar = TRUE) {
  isco88_para_egp(cbo2002_para_isco(cbo), conta_propria, n_supervisionados,
                  n_classes, rotulo, avisar)
}

#' ISCO-08 a partir da CBO-2002
#'
#' @inheritParams cbo2002_para_isco
#' @inheritParams isco88_para_isco08
#' @return Vetor de texto, ou um `data.frame` se `com_ambiguidade = TRUE`.
#' @examples
#' cbo2002_para_isco08("225120")
#' @export
cbo2002_para_isco08 <- function(cbo, com_ambiguidade = FALSE) {
  isco88_para_isco08(cbo2002_para_isco(cbo), com_ambiguidade)
}

#' Traduz a CBO-94 em ISCO-88
#'
#' Para microdado anterior a 2003, que usa a classificacao de 1994 (cinco
#' digitos). A correspondencia vem da mesma tabua oficial do Ministerio do
#' Trabalho, pela coluna CBO-94.
#'
#' @param cbo94 Vetor de codigos da CBO-94. Aceita "2-11.20" ou "21120".
#' @return Vetor de texto com o ISCO-88 de quatro digitos, ou `NA`.
#' @examples
#' cbo94_para_isco(c("2-11.20", "21130"))
#' @export
cbo94_para_isco <- function(cbo94) {
  .busca(.norm_cbo94(cbo94), ocupacoesBR::cbo94_isco88, "cbo94", "isco88",
         o_que = "cbo94_isco88")
}

#' Normaliza um codigo da CBO-94 (cinco digitos)
#' @noRd
.norm_cbo94 <- function(cbo94) {
  .checa_vetor(cbo94, "cbo94")
  if (is.factor(cbo94)) cbo94 <- as.character(cbo94)
  num <- is.numeric(cbo94)
  if (num) cbo94[!is.finite(cbo94)] <- NA
  cbo94 <- as.character(cbo94)
  if (!length(cbo94)) return(character(0))
  .por_unico(cbo94, function(u) {
    x <- trimws(u)
    x[is.na(x) | x == ""] <- NA_character_
    x[.e_sentinela(x)] <- NA_character_
    # a CBO-94 escreve-se "2-11.20": hifen e ponto sao separadores
    lim <- gsub("[-.[:space:]]", "", x)
    sujo <- !is.na(lim) & grepl("\\D", lim)
    lim[sujo] <- NA_character_
    # 231 dos 1.387 codigos comecam com zero, e a leitura numerica os come
    if (num) {
      curto <- !is.na(lim) & nchar(lim) %in% c(3L, 4L)
      lim[curto] <- formatC(as.integer(lim[curto]), width = 5L,
                            flag = "0", format = "d")
    }
    mau <- (!is.na(lim) & nchar(lim) != 5L) | sujo
    .trata_invalidos(lim, mau, u, "CBO-94", "deve ter 5 digitos")
  })
}

#' Indice socioeconomico ISEI a partir da CBO-94
#'
#' @inheritParams cbo94_para_isco
#' @return Vetor numerico com o escore ISEI-88.
#' @examples
#' cbo94_para_isei("2-11.20")
#' @export
cbo94_para_isei <- function(cbo94) {
  .busca(cbo94_para_isco(cbo94), ocupacoesBR::isco88_medidas, "isco88", "isei88")
}

#' Tabela completa de traducao a partir da CBO-2002
#'
#' @param cbo Vetor opcional de codigos. Se omitido, devolve a tabua inteira.
#' @inheritParams cbo2002_para_isco
#' @param escada Se `TRUE`, sobe a hierarquia da CBO para preencher as ocupacoes
#'   ausentes da tabua; veja [cbo2002_para_isco()]. A coluna `nivel_usado` sai
#'   de qualquer modo, e diz de que degrau veio o ISCO de cada linha: 6 e a
#'   propria ocupacao, 4 a familia, 3 o subgrupo, 2 o subgrupo principal.
#' @return `data.frame` com CBO-2002, titulo, familia, CBO-94, ISCO-88, ISCO-08,
#'   ISEI, SIOPS, EGP, `agregado`, `empate` e `nivel_usado`. `empate` e `TRUE`
#'   quando a linha e uma familia de quatro digitos sem ISCO majoritario; com
#'   `empate = "na"` (padrao) o ISCO dessa linha sai `NA`, exatamente como em
#'   [cbo2002_para_isco()] — a tabela nao pode devolver o que a porta recusa.
#' @examples
#' head(crosswalk_cbo2002())
#' crosswalk_cbo2002(c("1111-05", "225120"))
#' @export
crosswalk_cbo2002 <- function(cbo = NULL, empate = c("na", "moda"),
                              escada = FALSE) {
  empate <- match.arg(empate)
  tab <- ocupacoesBR::cbo2002_isco88
  if (is.null(cbo)) {
    d <- tab
    d$agregado <- FALSE
    d$empate   <- FALSE
  } else {
    x <- .norm_cbo2002(cbo)
    d <- tab[match(x, tab$cbo2002), ]
    d$cbo2002 <- x
    d$empate  <- FALSE
    # família de 4 dígitos: `cbo2002_para_isco()` a aceita, então a tabela
    # completa também precisa aceitar — antes devolvia uma linha toda NA.
    fam <- !is.na(x) & nchar(x) == 4L
    if (any(fam)) {
      j <- match(x[fam], ocupacoesBR::cbo2002_familia_isco88$familia)
      d$familia[fam] <- x[fam]
      d$titulo[fam]  <- NA_character_
      d$cbo94[fam]   <- NA_character_
      d$isco88[fam]  <- ocupacoesBR::cbo2002_familia_isco88$isco88[j]
      # a familia empatada e marcada sempre; com empate = "na" o ISCO tambem
      # cai, senao a tabela "auditavel" devolveria em silencio o vencedor do
      # desempate lexicografico que `cbo2002_para_isco()` recusa por padrao
      d$empate[fam]  <- ocupacoesBR::cbo2002_familia_isco88$empate[j] %in% TRUE
      if (empate == "na") d$isco88[fam & d$empate] <- NA_character_
    }
    d$agregado <- fam
  }
  # `nivel_usado` diz de que degrau da CBO veio o ISCO de cada linha — 6 e a
  # propria ocupacao, 2 e o subgrupo principal. Sai sempre, mesmo com a escada
  # desligada, porque a agregacao por familia ja existia e nunca foi declarada.
  esc <- .escada_cbo(d$cbo2002, d$isco88)
  if (isTRUE(escada)) {
    d$isco88 <- esc$isco88
    nivel <- esc$nivel
  } else {
    nivel <- ifelse(is.na(d$isco88), NA_integer_, nchar(d$cbo2002))
  }
  m <- match(d$isco88, ocupacoesBR::isco88_medidas$isco88)
  data.frame(
    d[, c("cbo2002", "titulo", "familia", "cbo94", "isco88")],
    isco08  = suppressWarnings(isco88_para_isco08(d$isco88)),
    isei88  = ocupacoesBR::isco88_medidas$isei88[m],
    siops88 = ocupacoesBR::isco88_medidas$siops88[m],
    egp     = isco88_para_egp(d$isco88, avisar = FALSE),
    agregado = d$agregado,
    empate   = d$empate,
    nivel_usado = nivel,
    stringsAsFactors = FALSE, row.names = NULL)
}

# ---------------------------------------------------------------------------
# atalhos que faltavam: a matriz de portas estava assimetrica
# ---------------------------------------------------------------------------
# O ISCO-88 e o HUB do pacote — e era a unica origem sem porta para o ISEI e
# para o prestigio. Quem chega de survey proprio, do ESS ou da PNAD via COD
# tinha de fazer merge na mao com `isco88_medidas`. E a CBO-94 parava no ISEI,
# sem que a documentacao dissesse por que.

#' Indice socioeconomico ISEI a partir do ISCO-88
#'
#' @param isco88 Vetor de codigos ISCO-88.
#' @return Vetor numerico com o escore ISEI-88.
#' @examples
#' isco88_para_isei(c("2221", "5220", "9130"))
#' @export
isco88_para_isei <- function(isco88) {
  .busca(.norm_isco(isco88), ocupacoesBR::isco88_medidas, "isco88", "isei88",
         o_que = "isco88_medidas")
}

#' Prestigio ocupacional de Treiman (SIOPS) a partir do ISCO-88
#'
#' @inheritParams isco88_para_isei
#' @return Vetor numerico com o escore de prestigio.
#' @examples
#' isco88_para_siops(c("2221", "5220", "9130"))
#' @export
isco88_para_siops <- function(isco88) {
  .busca(.norm_isco(isco88), ocupacoesBR::isco88_medidas, "isco88", "siops88",
         o_que = "isco88_medidas")
}

#' Prestigio ocupacional de Treiman a partir da CBO-94
#'
#' @inheritParams cbo94_para_isco
#' @return Vetor numerico com o escore de prestigio.
#' @examples
#' cbo94_para_siops("2-11.20")
#' @export
cbo94_para_siops <- function(cbo94) {
  .busca(cbo94_para_isco(cbo94), ocupacoesBR::isco88_medidas, "isco88",
         "siops88")
}

#' ISCO-08 a partir da CBO-94
#'
#' @inheritParams cbo94_para_isco
#' @inheritParams isco88_para_isco08
#' @return Vetor de texto com o ISCO-08, ou um `data.frame` se
#'   `com_ambiguidade = TRUE`.
#' @examples
#' cbo94_para_isco08("2-11.20")
#' @export
cbo94_para_isco08 <- function(cbo94, com_ambiguidade = FALSE) {
  isco88_para_isco08(cbo94_para_isco(cbo94), com_ambiguidade)
}

#' Classe EGP a partir da CBO-94
#'
#' Leia [isco88_para_egp()] antes de usar: sem posicao no emprego e supervisao,
#' o esquema sai degradado. Ao contrario do TSE, a RAIS TEM essas variaveis no
#' vinculo — vale passa-las.
#'
#' @inheritParams cbo94_para_isco
#' @inheritParams isco88_para_egp
#' @return Vetor de texto (ou inteiro, se `rotulo = FALSE`).
#' @examples
#' cbo94_para_egp("2-11.20", avisar = FALSE)
#' @export
cbo94_para_egp <- function(cbo94, conta_propria = NULL,
                           n_supervisionados = NULL, n_classes = 11,
                           rotulo = TRUE, avisar = TRUE) {
  isco88_para_egp(cbo94_para_isco(cbo94), conta_propria, n_supervisionados,
                  n_classes, rotulo, avisar)
}

#' ISEI-08 a partir da CBO-2002
#'
#' @inheritParams cbo2002_para_isco
#' @return Vetor numerico com o escore ISEI-08.
#' @examples
#' cbo2002_para_isei08("225120")
#' @export
cbo2002_para_isei08 <- function(cbo, empate = c("na", "moda"),
                                escada = FALSE) {
  i08 <- isco88_para_isco08(cbo2002_para_isco(cbo, empate, escada))
  .busca(i08, ocupacoesBR::isco08_medidas, "isco08", "isei08")
}

#' Prestigio ancorado na ISCO-08 a partir da CBO-2002
#'
#' @inheritParams cbo2002_para_isco
#' @return Vetor numerico com o escore de prestigio.
#' @examples
#' cbo2002_para_siops08("225120")
#' @export
cbo2002_para_siops08 <- function(cbo, empate = c("na", "moda"),
                                 escada = FALSE) {
  i08 <- isco88_para_isco08(cbo2002_para_isco(cbo, empate, escada))
  .busca(i08, ocupacoesBR::isco08_medidas, "isco08", "siops08")
}

#' Verifica a cobertura de codigos da CBO-94
#'
#' Equivalente de [checa_cobertura_cbo2002()] para o microdado anterior a 2003.
#'
#' @param cbo94 Vetor de codigos da CBO-94 observados no seu dado.
#' @param silencioso Se `TRUE`, nao escreve a mensagem de sucesso.
#' @return Invisivelmente, `TRUE`.
#' @examples
#' checa_cobertura_cbo94(c("2-11.20", "21130"))
#' @export
checa_cobertura_cbo94 <- function(cbo94, silencioso = FALSE) {
  obs <- unique(.norm_cbo94(cbo94))
  obs <- obs[!is.na(obs)]
  if (!length(obs))
    stop("nenhum c\u00f3digo da CBO-94 v\u00e1lido em `cbo94`",
         if (is.null(cbo94)) " (o vetor \u00e9 NULL \u2014 confira o nome da coluna)"
         else if (!length(cbo94)) " (o vetor est\u00e1 vazio)"
         else " (todos os valores s\u00e3o NA)", ".", call. = FALSE)
  sem <- setdiff(obs, ocupacoesBR::cbo94_isco88$cbo94)
  if (length(sem))
    .aviso(sprintf(paste0("%d c\u00f3digo(s) da CBO-94 sem correspond\u00eancia ",
                          "na t\u00e1bua do MTE: %s%s."),
                   length(sem), paste(utils::head(sem, 10), collapse = ", "),
                   if (length(sem) > 10) ", ..." else ""),
           "sem_correspondencia")
  if (!silencioso)
    message(sprintf("cobertura CBO-94: %d c\u00f3digos, %d com correspond\u00eancia.",
                    length(obs), length(obs) - length(sem)))
  invisible(TRUE)
}

#' Tabela completa de traducao a partir da CBO-94
#'
#' @param cbo94 Vetor opcional de codigos. Se omitido, devolve a tabua inteira.
#' @return `data.frame` com CBO-94, ISCO-88, ISCO-08, ISEI-88, prestigio e EGP.
#' @examples
#' head(crosswalk_cbo94())
#' @export
crosswalk_cbo94 <- function(cbo94 = NULL) {
  k <- if (is.null(cbo94)) ocupacoesBR::cbo94_isco88$cbo94 else .norm_cbo94(cbo94)
  i <- match(k, ocupacoesBR::cbo94_isco88$cbo94)
  .avisa_ausentes(k, i, "cbo94_isco88")
  isco <- ocupacoesBR::cbo94_isco88$isco88[i]
  m <- match(isco, ocupacoesBR::isco88_medidas$isco88)
  data.frame(
    cbo94   = k,
    isco88  = isco,
    isco08  = suppressWarnings(isco88_para_isco08(isco)),
    isei88  = ocupacoesBR::isco88_medidas$isei88[m],
    siops88 = ocupacoesBR::isco88_medidas$siops88[m],
    egp     = isco88_para_egp(isco, avisar = FALSE),
    stringsAsFactors = FALSE, row.names = NULL)
}
