# Dicionário de ocupações do TSE

Uma linha por código de ocupação (`CD_OCUPACAO`) das candidaturas.

## Uso

``` r
tse_isco
```

## Formato

`data.frame` com as colunas:

- cod_tse:

  código de ocupação do TSE, como texto.

- isco88:

  ISCO-88 de quatro dígitos; `NA` quando o código não designa ocupação
  (não informada, fora da PEA, vínculo sem função).

- nivel:

  número de dígitos da classificação de origem — 2, 3 ou 4. A maioria é
  a dois dígitos; desce-se a três ou quatro só onde dois fundiriam
  posições distantes demais, como médico e enfermeiro.

- classe:

  esquema de dez categorias para o dado eleitoral.

- estrato:

  classe alta, média, populares, ou uma das duas residuais.

- componente_alta:

  partição da classe alta em proprietária, credenciada e dirigentes;
  `NA` fora dela.

- politico:

  a ocupação é o próprio mandato ou cargo político.

- proprietario:

  o código nomeia explicitamente um proprietário ou empregador. Define a
  pertença à classe "Proprietários e empregadores" no esquema de
  classes.

- conta_propria:

  a pessoa trabalha por conta própria — o `SEMPL = 2` que as sintaxes do
  ISMF exigem para o EGP. É um **superconjunto** de `proprietario`: o
  agricultor (601) e o pescador (604) trabalham por conta própria sem
  pertencerem à classe proprietária. As duas marcas eram uma só até
  julho de 2026, e enquanto foram, marcar o agricultor como conta
  própria — o que o EGP exige para chegar a IVc — o promovia junto à
  classe alta, que o patrimônio não sustenta. A evidência que separou as
  duas está em
  [isco_posicao_br](https://moraespeixoto.github.io/ocupacoesBR/reference/isco_posicao_br.md).

## Fonte

Construído a partir dos microdados de candidaturas do Tribunal Superior
Eleitoral e da correspondência com a ISCO-88.

## Exemplos

``` r
# O agricultor trabalha por conta própria sem ser proprietário: as duas
# marcas eram uma só até julho de 2026, e enquanto foram, o EGP o promovia
# a IVc junto à classe alta.
tse_isco[tse_isco$cod_tse == "601", ]
#>     cod_tse isco88 nivel               classe           estrato componente_alta
#> 238     601   6100     2 Trabalhadores rurais Classes populares            <NA>
#>     politico proprietario conta_propria
#> 238    FALSE        FALSE          TRUE

# Quantos códigos o dicionário reconhece como o próprio mandato:
tse_isco$cod_tse[tse_isco$politico]
#> [1] "201" "203" "272" "273" "274" "275" "276" "277" "278"
```
