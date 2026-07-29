library(ocupacoesBR)
for (v in c("110","11","1","100","10","0110")) {
  w <- NULL
  r <- tryCatch(withCallingHandlers(ocupacoesBR:::.norm_isco(v),
        warning=function(x){ w <<- conditionMessage(x); invokeRestart("muffleWarning")}),
        error=function(e) paste("ERRO:", conditionMessage(e)))
  cat(sprintf("  %-5s -> %-6s  aviso=%s\n", v, r, if(is.null(w)) "NENHUM" else substr(w,1,60)))
}
cat("\n-- via API publica --\n")
for (v in c("110","11","1")) {
  w <- NULL
  r <- tryCatch(withCallingHandlers(isco88_para_isco08(v),
        warning=function(x){ w <<- conditionMessage(x); invokeRestart("muffleWarning")}),
        error=function(e) paste("ERRO:", conditionMessage(e)))
  cat(sprintf("  isco88_para_isco08(%-5s) -> %-6s aviso=%s\n", v, r, if(is.null(w)) "NENHUM" else substr(w,1,50)))
}
cat("\n-- vetorizado: 110 junto de outros --\n")
w<-NULL
r <- withCallingHandlers(ocupacoesBR:::.norm_isco(c("110","2211")), warning=function(x){w<<-conditionMessage(x);invokeRestart("muffleWarning")})
cat(paste(r,collapse=" "), "| aviso:", if(is.null(w))"NENHUM" else substr(w,1,70), "\n")
print(isco88_medidas[isco88_medidas$isco88 %in% c("0100","0110","1100","1000"), ])
