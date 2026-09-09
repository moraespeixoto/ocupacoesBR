# Comentários para a submissão ao CRAN

## Verificação

`R CMD check --as-cran` na versão 0.8.0, x86_64-pc-linux-gnu (Ubuntu 26.04),
R 4.6.1: **0 ERROR, 0 WARNING, 2 NOTEs.** Os testes passam sem falha e sem
SKIP, e as vinhetas reconstroem.

A verificação foi feita **também** numa biblioteca sem nenhum dos pacotes
sugeridos (`testthat`, `knitr`, `rmarkdown`, `readxl`): o pacote instala,
carrega e traduz normalmente, e os exemplos de todas as páginas de ajuda rodam
sem erro. Nenhuma função exportada depende de um pacote sugerido. Nessa
biblioteca a suíte e as vinhetas naturalmente não rodam, porque `testthat` e
`knitr` são justamente o que falta ali.

## As duas NOTEs

**1. "New submission"**, de `checking CRAN incoming feasibility` — é o primeiro
envio do pacote.

**2. `checking HTML version of manual`** — a máquina de verificação local não
tem o `tidy` instalado, e o check informa que pulou a validação do HTML. É
propriedade da máquina, não do pacote; não ocorre nas máquinas do CRAN.

### O que deixou de aparecer, e por quê

**As três URLs com status 404**, até a 0.7.0. O repositório estava privado
enquanto o pacote passava por revisão, e o verificador do CRAN é anônimo: as
duas URLs do repositório e a do site de documentação respondiam 404 para
qualquer visitante. Em 09/09/2026 o repositório foi aberto e o GitHub Pages
passou a servir <https://moraespeixoto.github.io/ocupacoesBR/>. As três
resolvem, e a NOTE deixou de ocorrer — os campos `URL` e `BugReports` do
`DESCRIPTION` seguem como estavam.

**O erro de LaTeX no manual em PDF**, na própria 0.8.0, antes desta submissão.
Três ocorrências do sinal de menos matemático (U+2212) numa passagem de
`?tse_para_isei` que relata coeficientes negativos faziam o `pdflatex` parar com
"Unicode character not set up for use with LaTeX", o que produzia um WARNING e
um ERROR. Passaram a hífen ASCII, que é o que o LaTeX espera e o que o leitor
lê igual.


**"Suggests or Enhances not in mainstream repositories: DIGCLASS"**, até a
0.5.2. O `DIGCLASS` (Cimentada) é uma implementação independente das mesmas
sintaxes do ISMF, usada numa conferência cruzada do EGP — a única validação
deste pacote contra código que não é dele nem da fonte que ele próprio leu.

Ele não é distribuído por repositório algum: nem CRAN, nem Bioconductor, nem
r-universe. Instala-se do HEAD do GitHub. Por isso `Additional_repositories:`
não se aplica — o campo exige um repositório no formato do CRAN, com índice
`PACKAGES` —, e mantê-lo em `Suggests` fazia o `R CMD check` devolver

```
* checking package dependencies ... ERROR
Package suggested but not available: 'DIGCLASS'
```

em qualquer máquina que não o tivesse instalado, o que inclui as do CRAN.

Desde a 0.6.0 o `DIGCLASS` saiu de `Suggests` e o teste que o usa
(`tests/testthat/test-digclass.R`) está em `.Rbuildignore`: ele permanece no
repositório e roda no desenvolvimento, mas não viaja no pacote distribuído, que
não menciona o `DIGCLASS` em lugar nenhum. A versão e o *commit* contra os
quais a conferência foi feita ficam registrados em
`inst/extdata/PROVENIENCIA.yml`, seção `conferencia_cruzada`.

**"The Title field should be in title case"**, até a 0.2.1. Não era defeito do
título: o verificador aplicava a convenção de capitalização do inglês a uma
frase em português, cuja norma é a inversa. A partir da 0.3.0 o `DESCRIPTION`
declara `Language: pt-BR`, como a política do CRAN pede para pacote que não é
em inglês, e o aviso deixou de ocorrer. Declarar a língua era a correção certa;
capitalizar "Ao", "Em" e "Da" teria produzido um título agramatical.

## Materiais de terceiros

O pacote redistribui, em `inst/extdata/fontes/`, as sintaxes SPSS publicadas do
International Stratification and Mobility File (Ganzeboom & Treiman) e uma
cópia da tábua oficial de conversão do Ministério do Trabalho brasileiro.

Elas viajam com o pacote **por necessidade metodológica**: nenhuma tabela de
dados é digitada à mão, todas são geradas por script a partir dessas fontes, e
a suíte de testes confere as tabelas contra elas linha a linha, mais o `sha256`
de cada uma. Sem as fontes embarcadas, essa verificação não roda no ambiente de
check.

A autoria e as condições estão declaradas em `LICENSE.note`, que também viaja
com o pacote. As sintaxes do ISMF são distribuídas pelos autores para uso
público em pesquisa, com pedido expresso de citação, que `citation(
"ocupacoesBR")` atende: devolve o pacote **e** as referências das escalas. A
tábua do MTE é dado administrativo público, produzido e publicado por órgão do
Estado brasileiro.

## Dependências

Apenas `stats` e `utils` (base R). Nenhum código compilado.
