# ISEI-08 da ocupação declarada ao TSE

Escore ISEI ancorado na ISCO-08, obtido pela ponte a partir do ISCO-88.

## Uso

``` r
tse_para_isei08(cod, ano = NULL)
```

## Argumentos

- cod:

  Vetor de códigos de ocupação do TSE (numérico ou texto).

- ano:

  Vetor opcional de anos de eleição, do mesmo comprimento de `cod`. Com
  ele, as candidaturas cujo código o TSE **reutilizou** depois voltam
  `NA` com aviso, em vez de traduzidas pelo dicionário errado: o código
  215 designava um cargo de direção até 2000 e passou a designar artista
  plástico. Sem ele, o comportamento é o de sempre. Veja
  [`tse_vigencia()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_vigencia.md).

## Valor

Vetor numérico com o escore ISEI-08.

## Quando *não* usar

Para comparar candidaturas entre si, prefira
[`tse_para_isei()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei.md),
na ISCO-88: o pacote é ancorado nela e a ponte introduz erro. O ISEI-08
serve para juntar o dado eleitoral a fontes que já classificam por
ISCO-08 — a PNAD Contínua, via COD, é o caso típico. As duas réguas
correlacionam-se fortemente no agregado
(`isei08 = 1,266 x isei88 - 12,72`, r = 0,97, n = 258), e a maior parte
das diferenças de 5 a 15 pontos é o próprio reescalonamento, não erro.
Esses coeficientes valem para a ponte **corrigida** por
`.corrige_isco08_tse()`; sem ela, seriam 1,212 e -9,80, e foram esses os
que esta seção publicou até a auditoria de 05/09/2026. Mas alguns
deslocamentos individuais são grandes **e reais**: o enfermeiro (código
113) sobe 26 pontos, de 43 para 68,7, porque a ISCO-08 promoveu a
enfermagem a profissão de nível superior (2221), separando-a dos
técnicos (3221); o vendedor e o comerciário (411, 170) caem 13, de 43
para 29,7, porque a revisão reavaliou o grupo 52 inteiro. Uma série que
troque de âncora no meio mede essas duas coisas como se fossem
mobilidade.

## Exemplos

``` r
data.frame(cod = c(111, 113), isei88 = tse_para_isei(c(111, 113)),
           isei08 = tse_para_isei08(c(111, 113)))
#>   cod isei88 isei08
#> 1 111     88   88.7
#> 2 113     43   68.7
```
