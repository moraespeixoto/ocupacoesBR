# A população brasileira pelos endereços da ISCO-88, por piso de elegibilidade

O denominador. A distribuição da população brasileira de 18 anos ou mais
pelos códigos ISCO-88, a partir da COD da PNAD Contínua, com a parcela
que **não está ocupada** como linha da própria tabela — e não como
ausência dela. É o outro lado de
[tse_universo](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_universo.md),
na mesma forma, para que comparar candidatura com população seja uma
junção de duas linhas.

## Usage

``` r
cod_populacao_br
```

## Format

`data.frame` com 3.811 linhas:

- piso:

  o piso etário de elegibilidade: 18, 21, 30 ou 35 anos. **São pisos,
  não faixas** — cada um é a população inteira daquela idade em diante,
  e por isso se sobrepõem.

- sexo:

  `"Homem"`, `"Mulher"` ou `"Todos"`.

- isco88:

  código ISCO-88 de quatro dígitos. `NA` nas duas linhas que não são
  ocupação.

- situacao:

  `"Ocupado"`, `"Não ocupado"` ou `"Ocupado sem endereço na ISCO-88"`
  (0,01% — a COD cobre quase tudo).

- pop:

  pessoas estimadas, com o peso da PNAD Contínua.

- n_pessoas:

  pessoas distintas na amostra, atrás da estimativa. É a coluna de
  precisão, e **704 das 3.811 linhas têm menos de 30**.

- pct:

  percentual dentro de `(piso, sexo)`. Somam 100 por construção.

## Source

Microdados da PNAD Contínua trimestral, IBGE, quatro trimestres de 2025.
Gerada por `data-raw/07b_gera_populacao.R`. Os microdados **não** viajam
com o pacote (212 MB por trimestre); o que entra é esta tabela agregada,
sem indivíduo e sem identificador.
<https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Trimestral/Microdados/>

## É estimativa de amostra com peso, e é de 2025

Isto não é um censo. Cada `pop` é uma estimativa da PNAD Contínua dos
**quatro trimestres de 2025**, com o peso `V1028` dividido pelo número
de trimestres, e carrega o erro amostral que `n_pessoas` deixa medir. Ao
contrário das tábuas de conversão do pacote, que não envelhecem, **esta
tabela envelhece**: uma distribuição de 2025 lida daqui a alguns anos
descreve um país que mudou. Declare o ano ao usá-la.

O pacote não faz desenho amostral. Se você precisa de erro-padrão, de
intervalo de confiança ou de subpopulação, o caminho é o microdado com
survey — esta tabela dá o ponto, não a incerteza.

## O piso é a decisão que mais move o denominador

Os quatro pisos são os do art. 14 §3º da Constituição: 18 anos para
vereador, 21 para prefeito e deputado, 30 para governador, 35 para
senador e presidente. A parcela que não está ocupada muda com o piso, e
não pouco:

|         |        |          |       |
|---------|--------|----------|-------|
| piso    | homens | mulheres | todos |
| 18 anos | 27,0%  | 48,1%    | 38,0% |
| 21 anos | 26,0%  | 47,7%    | 37,3% |
| 30 anos | 27,8%  | 49,9%    | 39,4% |
| 35 anos | 30,3%  | 52,3%    | 42,0% |

Quem compara candidatos ao Senado com "a população" sem escolher o piso
erra o denominador em quatro pontos, e a diferença entre os sexos é de
mais de vinte.

## As duas fontes perdem quase a mesma gente, por motivos opostos

Medida sobre a população de 18 anos ou mais, a cobertura do ISEI é de
**61,8%**; medida sobre as candidaturas de 2024,
[tse_universo](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_universo.md)
registra **62,0%**. Os números quase coincidem e as razões não têm nada
em comum: a população perde quem não está ocupado, o Tribunal perde quem
marcou uma rubrica que não nomeia ocupação. Trocar o denominador sem
dizer troca o resultado sem avisar. É o assunto do artigo *Comparar duas
fontes*, no site do pacote:
<https://moraespeixoto.github.io/ocupacoesBR/articles/comparar-fontes.html>

## A chave passou pela ponte reversa

A PNAD classifica por COD, e a chave desta tabela é a ISCO-88: o script
percorre COD -\> ISCO-08 -\> ISCO-88, e o segundo passo é a ponte que
[`isco08_para_isco88()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco08_para_isco88.md)
documenta como voltando ao ponto de partida em apenas 69% dos códigos.
Quem descer ao código de quatro dígitos deve saber disso, e olhar
`n_pessoas` antes de ler a célula.

## Examples

``` r
# O universo, declarado: quem está ocupado e quem não está.
p <- cod_populacao_br
aggregate(pct ~ situacao, p[p$piso == 18 & p$sexo == "Todos", ], sum)
#>                          situacao    pct
#> 1                     Não ocupado 38.008
#> 2                         Ocupado 61.988
#> 3 Ocupado sem endereço na ISCO-88  0.006

# A composição da população ocupada pelo grande grupo, no piso de vereador.
o <- p[p$piso == 18 & p$sexo == "Todos" & p$situacao == "Ocupado", ]
round(tapply(o$pop, substr(o$isco88, 1, 1), sum) / sum(o$pop) * 100, 1)
#>    0    1    2    3    4    5    6    7    8    9 
#>  0.3  7.6 12.9  9.3  9.3 15.4  4.8 12.9  9.6 17.9 

# A célula que só existe porque a tabela guarda quatro dígitos: a polícia
# militar, que a COD aloca ao grande grupo 0 e cod_para_isco() devolve ao 5.
p[p$isco88 %in% c("5161", "5162") & p$piso == 18, ]
#>     piso   sexo isco88 situacao    pop n_pessoas   pct
#> 174   18  Homem   5161  Ocupado 109788       476 0.141
#> 175   18  Homem   5162  Ocupado 503349      2115 0.646
#> 492   18 Mulher   5161  Ocupado  19834        94 0.023
#> 493   18 Mulher   5162  Ocupado  75038       368 0.089
#> 809   18  Todos   5161  Ocupado 129622       570 0.080
#> 810   18  Todos   5162  Ocupado 578387      2483 0.356
```
