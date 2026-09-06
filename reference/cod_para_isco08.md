# Traduz a COD do IBGE em ISCO-08

Converte o codigo da Classificacao de Ocupacoes para Pesquisas
Domiciliares — a da PNAD Continua e do Censo Demografico — no codigo
ISCO-08.

## Usage

``` r
cod_para_isco08(cod)
```

## Arguments

- cod:

  Vetor de codigos da COD, de quatro digitos.

## Value

Vetor de texto com o ISCO-08.

## Por que esta perna e quase gratuita

A COD e construida sobre a ISCO-08, e por isso **428 dos seus 434 grupos
de base sao identicos ao codigo internacional**. Nao ha tabua de
conversao a consultar nem correspondencia a construir: a traducao e
identidade, e o que resta e decidir as seis adaptacoes brasileiras.

Compare com a perna da CBO, que exige a tabua do Ministerio do Trabalho
e cobre metade do seu universo. A diferenca nao e de esforco: e de
desenho das classificacoes.

## As seis adaptacoes

- `0411`, `0412`, `0511`, `0512`:

  policia e bombeiro militar. Vao para `5412` e `5411`, do grande grupo
  5 (servicos protetivos), e nao para o grande grupo 0 (forcas armadas):
  a PM e o BM brasileiros sao militarizados em estatuto, mas exercem
  servico protetivo civil, e e a funcao que a classificacao mede. **A
  distincao entre oficial e praca se perde** — a ISCO-08 nao a tem, e no
  Brasil ela e um degrau de status real. Quem precisar dela tem de
  trata-la fora do ISEI.

- `5168`:

  trabalhadores do sexo, para `5169` (servicos pessoais nao
  classificados em outra parte).

- `6225`:

  pescadores, para o **subgrupo** `6220`. A COD funde numa rubrica o que
  a ISCO-08 reparte em quatro (aquicultura, pesca costeira, pesca de
  alto-mar, caca), que vao de ISEI 11 a 21. Escolher uma seria
  arbitrario; o subgrupo e a forma arredondada que o proprio ISMF
  publica.

## O unico buraco, e ele vem da fonte

A traducao e completa — os 434 grupos de base chegam a ISCO-08 e a
ISCO-88. Mas as FORCAS ARMADAS (`0110` e `0210`) ficam sem **ISEI-88,
prestigio-88 e EGP**, porque o ISMF nao pontua o ISCO-88 `0110`. As
medidas ancoradas na ISCO-08 existem — `cod_para_isei08("0110")` e 60,9
(oficiais) e `("0210")`, 51,6 —, porque o `isqoisei08.sps` pontua a
hierarquia militar da ISCO-08; a lacuna e so na ponte de volta a
ISCO-88, e devolver `NA` ali e o comportamento correto, nao um escore
inventado.

## See also

[`cod_para_isei08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cod_para_isei08.md),
[`cod_para_isco()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cod_para_isco.md),
[`crosswalk_cod()`](https://moraespeixoto.github.io/ocupacoesBR/reference/crosswalk_cod.md)

## Examples

``` r
cod_para_isco08(c("2211", "0411", "6225"))
#> [1] "2211" "5412" "6220"
```
