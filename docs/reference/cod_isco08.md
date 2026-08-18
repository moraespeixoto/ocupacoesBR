# Correspondência da COD do IBGE com a ISCO-08

A Classificação de Ocupações para Pesquisas Domiciliares é a da PNAD
Contínua e do Censo Demográfico.

## Uso

``` r
cod_isco08
```

## Formato

`data.frame` com 434 linhas:

- cod:

  grupo de base da COD, quatro dígitos.

- titulo:

  denominação oficial.

- isco08:

  código ISCO-08 correspondente.

- correspondencia:

  `identidade` (428 casos), `adaptacao` (5) ou `agregacao` (1).

## Fonte

Estrutura da Ocupação (COD), IBGE, distribuída em
`inst/extdata/fontes/Estrutura_Ocupacao_COD.xls`.

## Por que quase tudo é identidade

A COD é construída **sobre** a ISCO-08. Não há tábua de conversão a
consultar: 428 dos 434 grupos de base são o próprio código
internacional. O que resta são seis adaptações brasileiras, documentadas
uma a uma em
[`cod_para_isco08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cod_para_isco08.md)
— polícia e bombeiro militar, trabalhadores do sexo e pescadores.

O contraste com a perna da CBO é de desenho, não de esforço: aquela
depende de uma tábua do Ministério do Trabalho que cobre metade do seu
universo; esta cobre 100% do seu.

## Exemplos

``` r
head(cod_isco08)
#>    cod                                   titulo isco08 correspondencia
#> 1 0110              Oficiais das forças armadas   0110      identidade
#> 2 0210    Graduados e praças das forças armadas   0210      identidade
#> 3 0411              Oficiais de polícia militar   5412       adaptacao
#> 4 0412    Graduados e praças da polícia militar   5412       adaptacao
#> 5 0511             Oficiais de bombeiro militar   5411       adaptacao
#> 6 0512 Graduados e praças do corpo de bombeiros   5411       adaptacao

# Quase tudo é identidade — a COD do IBGE é a ISCO-08 com outro nome. As
# poucas exceções são onde vale olhar antes de confiar.
table(cod_isco08$correspondencia)
#> 
#>  adaptacao  agregacao identidade 
#>          5          1        428 
cod_isco08[cod_isco08$correspondencia != "identidade", ]
#>      cod                                   titulo isco08 correspondencia
#> 3   0411              Oficiais de polícia militar   5412       adaptacao
#> 4   0412    Graduados e praças da polícia militar   5412       adaptacao
#> 5   0511             Oficiais de bombeiro militar   5411       adaptacao
#> 6   0512 Graduados e praças do corpo de bombeiros   5411       adaptacao
#> 259 5168                    Trabalhadores do sexo   5169       adaptacao
#> 295 6225                               Pescadores   6220       agregacao
```
