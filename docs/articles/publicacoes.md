# Como citar

## As referências do pacote

``` r
citation("ocupacoesBR")
#> Ao usar o ocupacoesBR, cite o pacote E a fonte das escalas.  As tabelas
#> de ISEI, prestigio e EGP derivam das sintaxes publicadas do
#> International Stratification and Mobility File; Ganzeboom e Treiman as
#> mantem ha tres decadas e pedem citacao expressa. O pacote e o veiculo,
#> nao a fonte -- citar so o pacote apaga a autoria de quem construiu as
#> reguas. Veja tambem o arquivo LICENSE.note.
#> 
#> O pacote:
#> 
#>   Peixoto V (2026). _ocupacoesBR: Traduz a Ocupacao Declarada ao TSE em
#>   Classificacoes Padronizadas_. R package version 0.3.0,
#>   <https://github.com/moraespeixoto/ocupacoesBR>.
#> 
#> A fonte do ISEI, do prestigio e do EGP:
#> 
#>   Ganzeboom HBG, Treiman DJ (1996). "Internationally comparable
#>   measures of occupational status for the 1988 International Standard
#>   Classification of Occupations." _Social Science Research_, *25*(3),
#>   201-239. doi:10.1006/ssre.1996.0010
#>   <https://doi.org/10.1006/ssre.1996.0010>.
#> 
#> A construcao original do ISEI:
#> 
#>   Ganzeboom HBG, De Graaf PM, Treiman DJ (1992). "A standard
#>   international socio-economic index of occupational status." _Social
#>   Science Research_, *21*(1), 1-56. doi:10.1016/0049-089X(92)90017-B
#>   <https://doi.org/10.1016/0049-089X%2892%2990017-B>.
#> 
#> O prestigio ocupacional vem de Treiman, D. J. (1977), Occupational
#> Prestige in Comparative Perspective (Academic Press) -- uma media de
#> estudos de cerca de 60 paises levantados nos anos 1960 e 1970.
#> Aplica-lo a dado recente pressupoe que a ordem de prestigio e
#> invariante no tempo, que e a tese de Treiman e nao um fato dado. Veja
#> ?tse_para_siops.
#> 
#> To see these entries in BibTeX format, use 'print(<citation>,
#> bibtex=TRUE)', 'toBibtex(.)', or set
#> 'options(citation.bibtex.max=999)'.
```

São três entradas, e as duas primeiras devem aparecer juntas em qualquer
trabalho que use o pacote. A razão é simples: **o pacote é o veículo,
não a fonte**. As réguas — o ISEI, o prestígio de Treiman, o esquema EGP
— não foram construídas aqui. Elas vêm das sintaxes publicadas do
*International Stratification and Mobility File*, de Ganzeboom e
Treiman, redistribuídas em `inst/extdata/fontes/` com atribuição para
que a geração das tabelas seja reproduzível. Citar só o pacote credita a
embalagem e omite o conteúdo.

O que é autoral aqui, e por isso pede a citação do pacote, é a ponte
entre o cadastro de ocupações do TSE e a ISCO-88, com as decisões de
medida que ela exige, e o esquema de classes e estratos desenhado para o
dado eleitoral.

## O artigo de método

As decisões que a ponte exigiu estão documentadas em:

> Peixoto, V. (2026). Da ocupação declarada à posição social: as
> decisões de medida do pacote `ocupacoesBR`. Manuscrito em preparação.

O artigo é o lugar onde as escolhas são justificadas, e não apenas
descritas: por que o agricultor deixou de ser tratado como proprietário,
por que o `NA` é preferível a um escore plausível, por que o patrimônio
serve de critério externo apesar de tudo o que há de errado com ele. A
documentação do pacote diz o que fazer; o artigo diz por quê.

Há trabalhos em andamento sobre classe e recrutamento político que usam
o pacote como instrumento de medida. Serão listados aqui quando forem
publicados.

## Sobre os limites do EGP no Brasil

O esquema EGP é portado fielmente das sintaxes originais, mas fidelidade
à sintaxe não é adequação ao caso brasileiro. Antes de usá-lo, vale ler:

> Carvalhaes, F. (2015). A tipologia ocupacional
> Erikson-Goldthorpe-Portocarero (EGP): uma avaliação analítica e
> empírica. *Sociedade e Estado*, 30(3), 673–703.

A vinheta [Qual régua responde à sua
pergunta](https://moraespeixoto.github.io/ocupacoesBR/articles/qual-regua.md)
explica em que condições o EGP construído a partir do cadastro do TSE é
interpretável, e em que condições não é.
