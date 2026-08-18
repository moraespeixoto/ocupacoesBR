# Verifica a cobertura de codigos da COD

Verifica a cobertura de codigos da COD

## Uso

``` r
checa_cobertura_cod(cod, silencioso = FALSE)
```

## Argumentos

- cod:

  Vetor de codigos da COD observados no seu dado.

- silencioso:

  Se `TRUE`, nao escreve a mensagem de sucesso.

## Valor

Invisivelmente, `TRUE`.

## Exemplos

``` r
checa_cobertura_cod(c("2211", "0411"))
#> cobertura COD: 2 códigos, todos na tabela.
```
