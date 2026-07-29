suppressMessages(library(ocupacoesBR))
d <- suppressWarnings(crosswalk_tse())
cat("== n codigos TSE:", nrow(d), "\n")
cat("== ISCO88 distintos usados:", length(unique(na.omit(d$isco88))), "\n")
cat("== codigos TSE com isco88 NA:", sum(is.na(d$isco88)), "\n\n")

cat("=== FUSAO: quantos cod_tse por ISCO-88 ===\n")
tb <- table(d$isco88)
print(table(as.integer(tb)))
cat("razao de fusao (cod_tse com isco / isco distintos):",
    round(sum(!is.na(d$isco88))/length(unique(na.omit(d$isco88))),2), "\n")
cat("\ntop 15 ISCO que absorvem mais codigos do TSE:\n")
print(head(sort(tb, decreasing=TRUE), 15))
cat("\n% de codigos TSE que caem num ISCO compartilhado com >=2 codigos:\n")
sh <- d$isco88[!is.na(d$isco88)]
cat(round(100*mean(tb[sh] >= 2),1), "%\n")

cat("\n=== NIVEL da traducao (digitos do ISCO de origem) ===\n")
print(table(ocupacoesBR::tse_isco$nivel, useNA="always"))

cat("\n=== ISEI por classe ===\n")
s <- split(d$isei88, d$classe)
out <- do.call(rbind, lapply(names(s), function(k){
  v <- s[[k]][!is.na(s[[k]])]
  if(!length(v)) return(data.frame(classe=k,n=0,n_isei=0,min=NA,q25=NA,mediana=NA,q75=NA,max=NA,dp=NA))
  data.frame(classe=k, n=length(s[[k]]), n_isei=length(v), min=min(v),
             q25=quantile(v,.25), mediana=median(v), q75=quantile(v,.75),
             max=max(v), dp=round(sd(v),1))}))
print(out, row.names=FALSE)

cat("\n=== ISEI por estrato ===\n")
s2 <- split(d$isei88, d$estrato)
print(t(sapply(s2, function(v) {v<-v[!is.na(v)]; if(!length(v)) return(c(n=0,min=NA,med=NA,max=NA)); c(n=length(v),min=min(v),med=median(v),max=max(v))})))
