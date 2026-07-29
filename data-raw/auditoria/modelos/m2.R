suppressMessages(library(ocupacoesBR))
p <- ocupacoesBR::isco88_isco08
cat("=== PONTE 88->08 ===\n")
cat("pares:", nrow(p), "\n")
cat("n_alternativas: "); print(table(p$n_alternativas))
cat("% com >1 alternativa:", round(100*mean(p$n_alternativas>1),1), "%\n")
cat("ISCO-08 distintos de destino:", length(unique(p$isco08)), "\n")
cat("\n-- convergencia (varios 88 -> mesmo 08) --\n")
tb <- table(p$isco08); print(table(as.integer(tb)))
cat("ISCO-08 que recebem >1 ISCO-88:", sum(tb>1), "; codigos 88 envolvidos:", sum(tb[p$isco08]>1), "\n")

cat("\n=== O QUE ISSO CUSTA NO DADO DO TSE ===\n")
d <- suppressWarnings(crosswalk_tse())
i <- match(d$isco88, p$isco88)
d$nalt <- p$n_alternativas[i]
cat("codigos TSE com ponte ambigua (>1 alternativa OIT):", sum(d$nalt>1, na.rm=TRUE),
    "de", sum(!is.na(d$isco88)), sprintf("(%.1f%%)\n", 100*mean(d$nalt[!is.na(d$isco88)]>1)))
print(table(d$nalt, useNA="always"))

cat("\n=== ISEI-88 vs ISEI-08 (rota longa) ===\n")
ok <- !is.na(d$isei88) & !is.na(d$isei08)
cat("n com ambos:", sum(ok), " | sem isei08:", sum(!is.na(d$isco88) & is.na(d$isei08)), "\n")
cat("cor(pearson):", round(cor(d$isei88[ok], d$isei08[ok]),3),
    " cor(spearman):", round(cor(d$isei88[ok], d$isei08[ok], method="spearman"),3), "\n")
dif <- d$isei08[ok]-d$isei88[ok]
cat("dif isei08-isei88: media", round(mean(dif),2), "dp", round(sd(dif),2),
    "min", min(dif), "max", max(dif), "\n")
cat("|dif|>10 em", sum(abs(dif)>10), "codigos;", "|dif|>20 em", sum(abs(dif)>20), "\n")
u <- unique(data.frame(isco88=d$isco88[ok], isco08=d$isco08[ok], isei88=d$isei88[ok], isei08=d$isei08[ok], dif=dif))
u <- u[order(-abs(u$dif)),]
print(head(u,10), row.names=FALSE)
cat("\n-- dif por n_alternativas --\n")
print(tapply(abs(dif), d$nalt[ok], function(v) c(n=length(v), mean_abs=round(mean(v),2))))

cat("\n=== inversoes de ordenacao induzidas pela ponte ===\n")
uu <- unique(data.frame(a=d$isei88[ok], b=d$isei08[ok]))
n <- nrow(uu); inv <- 0; tot <- 0
for(i in 1:(n-1)) for(j in (i+1):n){
  if(uu$a[i]!=uu$a[j]) {tot<-tot+1; if(sign(uu$a[i]-uu$a[j])!=sign(uu$b[i]-uu$b[j])) inv<-inv+1}}
cat("pares de escores distintos:", tot, "; invertidos pela mudanca de ancora:", inv,
    sprintf("(%.1f%%)\n", 100*inv/tot))
