# Ponte da ISCO-08 de volta para a ISCO-88

Ponte da ISCO-08 de volta para a ISCO-88

## Usage

``` r
isco08_isco88
```

## Format

`data.frame` com 590 linhas:

- isco08:

  código de origem.

- isco88:

  código de destino na revisão de 1988.

## Source

Módulo `isco0888.sps` do International Stratification and Mobility File.
<http://www.harryganzeboom.nl/ismf/index.htm>

## A ida e a volta não se cancelam

Levar um código da ISCO-88 à ISCO-08 por
[`isco88_para_isco08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_para_isco08.md)
e trazê-lo de volta por
[`isco08_para_isco88()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco08_para_isco88.md)
devolve o ponto de partida em **69% dos casos**. O terço restante não é
defeito: a OIT reparte e funde categorias entre as revisões, e a
composição das duas concordâncias não é a identidade.

Esta tabela é o que destrava o EGP e o ISEI-88 para quem entra pela COD
— a PNAD Contínua e o Censo aterrissam na ISCO-08, e todo o esquema de
classes do pacote está ancorado na ISCO-88.

## Examples

``` r
head(isco08_isco88)
#>   isco08 isco88
#> 1   0100   0110
#> 2   0110   0110
#> 3   0200   0110
#> 4   0210   0110
#> 5   0300   0110
#> 6   0310   0110

# É esta tábua que permite entrar pela PNAD ou pelo Censo e chegar às
# medidas ancoradas na ISCO-88.
nrow(isco08_isco88)
#> [1] 590
```
