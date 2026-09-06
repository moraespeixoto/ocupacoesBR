# Correspondência da CBO-2002 com a ISCO-88, por ocupação

Correspondência da CBO-2002 com a ISCO-88, por ocupação

## Usage

``` r
cbo2002_isco88
```

## Format

`data.frame` com as colunas:

- cbo2002:

  código de seis dígitos, sem hífen, como nos microdados.

- titulo:

  título da ocupação na CBO-2002.

- familia:

  os quatro primeiros dígitos.

- cbo94:

  código correspondente na CBO-94, sem pontuação.

- isco88:

  código ISCO-88 de quatro dígitos.

## Source

Tábua de conversão CBO2002–CBO94–CIUO88 do Ministério do Trabalho,
consultada família a família em
<http://www.mtecbo.gov.br/cbosite/pages/tabua/FiltroConversao_CBO2002_CBO94_CIUO88.jsf>

## Cobertura

A tábua do Ministério do Trabalho é uma conversão entre a CBO-2002 e a
CBO-94, de modo que cobre apenas as ocupações presentes nas duas
classificações. As ocupações criadas na revisão de 2002 e o grande grupo
0 (forças armadas) não têm correspondência oficial com a CIUO-88 e não
aparecem aqui.

## Examples

``` r
# A tradução ocupação a ocupação, o caminho mais curto e mais confiável:
cbo2002_isco88[cbo2002_isco88$cbo2002 == "252105", ]
#>     cbo2002        titulo familia cbo94 isco88
#> 243  252105 Administrador    2521 09220   2419

# Quantas ocupações a tábua do MTE cobre, e quantos ISCO distintos alcança:
nrow(cbo2002_isco88)
#> [1] 1387
length(unique(stats::na.omit(cbo2002_isco88$isco88)))
#> [1] 296
```
