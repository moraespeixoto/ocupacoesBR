suppressMessages(library(ocupacoesBR))
teste <- function(v, rotulo) {
  r <- tryCatch(paste(cbo2002_para_isco(v), collapse=", "),
                error = function(e) paste("*** ABORTA:", conditionMessage(e)),
                warning = function(w) paste("aviso:", conditionMessage(w)))
  cat(sprintf("%-38s %s\n", rotulo, r))
}
cat("=== CRITICO 1: a forma DECLARADA do 'ignorado' na RAIS ===\n")
teste("-1", 'RAIS "-1"')
teste("0000-1", 'RAIS "0000-1"')
teste("000-1", 'RAIS "000-1"')
teste("{n class}", 'RAIS "{n class}"')
cat("\n=== CRITICO 2: CBO gravada como NUMERO (perde zero a esquerda) ===\n")
teste("010105", 'texto  "010105" (Oficial General Aer.)')
teste("10105", 'numero  10105  (mesmo codigo)')
cat("\n=== e o pior caso: UM codigo sujo no meio de um vetor bom ===\n")
teste(c("225120","223505","-1","251205"), 'vetor de 4, um sujo')
