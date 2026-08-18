# A ocupação declarada é um mandato ou cargo político?

Marca as ocupações que são o próprio ofício político (vereador,
deputado, prefeito, governador e afins). Útil para separar quem já vive
da política de quem chega a ela de outra ocupação.

## Uso

``` r
tse_para_politico(cod, ano = NULL)
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

Vetor lógico.

## Exemplos

``` r
tse_para_politico(c(274, 169))
#> [1]  TRUE FALSE
```
