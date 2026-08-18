# Classe EGP a partir da CBO-2002

Ao contrario do dado do TSE, o microdado que traz CBO costuma trazer
tambem posicao na ocupacao e supervisao — a RAIS e o eSocial identificam
vinculo, e varias pesquisas perguntam quantas pessoas o respondente
chefia. Quando esses campos existirem, passe-os: o EGP so sai completo
com eles.

## Uso

``` r
cbo2002_para_egp(
  cbo,
  conta_propria = NULL,
  n_supervisionados = NULL,
  n_classes = 11,
  rotulo = TRUE,
  avisar = TRUE
)
```

## Argumentos

- cbo:

  Vetor de codigos da CBO-2002, com 6 digitos (ocupacao) ou 4 (familia).
  Aceita "1111-05", "111105" ou 111105.

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
cbo2002_para_egp("521110", avisar = FALSE)
#> [1] "IIIb: vendas e serviços de baixa qualificação"
cbo2002_para_egp("521110", conta_propria = TRUE, n_supervisionados = 0)
#> [1] "IVb: conta própria sem empregados"
```
