# Rótulo da ocupação, como o TSE o escreveu

Rótulo da ocupação, como o TSE o escreveu

## Usage

``` r
tse_para_rotulo(cod, ano = NULL)
```

## Arguments

- cod:

  Vetor de códigos de ocupação do TSE.

- ano:

  Vetor opcional de anos de eleição, do mesmo comprimento de `cod`. Com
  ele, devolve o rótulo vigente naquele ano; sem ele, o mais recente.

## Value

Vetor de texto com o rotulo da ocupacao tal como o TSE o escreveu
naquele ano (ou o mais recente, se `ano` for omitido). Mesmo comprimento
e ordem do vetor de entrada; `NA` onde o codigo nao tem entrada no
cadastro de rotulos.

## Examples

``` r
tse_para_rotulo(c(215, 215), c(2000, 2020))
#> [1] "OCUPANTE DE CARGO DE DIREÇÃO E ASSESSORAMENTO SUPERIOR"
#> [2] "ARTISTA PLÁSTICO E ASSEMELHADOS"                       
tse_para_rotulo(c(111, 169, 257))
#> [1] "MÉDICO"      "COMERCIANTE" "EMPRESARIO" 
```
