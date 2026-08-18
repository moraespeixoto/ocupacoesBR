# Escada hierárquica da CBO-2002 para quando a ocupação não está na tábua

Um degrau por prefixo de CBO, para subir do código de seis dígitos até
um nível em que a fonte permita afirmar um ISCO. Usada por
[`cbo2002_para_isco()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_isco.md)
com `escada = TRUE`.

## Uso

``` r
cbo2002_escada
```

## Formato

`data.frame` com as colunas:

- prefixo:

  prefixo da CBO-2002, de 2 a 4 dígitos.

- nivel:

  quantos dígitos tem o prefixo: 4 = família, 3 = subgrupo, 2 = subgrupo
  principal.

- isco88:

  ISCO-88 comum às ocupações mapeadas sob o prefixo.

- n_base:

  quantas ocupações mapeadas sustentam o degrau.

## Fonte

Agregado de
[cbo2002_isco88](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_isco88.md)
pela hierarquia da própria CBO.

## Como o degrau é apurado

Onde as ocupações mapeadas sob o prefixo não concordam num único ISCO,
usa-se o **ancestral comum** delas na hierarquia da ISCO — a forma
arredondada que o próprio ISMF publica: `2211` e `2212` viram `2210`;
`2210` e `2230` viram `2200`. Só entram degraus cujo destino exista em
[isco88_medidas](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_medidas.md),
porque um ISCO sem ISEI não serve de nada. Não há destino inventado:
sobe-se até onde a fonte permite afirmar, e não além.

## Por que para em dois dígitos

Descer a um dígito fecharia boa parte das 283 ocupações que sobram sem
rota, e cometeria exatamente a armadilha que este pacote existe para
impedir: o grande grupo 9 da CBO é reparação e manutenção (ISEI ~34) e o
da ISCO é o das ocupações elementares (ISEI 16 a 30). Uma cobertura
maior comprada com inversão de classe não é cobertura.

## Exemplos

``` r
head(cbo2002_escada)
#>   prefixo nivel isco88 n_base
#> 1    1111     4   1110      4
#> 2    1113     4   1110      2
#> 3    1313     4   2310      1
#> 4    1414     4   1314      3
#> 5    1415     4   1315      4
#> 6    1416     4   1226      2

# A escada tem três degraus — prefixo de quatro, três e dois dígitos — e é
# tentada, nessa ordem, só sobre o que sobrou NA com `escada = TRUE`.
table(cbo2002_escada$nivel)
#> 
#>   2   3   4 
#>  16 118 424 
```
