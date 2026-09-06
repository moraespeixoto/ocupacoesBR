# Estrato social da ocupação declarada ao TSE

Agrega as classes de
[`tse_para_classe()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_classe.md)
em classe alta, classe média e classes populares, mantendo à parte as
duas categorias residuais (vínculo público sem função e fora da PEA),
que não são estratos e não devem ser silenciosamente somadas a nenhum
deles.

## Usage

``` r
tse_para_estrato(cod, ano = NULL)
```

## Arguments

- cod:

  Vetor de códigos de ocupação do TSE (numérico ou texto).

- ano:

  Vetor opcional de anos de eleição, do mesmo comprimento de `cod`. Com
  ele, as candidaturas cujo código o TSE **reutilizou** depois voltam
  `NA` com aviso, em vez de traduzidas pelo dicionário errado: o código
  215 designava um cargo de direção até 2000 e passou a designar artista
  plástico. Sem ele, o comportamento é o de sempre. Veja
  [`tse_vigencia()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_vigencia.md).

## Value

Vetor de texto com o estrato.

## O estrato e o ISEI se cruzam por desenho

O estrato é uma régua de **posição** — de onde vem o sustento: de um
diploma, de um patrimônio, de um salário, da terra. O ISEI
([`tse_para_isei()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei.md))
é uma régua de **status**, que ordena ocupações pela eficiência com que
convertem escolaridade em renda. Que discordem em alguns pontos não é
defeito: é a razão de haver duas. Um esquema de classes que apenas
reordenasse o ISEI em fatias seria redundante, e a distinção entre
classe e status é justamente o que Weber propôs e Goldthorpe endureceu.

Medidas sobre os 258 códigos do dicionário, as duas réguas concordam
quase inteiramente — os intervalos interquartis não se tocam:

|                   |     |     |         |     |
|-------------------|-----|-----|---------|-----|
| estrato           | n   | mín | mediana | máx |
| Classe alta       | 88  | 43  | 68      | 90  |
| Classe média      | 69  | 45  | 50      | 55  |
| Classes populares | 101 | 16  | 33      | 43  |

Nenhum código de classe média tem ISEI acima da mediana da classe alta.
Quatro dos 88 códigos de classe alta ficam abaixo da mediana da classe
média, e cada um tem explicação própria:

- **113 (enfermeiro), ISEI 43** — é a anomalia de gênero da própria
  escala, documentada em
  [`tse_para_isei()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei.md):
  enfermagem recebe menos que o técnico de enfermagem (48) e que o
  escriturário (45). Aqui é o ISEI que erra, não a classe. Enfermagem é
  bacharelado regulado, e a própria ISCO-88 a põe no grande grupo 2.

- **234, 602 e 901 (produtor agropecuário, pecuarista, proprietário
  agrícola), ISEI 43** — são classe alta por propriedade, com status
  baixo. É exatamente o contraste que
  [`tse_para_componente_alta()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_componente_alta.md)
  existe para exibir: capital econômico e capital cultural não se
  acompanham.

A leitura prática: uma discordância entre as duas réguas é achado a
interpretar, não erro a corrigir. Quem publicar as duas no mesmo gráfico
precisa dizer qual pergunta cada uma responde — veja
[`vignette("qual-regua")`](https://moraespeixoto.github.io/ocupacoesBR/articles/qual-regua.md).

## Examples

``` r
tse_para_estrato(c(111, 169, 291, 931))
#> [1] "Classe alta"                      "Classe alta"                     
#> [3] "Vínculo público não especificado" "Fora da PEA / não informado"     
```
