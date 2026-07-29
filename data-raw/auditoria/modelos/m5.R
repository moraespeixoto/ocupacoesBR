suppressMessages(library(ocupacoesBR))
env <- new.env()
old <- setwd("/home/nerd/ocupacoesBR/data-raw/fontes")
suppressMessages(sys.source("R/classe_ocupacao.R", envir=env))
setwd(old)
M <- ocupacoesBR::isco88_medidas
tab <- env$.ISEI_POR_ISCO_V2
k <- names(tab)
k4 <- formatC(as.integer(k)*10^(4-nchar(k)), width=4, flag="0", format="d")
pk <- M$isei88[match(k4, M$isco88)]
cmp <- data.frame(isco_fonte=k, isco4=k4, isei_manual=as.numeric(tab), isei_ismf=pk,
                  stringsAsFactors=FALSE)
cmp$dif <- cmp$isei_ismf - cmp$isei_manual
cat("=== ISEI digitado a mao em isei_ocupacao.R vs ISEI parseado do ISMF ===\n")
cat("codigos comparados:", nrow(cmp), " divergentes:", sum(cmp$dif!=0 | is.na(cmp$dif)), "\n")
print(cmp[which(cmp$dif!=0 | is.na(cmp$dif)),], row.names=FALSE)

cat("\n=== o pacote usa qual? (tse_para_isei vs isei_v2 da fonte) ===\n")
cods <- ocupacoesBR::tse_isco$cod_tse
a <- suppressWarnings(tse_para_isei(cods)); b <- env$isei_v2(cods)
cat("divergem em", sum(!( (is.na(a)&is.na(b)) | (!is.na(a)&!is.na(b)&a==b) )), "de", length(cods), "codigos\n")
w <- which(!((is.na(a)&is.na(b)) | (!is.na(a)&!is.na(b)&a==b)))
print(head(data.frame(cod=cods[w], pacote=a[w], fonte=b[w], isco=suppressWarnings(tse_para_isco(cods[w]))),20), row.names=FALSE)

cat("\n=== codigos TSE com ISCO mas SEM ISEI (silencioso: .busca sem o_que) ===\n")
d <- suppressWarnings(crosswalk_tse())
s <- d[!is.na(d$isco88) & is.na(d$isei88), c("cod_tse","isco88","classe","estrato")]
print(s, row.names=FALSE)
cat("\n=== EGP a partir do TSE ===\n")
print(table(d$egp, useNA="always"))
cat("\nproprietarios marcados no dicionario:", sum(d$proprietario), "\n")
cat("EGP com conta_propria = proprietario:\n")
e2 <- suppressWarnings(isco88_para_egp(d$isco88, conta_propria=d$proprietario, n_supervisionados=rep(0,nrow(d)), avisar=FALSE))
print(table(e2, useNA="always"))
