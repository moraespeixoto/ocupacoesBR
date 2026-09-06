# ISCO-08 da ocupação declarada ao TSE

ISCO-08 da ocupação declarada ao TSE

## Usage

``` r
tse_para_isco08(cod, com_ambiguidade = FALSE, ano = NULL)
```

## Arguments

- cod:

  Vetor de códigos de ocupação do TSE (numérico ou texto).

- com_ambiguidade:

  Se `TRUE`, devolve um `data.frame` com o código e o número de
  alternativas da OIT em vez de só o código.

- ano:

  Vetor opcional de anos de eleição, do mesmo comprimento de `cod`. Com
  ele, as candidaturas cujo código o TSE **reutilizou** depois voltam
  `NA` com aviso, em vez de traduzidas pelo dicionário errado: o código
  215 designava um cargo de direção até 2000 e passou a designar artista
  plástico. Sem ele, o comportamento é o de sempre. Veja
  [`tse_vigencia()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_vigencia.md).

## Value

Vetor de texto, ou um `data.frame` se `com_ambiguidade = TRUE`.

## Não é a mera composição das duas etapas

Em 21 dos 275 códigos o resultado difere de
`isco88_para_isco08(tse_para_isco(cod))`, porque o código do TSE carrega
informação que a ponte genérica não vê: a marca de proprietário — o
`SEMPL` do ISMF, que aciona a promoção de `iskopromo.sps` — e um rótulo
mais fino do que o código ISCO-88 agregado a que o dicionário o associa.
A ponte
[`isco88_para_isco08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_para_isco08.md)
permanece intacta e continua devolvendo o destino oficial da OIT para
quem entra pela ISCO-88. Veja `NEWS.md` da versão 0.2.1 para a lista dos
21, com valor antigo, valor novo e fonte de cada um.

## Examples

``` r
tse_para_isco08(c(111, 169))
#> [1] "2210" "1400"
# o proprietário rural não é rebaixado a trabalhador agrícola:
tse_para_isco08(234)
#> [1] "1311"
isco88_para_isco08("1311")
#> [1] "6130"
```
