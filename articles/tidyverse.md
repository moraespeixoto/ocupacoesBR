# Com o tidyverse: o percurso inteiro dentro do mutate()

Toda função de tradução deste pacote recebe um vetor e devolve um vetor
do mesmo comprimento, sem estado e sem efeito colateral. É a única
propriedade que importa para o dplyr: uma função assim entra em
[`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html), em
[`summarise()`](https://dplyr.tidyverse.org/reference/summarise.html),
em [`across()`](https://dplyr.tidyverse.org/reference/across.html) e em
[`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html) sem
adaptação nenhuma. Este artigo percorre um pipeline inteiro, do código
bruto do TSE à tabela agregada, sem sair do pipe.

Os outros artigos cobrem outras coisas. [Comece
aqui](https://moraespeixoto.github.io/ocupacoesBR/articles/comece-aqui.md)
explica o que cada medida significa, e [Os
percursos](https://moraespeixoto.github.io/ocupacoesBR/articles/percursos.md)
mostra onde cada tradução se interrompe. Aqui o assunto é só a mecânica
de aplicar essas funções a um banco de verdade.

``` r

library(dplyr)
library(ocupacoesBR)
```

## A moldura de dados

O recorte abaixo usa os nomes de coluna do cadastro de candidaturas do
TSE e códigos de ocupação reais, escolhidos para cobrir estratos
diferentes. As pessoas são fictícias e identificadas só pelo
`SQ_CANDIDATO`; os rótulos nunca são digitados, e sim pedidos ao pacote
com
[`tse_para_rotulo()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_rotulo.md).

``` r

candidaturas <- tibble(
  SQ_CANDIDATO = 10001:10012,
  ANO_ELEICAO  = c(2026L, 2026L, 2022L, 2022L, 2022L, 2026L,
                   2026L, 2022L, 2026L, 2026L, 2010L, 1998L),
  CD_OCUPACAO  = c("111", "131", "601", "169", "257", "298",
                   "265", "532", "709", "278", "999", "214"),
  DS_CARGO     = c("DEPUTADO FEDERAL", "DEPUTADO FEDERAL", "DEPUTADO ESTADUAL",
                   "DEPUTADO ESTADUAL", "SENADOR", "DEPUTADO ESTADUAL",
                   "DEPUTADO ESTADUAL", "DEPUTADO ESTADUAL", "DEPUTADO ESTADUAL",
                   "DEPUTADO ESTADUAL", "DEPUTADO FEDERAL", "DEPUTADO FEDERAL"),
  SG_UF        = c("RJ", "SP", "MG", "BA", "SP", "RJ",
                   "CE", "PR", "PE", "GO", "AM", "RS")
)

candidaturas |>
  mutate(rotulo = tse_para_rotulo(CD_OCUPACAO, ano = ANO_ELEICAO)) |>
  select(CD_OCUPACAO, ANO_ELEICAO, rotulo)
#> # A tibble: 12 × 3
#>    CD_OCUPACAO ANO_ELEICAO rotulo                                      
#>    <chr>             <int> <chr>                                       
#>  1 111                2026 MÉDICO                                      
#>  2 131                2026 ADVOGADO                                    
#>  3 601                2022 AGRICULTOR                                  
#>  4 169                2022 COMERCIANTE                                 
#>  5 257                2022 EMPRESARIO                                  
#>  6 298                2026 SERVIDOR PÚBLICO MUNICIPAL                  
#>  7 265                2026 PROFESSOR DE ENSINO FUNDAMENTAL             
#>  8 532                2022 MOTORISTA DE VEÍCULOS DE TRANSPORTE DE CARGA
#>  9 709                2026 TRABALHADOR DE CONSTRUÇÃO CIVIL             
#> 10 278                2026 VEREADOR                                    
#> 11 999                2010 OUTROS                                      
#> 12 214                1998 DELEGADO DE POLICIA
```

A última linha já mostra a razão de o `ano` existir: o código 214 em
1998 não é o 214 de hoje.

## Uma coluna por régua, num só `mutate()`

Cada função de tradução vira uma coluna. Elas não conversam entre si,
então a ordem dentro do
[`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) é
indiferente e todas podem entrar de uma vez.

``` r

medidas <- candidaturas |>
  mutate(
    isco88    = tse_para_isco(CD_OCUPACAO, ano = ANO_ELEICAO),
    isco08    = tse_para_isco08(CD_OCUPACAO, ano = ANO_ELEICAO),
    isei      = tse_para_isei(CD_OCUPACAO, ano = ANO_ELEICAO),
    prestigio = tse_para_prestigio(CD_OCUPACAO, ano = ANO_ELEICAO),
    egp       = tse_para_egp(CD_OCUPACAO, ano = ANO_ELEICAO, avisar = FALSE),
    classe    = tse_para_classe(CD_OCUPACAO, ano = ANO_ELEICAO),
    estrato   = tse_para_estrato(CD_OCUPACAO, ano = ANO_ELEICAO)
  )
#> Warning: There were 7 warnings in `mutate()`.
#> The first warning was:
#> ℹ In argument: `isco88 = tse_para_isco(CD_OCUPACAO, ano =
#>   ANO_ELEICAO)`.
#> Caused by warning:
#> ! 1 candidatura(s) usam código(s) que o TSE REUTILIZOU depois (214): naquele ano designavam outra ocupação, e voltam NA.
#> Veja ?tse_vigencia.
#> ℹ Run `dplyr::last_dplyr_warnings()` to see the 6 remaining warnings.

medidas |> select(CD_OCUPACAO, isco88, isco08, isei, prestigio)
#> # A tibble: 12 × 5
#>    CD_OCUPACAO isco88 isco08  isei prestigio
#>    <chr>       <chr>  <chr>  <dbl>     <dbl>
#>  1 111         2221   2210      88        78
#>  2 131         2421   2611      85        73
#>  3 601         6100   6100      23        38
#>  4 169         1300   1400      51        50
#>  5 257         1200   1200      68        60
#>  6 298         NA     NA        NA        NA
#>  7 265         2330   2340      66        57
#>  8 532         8300   8300      32        33
#>  9 709         7100   7100      31        34
#> 10 278         1100   1110      70        67
#> 11 999         NA     NA        NA        NA
#> 12 214         NA     NA        NA        NA
```

O aviso que veio junto é da última linha, o 214 de 1998, e a próxima
seção é sobre ele. Ele reaparece a cada chamada que toca aquele código;
da seção do
[`across()`](https://dplyr.tidyverse.org/reference/across.html) em
diante este artigo o omite, para não repetir dez vezes a mesma frase.

As colunas categóricas são largas e ficam melhor à parte:

``` r

medidas |>
  mutate(rotulo = tse_para_rotulo(CD_OCUPACAO, ano = ANO_ELEICAO)) |>
  select(CD_OCUPACAO, classe, estrato) |>
  print(n = Inf)
#> # A tibble: 12 × 3
#>    CD_OCUPACAO classe                            estrato                
#>    <chr>       <chr>                             <chr>                  
#>  1 111         Profissionais de nível superior   Classe alta            
#>  2 131         Profissionais de nível superior   Classe alta            
#>  3 601         Trabalhadores rurais              Classes populares      
#>  4 169         Proprietários e empregadores      Classe alta            
#>  5 257         Proprietários e empregadores      Classe alta            
#>  6 298         Vínculo público não especificado  Vínculo público não es…
#>  7 265         Profissionais de nível superior   Classe alta            
#>  8 532         Operários e trabalhadores manuais Classes populares      
#>  9 709         Operários e trabalhadores manuais Classes populares      
#> 10 278         Dirigentes e políticos            Classe alta            
#> 11 999         Não informado                     Fora da PEA / não info…
#> 12 214         NA                                NA
```

O médico tem ISEI 88 e o trabalhador de construção civil, 31. As linhas
de servidor público municipal, “outros” e do 214 de 1998 saem com `NA`
no ISEI, e mesmo assim recebem classe: são os três motivos diferentes de
o pacote se abster, e [Comece
aqui](https://moraespeixoto.github.io/ocupacoesBR/articles/comece-aqui.md)
explica cada um.

## O `ano` é o que evita o erro silencioso

Sem o `ano`, o pacote aplica o cadastro vigente a partir de 2002 a todas
as linhas, inclusive às de 1998 e 2000. Compare as duas chamadas na
mesma tabela:

``` r

candidaturas |>
  filter(ANO_ELEICAO == 1998) |>
  mutate(
    rotulo_sem_ano = tse_para_rotulo(CD_OCUPACAO),
    rotulo_com_ano = tse_para_rotulo(CD_OCUPACAO, ano = ANO_ELEICAO),
    isei_sem_ano   = tse_para_isei(CD_OCUPACAO),
    isei_com_ano   = tse_para_isei(CD_OCUPACAO, ano = ANO_ELEICAO)
  ) |>
  select(starts_with("rotulo"), starts_with("isei")) |>
  glimpse()
#> Warning: There was 1 warning in `mutate()`.
#> ℹ In argument: `isei_com_ano = tse_para_isei(CD_OCUPACAO, ano =
#>   ANO_ELEICAO)`.
#> Caused by warning:
#> ! 1 candidatura(s) usam código(s) que o TSE REUTILIZOU depois (214): naquele ano designavam outra ocupação, e voltam NA.
#> Veja ?tse_vigencia.
#> Rows: 1
#> Columns: 4
#> $ rotulo_sem_ano <chr> "ESCULTOR E PINTOR"
#> $ rotulo_com_ano <chr> "DELEGADO DE POLICIA"
#> $ isei_sem_ano   <dbl> 54
#> $ isei_com_ano   <dbl> NA
```

A versão sem `ano` devolve um número plausível para uma ocupação que
aquela pessoa não tinha. Para descobrir isso antes de traduzir,
[`checa_periodo()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_periodo.md)
marca as posições atingidas e avisa. Ela devolve o vetor lógico
invisivelmente, o que a torna útil dentro do pipe:

``` r

candidaturas |>
  mutate(atingido = checa_periodo(CD_OCUPACAO, ANO_ELEICAO)) |>
  count(atingido)
#> Warning: There was 1 warning in `mutate()`.
#> ℹ In argument: `atingido = checa_periodo(CD_OCUPACAO, ANO_ELEICAO)`.
#> Caused by warning:
#> ! 1 candidatura(s) até 2000 usam código(s) que o TSE reutilizou em 2002 (214). Elas estão classificadas pelo cadastro NOVO e portanto erradas; veja ?checa_periodo.
#> # A tibble: 2 × 2
#>   atingido     n
#>   <lgl>    <int>
#> 1 FALSE       11
#> 2 TRUE         1
```

## `across()`, quando a mesma transformação vale para várias colunas

Como as funções são vetorizadas puras, elas entram em
[`across()`](https://dplyr.tidyverse.org/reference/across.html) como
qualquer outra. Duas formas são úteis. A primeira aplica várias
traduções à mesma coluna de códigos, nomeando o resultado pelo nome da
função:

``` r

candidaturas |>
  mutate(across(
    CD_OCUPACAO,
    list(isei = ~ tse_para_isei(.x, ano = ANO_ELEICAO),
         prestigio = ~ tse_para_prestigio(.x, ano = ANO_ELEICAO),
         isei08 = ~ tse_para_isei08(.x, ano = ANO_ELEICAO)),
    .names = "{.fn}"
  )) |>
  select(CD_OCUPACAO, isei, prestigio, isei08)
#> # A tibble: 12 × 4
#>    CD_OCUPACAO  isei prestigio isei08
#>    <chr>       <dbl>     <dbl>  <dbl>
#>  1 111            88        78   88.7
#>  2 131            85        73   86.7
#>  3 601            23        38   19.4
#>  4 169            51        50   51.0
#>  5 257            68        60   72.9
#>  6 298            NA        NA   NA  
#>  7 265            66        57   71.4
#>  8 532            32        33   26.8
#>  9 709            31        34   25.4
#> 10 278            70        67   74.5
#> 11 999            NA        NA   NA  
#> 12 214            NA        NA   NA
```

A segunda arruma de uma vez as colunas já traduzidas:

``` r

medidas |>
  mutate(across(c(isei, prestigio), \(x) round(x))) |>
  select(CD_OCUPACAO, isei, prestigio) |>
  head(4)
#> # A tibble: 4 × 3
#>   CD_OCUPACAO  isei prestigio
#>   <chr>       <dbl>     <dbl>
#> 1 111            88        78
#> 2 131            85        73
#> 3 601            23        38
#> 4 169            51        50
```

## Agregar por cargo, ano ou partido

Daqui em diante é dplyr comum. O cuidado que permanece é com o `NA`: ele
precisa aparecer na contagem, e não sumir dentro de um `na.rm = TRUE`
que ninguém relata.

``` r

medidas |>
  group_by(DS_CARGO) |>
  summarise(
    n         = n(),
    com_isei  = sum(!is.na(isei)),
    isei_medio = round(mean(isei, na.rm = TRUE), 1),
    .groups = "drop"
  )
#> # A tibble: 3 × 4
#>   DS_CARGO              n com_isei isei_medio
#>   <chr>             <int>    <int>      <dbl>
#> 1 DEPUTADO ESTADUAL     7        6       45.5
#> 2 DEPUTADO FEDERAL      4        2       86.5
#> 3 SENADOR               1        1       68
```

A coluna `com_isei` ao lado de `n` é o mínimo que se publica junto de
uma média de ISEI. Sem ela, a média descreve um subconjunto que o leitor
não conhece.

Nas variáveis categóricas,
[`count()`](https://dplyr.tidyverse.org/reference/count.html) já mostra
o `NA` sem ajuda:

``` r

medidas |> count(classe, sort = TRUE)
#> # A tibble: 8 × 2
#>   classe                                n
#>   <chr>                             <int>
#> 1 Profissionais de nível superior       3
#> 2 Operários e trabalhadores manuais     2
#> 3 Proprietários e empregadores          2
#> 4 Dirigentes e políticos                1
#> 5 Não informado                         1
#> 6 Trabalhadores rurais                  1
#> 7 Vínculo público não especificado      1
#> 8 NA                                    1
```

## A junção com o dicionário inteiro

Quando o que se quer não é uma medida e sim todas, mais a régua de
qualidade da tradução, o caminho é juntar com o dicionário.
[`crosswalk_tse()`](https://moraespeixoto.github.io/ocupacoesBR/reference/crosswalk_tse.md)
sem argumento devolve as 275 linhas do cadastro.

``` r

candidaturas |>
  left_join(crosswalk_tse(), by = c("CD_OCUPACAO" = "cod_tse")) |>
  select(CD_OCUPACAO, isco88, isei88, qualidade, nivel)
#> # A tibble: 12 × 5
#>    CD_OCUPACAO isco88 isei88 qualidade nivel
#>    <chr>       <chr>   <dbl> <chr>     <int>
#>  1 111         2221       88 ambígua       4
#>  2 131         2421       85 exata         4
#>  3 601         6100       23 agregada      2
#>  4 169         1300       51 agregada      2
#>  5 257         1200       68 agregada      2
#>  6 298         NA         NA NA           NA
#>  7 265         2330       66 agregada      3
#>  8 532         8300       32 agregada      2
#>  9 709         7100       31 agregada      2
#> 10 278         1100       70 agregada      2
#> 11 999         NA         NA NA           NA
#> 12 214         2452       54 exata         4
```

A `qualidade` diz como cada tradução foi obtida, e serve para restringir
a análise ao que é exato:

``` r

candidaturas |>
  left_join(crosswalk_tse(), by = c("CD_OCUPACAO" = "cod_tse")) |>
  count(qualidade)
#> # A tibble: 4 × 2
#>   qualidade     n
#>   <chr>     <int>
#> 1 agregada      7
#> 2 ambígua       1
#> 3 exata         2
#> 4 NA            2
```

Há uma ressalva importante nessa junção, e ela é o preço de usar a
tabela em vez das funções: **a junção não conhece o `ano`**. O
dicionário tem uma linha por código, com o cadastro vigente a partir de
2002, então a candidatura de 1998 recebe calada o rótulo novo do 214.

``` r

candidaturas |>
  filter(ANO_ELEICAO == 1998) |>
  left_join(crosswalk_tse(), by = c("CD_OCUPACAO" = "cod_tse")) |>
  select(ANO_ELEICAO, CD_OCUPACAO, rotulo, isei88)
#> # A tibble: 1 × 4
#>   ANO_ELEICAO CD_OCUPACAO rotulo            isei88
#>         <int> <chr>       <chr>              <dbl>
#> 1        1998 214         ESCULTOR E PINTOR     54
```

Para dado que cruza 2000 e 2002, junte pelo dicionário para inspecionar
e traduza pelas funções com `ano` para analisar.

## EGP com o que o TSE conhece

O EGP distingue quem supervisiona de quem não supervisiona, e o cadastro
do TSE não registra isso.
[`tse_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_egp.md)
calcula assim mesmo e avisa; o `avisar = FALSE` acima serviu para não
repetir o mesmo aviso em cada chunk deste artigo, depois de ele ter sido
explicado. Os dois argumentos que mudam o resultado são `n_classes`, que
colapsa o esquema, e `usa_proprietario`, que decide se a marca de
proprietário do dicionário entra na classificação.

``` r

egps <- candidaturas |>
  mutate(
    egp11 = tse_para_egp(CD_OCUPACAO, ano = ANO_ELEICAO, avisar = FALSE),
    egp7  = tse_para_egp(CD_OCUPACAO, ano = ANO_ELEICAO, n_classes = 7,
                         avisar = FALSE),
    egp7_sem_prop = tse_para_egp(CD_OCUPACAO, ano = ANO_ELEICAO, n_classes = 7,
                                 usa_proprietario = FALSE, avisar = FALSE)
  )

egps |> select(CD_OCUPACAO, egp11) |> print(n = Inf)
#> # A tibble: 12 × 2
#>    CD_OCUPACAO egp11                                    
#>    <chr>       <chr>                                    
#>  1 111         I: dirigentes e profissionais superiores 
#>  2 131         I: dirigentes e profissionais superiores 
#>  3 601         IVc: proprietário rural                  
#>  4 169         IVb: conta própria sem empregados        
#>  5 257         I: dirigentes e profissionais superiores 
#>  6 298         NA                                       
#>  7 265         II: dirigentes e profissionais inferiores
#>  8 532         VIIa: trabalhador manual não qualificado 
#>  9 709         VI: trabalhador manual qualificado       
#> 10 278         I: dirigentes e profissionais superiores 
#> 11 999         NA                                       
#> 12 214         NA
```

O `usa_proprietario` muda a classe só de quem o dicionário marca como
proprietário, e o
[`filter()`](https://dplyr.tidyverse.org/reference/filter.html) isola
essas linhas:

``` r

egps |>
  filter(egp7 != egp7_sem_prop) |>
  select(CD_OCUPACAO, egp7, egp7_sem_prop) |>
  as.data.frame()
#>   CD_OCUPACAO                                egp7
#> 1         601 IVc: agricultores por conta própria
#> 2         169             IVab: pequena burguesia
#>                   egp7_sem_prop
#> 1 VIIb: trabalhadores agrícolas
#> 2       I+II: classe de serviço
```

Agricultor e comerciante mudam de lado. É uma decisão de medida, e ela
deve ser declarada no texto do artigo que a usa.

## Cobertura, antes de analisar

[`checa_cobertura()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_cobertura.md)
falha com erro quando algum código do seu vetor não está no dicionário,
ou quando não há código nenhum. Ela é uma barreira, não uma
transformação, então o lugar dela no pipe é antes do
[`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html),
alimentada por um
[`pull()`](https://dplyr.tidyverse.org/reference/pull.html):

``` r

candidaturas |> pull(CD_OCUPACAO) |> checa_cobertura()
#> cobertura ok: 12 códigos observados, todos no dicionário.
```

Com um código que não existe no cadastro, o pipeline para:

``` r

candidaturas |>
  mutate(CD_OCUPACAO = if_else(row_number() == 1, "812", CD_OCUPACAO)) |>
  pull(CD_OCUPACAO) |>
  checa_cobertura()
#> Error:
#> ! código(s) de ocupação sem entrada no dicionário: 812.
#> Se forem códigos novos do TSE, abra uma issue no repositório do pacote — o dicionário precisa ser estendido, e não contornado.
```

Vale a pena parar assim. A alternativa é um vetor de `NA` que atravessa
a análise inteira sem chamar atenção, e quase sempre a causa é de
formato do código, não de dicionário: zeros à esquerda perdidos numa
leitura de CSV, ou um fator convertido para inteiro.

## Série longa, com a mesma pessoa em várias eleições

Quando a mesma pessoa se candidata mais de uma vez, um registro sem
ocupação classificável pode herdar o escore do registro anterior dela
própria.
[`isei_retrospectivo()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isei_retrospectivo.md)
recebe `escore`, `id` e `tempo`, e devolve um `data.frame` com o escore
final, a marca de herança e a defasagem.

O ponto que costuma escapar: **não use
[`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)**. A
função já corta na fronteira de cada `id`, e receber o painel inteiro é
o que lhe permite fazer isso. O que ela precisa é da ordenação, que o
[`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html)
garante.

``` r

painel <- tibble(
  SQ_CANDIDATO = c(rep(20001L, 4), rep(20002L, 4)),
  ANO_ELEICAO  = rep(c(2010L, 2014L, 2018L, 2022L), 2),
  CD_OCUPACAO  = c("131", "999", "999", "278",
                   "999", "111", "931", "999")
)

carregado <- painel |>
  arrange(SQ_CANDIDATO, ANO_ELEICAO) |>
  mutate(isei = tse_para_isei(CD_OCUPACAO, ano = ANO_ELEICAO)) |>
  mutate(ret = isei_retrospectivo(isei, SQ_CANDIDATO, ANO_ELEICAO,
                                  cod = CD_OCUPACAO, excluir = "931")) |>
  mutate(isei_cheio = ret$escore,
         herdado    = ret$herdado,
         defasagem  = ret$defasagem) |>
  select(-ret)

carregado |>
  select(SQ_CANDIDATO, ANO_ELEICAO, CD_OCUPACAO, isei,
         isei_cheio, herdado, defasagem) |>
  print(n = Inf)
#> # A tibble: 8 × 7
#>   SQ_CANDIDATO ANO_ELEICAO CD_OCUPACAO  isei isei_cheio herdado
#>          <int>       <int> <chr>       <dbl>      <dbl> <lgl>  
#> 1        20001        2010 131            85         85 FALSE  
#> 2        20001        2014 999            NA         85 TRUE   
#> 3        20001        2018 999            NA         85 TRUE   
#> 4        20001        2022 278            70         70 FALSE  
#> 5        20002        2010 999            NA         NA FALSE  
#> 6        20002        2014 111            88         88 FALSE  
#> 7        20002        2018 931            NA         NA FALSE  
#> 8        20002        2022 999            NA         88 TRUE   
#> # ℹ 1 more variable: defasagem <dbl>
```

Os códigos do painel são 131 para advogado, 111 para médico, 278 para
vereador, 931 para estudante e 999 para “outros”, que é o que não se
classifica.

O `excluir = "931"` deixa de fora estudante e estagiário, cuja posição
raramente se explica pelo passado. O primeiro registro de cada pessoa
nunca herda, porque só o passado da própria pessoa é usado.

A herança tem custo, e ele é grande: o escore herdado supõe que a
ocupação não mudou, e nas candidaturas ela muda em cerca de metade dos
casos, sempre com o erro apontando para o passado. Por isso `herdado` e
`defasagem` saem no resultado. Relate quantos escores são herdados e
repita a análise só com os observados:

``` r

carregado |> count(herdado)
#> # A tibble: 2 × 2
#>   herdado     n
#>   <lgl>   <int>
#> 1 FALSE       5
#> 2 TRUE        3
```

A documentação de
[`?isei_retrospectivo`](https://moraespeixoto.github.io/ocupacoesBR/reference/isei_retrospectivo.md)
traz as taxas medidas no painel completo de candidaturas, e a decisão de
usar ou não o carregamento deve passar por elas.

## O resumo, função por coluna

| Chamada dentro do mutate() | O que vira |
|:---|:---|
| tse_para_isco(cod, ano = ) | código ISCO-88, texto |
| tse_para_isco08(cod, ano = ) | código ISCO-08, texto |
| tse_para_isei(cod, ano = ) | ISEI, numérico de 16 a 90 |
| tse_para_prestigio(cod, ano = ) | prestígio de Treiman, numérico |
| tse_para_egp(cod, ano = ) | classe do EGP, texto; com rotulo = FALSE, o código |
| tse_para_classe(cod, ano = ) | classe do esquema do pacote, texto |
| tse_para_estrato(cod, ano = ) | estrato, texto |
| tse_para_rotulo(cod, ano = ) | rótulo do cadastro no ano, texto |
| checa_periodo(cod, ano) | lógico: a linha é atingida pela quebra de 2002 |
| isei_retrospectivo(escore, id, tempo) | data.frame com escore, herdado e defasagem |

Fora do pipe ficam duas:
[`checa_cobertura()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_cobertura.md),
que é barreira e recebe o vetor por
[`pull()`](https://dplyr.tidyverse.org/reference/pull.html), e
[`crosswalk_tse()`](https://moraespeixoto.github.io/ocupacoesBR/reference/crosswalk_tse.md),
que é tabela e entra por
[`left_join()`](https://dplyr.tidyverse.org/reference/mutate-joins.html).

## Onde continuar

A escolha entre ISEI, prestígio, EGP e o esquema de classes está em
[Qual régua responde à sua
pergunta](https://moraespeixoto.github.io/ocupacoesBR/articles/qual-regua.md).
Se a medida vai sustentar um resultado publicado, [A medida se
sustenta?](https://moraespeixoto.github.io/ocupacoesBR/articles/validacao.md)
mostra como confrontá-la com um critério externo que não entrou na sua
construção.
