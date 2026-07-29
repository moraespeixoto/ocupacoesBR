library(ocupacoesBR)
set.seed(1); n <- 8e6
cod <- sample(tse_isco$cod_tse, n, replace=TRUE)
isco <- tse_para_isco(cod)
gc(reset=TRUE)
t_atual <- system.time(a <- isco88_para_egp(isco, avisar=FALSE))
g1 <- gc()
cat("ATUAL   tempo:", t_atual[["elapsed"]], "s | Vcells max Mb:", g1[2,6], "\n")

# proposta: dedup na fronteira quando nao ha covariaveis por caso
egp_dedup <- function(isco, ...) {
  u <- unique(isco); isco88_para_egp(u, ...)[match(isco, u)]
}
gc(reset=TRUE)
t_novo <- system.time(b <- egp_dedup(isco, avisar=FALSE))
g2 <- gc()
cat("DEDUP   tempo:", t_novo[["elapsed"]], "s | Vcells max Mb:", g2[2,6], "\n")
cat("IDENTICOS?", identical(a,b), "\n")

# proposta de guarda de tipo
.checa_vetor <- function(x, arg) {
  if (is.data.frame(x) || is.list(x))
    stop(sprintf("`%s` deve ser um vetor atomico; recebeu um %s de %d coluna(s). Passe a COLUNA (ex.: dados$%s).", arg, class(x)[1], length(x), arg), call.=FALSE)
  invisible(x)
}
df <- data.frame(cod=c(111,169,257), uf=c("a","b","c"))
print(tryCatch(.checa_vetor(df, "cod"), error=function(e) conditionMessage(e)))
