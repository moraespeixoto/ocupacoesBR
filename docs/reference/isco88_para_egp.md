# Traduz ISCO-88 no esquema de classes EGP

Implementação das sintaxes `iskopromo.sps` e `iskoegp.sps` do
International Stratification and Mobility File, de Ganzeboom e Treiman.

## Uso

``` r
isco88_para_egp(
  isco,
  conta_propria = NULL,
  n_supervisionados = NULL,
  n_classes = 11,
  rotulo = TRUE,
  avisar = TRUE
)
```

## Argumentos

- isco:

  Vetor de códigos ISCO-88, preferencialmente com quatro dígitos.
  Códigos de 2 ou 3 dígitos são expandidos com zeros à DIREITA, para as
  formas arredondadas que as tabelas do ISMF já contêm (24 vira 2400). O
  grande grupo 0 (forças armadas) é a exceção: o ISMF o escreve com zero
  à ESQUERDA (`0110`), de modo que `110` é ambíguo. Nesses casos a
  função lê a forma hierárquica e **avisa**; informe quatro dígitos para
  desempatar.

- conta_propria:

  Vetor lógico opcional: a pessoa trabalha por conta própria ou é
  empregadora (`TRUE`) ou é empregada (`FALSE`).

- n_supervisionados:

  Vetor numérico opcional com o número de pessoas supervisionadas.

- n_classes:

  Número de classes do resultado: 11 (padrão), 7, 5 ou 3.

- rotulo:

  Se `TRUE` (padrão), devolve rótulos — em todas as versões, inclusive
  nas colapsadas; se `FALSE`, os códigos inteiros.

- avisar:

  Se `TRUE` (padrão), avisa quando `conta_propria` ou
  `n_supervisionados` não são fornecidos.

## Valor

Vetor de texto (ou inteiro, se `rotulo = FALSE`).

## O que o EGP exige e o TSE não tem

O EGP não é uma função só da ocupação. As suas regras usam duas
variáveis adicionais: a posição na ocupação (`conta_propria`) e o número
de pessoas supervisionadas (`n_supervisionados`). Sem elas, **IVa e IVb
— a pequena burguesia — ficam estruturalmente vazias**, e V (técnicos de
nível inferior e supervisores manuais) sai fortemente subestimada,
porque só dois códigos ISCO a produzem sem a variável de supervisão.
Como o formulário do TSE pergunta apenas a ocupação, quem parte dele
obtém uma versão degradada do esquema, e a função avisa quando é esse o
caso.

Partindo só da ocupação, o resultado **não deve ser publicado como uma
tabela EGP de onze classes**. Os colapsos de 5 e 3 classes, em que IVa e
IVb se fundem a categorias que existem, são o uso defensável.

Essa não é uma limitação do pacote, e sim do dado: é exatamente o ponto
que Carvalhaes (2015) levanta ao avaliar o EGP no Brasil, onde a
categoria de conta própria é a que o esquema melhor capta — e é
justamente a que se perde.

## Os colapsos de 7, 5 e 3 classes

Vêm da tabela "The class schema" de Erikson e Goldthorpe (1992), pp.
38–39. Cuidado ao comparar com outras implementações: várias numeram IVc
na sétima posição, e os vetores parecem divergir quando na verdade
concordam.

## Referências

Erikson, R.; Goldthorpe, J. H. (1992). "The class schema", em *The
Constant Flux: A Study of Class Mobility in Industrial Societies*.
Oxford: Clarendon Press, pp. 38–39.

Ganzeboom, H. B. G.; Treiman, D. J. (1996). Internationally comparable
measures of occupational status for the 1988 International Standard
Classification of Occupations. *Social Science Research*, 25(3),
201–239.

Carvalhaes, F. (2015). A tipologia ocupacional
Erikson-Goldthorpe-Portocarero (EGP): uma avaliação analítica e
empírica. *Sociedade e Estado*, 30(3), 673–703.

## Exemplos

``` r
isco88_para_egp(c("2211", "1300", "6100"), avisar = FALSE)
#> [1] "I: dirigentes e profissionais superiores" 
#> [2] "II: dirigentes e profissionais inferiores"
#> [3] "VIIb: trabalhador agrícola"               

# com as variáveis que o esquema realmente pede, a pequena burguesia aparece
isco88_para_egp(c("5220", "5220"),
                conta_propria = c(TRUE, TRUE),
                n_supervisionados = c(0, 5))
#> [1] "IVb: conta própria sem empregados" "IVa: conta própria com empregados"
```
