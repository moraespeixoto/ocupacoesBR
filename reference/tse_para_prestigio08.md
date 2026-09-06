# Prestigio de Treiman ancorado na ISCO-08, a partir do TSE

Prestigio de Treiman ancorado na ISCO-08, a partir do TSE

## Usage

``` r
tse_para_prestigio08(cod, ano = NULL)
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

Vetor numerico.

## O argumento `ano`, e por que ele chegou tarde aqui

A versao 0.2.0 acrescentou `ano` as portas ancoradas na ISCO-08 e nomeou
tres delas:
[`tse_para_isco08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isco08.md),
[`tse_para_isei08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei08.md)
e
[`tse_para_siops08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_siops08.md).
Esta ficou de fora por descuido, de modo que o nome PREFERIDO da medida
de prestigio nao mascarava vigencia enquanto o seu proprio alias
depreciado mascarava. Quem montasse serie pela porta recomendada
recebia, calado, o escore do cadastro errado nos codigos reutilizados em
2002. Corrigido em 0.3.0; a assinatura agora e a mesma de
[`tse_para_siops08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_siops08.md).

## Examples

``` r
tse_para_prestigio08(c(111, 169))
#> [1] 78.01 44.83
tse_para_prestigio08("215", ano = 2000)   # reutilizado: NA com aviso
#> Warning: 1 candidatura(s) usam código(s) que o TSE REUTILIZOU depois (215): naquele ano designavam outra ocupação, e voltam NA.
#> Veja ?tse_vigencia.
#> [1] NA
```
