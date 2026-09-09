# Códigos cujo rótulo é autodescrição, sem registro externo que o valide

Os códigos de ocupação do TSE que designam **propriedade ou
empreendimento** — empresário, comerciante, industrial, proprietário de
estabelecimento — e que, por isso, não são ancorados em nenhum registro.
Servem para rodar uma análise com e sem eles, em uma linha.

## Usage

``` r
tse_codigos_autorrotulo
```

## Format

Vetor de texto com os códigos.

## Por que estes e não outros

O critério é **a priori, não empírico**: existe um registro externo que
precisa ser satisfeito para que alguém use o rótulo? "Advogado"
pressupõe inscrição na OAB, "médico" pressupõe CRM; "empresário" não
pressupõe nada. Não é uma afirmação sobre a honestidade de quem declara,
e sim sobre a existência de uma trava externa.

Este critério é conceitual porque **o dado não o produz sozinho**. A
dispersão de patrimônio dentro do código, por exemplo, não separa os
dois grupos: é de 76 vezes (p90/p10) entre os que declaram empresário e
de 55 entre os comerciantes, que são autorrótulos, mas de 48 entre os
advogados, que não é — e o comerciante fica **entre** os outros dois.
Patrimônio é disperso em toda parte. O que distingue não é a dispersão
bruta, é a ausência da trava.

Estes três números saem de
[tse_autorrotulo_patrimonio](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_autorrotulo_patrimonio.md)
e são conferidos contra ela em `tests/testthat/test-numeros-doc.R`. A
versão anterior dizia 80, 47 e 54: eram os valores da agregação que
somava cada bem duas vezes, corrigida em 09/2026, e sobreviveram por
estarem digitados.

## Como usar

Os escores destes códigos não são inválidos — são menos confiáveis do
que os ancorados, e a diferença não aparece na tabela, porque um ISEI de
68 é impresso do mesmo jeito venha de onde vier. A recomendação é
tratá-los como análise de sensibilidade:

    d$isei <- tse_para_isei(d$cod)
    d$isei_ancorado <- ifelse(d$cod %in% tse_codigos_autorrotulo, NA, d$isei)
    # rode a sua análise com as duas colunas e relate as duas

São **13,3%** das candidaturas de 1998 a 2026 — o bastante para mover um
resultado, e por isso o bastante para valer o teste.

## Relação com `tse_isco$proprietario`

Hoje os dois conjuntos coincidem, mas respondem a perguntas diferentes,
e por isso são objetos diferentes: `proprietario` é **pertença de
classe** (define quem entra em "Proprietários e empregadores"); este é
**confiabilidade de medida** (define de quem o escore é autodeclarado).
É a mesma distinção que separou `proprietario` de `conta_propria`, e
pela mesma razão: quando dois conceitos compartilham um vetor, mexer num
arrasta o outro.

## See also

[`tse_para_componente_alta()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_componente_alta.md),
que documenta a assimetria de confiabilidade entre as duas metades da
classe alta.

## Examples

``` r
tse_codigos_autorrotulo
#>  [1] "169" "206" "234" "257" "602" "901" "902" "903" "904" "905"
tse_para_rotulo(tse_codigos_autorrotulo)
#>  [1] "COMERCIANTE"                                                      
#>  [2] "INDUSTRIAL"                                                       
#>  [3] "PRODUTOR AGROPECUARIO"                                            
#>  [4] "EMPRESARIO"                                                       
#>  [5] "PECUARISTA"                                                       
#>  [6] "PROPRIETÁRIO DE ESTABELECIMENTO AGRÍCOLA, DA PECUÁRIA E FLORESTAL"
#>  [7] "PROPRIETÁRIO DE ESTABELECIMENTO COMERCIAL"                        
#>  [8] "PROPRIETÁRIO DE ESTABELECIMENTO INDUSTRIAL"                       
#>  [9] "PROPRIETÁRIO DE ESTABELECIMENTO DE PRESTAÇÃO DE SERVICOS"         
#> [10] "PROPRIETÁRIO DE MICROEMPRESA"                                     
```
