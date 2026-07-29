suppressMessages(library(ocupacoesBR))
G <- "/home/nerd/ocupacoesBR/data-raw/fontes/ganzeboom"
le <- function(f, nm){
  l <- readLines(file.path(G,f), warn=FALSE, encoding="UTF-8")
  m <- regmatches(l, regexec("^\\s*recode\\s+@\\w+\\s*\\(\\s*([0-9]+)\\s*=\\s*([0-9.]+)\\s*\\)", l))
  ok <- lengths(m)==3
  data.frame(cod=sprintf("%04d", as.integer(sapply(m[ok],`[`,2))), val=sapply(m[ok],`[`,3), stringsAsFactors=FALSE)
}
cat("=== duplicatas descartadas por !duplicated() nos parses ===\n")
for(f in c("iskoisei.sps","iskotrei.sps","iskoroot.sps","isqoisei08.sps","isqotrei08.sps")){
  d <- le(f); dup <- d$cod[duplicated(d$cod)]
  cat(sprintf("%-16s linhas=%d  codigos dup=%d  %s\n", f, nrow(d), length(dup),
      if(length(dup)) paste(head(unique(dup),8),collapse=",") else ""))
  if(length(dup)){
    for(k in unique(dup)) cat("    ", k, "-> valores:", paste(d$val[d$cod==k],collapse=" | "), "\n")
  }
}
# ponte
l <- readLines(file.path(G,"isco8808.sps"), warn=FALSE, encoding="UTF-8")
m <- regmatches(l, regexec("^\\s*recode\\s+@isko\\s*\\(\\s*([0-9]+)\\s*=\\s*([0-9]+)(?:\\.([0-9]+))?\\s*\\)", l))
ok <- lengths(m)>=3
pp <- data.frame(isco88=sprintf("%04d",as.integer(sapply(m[ok],`[`,2))),
                 isco08=sprintf("%04d",as.integer(sapply(m[ok],`[`,3))), stringsAsFactors=FALSE)
dup <- pp$isco88[duplicated(pp$isco88)]
cat("\nisco8808.sps: linhas=",nrow(pp)," isco88 duplicados=",length(unique(dup)),"\n")
if(length(dup)) for(k in unique(dup)) cat("   ",k,"->", paste(pp$isco08[pp$isco88==k],collapse=" | "),"\n")

cat("\n=== ida e volta 88 -> 08 -> 88 (isco0888.sps NAO usado pelo pacote) ===\n")
l2 <- readLines(file.path(G,"isco0888.sps"), warn=FALSE, encoding="UTF-8")
m2 <- regmatches(l2, regexec("^\\s*recode\\s+@\\w+\\s*\\(\\s*([0-9]+)\\s*=\\s*([0-9]+)(?:\\.([0-9]+))?\\s*\\)", l2))
ok2 <- lengths(m2)>=3
volta <- data.frame(isco08=sprintf("%04d",as.integer(sapply(m2[ok2],`[`,2))),
                    isco88=sprintf("%04d",as.integer(sapply(m2[ok2],`[`,3))),
                    nalt=suppressWarnings(as.integer(sapply(m2[ok2],`[`,4))), stringsAsFactors=FALSE)
volta <- volta[!duplicated(volta$isco08),]
cat("pares na volta:", nrow(volta), "\n")
P <- ocupacoesBR::isco88_isco08
P$volta <- volta$isco88[match(P$isco08, volta$isco08)]
ok3 <- !is.na(P$volta)
cat("com volta definida:", sum(ok3), "; retorna ao MESMO isco88:", sum(P$volta[ok3]==P$isco88[ok3]),
    sprintf(" (%.1f%%)\n", 100*mean(P$volta[ok3]==P$isco88[ok3])))
cat("nao fecha:", sum(P$volta[ok3]!=P$isco88[ok3]), "\n")

d <- suppressWarnings(crosswalk_tse())
j <- match(d$isco88, P$isco88)
d$volta <- P$volta[j]
z <- !is.na(d$volta)
cat("codigos TSE cuja ida-e-volta NAO fecha:", sum(d$volta[z]!=d$isco88[z]), "de", sum(z),
    sprintf(" (%.1f%%)\n", 100*mean(d$volta[z]!=d$isco88[z])))
u <- unique(d[z & d$volta!=d$isco88, c("isco88","isco08","volta","isei88")])
print(head(u[order(u$isco88),],15), row.names=FALSE)
