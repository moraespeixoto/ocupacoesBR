# Classe EGP a partir da COD

A PNAD Continua tem posicao na ocupacao (V4012) e o numero de empregados
do empregador, o que recupera a pequena burguesia e **separa IVa de
IVb** — a distincao que pela porta do TSE fica indeterminada. Passe-os.

## Uso

``` r
cod_para_egp(
  cod,
  conta_propria = NULL,
  n_supervisionados = NULL,
  n_classes = 11,
  rotulo = TRUE,
  avisar = TRUE
)
```

## Argumentos

- cod:

  Vetor de codigos da COD, de quatro digitos.

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

## Detalhes

O que ela nao tem e a supervisao exercida sobre assalariados, que e o
que define V (supervisores manuais) e governa as promocoes entre I e II.
Por essa porta o EGP fica mais completo que pelas outras, mas nao
completo.

## Exemplos

``` r
cod_para_egp("2211", avisar = FALSE)
#> [1] "I: dirigentes e profissionais superiores"
```
