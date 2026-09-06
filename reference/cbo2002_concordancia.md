# Quao homogenea e a familia da CBO-2002?

Devolve a proporcao das ocupacoes da familia que compartilham o ISCO
majoritario. Vale 1 quando a familia inteira cai num unico ISCO; abaixo
disso, traduzir pela familia mistura posicoes distintas.

## Usage

``` r
cbo2002_concordancia(cbo)
```

## Arguments

- cbo:

  Vetor de codigos da CBO-2002 (familia ou ocupacao; a ocupacao e
  reduzida a sua familia).

## Value

`data.frame` com a familia, o ISCO majoritario, quantas ocupacoes foram
vistas, quantas a familia tem de fato, a cobertura, quantos ISCO
distintos aparecem, a concordancia (ou `NA`) e a marca de empate.

## Concordancia so e afirmavel sobre familia vista inteira

A tabua do MTE cobre metade da CBO-2002, e a concordancia era calculada
sobre as ocupacoes **vistas**, nao sobre a familia real. O efeito: 131
familias tinham UMA unica ocupacao na tabua e reportavam
`concordancia = 1` — o valor que sinaliza "sem ambiguidade nenhuma" — e
em 87 delas a familia de fato tem mais de uma ocupacao. Era certeza
maxima onde a evidencia era minima.

Agora `concordancia` so recebe valor quando `cobertura_familia` vale 1,
isto e, quando a familia foi vista por inteiro (175 das 436). Nas demais
fica `NA`, e a proporcao entre as ocupacoes vistas segue disponivel em
`concordancia_vista`, sem posar de diagnostico. O denominador vem do
dominio oficial da CBO-2002 no Novo CAGED, 2.777 ocupacoes.

## Examples

``` r
cbo2002_concordancia(c("5211", "4121"))
#>   familia isco88 n_ocupacoes n_ocupacoes_cbo cobertura_familia n_isco_distintos
#> 1    5211   5220           6               8              0.75                1
#> 2    4121   4111           3               4              0.75                3
#>   concordancia concordancia_vista empate
#> 1           NA              1.000  FALSE
#> 2           NA              0.333   TRUE
cbo2002_concordancia("3171")  # vista em 1/4: concordancia NA
#>   familia isco88 n_ocupacoes n_ocupacoes_cbo cobertura_familia n_isco_distintos
#> 1    3171   3121           1               4              0.25                1
#>   concordancia concordancia_vista empate
#> 1           NA                  1  FALSE
```
