# Prestigio ocupacional de Treiman (SIOPS) a partir do ISCO-88

Prestigio ocupacional de Treiman (SIOPS) a partir do ISCO-88

## Usage

``` r
isco88_para_siops(isco88)
```

## Arguments

- isco88:

  Vetor de codigos ISCO-88.

## Value

Vetor numerico com o escore SIOPS (Standard International Occupational
Prestige Scale) de Treiman, na escala de 0 a 100 do ISMF: quanto maior,
mais prestigiada a ocupacao na media dos estudos originais. Mesmo
comprimento e ordem do vetor de entrada; `NA` onde o codigo nao tem
correspondencia na tabela.

## Examples

``` r
isco88_para_siops(c("2221", "5220", "9130"))
#> [1] 78 32 21
```
