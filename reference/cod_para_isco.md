# ISCO-88 a partir da COD

Passa pela ISCO-08 e desce pela ponte reversa. E o caminho para o
ISEI-88 e para o EGP a partir da PNAD Continua e do Censo.

## Usage

``` r
cod_para_isco(cod)
```

## Arguments

- cod:

  Vetor de codigos da COD, de quatro digitos.

## Value

Vetor de texto com o ISCO-88.

## Examples

``` r
cod_para_isco(c("2211", "0411"))
#> [1] "2221" "5162"
```
