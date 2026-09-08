# ISCO-88 a partir da COD

Passa pela ISCO-08 e desce pela ponte reversa. E o caminho para o
ISEI-88 e para o EGP a partir da PNAD Continua e do Censo.

## Uso

``` r
cod_para_isco(cod)
```

## Argumentos

- cod:

  Vetor de codigos da COD, de quatro digitos.

## Valor

Vetor de texto com o ISCO-88.

## Detalhes

E tambem o ponto em que a adaptacao brasileira da COD se desfaz sem que
voce peca: o IBGE aloca a policia militar e o corpo de bombeiros militar
ao grande grupo 0, o das forcas armadas, e esta funcao os devolve a 5162
e 5161, que e onde os codigos 145, 232, 233 e 258 do cadastro do TSE
tambem aterrissam. Quem ler o primeiro digito da COD em vez de traduzir
poe o policial militar da populacao num grande grupo e o candidato
policial militar em outro. O exemplo abaixo mostra os dois caminhos.

## Veja também

O artigo *Comparar duas fontes*, no site do pacote, que trata das oito
decisoes de uma comparacao entre candidaturas e populacao e explica esta
adaptacao em detalhe:
<https://moraespeixoto.github.io/ocupacoesBR/articles/comparar-fontes.html>

## Exemplos

``` r
cod_para_isco(c("2211", "0411"))
#> [1] "2221" "5162"

# a adaptacao da COD, desfeita: 0411 e policia militar
cod_para_isco08("0411")   # 5412, servico protetivo na ISCO-08
#> [1] "5412"
cod_para_isco("0411")     # 5162, o mesmo destino dos codigos do TSE
#> [1] "5162"
```
