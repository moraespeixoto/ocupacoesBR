# O que mudou no cadastro entre duas eleições

Devolve os códigos **extintos**, os **criados** e os que **trocaram de
rótulo** entre dois anos. É a função que falta a quem monta série longa:
a reutilização de código é o problema mais citado, mas o mais frequente
é a troca de inventário. Entre 2000 e 2002 o TSE aposentou 21 códigos,
criou 69 e renomeou 36.

## Uso

``` r
tse_diff_cadastro(ano1, ano2)
```

## Argumentos

- ano1, ano2:

  Anos de eleição a comparar.

## Valor

`data.frame` com `cod_tse`, `mudanca` (`extinto`, `criado` ou `rotulo`),
e os rótulos dos dois anos.

## O que conta como "em vigor"

A comparação usa a **vigência** registrada em
[tse_ocupacao_rotulos](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_ocupacao_rotulos.md),
não a presença de candidaturas naquela eleição específica. Um código que
existe no cadastro mas não teve candidato num ano continua em vigor — o
contrário faria uma ocupação rara "sumir e voltar" a cada eleição.

Por isso os números diferem de uma contagem por período. Comparando
*qualquer ano até 2000* com *qualquer ano a partir de 2002*, são 13
códigos extintos (12,4% das candidaturas do período antigo) e 122
criados (33,2% do novo). Comparando as eleições de 2000 e 2002 uma com a
outra, são 21 e 69. As duas leituras estão certas e respondem a
perguntas diferentes.

## Ausência não é revogação, e 2026 mostra isso

`tse_diff_cadastro(2024, 2026)` devolve 46 códigos como **extintos** e
nenhum criado. Os 46 não foram extintos. A vigência desta tabela se
constrói do rótulo **observado**, de modo que um código sem nenhum
candidato numa eleição registra ausência — e ausência é o que se espera
de um código raro quando a safra é pequena. A de 2026 é pequena duas
vezes: é geral, sem prefeito nem vereador, e está **aberta**, com o
Tribunal ainda julgando registros. Trocar de par não resolve:
`tse_diff_cadastro(2022, 2026)`, que compara duas gerais, devolve 47
extintos, e não menos.

A metade que se sustenta é a outra: **nenhum código criado**, nos dois
pares. Essa é robusta ao tamanho da safra, porque um código novo
apareceria ainda que uma vez só. Leia a contagem de extintos de uma
safra aberta como o que ela é — quem ainda não apareceu —, e refaça a
comparação quando o cadastro de 2026 fechar.

## Exemplos

``` r
d <- tse_diff_cadastro(2000, 2002)
table(d$mudanca)
#> 
#>  criado extinto  rotulo 
#>      69      21      36 
```
