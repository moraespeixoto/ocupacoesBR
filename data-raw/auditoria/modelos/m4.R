suppressMessages(library(ocupacoesBR))
G <- "/home/nerd/ocupacoesBR/data-raw/fontes/ganzeboom"
l <- readLines(file.path(G,"isco0888.sps"), warn=FALSE, encoding="UTF-8")
m <- regmatches(l, gregexpr("\\(\\s*-?([0-9]+)\\s*=\\s*([0-9]+)(\\.[0-9]+)?\\s*\\)", l))
pares <- unlist(m)
p2 <- regmatches(pares, regexec("\\(\\s*-?([0-9]+)\\s*=\\s*([0-9]+)(?:\\.([0-9]+))?\\s*\\)", pares))
volta <- data.frame(isco08=sprintf("%04d", as.integer(sapply(p2,`[`,2))),
                    isco88=sprintf("%04d", as.integer(sapply(p2,`[`,3))),
                    nalt=suppressWarnings(as.integer(sapply(p2,`[`,4))), stringsAsFactors=FALSE)
volta$nalt[is.na(volta$nalt)] <- 1L
cat("pares na volta 08->88:", nrow(volta), " dup:", sum(duplicated(volta$isco08)),
    " ambiguos(>1):", sum(volta$nalt>1), sprintf(" (%.1f%%)\n", 100*mean(volta$nalt>1)))
volta <- volta[!duplicated(volta$isco08),]

P <- ocupacoesBR::isco88_isco08
P$volta <- volta$isco88[match(P$isco08, volta$isco08)]
ok <- !is.na(P$volta)
cat("\n== IDA E VOLTA 88->08->88 ==\n")
cat("pares com volta definida:", sum(ok), "de", nrow(P), "\n")
cat("fecha (volta == origem):", sum(P$volta[ok]==P$isco88[ok]),
    sprintf("(%.1f%%)  NAO fecha: %d (%.1f%%)\n", 100*mean(P$volta[ok]==P$isco88[ok]),
            sum(P$volta[ok]!=P$isco88[ok]), 100*mean(P$volta[ok]!=P$isco88[ok])))

# custo em ISEI da nao-idempotencia
M <- ocupacoesBR::isco88_medidas
P$isei_orig <- M$isei88[match(P$isco88, M$isco88)]
P$isei_volta<- M$isei88[match(P$volta,  M$isco88)]
q <- ok & !is.na(P$isei_orig) & !is.na(P$isei_volta)
dd <- P$isei_volta[q]-P$isei_orig[q]
cat("ISEI-88 apos ida-e-volta: media dif", round(mean(dd),2), "dp", round(sd(dd),2),
    "| |dif|>10 em", sum(abs(dd)>10), "codigos\n")

# no universo TSE
d <- suppressWarnings(crosswalk_tse())
j <- match(d$isco88, P$isco88); d$volta <- P$volta[j]
z <- !is.na(d$volta)
cat("\n== NO UNIVERSO DO TSE ==\n")
cat("codigos TSE com volta definida:", sum(z), "; NAO fecham:", sum(d$volta[z]!=d$isco88[z]),
    sprintf("(%.1f%%)\n", 100*mean(d$volta[z]!=d$isco88[z])))
u <- unique(d[z & d$volta!=d$isco88, c("isco88","isco08","volta","isei88","isei08")])
u$isei_volta <- M$isei88[match(u$volta, M$isco88)]
print(u[order(u$isco88),], row.names=FALSE)
