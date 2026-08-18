# Os percursos, e onde cada um se interrompe

Uma tradução que sempre devolve uma resposta é uma tradução que mente em
algum lugar. Este artigo percorre os quatro caminhos do pacote e mostra,
em cada um, onde ele para e por quê.

## A ponte entre as duas ISCO

A Organização Internacional do Trabalho revisou a ISCO-88 em 2008, e a
revisão não é uma renumeração: ocupações foram fundidas, separadas e
movidas de grande grupo. A tábua do *International Stratification and
Mobility File* registra essas mudanças, e em boa parte dos casos um
código antigo tem mais de um destino possível.

![A ambiguidade da ponte ISCO-88 para ISCO-08](figuras/ponte_isco08.svg)

A ambiguidade da ponte ISCO-88 para ISCO-08

``` r
table(isco88_isco08$n_alternativas > 1)
#> 
#> FALSE  TRUE 
#>   344   186
```

São 186 códigos ambíguos em 530. A função devolve, por padrão, apenas o
destino escolhido:

``` r
isco88_para_isco08("1229")
#> [1] "1300"
```

E devolve a marca junto quando ela é pedida:

``` r
isco88_para_isco08("1229", com_ambiguidade = TRUE)
#>   isco88 isco08 n_alternativas
#> 1   1229   1300              9
```

O `com_ambiguidade` não muda a tradução. Ele diz quanta confiança ela
merece, e existe para que a incerteza possa entrar na análise em vez de
desaparecer nela.

## A escada da CBO, e o empate

O dado administrativo brasileiro é sujo de um jeito específico: o código
de seis dígitos da CBO-2002 aparece truncado em quatro, ou aparece com
um sufixo que a tábua oficial não conhece. O pacote tem duas respostas
para isso, e elas fazem coisas diferentes.

![O que a CBO-2002 faz quando o código não está na
tábua](figuras/cbo_empate_escada.svg)

O que a CBO-2002 faz quando o código não está na tábua

O `empate` decide o que fazer quando a entrada é uma família de quatro
dígitos e as ocupações dessa família não concordam num único ISCO:

``` r
empatadas <- cbo2002_familia_isco88$familia[cbo2002_familia_isco88$empate]
length(empatadas)
#> [1] 19

suppressWarnings(cbo2002_para_isco(empatadas[1:3]))
#> [1] NA NA NA
cbo2002_para_isco(empatadas[1:3], empate = "moda")
#> [1] "2111" "2451" "3111"
```

O padrão é `"na"`, e é o padrão certo: numa família empatada a tábua não
sabe, e `"moda"` é uma escolha do analista, que deve ser declarada.

A `escada` é outra coisa. Ela só age sobre o que já saiu `NA`, e sobe a
hierarquia da classificação até achar um prefixo que a tábua conheça:

``` r
# códigos no formato da RAIS que não estão na tábua ocupação a ocupação
fora <- paste0(substr(cbo2002_isco88$cbo2002[1:40], 1, 4), "99")

sum(!is.na(suppressWarnings(cbo2002_para_isco(fora))))
#> [1] 0
sum(!is.na(cbo2002_para_isco(fora, escada = TRUE)))
#> Warning: 16 código(s) sem correspondência em cbo2002_isco88: 111199, 111399,
#> 131399, 141499, 141599, 141699, 141799, 142199, 142299, 142399, ...
#> [1] 33
```

Quarenta códigos que a tradução direta não resolve, e a escada resolve
trinta e três. Os sete restantes continuam `NA`, porque nem o prefixo de
dois dígitos está na tábua. O preço dos trinta e três é a perda de
resolução, e ele fica registrado:
[`crosswalk_cbo2002()`](https://moraespeixoto.github.io/ocupacoesBR/reference/crosswalk_cbo2002.md)
devolve a coluna `nivel_usado`, que diz em que degrau cada tradução foi
obtida.

``` r
cw <- crosswalk_cbo2002(fora, escada = TRUE)
table(cw$nivel_usado, useNA = "ifany")
#> 
#>    4 <NA> 
#>   33    7
```

## A quebra de 2002 no cadastro do TSE

O TSE reformou o cadastro de ocupações entre a eleição de 2000 e a de
2002, e a reforma reaproveitou números. O código 214 era delegado de
polícia até 2000; a partir de 2002 é escultor e pintor.

``` r
tse_quebra_2002[tse_quebra_2002$tipo == "reutilizado",
                c("cod_tse", "rotulo_ate_2000", "rotulo_apos_2002")]
#>    cod_tse                                               rotulo_ate_2000
#> 5      214                                           DELEGADO DE POLICIA
#> 6      391                                           CHEFE INTERMEDIARIO
#> 7      215        OCUPANTE DE CARGO DE DIRECAO E ASSESSORAMENTO SUPERIOR
#> 8      216               OFICIAIS DAS FORCAS ARMADAS E FORCAS AUXILIARES
#> 9      521 GOVERNANTA DE HOTEL, CAMAREIRO, PORTEIRO, COZINHEIRO E GARCOM
#> 13     158                                            DESENHISTA TÉCNICO
#> 25     211                                     PROCURADOR E ASSEMELHADOS
#>                         rotulo_apos_2002
#> 5                      ESCULTOR E PINTOR
#> 6               TAQUÍGRAFO E ESTENÓGRAFO
#> 7        ARTISTA PLÁSTICO E ASSEMELHADOS
#> 8  EMBALADOR, EMPACOTADOR E ASSEMELHADOS
#> 9                             GOVERNANTA
#> 13                TÉCNICO EM INFORMÁTICA
#> 25  ESTIVADOR, CARREGADOR E ASSEMELHADOS
```

Por isso todas as funções da porta do TSE aceitam `ano`:

``` r
tse_para_isei("214")
#> [1] 54
tse_para_isei(c("214", "214"), ano = c(1998L, 2026L))
#> Warning: 1 candidatura(s) usam código(s) que o TSE REUTILIZOU depois (214): naquele ano designavam outra ocupação, e voltam NA.
#> Veja ?tse_vigencia.
#> [1] NA 54
```

Sem o `ano`, o pacote aplica o cadastro atual a tudo, e uma série de
1998 a 2026 que passe por qualquer um desses códigos descreve uma
trajetória que nunca existiu. O
[`checa_periodo()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_periodo.md)
avisa quando o vetor de códigos toca a quebra.

## A categoria residual

Nenhum dos percursos acima resolve o problema maior, que é anterior a
todos eles: a ocupação mais declarada nas candidaturas brasileiras é
“OUTROS”.

``` r
r <- tse_ocupacao_rotulos
round(100 * sum(r$n[r$cod_tse == "999"]) / sum(r$n), 1)
#> [1] 16.8
```

16.8% de todas as candidaturas de 1998 a 2026. O pacote devolve `NA`
para ela, e nenhuma escada, nenhum desempate e nenhuma ponte muda isso.
É o limite do dado, e ele é declarado em vez de preenchido.
