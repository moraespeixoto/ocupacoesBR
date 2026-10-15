# SIOPS-08 da ocupação declarada ao TSE

SIOPS-08 da ocupação declarada ao TSE

## Usage

``` r
tse_para_siops08(cod, ano = NULL)
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

Vetor numerico com o escore SIOPS (Standard International Occupational
Prestige Scale) de Treiman, na escala de 0 a 100 do ISMF: quanto maior,
mais prestigiada a ocupacao na media dos estudos originais. Mesmo
comprimento e ordem do vetor de entrada; `NA` onde o codigo nao tem
correspondencia na tabela.

## Examples

``` r
tse_para_siops08(c(111, 169))
#> [1] 78.01 44.83
```
