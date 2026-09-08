# Índice socioeconômico ISEI da ocupação declarada ao TSE

Devolve o escore ISEI (International Socio-Economic Index of
occupational status) de Ganzeboom, De Graaf e Treiman, ancorado na
ISCO-88.

## Uso

``` r
tse_para_isei(cod, ano = NULL)
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

Vetor numérico com o escore ISEI-88, ou `NA`. **Nem todo escore tem a
mesma procedência.** Um ISEI de 68 é impresso do mesmo jeito venha de
"advogado", que pressupõe inscrição na OAB, ou de "empresário", que não
pressupõe registro nenhum e cobre desde o microempreendedor até o
capitalista. Veja
[tse_codigos_autorrotulo](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_codigos_autorrotulo.md)
para rodar a sua análise com e sem esses códigos — são 13,3% das
candidaturas.

## Anomalias conhecidas da escala

O ISEI não é constante da natureza: é o escalonamento que maximiza o
efeito indireto da escolaridade sobre a renda **via ocupação**, estimado
por Ganzeboom, De Graaf e Treiman (1992) sobre dados internacionais dos
anos 1970–80. Duas consequências para quem usa a versão ancorada na
ISCO-88.

**A escala é enviesada contra ocupações femininas.** Regressão no nível
do código, ponderada por número de candidaturas (168 códigos com n \>=
500, dos quais 28 são majoritariamente femininos):

    ISEI = 38,6 + 0,469 x (% com superior) - 6,17 x (código majoritariamente feminino)
                                              (ep 3,03; p = 0,043)

**A credencial constante, um código feminino recebe 6,2 pontos de ISEI a
menos.** E não é que essas ocupações tenham menos escolaridade — têm
mais: 29,9% de superior contra 24,1%, com ISEI médio de 46,0 contra
49,0.

**O sinal é robusto; o `p` não.** A especificação acima pondera por
número de candidaturas, o que muda a população-alvo de códigos para
candidaturas — é escolha defensável, mas o erro-padrão de `lm` ponderado
não a descreve, e o ISEI é atributo determinístico do código, não
estimativa com variância inversa a `n`. Trocando a especificação: com
erro-padrão robusto (HC3) o coeficiente fica em −6,2 com p = 0,14; sem
ponderação, −5,3 com p = 0,012; com `pct_mulher` contínuo em vez da
dicotomia, −0,09 por ponto percentual com p = 0,08. O sinal e a ordem de
grandeza sobrevivem a todas; o `p = 0,043` é da primeira. Use o
intervalo de especificações, não o `p` pontual.

**E "viés" pede uma premissa que convém explicitar.** O ISEI pondera
escolaridade *e* renda, e ocupações femininas rendem menos com
credencial igual: a escala registra isso fielmente. Chamar de viés supõe
que status *deveria* seguir a credencial. Se o que se quer medir é
credencial, é viés; se é retorno, é fidelidade. A recomendação abaixo
vale nos dois casos, porque a ISCO-08 reestima o retorno sobre uma
população que inclui mulheres.

O caso emblemático é a enfermagem, que a ISCO-88 põe em `2230` com
**ISEI 43** — abaixo dos escriturários (`4100`, ISEI 45), apesar de ser
profissão universitária. A âncora da ISCO-08 corrige boa parte disso: o
mesmo posto recebe **68,7**.

Daí a recomendação prática: **para análise de gênero, prefira
[`tse_para_isei08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei08.md)**.
Ganzeboom rebalanceou saúde e cuidado na revisão de 2008. Isto qualifica
a defesa de que a ISCO-88 é "a escolha conservadora": ela está certa no
sinal, mas é conservadora *porque* a escala é enviesada contra ocupações
femininas, o que não é a mesma coisa que ser robusta.

**A relação com o critério externo não é linear nem monótona.** Veja
[`vignette("validacao")`](https://moraespeixoto.github.io/ocupacoesBR/articles/validacao.md):
a correlação entre ISEI e patrimônio é de 0,681 no nível da ocupação e
de apenas 0,207 no da candidatura, valor que
[tse_dispersao_patrimonio](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_dispersao_patrimonio.md)
permite recalcular. Uma medida de posição ocupacional explica a
variância *entre* ocupações e quase nada *dentro* de cada uma — por isso
**não use o ISEI como proxy de renda individual**.

## Referências

Ganzeboom, H. B. G.; De Graaf, P. M.; Treiman, D. J. (1992). A standard
international socio-economic index of occupational status. *Social
Science Research*, 21(1), 1–56.

## Veja também

[`tse_para_isei08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei08.md),
para a âncora da ISCO-08;
[isco_posicao_br](https://moraespeixoto.github.io/ocupacoesBR/reference/isco_posicao_br.md),
para a posição na ocupação;
[tse_codigos_autorrotulo](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_codigos_autorrotulo.md),
para a sensibilidade aos rótulos sem âncora;
[`vignette("qual-regua")`](https://moraespeixoto.github.io/ocupacoesBR/articles/qual-regua.md).

## Exemplos

``` r
tse_para_isei(c(111, 169, 257))
#> [1] 88 51 68
```
