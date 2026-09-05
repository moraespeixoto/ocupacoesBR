# ISEI-BR: status ocupacional estimado na PNAD Contínua

O ISEI que o pacote carregava era importado: Ganzeboom, De Graaf e
Treiman (1992) escalonaram a ISCO sobre dado de dezesseis países, nenhum
deles o Brasil. Esta tabela é o mesmo procedimento refeito do zero sobre
a PNAD Contínua de 2025. Ela fecha a lacuna que
[`vignette("validacao")`](https://moraespeixoto.github.io/ocupacoesBR/articles/validacao.md)
declarava em aberto.

## Uso

``` r
isco08_isei_br
```

## Formato

`data.frame` com 590 linhas, uma para cada chave de
[isco08_medidas](https://moraespeixoto.github.io/ocupacoesBR/reference/isco08_medidas.md),
e as colunas:

- isco08:

  código ISCO-08 de quatro dígitos.

- isei_br:

  escore, contínuo entre 10 e 90.

- n_pessoas:

  pessoas distintas na célula que forneceu o escore.

- n_obs:

  observações trimestrais nessa mesma célula.

- nivel:

  em quantos dígitos o escore foi apurado: 4 é a própria ocupação, 3, 2
  e 1 são grupos cada vez mais grossos.

- anos_estudo:

  média de anos de estudo na célula, sem residualizar.

- log_renda:

  média do log do rendimento habitual, sem residualizar.

Os atributos `theta`, `beta_direto`, `beta_total` e `parcela_mediada`
guardam os parâmetros da estimação.

## Fonte

PNAD Contínua trimestral, microdados dos quatro trimestres de 2025,
IBGE. Acesso em 05/09/2026. Gerada por `data-raw/09_gera_isei_br.R`; os
sha256 dos arquivos estão em `inst/extdata/PROVENIENCIA.yml`.

## Método

A ocupação entra como variável interveniente entre escolaridade e renda,
e o escore de cada ocupação é a combinação das médias de escolaridade e
de renda dos seus ocupantes que minimiza o efeito direto da escolaridade
sobre a renda. A amostra tem idade de 21 a 64 anos, ambos os sexos, pelo
menos 30 horas semanais no trabalho principal e rendimento habitual
positivo. Escolaridade e renda entram residualizadas em idade, idade ao
quadrado, sexo e trimestre. O peso é dividido pelo número de trimestres,
porque a PNAD é painel rotativo e a mesma pessoa reaparece.

## O resíduo, que é achado e não defeito

O procedimento de 1992 supõe que a ocupação medeia integralmente a
relação entre escolaridade e renda, e escolhe o ângulo onde o efeito
direto zera. No Brasil ele não zera. A curva tem mínimo interior e para
em 0,206, contra um efeito total de 0,494, de modo que a ocupação medeia
58,4% do efeito. Os outros 41,6% são escolaridade que paga dentro da
mesma ocupação, o que se lê como heterogeneidade intraocupacional e
informalidade. Adota-se o ângulo de mínimo e publica-se o resíduo.

## Sensibilidade

O ordenamento não depende do ângulo exato nem das escolhas de método. A
correlação de Spearman entre a escala no ângulo adotado e em mais ou
menos 0,15 radianos é de 0,999. Sete especificações alternativas foram
testadas, entre elas exigir 40 horas, dispensar a restrição de horas,
usar renda-hora, usar rendimento efetivo, restringir a homens como o
artigo de 1992 fez, e usar escolaridade em categorias: nenhuma move o
ordenamento abaixo de 0,99 contra a especificação adotada, e a parcela
mediada fica sempre entre 57,9% e 60,1%.

## O que se perde

A COD funde oficiais e praças de polícia e bombeiro militar, então a
escala não distingue os dois. Códigos da ISCO-08 em que nenhuma COD
aterrissa herdam o escore do grupo acima. Dos 407 códigos de quatro
dígitos, 348 têm escore próprio e 59 são herdados por terem menos de 30
pessoas na amostra. As outras 183 linhas são as formas arredondadas de
dois e três dígitos, que existem porque a ocupação declarada ao TSE é
grossa e aterrissa nelas.

## O que ela não é

Não é substituta do ISEI-08. Comparação internacional continua exigindo
a âncora internacional, e uma série não troca de régua no meio. É um ano
só, 2025, e não forma série.

## Referências

Ganzeboom, H. B. G., De Graaf, P. M., & Treiman, D. J. (1992). A
standard international socio-economic index of occupational status.
*Social Science Research*, 21(1), 1-56.

## Veja também

[`tse_para_isei_br()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei_br.md)
e as irmãs por COD, CBO-2002 e CBO-94.

## Exemplos

``` r
head(isco08_isei_br)
#>   isco08 isei_br n_pessoas n_obs nivel anos_estudo log_renda
#> 1   0000    66.2      1077  2063     1       13.98    8.6006
#> 2   0100    83.4       295   552     2       15.69    9.2848
#> 3   0110    83.4       295   552     3       15.69    9.2848
#> 4   0200    60.4       798  1511     2       13.40    8.3687
#> 5   0210    60.4       798  1511     3       13.40    8.3687
#> 6   0300    66.2      1077  2063     1       13.98    8.6006

# Concorda com a âncora internacional sem ser cópia dela.
f <- isco08_isei_br[isco08_isei_br$nivel == 4, ]
i <- isco08_medidas$isei08[match(f$isco08, isco08_medidas$isco08)]
round(stats::cor(f$isei_br, i, use = "complete.obs", method = "spearman"), 3)
#> [1] 0.894

# Os parâmetros da estimação viajam com a tabela.
attributes(isco08_isei_br)[c("theta", "parcela_mediada")]
#> $theta
#> [1] 1.0375
#> 
#> $parcela_mediada
#> [1] 58.4
#> 
```
