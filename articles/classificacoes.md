# As classificações: história, alcance e limites

Quatro classificações de ocupação entram neste pacote, e nenhuma delas
foi feita para o que aqui se faz com ela. Uma foi desenhada para
comparar países, duas para administrar registros do Estado brasileiro, e
a quarta nem é classificação — é uma lista de opções de formulário.

Saber de onde cada uma vem não é erudição: **é o que permite prever onde
ela vai falhar.** Uma classificação carrega no seu desenho a pergunta
que a originou, e usá-la para outra pergunta produz erro com aparência
de normalidade.

Esta página trata das classificações — os endereços. Para as **medidas**
que se constroem sobre elas (ISEI, prestígio, EGP), veja [Qual régua
responde à sua
pergunta](https://moraespeixoto.github.io/ocupacoesBR/articles/qual-regua.md).

Os números computáveis desta página saem dos dados instalados com o
pacote. As datas, os números de resolução e os fatos documentais são
digitados, e vêm das fontes registradas em
`inst/extdata/PROVENIENCIA.yml` e na bibliografia do artigo de método.

## A ISCO, o eixo internacional

**História.** A Classificação Internacional Uniforme de Ocupações teve
quatro versões. A de **1958** foi adotada pela 9ª Conferência
Internacional de Estatísticos do Trabalho e organizava as ocupações em
dez grandes grupos. A de **1968** reduziu-os a oito e ampliou o detalhe.
A de **1988** — adotada em 1987, publicada em 1990 — é uma ruptura
conceitual com as duas anteriores. A de **2008** manteve o arcabouço de
1988 e ampliou a granularidade.

**A ruptura de 1988** consistiu em substituir a acumulação de categorias
por dois critérios explícitos: o **nível de habilidade** (complexidade e
amplitude das tarefas) e a **especialização** (campo de conhecimento,
instrumentos, materiais, tipo de bem ou serviço). O primeiro dígito
resulta principalmente do primeiro critério.

O nível de habilidade não é abstrato: a OIT o ancorou na Classificação
Internacional Normalizada da Educação — na versão de 1976, que é a
vigente quando a ISCO-88 foi desenhada. O nível 4 corresponde ao grau
universitário ou à pós-graduação (categorias 6 e 7); o 3, ao terciário
que não leva a diploma universitário (categoria 5); o 2, ao secundário,
primeiro e segundo estágios (categorias 2 e 3); o 1, ao primário
(categoria 1).

A ISCO-08 reancorou os mesmos quatro níveis na ISCED de 1997, e aí o
nível 2 passou a incluir também o pós-secundário não terciário. É uma
diferença fácil de citar trocada, e ela importa: o pacote está ancorado
na de 1988. Sobre essa âncora, o grande grupo 2 recebe o nível 4, o
grupo 3 o nível 3, os grupos 4 a 8 o nível 2, e o grupo 9 o nível 1.

**Por que importa.** É o eixo. Toda medida **importada** deste pacote —
ISEI, prestígio, EGP — está publicada sobre a ISCO, e não sobre
classificação nacional alguma. Sem passar por ela, não há régua
importada.

As que o pacote produz são outra coisa, e não passam por aí: classe,
estrato e componente da classe alta ancoram no próprio cadastro do TSE,
e o ISEI-BR é estimado sobre a COD. A coluna `ancora` de `reguas` diz
qual é qual.

``` r

c(`grupos com medidas na ISCO-88` = nrow(isco88_medidas),
  `grupos com medidas na ISCO-08` = nrow(isco08_medidas))
#> grupos com medidas na ISCO-88 grupos com medidas na ISCO-08 
#>                           537                           590
```

### O limite que mais engana

**Os grandes grupos 0 e 1 da ISCO-88 não receberam nível de habilidade
algum.** Dirigentes e legisladores (grupo 1) e forças armadas (grupo 0)
foram construídos por outro critério — a função de direção e a natureza
militar da tarefa — e apenas *ocupam posições vizinhas na numeração*.

A consequência é dura: **o primeiro dígito da ISCO-88 não é uma escala
percorrida de ponta a ponta.** Qualquer uso dele como ordenação contínua
herda essa descontinuidade. É a razão de este pacote nunca ordenar por
código, e de a [armadilha do primeiro
dígito](https://moraespeixoto.github.io/ocupacoesBR/articles/comece-aqui.md)
ter teste próprio na suíte.

O segundo limite é a **fronteira entre os grandes grupos 2 e 3** —
profissionais e técnicos. Ela foi desenhada quando muitas ocupações hoje
universitárias ainda não o eram, e a revisão de 2008 promoveu parte
delas: a fisioterapia passou de `3226` a `2264`, e a nutrição de `3223`
a `2265`, ambas de técnicas a profissionais. A enfermagem **não** é caso
de promoção — a ISCO-88 já a punha no grande grupo 2 —, e mesmo assim é
por causa dela que a documentação recomenda ancorar na ISCO-08 para
análise de gênero: ali o que se corrige é o escore, não a alocação.

## A CBO, e a ruptura de 2002

**História.** A Classificação Brasileira de Ocupações nasceu de convênio
entre o Brasil e as Nações Unidas, com estrutura elaborada em **1977** e
primeira versão publicada em **1982**. A sua matriz internacional
declarada é a ISCO de **1968** — não a de 1958, confusão fácil porque a
cronologia oficial abre registrando a primeira edição da OIT.

A **CBO-94** tinha cinco dígitos, sete grandes grupos, 354 grupos de
base e 2.355 ocupações. O princípio classificatório era o **cargo**, ou
posto de trabalho, agregado por analogia de tarefas — pergunta diferente
da que a ISCO-88 faz, que agrupa por nível de habilidade.

A **CBO-2002**, aprovada pela Portaria MTE nº 397, de 9 de outubro de
2002, mudou o princípio: passou a seis dígitos, substituiu o cargo pela
**família ocupacional** e adotou os dez grandes grupos da ISCO-88 com o
critério de agregação por nível de competência. A construção mobilizou
cerca de sete mil trabalhadores em mil e oitocentas reuniões-dia, pelo
método DACUM — em que a descrição de uma ocupação é produzida por quem a
exerce.

**Por que importa.** É a classificação do registro administrativo
brasileiro: RAIS, CAGED, eSocial. Quem trabalha com vínculo formal entra
por ela.

``` r

# Os dois números abaixo são o que o pacote COBRE, e não o tamanho da CBO: a
# tábua oficial do MTE só cobre as ocupações que existem também na CBO-94.
# Veja ?cbo2002_para_isco.
c(`códigos com correspondência oficial` = nrow(cbo2002_isco88),
  `famílias com correspondência` = nrow(cbo2002_familia_isco88))
#> códigos com correspondência oficial        famílias com correspondência 
#>                                1387                                 436
```

O tamanho da CBO depende de qual edição se conta, e o site usava os dois
números sem dizer. A edição de 2002 traz 2.422 ocupações em 596
famílias; o domínio vigente, o do Novo CAGED — que é contra o qual as
taxas de cobertura deste pacote são calculadas —, é maior:

``` r

dom <- readLines(system.file("extdata", "fontes", "cbo2002_dominio.txt",
                             package = "ocupacoesBR"), warn = FALSE)
dom <- setdiff(trimws(dom[nzchar(trimws(dom))]), "999999")  # tira o sentinela
c(ocupacoes = length(dom), familias = length(unique(substr(dom, 1, 4))))
#> ocupacoes  familias 
#>      2777       626
```

### Dois limites, e o segundo é uma ausência

O primeiro: a conversão entre a **CBO-94 e a CBO-2002 não é um a um**.
As ocupações de uma família antiga podem se distribuir por famílias
diferentes na estrutura nova — a comparabilidade existe no nível dos
códigos, não no das famílias.

O segundo é mais consequente. **Não existe tábua oficial ligando a
CBO-2002 à ISCO-08.** A CBO permanece ancorada na ISCO-88, com quase
duas décadas de defasagem em relação à revisão vigente. Um dado que
chegue pela CBO só alcança a ISCO-08 por travessia — CBO → ISCO-88 →
ISCO-08 —, e cada passo custa precisão. A prova §1 de
[Robustez](https://moraespeixoto.github.io/ocupacoesBR/articles/robustez.md)
mostra o tamanho desse custo.

## A COD, a classificação das pesquisas domiciliares

**História.** A Classificação de Ocupações para Pesquisas Domiciliares
foi desenvolvida pelo IBGE para o **Censo de 2010**, e é usada desde o
primeiro trimestre de **2012** na PNAD Contínua. A sua referência
declarada é a **ISCO-08**.

E a ancoragem é observável na estrutura, sem depender da declaração:

``` r

cc <- cod_isco08
c(`grupos de base` = nrow(cc),
  `idênticos ao código da ISCO-08` = sum(cc$cod == cc$isco08),
  `porcentagem` = round(100 * mean(cc$cod == cc$isco08), 1))
#>                 grupos de base idênticos ao código da ISCO-08 
#>                          434.0                          428.0 
#>                    porcentagem 
#>                           98.6
```

**Por que importa.** Esta é a diferença mais consequente entre as duas
classificações brasileiras: **a CBO ancora em 1988 e a COD em 2008.**
Não são duas versões da mesma árvore — são duas árvores. Um dado que
chegue pela COD já está na ISCO-08 para quase todos os seus grupos; um
dado que chegue pela CBO precisa atravessar.

É também por isso que o ISEI-BR é estimado sobre a PNAD Contínua: ali a
ocupação já está, quase sempre, no endereço internacional vigente.

### Os limites: granularidade e o grande grupo 0

A COD é mais curta que a CBO — 434 grupos de base contra 596 famílias —,
e a razão declarada é metodológica antes de classificatória. Em pesquisa
domiciliar a ocupação é a **frase que o morador diz ao entrevistador**,
e essa frase frequentemente não detalha o suficiente para distinguir
grupos de base da classificação internacional. A CBO é construída sobre
descrições de cargo em registro administrativo; a COD, sobre uma
resposta de entrevista. A granularidade de cada uma responde ao seu
instrumento de coleta.

As exceções à identidade com a ISCO-08 são poucas e concentradas:

``` r

cc[cc$correspondencia != "identidade",
   c("cod", "titulo", "isco08", "correspondencia")]
#>      cod                                   titulo isco08 correspondencia
#> 3   0411              Oficiais de polícia militar   5412       adaptacao
#> 4   0412    Graduados e praças da polícia militar   5412       adaptacao
#> 5   0511             Oficiais de bombeiro militar   5411       adaptacao
#> 6   0512 Graduados e praças do corpo de bombeiros   5411       adaptacao
#> 259 5168                    Trabalhadores do sexo   5169       adaptacao
#> 295 6225                               Pescadores   6220       agregacao
```

Quatro delas dizem respeito ao **policiamento**. A classificação
brasileira aloca oficiais e praças da polícia militar e do corpo de
bombeiros militar ao grande grupo 0 — o das forças armadas —, ocupando
subgrupos que a internacional deixa vazios. Com isso ela separa o
policial militar do não militar, pondo os dois em grandes grupos
diferentes.

As duas exceções restantes são de outra natureza, e a tabela as exibe.
Uma é uma categoria que a classificação brasileira nomeia e a
internacional não, conduzida ao código vizinho. A outra é a pesca: onde
a ISCO-08 distingue pesca costeira, de águas interiores e outras, a COD
mantém um código único, que só encontra destino no agregado.

Convém não atribuir à escolha sobre o policiamento uma intenção que a
fonte não declara. O IBGE registra que preservou nesse grupo o
detalhamento da classificação anterior “para melhor comparabilidade com
outras estatísticas de mercado de trabalho, em especial os registros
administrativos, classificados segundo a CBO 2002”. O grande grupo 0 é o
ponto em que a COD deliberadamente se afasta da ISCO-08 para se
aproximar da CBO. Que a estrutura resultante também registre o caráter
militarizado do policiamento ostensivo brasileiro é leitura possível — e
não é o motivo declarado.

## O cadastro do TSE, que não é uma classificação

**História e natureza.** O cadastro de ocupações do Tribunal Superior
Eleitoral difere das anteriores em natureza, não em tamanho. **Ele não é
uma classificação estatística.** É uma lista de opções de preenchimento
de formulário, mantida pela Corregedoria-Geral Eleitoral e publicada
como anexo de **Provimento** — não de Resolução. A sua finalidade é o
cadastro eleitoral, não a mensuração, e a diferença de propósito explica
todas as suas propriedades.

**Por que importa.** É a única fonte de ocupação das candidaturas
brasileiras. Quem quer estudar recrutamento político por posição social
não tem outra porta.

``` r

c(`códigos no dicionário do pacote (1998–2026)` = nrow(tse_isco),
  `sem correspondência na ISCO-88` = sum(is.na(tse_isco$isco88)),
  `rótulos distintos ao longo do tempo` = nrow(tse_ocupacao_rotulos))
#> códigos no dicionário do pacote (1998–2026) 
#>                                         275 
#>              sem correspondência na ISCO-88 
#>                                          17 
#>         rótulos distintos ao longo do tempo 
#>                                         334
```

### Quatro limites, em ordem de gravidade

**1. A escala.** A versão vigente do cadastro traz 257 códigos, contra
2.777 ocupações no domínio vigente da CBO-2002 (2.422 na edição de
2002). São instrumentos de ordens de grandeza distintas, e isso sozinho
impede tratar o código do TSE como equivalente ao da classificação
nacional. Uma tradução do TSE é, em boa parte, **agregada** — e é por
isso que
[`crosswalk_tse()`](https://moraespeixoto.github.io/ocupacoesBR/reference/crosswalk_tse.md)
traz a coluna `qualidade`:

``` r

table(crosswalk_tse()$qualidade, useNA = "ifany")
#> 
#> agregada  ambígua    exata     <NA> 
#>      195       52       11       17
```

Um cuidado ao ler essa coluna: ela resume **duas** etapas distintas, e a
segunda tem precedência. `"ambígua"` é decidido pela ponte ISCO-88 →
ISCO-08 (mais de um destino na tábua da OIT), e sobrepõe a informação
sobre o quanto a tradução TSE → ISCO-88 foi agregada. Por isso há
códigos traduzidos exatamente, a quatro dígitos, que aparecem como
`"ambígua"` — e a ambiguidade deles é da ponte, que é irrelevante para
quem usa o ISEI-88, a régua que o pacote recomenda. Para ler só a
agregação, use a coluna `nivel` de `tse_isco`.

**2. Não é autodocumentado.** O leiaute que acompanha os arquivos de
candidaturas descreve os campos de código e descrição da ocupação mas —
ao contrário do que faz para grau de instrução, estado civil e cor ou
raça — **não enumera os valores possíveis**. Quem precisa da tabela tem
de buscá-la na legislação da Corregedoria.

**3. O cadastro muda.** O Provimento de 2005 justifica-se, entre outros
motivos, pela necessidade de desmembrar grupos de ocupações anotados sob
um mesmo número. O de 2023 introduziu flexão de gênero em todas as
entradas. Nenhuma dessas alterações produz valor inválido em série
alguma — o que é justamente o problema.

``` r

table(tse_quebra_2002$tipo)
#> 
#>  redefinido    refinado   renomeado reutilizado 
#>          15          18           4           7
```

**4. E alguns códigos foram reaproveitados.** Sete deles passaram a
designar ocupação distinta:

``` r

r <- tse_quebra_2002[tse_quebra_2002$tipo == "reutilizado", ]
r[order(r$similaridade),
  c("cod_tse", "rotulo_ate_2000", "rotulo_apos_2002", "primeiro_ano_novo")]
#>    cod_tse                                               rotulo_ate_2000
#> 5      214                                           DELEGADO DE POLICIA
#> 6      391                                           CHEFE INTERMEDIARIO
#> 7      215        OCUPANTE DE CARGO DE DIRECAO E ASSESSORAMENTO SUPERIOR
#> 8      216               OFICIAIS DAS FORCAS ARMADAS E FORCAS AUXILIARES
#> 9      521 GOVERNANTA DE HOTEL, CAMAREIRO, PORTEIRO, COZINHEIRO E GARCOM
#> 13     158                                            DESENHISTA TÉCNICO
#> 25     211                                     PROCURADOR E ASSEMELHADOS
#>                         rotulo_apos_2002 primeiro_ano_novo
#> 5                      ESCULTOR E PINTOR              2006
#> 6               TAQUÍGRAFO E ESTENÓGRAFO              2006
#> 7        ARTISTA PLÁSTICO E ASSEMELHADOS              2006
#> 8  EMBALADOR, EMPACOTADOR E ASSEMELHADOS              2008
#> 9                             GOVERNANTA              2004
#> 13                TÉCNICO EM INFORMÁTICA              2006
#> 25  ESTIVADOR, CARREGADOR E ASSEMELHADOS              2006
```

Uma candidatura de 1998 traduzida pelo cadastro atual classifica um
ocupante de cargo de direção e assessoramento superior como **artista
plástico**, e um procurador como **estivador**. É o pior tipo de
descontinuidade: produz valor errado, em silêncio, com aparência de
normalidade — sem gerar `NA` nem código desconhecido.

É por isso que **toda função de tradução da porta do TSE aceita `ano`**
— as das outras portas não, porque a quebra é do cadastro eleitoral:

``` r

c(`214 em 1998` = tse_para_rotulo(214, ano = 1998),
  `214 em 2010` = tse_para_rotulo(214, ano = 2010))
#>           214 em 1998           214 em 2010 
#> "DELEGADO DE POLICIA"   "ESCULTOR E PINTOR"
```

A prova §7 de
[Robustez](https://moraespeixoto.github.io/ocupacoesBR/articles/robustez.md)
mostra o salto de escolaridade que confirma a reatribuição, e onde ele
não aparece.

## As quatro, lado a lado

|  | ISCO-88/08 | CBO-2002 | COD | Cadastro do TSE |
|----|----|----|----|----|
| **Quem mantém** | OIT | Ministério do Trabalho | IBGE | Corregedoria-Geral Eleitoral |
| **Para que foi feita** | comparar países | registro administrativo | pesquisa domiciliar | preencher formulário |
| **Unidade** | grupo de base | família ocupacional | grupo de base | opção de lista |
| **Âncora internacional** | é a âncora | ISCO-88 | ISCO-08 | nenhuma |
| **Ordem de grandeza** | centenas | milhares | centenas | dezenas a centenas |
| **Estável no tempo** | revisões declaradas | revisões declaradas | estável | **muda sem aviso** |
| **Tem tábua oficial para a ISCO** | — | sim, para a 88 | sim, para a 08 | **não existe** |

A última linha é a razão de este pacote existir. Para a CBO e para a COD
há documento oficial a seguir; para o cadastro do TSE não há, e a ponte
teve de ser construída código a código. É a única parte do pacote que
nenhuma autoridade externa confirma — e é por isso que ela vem com
rótulos, com régua de qualidade e com [validação contra critério
externo](https://moraespeixoto.github.io/ocupacoesBR/articles/validacao.md).

## Para seguir

- [Qual régua responde à sua
  pergunta](https://moraespeixoto.github.io/ocupacoesBR/articles/qual-regua.md)
  — as **medidas** construídas sobre estes endereços, e como escolher
  entre elas.
- [Robustez](https://moraespeixoto.github.io/ocupacoesBR/articles/robustez.md)
  — as provas de que as travessias entre elas fazem o que dizem fazer.
- [Antecedentes](https://moraespeixoto.github.io/ocupacoesBR/articles/antecedentes.md)
  — a linhagem em que este trabalho se inscreve, e o que nele é
  contribuição.
