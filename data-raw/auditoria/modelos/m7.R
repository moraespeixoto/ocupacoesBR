suppressMessages({library(data.table); library(ocupacoesBR)})
d <- readRDS("DADOS/raw/microdados_classe_v2.rds")
d[, cod := as.character(cod_ocup)]
cw <- as.data.table(suppressWarnings(crosswalk_tse()))
d[cw, on=.(cod=cod_tse), `:=`(isei88=i.isei88, cl=i.classe)]

cat("=== 5. CARDINALIDADE DO ISEI: linear vs. categorico ===\n")
w <- d[!is.na(isei88) & !is.na(patrim) & patrim>0]
w[, y := log(patrim)]
m1 <- lm(y ~ isei88, w); m2 <- lm(y ~ poly(isei88,3), w); m3 <- lm(y ~ factor(isei88), w)
cat(sprintf("log(patrim) ~ ISEI linear    : R2=%.4f (1 gl)\n", summary(m1)$r.squared))
cat(sprintf("log(patrim) ~ ISEI cubico    : R2=%.4f (3 gl)\n", summary(m2)$r.squared))
cat(sprintf("log(patrim) ~ ISEI como fator: R2=%.4f (%d gl)\n", summary(m3)$r.squared, length(coef(m3))-1))
cat(sprintf("=> a linearidade descarta %.0f%% do sinal que o ISEI carrega\n",
    100*(1-summary(m1)$r.squared/summary(m3)$r.squared)))
cat("\nteste F de nao-linearidade (linear vs fator):\n"); print(anova(m1,m3)[2,])
cat("\nmedia de log(patrim) por decil de ISEI (checa monotonicidade da escala):\n")
w[, dec := cut(isei88, breaks=quantile(isei88, 0:10/10), include.lowest=TRUE)]
print(w[, .(n=.N, isei_med=round(mean(isei88),1), patrim_mediano=round(median(patrim))), by=dec][order(isei_med)])

# escolaridade: ISEI e ordinal?
s <- d[!is.na(isei88) & !is.na(superior), .(n=.N, pct_sup=100*mean(superior)), by=isei88][order(isei88)][n>=1000]
cat("\n% superior por escore ISEI (a escala e monotona na credencial?):\n")
print(s)
cat("inversoes (ISEI sobe, %superior cai) entre escores consecutivos:",
    sum(diff(s$pct_sup)<0), "de", nrow(s)-1, "\n")

cat("\n\n=== 4. IMPUTACAO POR ESCOLARIDADE ===\n")
pub <- d[cl=="Vínculo público não especificado"]
cat("candidaturas na categoria:", nrow(pub), sprintf("(%.1f%%)\n", 100*nrow(pub)/nrow(d)))
cat("superior NA nessa categoria:", pub[,sum(is.na(superior))],
    sprintf("(%.2f%%) -> tse_para_classe manda TODOS para 'medio ou menos'\n",
            100*pub[,mean(is.na(superior))]))
cat("distribuicao de superior:\n"); print(pub[, .N, by=superior])
cat("\nsuperior NA no dado inteiro:", d[,sum(is.na(superior))], sprintf("(%.2f%%)\n", 100*d[,mean(is.na(superior))]))
cat("\ncolinearidade construida: dentro da categoria dividida, classe = f(superior) exatamente.\n")
pub2 <- copy(pub); pub2[, cl2 := suppressWarnings(tse_para_classe(cod, superior))]
print(pub2[, .N, by=.(superior, cl2)])
cat("\nR2 de superior ~ classe, com e sem o corte (amostra: vinculo publico + resto):\n")
dd <- d[!is.na(superior)]
dd[, cl_sem := cl]
dd[, cl_com := suppressWarnings(tse_para_classe(cod, superior))]
r_sem <- summary(lm(as.numeric(superior) ~ factor(cl_sem), dd))$r.squared
r_com <- summary(lm(as.numeric(superior) ~ factor(cl_com), dd))$r.squared
cat(sprintf("  sem corte: R2=%.4f (%d categorias) | com corte: R2=%.4f (%d categorias)\n",
    r_sem, dd[,uniqueN(cl_sem)], r_com, dd[,uniqueN(cl_com)]))
cat(sprintf("  ganho de R2 puramente tautologico: +%.4f\n", r_com-r_sem))
