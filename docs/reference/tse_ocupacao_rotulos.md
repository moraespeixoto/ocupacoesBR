# Vigências do cadastro de ocupações do TSE, 1998–2026

Uma linha por **vigência**: o período em que um código carregou um dado
rótulo. Um código que nunca mudou de nome tem uma linha; um que mudou
tem uma por período. É a diferença entre um dicionário e a história de
um cadastro.

## Uso

``` r
tse_ocupacao_rotulos
```

## Formato

`data.frame` com 334 linhas e as colunas:

- cod_tse:

  código de ocupação.

- de, ate:

  primeiro e último ano de eleição em que a vigência valeu.

- rotulo:

  o `DS_OCUPACAO` como o TSE o escreveu, forma modal do período.

- n:

  candidaturas na vigência.

## Fonte

`DS_OCUPACAO` dos arquivos `consulta_cand` do TSE, 1998–2026 (3.368.921
candidaturas, campo 100% preenchido nas 15 eleições). A safra de 2026 é
a geração de 17/08/2026, 08:30, e é **aberta**: o prazo de registro
encerrou em 15/08/2026, mas o Tribunal ainda julga e publica
candidaturas, de modo que o `n` de 2026 há de crescer. O rótulo, que é o
que esta tabela guarda, não depende disso.

## Vigência não é presença

Um código sem candidato numa eleição continua na vigência: o contrário
faria uma ocupação rara "sumir e voltar" a cada pleito. A vigência se
interrompe quando o **rótulo** muda, não quando a frequência cai a zero.

## Exemplos

``` r
# O que as candidaturas mais declaram, em 1998--2026 somados:
r <- tse_ocupacao_rotulos
head(r[order(-r$n), c("cod_tse", "rotulo", "n")], 5)
#>     cod_tse                     rotulo      n
#> 334     999                     OUTROS 567118
#> 286     601                 AGRICULTOR 240684
#> 216     298 SERVIDOR PÚBLICO MUNICIPAL 212752
#> 82      169                COMERCIANTE 204676
#> 188     257                 EMPRESARIO 152512

# Os códigos vigentes na safra em curso:
sum(r$ate == 2026)
#> [1] 211

# Um código pode ter mais de uma vigência, com rótulos diferentes:
r[r$cod_tse == "215", ]
#>     cod_tse   de  ate                                                 rotulo
#> 139     215 1998 2000 OCUPANTE DE CARGO DE DIREÇÃO E ASSESSORAMENTO SUPERIOR
#> 140     215 2006 2026                        ARTISTA PLÁSTICO E ASSEMELHADOS
#>        n
#> 139  534
#> 140 1201
```
