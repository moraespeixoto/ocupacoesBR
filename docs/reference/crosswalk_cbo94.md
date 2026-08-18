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
