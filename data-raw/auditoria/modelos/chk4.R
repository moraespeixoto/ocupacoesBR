suppressMessages(library(ocupacoesBR))
cat("== ambiguidade da ponte ISCO88->ISCO08 no dicionario do TSE ==\n")
a <- tse_para_isco08(tse_isco$cod_tse[!is.na(tse_isco$isco88)], com_ambiguidade=TRUE)
print(table(a$n_alternativas, useNA="ifany"))
cat("\nfracao com mais de 1 destino:",
    round(mean(a$n_alternativas > 1, na.rm=TRUE), 3), "\n")
cat("\n== codigos-lixo tipicos de RAIS/CAGED ==\n")
for (v in c("999999","000000","      ","-1")) {
  r <- tryCatch(cbo2002_para_isco(v), error=function(e) paste("ERRO:", conditionMessage(e)),
                warning=function(w) paste("AVISO:", conditionMessage(w)))
  cat(sprintf("%-8s -> %s\n", dQuote(v), paste(r, collapse=",")))
}
