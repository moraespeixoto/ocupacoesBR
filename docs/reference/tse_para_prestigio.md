# Prestigio ocupacional de Treiman

Devolve o escore da Standard International Occupational Prestige Scale,
de Donald Treiman. E uma regua de PRESTIGIO — o quanto uma ocupacao e
socialmente estimada —, distinta do ISEI, que mede posicao
socioeconomica.

## Uso

``` r
tse_para_prestigio(cod, ano = NULL)
```

## Argumentos

- cod:

  Vetor de códigos de ocupação do TSE (numérico ou texto).

- ano:

  Vetor opcional de anos de eleição, do mesmo comprimento de `cod`. Com
  ele, as candidaturas cujo código o TSE **reutilizou** depois voltam
  `NA` com aviso, em vez de traduzidas pelo dicionário errado: o código
  215 designava um cargo de direção até 2000 e passou a designar artista
  plástico. Sem ele, o comportamento é o de sempre. Veja
  [`tse_vigencia()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_vigencia.md).

## Valor

Vetor numerico com o escore de prestigio.

## Quando o pressuposto quebra

A escala e a media de estudos de prestigio de cerca de 60 paises
levantados nos anos 1960 e 1970. Aplica-la a dado recente pressupoe que
a ordem de prestigio e invariante no tempo e no espaco — que e a tese
estrutural de Treiman (1977), e nao um fato dado. Ela quebra onde a
ocupacao mudou de posicao desde entao: bancario, professor, policial,
ocupacoes de tecnologia.

## Sobre o nome

Estas funcoes substituem
[`tse_para_siops()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_siops.md)
e companhia. No Brasil a sigla SIOPS designa o Sistema de Informacoes
sobre Orcamentos Publicos em Saude, e a colisao e certa num pacote em
portugues. As formas antigas seguem funcionando como alias depreciados.

## Referências

Treiman, D. J. (1977). *Occupational Prestige in Comparative
Perspective*. New York: Academic Press.

## Exemplos

``` r
tse_para_prestigio(c(111, 169, 257))
#> [1] 78 50 60
```
