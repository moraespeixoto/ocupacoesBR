# Tabela completa de traducao a partir da CBO-94

Tabela completa de traducao a partir da CBO-94

## Uso

``` r
crosswalk_cbo94(cbo94 = NULL)
```

## Argumentos

- cbo94:

  Vetor opcional de codigos. Se omitido, devolve a tabua inteira.

## Valor

`data.frame` com CBO-94, ISCO-88, ISCO-08, ISEI-88, prestigio e EGP.

## A coluna `egp` sai degradada, e em silêncio

O EGP não é função só da ocupação: as suas regras pedem a posição no
emprego e o número de subordinados, e nenhum dos dois existe num código
de CBO-94. A coluna é calculada sem eles, e a consequência não é ruído —
**IVa, IVb e V saem estruturalmente vazias**, de modo que a pequena
burguesia aparece contada como classe de serviço. Isso é inversão de
classe, não arredondamento.

A chamada silencia o aviso que
[`isco88_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_para_egp.md)
emitiria, porque repeti-lo uma vez por linha seria inútil; a ressalva
passou a viver aqui, na auditoria de 05/09/2026. Para publicar, use os
colapsos de 5 ou 3 classes, onde IVa e IVb se fundem a categorias que
existem, e leia
[`isco88_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_para_egp.md).

## Exemplos

``` r
head(crosswalk_cbo94())
#>   cbo94 isco88 isco08 isei88 siops88                                      egp
#> 1 01105   2113   2113     74      69 I: dirigentes e profissionais superiores
#> 2 01110   2113   2113     74      69 I: dirigentes e profissionais superiores
#> 3 01210   2111   2111     74      75 I: dirigentes e profissionais superiores
#> 4 01215   2111   2111     74      75 I: dirigentes e profissionais superiores
#> 5 01230   2111   2111     74      75 I: dirigentes e profissionais superiores
#> 6 01240   2111   2111     74      75 I: dirigentes e profissionais superiores
```
