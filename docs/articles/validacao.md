# A medida se sustenta? Validação contra um critério externo

Todo o resto deste pacote é tradução: um código do TSE vira um ISCO, que
vira um ISEI. Nada nessa cadeia se afere contra coisa alguma **fora**
dela — e um crosswalk internamente consistente pode estar inteiramente
errado.

Esta vinheta faz a única pergunta que importa: as posições que a medida
atribui correspondem a algo observável e independente?

O critério são duas variáveis que o próprio TSE coleta e que **não
entram na construção da medida em momento nenhum**: o patrimônio
declarado na candidatura e o grau de instrução. Elas estão agregadas por
ocupação em `tse_validacao`.

``` r
library(ocupacoesBR)

v <- tse_validacao
v$isei   <- isco88_para_isei(tse_isco$isco88[match(v$cod_tse, tse_isco$cod_tse)])
v$rotulo <- tse_para_rotulo(v$cod_tse)
v <- v[!is.na(v$isei), ]

# A mediana de patrimonio e NA onde faltam declaracoes de bens suficientes (ver
# ?tse_validacao). A escolaridade esta medida em todas as linhas; o patrimonio,
# so nestas.
vb <- v[!is.na(v$mediana_patrimonio), ]
c(com_escolaridade = nrow(v), com_patrimonio = nrow(vb))
#> com_escolaridade   com_patrimonio 
#>              208              165
```

## O resultado

``` r
r <- function(x, y, m = "pearson") round(cor(x, y, method = m), 3)

data.frame(
  criterio = c("% com ensino superior", "log da mediana de patrimonio"),
  n        = c(nrow(v), nrow(vb)),
  pearson  = c(r(v$isei, v$pct_superior),
               r(vb$isei, log(vb$mediana_patrimonio))),
  spearman = c(r(v$isei, v$pct_superior, "spearman"),
               r(vb$isei, log(vb$mediana_patrimonio), "spearman")))
#>                       criterio   n pearson spearman
#> 1        % com ensino superior 208   0.765    0.812
#> 2 log da mediana de patrimonio 165   0.681    0.695
```

Correlações dessa ordem, contra critérios que não participaram da
construção da medida, são evidência forte de que o ISEI atribuído às
ocupações brasileiras mede o que promete medir.

![ISEI contra patrimonio mediano e
escolaridade](validacao_files/figure-html/unnamed-chunk-3-1.png)

## O contraste que é o verdadeiro resultado

No nível do **indivíduo**, a correlação entre ISEI e patrimônio é de
apenas **0,207**. No nível da **ocupação**, é 0,682. Essa diferença não
é defeito: é a definição do que o ISEI é.

Uma medida de posição ocupacional explica a variância **entre**
ocupações e quase nada da variância **dentro** de cada uma. Advogados
variam enormemente em patrimônio entre si, e o ISEI não tem nada a dizer
sobre isso — nem deveria.

A consequência é direta: **não use ISEI como proxy de renda
individual.** Ele responde “que posição esta ocupação ocupa na
estrutura”, não “quanto esta pessoa tem”.

## Onde a medida não é monótona

A correlação alta esconde inversões locais que importam:

``` r
alvo <- c("169", "257", "111", "265", "113", "601")
d <- vb[vb$cod_tse %in% alvo, c("rotulo", "isei", "pct_superior",
                                "mediana_patrimonio")]
d[order(-d$isei), ]
#>                              rotulo isei pct_superior mediana_patrimonio
#> 9                            MÉDICO   88         99.0            1650752
#> 121                      EMPRESARIO   68         22.9             497797
#> 126 PROFESSOR DE ENSINO FUNDAMENTAL   66         74.7             193688
#> 57                      COMERCIANTE   51          7.1             296088
#> 11                       ENFERMEIRO   43         59.6             222662
#> 189                      AGRICULTOR   23          2.5             244790
```

O comerciante e o empresário têm ISEI de classe média e patrimônio de
classe alta; a professora tem ISEI alto e patrimônio modesto. **São duas
réguas diferentes** — status ocupacional e capital econômico —, e elas
discordam por desenho, não por erro.

Quem cruzar as duas num mesmo gráfico precisa dizer isso ao leitor. É
exatamente a distinção que
[`tse_para_componente_alta()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_componente_alta.md)
opera ao separar a classe alta em proprietária e credenciada.

## A anomalia do cuidado

``` r
data.frame(
  regua = c("ISEI-88", "ISEI-08"),
  enfermagem = c(tse_para_isei("113"), round(tse_para_isei08("113"), 1)))
#>     regua enfermagem
#> 1 ISEI-88       43.0
#> 2 ISEI-08       68.7

v$pct_superior[v$cod_tse == "113"]
#> [1] 59.6
```

O ISEI-88 põe a enfermagem **abaixo** do escriturário, apesar de quase
60% de ensino superior. A revisão de 2008 da OIT corrigiu isso, e o
ISEI-08 a promove em mais de vinte pontos.

Isso não é peculiaridade brasileira, mas pesa mais aqui: o país tem um
vale de ocupações femininas de alta escolaridade e baixa remuneração —
enfermagem, docência, assistência social. **Para análise de gênero,
prefira a ISCO-08.**

``` r
fem <- v$pct_mulher > 50
round(c(feminina = mean(v$isei[fem]), masculina = mean(v$isei[!fem])), 1)
#>  feminina masculina 
#>      46.1      47.6
round(c(feminina = mean(v$pct_superior[fem]),
        masculina = mean(v$pct_superior[!fem])), 1)
#>  feminina masculina 
#>      32.1      23.9
```

Ocupações majoritariamente femininas têm **mais** escolaridade e
**menos** ISEI. A régua importada carrega esse viés, e declará-lo é
parte de usá-la bem.

## O que esta vinheta não prova

O critério é o patrimônio de **candidatos**, que não são a população. A
validação mostra que a medida ordena bem as ocupações dentro do universo
eleitoral; não mostra que os escores estão calibrados para o Brasil.

Calibrá-los exigiria refazer o escalonamento do ISEI sobre a PNAD
Contínua — o procedimento de Ganzeboom, De Graaf e Treiman (1992)
aplicado ao dado brasileiro. Isso está em aberto, e é a melhoria de
maior valor que o pacote ainda não tem.
