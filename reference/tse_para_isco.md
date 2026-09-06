# Traduz a ocupação declarada ao TSE em ISCO-88

Converte o código de ocupação da candidatura (`CD_OCUPACAO`) no código
da Classificação Internacional Uniforme de Ocupações de 1988, com quatro
dígitos.

## Usage

``` r
tse_para_isco(cod, ano = NULL)
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

Vetor de texto com o ISCO-88 de quatro dígitos. `NA` para códigos que
não designam ocupação (não informada, fora da PEA, vínculo sem função).

## A armadilha do primeiro dígito

Traduzir ocupação pelo primeiro dígito **inverte classes inteiras**. O
grande grupo 9 da CBO brasileira é reparação e manutenção (mecânicos,
ISEI em torno de 34); o grande grupo 9 da ISCO é o das ocupações
elementares (serventes, ISEI entre 16 e 30). Toda tradução válida é, no
mínimo, a dois dígitos — que é o nível em que este pacote opera,
descendo a três ou quatro onde dois fundiriam posições distantes demais
(médico e enfermeiro, por exemplo).

## See also

[`tse_para_isei()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei.md),
[`tse_para_classe()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_classe.md),
[`crosswalk_tse()`](https://moraespeixoto.github.io/ocupacoesBR/reference/crosswalk_tse.md)

## Examples

``` r
tse_para_isco(c(111, 169, 257))
#> [1] "2221" "1300" "1200"
```
