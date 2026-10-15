# Prestigio de Treiman a partir do ISCO-88

Prestigio de Treiman a partir do ISCO-88

## Usage

``` r
isco88_para_prestigio(isco88)
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
isco88_para_prestigio("2221")
#> [1] 78
```
