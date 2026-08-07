# ---------------------------------------------------------------------------
# tabela completa e verificação de cobertura
# ---------------------------------------------------------------------------

#' Tabela completa de tradução, do TSE a todas as medidas
#'
#' Devolve, num único `data.frame`, tudo o que o pacote sabe sobre cada código
#' de ocupação do TSE. Serve para inspecionar a medida antes de aplicá-la, para
#' publicar como material suplementar de um artigo e para auditar decisões de
#' classificação uma a uma.
#'
#' @param cod Vetor opcional de códigos. Se omitido, devolve o dicionário
#'   inteiro.
#' @return `data.frame` com o código do TSE, ISCO-88, ISCO-08, ISEI-88, ISEI-08,
#'   SIOPS, EGP, classe, estrato, componente da classe alta e as marcas de
#'   ocupação política e de proprietário.
#' @examples
#' head(crosswalk_tse())
#' crosswalk_tse(c(111, 169, 257))
#' @export
crosswalk_tse <- function(cod = NULL) {
  k <- if (is.null(cod)) ocupacoesBR::tse_isco$cod_tse else .norm_tse(cod)
  # um único match para todas as colunas: além de ~3x mais rápido, evita o
  # mesmo aviso ser emitido oito vezes pelo mesmo código desconhecido.
  i <- match(k, ocupacoesBR::tse_isco$cod_tse)
  .avisa_ausentes(k, i, "tse_isco")
  d    <- ocupacoesBR::tse_isco
  isco <- d$isco88[i]
  m    <- match(isco, ocupacoesBR::isco88_medidas$isco88)
  p    <- match(isco, ocupacoesBR::isco88_isco08$isco88)
  # A tabela auditável tem de mostrar o que `tse_para_isco08()` devolve, e não
  # a ponte crua: as duas correções do passo TSE -> ISCO-08 (promoção do
  # proprietário por `iskopromo.sps` e refinamento por rótulo) vivem numa única
  # função interna, chamada aqui e lá. Veja `.corrige_isco08_tse` em R/isco08.R.
  isco08 <- .corrige_isco08_tse(k, ocupacoesBR::isco88_isco08$isco08[p])
  m08  <- match(isco08, ocupacoesBR::isco08_medidas$isco08)
  # --- réguas de qualidade da tradução --------------------------------------
  # Sem elas o quadro apresenta um ISEI de 2 dígitos e um de 4 com a mesma
  # tipografia. O erro de medida resultante não é ruído: é heterocedástico e
  # correlacionado com o estrato, porque foram as ocupações de topo que
  # receberam refinamento a 3 e 4 dígitos.
  n_alt <- ocupacoesBR::isco88_isco08$n_alternativas[p]
  # quantos códigos do TSE dividem este mesmo ISCO-88 (fusão: 258 -> 41)
  freq  <- table(ocupacoesBR::tse_isco$isco88)
  n_dst <- as.integer(freq[isco])
  qual  <- ifelse(is.na(isco), NA_character_,
           ifelse(!is.na(n_alt) & n_alt > 1L, "amb\u00edgua",
           ifelse(d$nivel[i] >= 4L,           "exata",
                                              "agregada")))
  # O rotulo faltava, e sem ele a funcao nao serve ao uso que a propria
  # documentacao anuncia: ninguem audita "169 -> 1300 -> 51 -> Proprietarios"
  # sem saber que 169 e COMERCIANTE. Todo o valor autoral do pacote esta neste
  # primeiro elo, que e um mapeamento semantico sem validacao externa — retirar
  # os rotulos retirava justamente a chance de auditar a parte nao verificavel.
  data.frame(
    cod_tse         = k,
    rotulo          = tse_para_rotulo(k),
    isco88          = isco,
    isco08          = isco08,
    isei88          = ocupacoesBR::isco88_medidas$isei88[m],
    isei08          = ocupacoesBR::isco08_medidas$isei08[m08],
    siops88         = ocupacoesBR::isco88_medidas$siops88[m],
    # A chamada era `isco88_para_egp(isco, avisar = FALSE)`: o `avisar = FALSE`
    # fixo silenciava justamente o aviso de EGP degradado, e a coluna saía com
    # IVa, IVb e V ZERADAS — a pequena burguesia contada como classe de serviço,
    # numa tabela que a documentação manda publicar como material suplementar.
    # A marca `proprietario` é o SEMPL do ISMF e estava aqui o tempo todo.
    egp             = isco88_para_egp(isco, conta_propria = d$proprietario[i],
                                      avisar = FALSE),
    classe          = d$classe[i],
    estrato         = d$estrato[i],
    componente_alta = d$componente_alta[i],
    politico        = d$politico[i],
    proprietario    = d$proprietario[i],
    nivel           = d$nivel[i],
    n_destinos_tse  = n_dst,
    n_alt_08        = n_alt,
    qualidade       = qual,
    stringsAsFactors = FALSE, row.names = NULL)
}

#' Verifica se todos os códigos observados estão no dicionário
#'
#' Falha com erro se algum código de ocupação presente no seu dado não tiver
#' entrada no dicionário do pacote, **ou se não houver código nenhum**. Chame
#' antes de qualquer análise.
#'
#' @section Por que isto existe:
#' O modo silencioso de errar uma medida de classe não é classificar mal um
#' caso: é um código novo cair num rótulo residual sem que ninguém perceba. Foi
#' o que aconteceu na primeira versão deste dicionário, em que 76 códigos reais
#' caíam no rótulo "fora da PEA" — inclusive proprietários, que somem
#' justamente da categoria em que mais importam.
#'
#' O segundo modo silencioso é mais banal e mais comum: passar a coluna errada.
#' `dados$CD_OCUPACAO` num quadro cuja coluna se chama `cd_ocupacao` devolve
#' `NULL`, e uma verificação ingênua aprovaria o vetor vazio. Por isso entrada
#' vazia, `NULL` ou inteiramente ausente também é erro aqui.
#'
#' @param cod Vetor de códigos de ocupação observados no seu dado.
#' @param silencioso Se `TRUE`, não escreve a mensagem de sucesso.
#' @return Invisivelmente, `TRUE`. Erro se houver código fora do dicionário ou
#'   se não houver código válido algum.
#' @examples
#' checa_cobertura(c(111, 169, 257))
#' try(checa_cobertura(c(111, 99999)))
#' try(checa_cobertura(NULL))
#' @export
checa_cobertura <- function(cod, silencioso = FALSE) {
  obs <- unique(.norm_tse(cod))
  obs <- obs[!is.na(obs)]
  if (!length(obs))
    stop("nenhum c\u00f3digo de ocupa\u00e7\u00e3o v\u00e1lido em `cod`",
         if (is.null(cod)) " (o vetor \u00e9 NULL \u2014 confira o nome da coluna)"
         else if (!length(cod)) " (o vetor est\u00e1 vazio)"
         else " (todos os valores s\u00e3o NA)", ".", call. = FALSE)
  fora <- setdiff(obs, ocupacoesBR::tse_isco$cod_tse)
  if (length(fora))
    stop("c\u00f3digo(s) de ocupa\u00e7\u00e3o sem entrada no dicion\u00e1rio: ",
         paste(utils::head(fora, 20), collapse = ", "),
         if (length(fora) > 20) sprintf(" (e mais %d)", length(fora) - 20) else "",
         ".\nSe forem c\u00f3digos novos do TSE, abra uma issue no reposit\u00f3rio do ",
         "pacote \u2014 o dicion\u00e1rio precisa ser estendido, e n\u00e3o contornado.",
         call. = FALSE)
  isco <- stats::na.omit(unique(tse_para_isco(obs)))
  sem  <- setdiff(isco, ocupacoesBR::isco88_medidas$isco88)
  if (length(sem))
    stop("ISCO-88 sem medidas associadas: ", paste(sem, collapse = ", "),
         call. = FALSE)
  if (!silencioso)
    message(sprintf("cobertura ok: %d c\u00f3digos observados, todos no dicion\u00e1rio.",
                    length(obs)))
  invisible(TRUE)
}

#' Verifica a cobertura de códigos da CBO-2002
#'
#' Equivalente de [checa_cobertura()] para a porta da CBO. Distingue o código
#' que não existe na CBO-2002 daquele que existe mas **não tem correspondência
#' oficial** com a CIUO-88 — este último é limite da tábua do Ministério do
#' Trabalho, não erro do seu dado, e por isso vira aviso, não erro.
#'
#' @param cbo Vetor de códigos da CBO-2002 observados no seu dado.
#' @param silencioso Se `TRUE`, não escreve a mensagem de sucesso.
#' @return Invisivelmente, `TRUE`.
#' @examples
#' checa_cobertura_cbo2002(c("1111-05", "225120"))
#' try(checa_cobertura_cbo2002(NULL))
#' @export
checa_cobertura_cbo2002 <- function(cbo, silencioso = FALSE) {
  obs <- unique(.norm_cbo2002(cbo))
  obs <- obs[!is.na(obs)]
  if (!length(obs))
    stop("nenhum c\u00f3digo da CBO-2002 v\u00e1lido em `cbo`",
         if (is.null(cbo)) " (o vetor \u00e9 NULL \u2014 confira o nome da coluna)"
         else if (!length(cbo)) " (o vetor est\u00e1 vazio)"
         else " (todos os valores s\u00e3o NA)", ".", call. = FALSE)
  sem <- obs[is.na(suppressWarnings(cbo2002_para_isco(obs)))]
  if (length(sem))
    .aviso(sprintf(paste0("%d c\u00f3digo(s) da CBO-2002 sem correspond\u00eancia ",
                          "oficial com a CIUO-88: %s%s.\nA t\u00e1bua do MTE s\u00f3 ",
                          "cobre ocupa\u00e7\u00f5es presentes tamb\u00e9m na CBO-94; ",
                          "veja ?cbo2002_para_isco."),
                   length(sem), paste(utils::head(sem, 10), collapse = ", "),
                   if (length(sem) > 10) ", ..." else ""),
           "sem_correspondencia")
  if (!silencioso)
    message(sprintf("cobertura CBO-2002: %d c\u00f3digos, %d com correspond\u00eancia.",
                    length(obs), length(obs) - length(sem)))
  invisible(TRUE)
}
