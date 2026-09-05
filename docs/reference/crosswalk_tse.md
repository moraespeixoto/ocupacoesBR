# Tabela completa de tradução, do TSE a todas as medidas

Devolve, num único `data.frame`, tudo o que o pacote sabe sobre cada
código de ocupação do TSE. Serve para inspecionar a medida antes de
aplicá-la, para publicar como material suplementar de um artigo e para
auditar decisões de classificação uma a uma.

## Uso

``` r
crosswalk_tse(cod = NULL)
```

## Argumentos

- cod:

  Vetor opcional de códigos. Se omitido, devolve o dicionário inteiro.

## Valor

`data.frame` com o código do TSE, ISCO-88, ISCO-08, ISEI-88, ISEI-08,
SIOPS, EGP, classe, estrato, componente da classe alta e as marcas de
ocupação política e de proprietário.

## Exemplos

``` r
head(crosswalk_tse())
#>   cod_tse         rotulo isco88 isco08 isei88 isei08 isei_br siops88
#> 1      -4 NÃO DIVULGÁVEL   <NA>   <NA>     NA     NA      NA      NA
#> 2       0  NÃO INFORMADA   <NA>   <NA>     NA     NA      NA      NA
#> 3     101     ENGENHEIRO   2100   2100     69  79.49    71.8      63
#> 4     102      ARQUITETO   2100   2100     69  79.49    71.8      63
#> 5     103       AGRÔNOMO   2100   2100     69  79.49    71.8      63
#> 6     104        QUÍMICO   2100   2100     69  79.49    71.8      63
#>                                        egp                          classe
#> 1                                     <NA>                   Não informado
#> 2                                     <NA>                   Não informado
#> 3 I: dirigentes e profissionais superiores Profissionais de nível superior
#> 4 I: dirigentes e profissionais superiores Profissionais de nível superior
#> 5 I: dirigentes e profissionais superiores Profissionais de nível superior
#> 6 I: dirigentes e profissionais superiores Profissionais de nível superior
#>                       estrato  componente_alta politico proprietario nivel
#> 1 Fora da PEA / não informado             <NA>    FALSE        FALSE    NA
#> 2 Fora da PEA / não informado             <NA>    FALSE        FALSE    NA
#> 3                 Classe alta Alta credenciada    FALSE        FALSE     2
#> 4                 Classe alta Alta credenciada    FALSE        FALSE     2
#> 5                 Classe alta Alta credenciada    FALSE        FALSE     2
#> 6                 Classe alta Alta credenciada    FALSE        FALSE     2
#>   n_destinos_tse n_alt_08 qualidade
#> 1             NA       NA      <NA>
#> 2             NA       NA      <NA>
#> 3             20        1  agregada
#> 4             20        1  agregada
#> 5             20        1  agregada
#> 6             20        1  agregada
crosswalk_tse(c(111, 169, 257))
#>   cod_tse      rotulo isco88 isco08 isei88 isei08 isei_br siops88
#> 1     111      MÉDICO   2221   2210     88  88.70    87.7      78
#> 2     169 COMERCIANTE   1300   1400     51  51.01    58.0      50
#> 3     257  EMPRESARIO   1200   1200     68  72.94    72.0      60
#>                                        egp                          classe
#> 1 I: dirigentes e profissionais superiores Profissionais de nível superior
#> 2        IVb: conta própria sem empregados    Proprietários e empregadores
#> 3 I: dirigentes e profissionais superiores    Proprietários e empregadores
#>       estrato   componente_alta politico proprietario nivel n_destinos_tse
#> 1 Classe alta  Alta credenciada    FALSE        FALSE     4              1
#> 2 Classe alta Alta proprietária    FALSE         TRUE     2              6
#> 3 Classe alta Alta proprietária    FALSE         TRUE     2              3
#>   n_alt_08 qualidade
#> 1        2   ambígua
#> 2        1  agregada
#> 3        1  agregada
```
