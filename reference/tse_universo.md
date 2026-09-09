# O universo das candidaturas: quem o formulário deixa de fora, ano a ano

A decomposição do resíduo das candidaturas brasileiras, por safra e por
sexo.
[`checa_cobertura()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_cobertura.md)
diz *quanto* de um vetor recebe escore; esta tabela diz *de que é feito*
o que não recebe — e mostra que a resposta muda com o tempo e com o sexo
de quem se candidata.

## Usage

``` r
tse_universo
```

## Format

`data.frame` com 315 linhas:

- ano:

  a safra eleitoral, de 1998 a 2026.

- sexo:

  `"Homem"`, `"Mulher"` ou `"Todos"`. A linha `"Todos"` existe para que
  quem não se interessa por sexo não tenha de somar nada — e porque a
  soma correta não é óbvia quando o sexo falta em alguma safra.

- rubrica:

  a categoria do universo. Sete valores, na ordem em que a tabela os
  apresenta: `"Com escore"`, `"Ocupação sem escore"`,
  `"Vínculo público"`, `"Fora da força de trabalho"`,
  `"Inativo com trajetória"`, `"Outros (999)"` e `"Não informada"`.

- n:

  candidaturas na célula.

- pct:

  percentual dentro de `(ano, sexo)`. Somam 100 por construção.

## Source

Microdados de candidaturas do Tribunal Superior Eleitoral, 1998 a 2026,
pela microbase descrita em `data-raw/05a_microbase_2026.R`. Gerada por
`data-raw/13_gera_universo.R`. Os microdados **não** viajam com o
pacote; o que entra é esta tabela agregada, sem indivíduo e sem
identificador.

## As sete rubricas não são a mesma coisa

Descartá-las juntas como "sem escore" trata como ruído o que é, em quase
todos os casos, informação:

- **Com escore** — o código traduz a um ISCO-88 com ISEI, com `ano =`
  passado. É a base classificável.

- **Ocupação sem escore** — o rótulo nomeia uma ocupação e o escore não
  existe. O caso é `295 MEMBRO DAS FORÇAS ARMADAS`: o ISCO-88 `0110` não
  tem ISEI, e `NA` é a resposta certa.

- **Vínculo público** — `291 OCUPANTE DE CARGO EM COMISSÃO` e
  `296`/`297`/`298 SERVIDOR PÚBLICO FEDERAL/ESTADUAL/MUNICIPAL`. A
  pessoa **tem** ocupação e escolheu não a declarar. É a rubrica que
  quebra a comparação com a população, onde as mesmas pessoas declaram
  ocupação — veja `pct_setor_publico` em
  [isco_posicao_br](https://moraespeixoto.github.io/ocupacoesBR/reference/isco_posicao_br.md).

- **Fora da força de trabalho** — `581 DONA DE CASA` e
  `931 ESTUDANTE, BOLSISTA, ESTAGIÁRIO E ASSEMELHADOS`. Posição
  declarada, não omissão.

- **Inativo com trajetória** — aposentado, pensionista, militar
  reformado, capitalista de ativos financeiros. Há ocupação passada, e
  [`isei_retrospectivo()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isei_retrospectivo.md)
  recupera parte dela.

- **Outros (999)** — recusa de nomear. É a única rubrica que é ausência
  pura de informação, e é a que mais cresce.

- **Não informada** — códigos `-4`, `0` e `949`, ausência de registro.

## O buraco cresce, e não é o mesmo buraco

Duas leituras que a tabela permite e que uma taxa de cobertura única
esconde. A primeira: **a não declaração vai a zero a partir de 2006**, o
que indica preenchimento obrigatório do campo — e a recusa de nomear
assume o lugar dela. A rubrica `999` sai de 13,5% em 1998 e chega a
21,9% em 2024. A cobertura de 2024 (62,0%) é mais baixa que a de 2006
(73,2%) **sem que a tradução tenha piorado**: o que mudou foi o que se
declara.

A segunda: **a diferença de cobertura entre os sexos está quase toda
numa linha.** De 2004 em diante, `Fora da força de trabalho` é 1,2% das
candidaturas de homens e 14,6% das de mulheres. Descartar o resíduo
apaga mulheres em proporção muito maior, e isso inverte o sinal de
proporções de classe calculadas sobre a base cheia.

## O escore sai do pacote, com o ano

A rubrica `Com escore` é definida por `tse_para_isei(cod, ano = ano)`, e
o `ano` não é decorativo: sem ele, os sete códigos reaproveitados depois
de 2002 receberiam o escore da ocupação errada, e a tabela mediria a
cobertura de um erro. Veja
[tse_quebra_2002](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_quebra_2002.md)
e
[`checa_periodo()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_periodo.md).

## Examples

``` r
# A cobertura do escore, por safra — e o que a substitui quando ela cai.
u <- tse_universo
u[u$sexo == "Todos" & u$rubrica %in% c("Com escore", "Outros (999)"),
  c("ano", "rubrica", "pct")]
#>      ano      rubrica   pct
#> 15  1998   Com escore 64.67
#> 20  1998 Outros (999) 13.54
#> 36  2000   Com escore 61.39
#> 41  2000 Outros (999) 15.64
#> 57  2002   Com escore 70.77
#> 62  2002 Outros (999)  6.03
#> 78  2004   Com escore 64.97
#> 83  2004 Outros (999) 13.85
#> 99  2006   Com escore 73.20
#> 104 2006 Outros (999) 12.95
#> 120 2008   Com escore 72.25
#> 125 2008 Outros (999) 10.44
#> 141 2010   Com escore 69.22
#> 146 2010 Outros (999) 15.88
#> 162 2012   Com escore 64.26
#> 167 2012 Outros (999) 14.55
#> 183 2014   Com escore 67.52
#> 188 2014 Outros (999) 16.58
#> 204 2016   Com escore 62.88
#> 209 2016 Outros (999) 18.24
#> 225 2018   Com escore 66.67
#> 230 2018 Outros (999) 19.53
#> 246 2020   Com escore 61.30
#> 251 2020 Outros (999) 21.39
#> 267 2022   Com escore 69.67
#> 272 2022 Outros (999) 17.72
#> 288 2024   Com escore 62.04
#> 293 2024 Outros (999) 21.88
#> 309 2026   Com escore 73.31
#> 314 2026 Outros (999) 13.37

# A linha que explica a diferença de cobertura entre os sexos.
u[u$ano == 2024 & u$rubrica == "Fora da força de trabalho", ]
#>      ano   sexo                   rubrica     n  pct
#> 275 2024  Homem Fora da força de trabalho  2061 0.68
#> 282 2024 Mulher Fora da força de trabalho 15027 9.45
#> 289 2024  Todos Fora da força de trabalho 17088 3.69
```
