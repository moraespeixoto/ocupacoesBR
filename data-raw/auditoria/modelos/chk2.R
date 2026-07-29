suppressMessages(library(ocupacoesBR))
d <- tse_isco
cat("== a coluna `proprietario` existe e marca quantos?\n")
print(table(d$proprietario, useNA="ifany"))
cat("\n== EGP desses proprietarios, SEM usar conta_propria (o que crosswalk_tse faz):\n")
p <- d$cod_tse[d$proprietario %in% TRUE]
print(table(tse_para_egp(p, avisar=FALSE), useNA="ifany"))
cat("\n== EGP dos MESMOS, alimentando conta_propria = proprietario:\n")
print(table(tse_para_egp(p, conta_propria = rep(TRUE, length(p)), avisar=FALSE), useNA="ifany"))
