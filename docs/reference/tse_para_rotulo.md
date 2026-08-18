# Rótulo da ocupação, como o TSE o escreveu

Rótulo da ocupação, como o TSE o escreveu

## Uso

``` r
tse_para_rotulo(cod, ano = NULL)
```

## Argumentos

- cod:

  Vetor de códigos de ocupação do TSE.

- ano:

  Vetor opcional de anos de eleição, do mesmo comprimento de `cod`. Com
  ele, devolve o rótulo vigente naquele ano; sem ele, o mais recente.

## Valor

Vetor de texto com o rótulo, ou `NA`.

## Exemplos

``` r
tse_para_rotulo(c(215, 215), c(2000, 2020))
#> [1] "OCUPANTE DE CARGO DE DIREÇÃO E ASSESSORAMENTO SUPERIOR"
#> [2] "ARTISTA PLÁSTICO E ASSEMELHADOS"                       
tse_para_rotulo(c(111, 169, 257))
#> [1] "MÉDICO"      "COMERCIANTE" "EMPRESARIO" 
```
