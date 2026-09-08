# Classe EGP a partir da CBO-94

Leia
[`isco88_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_para_egp.md)
antes de usar: sem posicao no emprego e supervisao, o esquema sai
degradado. A RAIS **nao** tem essas variaveis: e um registro de vinculo
empregaticio, em que toda linha e um empregado. Por essa porta o EGP sai
sem IVa, IVb e V por construcao. Veja
[`cbo2002_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_egp.md).

## Uso

``` r
cbo94_para_egp(
  cbo94,
  conta_propria = NULL,
  n_supervisionados = NULL,
  n_classes = 11,
  rotulo = TRUE,
  avisar = TRUE
)
```

## Argumentos

- cbo94:

  Vetor de codigos da CBO-94. Aceita "2-11.20" ou "21120".

- conta_propria:

  Vetor lógico opcional: a pessoa trabalha por conta própria ou é
  empregadora (`TRUE`) ou é empregada (`FALSE`).

- n_supervisionados:

  Vetor numérico opcional com o número de pessoas supervisionadas.

- n_classes:

  Número de classes do resultado: 11 (padrão), 7, 5 ou 3.

- rotulo:

  Se `TRUE` (padrão), devolve rótulos — em todas as versões, inclusive
  nas colapsadas; se `FALSE`, os códigos inteiros.

- avisar:

  Se `TRUE` (padrão), avisa quando `conta_propria` ou
  `n_supervisionados` não são fornecidos.

## Valor

Vetor de texto (ou inteiro, se `rotulo = FALSE`).

## Exemplos

``` r
cbo94_para_egp("2-11.20", avisar = FALSE)
#> [1] "I: dirigentes e profissionais superiores"
```
