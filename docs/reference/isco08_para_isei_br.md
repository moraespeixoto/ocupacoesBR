# ISEI-BR a partir da ISCO-08

Entrada direta para quem ja tem o codigo internacional. Leia
[`tse_para_isei_br()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei_br.md)
para o que a regua e e o que ela nao e.

## Uso

``` r
isco08_para_isei_br(isco08)
```

## Argumentos

- isco08:

  Vetor de codigos ISCO-08.

## Valor

Vetor numerico com o escore ISEI-BR, entre 10 e 90.

## Veja também

[`tse_para_isei_br()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei_br.md),
[isco08_isei_br](https://moraespeixoto.github.io/ocupacoesBR/reference/isco08_isei_br.md)

## Exemplos

``` r
isco08_para_isei_br(c("2211", "5411"))
#> [1] 84.6 62.9
```
