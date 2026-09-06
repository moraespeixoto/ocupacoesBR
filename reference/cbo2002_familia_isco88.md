# Correspondência da CBO-2002 com a ISCO-88, por família

Para o microdado que publica apenas a família de quatro dígitos.

## Usage

``` r
cbo2002_familia_isco88
```

## Format

`data.frame` com as colunas:

- familia:

  código de quatro dígitos.

- isco88:

  ISCO-88 **majoritário** entre as ocupações da família.

- n_ocupacoes:

  quantas ocupações da família a tábua do MTE cobre.

- n_ocupacoes_cbo:

  quantas ocupações a família tem **de fato**, pelo domínio oficial da
  CBO-2002.

- cobertura_familia:

  `n_ocupacoes / n_ocupacoes_cbo`. Vale 1 quando a família foi vista por
  inteiro — o caso de 175 das 436.

- n_isco_distintos:

  quantos ISCO diferentes aparecem na família.

- concordancia:

  proporção das ocupações que caem no ISCO majoritário, **ou `NA` quando
  `cobertura_familia < 1`**. Vale 1 quando a família é homogênea; abaixo
  disso, traduzir pela família mistura posições distintas.

- concordancia_vista:

  a mesma proporção calculada só sobre as ocupações vistas. Sempre
  preenchida, mas não é diagnóstico da família.

- empate:

  `TRUE` quando a moda **não é maioria** — o ISCO escolhido só venceu
  por ordenação. Tratar essas famílias como uma posição única é
  arbitrário, e `concordancia` sozinha não distingue "dividida" de "cara
  ou coroa".

## Source

Agregado de
[cbo2002_isco88](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_isco88.md);
o denominador vem do domínio oficial da CBO-2002 na aba
`cbo2002ocupação` do layout do Novo CAGED (2.777 ocupações), distribuído
em `inst/extdata/fontes/cbo2002_dominio.txt`.

## Por que há duas concordâncias

A tábua do MTE cobre metade da CBO-2002, e a concordância era apurada
sobre as ocupações **vistas**, não sobre a família real. O resultado é
que 131 famílias tinham uma única ocupação na tábua e reportavam
`concordancia = 1` — o valor que sinaliza ausência total de ambiguidade
— e em **87** delas a família de fato tem mais de uma ocupação. Era
certeza máxima onde a evidência era mínima, e o README chegava a afirmar
que 1 significava "a família inteira cai num único ISCO".

A separação resolve sem descartar informação: `concordancia` só é
afirmada sobre família vista por inteiro; `concordancia_vista` guarda a
proporção bruta para quem quiser inspecioná-la sabendo o que ela é.

## Examples

``` r
# As famílias em que a tábua empata: nelas, o argumento `empate` de
# cbo2002_para_isco() é quem decide entre NA e o ISCO majoritário.
cbo2002_familia_isco88[cbo2002_familia_isco88$empate,
                       c("familia", "isco88", "n_ocupacoes",
                         "n_isco_distintos")]
#>     familia isco88 n_ocupacoes n_isco_distintos
#> 22     2133   2111           2                2
#> 85     2617   2451           2                2
#> 100    3115   3111           2                2
#> 125    3221   3229           2                2
#> 142    3511   3431           2                2
#> 145    3515   4111           2                2
#> 149    3522   3222           2                2
#> 177    4121   4111           3                3
#> 200    5142   9132           3                3
#> 201    5143   7143           4                2
#> 220    5242   9111           2                2
#> 221    5243   9111           2                2
#> 231    6220   6113           2                2
#> 314    7522   7322           6                2
#> 373    8111   8151           6                2
#> 374    8112   8152           2                2
#> 397    8401   7412           2                2
#> 413    8601   7242           3                3
#> 426    9141   7232           2                2
```
