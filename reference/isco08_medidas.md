# Medidas ancoradas na ISCO-08

Medidas ancoradas na ISCO-08

## Usage

``` r
isco08_medidas
```

## Format

`data.frame` com as colunas:

- isco08:

  código ISCO-08 de quatro dígitos.

- isei08:

  escore ISEI-08, contínuo.

- siops08:

  escore SIOPS-08, contínuo.

## Source

Módulos `isqoisei08.sps` e `isqotrei08.sps` do International
Stratification and Mobility File.
<http://www.harryganzeboom.nl/ismf/index.htm>

## Examples

``` r
head(isco08_medidas)
#>   isco08 isei08 siops08
#> 1   0000  51.25   42.88
#> 2   0100  60.92   48.68
#> 3   0110  60.92   48.68
#> 4   0200  51.63   39.00
#> 5   0210  51.63   39.00
#> 6   0300  29.18   43.23

# A âncora é outra: um escore da ISCO-08 não é comparável com um da
# ISCO-88, e misturar as duas numa mesma série é o erro mais comum.
nrow(isco08_medidas)
#> [1] 590
summary(isco08_medidas$isei08)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>   11.01   25.73   43.19   45.43   64.43   88.96 

# Estes escores foram estimados fora do Brasil. Para a régua estimada em
# dado brasileiro, com o mesmo método, veja [isco08_isei_br].
```
