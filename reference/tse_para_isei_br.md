# ISEI-BR: status ocupacional estimado em dado brasileiro

Escore de status ocupacional obtido refazendo o procedimento de
Ganzeboom, De Graaf e Treiman (1992) sobre a PNAD Continua de 2025, em
vez de importar os escores calculados por eles em dado estrangeiro. Esta
funcao entra pela ocupacao declarada ao TSE; as irmas entram pela COD
([`cod_para_isei_br()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cod_para_isei_br.md)),
pela CBO-2002
([`cbo2002_para_isei_br()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_isei_br.md))
e pela propria ISCO-08
([`isco08_para_isei_br()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco08_para_isei_br.md)).
Nao ha porta pela CBO-94, e a razao esta em
[cbo94_isco88](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo94_isco88.md).

## Usage

``` r
tse_para_isei_br(cod, ano = NULL)
```

## Arguments

- cod:

  Vetor de códigos de ocupação do TSE (numérico ou texto).

- ano:

  Vetor opcional de anos de eleição, do mesmo comprimento de `cod`. Com
  ele, as candidaturas cujo código o TSE **reutilizou** depois voltam
  `NA` com aviso, em vez de traduzidas pelo dicionário errado: o código
  215 designava um cargo de direção até 2000 e passou a designar artista
  plástico. Sem ele, o comportamento é o de sempre. Veja
  [`tse_vigencia()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_vigencia.md).

## Value

Vetor numerico com o escore ISEI-BR, entre 10 e 90.

## O que esta regua e e o que ela nao e

O ISEI trata a ocupacao como o meio pelo qual a escolaridade se converte
em renda, e da a cada ocupacao o escore que melhor cumpre esse papel de
intermediario. O ISEI-88 e o ISEI-08 que este pacote tambem oferece
foram estimados assim, mas em dado de outros paises. O ISEI-BR e o mesmo
metodo estimado aqui, sobre 655.787 observacoes de 339.181 pessoas.

Ele **nao substitui** o ISEI-08. Comparacao internacional continua
exigindo a ancora internacional, e uma serie nao pode trocar de regua no
meio. O ISEI-BR responde a outra pergunta: como o mercado de trabalho
brasileiro de hoje, e nao um escalonamento unico de dezesseis paises com
dado brasileiro de 1973 e 1982, ordena as ocupacoes.

Duas coisas precisam ser ditas por quem usa. A primeira e que a mediacao
nao e completa: no Brasil a ocupacao explica cerca de 58% do efeito da
escolaridade sobre a renda, e o resto e escolaridade que paga dentro da
mesma ocupacao. Os valores exatos estao nos atributos de
[isco08_isei_br](https://moraespeixoto.github.io/ocupacoesBR/reference/isco08_isei_br.md).
A segunda e que a escala vem de um ano so, 2025, e nao forma serie.

Codigos finos com menos de 30 pessoas na amostra herdam o escore do
grupo acima. A coluna `nivel` de
[isco08_isei_br](https://moraespeixoto.github.io/ocupacoesBR/reference/isco08_isei_br.md)
diz quais.

## References

Ganzeboom, H. B. G., De Graaf, P. M., & Treiman, D. J. (1992). A
standard international socio-economic index of occupational status.
*Social Science Research*, 21(1), 1-56.

## See also

[isco08_isei_br](https://moraespeixoto.github.io/ocupacoesBR/reference/isco08_isei_br.md)
para a tabela e o metodo;
[`tse_para_isei08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei08.md)
para a ancora internacional;
[`vignette("validacao")`](https://moraespeixoto.github.io/ocupacoesBR/articles/validacao.md)
para a comparacao das duas contra o patrimonio dos candidatos.

## Examples

``` r
data.frame(cod    = c(111, 113, 601),
           rotulo = tse_para_rotulo(c(111, 113, 601)),
           isei08 = tse_para_isei08(c(111, 113, 601)),
           isei_br = tse_para_isei_br(c(111, 113, 601)))
#>   cod     rotulo isei08 isei_br
#> 1 111     MÉDICO  88.70    87.7
#> 2 113 ENFERMEIRO  68.70    66.1
#> 3 601 AGRICULTOR  19.41    28.8
```
