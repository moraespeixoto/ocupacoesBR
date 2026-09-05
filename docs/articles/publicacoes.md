# Publicações e como citar

## O artigo de método

As decisões que a ponte entre o cadastro do TSE e a ISCO-88 exigiu estão
documentadas em:

> Peixoto, V. (2026). Da ocupação declarada à posição social: as
> decisões de medida do pacote `ocupacoesBR`. **\[DOI em breve\]** ·
> Manuscrito em preparação.

O artigo é o lugar onde as escolhas são justificadas, e não apenas
descritas: por que o agricultor deixou de ser tratado como proprietário,
por que o `NA` é preferível a um escore plausível, por que o patrimônio
serve de critério externo apesar de tudo o que há de errado com ele. A
documentação do pacote diz o que fazer; o artigo diz por quê.

## Trabalhos que usam o pacote

Estes são os trabalhos empíricos que usam o `ocupacoesBR` como
instrumento de medida. Os campos entre colchetes são preenchidos quando
cada trabalho é publicado; os DOIs entram aqui assim que existirem.

> \[título\] · \[periódico, ano\] · \[DOI\]

Se você publicou algo usando o pacote e quer que apareça nesta lista,
abra uma questão em
<https://github.com/moraespeixoto/ocupacoesBR/issues>.

## A fonte das réguas

O pacote é o veículo, não a fonte. As réguas — o ISEI, o prestígio de
Treiman, o esquema EGP — não foram construídas aqui. Elas vêm das
sintaxes publicadas do *International Stratification and Mobility File*,
de Ganzeboom e Treiman, redistribuídas em `inst/extdata/fontes/` com
atribuição para que a geração das tabelas seja reproduzível. Citar só o
pacote credita a embalagem e omite o conteúdo.

O ISEI-BR inverte isso, e é a única régua que inverte. Ele não foi
importado de lugar nenhum: o pacote o estima, com o script
`data-raw/09_gera_isei_br.R`, sobre microdados públicos. Quem o usa deve
três citações. O pacote, porque a estimação é dele. Ganzeboom, De Graaf
e Treiman (1992), porque o método é deles. E o IBGE, pela PNAD Contínua
trimestral de 2025, porque o dado é dele. Creditar só Ganzeboom aqui
seria o erro simétrico do anterior: atribuiria a eles números que não
calcularam.

> Ganzeboom, H. B. G. e Treiman, D. J. (1996). Internationally
> comparable measures of occupational status for the 1988 International
> Standard Classification of Occupations. *Social Science Research*,
> 25(3), 201–239. <https://doi.org/10.1006/ssre.1996.0010>

> Ganzeboom, H. B. G., De Graaf, P. M. e Treiman, D. J. (1992). A
> standard international socio-economic index of occupational status.
> *Social Science Research*, 21(1), 1–56.
> <https://doi.org/10.1016/0049-089X(92)90017-B>

O prestígio ocupacional vem de Treiman, D. J. (1977), *Occupational
Prestige in Comparative Perspective* (Academic Press) — uma média de
estudos de cerca de 60 países levantados nos anos 1960 e 1970. Aplicá-lo
a dado recente pressupõe que a ordem de prestígio é invariante no tempo,
que é a tese de Treiman e não um fato dado.

O que é autoral aqui, e por isso pede a citação do pacote, é a ponte
entre o cadastro de ocupações do TSE e a ISCO-88, com as decisões de
medida que ela exige, e o esquema de classes e estratos desenhado para o
dado eleitoral.

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

## As referências do pacote, como o R as devolve

``` r
citation("ocupacoesBR")
#> Ao usar o ocupacoesBR, cite o pacote E a fonte das escalas.  As tabelas
#> de ISEI, prestigio e EGP derivam das sintaxes publicadas do
#> International Stratification and Mobility File; Ganzeboom e Treiman as
#> mantem ha tres decadas e pedem citacao expressa. O pacote e o veiculo,
#> nao a fonte -- citar so o pacote apaga a autoria de quem construiu as
#> reguas. Veja tambem o arquivo LICENSE.note.
#> 
#> O ISEI-BR e a excecao: ele nao foi importado, o pacote o estimou sobre
#> a PNAD Continua de 2025. Quem o usa deve tres citacoes -- o pacote pela
#> estimacao, Ganzeboom, De Graaf e Treiman (1992) pelo metodo, e o IBGE
#> pelo dado. Veja ?isco08_isei_br.
#> 
#> O pacote:
#> 
#>   Peixoto V (2026). _ocupacoesBR: Traduz a Ocupacao Declarada ao TSE em
#>   Classificacoes Padronizadas_. R package version 0.6.0,
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
#> O dado do ISEI-BR:
#> 
#>   IBGE (2025). _Pesquisa Nacional por Amostra de Domicilios Continua
#>   trimestral: microdados_. Instituto Brasileiro de Geografia e
#>   Estatistica, Rio de Janeiro.
#>   <https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Trimestral/Microdados/>.
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
trabalho que use o pacote.
