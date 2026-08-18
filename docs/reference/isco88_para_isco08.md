# Converte ISCO-88 em ISCO-08

Aplica a conversão publicada no módulo `isco8808.sps` do ISMF, derivada
da correspondência oficial da Organização Internacional do Trabalho.

## Uso

``` r
isco88_para_isco08(isco88, com_ambiguidade = FALSE)
```

## Argumentos

- isco88:

  Vetor de códigos ISCO-88.

- com_ambiguidade:

  Se `TRUE`, devolve um `data.frame` com o código e o número de
  alternativas da OIT em vez de só o código.

## Valor

Vetor de texto com o ISCO-08, ou um `data.frame` se
`com_ambiguidade = TRUE`.

## A ponte é ambígua e a ambiguidade importa

A OIT define, para muitos códigos da ISCO-88, mais de um destino
possível na ISCO-08. A sintaxe original guarda esse número na parte
decimal e instrui a truncá-lo quando não houver informação adicional. O
pacote trunca, como manda, mas **preserva a contagem** em
`n_alternativas` na tabela
[isco88_isco08](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_isco08.md),
e
[`tse_para_isco08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isco08.md)
pode devolvê-la. Cerca de um terço dos pares tem mais de uma
alternativa: a conversão é uma escolha razoável, não um equivalente
exato.

## Exemplos

``` r
isco88_para_isco08(c("2211", "1300"))
#> [1] "2130" "1400"
isco88_para_isco08(c("2211", "1300"), com_ambiguidade = TRUE)
#>   isco88 isco08 n_alternativas
#> 1   2211   2130              2
#> 2   1300   1400              1
```
