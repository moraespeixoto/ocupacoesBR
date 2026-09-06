# Prestígio ocupacional SIOPS da ocupação declarada ao TSE

Devolve o escore SIOPS (Standard International Occupational Prestige
Scale), de Treiman, ancorado na ISCO-88. É uma régua de prestígio,
distinta do ISEI, que mede posição socioeconômica.

## Usage

``` r
tse_para_siops(cod, ano = NULL)
```

## Arguments

- cod:

  Vetor de códigos de ocupação do TSE (numérico ou texto).

- ano:

  Vetor opcional de anos de eleição, do mesmo comprimento de `cod`. Com
  ele, as candidaturas cujo código o TSE **reutilizou** depois voltam
  `NA` com aviso, em vez de traduzidas pelo dicionário errado: o código
  215 designava um cargo de direção até 2000 e passou a designar artista
  plástico. Sem ele, o comportamento é o de sempre. Veja
  [`tse_vigencia()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_vigencia.md).

## Value

Vetor numérico com o escore SIOPS, ou `NA`.

## Examples

``` r
tse_para_siops(c(111, 169, 257))
#> [1] 78 50 60
```
