# ocupacoesBR: da ocupação brasileira a medidas padronizadas de posição social

Traduz a ocupação para a ISCO-88 e a ISCO-08 e, a partir delas, para o
ISEI, o SIOPS, o EGP e um esquema de classes e estratos desenhado para o
dado eleitoral.

## Details

Duas portas de entrada, que levam ao mesmo lugar:

- TSE:

  [`tse_para_isco()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isco.md)
  e companhia, para o código de ocupação declarado nas candidaturas.

- CBO:

  [`cbo2002_para_isco()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_isco.md)
  e companhia, para a Classificação Brasileira de Ocupações usada na
  RAIS, no CAGED e no eSocial; e
  [`cbo94_para_isco()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo94_para_isco.md)
  para microdado anterior a 2003.

O esquema de classes e estratos
([`tse_para_classe()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_classe.md),
[`tse_para_estrato()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_estrato.md))
existe só para a porta do TSE: ele depende de categorias que o registro
eleitoral cria — proprietários nomeados pelo próprio código de ocupação
e vínculo público sem função — e que não têm equivalente na CBO.

Toda tabela de conversão é **gerada por script** a partir dos arquivos
originais guardados em `inst/extdata/fontes/`, nunca transcrita à mão. O
script está em `data-raw/01_gera_dados.R` e pode ser reexecutado para
reconferir qualquer valor contra a sua fonte.

## Para quem lê por máquina

O pacote traz um resumo operacional de uma página, escrito para ser lido
inteiro antes da primeira chamada — a gramática dos nomes, o contrato de
chamada e as três maneiras de obter um resultado errado e silencioso:

    system.file("llm", "GUIA_AGENTE.md", package = "ocupacoesBR")

A escolha da régua, que é o erro mais caro, está em forma consultável em
[reguas](https://moraespeixoto.github.io/ocupacoesBR/reference/reguas.md).

## See also

Useful links:

- <https://github.com/moraespeixoto/ocupacoesBR>

- <https://moraespeixoto.github.io/ocupacoesBR/>

- Report bugs at <https://github.com/moraespeixoto/ocupacoesBR/issues>

## Author

**Maintainer**: Vitor Peixoto <moraespeixoto@gmail.com>
([ORCID](https://orcid.org/0000-0001-6618-3311))

Authors:

- Vitor Peixoto <moraespeixoto@gmail.com>
  ([ORCID](https://orcid.org/0000-0001-6618-3311))
