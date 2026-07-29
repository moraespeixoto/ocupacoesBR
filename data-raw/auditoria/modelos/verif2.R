suppressMessages(library(ocupacoesBR))
cw <- crosswalk_tse()
cat("=== A2: agricultor (601) vs os produtores patcheados (234,602,901) e comerciante (169)\n")
print(cw[cw$cod_tse %in% c("601","234","602","901","169","606"),
         c("cod_tse","isco88","isei88","classe","estrato")], right=FALSE)

cat("\n=== A4: fisioterapeuta (114) e nutricionista (222): a OIT ja os promoveu?\n")
print(cw[cw$cod_tse %in% c("114","222","265"),
         c("cod_tse","isco88","isco08","isei88","isei08","classe","estrato")], right=FALSE)
cat("\n(ISCO-08 2264=fisioterapeuta, 2265=nutricionista sao 'professionals' -> grande grupo 2)\n")
