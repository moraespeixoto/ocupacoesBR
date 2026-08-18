# Em que eleições cada código esteve em vigor, e com que nome

Uma linha por **vigência**: um código que nunca mudou de nome tem uma;
um que mudou tem uma por período.

## Uso

``` r
tse_vigencia(cod = NULL)
```

## Argumentos

- cod:

  Vetor opcional de códigos. Se omitido, devolve a tabela inteira.

## Valor

`data.frame` com `cod_tse`, `de`, `ate`, `rotulo` e `n`.

## Exemplos

``` r
tse_vigencia(215)
#>   cod_tse   de  ate                                                 rotulo    n
#> 1     215 1998 2000 OCUPANTE DE CARGO DE DIREÇÃO E ASSESSORAMENTO SUPERIOR  534
#> 2     215 2006 2026                        ARTISTA PLÁSTICO E ASSEMELHADOS 1201
```
