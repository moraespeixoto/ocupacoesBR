# ISEI-BR a partir da CBO-94

Versao para a RAIS anterior a 2003. Leia
[`tse_para_isei_br()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei_br.md)
para o que a regua e e o que ela nao e.

## Uso

``` r
cbo94_para_isei_br(cbo94)
```

## Argumentos

- cbo94:

  Vetor de codigos da CBO-94. Aceita "2-11.20" ou "21120".

## Valor

Vetor numerico com o escore ISEI-BR, entre 10 e 90.

## Veja também

[`tse_para_isei_br()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei_br.md),
[isco08_isei_br](https://moraespeixoto.github.io/ocupacoesBR/reference/isco08_isei_br.md)

## Exemplos

``` r
cbo94_para_isei_br("2-11.20")
#> [1] 72
```
