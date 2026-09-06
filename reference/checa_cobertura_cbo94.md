# Verifica a cobertura de codigos da CBO-94

Equivalente de
[`checa_cobertura_cbo2002()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_cobertura_cbo2002.md)
para o microdado anterior a 2003.

## Usage

``` r
checa_cobertura_cbo94(cbo94, silencioso = FALSE)
```

## Arguments

- cbo94:

  Vetor de codigos da CBO-94 observados no seu dado.

- silencioso:

  Se `TRUE`, nao escreve a mensagem de sucesso.

## Value

Invisivelmente, `TRUE`.

## Examples

``` r
checa_cobertura_cbo94(c("2-11.20", "21130"))
#> cobertura CBO-94: 2 códigos, 2 com correspondência.
```
