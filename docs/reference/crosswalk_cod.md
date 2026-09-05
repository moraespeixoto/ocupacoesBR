# Tabela completa de traducao a partir da COD

Tabela completa de traducao a partir da COD

## Uso

``` r
crosswalk_cod(cod = NULL)
```

## Argumentos

- cod:

  Vetor opcional de codigos. Se omitido, devolve a tabela inteira.

## Valor

`data.frame` com COD, titulo, ISCO-08, ISCO-88, as duas versoes do ISEI,
o prestigio, o EGP e o tipo de correspondencia.

## A coluna `egp` sai degradada, e em silêncio

O EGP não é função só da ocupação: as suas regras pedem a posição no
emprego e o número de subordinados, e nenhum dos dois existe num código
de COD da PNAD. A coluna é calculada sem eles, e a consequência não é
ruído — **IVa, IVb e V saem estruturalmente vazias**, de modo que a
pequena burguesia aparece contada como classe de serviço. Isso é
inversão de classe, não arredondamento.

A chamada silencia o aviso que
[`isco88_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_para_egp.md)
emitiria, porque repeti-lo uma vez por linha seria inútil; a ressalva
passou a viver aqui, na auditoria de 05/09/2026. Para publicar, use os
colapsos de 5 ou 3 classes, onde IVa e IVb se fundem a categorias que
existem, e considere
[isco_posicao_br](https://moraespeixoto.github.io/ocupacoesBR/reference/isco_posicao_br.md)
como prior empírico da posição no emprego. Compare com
[`crosswalk_tse()`](https://moraespeixoto.github.io/ocupacoesBR/reference/crosswalk_tse.md),
que é a única das quatro tabelas em que o EGP sai completo, porque o
dicionário do TSE marca quem trabalha por conta própria.

## Exemplos

``` r
head(crosswalk_cod())
#>    cod                                   titulo isco08 isco88 isei08 isei_br
#> 1 0110              Oficiais das forças armadas   0110   0110  60.92    83.4
#> 2 0210    Graduados e praças das forças armadas   0210   0110  51.63    60.4
#> 3 0411              Oficiais de polícia militar   5412   5162  51.50    69.1
#> 4 0412    Graduados e praças da polícia militar   5412   5162  51.50    69.1
#> 5 0511             Oficiais de bombeiro militar   5411   5161  46.38    62.9
#> 6 0512 Graduados e praças do corpo de bombeiros   5411   5161  46.38    62.9
#>   isei88 prestigio88                                egp correspondencia
#> 1     NA          NA                               <NA>      identidade
#> 2     NA          NA                               <NA>      identidade
#> 3     50          40 VI: trabalhador manual qualificado       adaptacao
#> 4     50          40 VI: trabalhador manual qualificado       adaptacao
#> 5     42          35 VI: trabalhador manual qualificado       adaptacao
#> 6     42          35 VI: trabalhador manual qualificado       adaptacao
crosswalk_cod(c("2211", "0411", "6225"))
#>    cod                      titulo isco08 isco88 isei08 isei_br isei88
#> 1 2211              Médicos gerais   2211   2221  88.70    84.6     88
#> 2 0411 Oficiais de polícia militar   5412   5162  51.50    69.1     50
#> 3 6225                  Pescadores   6220   6150  16.33    12.3     28
#>   prestigio88                                      egp correspondencia
#> 1          78 I: dirigentes e profissionais superiores      identidade
#> 2          40       VI: trabalhador manual qualificado       adaptacao
#> 3          28               VIIb: trabalhador agrícola       agregacao
```
