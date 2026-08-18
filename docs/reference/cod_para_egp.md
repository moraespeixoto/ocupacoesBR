# Classe EGP a partir da COD

Ao contrario do TSE, a PNAD Continua **tem** posicao na ocupacao e
numero de empregados. Passe-os: e a diferenca entre um EGP completo e um
degradado.

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

## Exemplos

``` r
cod_para_egp("2211", avisar = FALSE)
#> [1] "I: dirigentes e profissionais superiores"
```
