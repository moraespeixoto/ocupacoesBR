# Tabela completa de traducao a partir da CBO-2002

Tabela completa de traducao a partir da CBO-2002

## Uso

``` r
crosswalk_cbo2002(cbo = NULL, empate = c("na", "moda"), escada = FALSE)
```

## Argumentos

- cbo:

  Vetor opcional de codigos. Se omitido, devolve a tabua inteira.

- empate:

  O que fazer quando a familia nao tem ISCO majoritario: `"na"` (padrao)
  devolve `NA`; `"moda"` devolve o vencedor do desempate por menor
  codigo, como nas versoes anteriores.

- escada:

  Se `TRUE`, sobe a hierarquia da CBO para preencher as ocupacoes
  ausentes da tabua; veja
  [`cbo2002_para_isco()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_isco.md).
  A coluna `nivel_usado` sai de qualquer modo, e diz de que degrau veio
  o ISCO de cada linha: 6 e a propria ocupacao, 4 a familia, 3 o
  subgrupo, 2 o subgrupo principal.

## Valor

`data.frame` com CBO-2002, titulo, familia, CBO-94, ISCO-88, ISCO-08,
ISEI, SIOPS, EGP, `agregado`, `empate` e `nivel_usado`. `empate` e
`TRUE` quando a linha e uma familia de quatro digitos sem ISCO
majoritario; com `empate = "na"` (padrao) o ISCO dessa linha sai `NA`,
exatamente como em
[`cbo2002_para_isco()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_isco.md)
— a tabela nao pode devolver o que a porta recusa.

## Exemplos

``` r
head(crosswalk_cbo2002())
#>   cbo2002                        titulo familia cbo94 isco88 isco08 isei88
#> 1  111105                       Senador    1111 21120   1110   1111     77
#> 2  111110              Deputado federal    1111 21130   1110   1111     77
#> 3  111115 Deputado estadual e distrital    1111 21135   1110   1111     77
#> 4  111120                      Vereador    1111 21140   1110   1111     77
#> 5  111330                  Juiz federal    1113 21320   1110   1111     77
#> 6  111345              Juiz do trabalho    1113 21350   1110   1111     77
#>   siops88                                      egp agregado empate nivel_usado
#> 1      64 I: dirigentes e profissionais superiores    FALSE  FALSE           6
#> 2      64 I: dirigentes e profissionais superiores    FALSE  FALSE           6
#> 3      64 I: dirigentes e profissionais superiores    FALSE  FALSE           6
#> 4      64 I: dirigentes e profissionais superiores    FALSE  FALSE           6
#> 5      64 I: dirigentes e profissionais superiores    FALSE  FALSE           6
#> 6      64 I: dirigentes e profissionais superiores    FALSE  FALSE           6
crosswalk_cbo2002(c("1111-05", "225120"))
#>   cbo2002               titulo familia cbo94 isco88 isco08 isei88 siops88
#> 1  111105              Senador    1111 21120   1110   1111     77      64
#> 2  225120 Médico cardiologista    2251 06117   2221   2210     88      78
#>                                        egp agregado empate nivel_usado
#> 1 I: dirigentes e profissionais superiores    FALSE  FALSE           6
#> 2 I: dirigentes e profissionais superiores    FALSE  FALSE           6
```
