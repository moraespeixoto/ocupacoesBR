# Dispersão do patrimônio dentro de cada nível de status

Somatórios que reproduzem, sem microdado, a correlação entre o índice de
status e o patrimônio declarado **no nível da candidatura** — o número
que quantifica o que uma escala de posição ocupacional não explica.

## Uso

``` r
tse_dispersao_patrimonio
```

## Formato

`data.frame` com 29 linhas e 6 colunas:

- isei88:

  escore ISEI-88, que é discreto: cada código do dicionário tem um valor
  só, e a tabela agrupa por ele.

- n:

  candidaturas com escore e com patrimônio declarado positivo.

- soma_log:

  soma do logaritmo natural do patrimônio no grupo.

- soma_log2:

  soma dos quadrados desses logaritmos.

- media_log:

  média do log do patrimônio, arredondada.

- sd_log:

  desvio padrão do log do patrimônio DENTRO do grupo.

## Fonte

Declaração de bens das candidaturas ao TSE, 2006–2024, agregada por
`data-raw/08_gera_dispersao.R`. O patrimônio é deflacionado a reais de
outubro de 2024; 2026 não entra, pela razão exposta em
[tse_validacao](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_validacao.md).

## Por que somatórios e não os dados

O coeficiente de Pearson é função apenas de \\n\\, \\\sum x\\, \\\sum
y\\, \\\sum x^2\\, \\\sum y^2\\ e \\\sum xy\\. Como o ISEI é constante
dentro do grupo, essas seis quantidades se recuperam das colunas acima,
e o coeficiente sai **exato** — não aproximado. O que a tabela descarta
é tudo o que o coeficiente não usa, isto é, a candidatura individual. É
o que permite publicar o número mantendo a política de não distribuir
microdado de patrimônio.

## O contraste que a tabela existe para sustentar

No nível da **ocupação**, o ISEI correlaciona-se a 0,681 com o log da
mediana de patrimônio (veja
[tse_validacao](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_validacao.md)).
No nível do **indivíduo**, a 0,207. A queda não é defeito de medida: é a
definição operacional do que uma escala de posição ocupacional faz, que
é explicar a variação *entre* ocupações e quase nada *dentro* de cada
uma. A coluna `sd_log` mostra o fenômeno diretamente — o desvio padrão
do log do patrimônio dentro de um mesmo nível de status é da ordem de
1,7, isto é, uma ordem de grandeza. A consequência prática está em
[`tse_para_isei()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei.md):
**não use o ISEI como proxy de renda ou de patrimônio individual.**

## A unidade é a candidatura, não a pessoa

As 1.103.019 observações são candidaturas, de 767.015 pessoas distintas
entre 2006 e 2024 — a mesma pessoa entra até seis vezes. A documentação
chamava isso de "nível do indivíduo" até 05/09/2026, o que convidava a
tratar as observações como independentes. Para este número não há
consequência, porque ele é descritivo e não vem com erro padrão. Mas não
peça um intervalo de confiança a ele sem antes decidir o que fazer com a
repetição.

## Veja também

[tse_validacao](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_validacao.md),
para a validação no nível da ocupação.

## Exemplos

``` r
# A correlação individual, recuperada dos somatórios (exata):
d <- tse_dispersao_patrimonio
N <- sum(d$n); sx <- sum(d$isei88 * d$n); sy <- sum(d$soma_log)
sxx <- sum(d$isei88^2 * d$n); syy <- sum(d$soma_log2)
sxy <- sum(d$isei88 * d$soma_log)
round((N * sxy - sx * sy) /
        sqrt((N * sxx - sx^2) * (N * syy - sy^2)), 3)
#> [1] 0.207

# A dispersão dentro do nível de status, que é o mesmo fato visto de perto:
summary(d$sd_log)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>   1.375   1.619   1.700   1.713   1.805   2.053 
```
