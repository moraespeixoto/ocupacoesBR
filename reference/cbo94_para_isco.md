# Traduz a CBO-94 em ISCO-88

Para microdado anterior a 2003, que usa a classificacao de 1994 (cinco
digitos). A correspondencia vem da mesma tabua oficial do Ministerio do
Trabalho, pela coluna CBO-94.

## Usage

``` r
cbo94_para_isco(cbo94)
```

## Arguments

- cbo94:

  Vetor de codigos da CBO-94. Aceita "2-11.20" ou "21120".

## Value

Vetor de texto com o ISCO-88 de quatro digitos, ou `NA`.

## Examples

``` r
cbo94_para_isco(c("2-11.20", "21130"))
#> [1] "1110" "1110"
```
