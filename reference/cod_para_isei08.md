# ISEI-08 a partir da COD

ISEI-08 a partir da COD

## Usage

``` r
cod_para_isei08(cod)
```

## Arguments

- cod:

  Vetor de codigos da COD, de quatro digitos.

## Value

Vetor numerico com o escore ISEI-08, na escala de Ganzeboom e Treiman
reestimada sobre o ISSP de 2002-2007 (de 11 a 89 neste dicionario).
Mesmo comprimento e ordem do vetor de entrada; `NA` onde o codigo nao
tem correspondencia na tabela
[isco08_medidas](https://moraespeixoto.github.io/ocupacoesBR/reference/isco08_medidas.md).

## Examples

``` r
cod_para_isei08(c("2211", "9629"))
#> [1] 88.70 27.91
```
