# ISCO-08 a partir da CBO-94

ISCO-08 a partir da CBO-94

## Uso

``` r
cbo94_para_isco08(cbo94, com_ambiguidade = FALSE)
```

## Argumentos

- cbo94:

  Vetor de codigos da CBO-94. Aceita "2-11.20" ou "21120".

- com_ambiguidade:

  Se `TRUE`, devolve um `data.frame` com o código e o número de
  alternativas da OIT em vez de só o código.

## Valor

Vetor de texto com o ISCO-08, ou um `data.frame` se
`com_ambiguidade = TRUE`.

## Exemplos

``` r
cbo94_para_isco08("2-11.20")
#> [1] "1111"
```
