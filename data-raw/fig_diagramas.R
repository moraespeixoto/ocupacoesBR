# ============================================================================
# fig_diagramas.R — os fluxogramas do site, de mermaid para SVG
# ----------------------------------------------------------------------------
# Cada diagrama e um .qmd em data-raw/figuras/ com um unico bloco mermaid.
# O quarto renderiza com `mermaid-format: svg`, que embute o SVG dentro do
# HTML; este script extrai esse SVG e grava um arquivo autonomo em
# man/figures/.
#
# Por que SVG pre-renderizado, e nao mermaid ao vivo no navegador: assim o
# desenho funciona offline, pode ser reusado no artigo de metodo, e nao depende
# de um script de terceiros carregado de CDN.
#
# Por que em vignettes/articles/figuras e nao em man/figures: estes desenhos
# sao conteudo do site, nao da documentacao instalada. vignettes/articles fica
# fora do tarball (ver .Rbuildignore), entao o pacote nao engorda.
#
# Por que o conserto de maiusculas abaixo: o SVG sai de dentro de um HTML, e o
# parser de HTML rebaixa todo nome de atributo para minusculas. Num arquivo
# .svg servido como XML isso importa — `viewbox` nao e `viewBox`, e sem ele o
# desenho perde a caixa de recorte. A lista restaura os nomes que o mermaid
# usa.
#
# Rodar: Rscript data-raw/fig_diagramas.R
# ============================================================================

ENTRADA <- "data-raw/figuras"
SAIDA   <- "vignettes/articles/figuras"

if (Sys.which("quarto") == "")
  stop("quarto nao encontrado no PATH; ele e quem renderiza o mermaid.")

dir.create(SAIDA, showWarnings = FALSE, recursive = TRUE)

# nomes de atributo SVG que o parser de HTML rebaixa e o XML exige de volta
CAMEL <- c(viewbox = "viewBox", markerwidth = "markerWidth",
           markerheight = "markerHeight", markerunits = "markerUnits",
           refx = "refX", refy = "refY", gradientunits = "gradientUnits",
           patternunits = "patternUnits", clippath = "clipPath",
           stddeviation = "stdDeviation", textlength = "textLength",
           startoffset = "startOffset",
           preserveaspectratio = "preserveAspectRatio")

extrai_svg <- function(html) {
  txt <- paste(readLines(html, warn = FALSE, encoding = "UTF-8"),
               collapse = "\n")
  svg <- regmatches(txt, regexpr("(?s)<svg\\b.*?</svg>", txt, perl = TRUE))
  if (!length(svg)) stop("nenhum <svg> em ", html)
  for (k in names(CAMEL))
    svg <- gsub(paste0(" ", k, "="), paste0(" ", CAMEL[[k]], "="), svg,
                fixed = TRUE)
  # o `xmlns:xlink` chega mutilado como `xlink`; `data-xmlns` e lixo do quarto
  svg <- sub(" xlink=", " xmlns:xlink=", svg, fixed = TRUE)
  svg <- gsub(" data-xmlns=\"[^\"]*\"", "", svg)
  # sem `xml:space`, o SVG descarta o espaco inicial de cada <tspan>, e o
  # mermaid quebra os rotulos justamente em tspans por palavra: sem isto,
  # "o codigo declarado" e desenhado como "ocodigodeclarado".
  svg <- gsub("<text ", "<text xml:space=\"preserve\" ", svg, fixed = TRUE)
  # o quarto carimba width/height fixos vindos das dimensoes de figura dele, o
  # que emoldura o desenho em espaco vazio. Sem eles, e com o viewBox intacto,
  # o SVG escala para a largura do texto e mantem a propria proporcao.
  svg <- sub("^(<svg[^>]*?) width=\"[^\"]*\"", "\\1", svg, perl = TRUE)
  sub("^(<svg[^>]*?) height=\"[^\"]*\"", "\\1", svg, perl = TRUE)
}

qmds <- sort(list.files(ENTRADA, pattern = "\\.qmd$", full.names = TRUE))
if (!length(qmds)) stop("nenhum .qmd em ", ENTRADA)

for (q in qmds) {
  nome <- sub("\\.qmd$", "", basename(q))
  message("--- ", nome)
  st <- system2("quarto", c("render", shQuote(q)),
                stdout = TRUE, stderr = TRUE)
  html <- file.path(ENTRADA, paste0(nome, ".html"))
  if (!file.exists(html)) {
    cat(st, sep = "\n")
    stop("o quarto nao gerou ", html)
  }
  destino <- file.path(SAIDA, paste0(nome, ".svg"))
  writeLines(extrai_svg(html), destino, useBytes = TRUE)

  # o HTML e o diretorio de bibliotecas sao rascunho: so o .svg fica
  unlink(html)
  unlink(file.path(ENTRADA, paste0(nome, "_files")), recursive = TRUE)

  message("    ", destino, " (", file.size(destino), " bytes)")
}

message("\nPronto. Confira cada SVG antes de commitar: o desenho nao pode\n",
        "afirmar nada que o pacote nao faca.")
