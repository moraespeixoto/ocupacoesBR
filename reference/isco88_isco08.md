# Ponte da ISCO-88 para a ISCO-08

Ponte da ISCO-88 para a ISCO-08

## Usage

``` r
isco88_isco08
```

## Format

`data.frame` com as colunas:

- isco88:

  código de origem.

- isco08:

  código de destino, já truncado como manda a sintaxe.

- n_alternativas:

  quantos destinos a Organização Internacional do Trabalho define para
  esse código de origem. Vale 1 quando a conversão é unívoca; acima
  disso, a tradução é uma escolha entre alternativas, e convém dizê-lo
  ao leitor.

## Source

Módulo `isco8808.sps` do International Stratification and Mobility File.
<http://www.harryganzeboom.nl/ismf/index.htm>

## Examples

``` r
head(isco88_isco08)
#>   isco88 isco08 n_alternativas
#> 1   0100   0300              3
#> 2   0110   0300              3
#> 3   1250   0100              1
#> 4   3452   0200              2
#> 5   1000   1000              1
#> 6   1100   1110              1

# A ponte não é uma bijeção: 186 dos 530 códigos têm mais de um destino
# possível na ISCO-08, e a tábua escolhe um deles.
table(isco88_isco08$n_alternativas > 1)
#> 
#> FALSE  TRUE 
#>   344   186 

# Peça a marca junto com a tradução quando a ambiguidade importar:
isco88_para_isco08("1229", com_ambiguidade = TRUE)
#>   isco88 isco08 n_alternativas
#> 1   1229   1300              9
```
