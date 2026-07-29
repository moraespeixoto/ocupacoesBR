suppressMessages({library(data.table); library(ocupacoesBR)})
d <- readRDS("DADOS/raw/microdados_classe_v2.rds")
d[, cod := as.character(cod_ocup)]
cw <- suppressWarnings(crosswalk_tse())
setDT(cw); setkey(cw, cod_tse)
d[cw, on=.(cod=cod_tse), `:=`(isco88=i.isco88, isco08=i.isco08, isei88=i.isei88,
   isei08=i.isei08, cl=i.classe, es=i.estrato, egp=i.egp)]
N <- nrow(d)
cat("N candidaturas:", N, "\n")

cat("\n=== FUSAO PONDERADA POR CANDIDATURA ===\n")
tb <- d[!is.na(isco88), .N, by=isco88][order(-N)]
cat("massa em ISCO 2400 (24 = 'outros profissionais'):",
    sprintf("%.1f%% das candidaturas com ISCO", 100*tb[isco88=="2400",N]/sum(tb$N)), "\n")
print(head(tb,12))
ncods <- cw[!is.na(isco88), .N, by=isco88]
tb <- merge(tb, ncods, by="isco88", suffixes=c("_cand","_cods"))
cat("\n% de candidaturas com ISCO cujo destino recebe >=2 codigos TSE:",
    sprintf("%.1f%%\n", 100*tb[N_cods>=2, sum(N_cand)]/sum(tb$N_cand)))
cat("entropia perdida: codigos TSE distintos =", cw[!is.na(isco88),.N],
    "-> ISCO distintos =", nrow(ncods), "\n")

cat("\n=== PONTE 88->08 PONDERADA ===\n")
P <- as.data.table(ocupacoesBR::isco88_isco08)
d[P, on=.(isco88), nalt := i.n_alternativas]
cat("candidaturas cuja ponte tem >1 alternativa OIT:",
    sprintf("%.1f%% (%d de %d com ISCO)\n", 100*d[!is.na(isco88), mean(nalt>1)],
            d[!is.na(isco88) & nalt>1,.N], d[!is.na(isco88),.N]))
print(d[!is.na(isco88), .N, by=nalt][order(nalt)])
cat("\nISEI-88 medio:", round(d[,mean(isei88,na.rm=TRUE)],2),
    "| ISEI-08 medio:", round(d[,mean(isei08,na.rm=TRUE)],2), "\n")
cat("cor(isei88, isei08) nas candidaturas:", round(d[!is.na(isei88), cor(isei88,isei08)],3), "\n")

cat("\n=== COBERTURA ===\n")
cat("sem ISEI:", sprintf("%.1f%%\n", 100*d[,mean(is.na(isei88))]))
print(d[, .(n=.N, pct=round(100*.N/N,1)), by=es][order(-n)])

cat("\n=== VALIDACAO CONVERGENTE (o que o pacote NAO carrega) ===\n")
v <- d[!is.na(isei88)]
cat("n com ISEI:", nrow(v), "\n")
cat("cor(ISEI, superior)      =", round(v[!is.na(superior), cor(isei88, as.numeric(superior))],3), "\n")
w <- v[!is.na(patrim) & patrim>0]
cat("n com patrimonio>0:", nrow(w), "\n")
cat("cor(ISEI, log patrim)    =", round(w[, cor(isei88, log(patrim))],3), "\n")
cat("cor(ISEI, log patrim) spearman =", round(w[, cor(isei88, log(patrim), method='spearman')],3), "\n")
# no NIVEL DA OCUPACAO (a unidade em que a medida e definida)
oc <- v[!is.na(patrim) & patrim>0, .(n=.N, isei=first(isei88),
        med_patrim=median(patrim), pct_sup=100*mean(superior,na.rm=TRUE)), by=cod][n>=200]
cat("\nno nivel do CODIGO DE OCUPACAO (n>=200):", nrow(oc), "codigos\n")
cat("cor(ISEI, log mediana patrim) =", round(oc[, cor(isei, log(med_patrim))],3),
    "| spearman =", round(oc[, cor(isei, log(med_patrim), method='spearman')],3), "\n")
cat("cor(ISEI, % superior)         =", round(oc[, cor(isei, pct_sup)],3),
    "| spearman =", round(oc[, cor(isei, pct_sup, method='spearman')],3), "\n")
saveRDS(oc, "/tmp/claude-1000/-home-nerd-vices-do-brasil/2a8c8af0-f353-4674-aa64-5fef5ea0c198/scratchpad/oc.rds")
