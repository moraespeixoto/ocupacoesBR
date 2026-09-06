# Correspondência da CBO-94 com a ISCO-88

Para microdado anterior a 2003.

## Usage

``` r
cbo94_isco88
```

## Format

`data.frame` com as colunas:

- cbo94:

  código da CBO-94, sem pontuação.

- isco88:

  ISCO-88 correspondente.

## Source

Coluna CBO-94 da mesma tábua do Ministério do Trabalho.

## Sem agregação

A tábua do MTE é 1:1 entre CBO-94 e CBO-2002 — cada linha traz um par —,
de modo que não há maioria a apurar. Uma versão anterior desta tabela
trazia uma coluna `concordancia` que era constante 1 por construção e
sugeria um diagnóstico que não existia.

## Examples

``` r
head(cbo94_isco88)
#>   cbo94 isco88
#> 1 01105   2113
#> 2 01110   2113
#> 3 01210   2111
#> 4 01215   2111
#> 5 01230   2111
#> 6 01240   2111

# A CBO-94 chega à ISCO-88 e para aí no que toca a MEDIDAS: não há
# cbo94_para_isei08(), cbo94_para_prestigio08() nem cbo94_para_isei_br().
# A tradução de código existe (cbo94_para_isco08()); o que o pacote recusa é
# pendurar escore de 2008 ou de 2025 em microdado anterior a 2003.
nrow(cbo94_isco88)
#> [1] 1387
```
