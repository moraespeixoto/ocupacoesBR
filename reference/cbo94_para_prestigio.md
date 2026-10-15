# Prestigio de Treiman a partir da CBO-94

Prestigio de Treiman a partir da CBO-94

## Usage

``` r
cbo94_para_prestigio(cbo94)
```

## Arguments

- cbo94:

  Vetor de codigos da CBO-94. Aceita "2-11.20" ou "21120".

## Value

Vetor numerico com o escore SIOPS (Standard International Occupational
Prestige Scale) de Treiman, na escala de 0 a 100 do ISMF: quanto maior,
mais prestigiada a ocupacao na media dos estudos originais. Mesmo
comprimento e ordem do vetor de entrada; `NA` onde o codigo nao tem
correspondencia na tabela.

## Examples

``` r
cbo94_para_prestigio("2-11.20")
#> [1] 64
```
