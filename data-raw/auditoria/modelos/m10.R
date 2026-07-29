suppressMessages(library(ocupacoesBR))
M <- ocupacoesBR::isco88_medidas
cat("ISCO-88 na tabela de medidas sem ISEI:", sum(is.na(M$isei88)), ":",
    paste(M$isco88[is.na(M$isei88)], collapse=", "), "\n")
C <- ocupacoesBR::cbo2002_isco88
cat("CBO-2002 mapeadas:", nrow(C), " -> ISCO distintos:", length(unique(C$isco88)), "\n")
i <- match(C$isco88, M$isco88)
cat("ocupacoes CBO cujo ISCO nao tem ISEI (tse/cbo_para_isei devolve NA SEM aviso):",
    sum(is.na(M$isei88[i])), ":", paste(unique(C$cbo2002[is.na(M$isei88[i])]), collapse=", "), "\n")
cat("\nfusao CBO-2002 -> ISCO-88: razao", round(nrow(C)/length(unique(C$isco88)),2), "\n")
tb <- table(C$isco88); cat("max ocupacoes CBO por ISCO:", max(tb), "(", names(tb)[which.max(tb)], ")\n")
F <- ocupacoesBR::cbo2002_familia_isco88
cat("\nfamilias CBO:", nrow(F), " homogeneas:", sum(F$n_isco_distintos==1),
    sprintf("(%.1f%%)", 100*mean(F$n_isco_distintos==1)), " com empate:", sum(F$empate), "\n")
cat("concordancia < 0.5 em", sum(F$concordancia<0.5), "familias\n")
cat("\ncbo2002_para_isco de uma familia dividida NAO avisa? ")
w <- tryCatch({withCallingHandlers(cbo2002_para_isco(F$familia[F$empate][1]),
  warning=function(x) invokeRestart("muffleWarning")); "sem aviso"}, error=function(e) "erro")
cat(w, "-> devolve", cbo2002_para_isco(F$familia[F$empate][1]), "com concordancia",
    F$concordancia[F$empate][1], "\n")
cat("\n=== ambiguidade exposta: quais funcoes a devolvem ===\n")
print(head(suppressWarnings(tse_para_isco08(c(111,234,601), com_ambiguidade=TRUE))))
