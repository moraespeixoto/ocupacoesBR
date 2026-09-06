# Antecedentes: de onde vem este pacote

Um pacote de medida não nasce de uma ideia. Ele nasce de uma tradição de
pesquisa que já formulou o problema, já propôs soluções e já registrou
os seus próprios limites. Esta página existe para dizer qual é essa
tradição, o que dela veio pronto, e o que restava por fazer.

Ela também serve a um propósito menos elevado e igualmente necessário:
separar, para o leitor apressado e para o parecerista atento, o que este
pacote contribui do que ele apenas embala.

## A linhagem brasileira

A ideia de ordenar ocupações por posição social não chega ao Brasil com
o índice internacional. Ela é anterior. **Nelson do Valle Silva**
derivou do Censo de 1970 a primeira escala socioeconômica nacional das
ocupações brasileiras, em *Posição social das ocupações* (IBGE, 1974) —
trabalho contemporâneo da própria tradição de Duncan, e não derivado
dela. Os estratos ocupacionais de **Pastore e Valle Silva** circulam na
pesquisa brasileira até hoje.

Sobre essa base construiu-se uma sociologia da estratificação brasileira
com instrumento próprio: **Carlos Hasenbalg** e Valle Silva sobre
estrutura social e desigualdade racial; **Carlos Antônio Costa Ribeiro**
sobre estrutura de classes e mobilidade; e **Flávio Carvalhaes**, cuja
avaliação por classes latentes do esquema EGP no caso brasileiro é a
advertência mais direta que este pacote teve de incorporar.

Este pacote não é uma alternativa a essa linhagem. É um instrumento
construído dentro dela, para uma fonte de dados que ela ainda não tinha
alcançado.

> Silva, N. V. (1974). *Posição social das ocupações*. Rio de Janeiro:
> IBGE.
>
> Carvalhaes, F. (2015). A tipologia ocupacional
> Erikson-Goldthorpe-Portocarero (EGP): uma avaliação analítica e
> empírica. *Sociedade e Estado*, 30(3), 673–703.
> <https://doi.org/10.1590/S0102-69922015.00030005>

## O que já estava resolvido, e que aqui é reimplementação

A tradução da ISCO em ISEI, prestígio e EGP **não é contribuição deste
pacote**. Ela é de Ganzeboom, De Graaf e Treiman, publicada em sintaxes
SPSS que o pacote lê, converte por script e redistribui com atribuição.

Existem, além disso, outros pacotes de R que fazem essa mesma tradução:
[`DIGCLASS`](https://cimentadaj.github.io/DIGCLASS/) (Cimentada),
[`ISCO08ConveRsions`](https://cran.r-project.org/package=ISCO08ConveRsions),
`isco88conversion` (Parker),
[`occupar`](https://github.com/DiogoFerrari/occupar) (Ferrari) e
[`iscoCrosswalks`](https://github.com/eworx-org/iscoCrosswalks), este
último entre a ISCO e a classificação norte-americana.

A postura do `ocupacoesBR` diante disso é não competir e sim
**conferir**: a implementação do EGP é comparada com a do `DIGCLASS` nas
oito células da grade de posição no emprego e supervisão, e as duas
concordam integralmente. A prova está em
[Robustez](https://moraespeixoto.github.io/ocupacoesBR/articles/robustez.md),
§3. Duas pessoas leram a mesma sintaxe separadamente e chegaram à mesma
tabela; é isso, e não a originalidade, que sustenta essa parte do
pacote.

Uma ausência vale registro: o
[`occupationcross`](https://guidowe.github.io/occupationcross/) cobre os
classificadores nacionais do México, da Argentina e dos Estados Unidos,
e **não** cobre a CBO brasileira. Nenhum dos pacotes acima cobre.

## O ISEI-BR não é o primeiro, e o precedente importa

Reestimar o índice socioeconômico em dado nacional, em vez de importar
os escores, tem precedente recente e próximo. **Sofia Jaime e Harry
Ganzeboom** — o próprio autor do procedimento de 1992 — publicaram em
2025 o **ARSEI**, um índice argentino construído pelo mesmo
escalonamento ótimo de efeito indireto, aplicado tanto ao classificador
nacional quanto à ISCO-08.

E o resultado deles vai na direção contrária ao daqui: encontraram o
índice internacional superando as duas versões locais, e leram isso como
apoio à tese de Treiman de que a hierarquia ocupacional é
aproximadamente invariante entre sociedades.

Essa divergência é declarada, e não escondida. Ela não se resolve por
autoridade, e boa parte dela pode ser de desenho: o critério externo é
outro (reprodução intergeracional numa pesquisa domiciliar, lá;
patrimônio declarado numa população de candidaturas, aqui), a população
de estimação é outra, o ano é outro. O que o pacote afirma é estreito e
verificável — a régua estimada leva vantagem **contra este critério,
nesta população** —, e é por isso que ela é oferecida ao lado das
importadas e nunca no lugar delas.

> Jaime, S. e Ganzeboom, H. B. G. (2025). A Socio-Economic Index for
> Occupational Stratification in Argentina: With Insights for
> Comparative Research. *Social Indicators Research*, 178(2), 875–904.
> <https://doi.org/10.1007/s11205-025-03582-1>

## A ocupação do candidato já havia sido classificada — de outro modo

No estudo do recrutamento político brasileiro, **Adriano Codato, Luiz
Domingos Costa e Lucas Massimo** propuseram em 2014 uma classificação
das ocupações prévias à entrada na política, testada sobre cerca de oito
mil candidaturas a deputado federal em 2006 e 2010.

O critério deles é declaradamente **analítico, e não sociográfico**:
classificam as ocupações pela flexibilidade da carreira, pelo status na
comunidade e pela afinidade prévia com o mundo político. É um esquema
desenhado para a pergunta do recrutamento, e deliberadamente não uma
ponte para padrão internacional.

Os dois caminhos respondem a perguntas diferentes e não se substituem.
Quem pergunta *quais ocupações predispõem à política* precisa de um
critério como o deles. Quem pergunta *como o perfil de classe das
candidaturas brasileiras se compara ao de outros países, ou à população
brasileira*, precisa de uma medida padronizada — e é essa que não
existia.

> Codato, A., Costa, L. D. e Massimo, L. (2014). Classificando ocupações
> prévias à entrada na política: uma discussão metodológica e um teste
> empírico. *Opinião Pública*, 20(3), 346–362.
> <https://doi.org/10.1590/1807-01912014203346>

## A advertência do campo, e por que o pacote a desobedece em parte

A revisão de referência sobre classificações ocupacionais recomenda que
se prefiram sempre medidas com padrão documentado e acordado, e que
ninguém desenvolva medida própria sem justificativa forte.

Este pacote faz as duas coisas de que essa recomendação desconfia:
constrói um dicionário autoral e distribui uma régua reestimada. A
justificativa é estreita e vale a pena enunciá-la sem retórica.

O dicionário é inevitável. O Tribunal Superior Eleitoral não publica
correspondência entre o seu cadastro de ocupações e classificação
alguma. Onde não há tábua oficial, a alternativa a um dicionário próprio
não é uma medida padronizada: é nenhuma medida, ou pior, a armadilha do
primeiro dígito. O que o pacote deve, em troca, é tornar cada decisão
auditável — daí a coluna `qualidade`, os rótulos em
[`crosswalk_tse()`](https://moraespeixoto.github.io/ocupacoesBR/reference/crosswalk_tse.md),
e a validação contra critério externo.

A régua é opcional. O ISEI-BR nunca substitui o importado: as duas
versões ancoradas e a estimada convivem, e a [vinheta de
validação](https://moraespeixoto.github.io/ocupacoesBR/articles/validacao.md)
mostra as três contra o mesmo critério. Quem discordar da estimação
continua com o pacote inteiro à disposição.

> Connelly, R., Gayle, V. e Lambert, P. S. (2016). A Review of
> Occupation-Based Social Classifications for Social Survey Research.
> *Methodological Innovations*, 9.
> <https://doi.org/10.1177/2059799116638003>

## O que, então, é contribuição

Feita a subtração, resta pouco — e o pouco é o que importa:

| Camada | Origem |
|----|----|
| ISCO → ISEI, SIOPS, EGP | Ganzeboom e Treiman (ISMF). Reimplementado e conferido. |
| CBO ↔︎ ISCO | Tábua oficial do Ministério do Trabalho. Redistribuída. |
| COD ↔︎ ISCO-08 | Estrutura do IBGE. Redistribuída. |
| **TSE → ISCO-88** | **Autoral.** Não há documento oficial que a confirme. |
| **Vigência dos códigos do TSE** | **Autoral.** A quebra de cadastro de 2002 e o argumento `ano`. |
| **ISEI-BR** | **Estimado aqui**, pelo procedimento de 1992, sobre a PNAD Contínua. |
| **Esquema de classes e estratos eleitoral** | **Autoral.** |

Duas dessas seis linhas são as que exigem citação do pacote, e são as
duas que não podem ser conferidas contra documento externo nenhum. É
essa a razão de tudo o mais nesta documentação: onde não há autoridade
externa a invocar, resta mostrar o trabalho.

Veja [Publicações e como
citar](https://moraespeixoto.github.io/ocupacoesBR/articles/publicacoes.md)
para as referências completas, e
[Robustez](https://moraespeixoto.github.io/ocupacoesBR/articles/robustez.md)
para as provas.
