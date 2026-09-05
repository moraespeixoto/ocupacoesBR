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
