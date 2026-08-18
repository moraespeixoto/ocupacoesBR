# Medidas ancoradas na ISCO-88

Medidas ancoradas na ISCO-88

## Uso

``` r
isco88_medidas
```

## Formato

`data.frame` com as colunas:

- isco88:

  código ISCO-88 de quatro dígitos, incluindo as formas arredondadas da
  hierarquia (2400 para o grande grupo 24).

- isei88:

  escore ISEI.

- siops88:

  escore de prestígio SIOPS, de Treiman.

- egp:

  classe EGP da tabela-base, **antes** das regras que dependem de
  posição na ocupação e supervisão. Não use esta coluna diretamente: use
  [`isco88_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_para_egp.md),
  que aplica as regras.

- rotulo:

  rótulo em inglês, quando a sintaxe original o traz.

## Fonte

Módulos `iskoisei.sps`, `iskotrei.sps`, `iskoroot.sps` e `iskolab.sps`
do International Stratification and Mobility File, de Harry B. G.
Ganzeboom e Donald J. Treiman.
<http://www.harryganzeboom.nl/ismf/index.htm>

## Exemplos

``` r
head(isco88_medidas)
#>   isco88 isei88 siops88 egp                                   rotulo
#> 1   0100     NA      NA  NA                                     <NA>
#> 2   0110     NA      NA  NA                           [armed forces]
#> 3   1000     55      51   1 legislators, senior officials & managers
#> 4   1100     70      67   1           legislators & senior officials
#> 5   1110     77      64   1                              legislators
#> 6   1120     77      71   1              senior government officials

# O ISEI e o prestígio ordenam parecido, mas não igual — e é na diferença
# que mora a escolha entre um e outro.
m <- isco88_medidas[stats::complete.cases(isco88_medidas[, c("isei88",
                                                             "siops88")]), ]
round(stats::cor(m$isei88, m$siops88, method = "spearman"), 3)
#> [1] 0.851
```
