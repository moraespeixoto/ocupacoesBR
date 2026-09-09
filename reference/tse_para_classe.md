# Classe social da ocupação declarada ao TSE

Esquema de doze categorias desenhado para o dado eleitoral brasileiro.
Não é o EGP: parte do ISCO como o EGP parte, mas trata como categorias
próprias duas situações que o registro eleitoral cria e que os esquemas
canônicos não preveem — proprietários e empregadores nomeados pelo
próprio código de ocupação, e o vínculo público declarado sem função
especificada. Para o EGP canônico, veja
[`tse_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_egp.md).

## Usage

``` r
tse_para_classe(cod, superior = NULL, ano = NULL)
```

## Arguments

- cod:

  Vetor de códigos de ocupação do TSE (numérico ou texto).

- superior:

  Vetor lógico opcional, do mesmo comprimento de `cod`, indicando ensino
  superior completo. Quando fornecido, a categoria residual "Vínculo
  público não especificado" — que sozinha reúne cerca de 9% das
  candidaturas, do faxineiro ao secretário de finanças — é dividida pela
  escolaridade declarada.

- ano:

  Vetor opcional de anos de eleição, do mesmo comprimento de `cod`. Com
  ele, as candidaturas cujo código o TSE **reutilizou** depois voltam
  `NA` com aviso, em vez de traduzidas pelo dicionário errado: o código
  215 designava um cargo de direção até 2000 e passou a designar artista
  plástico. Sem ele, o comportamento é o de sempre. Veja
  [`tse_vigencia()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_vigencia.md).

## Value

Vetor de texto com a classe.

## O agricultor, e por que ele não tem classe própria

Os códigos 601 (agricultor) e 604 (pescador) ficam em
`"Trabalhadores rurais"`, portanto nas classes populares, embora
[`tse_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_egp.md)
os classifique como `IVc: proprietário rural`. A aparente discordância
entre as duas medidas é **artefato de granularidade**, e o registro é
útil porque a classe própria chegou a ser criada, em 29/07/2026, e foi
revertida no mesmo dia.

O esquema relacional separa IVc de VIIb nas **onze** e nas **sete**
classes. Nos dois colapsos mais fortes de Erikson e Goldthorpe, o
agricultor e o assalariado rural voltam a ser a mesma coisa:

|             |                |                       |
|-------------|----------------|-----------------------|
| `n_classes` | 601 agricultor | 606 assalariado rural |
| 11          | IVc            | VIIb                  |
| 7           | IVc            | VIIb                  |
| 5           | IVc+VIIb       | IVc+VIIb              |
| 3           | Agrícolas      | Agrícolas             |

A linha de sete classes estava ausente desta tabela até 05/09/2026, e a
ausência importava: ela é o colapso mais usado para publicar, e nela a
distinção **sobrevive**. Comparar um esquema de onze classes com uma
partição em três estratos é comparar resoluções diferentes, não
encontrar divergência. Só nas resoluções equivalentes à do estrato o
próprio EGP funde os dois.

O dado externo concorda. O ISEI do agricultor, 23, está **dentro** da
faixa das classes populares, que vai de 16 a 43, e corresponde ao
percentil 5 do dicionário. O patrimônio mediano declarado, de R\$
122.395, fica dentro da faixa das classes populares, cujo máximo é R\$
126.801 – só um dos sessenta demais códigos do estrato declara mais: põe
o agricultor no topo da classe popular, não fora dela.

A distinção entre agricultura familiar e proletariado rural é real, e
continua disponível onde Erikson e Goldthorpe a puseram: em
`tse_para_egp(n_classes = 11)`. O que não se justifica é transportá-la
para a partição em estratos.

## Não há equivalente pela COD, e o motivo é do esquema

`cod_para_classe()` não existe, e não é omissão. Quatro das categorias
deste esquema — "Vínculo público não especificado", "Fora da PEA por
posição", "Inativo com trajetória" e "Não informado" — são **rubricas do
formulário do TSE**, e não posições da ISCO. Elas existem porque o
cadastro do Tribunal oferece à pessoa rótulos que *substituem* a
ocupação em vez de a nomear. A PNAD Contínua e o Censo não têm nada
disso: lá, vínculo e ocupação são perguntas separadas, e quem é servidor
público **também** declara a ocupação. Traduzir o esquema para a COD
exigiria inventar do lado da população categorias que só existem por
causa de um formulário.

A consequência prática é direta: **este esquema não atravessa para a
população**, e quem precisa comparar composição de classe entre as duas
fontes não tem régua pronta. O caminho é comparar pelo ISEI, que é
literalmente o mesmo construto dos dois lados, ou construir uma régua
própria declarando as categorias que só existem de um lado. O tamanho do
problema está medido em
[tse_universo](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_universo.md)
e o artigo *Comparar duas fontes* desenvolve as alternativas:
<https://moraespeixoto.github.io/ocupacoesBR/articles/comparar-fontes.html>

## Examples

``` r
tse_para_classe(c(111, 169, 291))
#> [1] "Profissionais de nível superior"  "Proprietários e empregadores"    
#> [3] "Vínculo público não especificado"
tse_para_classe(c(291, 291), superior = c(TRUE, FALSE))
#> [1] "Vínculo público, superior"       "Vínculo público, médio ou menos"
```
