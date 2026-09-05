# 00_confere_proveniencia.R — as fontes ainda são as que geraram os dados?
#
# Rode ANTES de 01_, 02_ e 03_. Se uma fonte mudou — porque o MTE republicou a
# tábua, porque alguém editou um .sps à mão, porque um download veio truncado —
# é aqui que se descobre, e não seis meses depois num resultado que não replica.
#
# Rodar:  Rscript data-raw/00_confere_proveniencia.R

FONTES <- "inst/extdata/fontes"
YML    <- "inst/extdata/PROVENIENCIA.yml"

stopifnot(file.exists(YML), dir.exists(FONTES))
l <- readLines(YML, warn = FALSE, encoding = "UTF-8")

campo <- function(chave) {
  pad <- sprintf("^\\s*(-\\s*)?%s:\\s*", chave)   # o "- " abre item de lista
  trimws(sub(pad, "", grep(pad, l, value = TRUE)))
}
arquivos <- campo("arquivo")
hashes   <- campo("sha256")
stopifnot(length(arquivos) == length(hashes), length(arquivos) > 0)

atual <- vapply(file.path(FONTES, arquivos), function(p)
  if (file.exists(p)) as.character(tools::sha256sum(p)) else NA_character_,
  character(1), USE.NAMES = FALSE)

sumiu  <- is.na(atual)
mudou  <- !sumiu & atual != hashes
# fonte no disco que o registro não conhece: entrou sem passar pela proveniência
no_disco <- sub(paste0("^", FONTES, "/"), "",
                list.files(FONTES, recursive = TRUE, full.names = TRUE))
extra <- setdiff(no_disco, arquivos)

relata <- function(rotulo, quais) if (length(quais))
  message(sprintf("  %s (%d): %s", rotulo, length(quais),
                  paste(quais, collapse = ", ")))

if (any(sumiu) || any(mudou) || length(extra)) {
  message("PROVENIÊNCIA DIVERGENTE:")
  relata("ausentes", arquivos[sumiu])
  relata("alteradas", arquivos[mudou])
  relata("fora do registro", extra)
  if (any(sumiu) || any(mudou))
    stop("as fontes não são as que geraram os dados do pacote.\n",
         "Se a mudança foi deliberada, atualize ", YML, " e REGERE os dados ",
         "com 01_, 02_ e 03_ — nunca só o hash.", call. = FALSE)
  warning("há fonte fora do registro de proveniência.", call. = FALSE)
} else {
  message(sprintf("proveniência ok: %d fontes conferem com %s.",
                  length(arquivos), YML))
}

# --- a referência da conferência cruzada ------------------------------------
# O DIGCLASS não é fonte de dado nenhum: é a única implementação independente
# contra a qual R/egp.R é validado (test-fonte.R). Não vem de repositório —
# instala-se do HEAD do GitHub —, então a referência pode mudar sob o teste sem
# aviso. Aqui só se compara o que está instalado com o que está registrado.
reg <- campo("versao")
if (length(reg)) {
  if (!requireNamespace("DIGCLASS", quietly = TRUE)) {
    message(sprintf("conferência cruzada: DIGCLASS %s registrado, não instalado ",
                    reg[1]), "— o teste do EGP vai pular.")
  } else {
    inst <- as.character(utils::packageVersion("DIGCLASS"))
    if (identical(inst, reg[1]))
      message(sprintf("conferência cruzada ok: DIGCLASS %s, como registrado.",
                      reg[1]))
    else
      warning(sprintf(paste0("o DIGCLASS instalado (%s) não é o da conferência ",
                             "registrada (%s). Reveja o teste do EGP e atualize ",
                             "%s — a referência mudou, não o pacote."),
                      inst, reg[1], YML), call. = FALSE)
  }
}
