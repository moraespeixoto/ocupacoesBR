# Comentários para a submissão ao CRAN

## Verificação

`R CMD check --as-cran` em R 4.5.3, x86_64-pc-linux-gnu (Ubuntu 26.04):
**0 ERROR, 0 WARNING, 1 NOTE.**

## Sobre a NOTE

A NOTE vem de `checking CRAN incoming feasibility` e reúne dois pontos:

**1. "The Title field should be in title case"** — falso positivo. O pacote é
escrito em português, e o título é uma frase em português:

> Traduz a Ocupação Declarada ao TSE em Classificações Padronizadas

O verificador aplica a convenção de capitalização do inglês, em que
preposições e artigos curtos ficam em minúscula e o resto em maiúscula. Em
português, a norma é a inversa: capitaliza-se a primeira palavra e os nomes
próprios, e o restante fica em minúscula. Capitalizar "Ao", "Em" e "Da" para
satisfazer o verificador produziria um título agramatical na língua em que ele
está escrito. O título segue a convenção correta do português.

O mesmo vale para a `Description`, também em português.

**2. "URL ... Status: 404"** — o repositório está privado enquanto o pacote
passa por revisão. O verificador do CRAN é anônimo e por isso recebe 404. O
repositório será tornado público antes da submissão, e a NOTE desaparece; se
esta submissão ocorrer antes disso, os campos `URL` e `BugReports` serão
removidos do `DESCRIPTION`.

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
