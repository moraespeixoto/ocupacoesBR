# Traduz a CBO-2002 em ISCO-88

Converte o codigo da Classificacao Brasileira de Ocupacoes de 2002 — o
que aparece na RAIS, no CAGED e no eSocial — no codigo ISCO-88 de quatro
digitos, porta de entrada para o ISEI, o SIOPS e o EGP.

## Usage

``` r
cbo2002_para_isco(cbo, empate = c("na", "moda"), escada = FALSE)
```

## Arguments

- cbo:

  Vetor de codigos da CBO-2002, com 6 digitos (ocupacao) ou 4 (familia).
  Aceita "1111-05", "111105" ou 111105.

- empate:

  O que fazer quando a familia nao tem ISCO majoritario: `"na"` (padrao)
  devolve `NA`; `"moda"` devolve o vencedor do desempate por menor
  codigo, como nas versoes anteriores.

- escada:

  Se `TRUE`, sobe a hierarquia da CBO quando a ocupacao de seis digitos
  nao esta na tabua: tenta a familia de 4, depois o subgrupo de 3,
  depois o subgrupo principal de 2. Leva a cobertura do dominio oficial
  de **49,8% para 89,8%**. Padrao `FALSE`, porque o resultado deixa de
  ser a ocupacao declarada e passa a ser o seu grupo. Use
  [`crosswalk_cbo2002()`](https://moraespeixoto.github.io/ocupacoesBR/reference/crosswalk_cbo2002.md)
  para ver `nivel_usado` caso a caso.

## Value

Vetor de texto com o ISCO-88 de quatro digitos, ou `NA`.

## De onde vem a correspondencia

Da tabua oficial de conversao CBO2002–CBO94–CIUO88 do Ministerio do
Trabalho, consultada familia por familia. Nao e uma equivalencia
construida por nos.

## O que a fonte nao cobre

A tabua e, por construcao, uma conversao entre a CBO-2002 e a CBO-94: so
inclui as ocupacoes que existem nas duas. As ocupacoes criadas na
revisao de 2002 — e o grande grupo 0, das forcas armadas — nao tem
correspondencia oficial com a CIUO-88 e voltam `NA`. Isso e limite da
fonte, e a funcao prefere devolver `NA` a inventar um destino plausivel.

## Familia de quatro digitos

Muito microdado publica so a familia. Nesse caso o pacote devolve o ISCO
**majoritario** entre as ocupacoes da familia. Use
[`cbo2002_concordancia()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_concordancia.md)
para saber se a familia e homogenea antes de confiar no valor: uma
familia dividida ao meio nao deve ser tratada como uma posicao unica.

## A escada hierarquica

A tabua do MTE cobre metade da CBO-2002, e o buraco NAO e aleatorio: cai
sobre o que foi criado na revisao de 2002 — tecnologia da informacao em
peso, pesquisadores — e sobre todo o grande grupo 0. Um vinculo de RAIS
nesses codigos volta `NA`.

Com `escada = TRUE`, a funcao sobe a hierarquia da propria CBO ate achar
um nivel com correspondencia. Onde as ocupacoes mapeadas sob aquele
prefixo nao concordam num unico ISCO, usa-se o ancestral comum delas na
hierarquia da ISCO — que e a forma arredondada que o proprio ISMF
publica (2211 e 2212 viram 2210). Nao ha destino inventado: so se sobe
ate onde a fonte permite afirmar. Cobertura do dominio oficial (2.777
ocupacoes):

|                        |           |           |
|------------------------|-----------|-----------|
| nivel usado            | ocupacoes | acumulado |
| 6 (a ocupacao)         | 1.384     | 49,8%     |
| 4 (familia)            | 760       | 77,2%     |
| 3 (subgrupo)           | 306       | 88,2%     |
| 2 (subgrupo principal) | 44        | 89,8%     |
| sem rota               | 283       | —         |

**A escada para em dois digitos de proposito.** Descer a um fecharia o
buraco restante e cometeria exatamente a armadilha que este pacote
existe para impedir: o grande grupo 9 da CBO e reparacao e manutencao, o
da ISCO e ocupacoes elementares. As 283 ocupacoes sem rota — em peso o
bloco de diretores 12xx e as forcas armadas — nao tem correspondencia
oficial nenhuma, e continuam `NA`.

**A escada e a consulta por familia aplicam regras diferentes.** Entrar
com quatro digitos consulta `cbo2002_familia_isco88`, que traz a MODA
das ocupacoes da familia. Entrar com seis e `escada = TRUE` exige
ancestral comum na ISCO, e devolve `NA` quando ele nao existe acima do
primeiro digito. Em oito familias as duas respostas divergem —
`cbo2002_para_isco("1423")` da `"2419"`, e
`cbo2002_para_isco("142399", escada = TRUE)` da `NA` —, porque as
ocupacoes de 1423 se espalham por 1233, 1234, 1239 e 2419. A escada e a
mais conservadora das duas, e a divergencia e deliberada; quem alterna
entre as duas entradas precisa saber que elas nao respondem a mesma
pergunta. `tests/testthat/test-cbo.R` trava a lista das oito.

## Familias empatadas

Em 19 familias a moda NAO e maioria: duas ocupacoes dividem o topo. O
desempate anterior era mudo e ia sempre para o **menor** codigo ISCO —
consequencia da ordenacao lexicografica de
[`table()`](https://rdrr.io/r/base/table.html) —, e como a hierarquia da
ISCO e ordenada por status, o menor codigo tem o maior ISEI em 16 dos 19
casos. Isso e vies, nao ruido: nao desaparece com N.

Por isso `empate = "na"` e o padrao. Um empate 1:1 nao tem destino
majoritario, e devolver `NA` e mais honesto que escolher por ordem
alfabetica. Use `empate = "moda"` para reproduzir o comportamento
antigo.

## See also

[`cbo2002_para_isei()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_isei.md),
[`cbo2002_concordancia()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_concordancia.md),
[`cbo94_para_isco()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo94_para_isco.md)

## Examples

``` r
cbo2002_para_isco(c("1111-05", "225120", "5211"))
#> [1] "1110" "2221" "5220"
```
