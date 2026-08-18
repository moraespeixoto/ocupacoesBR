# Encontra o código a partir do rótulo da ocupação

Serve a quem recebe a ocupação como texto e não como código — o caso de
quem baixa `br_tse_eleicoes.candidatos` no `basedosdados`. A busca
ignora caixa, acento e pontuação.

## Uso

``` r
tse_rotulo_para_cod(rotulo, exato = TRUE)
```

## Argumentos

- rotulo:

  Vetor de rótulos de ocupação.

- exato:

  Se `TRUE` (padrão), só casa o rótulo inteiro; se `FALSE`, casa por
  conteúdo e pode devolver mais de um código por rótulo.

## Valor

`data.frame` com `rotulo` (o que se procurou), `cod_tse` e o rótulo
canônico encontrado. Sempre um `data.frame`, com zero linhas quando não
há o que procurar — o tipo do retorno não depende do conteúdo do
argumento.

## Exemplos

``` r
tse_rotulo_para_cod("Agricultor")
#>       rotulo cod_tse rotulo_tse
#> 1 Agricultor     601 AGRICULTOR
tse_rotulo_para_cod("advogado", exato = FALSE)
#>     rotulo cod_tse rotulo_tse
#> 1 advogado     131   ADVOGADO
```
