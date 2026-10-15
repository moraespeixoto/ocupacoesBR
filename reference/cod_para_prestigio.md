# Prestigio de Treiman a partir da COD

Prestigio de Treiman a partir da COD

## Usage

``` r
cod_para_prestigio(cod)
```

## Arguments

- cod:

  Vetor de codigos da COD, de quatro digitos.

## Value

Vetor numerico com o escore SIOPS (Standard International Occupational
Prestige Scale) de Treiman, na escala de 0 a 100 do ISMF: quanto maior,
mais prestigiada a ocupacao na media dos estudos originais. Mesmo
comprimento e ordem do vetor de entrada; `NA` onde o codigo nao tem
correspondencia na tabela.

## Examples

``` r
cod_para_prestigio(c("2211", "9629"))
#> [1] 78 23
```
