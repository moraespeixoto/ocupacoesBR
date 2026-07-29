suppressMessages(library(ocupacoesBR))
C <- ocupacoesBR::cbo2002_isco88; F <- ocupacoesBR::cbo2002_familia_isco88
M <- ocupacoesBR::isco88_medidas
emp <- F[F$empate, ]
cat("=== 19 familias com EMPATE: quem vence o sorteio? ===\n")
res <- do.call(rbind, lapply(emp$familia, function(f){
  v <- C$isco88[C$familia==f]; tt <- sort(table(v), decreasing=TRUE)
  cand <- names(tt)[tt==max(tt)]
  isei <- M$isei88[match(cand, M$isco88)]
  data.frame(familia=f, vencedor=names(tt)[1], candidatos=paste(cand,collapse="/"),
             isei_venc=M$isei88[match(names(tt)[1],M$isco88)],
             isei_min=min(isei,na.rm=TRUE), isei_max=max(isei,na.rm=TRUE))}))
res$eh_menor_codigo <- res$vencedor == sapply(strsplit(res$candidatos,"/"), function(x) x[which.min(as.integer(x))])
res$eh_maior_isei <- res$isei_venc == res$isei_max
print(res, row.names=FALSE)
cat("\nvence o MENOR codigo ISCO em", sum(res$eh_menor_codigo), "de", nrow(res), "empates\n")
cat("vence o MAIOR ISEI em", sum(res$eh_maior_isei, na.rm=TRUE), "de", nrow(res), "\n")
cat("viés medio do desempate (isei_venc - media dos candidatos):",
    round(mean(res$isei_venc - (res$isei_min+res$isei_max)/2, na.rm=TRUE),2), "pontos ISEI\n")
cat("amplitude media descartada (isei_max-isei_min):", round(mean(res$isei_max-res$isei_min, na.rm=TRUE),1), "\n")
cat("\n=== cobertura da perna CBO ===\n")
cat("familias cobertas:", nrow(F), "de 616 declaradas na fonte =",
    sprintf("%.1f%%\n", 100*nrow(F)/616))
