# Códigos de ocupação do TSE que mudaram de nome ou de sentido em 2002

O TSE reeditou a tabela de ocupações entre as eleições de 2000 e 2002.
Nem toda mudança de rótulo é problema, e é por isso que esta tabela tem
a coluna `tipo`: só `reutilizado` invalida a tradução. Use
[`checa_periodo()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_periodo.md)
para saber se o seu dado é atingido, e
[`tse_vigencia()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_vigencia.md)
para ver a história de um código.

## Uso

``` r
tse_quebra_2002
```

## Formato

`data.frame` com 44 linhas e as colunas:

- cod_tse:

  o código.

- rotulo_ate_2000, rotulo_apos_2002:

  como o TSE o chamava antes e depois.

- ultimo_ano_antigo, primeiro_ano_novo:

  as eleições comparadas.

- n_ate_2000:

  candidaturas com esse código até 2000.

- similaridade:

  sobreposição de palavras entre os dois rótulos (0 a 1).

- pct_superior_ate_2000, pct_superior_apos_2002, delta_pp:

  proporção com ensino superior completo em cada período, e a diferença.

- delta_vs_tendencia:

  `delta_pp` menos a tendência geral do período (+7,8 pp). `NA` onde há
  menos de 30 candidaturas em algum dos lados, que é pouco para o sinal
  significar coisa alguma.

- tipo:

  `reutilizado`, `renomeado`, `redefinido` ou `refinado`.

## Fonte

Rótulos e escolaridade das candidaturas de 1998 a 2026. Os valores de
`pct_superior_*` reproduzem exatamente os que a versão anterior desta
tabela trazia digitados à mão — que era a única tabela do pacote não
gerada por script, e deixou de ser.

## Por que `tipo` é um julgamento, e não uma fórmula

Há dois sinais disponíveis, e **nenhum dos dois basta**:

O rótulo `601` foi de "TRABALHADOR AGRÍCOLA" para "AGRICULTOR": muda
todo o léxico e é o mesmo ofício — a população sob o código nem se move
(+2,2 pp, abaixo da tendência). Tratá-lo como reutilização mandaria
descartar 52.090 candidaturas válidas.

O `215` foi de "OCUPANTE DE CARGO DE DIREÇÃO E ASSESSORAMENTO SUPERIOR"
para "ARTISTA PLÁSTICO": reutilização inequívoca que **não move a
escolaridade** (+6,5 pp), porque um DAS e um artista plástico têm perfil
de diploma parecido. Foi por isso que a versão anterior desta tabela,
que só olhava escolaridade, não o via — e ela documentava 3 códigos onde
há 7.

Quatro das sete reutilizações são invisíveis ao sinal de escolaridade. A
distinção é semântica, e nenhuma métrica automática a alcança. São 44
casos: o `tipo` foi julgado um a um, e o julgamento é **auditável na
própria tabela** — os dois rótulos viajam ao lado das duas evidências.

## O que fazer com cada tipo

- reutilizado (7 códigos, 1.628 candidaturas):

  o código passou a designar outra ocupação. Traduzir o período antigo
  pelo dicionário é erro; exclua ou reclassifique.

- renomeado (4):

  mesma ocupação, nome novo. Não é problema — está aqui para que ninguém
  a confunda com reutilização ao comparar rótulos.

- redefinido (15):

  o escopo mudou. Cautela.

- refinado (18):

  mesmo posto, rótulo mais preciso.

## Exemplos

``` r
# Os códigos reutilizados: o mesmo número, outra ocupação. Ler qualquer um
# deles como série contínua de 1998 a hoje produz uma trajetória que nunca
# existiu.
tse_quebra_2002[tse_quebra_2002$tipo == "reutilizado",
                c("cod_tse", "rotulo_ate_2000", "rotulo_apos_2002")]
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

# A que tipo pertence cada um dos 44:
table(tse_quebra_2002$tipo)
#> 
#>  redefinido    refinado   renomeado reutilizado 
#>          15          18           4           7 
```
