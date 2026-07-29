library(ocupacoesBR)
p <- function(lbl, expr) {
  r <- tryCatch(list(v=eval(expr), e=NULL), error=function(e) list(v=NULL,e=conditionMessage(e)))
  cat("### ", lbl, "\n"); if (!is.null(r$e)) cat("  ERRO: ", r$e, "\n") else { cat("  class=",paste(class(r$v),collapse="/")," typeof=",typeof(r$v)," len=",length(r$v),"\n"); print(utils::head(r$v,6)) }
}
cat("===== A. comprimento zero =====\n")
p("isco88_para_egp(character(0))", quote(suppressWarnings(isco88_para_egp(character(0), avisar=FALSE))))
p("isco88_para_egp(integer(0))", quote(suppressWarnings(isco88_para_egp(integer(0), avisar=FALSE))))
p("tse_para_egp(character(0))", quote(suppressWarnings(tse_para_egp(character(0), avisar=FALSE))))
p("crosswalk_tse(character(0))", quote(suppressWarnings(crosswalk_tse(character(0)))))
p("crosswalk_cbo2002(character(0))", quote(suppressWarnings(crosswalk_cbo2002(character(0)))))
p("cbo2002_concordancia(character(0))", quote(suppressWarnings(cbo2002_concordancia(character(0)))))
p("cbo2002_para_egp(character(0))", quote(suppressWarnings(cbo2002_para_egp(character(0), avisar=FALSE))))
p("checa_periodo(character(0), integer(0))", quote(suppressWarnings(checa_periodo(character(0), integer(0)))))
