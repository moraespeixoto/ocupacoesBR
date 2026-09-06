# Posição na ocupação por código ISCO-88, medida na PNAD Contínua

A distribuição brasileira de posição no emprego — conta própria,
empregador, número de empregados — para cada código ISCO-88, apurada nos
microdados da PNAD Contínua de 2025.

## Usage

``` r
isco_posicao_br
```

## Format

`data.frame` com 319 linhas:

- isco88:

  código ISCO-88 de quatro dígitos.

- n_pessoas:

  pessoas distintas observadas (a medida honesta de precisão; veja a
  seção sobre o painel).

- n_obs:

  observações pessoa-trimestre.

- pct_conta_propria:

  % que trabalha por conta própria **ou** é empregadora — o `SEMPL = 2`
  das sintaxes do ISMF.

- pct_empregador:

  % que é empregadora.

- pct_emp_11mais:

  entre os empregadores, % com 11 ou mais empregados — o limiar que
  separa a ISCO 12 da 13. `NA` onde há menos de 25 empregadores na
  célula.

- grupo:

  o grande grupo de dois dígitos.

- n_pessoas_grupo, pct_conta_propria_grupo, pct_empregador_grupo:

  o mesmo, apurado no grupo de dois dígitos. Cada linha carrega a sua
  própria estimativa e a do grupo, para que quem cair numa célula fina
  possa recuar um nível sem refazer a conta — e veja, lado a lado, com
  que `n` cada uma foi apurada.

## Source

Microdados da PNAD Contínua trimestral, IBGE, quatro trimestres de 2025,
acessados em 28/07/2026.
<https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Trimestral/Microdados/>
Gerada por `data-raw/07_gera_posicao.R`. Os microdados **não** viajam
com o pacote (212 MB por trimestre); o que entra é esta tabela agregada.

## Para que serve

O EGP não é função só da ocupação: as regras do ISMF pedem a posição no
emprego e a supervisão. O formulário do TSE não pergunta nenhuma das
duas, e por isso o esquema sai degradado (veja
[`isco88_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_para_egp.md)).
Esta tabela é o **prior empírico** dessa variável ausente: não imputa a
posição de ninguém, e sim informa qual é a composição da ocupação no
país.

O uso legítimo é análise de sensibilidade — rodar o EGP com e sem a
posição provável e ver se a conclusão se move. O uso ilegítimo é tratar
a proporção como se fosse o caso individual.

## O painel rotativo

A PNAD reentrevista o mesmo domicílio por cinco trimestres. Os quatro
trimestres de 2025 somam 864.870 observações de **437.880 pessoas
distintas** (1,98x). Somá-los como amostras independentes inflaria o `n`
sem acrescentar informação na mesma proporção. Por isso os pesos são
divididos pelo número de trimestres — as estimativas são a média do ano
civil, com os pesos somando a população e não quatro vezes ela — e a
coluna de precisão é `n_pessoas`.

## O que ela mostra, e por que isso importa

A ISCO 61 é, na definição da OIT, quem **opera a própria terra**; a 92 é
o assalariado rural. O dado brasileiro separa as duas com folga:

|                             |                             |
|-----------------------------|-----------------------------|
| ISCO-88                     | conta própria ou empregador |
| 61 (agrícolas qualificados) | 67,6%                       |
| 6150 (pesca)                | 83,8%                       |
| 92 (rurais elementares)     | 16,5%                       |
| todas as ocupações          | 29,4%                       |

É a evidência externa que motivou separar `tse_isco$conta_propria` de
`tse_isco$proprietario`: o agricultor familiar trabalha por conta
própria sem pertencer à classe proprietária.

Como candidatos são selecionados por patrimônio, tomar estas proporções
como piso — e não como estimativa central — é a leitura conservadora.

## A tabela atravessa a ponte reversa

A PNAD classifica por COD, e a chave desta tabela é a ISCO-88, de modo
que `data-raw/07_gera_posicao.R` percorre COD -\> ISCO-08 -\> ISCO-88. O
segundo passo é a ponte reversa, que
[`isco08_para_isco88()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco08_para_isco88.md)
documenta como voltando ao ponto de partida em apenas 69% dos códigos. A
advertência existia lá e não aqui, que é onde quem usa esta tabela vai
olhar (auditoria de 05/09/2026).

Na prática o dano é pequeno, porque as linhas publicadas são grupos de
dois dígitos e a perda da ponte está sobretudo no quarto. Mas quem
descer ao código de quatro dígitos desta tabela deve saber que a chave
passou por uma tradução que não é bijetiva.

## Examples

``` r
# Dentro do mesmo ISCO convivem quem trabalha por conta própria e quem
# emprega. É esta tabela, medida na PNAD Contínua, que separa os dois — e
# foi ela que tirou o agricultor da classe alta.
p <- isco_posicao_br
head(p[order(-p$pct_conta_propria),
       c("isco88", "n_obs", "pct_conta_propria", "pct_empregador")], 5)
#>     isco88 n_obs pct_conta_propria pct_empregador
#> 172   5152    67             100.0            0.0
#> 191   6154     2             100.0            0.0
#> 107   3241   331              96.6            2.9
#> 229   7312    25              93.5            0.0
#> 295   9112  1892              92.1            0.9
```
