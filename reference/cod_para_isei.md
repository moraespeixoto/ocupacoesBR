# ISEI-88 a partir da COD

Use este, e nao
[`cod_para_isei08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cod_para_isei08.md),
para comparar com dado eleitoral: o pacote e ancorado na ISCO-88 e e
nela que o TSE aterrissa.

## Usage

``` r
cod_para_isei(cod)
```

## Arguments

- cod:

  Vetor de codigos da COD, de quatro digitos.

## Value

Vetor numerico com o escore ISEI-88, na escala de Ganzeboom e Treiman
(de 16 a 90 neste dicionario): quanto maior, mais a ocupacao converte
escolaridade em renda. Mesmo comprimento e ordem do vetor de entrada;
`NA` onde o codigo nao tem correspondencia na tabela
[isco88_medidas](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_medidas.md).

## Examples

``` r
cod_para_isei(c("2211", "9629"))
#> [1] 88 25
```
