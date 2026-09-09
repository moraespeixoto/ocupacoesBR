# Da ocupação declarada ao TSE à posição social

Pacote R · dado eleitoral brasileiro

Traduz o código de ocupação das candidaturas em ISCO-88 e ISCO-08, e daí
em ISEI, prestígio de Treiman, EGP e um esquema de classes desenhado
para o dado eleitoral. Também entra pela CBO da RAIS e pela COD da PNAD.

``` r

remotes::install_github("moraespeixoto/ocupacoesBR")
```

[Comece
aqui](https://moraespeixoto.github.io/ocupacoesBR/articles/comece-aqui.md)
[Qual régua
usar?](https://moraespeixoto.github.io/ocupacoesBR/articles/qual-regua.md)
[Referência](https://moraespeixoto.github.io/ocupacoesBR/reference/index.md)

[![R-CMD-check](https://github.com/moraespeixoto/ocupacoesBR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/moraespeixoto/ocupacoesBR/actions/workflows/R-CMD-check.yaml)
licençaMIT cadastro TSE1998–2026 idiomapt-BR

![Do código bruto de ocupação às ocupações
classificadas](banner_ocupacoes.jpg)

O uso normal

## Uma linha, e o banco ganha uma coluna

Você passa a coluna inteira de códigos e recebe a coluna traduzida,
alinhada linha a linha. Não há loop nem tradução código a código, e o
banco não muda de tamanho.

Cada régua é uma função, e cada função é uma coluna nova. Como todas são
vetorizadas puras, elas cabem no mesmo
[`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html), em
qualquer ordem, e o pipeline não sai do dplyr. O artigo [Com o
tidyverse](https://moraespeixoto.github.io/ocupacoesBR/articles/tidyverse.md)
percorre um pipeline inteiro assim.

O `ano` também é uma coluna, e é o que resolve a quebra de cadastro de
2002: em 1998 o código 214 era delegado de polícia, e hoje é escultor e
pintor. Sem o ano, aquela linha receberia calada o escore de escultor.
Com ele, o pacote devolve `NA` e avisa.

R

``` r

library(dplyr)
library(ocupacoesBR)

dados |>
  mutate(
    isco  = tse_para_isco(CD_OCUPACAO, ano = ANO_ELEICAO),
    isei  = tse_para_isei(CD_OCUPACAO, ano = ANO_ELEICAO),
    prest = tse_para_prestigio(CD_OCUPACAO, ano = ANO_ELEICAO),
    egp   = tse_para_egp(CD_OCUPACAO, ano = ANO_ELEICAO,
                         avisar = FALSE),
    classe = tse_para_classe(CD_OCUPACAO, ano = ANO_ELEICAO)
  ) |>
  select(-DS_CARGO) |>
  glimpse()
#> Warning: There were 5 warnings in `mutate()`.
#> The first warning was:
#> ℹ In argument: `isco = tse_para_isco(CD_OCUPACAO, ano =
#>   ANO_ELEICAO)`.
#> Caused by warning:
#> ! 1 candidatura(s) usam código(s) que o TSE REUTILIZOU depois (214): naquele ano designavam outra ocupação, e voltam NA.
#> Veja ?tse_vigencia.
#> ℹ Run `dplyr::last_dplyr_warnings()` to see the 4 remaining
#>   warnings.
#> Rows: 5
#> Columns: 7
#> $ ANO_ELEICAO <int> 2026, 2026, 2026, 2026, 1998
#> $ CD_OCUPACAO <chr> "131", "601", "298", "999", "214"
#> $ isco        <chr> "2421", "6100", NA, NA, NA
#> $ isei        <dbl> 85, 23, NA, NA, NA
#> $ prest       <dbl> 73, 38, NA, NA, NA
#> $ egp         <chr> "I: dirigentes e profissionais superiore…
#> $ classe      <chr> "Profissionais de nível superior", "Trab…
```

Quatro portas de entrada

## Cada fonte brasileira tem a sua porta, e todas levam ao mesmo lugar

### TSE

O código de ocupação das candidaturas, de 1998 a 2026. A única ponte
autoral do pacote, com régua de qualidade em cada linha.

`tse_para_*()`

### CBO

A Classificação Brasileira de Ocupações da RAIS, do CAGED e do eSocial,
pela tábua oficial do Ministério do Trabalho. CBO-2002 e CBO-94.

`cbo2002_para_*()`

### COD

A classificação da PNAD Contínua e do Censo, construída sobre a ISCO-08.
É por aqui que se compara candidatura com população.

`cod_para_*()`

### ISCO

Para quem já tem o código internacional e quer só a medida, ou precisa
atravessar da ISCO-88 para a ISCO-08 e voltar.

`isco88_para_*()`

Quatro réguas, que não são intercambiáveis

## O pacote entrega todas com a mesma facilidade. Escolher é com você.

16 – 90

### ISEI

Índice socioeconômico de Ganzeboom, De Graaf e Treiman. Contínuo,
somável, o padrão da pesquisa comparada de estratificação. Vem em três
estimações: as âncoras de 1988 e de 2008, importadas, e a brasileira,
que o pacote estima na PNAD Contínua e que não substitui as outras.

Treiman, 1977

### Prestígio

Escala de prestígio ocupacional comparativa. Mede reputação, não
recurso; as duas se separam em ocupações inteiras.

11 · 7 · 5 · 3 classes

### EGP

Erikson-Goldthorpe-Portocarero, portado das sintaxes do ISMF — o
mapeamento de Ganzeboom e Treiman sobre a ISCO-88. Exige posição no
emprego, que o pacote preenche pelo dicionário, e número de
subordinados, que o TSE não pergunta: o pacote avisa.

esquema do pacote

### Classe e estrato

Desenhado para o que o cadastro do TSE de fato registra, inclusive o
político profissional e o vínculo público não especificado.

Por onde começar

## Seis artigos, e o primeiro importa mais que a documentação de qualquer função

[Todos os artigos
→](https://moraespeixoto.github.io/ocupacoesBR/articles/index.md)

[Comece
aqui](https://moraespeixoto.github.io/ocupacoesBR/articles/comece-aqui.md)

### Da ocupação declarada à posição social

O percurso inteiro em uma sessão, com códigos reais do TSE, e a tabela
que mostra onde cada medida responde e onde ela se abstém.

[No
pipe](https://moraespeixoto.github.io/ocupacoesBR/articles/tidyverse.md)

### Com o tidyverse

O percurso inteiro dentro de um mutate(): uma coluna por régua,
across(), a junção com o dicionário e a checagem de cobertura antes de
analisar.

[Escolher a
medida](https://moraespeixoto.github.io/ocupacoesBR/articles/qual-regua.md)

### Qual régua responde à sua pergunta

Quatro medidas, nenhuma intercambiável, e os erros que as pessoas
cometem, na ordem em que os cometem.

[Validar](https://moraespeixoto.github.io/ocupacoesBR/articles/validacao.md)

### A medida se sustenta?

Patrimônio declarado e escolaridade como critério externo, que não
entram na construção da medida.

[Percursos](https://moraespeixoto.github.io/ocupacoesBR/articles/percursos.md)

### Onde cada tradução se interrompe

Os pontos de ruptura dos percursos: a ambiguidade da ponte, o empate, a
agregação e o resíduo.

[A eleição em
curso](https://moraespeixoto.github.io/ocupacoesBR/articles/safra-2026.md)

### A safra de 2026, na régua

Nenhum código novo: os 210 códigos declarados em 2026 são subconjunto
dos 275 que o pacote já cobria.

O mapa das traduções

## Cada seta tem fonte declarada

As tábuas de conversão derivam das sintaxes publicadas do *International
Stratification and Mobility File*, de Ganzeboom e Treiman, e da tábua
oficial do Ministério do Trabalho. São geradas por script a partir dos
arquivos originais, nunca transcritas à mão.

A do TSE para a ISCO-88 é a única autoral. É por isso que ela carrega os
rótulos e a régua de qualidade: é a parte que ninguém pode conferir
contra um documento oficial.

[Ver as tabelas na referência
→](https://moraespeixoto.github.io/ocupacoesBR/reference/index.html#as-tabelas)

![As traduções que o pacote faz, e as que não
faz](reference/figures/rede_crosswalks.png)

Publicações

## O que foi construído com o pacote

O artigo de método é o lugar onde as escolhas são justificadas, e não
apenas descritas. Os trabalhos empíricos usam o pacote como instrumento
de medida.

[Como citar o pacote e as réguas
→](https://moraespeixoto.github.io/ocupacoesBR/articles/publicacoes.md)

Artigo de método

Peixoto, V. (2026). Da ocupação declarada à posição social: as decisões
de medida do pacote ocupacoesBR.

[doi:10.31235/osf.io/b29kg_v1](https://doi.org/10.31235/osf.io/b29kg_v1)SocArXiv,
2026

Trabalho empírico

Peixoto, V. (2026). Os três corpos de uma eleição: eleitorado,
candidaturas e eleitos no Brasil (1998–2026).

[doi:10.31235/osf.io/57xp6_v1](https://doi.org/10.31235/osf.io/57xp6_v1)SocArXiv,
2026

Trabalho empírico

Peixoto, V. (2026). As duas faces da classe no recrutamento político
brasileiro.

[doi:10.31235/osf.io/muxf8_v1](https://doi.org/10.31235/osf.io/muxf8_v1)SocArXiv,
2026

A fonte das réguas

Ganzeboom, H. B. G. e Treiman, D. J. (1996). Internationally comparable
measures of occupational status for the 1988 ISCO. *Social Science
Research*, 25(3), 201–239.

[doi:10.1006/ssre.1996.0010](https://doi.org/10.1006/ssre.1996.0010)

### Ao usar o ocupacoesBR, cite o pacote e a fonte das escalas

O pacote é o veículo, não a fonte. As réguas vêm do *International
Stratification and Mobility File*, que Ganzeboom e Treiman mantêm há
três décadas e pedem citação expressa.

O ISEI-BR é a exceção, e pede três citações: o pacote, porque a
estimação é dele; Ganzeboom, De Graaf e Treiman (1992), pelo método; e o
IBGE, pela PNAD Contínua trimestral de 2025, que é o dado.

    Peixoto V (2026). _ocupacoesBR: Traduz a Ocupacao
    Declarada ao TSE em Classificacoes Padronizadas_. R
    package version 0.8.0,
    <https://github.com/moraespeixoto/ocupacoesBR>.

Pacote
[Referência](https://moraespeixoto.github.io/ocupacoesBR/reference/index.md)
[Novidades
(0.8.0)](https://moraespeixoto.github.io/ocupacoesBR/news/index.md)
[Código-fonte](https://github.com/moraespeixoto/ocupacoesBR) [Reportar
um erro](https://github.com/moraespeixoto/ocupacoesBR/issues)

Ler [Comece
aqui](https://moraespeixoto.github.io/ocupacoesBR/articles/comece-aqui.md)
[Qual
régua](https://moraespeixoto.github.io/ocupacoesBR/articles/qual-regua.md)
[Validação](https://moraespeixoto.github.io/ocupacoesBR/articles/validacao.md)
[Safra
2026](https://moraespeixoto.github.io/ocupacoesBR/articles/safra-2026.md)

Autor Vitor Peixoto UENF [Licença
MIT](https://moraespeixoto.github.io/ocupacoesBR/LICENSE.md)
