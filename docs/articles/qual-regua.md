# Qual régua responde à sua pergunta

O pacote oferece quatro medidas com a mesma facilidade. Elas **não são
intercambiáveis**, e nenhuma delas é “a melhor” — cada uma responde a
uma pergunta diferente, e a facilidade de trocar uma pela outra é o
principal risco de usar este pacote.

Esta vinheta é sobre escolher. A ordem dos avisos abaixo é a ordem em
que as pessoas erram.

``` r
library(ocupacoesBR)
```

## 1. Escolha a régua pela pergunta

| se você quer saber… | use | o que ela mede |
|----|----|----|
| quanto uma posição converte educação em renda | [`tse_para_isei()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei.md) | **status socioeconômico**, contínuo |
| o quanto uma ocupação é socialmente estimada | [`tse_para_prestigio()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_prestigio.md) | **prestígio**, contínuo |
| a relação de emprego (quem contrata, quem é contratado) | [`tse_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_egp.md) | **classe relacional**, categórica |
| a estrutura de classes do dado eleitoral brasileiro | [`tse_para_classe()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_classe.md) | esquema próprio, categórico |

### ISEI e prestígio não são a mesma coisa

Correlacionam-se forte, e é justamente por isso que a diferença passa
despercebida:

``` r
cw <- crosswalk_tse()
ok <- !is.na(cw$isei88) & !is.na(cw$siops88)
round(cor(cw$isei88[ok], cw$siops88[ok]), 3)
#> [1] 0.944
```

Mas onde discordam, discordam na direção que importa:

``` r
cw$dif <- cw$siops88 - cw$isei88
d <- cw[ok, c("rotulo", "isei88", "siops88", "dif")]
rbind(head(d[order(d$dif), ], 3),
      head(d[order(-d$dif), ], 3))
#>                                        rotulo isei88 siops88 dif
#> 105 MINISTRO DO PODER JUDICIARIO E MAGISTRADO     90      76 -14
#> 168                                MAGISTRADO     90      76 -14
#> 14                                VETERINARIO     85      73 -12
#> 107                                JARDINEIRO     23      38  15
#> 238                                AGRICULTOR     23      38  15
#> 241                                  PESCADOR     23      38  15
```

O magistrado tem ISEI **90** e prestígio **76**: a posição converte
credencial em retorno melhor do que a sociedade a estima. O enfermeiro
faz o inverso — ISEI **43**, prestígio **54**.

**A consequência é direta.** Uma pesquisa sobre “quem tem posição de
topo no recrutamento” e outra sobre “quem é socialmente valorizado” vão
ordenar as profissões de saúde de formas diferentes, e as duas estarão
certas. Escolha antes de rodar, e diga qual escolheu.

## 2. `NA` não é zero, e a ausência é generificada

Dezessete dos 275 códigos não designam ocupação alguma — não informada,
fora da PEA, vínculo sem função —, e por isso não têm ISEI, prestígio
nem EGP:

``` r
sum(is.na(cw$isco88))
#> [1] 17
```

Isso **não** é falha de cobertura: é a resposta correta. O erro é tratar
esses casos como zero, ou tirá-los da conta sem dizer.

E há uma armadilha específica: o padrão de ausência é **fortemente
generificado**. Entre as candidaturas ao TSE, cerca de 15% das mulheres
declaram posição fora da PEA, contra pouco mais de 1% dos homens. Uma
média de ISEI por gênero, com `na.rm = TRUE`, compara duas subpopulações
truncadas de formas diferentes — e a “vantagem feminina em status” que
aparece é, em boa parte, artefato disso.

Quem for comparar médias por grupo **precisa reportar a cobertura
junto**:

``` r
# sempre, não às vezes
tapply(isei, genero, function(x) c(media = mean(x, na.rm = TRUE),
                                   cobertura = mean(!is.na(x))))
```

[`isei_retrospectivo()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isei_retrospectivo.md)
recupera parte disso carregando a ocupação anterior da própria pessoa —
a cobertura feminina sobe de 52,9% para 58,7%. Não resolve; reduz.

## 3. A régua categórica cobre onde a contínua não chega

Os mesmos 17 códigos sem ISEI **têm** classe:

``` r
table(cw$classe[is.na(cw$isco88)])
#> 
#>          Fora da PEA por posição           Inativo com trajetória 
#>                                2                                6 
#>    Militares e segurança pública                    Não informado 
#>                                1                                4 
#> Vínculo público não especificado 
#>                                4
```

“Inativo com trajetória” e “Vínculo público não especificado” são
posições sociais reconhecíveis; elas só não são pontos numa escala de
status. Se a sua pergunta comporta uma categoria residual nomeada, o
esquema categórico diz mais do que a escala contínua.

## 4. Categoria residual não é estrato

``` r
table(cw$estrato)
#> 
#>                      Classe alta                     Classe média 
#>                               88                               70 
#>                Classes populares      Fora da PEA / não informado 
#>                              101                               12 
#> Vínculo público não especificado 
#>                                4
```

“Fora da PEA / não informado” e “Vínculo público não especificado” **não
são estratos**. Somá-los a “Classes populares” — a tentação óbvia,
porque parecem “baixo” — inventa uma classe popular que não foi medida.
Eles ficam à parte de propósito.

## 5. Não publique EGP de onze classes a partir do TSE

O EGP exige posição no emprego **e** número de subordinados. O TSE não
pergunta o segundo:

``` r
tse_para_egp(c(111, 169, 601))
#> Warning: EGP calculado sem `n_supervisionados`. A divisão entre IVa (com
#> empregados) e IVb (sem) fica indeterminada — todos caem em IVb — e V fica
#> subestimada; para publicar prefira n_classes = 7 ou 5; veja ?isco88_para_egp.
#> [1] "I: dirigentes e profissionais superiores"
#> [2] "IVb: conta própria sem empregados"       
#> [3] "IVc: proprietário rural"
```

O aviso diz o que falta. Repare no que ele **não** diz mais: a pequena
burguesia aparece, porque dez códigos nomeiam o proprietário no próprio
rótulo e o pacote usa essa marca. O que continua indeterminado é a
divisão entre IVa (com empregados) e IVb (sem).

**Para publicar, colapse:**

``` r
table(tse_para_egp(tse_isco$cod_tse, n_classes = 5, avisar = FALSE),
      useNA = "no")
#> 
#>              I-III: colarinho branco              IVab: pequena burguesia 
#>                                  179                                    5 
#>                  IVc+VIIb: agrícolas     V+VI: trabalhadores qualificados 
#>                                    8                                   38 
#> VIIa: trabalhadores não qualificados 
#>                                   28
```

Em cinco classes, IVa e IVb se fundem em IVab e a indeterminação
desaparece.

Com dado que **tem** as variáveis — a PNAD Contínua tem —, o esquema
funciona por inteiro: veja
[`cod_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cod_para_egp.md).

## 6. Série longa: o cadastro do TSE mudou embaixo do dado

Entre 2000 e 2002 o TSE reeditou a tabela de ocupações. Sete códigos
passaram a designar **outra** ocupação:

``` r
q <- tse_quebra_2002[tse_quebra_2002$tipo == "reutilizado", ]
q[, c("cod_tse", "rotulo_ate_2000", "rotulo_apos_2002")]
#>    cod_tse                                               rotulo_ate_2000
#> 5      214                                           DELEGADO DE POLICIA
#> 6      391                                           CHEFE INTERMEDIARIO
#> 7      215        OCUPANTE DE CARGO DE DIRECAO E ASSESSORAMENTO SUPERIOR
#> 8      216               OFICIAIS DAS FORCAS ARMADAS E FORCAS AUXILIARES
#> 9      521 GOVERNANTA DE HOTEL, CAMAREIRO, PORTEIRO, COZINHEIRO E GARCOM
#> 13     158                                            DESENHISTA TÉCNICO
#> 25     211                                     PROCURADOR E ASSEMELHADOS
#>                         rotulo_apos_2002
#> 5                      ESCULTOR E PINTOR
#> 6               TAQUÍGRAFO E ESTENÓGRAFO
#> 7        ARTISTA PLÁSTICO E ASSEMELHADOS
#> 8  EMBALADOR, EMPACOTADOR E ASSEMELHADOS
#> 9                             GOVERNANTA
#> 13                TÉCNICO EM INFORMÁTICA
#> 25  ESTIVADOR, CARREGADOR E ASSEMELHADOS
```

Traduzir uma candidatura de 1998 pelo dicionário atual classifica um
ocupante de cargo de direção como artista plástico. Passe o ano e o
problema se resolve:

``` r
tse_para_classe(c("215", "215"), ano = c(2000, 2020))
#> Warning: 1 candidatura(s) usam código(s) que o TSE REUTILIZOU depois (215): naquele ano designavam outra ocupação, e voltam NA.
#> Veja ?tse_vigencia.
#> [1] NA                                "Profissionais de nível superior"
```

**E o problema maior nem é esse.** Mais frequente que a reutilização é a
troca de inventário — códigos que sumiram e códigos que nasceram:

``` r
table(tse_diff_cadastro(2000, 2002)$mudanca)
#> 
#>  criado extinto  rotulo 
#>      69      21      36
```

Comparando os períodos inteiros, são 13 códigos extintos (12,4% das
candidaturas de 1998–2000) e 122 criados (33,2% das de 2002 em diante),
entre eles `COMERCIANTE` e `EMPRESÁRIO`. Uma série que atravesse 2002
mede “Proprietários e empregadores” com dois vocabulários
incomensuráveis.

O caminho honesto é começar a série em 2004, ou declarar a
descontinuidade.

## 7. Não misture ISEI-88 e ISEI-08 na mesma série

``` r
data.frame(
  cod    = c("111", "113", "411"),
  rotulo = tse_para_rotulo(c("111", "113", "411")),
  isei88 = tse_para_isei(c("111", "113", "411")),
  isei08 = round(tse_para_isei08(c("111", "113", "411")), 1))
#>   cod                                      rotulo isei88 isei08
#> 1 111                                      MÉDICO     88   88.7
#> 2 113                                  ENFERMEIRO     43   68.7
#> 3 411 VENDEDOR DE COMÉRCIO VAREJISTA E ATACADISTA     43   29.7
```

O médico fica onde estava; o enfermeiro sobe 26 pontos, porque a ISCO-08
promoveu a enfermagem a profissão de nível superior (`2221`),
separando-a dos técnicos (`3221`); o vendedor cai 13, porque a revisão
reavaliou o grupo `52` inteiro. Não é erro de nenhuma das duas réguas:
são recortes diferentes. Numa série que troque de âncora no meio, os
dois deslocamentos aparecem como mobilidade que não houve.

**Fique na ISCO-88** para comparar candidaturas entre si — é onde o
pacote está ancorado. Use a ISCO-08 para juntar o dado eleitoral a
fontes que já a usam, e para análise de gênero, onde a revisão de 2008
corrigiu a subvalorização das ocupações de cuidado (veja
[`vignette("validacao")`](https://moraespeixoto.github.io/ocupacoesBR/articles/validacao.md)).

Desde a versão 0.5.0 há uma terceira régua,
[`tse_para_isei_br()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei_br.md),
estimada na PNAD Contínua em vez de importada. O aviso vale para ela
igualmente, e com uma razão a mais: as três não têm sequer o mesmo
denominador. A brasileira é de um ano só, 2025, e serve para perguntar
como o mercado de trabalho **brasileiro** ordena as ocupações. Para
comparação internacional, ou para qualquer série longa, ela não serve.

## 8. Verifique antes, não depois

As duas travas são **opt-in** e ficam fora do caminho feliz. Chame-as:

``` r
checa_cobertura(c(111, 169, 257))
#> cobertura ok: 3 códigos observados, todos no dicionário.
invisible(checa_periodo(c("215", "111"), c(2000, 2020)))
#> Warning: 1 candidatura(s) até 2000 usam código(s) que o TSE reutilizou em 2002
#> (215). Elas estão classificadas pelo cadastro NOVO e portanto erradas; veja
#> ?checa_periodo.
```

[`checa_cobertura()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_cobertura.md)
falha **com erro** se aparecer código fora do dicionário. O modo
silencioso de errar uma medida de classe não é classificar mal um caso:
é um código novo cair num rótulo residual sem ninguém perceber.

## 9. Nem todo escore tem a mesma procedência

Um ISEI de 68 sai impresso do mesmo jeito venha de onde vier. Mas
“advogado” pressupõe inscrição na OAB, e “empresário” não pressupõe
registro nenhum:

``` r
crosswalk_tse(c("131", "257"))[, c("cod_tse", "rotulo", "isei88", "componente_alta")]
#>   cod_tse     rotulo isei88   componente_alta
#> 1     131   ADVOGADO     85  Alta credenciada
#> 2     257 EMPRESARIO     68 Alta proprietária
```

Os dois entram na classe alta, e os dois escores saem com a mesma
tipografia — mas não com a mesma procedência. Para chegar a 85, é
preciso estar inscrito na OAB; para chegar a 68, basta escrever
“empresário” no formulário.

E o que esse 68 cobre: entre os que se declaram empresário, o patrimônio
mediano vai de R\$ 370 mil (candidatos a vereador) a R\$ 9,3 milhões
(candidatos a senador), e dentro do código os extremos distam **80
vezes**. Não é erro de medida: é uma **mistura** de duas populações — o
microempreendedor e o capitalista — sob um rótulo só. Nenhum escore
único está certo para as duas, e por isso trocar o 68 por outro número
não resolveria.

Isso não invalida o código; torna-o menos confiável que os ancorados, de
um jeito que a tabela não mostra. A saída é sensibilidade, não conserto:

``` r
d <- data.frame(cod = c("131", "257", "111", "265"))
d$isei <- tse_para_isei(d$cod)
d$isei_ancorado <- ifelse(d$cod %in% tse_codigos_autorrotulo, NA, d$isei)
d
#>   cod isei isei_ancorado
#> 1 131   85            85
#> 2 257   68            NA
#> 3 111   88            88
#> 4 265   66            66
```

São 13,3% das candidaturas. Rode com as duas colunas e relate as duas:
se a sua conclusão só aparece na primeira, ela depende de autodeclaração
sem âncora.

## Resumo

1.  Escolha a régua pela pergunta, e diga qual escolheu.
2.  `NA` é resposta, não ausência de resposta — e a ausência é
    generificada.
3.  Categoria residual não é estrato.
4.  EGP de onze classes a partir do TSE, não; de cinco, sim.
5.  Série que atravessa 2002 precisa de `ano`, ou de uma nota de rodapé.
6.  Uma âncora por série.
7.  [`checa_cobertura()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_cobertura.md)
    antes de analisar, sempre.
8.  Rótulo de propriedade não tem a confiabilidade de rótulo com
    registro — rode também sem `tse_codigos_autorrotulo`.
