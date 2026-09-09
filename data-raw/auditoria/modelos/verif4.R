e <- new.env(); load("/dados/novissimos_dados_tse/resultados_eleicoes_98_24.Rda", envir=e)
d <- get(ls(e)[1], envir=e)
cat("objeto:", ls(e)[1], "| linhas:", nrow(d), "\n")
cn <- names(d)[grepl("OCUPACAO|ANO_ELEICAO", names(d), ignore.case=TRUE)]
cat("colunas relevantes:", paste(cn, collapse=", "), "\n\n")
d$ANO <- d$ANO_ELEICAO; d$CD <- as.character(d$CD_OCUPACAO); d$DS <- as.character(d$DS_OCUPACAO)

cat("=== ACHADO 1: DS_OCUPACAO esta preenchido em todas as eleicoes? ===\n")
vazio <- function(x) is.na(x) | trimws(x)=="" | x=="#NULO#"
print(tapply(d$DS, d$ANO, function(z) sprintf("n=%d vazios=%d", length(z), sum(vazio(z)))))

cat("\n=== ACHADO 2: o codigo 215 mudou de ocupacao? ===\n")
s <- d[d$CD=="215", ]
tb <- table(s$ANO, s$DS)
for (a in rownames(tb)) {
  r <- tb[a,]; r <- r[r>0]
  cat(sprintf("  %s: %s\n", a, paste(sprintf("%s (%d)", names(r), r), collapse=" | ")))
}
