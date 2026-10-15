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

Invisivelmente, `TRUE`, se todo codigo observado tem entrada na tabela.
O valor em si nao carrega informacao alem de confirmar que nao houve
erro: a funcao para com [`stop()`](https://rdrr.io/r/base/stop.html),
nomeando os codigos sem entrada, quando a cobertura falha, e a mensagem
de sucesso (a menos que `silencioso = TRUE`) e' o efeito colateral que
interessa.

## Examples

``` r
checa_cobertura_cod(c("2211", "0411"))
#> cobertura COD: 2 códigos, todos na tabela.
```
