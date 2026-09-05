# Comentários para a submissão ao CRAN

## Verificação

`R CMD check --as-cran` na versão 0.6.0, x86_64-pc-linux-gnu (Ubuntu 26.04):
**0 ERROR, 0 WARNING, 1 NOTE.** Os testes passam sem falha e sem SKIP.

A verificação foi feita **também** numa biblioteca sem os pacotes sugeridos e
com `_R_CHECK_FORCE_SUGGESTS_=true`, para reproduzir o ambiente do CRAN.

## A NOTE

Vem de `checking CRAN incoming feasibility` e traz dois pontos.

**1. "New submission"** — é o primeiro envio do pacote.

**2. URLs com status 404.** São três, todas pelo mesmo motivo: o repositório
está privado enquanto o pacote passa por revisão, e o verificador do CRAN é
anônimo. Duas apontam para o repositório e para o rastreador de problemas; a
terceira, `https://moraespeixoto.github.io/ocupacoesBR/`, é o site de
documentação, que o GitHub Pages só passa a servir depois que o repositório for
aberto. As três resolvem no mesmo momento. Se esta submissão ocorrer antes
disso, os campos `URL` e `BugReports` serão removidos do `DESCRIPTION`.

### O que deixou de aparecer, e por quê

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
