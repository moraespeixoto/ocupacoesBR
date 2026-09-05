# ============================================================================
# 10_gera_autorrotulo.R — o patrimônio por trás dos códigos autodeclarados
# ----------------------------------------------------------------------------
# `?tse_para_componente_alta` sustenta o argumento central do pacote sobre a
# alta proprietária numa tabela de patrimônio mediano do código 257 por cargo.
# Essa tabela foi DIGITADA e errou duas vezes: entrou com números da microbase
# v2, em que cada bem era somado duas vezes, e sobreviveu à correção de
# 09/2026 porque ninguém revisita um número que não é executado. Auditoria de
# 05/09/2026.
#
# ESTE SCRIPT TIRA O NÚMERO DA PROSA E O PÕE NUM OBJETO, como o
# `08_gera_dispersao.R` fez com o coeficiente de 0,208. A documentação passa a
# ler a tabela do dado, e uma troca de fonte se propaga sozinha.
#
# O que se publica são quantis por célula (código x cargo), com n >= 30: não há
# candidatura, não há município, não há ano. Nada identificável.
#
# O recorte não é arbitrário. São os dez códigos de `tse_codigos_autorrotulo`,
# aqueles cujo rótulo é autodescrição sem registro externo que a sustente, mais
# o 131 (ADVOGADO), que é o contraexemplo ancorado — para chegar a ele é
# preciso estar inscrito na OAB. O contraste entre os dois regimes é o que a
# documentação afirma, e agora ele se recalcula.
#
# FONTE: ~/dados_ocupacoesBR/microbase_validacao_1998_2026.rds (mesma de
#   `05_gera_validacao.R` e `08_gera_dispersao.R`). Não versionada.
#   Ajuste OCUPACOESBR_MICROBASE.
#
# Rodar: Rscript data-raw/10_gera_autorrotulo.R
# ============================================================================

MICRO <- path.expand(Sys.getenv("OCUPACOESBR_MICROBASE",
                                "~/dados_ocupacoesBR/microbase_validacao_1998_2026.rds"))
if (!file.exists(MICRO))
  stop("microbase nao encontrada em:\n  ", MICRO,
       "\nAponte OCUPACOESBR_MICROBASE para o arquivo.", call. = FALSE)

devtools::load_all(quiet = TRUE)
m <- readRDS(MICRO)
stopifnot(all(c("cod_ocup", "cargo", "patrim", "ano") %in% names(m)))

N_MIN  <- 30L
CODS   <- c(ocupacoesBR::tse_codigos_autorrotulo, "131")
# A ordem e a hierarquia do cargo, nao a alfabetica: a tabela existe para
# mostrar um GRADIENTE, e um fator alfabetico o esconderia. PRESIDENTE e VICE-*
# ficam de fora por n irrisorio; suplentes, por nao serem disputa.
CARGOS <- c("VEREADOR", "PREFEITO", "DEPUTADO ESTADUAL", "DEPUTADO DISTRITAL",
            "DEPUTADO FEDERAL", "SENADOR", "GOVERNADOR")
# "TODOS" nao e um cargo: e a linha agregada do codigo. Ela precisa existir
# porque a afirmacao que a documentacao faz — a distancia entre os extremos
# DENTRO do codigo — e sobre o codigo inteiro, e uma razao p90/p10 nao se
# recupera das celulas. Sem esta linha, o numero voltaria a ser digitado.
TODOS  <- "TODOS"

# patrimonio > 0: o zero aqui e ausencia de declaracao de bens, nao pobreza
# medida, e a mediana de um vetor com metade de zeros mede o formulario
ok <- m$cod_ocup %in% CODS & m$cargo %in% CARGOS &
      !is.na(m$patrim) & m$patrim > 0
d  <- m[ok, c("cod_ocup", "cargo", "patrim")]
message(nrow(d), " candidaturas com patrimonio positivo nos ", length(CODS),
        " codigos.")

pares <- unique(d[, c("cod_ocup", "cargo")])
pares <- rbind(pares,
               data.frame(cod_ocup = unique(d$cod_ocup), cargo = TODOS,
                          stringsAsFactors = FALSE))
linhas <- lapply(seq_len(nrow(pares)), function(j) {
  sel <- d$cod_ocup == pares$cod_ocup[j] &
         (pares$cargo[j] == TODOS | d$cargo == pares$cargo[j])
  g <- d$patrim[sel]
  q <- stats::quantile(g, c(0.10, 0.50, 0.90), names = FALSE)
  data.frame(cod_tse = pares$cod_ocup[j], cargo = pares$cargo[j],
             n = length(g), p10 = q[1], mediana = q[2], p90 = q[3],
             stringsAsFactors = FALSE)
})
res <- do.call(rbind, linhas)
res <- res[res$n >= N_MIN, ]

res$rotulo   <- ocupacoesBR::tse_para_rotulo(res$cod_tse)
res$ancorado <- !(res$cod_tse %in% ocupacoesBR::tse_codigos_autorrotulo)
res$cargo    <- factor(res$cargo, levels = c(CARGOS, TODOS))
res <- res[order(res$cod_tse, res$cargo), ]
res <- res[, c("cod_tse", "rotulo", "cargo", "ancorado",
               "n", "p10", "mediana", "p90")]
row.names(res) <- NULL
# arredondar ao real: a precisao abaixo disso e ruido do formulario
res[c("p10", "mediana", "p90")] <- lapply(res[c("p10", "mediana", "p90")], round)

tse_autorrotulo_patrimonio <- res
attr(tse_autorrotulo_patrimonio, "n_min") <- N_MIN
attr(tse_autorrotulo_patrimonio, "anos")  <- range(m$ano[ok])
attr(tse_autorrotulo_patrimonio, "n_obs") <- nrow(d)

# ---- as afirmacoes que a documentacao faz, conferidas aqui -----------------
v <- function(k, c_) res[res$cod_tse == k & res$cargo == c_, ]
message("257 vereador -> senador: fator ",
        round(v("257", "SENADOR")$mediana / v("257", "VEREADOR")$mediana, 1))
t257 <- d$patrim[d$cod_ocup == "257"]
tt <- v("257", TODOS)
message("257 p90/p10 (linha TODOS): ", round(tt$p90 / tt$p10, 1))
stopifnot(abs(tt$p90 / tt$p10 -
              stats::quantile(t257, .9) / stats::quantile(t257, .1)) < 0.1)
print(res[res$cod_tse %in% c("257", "131"), ])

usethis::use_data(tse_autorrotulo_patrimonio, overwrite = TRUE)
