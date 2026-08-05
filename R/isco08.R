# ---------------------------------------------------------------------------
# ponte ISCO-88 -> ISCO-08 e as medidas ancoradas na ISCO-08
# ---------------------------------------------------------------------------

#' Converte ISCO-88 em ISCO-08
#'
#' Aplica a conversão publicada no módulo `isco8808.sps` do ISMF, derivada da
#' correspondência oficial da Organização Internacional do Trabalho.
#'
#' @section A ponte é ambígua e a ambiguidade importa:
#' A OIT define, para muitos códigos da ISCO-88, mais de um destino possível na
#' ISCO-08. A sintaxe original guarda esse número na parte decimal e instrui a
#' truncá-lo quando não houver informação adicional. O pacote trunca, como
#' manda, mas **preserva a contagem** em `n_alternativas` na tabela
#' [isco88_isco08], e [tse_para_isco08()] pode devolvê-la. Cerca de um terço dos
#' pares tem mais de uma alternativa: a conversão é uma escolha razoável, não um
#' equivalente exato.
#'
#' @param isco88 Vetor de códigos ISCO-88.
#' @param com_ambiguidade Se `TRUE`, devolve um `data.frame` com o código e o
#'   número de alternativas da OIT em vez de só o código.
#' @return Vetor de texto com o ISCO-08, ou um `data.frame` se
#'   `com_ambiguidade = TRUE`.
#' @examples
#' isco88_para_isco08(c("2211", "1300"))
#' isco88_para_isco08(c("2211", "1300"), com_ambiguidade = TRUE)
#' @export
isco88_para_isco08 <- function(isco88, com_ambiguidade = FALSE) {
  k <- .norm_isco(isco88)
  i <- match(k, ocupacoesBR::isco88_isco08$isco88)
  .avisa_ausentes(k, i, "isco88_isco08")
  if (!com_ambiguidade) return(ocupacoesBR::isco88_isco08$isco08[i])
  data.frame(isco88 = k,
             isco08 = ocupacoesBR::isco88_isco08$isco08[i],
             n_alternativas = ocupacoesBR::isco88_isco08$n_alternativas[i],
             stringsAsFactors = FALSE)
}

#' ISCO-08 da ocupação declarada ao TSE
#'
#' @inheritParams tse_para_isco
#' @inheritParams isco88_para_isco08
#' @return Vetor de texto, ou um `data.frame` se `com_ambiguidade = TRUE`.
#' @examples
#' tse_para_isco08(c(111, 169))
#' @export
tse_para_isco08 <- function(cod, com_ambiguidade = FALSE, ano = NULL) {
  isco88_para_isco08(tse_para_isco(cod, ano), com_ambiguidade)
}

#' ISEI-08 da ocupação declarada ao TSE
#'
#' Escore ISEI ancorado na ISCO-08, obtido pela ponte a partir do ISCO-88.
#'
#' @section Quando *não* usar:
#' Para comparar candidaturas entre si, prefira [tse_para_isei()], na ISCO-88:
#' o pacote é ancorado nela e a ponte introduz erro. O ISEI-08 serve para juntar
#' o dado eleitoral a fontes que já classificam por ISCO-08 — a PNAD Contínua,
#' via COD, é o caso típico. As duas réguas correlacionam-se fortemente no
#' agregado, mas alguns deslocamentos individuais são grandes: o produtor
#' agropecuário do TSE, por exemplo, cai cerca de 25 pontos ao mudar de âncora,
#' porque 1311 (dirigente de empresa agropecuária) na ISCO-88 vira 6130
#' (produtor agropecuário misto) na ISCO-08.
#'
#' @inheritParams tse_para_isco
#' @return Vetor numérico com o escore ISEI-08.
#' @examples
#' data.frame(cod = c(111, 234), isei88 = tse_para_isei(c(111, 234)),
#'            isei08 = tse_para_isei08(c(111, 234)))
#' @export
tse_para_isei08 <- function(cod, ano = NULL) {
  .busca(tse_para_isco08(cod, ano = ano), ocupacoesBR::isco08_medidas, "isco08", "isei08")
}

#' SIOPS-08 da ocupação declarada ao TSE
#'
#' @inheritParams tse_para_isco
#' @return Vetor numérico com o escore SIOPS ancorado na ISCO-08.
#' @examples
#' tse_para_siops08(c(111, 169))
#' @export
tse_para_siops08 <- function(cod, ano = NULL) {
  .busca(tse_para_isco08(cod, ano = ano), ocupacoesBR::isco08_medidas, "isco08", "siops08")
}
