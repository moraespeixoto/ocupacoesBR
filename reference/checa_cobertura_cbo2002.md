# Verifica a cobertura de códigos da CBO-2002

Equivalente de
[`checa_cobertura()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_cobertura.md)
para a porta da CBO. Distingue o código que não existe na CBO-2002
daquele que existe mas **não tem correspondência oficial** com a CIUO-88
— este último é limite da tábua do Ministério do Trabalho, não erro do
seu dado, e por isso vira aviso, não erro.

## Usage

``` r
checa_cobertura_cbo2002(cbo, silencioso = FALSE)
```

## Arguments

- cbo:

  Vetor de códigos da CBO-2002 observados no seu dado.

- silencioso:

  Se `TRUE`, não escreve a mensagem de sucesso.

## Value

Invisivelmente, `TRUE`.

## Examples

``` r
checa_cobertura_cbo2002(c("1111-05", "225120"))
#> cobertura CBO-2002: 2 códigos, 2 com correspondência.
try(checa_cobertura_cbo2002(NULL))
#> Error : nenhum código da CBO-2002 válido em `cbo` (o vetor é NULL — confira o nome da coluna).
```
