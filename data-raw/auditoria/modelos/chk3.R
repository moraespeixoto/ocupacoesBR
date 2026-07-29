suppressMessages(library(ocupacoesBR))
d <- tse_isco
p <- d[d$proprietario %in% TRUE, ]
p$egp_atual <- tse_para_egp(p$cod_tse, avisar=FALSE)
p$egp_correto <- tse_para_egp(p$cod_tse, conta_propria=rep(TRUE,nrow(p)), avisar=FALSE)
print(p[, c("cod_tse","isco88","classe","componente_alta","egp_atual","egp_correto")], right=FALSE)
