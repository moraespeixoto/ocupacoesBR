# Critério externo para aferir a medida: patrimônio e escolaridade por ocupação

Agregado por ocupação de duas variáveis que o TSE coleta e que **não
entram na construção da medida em momento nenhum**: o patrimônio
declarado na candidatura e o grau de instrução. É contra ele que a
vinheta
[`vignette("validacao")`](https://moraespeixoto.github.io/ocupacoesBR/articles/validacao.md)
afere o ISEI.

## Usage

``` r
tse_validacao
```

## Format

`data.frame` com 220 linhas e as colunas:

- cod_tse:

  código de ocupação.

- n:

  candidaturas com esse código, 1998–2026.

- pct_superior:

  % com ensino superior completo.

- pct_mulher:

  % de mulheres.

- n_com_bens:

  candidaturas com patrimônio declarado maior que zero.

- mediana_patrimonio:

  mediana do patrimônio declarado, em reais. **`NA` onde
  `n_com_bens < 200`** — ver a seção sobre o piso.

## Source

Declaração de bens e grau de instrução das candidaturas ao TSE,
1998–2026 (patrimônio: 2006–2024; ver a seção acima).

## Por que agregado, e por que este piso

A unidade é a **ocupação**, não a candidatura, porque é nesse nível que
uma medida de posição ocupacional é definida, e porque um agregado de
220 linhas não é microdado, não identifica ninguém e pode viajar com o
pacote.

Entram ocupações com pelo menos 200 candidaturas. A mediana de
patrimônio exige um segundo piso, de 200 declarações de bens, porque
mediana apoiada em poucas declarações é ruidosa: sem ele a correlação
com o ISEI cai de 0,681 para cerca de 0,63, não porque a medida piore,
mas porque o critério externo fica instável. Este 0,63 é o único número
desta página que não se recalcula a partir do pacote — as medianas
abaixo do piso são `NA` aqui —, e sai de `data-raw/05_gera_validacao.R`.

**O segundo piso zera a mediana; não descarta a linha**, e a diferença
importa. Até 29/07/2026 ele descartava a linha inteira, o que amputava
do conjunto 44 ocupações cuja escolaridade e cuja composição por gênero
estão perfeitamente medidas e que apenas carecem de declarações de bens.
A consequência era que a regressão de gênero documentada em
[`tse_para_isei()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei.md)
não se reproduzia a partir do dado publicado. Hoje reproduz. Quem
correlacionar com patrimônio deve filtrar `!is.na(mediana_patrimonio)`;
quem usar escolaridade ou gênero tem as 220 linhas à disposição.

## Os códigos reutilizados entram só na vigência nova

Sete códigos foram reaproveitados para ocupação diferente depois de 2002
(veja
[tse_quebra_2002](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_quebra_2002.md)).
Até a auditoria de 05/09/2026 este conjunto os agregava sobre a série
inteira, de modo que `pct_superior` e `pct_mulher` misturavam duas
populações: o código 214 saía com 30,6% de ensino superior porque metade
da massa era DELEGADO DE POLÍCIA, quando ESCULTOR E PINTOR tem 2,3%; o
521 saía com 42,3% de mulheres onde a GOVERNANTA tem 97,2%. Hoje cada um
desses códigos entra apenas a partir do seu `primeiro_ano_novo`, que é o
mesmo corte que o argumento `ano =` das funções de tradução aplica. Um
deles deixou de alcançar o piso de 200 candidaturas dentro da própria
vigência e saiu do conjunto — por isso 220 linhas, e não 221.

O efeito sobre as correlações é imperceptível (a de escolaridade não se
move na terceira casa), porque são 7 códigos em 220 e cerca de 1.800
candidaturas em 3,37 milhões. A correção não é pelo tamanho: é porque
quem toma este conjunto como a tabela descritiva por ocupação — que é
para isso que ele é publicado — lia cinco linhas materialmente erradas.

## As correlações que este conjunto sustenta

Contra a escolaridade, sobre as 207 ocupações com ISEI: r = 0,765
(Spearman 0,816). Contra o logaritmo da mediana de patrimônio, sobre as
165 que também têm mediana: r = 0,681 (Spearman 0,695), ambas **não
ponderadas** — cada ocupação conta uma, que é o certo para aferir uma
régua de ocupações. No nível da **candidatura** a correlação com
patrimônio é de apenas 0,207, e o contraste é o resultado, não um
defeito. A comparação estritamente equivalente, na mesma unidade e com o
mesmo peso, é com a correlação ecológica de 0,748; veja
[tse_dispersao_patrimonio](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_dispersao_patrimonio.md).

## O patrimônio de 2026 não entra, e por quê

A safra de 2026 contribui para `n`, `pct_superior` e `pct_mulher`, e
**se abstém de `n_com_bens` e da mediana de patrimônio**. A razão é de
unidade, não de qualidade do dado: o patrimônio está deflacionado a
reais de outubro de 2024, pelo número-índice do IPCA do mês da eleição,
e outubro de 2026 ainda não aconteceu. Deflacionar por um mês que não é
o da eleição poria na coluna um valor que a definição da coluna
desmente.

A assimetria não é nova: `n` sempre cobriu um período mais largo do que
`n_com_bens`, porque o TSE só publica declaração de bens a partir de
2006 e as candidaturas de 1998 a 2004 já entravam nessa mesma condição.
Quando o IPCA de outubro de 2026 existir, a coluna sai de graça.

## Examples

``` r
# As ocupações com mais candidaturas no conjunto de validação:
head(tse_validacao[order(-tse_validacao$n), ], 5)
#>     cod_tse      n pct_superior pct_mulher n_com_bens mediana_patrimonio
#> 220     999 567077         11.2       30.5     219874              77633
#> 188     601 292752          2.5       15.3     132163             122395
#> 139     298 212709         22.8       33.2     113178              91866
#> 57      169 204675          7.1       19.6     105777             148044
#> 121     257 152409         22.9       19.0     109395             249001

# A correlação que sustenta a medida: o ISEI atribuído por tradução contra
# a escolaridade declarada, que o pacote nunca viu ao construir a régua.
v <- tse_validacao
v$isei <- suppressWarnings(tse_para_isei(v$cod_tse))
round(stats::cor(v$isei, v$pct_superior, use = "complete.obs"), 3)
#> [1] 0.765
```
