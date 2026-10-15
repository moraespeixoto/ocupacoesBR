# Indice socioeconomico ISEI a partir da CBO-94

Indice socioeconomico ISEI a partir da CBO-94

## Usage

``` r
cbo94_para_isei(cbo94)
```

## Arguments

- cbo94:

  Vetor de codigos da CBO-94. Aceita "2-11.20" ou "21120".

## Value

Vetor numerico com o escore ISEI-88, na escala de Ganzeboom e Treiman
(de 16 a 90 neste dicionario): quanto maior, mais a ocupacao converte
escolaridade em renda. Mesmo comprimento e ordem do vetor de entrada;
`NA` onde o codigo nao tem correspondencia na tabela
[isco88_medidas](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_medidas.md).

## Examples

``` r
cbo94_para_isei("2-11.20")
#> [1] 77
```
