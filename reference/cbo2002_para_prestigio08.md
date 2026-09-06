# Prestigio de Treiman ancorado na ISCO-08, a partir da CBO-2002

A CBO-2002 aterrissa na ISCO-88, de modo que este escore atravessa a
ponte 88 -\> 08 e herda a perda dela: onde a OIT define mais de um
destino, usa-se o codigo truncado. Veja
[`isco88_para_isco08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_para_isco08.md).

## Usage

``` r
cbo2002_para_prestigio08(cbo, empate = c("na", "moda"), escada = FALSE)
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

Vetor numerico.

## Examples

``` r
cbo2002_para_prestigio08("225120")
#> [1] 78.01
```
