# Indice socioeconomico ISEI a partir do ISCO-88

Indice socioeconomico ISEI a partir do ISCO-88

## Usage

``` r
isco88_para_isei(isco88)
```

## Arguments

- isco88:

  Vetor de codigos ISCO-88.

## Value

Vetor numerico com o escore ISEI-88, na escala de Ganzeboom e Treiman
(de 16 a 90 neste dicionario): quanto maior, mais a ocupacao converte
escolaridade em renda. Mesmo comprimento e ordem do vetor de entrada;
`NA` onde o codigo nao tem correspondencia na tabela
[isco88_medidas](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_medidas.md).

## Examples

``` r
isco88_para_isei(c("2221", "5220", "9130"))
#> [1] 88 43 16
```
