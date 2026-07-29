suppressMessages(library(ocupacoesBR))
cat("=== NA em `superior` -> 'medio ou menos', em silencio ===\n")
print(suppressWarnings(tse_para_classe(c("291","291","291"), superior=c(TRUE,FALSE,NA))))
cat("\n=== superior numerico 0/1 e 2 (fora do dominio) ===\n")
print(suppressWarnings(tse_para_classe(c("291","291"), superior=c(2, -1))))
cat("\n=== codigos TSE com classe/estrato substantivos mas ISCO NA ===\n")
d <- suppressWarnings(crosswalk_tse())
print(d[is.na(d$isco88) & !d$estrato %in% c("Fora da PEA / não informado","Vínculo público não especificado"),
        c("cod_tse","isco88","isei88","classe","estrato","componente_alta")])
cat("\n=== o que crosswalk_tse() NAO devolve ===\n")
print(names(d))
cat("nivel presente em tse_isco mas ausente do crosswalk:", "nivel" %in% names(ocupacoesBR::tse_isco),
    "/", "nivel" %in% names(d), "\n")
cat("n_alternativas da ponte no crosswalk:", "n_alternativas" %in% names(d), "\n")

cat("\n=== proprietarios: classe alta com ISEI de classe media ===\n")
print(d[d$proprietario, c("cod_tse","isco88","isei88","classe","estrato","egp")])

cat("\n=== EGP: classes estruturalmente vazias ===\n")
e <- suppressWarnings(tse_para_egp(ocupacoesBR::tse_isco$cod_tse, avisar=FALSE))
faltam <- setdiff(c("IVa: conta própria com empregados","IVb: conta própria sem empregados",
                    "V: supervisores manuais"), unique(e))
cat("ausentes:", paste(faltam, collapse=" | "), "\n")

cat("\n=== hash/versao das fontes? ===\n")
