# Verifica a cobertura de codigos da COD

Verifica a cobertura de codigos da COD

## Usage

``` r
checa_cobertura_cod(cod, silencioso = FALSE)
```

## Arguments

- cod:

  Vetor de codigos da COD observados no seu dado.

- silencioso:

  Se `TRUE`, nao escreve a mensagem de sucesso.

## Value

Invisivelmente, `TRUE`.

## Examples

``` r
checa_cobertura_cod(c("2211", "0411"))
#> cobertura COD: 2 códigos, todos na tabela.
```
