# ISEI-88 a partir da COD

Use este, e nao
[`cod_para_isei08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cod_para_isei08.md),
para comparar com dado eleitoral: o pacote e ancorado na ISCO-88 e e
nela que o TSE aterrissa.

## Uso

``` r
cod_para_isei(cod)
```

## Argumentos

- cod:

  Vetor de codigos da COD, de quatro digitos.

## Valor

Vetor numerico com o escore ISEI-88.

## Exemplos

``` r
cod_para_isei(c("2211", "9629"))
#> [1] 88 25
```
