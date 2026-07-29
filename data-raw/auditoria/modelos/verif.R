suppressMessages(library(ocupacoesBR))
cat("=== BLOQUEADOR 1: n_supervisionados como factor ===\n")
a <- isco88_para_egp(rep("5220",3), conta_propria=rep(TRUE,3),
                     n_supervisionados=factor(c("0","5","20")), avisar=FALSE)
b <- isco88_para_egp(rep("5220",3), conta_propria=rep(TRUE,3),
                     n_supervisionados=c(0,5,20), avisar=FALSE)
print(data.frame(factor=a, numerico=b))
cat("\n=== BLOQUEADOR 2: data.frame colapsa comprimento ===\n")
df <- data.frame(cod=c(111,169,257), uf=c("RJ","SP","MG"))
cat("nrow(df) =", nrow(df), "\n")
cat("length(tse_para_isco(df)) =", length(suppressWarnings(tse_para_isco(df))), "\n")
cat("length(tse_para_classe(df['cod'])) =", length(suppressWarnings(tse_para_classe(df["cod"]))), "\n")
cat("valor devolvido por tse_para_classe(df['cod']): ")
print(suppressWarnings(tse_para_classe(df["cod"])))
cat("\n=== GRAVE 3: aviso de ambiguidade engolido no EGP ===\n")
cat("isco88_para_isco08('110'):\n")
withCallingHandlers(invisible(isco88_para_isco08("110")),
  warning=function(w){cat("  AVISOU:", conditionMessage(w), "\n"); invokeRestart("muffleWarning")})
cat("isco88_para_egp('110'):\n")
r <- withCallingHandlers(isco88_para_egp("110", avisar=FALSE),
  warning=function(w){cat("  AVISOU:", conditionMessage(w),"\n"); invokeRestart("muffleWarning")})
cat("  devolveu:", r, "(sem aviso acima = confirmado)\n")
