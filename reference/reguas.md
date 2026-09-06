# Qual régua responde a qual pergunta

Uma linha por medida de posição social oferecida pelo pacote, com a
pergunta que ela responde, o que ela mede e quando **não** usá-la.

## Usage

``` r
reguas
```

## Format

`data.frame` com nove linhas e as colunas:

- medida:

  nome curto da régua.

- tipo:

  `continua`, `categorica` ou `ordinal`.

- ancora:

  a classificação em que a régua está ancorada: ISCO-88, ISCO-08, a PNAD
  Contínua de 2025 ou o próprio cadastro do TSE.

- escala:

  o intervalo ou o número de categorias. Para as réguas contínuas é o
  intervalo **observado** nas tabelas do pacote, calculado no momento da
  geração, não digitado.

- funcao_tse:

  a porta de entrada pela ocupação declarada ao TSE.

- outras_portas:

  as demais funções que chegam à mesma régua, separadas por vírgula;
  `NA` quando a medida só existe pela porta do TSE.

- pergunta:

  a pergunta de pesquisa que a régua responde.

- mede:

  o que a régua mede, em uma linha.

- quando_nao_usar:

  a armadilha própria daquela régua — a razão pela qual ela é a escolha
  errada para certas perguntas.

- fonte:

  de onde a régua vem.

- ver:

  onde ler o assunto por inteiro.

## Source

Destilada da documentação do próprio pacote — as seções de
[`tse_para_isei()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei.md),
[`tse_para_isei_br()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei_br.md),
[`tse_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_egp.md),
[`tse_para_estrato()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_estrato.md)
e
[`tse_para_componente_alta()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_componente_alta.md),
e a vinheta
[`vignette("qual-regua")`](https://moraespeixoto.github.io/ocupacoesBR/articles/qual-regua.md).
É a única tabela do pacote que não deriva de fonte externa, e por isso
não entra na auditoria de proveniência. Gerada por
`data-raw/12_gera_reguas.R`; o que a mantém em dia com o pacote é o
teste que amarra as funções citadas aqui aos exports reais, nas duas
direções.

## Details

As réguas não são intercambiáveis, e a facilidade de trocar uma pela
outra é o principal risco de usar este pacote: a troca custa uma letra
no nome da função e não produz erro nenhum. Escolha pela pergunta, e
diga qual escolheu. Esta tabela existe para que esse critério seja
consultável — filtrável por tipo, por âncora ou por porta de entrada — e
não apenas legível em prosa.

## O que a tabela não diz, porque não é por régua

Quatro regras valem para todas e não cabem em nenhuma linha. `NA` não é
zero, e o padrão de ausência é fortemente generificado — cerca de 15%
das mulheres declaram posição fora da PEA, contra pouco mais de 1% dos
homens —, de modo que média por grupo exige reportar a cobertura junto.
O argumento `ano` resolve a quebra de cadastro de 2002, e sem ele uma
candidatura de 1998 é traduzida pelo dicionário errado em silêncio.
[`checa_cobertura()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_cobertura.md)
e
[`checa_periodo()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_periodo.md)
são `opt-in` e devem ser chamadas antes da análise. E toda tradução
válida é, no mínimo, a dois dígitos: pelo primeiro dígito a
correspondência inverte classes inteiras.

## See also

[`vignette("qual-regua")`](https://moraespeixoto.github.io/ocupacoesBR/articles/qual-regua.md),
[`crosswalk_tse()`](https://moraespeixoto.github.io/ocupacoesBR/reference/crosswalk_tse.md)

## Examples

``` r
# As réguas contínuas, e por onde se entra nelas
reguas[reguas$tipo == "continua", c("medida", "ancora", "funcao_tse")]
#>         medida                       ancora           funcao_tse
#> 1      ISEI-88                      ISCO-88        tse_para_isei
#> 2      ISEI-08                      ISCO-08      tse_para_isei08
#> 3      ISEI-BR PNAD Continua 2025 (ISCO-08)     tse_para_isei_br
#> 4 Prestigio-88                      ISCO-88   tse_para_prestigio
#> 5 Prestigio-08                      ISCO-08 tse_para_prestigio08

# Antes de publicar EGP a partir do TSE, leia isto:
cat(strwrap(reguas$quando_nao_usar[reguas$medida == "EGP"], 72), sep = "\n")
#> não publique onze classes a partir do TSE: sem número de subordinados,
#> IVa e IVb não se separam; colapse em 5 ou 3 para publicar; pela CBO e
#> pela COD o esquema sai degradado; com dado que tem as variáveis, como a
#> PNAD, funciona por inteiro

# Qual régua responde a uma pergunta sobre relação de emprego?
reguas[grep("emprego", reguas$pergunta), c("medida", "funcao_tse")]
#>   medida   funcao_tse
#> 6    EGP tse_para_egp
```
