# Classe EGP da ocupação declarada ao TSE

Atalho de
[`tse_para_isco()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isco.md)
seguido de
[`isco88_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_para_egp.md).
Leia
[`isco88_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_para_egp.md)
antes de usar: partindo só do TSE, o EGP sai incompleto, porque o
formulário não pergunta supervisão.

## Uso

``` r
tse_para_egp(
  cod,
  conta_propria = NULL,
  n_supervisionados = NULL,
  n_classes = 11,
  rotulo = TRUE,
  avisar = TRUE,
  usa_proprietario = TRUE,
  ano = NULL
)
```

## Argumentos

- cod:

  Vetor de códigos de ocupação do TSE (numérico ou texto).

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

- usa_proprietario:

  Se `TRUE` (padrão) e `conta_propria` não for informado, usa a marca
  `proprietario` do dicionário como posição no emprego. Informar
  `conta_propria` explicitamente tem precedência.

- ano:

  Vetor opcional de anos de eleição, do mesmo comprimento de `cod`. Com
  ele, as candidaturas cujo código o TSE **reutilizou** depois voltam
  `NA` com aviso, em vez de traduzidas pelo dicionário errado: o código
  215 designava um cargo de direção até 2000 e passou a designar artista
  plástico. Sem ele, o comportamento é o de sempre. Veja
  [`tse_vigencia()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_vigencia.md).

## Valor

Vetor de texto (ou inteiro, se `rotulo = FALSE`).

## A posição no emprego que o dicionário conhece

O TSE não pergunta posição na ocupação, mas alguns dos seus códigos
**nomeiam** no próprio rótulo quem trabalha por conta própria —
comerciante, empresário, pecuarista, proprietário de estabelecimento, e
também o agricultor e o pescador. O dicionário marca essa condição em
`tse_isco$conta_propria`, e é ela, não `proprietario`, que corresponde
ao `SEMPL = 2` das sintaxes do ISMF. As duas marcas são distintas desde
07/2026: `proprietario` é o subconjunto que pertence à classe
proprietária, e o agricultor (601) e o pescador (604) estão fora dele
sem deixarem de trabalhar por conta própria. Enquanto eram uma coisa só,
os dois caíam em VIIb, o fundo do esquema, ao lado do assalariado rural.

Por padrão (`usa_proprietario = TRUE` — o nome do argumento é anterior à
separação das duas marcas e foi mantido por compatibilidade) a função a
utiliza. São doze os códigos marcados, e sete deles mudam de classe por
causa dela. Cinco — 169, 902, 903, 904 e 905 — sairiam em II, a classe
de serviço assalariada, o que é uma inversão: a pequena burguesia
contada como classe de serviço. Os outros dois — 601 e 604 — sairiam em
VIIb, ao lado do assalariado rural.

O que **continua** indeterminado é a divisão entre IVa (conta própria
com empregados) e IVb (sem), que exige o número de subordinados. Todos
caem em IVb. Para publicar, prefira `n_classes = 7` ou `5`, onde as duas
se fundem em IVab.

## Exemplos

``` r
# 169 é COMERCIANTE: pequena burguesia, não classe de serviço
tse_para_egp(c(111, 169, 601), avisar = FALSE)
#> [1] "I: dirigentes e profissionais superiores"
#> [2] "IVb: conta própria sem empregados"       
#> [3] "IVc: proprietário rural"                 
tse_para_egp(169, usa_proprietario = FALSE, avisar = FALSE)
#> [1] "II: dirigentes e profissionais inferiores"
```
