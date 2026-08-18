# Verifica se o seu dado é atingido pela quebra de cadastro do TSE em 2002

O dicionário deste pacote adota o cadastro de ocupações vigente a partir
de 2002. Entre 2000 e 2002 o TSE reeditou essa tabela e **reutilizou
códigos** para ocupações diferentes, de modo que aplicar o dicionário a
candidaturas de 1998 e 2000 classifica essas ocupações erradas. Esta
função diz se, e quanto, o seu dado é atingido.

## Uso

``` r
checa_periodo(cod, ano, avisar = TRUE)
```

## Argumentos

- cod:

  Vetor de códigos de ocupação do TSE.

- ano:

  Vetor de anos de eleição, do mesmo comprimento de `cod`.

- avisar:

  Se `TRUE` (padrão), emite aviso quando há casos atingidos.

## Valor

Invisivelmente, um vetor lógico marcando as posições atingidas (código
reutilizado **e** ano até 2000).

## Como os casos foram identificados

Não por rótulo — o pacote não distribui os rótulos do TSE —, e sim pelo
dado. Para cada código presente nos dois períodos, comparou-se a
proporção de candidatos com ensino superior completo. A escolaridade
sobe ao longo de todo o período, então altas de 20 a 27 pontos são a
tendência geral. Uma queda de 60 a 85 pontos, não: a população sob o
código passou a ser outra. Ver
[tse_quebra_2002](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_quebra_2002.md).

## O que fazer

Para análises restritas a 2002 ou depois, nada — a quebra não a atinge.
Para séries que cruzam 2000/2002, o mínimo é excluir os códigos afetados
do período antigo; o correto é obter os rótulos de ocupação do TSE de
cada eleição e construir um dicionário com chave `(código, ano)`.

## Exemplos

``` r
checa_periodo(c("211", "211", "111"), c(2000, 2012, 2000))
#> Warning: 1 candidatura(s) até 2000 usam código(s) que o TSE reutilizou em 2002 (211). Elas estão classificadas pelo cadastro NOVO e portanto erradas; veja ?checa_periodo.
```
