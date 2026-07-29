library(ocupacoesBR)
tab <- as.data.frame(DIGCLASS::all_schemas$isco88_to_egp11)
chave <- sprintf("%04d", as.integer(tab[[1]]))
casos <- list(
  list(col="EGP(0,0)",    s=FALSE, sv=0),
  list(col="EGB(0,1)",    s=FALSE, sv=1),
  list(col="EGP(0,2-9)",  s=FALSE, sv=5),
  list(col="EGP(0,10+)",  s=FALSE, sv=11),
  list(col="EGP(0,10+)",  s=FALSE, sv=10),
  list(col="EGP(1,0)",    s=TRUE,  sv=0),
  list(col="EGB(1,1)",    s=TRUE,  sv=1),
  list(col="EGP(1,2-9)",  s=TRUE,  sv=5),
  list(col="EGP(1,10+)",  s=TRUE,  sv=11),
  list(col="EGP(1,10+)",  s=TRUE,  sv=10))
for (cs in casos) {
  esperado <- as.integer(tab[[cs$col]])
  obtido <- isco88_para_egp(chave, conta_propria=rep(cs$s, length(chave)),
                            n_supervisionados=rep(cs$sv, length(chave)),
                            rotulo=FALSE, avisar=FALSE)
  comum <- !is.na(esperado) & !is.na(obtido)
  dif <- comum & esperado != obtido
  cat(sprintf("%-12s sv=%-3d  n=%d  divergencias=%d\n", cs$col, cs$sv, sum(comum), sum(dif)))
  if (any(dif)) {
    d <- data.frame(isco=chave[dif], DIGCLASS=esperado[dif], ocupacoesBR=obtido[dif])
    print(utils::head(d, 15))
    cat("  ... total", sum(dif), "\n")
    print(table(paste(d$DIGCLASS, "->", d$ocupacoesBR)))
  }
}
