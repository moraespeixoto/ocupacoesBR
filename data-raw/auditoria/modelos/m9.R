suppressMessages({library(data.table); library(ocupacoesBR)})
d <- readRDS("DADOS/raw/microdados_classe_v2.rds"); d[, cod := as.character(cod_ocup)]
cw <- as.data.table(suppressWarnings(crosswalk_tse()))
ti <- as.data.table(ocupacoesBR::tse_isco)
d[cw, on=.(cod=cod_tse), `:=`(isco88=i.isco88, isei88=i.isei88, es=i.estrato, cl=i.classe)]
d[ti, on=.(cod=cod_tse), nivel := i.nivel]

cat("=== massa de candidaturas por NIVEL da traducao ===\n")
print(d[, .(n=.N, pct=round(100*.N/nrow(d),1)), by=nivel][order(nivel)])

cat("\n=== 295 (seguranca sem ISCO) ===\n")
cat("n:", d[cod=="295",.N], sprintf("(%.2f%% do total; %.1f%% da classe media)\n",
  100*d[cod=="295",.N]/nrow(d), 100*d[cod=="295",.N]/d[es=="Classe média",.N]))

cat("\n=== SOBREPOSICAO DE ISEI ENTRE ESTRATOS (ponderada) ===\n")
v <- d[!is.na(isei88) & es %in% c("Classe alta","Classe média","Classes populares")]
print(v[, .(n=.N, min=min(isei88), p10=quantile(isei88,.1), mediana=median(isei88),
            p90=quantile(isei88,.9), max=max(isei88), media=round(mean(isei88),1)), by=es])
cat("\ncandidaturas de CLASSE ALTA com ISEI <= mediana da CLASSE MEDIA (50):",
    v[es=="Classe alta" & isei88<=50, .N], sprintf("(%.1f%% da classe alta)\n",
    100*v[es=="Classe alta" & isei88<=50,.N]/v[es=="Classe alta",.N]))
cat("candidaturas de CLASSE MEDIA com ISEI >= mediana da CLASSE ALTA (68):",
    v[es=="Classe média" & isei88>=68,.N], "\n")
cat("candidaturas POPULARES com ISEI >= min da CLASSE ALTA (43):",
    v[es=="Classes populares" & isei88>=43,.N], sprintf("(%.1f%% das populares)\n",
    100*v[es=="Classes populares" & isei88>=43,.N]/v[es=="Classes populares",.N]))
cat("\nAUC de separacao alta vs popular pelo ISEI (concordancia de pares):\n")
set.seed(1); a <- v[es=="Classe alta", sample(isei88, 2e5, TRUE)]
b <- v[es=="Classes populares", sample(isei88, 2e5, TRUE)]
cat(sprintf("  P(ISEI_alta > ISEI_pop) = %.3f ; empates = %.3f\n", mean(a>b), mean(a==b)))
a2 <- v[es=="Classe média", sample(isei88, 2e5, TRUE)]
cat(sprintf("  P(ISEI_alta > ISEI_media) = %.3f ; empates = %.3f\n", mean(a>a2), mean(a==a2)))

cat("\n=== ISEI por CLASSE, ponderado por candidatura ===\n")
print(d[!is.na(isei88), .(n=.N, min=min(isei88), mediana=median(isei88),
        media=round(mean(isei88),1), max=max(isei88)), by=.(cl,es)][order(-media)])
