library(ocupacoesBR)
tab <- DIGCLASS::all_schemas$isco88_to_egp11
cat("colunas de DIGCLASS:\n"); print(names(tab)); cat("nrow:", nrow(tab), "\n")
print(utils::head(as.data.frame(tab), 3))
