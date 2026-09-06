# Converte ISCO-08 em ISCO-88

A ponte de volta, do modulo `isco0888.sps` do ISMF.

## Usage

``` r
isco08_para_isco88(isco08)
```

## Arguments

- isco08:

  Vetor de codigos ISCO-08.

## Value

Vetor de texto com o ISCO-88.

## A ida e a volta nao se cancelam

Levar um codigo da ISCO-88 a ISCO-08 e traze-lo de volta devolve o ponto
de partida em apenas **69% dos casos**. Isso nao e defeito de
implementacao: e propriedade da concordancia da Organizacao
Internacional do Trabalho, que reparte e funde categorias entre as duas
revisoes. Um terco dos codigos nao tem volta ao mesmo lugar, e quem
encadeia as duas pontes precisa saber disso.

## Examples

``` r
isco08_para_isco88(c("2211", "5412"))
#> [1] "2221" "5162"
```
