# Patrimônio por trás dos códigos que são autodescrição

Quantis do patrimônio declarado, por código de ocupação e cargo
disputado, para os dez códigos de
[tse_codigos_autorrotulo](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_codigos_autorrotulo.md)
mais o 131 (ADVOGADO), que entra como contraexemplo ancorado. Sustenta o
argumento de
[`tse_para_componente_alta()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_componente_alta.md)
sobre a assimetria de confiabilidade entre as duas metades da classe
alta.

## Uso

``` r
tse_autorrotulo_patrimonio
```

## Formato

`data.frame` com 8 colunas:

- cod_tse:

  código de ocupação do TSE, texto.

- rotulo:

  rótulo do código, vigente após 2002.

- cargo:

  cargo disputado, fator na ordem da hierarquia e não na alfabética. O
  nível `"TODOS"` **não é um cargo**: é a linha agregada do código, e
  existe porque uma razão entre quantis não se recupera das células.

- ancorado:

  `TRUE` para o 131, cujo rótulo pressupõe inscrição na OAB; `FALSE`
  para os dez autodeclarados.

- n:

  candidaturas com patrimônio declarado positivo na célula.

- p10, mediana, p90:

  quantis do patrimônio, em reais.

## Fonte

Declaração de bens das candidaturas ao TSE, 2006–2024, agregada por
`data-raw/10_gera_autorrotulo.R`. Mesma microbase e mesma deflação de
[tse_dispersao_patrimonio](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_dispersao_patrimonio.md);
2026 não entra porque a declaração de bens daquela safra ainda não está
fechada.

## Por que esta tabela existe

Ela não acrescenta fato novo — os números já estavam em
[`?tse_para_componente_alta`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_componente_alta.md).
O que ela acrescenta é que eles passam a ser **executados**. Digitados,
erraram duas vezes: entraram com a agregação de bens que somava cada bem
duas vezes e sobreviveram intactos à correção de 09/2026, porque ninguém
revisita um número que não roda. A auditoria de 05/09/2026 os encontrou
ainda dobrados. Agora a documentação lê a tabela, e uma troca de fonte
se propaga sozinha.

## O contraste

Os dois regimes de rótulo têm gradiente por cargo — quem disputa posto
mais alto é mais rico nos dois casos. O que os separa é a **dispersão
interna**: na linha `"TODOS"`, o ADVOGADO tem a **menor** razão entre
p90 e p10 de todos os códigos da tabela (47,8), e os autodeclarados vão
de 55,1 a 75,6. É um único caso ancorado contra cinco autodeclarados,
então isto é uma ilustração e não um teste. Mas é esse contraste, e não
a diferença de mediana, que torna o 257 menos confiável que o 131 de um
jeito que nenhuma tabela de escores mostra.

## Corte e sigilo

Células com menos de 30 candidaturas ficam de fora (atributo `n_min`). O
que se publica são três quantis por célula: não há candidatura, não há
município, não há ano. Os atributos `anos` e `n_obs` guardam o período e
a amostra.

## Veja também

[`tse_para_componente_alta()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_componente_alta.md),
que interpreta esta tabela;
[tse_codigos_autorrotulo](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_codigos_autorrotulo.md),
a lista dos códigos;
[tse_dispersao_patrimonio](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_dispersao_patrimonio.md),
para a dispersão dentro do nível de status.

## Exemplos

``` r
p <- tse_autorrotulo_patrimonio
# o gradiente do "empresário" por cargo
p[p$cod_tse == "257", c("cargo", "n", "mediana")]
#>                 cargo      n mediana
#> 25           VEREADOR  80829  185000
#> 26           PREFEITO  10691  812544
#> 27  DEPUTADO ESTADUAL   5275  410824
#> 28 DEPUTADO DISTRITAL    289  420496
#> 29   DEPUTADO FEDERAL   2772  646282
#> 30            SENADOR     95 4678498
#> 31         GOVERNADOR     66 3548117
#> 32              TODOS 100017  229468

# a dispersão interna, autodeclarado contra ancorado
a <- p[p$cargo == "TODOS", ]
data.frame(a["rotulo"], a["ancorado"], razao = round(a$p90 / a$p10, 1))
#>                   rotulo ancorado razao
#> 8               ADVOGADO     TRUE  47.8
#> 14           COMERCIANTE    FALSE  55.1
#> 19            INDUSTRIAL    FALSE  73.6
#> 24 PRODUTOR AGROPECUARIO    FALSE  72.0
#> 32            EMPRESARIO    FALSE  75.6
#> 37            PECUARISTA    FALSE  62.8
```
