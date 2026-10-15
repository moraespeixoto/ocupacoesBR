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

Invisivelmente, `TRUE`, se todo codigo observado tem entrada na tabela.
O valor em si nao carrega informacao alem de confirmar que nao houve
erro: a funcao para com [`stop()`](https://rdrr.io/r/base/stop.html),
nomeando os codigos sem entrada, quando a cobertura falha, e a mensagem
de sucesso (a menos que `silencioso = TRUE`) e' o efeito colateral que
interessa.

## Examples

``` r
checa_cobertura_cbo94(c("2-11.20", "21130"))
#> cobertura CBO-94: 2 códigos, 2 com correspondência.
```
