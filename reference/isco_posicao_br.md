# Posição na ocupação por código ISCO-88, medida na PNAD Contínua

A distribuição brasileira de posição no emprego — conta própria,
empregador, número de empregados, setor público, posição militar — para
cada código ISCO-88, apurada nos microdados da PNAD Contínua de 2025.

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

- pct_setor_publico:

  % empregada do setor público, inclusive empresas de economia mista
  (`V4012 == 4`). É a coluna que torna comparável, do lado da população,
  o vínculo público que o formulário do TSE oferece como rótulo — veja a
  seção "O vínculo público".

- pct_militar:

  % cuja **posição** declarada é militar (`V4012 == 2`). Leia a seção
  "Militar é duas coisas" antes de usar: esta coluna não é o grande
  grupo 0 da ISCO-88, e a diferença é o assunto.

- grupo:

  o grande grupo de dois dígitos.

- n_pessoas_grupo, pct_conta_propria_grupo, pct_empregador_grupo,
  pct_setor_publico_grupo, pct_militar_grupo:

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

## O vínculo público

O cadastro de ocupações do TSE oferece à pessoa quatro rótulos que
**substituem** a ocupação em vez de a nomear —
`291 OCUPANTE DE CARGO EM COMISSÃO` e
`296`/`297`/`298 SERVIDOR PÚBLICO FEDERAL/ESTADUAL/MUNICIPAL`. Nenhum
tem ISCO, e corretamente: não designam ocupação. Na PNAD Contínua as
mesmas pessoas **têm** ocupação declarada, porque vínculo e ocupação são
duas perguntas separadas. Medido nos quatro trimestres de 2025, o setor
público é 11,7% dos ocupados com endereço na ISCO-88, e se distribui
assim pelo grande grupo:

|                    |     |      |      |      |      |     |     |     |     |
|--------------------|-----|------|------|------|------|-----|-----|-----|-----|
| dígito             | 1   | 2    | 3    | 4    | 5    | 6   | 7   | 8   | 9   |
| % do setor público | 4,0 | 37,9 | 18,7 | 14,2 | 12,1 | 0,1 | 1,1 | 3,6 | 8,3 |

Quase quatro em dez estão no dígito 2, professores sobretudo. Uma
comparação de composição entre as duas fontes que não trate disso
compara um universo que exclui servidores com outro que os inclui. O
artigo *Comparar duas fontes*, no site do pacote, mede a consequência:
<https://moraespeixoto.github.io/ocupacoesBR/articles/comparar-fontes.html>

Esta coluna **não conserta o construto**, só o denominador: no TSE o
vínculo público é uma *escolha* de rótulo, feita por quem podia ter
escrito "professor"; aqui é a posição de quem *também* declarou a
ocupação.

## Militar é duas coisas, e elas discordam

O dicionário do IBGE define `V4012 == 2` como "militar do exército, da
marinha, da aeronáutica, **da polícia militar ou do corpo de bombeiros
militar**". Não é o grande grupo 0 da ISCO-88. Medido aqui: entre quem
declara essa posição, 39,9% cai no grande grupo 0 pelo código de
ocupação e 60,1% cai no 5, o dos serviços protetivos. **A pergunta sobre
posição e a pergunta sobre ocupação discordam sobre quem é militar no
Brasil**, e a discordância é a mesma que a COD registra ao alocar a
polícia militar e o bombeiro militar ao grande grupo 0 — adaptação que
[`cod_para_isco()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cod_para_isco.md)
desfaz, devolvendo 5162 e 5161.

A consequência prática: `pct_militar` não é o tamanho das forças armadas
(0,81% dos ocupados inclui o policiamento militar), e não deve ser
somada nem comparada com a parcela do grande grupo 0 como se fossem a
mesma coisa. Nenhuma das duas respostas é o erro da outra; são
construtos diferentes.

## As quatro colunas não se somam a 100

`pct_conta_propria`, `pct_setor_publico` e `pct_militar` são mutuamente
exclusivas — `V4012` vale 2, 4, 5 ou 6, e nunca duas ao mesmo tempo — e
a soma das três nunca passa de 100. O que sobra é empregado do setor
privado, trabalhador doméstico e trabalhador familiar auxiliar.
`pct_empregador` **não** entra nessa soma: é subconjunto de
`pct_conta_propria`.

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
