# Critério externo para aferir a medida: patrimônio e escolaridade por ocupação

Agregado por ocupação de duas variáveis que o TSE coleta e que **não
entram na construção da medida em momento nenhum**: o patrimônio
declarado na candidatura e o grau de instrução. É contra ele que a
vinheta
[`vignette("validacao")`](https://moraespeixoto.github.io/ocupacoesBR/articles/validacao.md)
afere o ISEI.

## Uso

``` r
tse_validacao
```

## Formato

`data.frame` com 221 linhas e as colunas:

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

## Fonte

Declaração de bens e grau de instrução das candidaturas ao TSE,
1998–2026 (patrimônio: 2006–2024; ver a seção acima).

## Por que agregado, e por que este piso

A unidade é a **ocupação**, não a candidatura, porque é nesse nível que
uma medida de posição ocupacional é definida, e porque um agregado de
221 linhas não é microdado, não identifica ninguém e pode viajar com o
pacote.

Entram ocupações com pelo menos 200 candidaturas. A mediana de
patrimônio exige um segundo piso, de 200 declarações de bens, porque
mediana apoiada em poucas declarações é ruidosa: sem ele a correlação
com o ISEI cai de 0,682 para cerca de 0,63, não porque a medida piore,
mas porque o critério externo fica instável.

**O segundo piso zera a mediana; não descarta a linha**, e a diferença
importa. Até 29/07/2026 ele descartava a linha inteira, o que amputava
do conjunto 46 ocupações cuja escolaridade e cuja composição por gênero
estão perfeitamente medidas e que apenas carecem de declarações de bens.
A consequência era que a regressão de gênero documentada em
[`tse_para_isei()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei.md)
não se reproduzia a partir do dado publicado. Hoje reproduz. Quem
correlacionar com patrimônio deve filtrar `!is.na(mediana_patrimonio)`;
quem usar escolaridade ou gênero tem as 221 linhas à disposição.

## As correlações que este conjunto sustenta

Contra a escolaridade, sobre as 208 ocupações com ISEI: r = 0,765
(Spearman 0,812). Contra o logaritmo da mediana de patrimônio, sobre as
165 que também têm mediana: r = 0,681 (Spearman 0,695). No nível do
**indivíduo** a correlação com patrimônio é de apenas 0,208, e o
contraste entre 0,208 e 0,681 é o resultado, não um defeito: o ISEI
explica a variação entre ocupações e quase nada dentro de cada uma.

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

## Exemplos

``` r
# As ocupações com mais candidaturas no conjunto de validação:
head(tse_validacao[order(-tse_validacao$n), ], 5)
#>     cod_tse      n pct_superior pct_mulher n_com_bens mediana_patrimonio
#> 221     999 565549         11.2       30.6     219876             155267
#> 189     601 290797          2.5       15.4     132134             244790
#> 139     298 212328         22.8       33.3     113152             183732
#> 57      169 204892          7.1       19.6     105795             296088
#> 121     257 152505         22.9       19.0     109346             497797

# A correlação que sustenta a medida: o ISEI atribuído por tradução contra
# a escolaridade declarada, que o pacote nunca viu ao construir a régua.
v <- tse_validacao
v$isei <- suppressWarnings(tse_para_isei(v$cod_tse))
round(stats::cor(v$isei, v$pct_superior, use = "complete.obs"), 3)
#> [1] 0.765
```
