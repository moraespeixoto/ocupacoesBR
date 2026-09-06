# ISEI-BR a partir da CBO-2002

Versao para o microdado do trabalho a partir de 2003, RAIS, CAGED e
eSocial. Leia
[`tse_para_isei_br()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei_br.md)
para o que a regua e e o que ela nao e.

## Usage

``` r
cbo2002_para_isei_br(cbo, empate = c("na", "moda"), escada = FALSE)
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

Vetor numerico com o escore ISEI-BR, entre 10 e 90.

## Duas pontes empilhadas

O caminho e CBO-2002 -\> ISCO-88 (tabua do Ministerio do Trabalho) -\>
ISCO-08 (ponte da OIT) -\> ISEI-BR, e a segunda ponte e ambigua em cerca
de um terco dos codigos de origem. A ressalva e a mesma de
[`cbo2002_para_isei08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_isei08.md)
e
[`cbo2002_para_prestigio08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_prestigio08.md),
que ja a traziam; esta porta nao a trazia ate 05/09/2026.

Vale ainda lembrar a data. O ISEI-BR e uma regua estimada em 2025 e que
a propria documentacao declara nao formar serie. Foi esse o argumento
que retirou a porta pela CBO-94 na versao 0.5.1. Ele nao se aplica aqui
com a mesma forca — a CBO-2002 esta em uso hoje —, mas se aplica ao
inicio de uma serie de RAIS que comece em 2003.

## See also

[`tse_para_isei_br()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei_br.md),
[isco08_isei_br](https://moraespeixoto.github.io/ocupacoesBR/reference/isco08_isei_br.md)

## Examples

``` r
cbo2002_para_isei_br("225120")
#> [1] 87.7
```
