# Verifica a cobertura de codigos da CBO-94

Equivalente de
[`checa_cobertura_cbo2002()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_cobertura_cbo2002.md)
para o microdado anterior a 2003.

## Uso

``` r
checa_cobertura_cbo94(cbo94, silencioso = FALSE)
```

## Argumentos

- cbo94:

  Vetor de codigos da CBO-94 observados no seu dado.

- silencioso:

  Se `TRUE`, nao escreve a mensagem de sucesso.

## Valor

Invisivelmente, `TRUE`.

## Exemplos

``` r
checa_cobertura_cbo94(c("2-11.20", "21130"))
#> cobertura CBO-94: 2 códigos, 2 com correspondência.
```
