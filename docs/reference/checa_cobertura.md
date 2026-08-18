# Verifica se todos os códigos observados estão no dicionário

Falha com erro se algum código de ocupação presente no seu dado não
tiver entrada no dicionário do pacote, **ou se não houver código
nenhum**. Chame antes de qualquer análise.

## Uso

``` r
checa_cobertura(cod, silencioso = FALSE)
```

## Argumentos

- cod:

  Vetor de códigos de ocupação observados no seu dado.

- silencioso:

  Se `TRUE`, não escreve a mensagem de sucesso.

## Valor

Invisivelmente, `TRUE`. Erro se houver código fora do dicionário ou se
não houver código válido algum.

## Por que isto existe

O modo silencioso de errar uma medida de classe não é classificar mal um
caso: é um código novo cair num rótulo residual sem que ninguém perceba.
Foi o que aconteceu na primeira versão deste dicionário, em que 76
códigos reais caíam no rótulo "fora da PEA" — inclusive proprietários,
que somem justamente da categoria em que mais importam.

O segundo modo silencioso é mais banal e mais comum: passar a coluna
errada. `dados$CD_OCUPACAO` num quadro cuja coluna se chama
`cd_ocupacao` devolve `NULL`, e uma verificação ingênua aprovaria o
vetor vazio. Por isso entrada vazia, `NULL` ou inteiramente ausente
também é erro aqui.

## Exemplos

``` r
checa_cobertura(c(111, 169, 257))
#> cobertura ok: 3 códigos observados, todos no dicionário.
try(checa_cobertura(c(111, 99999)))
#> Error : código(s) de ocupação sem entrada no dicionário: 99999.
#> Se forem códigos novos do TSE, abra uma issue no repositório do pacote — o dicionário precisa ser estendido, e não contornado.
try(checa_cobertura(NULL))
#> Error : nenhum código de ocupação válido em `cod` (o vetor é NULL — confira o nome da coluna).
```
