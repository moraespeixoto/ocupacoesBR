# ============================================================================
# constroi_site.R — o site do pacote, e a peneira que ele exige
# ----------------------------------------------------------------------------
# O pkgdown transforma em pagina TODO arquivo .md da raiz do repositorio e de
# .github/, sem opcao de exclusao (veja pkgdown:::package_mds). Neste
# repositorio a raiz guarda arquivos que sao de trabalho e nao do pacote: o
# ferramental de assistentes de IA (AGENTS.md, CLAUDE.md, GEMINI.md, ...) e os
# registros datados de auditoria. Todos estao no .gitignore, nenhum deve ser
# publicado.
#
# Nao basta apagar as paginas depois do build: o indice de busca e o sitemap
# guardam o TEXTO desses arquivos, e apagar o .html deixa o conteudo dentro do
# search.json. Por isso o script os esconde ANTES de construir e os devolve
# depois, com `on.exit` para que voltem mesmo se o build falhar.
#
# A lista abaixo e uma LISTA BRANCA: e publicado o que ela preve, e escondido
# todo o resto. Assim um arquivo de trabalho novo na raiz nao vaza para o site
# por esquecimento.
#
# Rodar: Rscript data-raw/constroi_site.R
#
# QUEM PUBLICA, desde 09/09/2026: nao e este script rodado na sua maquina. O
# workflow pkgdown roda ESTE MESMO script no runner a cada push em main e
# publica o docs/ que ele gera no branch gh-pages, que e de onde o GitHub Pages
# serve o site. O docs/ da sua maquina nao e mais versionado (esta no
# .gitignore) e nao sai daqui.
#
# Rodar localmente continua valendo para uma coisa: CONFERIR o site antes de
# empurrar, abrindo docs/index.html. Se o que voce ve local estiver certo, o que
# o runner publica sera igual -- ele parte do mesmo script e do mesmo commit.
# ============================================================================

# os .md da raiz que SAO do pacote e devem virar pagina
PUBLICAVEIS <- c("README.md", "index.md", "NEWS.md", "LICENSE.md", "LICENCE.md",
                 "cran-comments.md", "404.md")

# Tudo dentro de uma funcao: `on.exit` no nivel de topo de um script dispara
# assim que a expressao termina, e nao no fim do script — os arquivos ficariam
# escondidos.
constroi <- function() {

mds <- c(list.files(".", pattern = "\\.md$"),
         list.files(".github", pattern = "\\.md$", full.names = TRUE))
esconder <- setdiff(mds, PUBLICAVEIS)

# O disfarce e uma extensao a mais, no mesmo diretorio: renomear para outro
# sistema de arquivos falha, e o /tmp aqui e outra particao.
if (length(esconder)) {
  destinos <- paste0(esconder, ".oculto")
  message("Escondidos do pkgdown durante o build:")
  for (m in esconder) message("  - ", m)
  stopifnot(all(file.rename(esconder, destinos)))
  on.exit(stopifnot(all(file.rename(destinos, esconder))), add = TRUE)
}

pkgdown::build_site(preview = FALSE)

}

constroi()

message("\nSite em docs/. Abra docs/index.html antes de commitar.")
