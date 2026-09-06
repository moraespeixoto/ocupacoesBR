# ISEI-BR a partir da COD

Versao para a classificacao do IBGE, que e a da PNAD Continua e do
Censo. Leia
[`tse_para_isei_br()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei_br.md)
para o que a regua e e o que ela nao e.

## Usage

``` r
cod_para_isei_br(cod)
```

## Arguments

- cod:

  Vetor de codigos da COD, de quatro digitos.

## Value

Vetor numerico com o escore ISEI-BR, entre 10 e 90.

## See also

[`tse_para_isei_br()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei_br.md),
[isco08_isei_br](https://moraespeixoto.github.io/ocupacoesBR/reference/isco08_isei_br.md)

## Examples

``` r
cod_para_isei_br(c("2211", "9629"))
#> [1] 84.6 28.6
```
