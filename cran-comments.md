# Comentários para a submissão ao CRAN

## Verificação

`R CMD check --as-cran` na versão 0.3.0, x86_64-pc-linux-gnu (Ubuntu 26.04):
**0 ERROR, 0 WARNING, 2 NOTEs.**

A segunda NOTE é do ambiente de verificação, não do pacote: `checking HTML
version of manual` avisa que o utilitário `tidy` não está instalado na
máquina e pula a validação do HTML. Ela não aparece num ambiente com o
`tidy` presente.

## Sobre a NOTE

A NOTE vem de `checking CRAN incoming feasibility` e reúne três pontos, todos
esperados:

**1. "New submission"** — é o primeiro envio do pacote.

**2. "Suggests or Enhances not in mainstream repositories: DIGCLASS"** — o
`DIGCLASS` está em `Suggests` e entra apenas numa conferência cruzada da suíte
(`test-fonte.R`), protegida por `skip_if_not_installed()`. Nunca é carregado em
uso normal, e a sua ausência não afeta nenhum resultado do pacote.

**3. "URL ... Status: 404"** — o repositório está privado enquanto o pacote
passa por revisão. O verificador do CRAN é anônimo e por isso recebe 404. O
repositório será tornado público antes da submissão, e a NOTE desaparece; se
esta submissão ocorrer antes disso, os campos `URL` e `BugReports` serão
removidos do `DESCRIPTION`.

### O que deixou de aparecer, e por quê

Até a versão 0.2.1 a NOTE trazia também **"The Title field should be in title
case"**. Não era defeito do título: o verificador aplicava a convenção de
capitalização do inglês a uma frase em português, cuja norma é a inversa. A
partir de 0.3.0 o `DESCRIPTION` declara `Language: pt-BR`, como a política do
CRAN pede para pacote que não é em inglês, e o aviso deixou de ocorrer — tanto
para o `Title` quanto para a `Description`. Declarar a língua era a correção
certa; capitalizar "Ao", "Em" e "Da" teria produzido um título agramatical.

## Materiais de terceiros

O pacote redistribui, em `inst/extdata/fontes/`, as sintaxes SPSS publicadas do
International Stratification and Mobility File (Ganzeboom & Treiman) e uma
cópia da tábua oficial de conversão do Ministério do Trabalho brasileiro.

Elas viajam com o pacote **por necessidade metodológica**: nenhuma tabela de
dados é digitada à mão, todas são geradas por script a partir dessas fontes, e
a suíte de testes confere as tabelas contra elas linha a linha, mais o `sha256`
de cada uma. Sem as fontes embarcadas, essa verificação não roda no ambiente de
check — que é exatamente o problema que esta versão corrigiu.

A autoria e as condições estão declaradas em `LICENSE.note`, que também viaja
com o pacote. `citation("ocupacoesBR")` devolve o pacote **e** as referências do
ISMF, conforme o pedido expresso dos autores das escalas.

## Dependências

Apenas `stats` e `utils` (base R). `DIGCLASS` está em `Suggests` e entra só
como conferência cruzada num teste — nunca é carregado em uso normal, e por
isso a sua licença GPL-3 não afeta a licença MIT deste pacote.
