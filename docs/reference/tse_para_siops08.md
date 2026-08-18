# SIOPS-08 da ocupação declarada ao TSE

SIOPS-08 da ocupação declarada ao TSE

## Uso

``` r
tse_para_siops08(cod, ano = NULL)
```

## Argumentos

- cod:

  Vetor de códigos de ocupação do TSE (numérico ou texto).

- ano:

  Vetor opcional de anos de eleição, do mesmo comprimento de `cod`. Com
  ele, as candidaturas cujo código o TSE **reutilizou** depois voltam
  `NA` com aviso, em vez de traduzidas pelo dicionário errado: o código
  215 designava um cargo de direção até 2000 e passou a designar artista
  plástico. Sem ele, o comportamento é o de sempre. Veja
  [`tse_vigencia()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_vigencia.md).

## Valor

Vetor numérico com o escore SIOPS ancorado na ISCO-08.

## Exemplos

``` r
tse_para_siops08(c(111, 169))
#> [1] 78.01 44.83
```
