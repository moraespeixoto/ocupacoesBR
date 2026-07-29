library(ocupacoesBR)
cat("===== P. aviso de ambiguidade ISCO =====\n")
print(tryCatch(withCallingHandlers(isco88_para_egp("110", avisar=FALSE),
   warning=function(w){cat("AVISO:",conditionMessage(w),"\n"); invokeRestart("muffleWarning")}),
   error=function(e)paste("ERRO:",conditionMessage(e))))
cat("classes das condicoes emitidas:\n")
withCallingHandlers(suppressMessages(try(tse_para_isco(99999), silent=TRUE)),
  warning=function(w){cat("  ", paste(class(w),collapse="/"), "\n"); invokeRestart("muffleWarning")})
withCallingHandlers(try(isco88_para_egp("2211"), silent=TRUE),
  warning=function(w){cat("  ", paste(class(w),collapse="/"), "\n"); invokeRestart("muffleWarning")})

cat("\n===== Q. nomes/atributos preservados? =====\n")
v <- c(a=111, b=169); print(tse_para_isco(v)); print(names(tse_para_isei(v)))

cat("\n===== R. cbo2002_concordancia com familia inexistente: silencio? =====\n")
print(cbo2002_concordancia("9999"))
cat("nenhum aviso acima -> familia desconhecida vira linha NA calada\n")
cat("-- e com 6 digitos inexistentes --\n")
print(suppressWarnings(cbo2002_concordancia("999999")))

cat("\n===== S. checa_cobertura com factor e com data.frame =====\n")
print(tryCatch(checa_cobertura(factor(c("111","169")), silencioso=TRUE), error=function(e)paste("ERRO:",conditionMessage(e))))
df <- data.frame(cod=c(111,169))
print(tryCatch(checa_cobertura(df, silencioso=TRUE), error=function(e)paste("ERRO:",conditionMessage(e))))

cat("\n===== T. options(warn=2): aviso rotineiro vira erro =====\n")
op <- options(warn=2)
print(tryCatch(tse_para_isco(c(111, 99999)), error=function(e)paste("ERRO:",conditionMessage(e))))
options(op)

cat("\n===== U. isco88_para_isco08(com_ambiguidade) com duplicatas e NA =====\n")
print(suppressWarnings(isco88_para_isco08(c("2211","2211",NA), com_ambiguidade=TRUE)))

cat("\n===== V. crosswalk_cbo2002 com codigo repetido/desconhecido =====\n")
print(suppressWarnings(crosswalk_cbo2002(c("111105","111105","999999"))))
