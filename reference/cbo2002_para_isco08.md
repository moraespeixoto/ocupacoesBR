# ISCO-08 a partir da CBO-2002

ISCO-08 a partir da CBO-2002

## Usage

``` r
cbo2002_para_isco08(cbo, com_ambiguidade = FALSE)
```

## Arguments

- cbo:

  Vetor de codigos da CBO-2002, com 6 digitos (ocupacao) ou 4 (familia).
  Aceita "1111-05", "111105" ou 111105.

- com_ambiguidade:

  Se `TRUE`, devolve um `data.frame` com o código e o número de
  alternativas da OIT em vez de só o código.

## Value

Vetor de texto, ou um `data.frame` se `com_ambiguidade = TRUE`.

## Examples

``` r
cbo2002_para_isco08("225120")
#> [1] "2210"
```
