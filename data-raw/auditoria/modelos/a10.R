library(ocupacoesBR)
cat("codigos do grupo 0 em isco88_medidas:\n")
print(grep("^0", isco88_medidas$isco88, value=TRUE))
cat("\n'0110' presente?", "0110" %in% isco88_medidas$isco88, "\n")
cat("'0100' presente?", "0100" %in% isco88_medidas$isco88, "\n")
cat("'0300' presente?", "0300" %in% isco88_medidas$isco88, "\n")
cat("\n-- teste do aviso de ambiguidade, um a um --\n")
for (v in c("110","11","1","100","30","300","10")) {
  w <- NULL
  r <- withCallingHandlers(suppressWarnings0 <- .Internal(identity(NULL)), warning=function(x) NULL)
  r <- tryCatch(withCallingHandlers(ocupacoesBR:::.norm_isco(v),
        warning=function(x){ w <<- conditionMessage(x); invokeRestart("muffleWarning")}),
        error=function(e) paste("ERRO:", conditionMessage(e)))
  cat(sprintf("  %-4s -> %-6s  aviso=%s\n", v, r, if(is.null(w)) "NENHUM" else "SIM"))
}
cat("\n-- e o proprio grupo 0 chega a ter medidas? --\n")
print(isco88_medidas[grep("^0", isco88_medidas$isco88), ])
