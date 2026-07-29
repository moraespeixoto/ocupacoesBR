library(ocupacoesBR)
cat("locale LC_CTYPE:", Sys.getlocale("LC_CTYPE"), "| LC_COLLATE:", Sys.getlocale("LC_COLLATE"), "\n")
cat("Encoding(dado):", Encoding(tse_isco$classe[match("291", tse_isco$cod_tse)]), "\n")
lit <- "Vínculo público não especificado"
cat("Encoding(literal):", Encoding(lit), "\n")
dado <- tse_isco$classe[match("291", tse_isco$cod_tse)]
cat("dado ==  literal ?", identical(dado==lit, TRUE), "\n")
r <- tse_para_classe(c("291","291"), superior=c(TRUE,FALSE))
cat("resultado do corte:", r, "\n")
cat("O CORTE FUNCIONOU?", !any(r == lit), "\n")
cat("bytes dado:", paste(sprintf("%02x", as.integer(charToRaw(dado))[1:8]), collapse=" "), "\n")
