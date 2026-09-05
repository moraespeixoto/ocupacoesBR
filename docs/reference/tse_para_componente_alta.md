# Partição da classe alta em proprietária, credenciada e dirigente

Separa a classe alta nas duas espécies de recurso que a compõem — o
capital e a credencial — além das ocupações propriamente políticas.
Devolve `NA` fora da classe alta.

## Uso

``` r
tse_para_componente_alta(cod, ano = NULL)
```

## Argumentos

- cod:

  Vetor de códigos de ocupação do TSE (numérico ou texto).

- ano:

  Vetor opcional de anos de eleição, do mesmo comprimento de `cod`. Com
  ele, as candidaturas cujo código o TSE **reutilizou** depois voltam
  `NA` com aviso, em vez de traduzidas pelo dicionário errado: o código
  215 designava um cargo de direção até 2000 e passou a designar artista
  plástico. Sem ele, o comportamento é o de sempre. Veja
  [`tse_vigencia()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_vigencia.md).

## Valor

Vetor de texto, ou `NA` fora da classe alta.

## As duas metades não têm a mesma confiabilidade

A partição é simétrica no desenho e **assimétrica na medição**, e quem
publica o contraste precisa dizê-lo.

A **alta credenciada** é ancorada em registro externo. "Advogado" não é
autodescrição: pressupõe inscrição na OAB. Por isso o rótulo se comporta
de modo estável — entre os que declaram o código 131, a proporção com
ensino superior varia pouco mais de um ponto entre vereador e presidente
(98,6% a 100%).

A **alta proprietária** não tem âncora nenhuma. "Empresário" (código
257) é autodeclaração: nenhum registro precisa existir para que alguém
se descreva assim. E o mesmo rótulo cobre posições materialmente
incomparáveis — entre os que declaram 257, o patrimônio mediano varia
por um fator de **25** conforme o cargo disputado:

|          |                                        |
|----------|----------------------------------------|
| cargo    | patrimônio mediano de quem declara 257 |
| Vereador | R\$ 185.000                            |
| Prefeito | R\$ 812.544                            |
| Senador  | R\$ 4.678.498                          |

Tudo isso sob um **único** ISEI (68) e uma única classe. Dentro do
código, os extremos de patrimônio distam 76 vezes (p10 R\$ 19,8 mil, p90
R\$ 1,50 milhão). A tabela acima e esses dois quantis saem de
[tse_autorrotulo_patrimonio](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_autorrotulo_patrimonio.md),
e não estão digitados aqui — a versão anterior deles estava, e
sobreviveu errada à correção do patrimônio de 09/2026.

O 257 não é uma ocupação medida com erro: é uma **mistura** de duas
populações — o microempreendedor e o capitalista — sob um rótulo só.
Nenhum escore único está certo para as duas, razão pela qual mudá-lo de
valor não resolve (veja
[tse_codigos_autorrotulo](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_codigos_autorrotulo.md)).

Consequência: um gráfico que compare os dois componentes está comparando
uma quantidade ancorada em registro externo a uma quantidade
autodeclarada que agrega posições muito distantes. Teoricamente a
partição é boa (é Bourdieu e Wright operacionalizados), mas Wright
insistia em *employment relations*, não em rótulos.

**O que o dado NÃO mostra**, e vale dizer para que ninguém repita: não
há evidência de que as pessoas troquem de rótulo conforme o cargo. A
frequência do 257 não cresce com a importância do posto — tem pico em
prefeito (10,6%) e cai em senador (7,2%) e governador (6,9%). Quem
cresce monotonicamente é "advogado" (1,6% a 14,8%), que é o caso
ancorado, e "comerciante" **cai** de 6,2% a 0%. O gradiente de
patrimônio acima é consistente tanto com recrutamento seletivo quanto
com relabeling, e estes dados não separam as duas hipóteses.

Se a sua conclusão depende do tamanho relativo dos dois componentes,
rode-a também sem
[tse_codigos_autorrotulo](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_codigos_autorrotulo.md)
e relate as duas versões.

## Exemplos

``` r
tse_para_componente_alta(c(257, 111, 274, 411))
#> [1] "Alta proprietária"      "Alta credenciada"       "Dirigentes e políticos"
#> [4] NA                      
```
