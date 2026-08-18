# ocupacoesBR 0.3.0

## A safra de 2026 entra, e o dicionário não precisou de uma linha

Esta versão estende o pacote das 14 eleições de 1998 a 2024 para as **15 de
1998 a 2026**. O resultado central é negativo, e é o mais informativo que
poderia sair: **o cadastro de ocupações do TSE não criou nenhum código em
2026**. Os 211 códigos observados na safra são subconjunto dos 275 que o
dicionário já cobria, com a mesma grafia acentuada que vigora desde 2018.
`tse_isco` não mudou; nenhuma ponte mudou; nenhum ISEI, prestígio, EGP,
classe ou estrato se deslocou de nenhum código.

Isso importa para quem usa o pacote **na eleição em curso**: a tradução de
2026 não é extrapolação. `checa_cobertura()` sobre a safra inteira passa, e
um teste novo (`test-rotulos.R`) trava a afirmação — se uma safra futura
trouxer código inédito, a suíte quebra em vez de o pacote devolver `NA`
silencioso.

### A safra é aberta, e o pacote diz isso

O prazo de registro encerrou em 15/08/2026, mas o Tribunal ainda julga e
publica candidaturas. Os dados desta versão são a geração do TSE de
**17/08/2026, 08:30** — 20.506 candidaturas, cerca de dois terços do volume
de 2022 nos cargos proporcionais, com `DS_SITUACAO_CANDIDATURA` igual a
`#NE` em toda linha e sem apuração. Nada do que o pacote extrai depende de
apuração: o rótulo de um código é propriedade do cadastro, não da
candidatura. Mas o `n` de 2026 há de crescer, e a documentação dos dados
registra a geração exata para que ninguém confunda duas safras de 2026 — o
TSE gera o arquivo duas vezes por dia.

**Uma armadilha nova, documentada em `?tse_diff_cadastro`.**
`tse_diff_cadastro(2024, 2026)` devolve 46 códigos como "extintos". Nenhum
foi extinto. A vigência se constrói do rótulo observado, e um código raro sem
candidato numa safra pequena registra ausência, não revogação — 2026 é
pequena duas vezes, por ser geral e por estar aberta. Trocar o par não
resolve: contra 2022, que também é geral, são 47. A metade que se sustenta é
a outra, "nenhum código criado", porque um código novo apareceria ainda que
uma vez só.

## A fonte dos rótulos mudou de arquivo, e o N muda por duas razões

`data-raw/04_gera_rotulos.R` lia um `.Rda` agregado de 397 MB e passa a ler
as safras individuais (`bancos/candidaturas/candidaturas_AAAA.rds` do projeto
`novissimos_dados_tse`), quatro colunas de cada. A troca não é de estilo. O
agregado se reconstrói de tempos em tempos e pode estar defasado sem que nada
no arquivo o denuncie: em 17/08/2026 ele trazia 15.866 candidaturas de 2026
contra as 20.506 da safra. Ler as safras é ler a fonte, custa megabytes em vez
de gigabytes, e acrescentar uma eleição passa a ser acrescentar um arquivo.
`OCUPACOESBR_TSE_RDA` continua honrado, para quem só tenha o agregado.

Por isso o total de candidaturas sai de **3.334.269 para 3.368.921**, e a
diferença tem **duas** causas que não convém somar às cegas:

* **+20.506** são a safra de 2026;
* **+14.146** são a reconstrução da base 1998–2024 feita a montante, no
  `novissimos_dados_tse`, que corrigiu a totalização e a deduplicação. Ela
  não é uniforme: soma 15.679 em 2000 e subtrai 1.485 em 2006. O sentinela
  `-4` ("NÃO DIVULGÁVEL", já mapeado para "Não informado") passa de 140 para
  1.698 registros, concentrados em 2012.

Números derivados que se moveram com a base nova, todos recomputados:

| valor | 0.2.1 | 0.3.0 |
|---|---|---|
| candidaturas com rótulo | 3.334.269 | 3.368.921 |
| eleições | 14 | 15 |
| códigos extintos após 2000 | 13 (12,2%) | 13 (12,4%) |
| códigos criados em 2002+ | 122 (33,1%) | 122 (33,2%) |
| `tse_diff_cadastro(2000, 2002)`, criados | 67 | 69 |
| candidaturas do 601 em 1998–2000 | 50.139 | 52.090 |
| reutilizados, candidaturas em 2000 | 1.582 | 1.628 |

Os 69 criados entre 2000 e 2002 substituem 67 porque a base recuperou uma
candidatura de 2002 nos códigos 150 (CHAVEIRO) e 241 (TAPECEIRO), cuja
vigência começava em 2004 e passa a começar em 2002.

### O que ficou idêntico, e é o que mais importa

`tse_ocupacao_rotulos` continua com **334 vigências para os mesmos 275
códigos**, e `tse_quebra_2002` com **44 códigos na mesma partição — 15
redefinidos, 18 refinados, 4 renomeados, 7 reutilizados**. A curadoria
editorial do campo `tipo`, que é a única decisão de medida desta tabela, não
se mexeu sob uma base maior e uma safra a mais. A suíte passa em 1310
expectativas, sem nenhuma alteração de valor esperado além do teto de ano.

## `tse_validacao` vai a 2026, sem o patrimônio de 2026

A tabela do critério externo passa a somar **3.347.794 candidaturas** nas
mesmas 221 ocupações. A safra entra em `n`, `pct_superior` e `pct_mulher`, e
**se abstém de `n_com_bens` e de toda mediana de patrimônio**.

A abstenção é de unidade, não de qualidade do dado. O patrimônio da tabela
está deflacionado a reais de **outubro de 2024**, pelo número-índice do IPCA
do mês da eleição, e outubro de 2026 não aconteceu. Deflacionar por outro mês
poria na coluna um valor que a definição da coluna desmente. A assimetria não
é nova: `n` sempre cobriu período mais largo do que `n_com_bens`, porque não
há declaração de bens antes de 2006, e as candidaturas de 1998 a 2004 já
entravam nessa condição. Quando o índice de outubro de 2026 existir, a coluna
sai de graça.

O desenho é **verificável, e foi verificado**. Rodando `05_gera_validacao.R`
sobre as duas microbases, a safra de 2026 move exatamente o que devia mover e
nada além:

| efeito | `sum(n)` | `sum(n_com_bens)` | `pct_superior` | mediana |
|---|---|---|---|---|
| religação de bens (a montante) | +0 | +67.117 | 0 códigos | 137 códigos |
| safra de 2026 | +20.447 | **+0** | 108 códigos (máx. 1,5 pp) | **0 códigos** |

A religação de bens é a segunda correção vinda de fora: a chave de junção da
declaração de bens passou a ser tripla (`ano`, `sg_ue`, `SQ_CANDIDATO`), o que
recuperou 67.117 declarações que os zeros à esquerda da unidade eleitoral
faziam perder. Ela desloca 137 medianas — entre elas a do código 257, de
R$ 495.400 para R$ 497.797 — e a dispersão do 257 passa de 81 para 80 vezes
(p90/p10). Nenhuma dessas mudanças altera a leitura substantiva registrada em
`?tse_codigos_autorrotulo`: o 257 continua sendo a mistura de duas populações
sob um rótulo só.

As correlações que a vinheta `validacao` reporta:

| | 0.2.1 | 0.3.0 |
|---|---|---|
| ISEI × % superior | r = 0,764 (rho 0,811), n = 208 | **r = 0,765 (rho 0,812), n = 208** |
| ISEI × log mediana de patrimônio | r = 0,682 (rho 0,695), n = 164 | **r = 0,681 (rho 0,695), n = 165** |
| nível do indivíduo | r = 0,207 | **r = 0,208** |

A microbase que sustenta a tabela é produzida por um script novo,
`data-raw/05a_microbase_2026.R`, que **anexa** 2026 às linhas de 1998 a 2024
sem recalcular nenhuma delas. A escolha é o que torna a decomposição acima
possível: se as linhas antigas fossem refeitas junto, toda diferença teria
duas causas e nenhuma separável.

## Correção de um número que estava errado desde antes desta versão

`tse_codigos_autorrotulo` estava documentado como **12,2% das candidaturas**
(em `?tse_para_isei`, `?tse_codigos_autorrotulo` e na vinheta `qual-regua`).
O valor correto é **13,3%**, e o erro não vem da base nova: sobre a base
antiga o valor já era 13,29%, e sobre a microbase do `vices_do_brasil`,
13,30%. Nenhum denominador plausível produz 12,2% — entre as candidaturas com
escore ISEI o percentual é 20,7%.

A origem do engano é visível: 12,2% é o percentual dos **códigos extintos**
sobre as candidaturas de 1998–2000, que aparece a duas seções de distância e
foi copiado para a documentação do autorrótulo, que mede outra coisa. Os dois
valores agora divergem também na aparência (13,3% e 12,4%), o que reduz a
chance de a confusão se repetir.

Nenhum resultado publicado muda por isso: o vetor
`tse_codigos_autorrotulo` sempre teve os mesmos dez códigos, e a análise de
sensibilidade que ele serve nunca dependeu do percentual. O que muda é a
frase que o descreve.

## Auditoria de cobertura de testes, e os defeitos que ela encontrou

A suíte cobria 85,2% das linhas de `R/`. A auditoria começou por uma pergunta
simples — toda função exportada é chamada ao menos uma vez? — e a resposta era
não: **doze das 57 não eram**, entre elas as oito de `R/prestigio.R`, arquivo
que a suíte não executava em nenhuma linha. A cobertura agora é **97,5%**, com
as 57 exportações exercitadas e a suíte em **1.447 expectativas** (eram 1.310).

Escrever esses testes revelou três defeitos reais, e é por isso que eles valem
mais do que o número de cobertura.

### `tse_para_prestigio08()` não aceitava `ano`

A versão 0.2.0 acrescentou o argumento `ano` às portas ancoradas na ISCO-08 e
nomeou três: `tse_para_isco08()`, `tse_para_isei08()` e `tse_para_siops08()`.
Esta ficou de fora. O efeito é perverso porque `*_prestigio()` é o nome
**preferido** e `*_siops()` o alias depreciado: durante duas versões o nome que
a documentação recomenda não mascarava vigência, enquanto o desaconselhado
mascarava. Quem montasse série pela porta certa recebia, sem aviso, o escore do
cadastro errado nos códigos reutilizados em 2002 — exatamente o erro que o
argumento existe para impedir.

Corrigido. Um teste novo compara as assinaturas dos seis pares
`prestigio`/`siops` e falha se voltarem a divergir.

### A família da CBO-2002 perdia `empate` e `escada` no meio do caminho

`cbo2002_para_isco()`, `cbo2002_para_isei08()`, `cbo2002_para_prestigio()`,
`cbo2002_para_prestigio08()` e `cbo2002_para_siops08()` aceitavam os dois
argumentos; `cbo2002_para_isei()` e `cbo2002_para_siops()` não. Quem ligasse a
escada para obter o código ISCO e a perdesse ao pedir o ISEI terminava com duas
colunas calculadas sobre universos diferentes, sem sinal de erro. As duas
funções agora têm a assinatura das demais, com os mesmos padrões.

### `tse_rotulo_para_cod()` devolvia `NULL` em vez de tabela vazia

Com `exato = FALSE` e nada a procurar — vetor vazio, ou todo `NA` —,
`do.call(rbind, ...)` devolvia `NULL`, de modo que o tipo do retorno dependia do
conteúdo do argumento: `data.frame` quase sempre, `NULL` nesses dois casos.
`nrow()` respondia `NULL` em vez de `0` e o acesso a coluna errava. Agora sai
sempre um `data.frame`, com zero linhas quando não há o que procurar. O ramo
`exato = TRUE` nunca teve o problema.

## O pacote ganha um site

A documentação passa a ter uma porta de entrada fora do R. O site é construído
com pkgdown a partir do próprio repositório e será servido pelo GitHub Pages em
`https://moraespeixoto.github.io/ocupacoesBR/` assim que o repositório for
aberto. Ele reúne o que já existia — o README, as duas vinhetas, o changelog, a
citação — e acrescenta quatro coisas novas.

**A referência deixou de ser alfabética.** As 57 funções estão agrupadas por
porta de entrada e por finalidade: a porta do TSE, o cadastro do TSE ao longo do
tempo, a porta da CBO, a porta do IBGE, as medidas a partir da ISCO, a
verificação de cobertura, o carregamento retrospectivo, as tabelas, e por último
os alias depreciados `*_siops*`, com a explicação de por que foram renomeados.
Ordem alfabética é útil para quem já sabe o nome da função; para quem não sabe,
esconde o pacote.

**Quatro artigos novos, só do site.** "Comece aqui" percorre o caminho inteiro
numa sessão e é construído em torno de uma tabela de oito ocupações reais e
frequentes, que mostra onde o ISEI se abstém e o esquema de classes ainda
responde. "Os percursos" mostra cada caminho de tradução e o ponto exato em que
ele para: a ambiguidade da ponte ISCO-08, o `empate` e a `escada` da CBO, a
quebra de 2002, a categoria residual. "A safra de 2026, na régua" reúne o que o
pacote já sabe da eleição em curso e o que não pode saber ainda. "Como citar"
explica por que são duas referências e não uma.

Os artigos vivem em `vignettes/articles/`, que fica fora do tarball: o site
cresce sem que o pacote engorde.

**Quatro fluxogramas.** Escritos em mermaid e pré-renderizados para SVG por
`data-raw/fig_diagramas.R`, de modo que funcionam offline e não dependem de
script carregado de CDN. Reusam a paleta de `data-raw/fig_rede_crosswalks.R`,
para o site não falar dois idiomas visuais. O diagrama da CBO foi redesenhado
depois de conferido contra `cbo2002_para_isco()`: a primeira versão punha a
`escada` antes do `empate`, e a ordem real é a inversa — o `empate` decide a
entrada de quatro dígitos, e a `escada` só age depois, sobre o que sobrou `NA`.

**Exemplos nas 14 tabelas de dados.** Era o único ponto em que a referência
estava incompleta: as 57 funções já tinham exemplo, os dados não tinham nenhum.
Cada tabela ganhou um `@examples` que a mostra e a põe em uso — em
`tse_quebra_2002`, os códigos reutilizados, com o 214 que era delegado de
polícia e passou a ser escultor e pintor.

### Duas armadilhas encontradas no caminho

O pkgdown transforma em página **todo** arquivo `.md` da raiz do repositório e
de `.github/`, sem opção de exclusão. Aqui isso significava publicar o
ferramental de assistentes de IA e os registros datados de auditoria, todos
gitignorados. Apagar as páginas depois do build não resolve: o índice de busca e
o sitemap guardam o *texto* desses arquivos. Por isso o build passa por
`data-raw/constroi_site.R`, que os esconde antes e os devolve depois, com lista
branca — arquivo de trabalho novo na raiz não vaza para o site por esquecimento.

O SVG do mermaid sai de dentro de um HTML, e o parser de HTML rebaixa todo nome
de atributo para minúsculas e não fecha o `<br>`. Num arquivo `.svg` servido
como XML isso quebra o desenho: `viewbox` não é `viewBox`. O extrator restaura
os nomes, fecha as tags e acrescenta `xml:space="preserve"`, sem o qual o SVG
descarta o espaço inicial de cada `tspan` e "o código declarado" é desenhado
como "ocodigodeclarado".

### O que isso mexeu no resto

- `DESCRIPTION` ganha a URL do site no campo `URL`. A NOTE de URL inválida do
  `R CMD check` passa de duas para três entradas, todas pelo mesmo motivo — o
  repositório fechado — e todas resolvem no mesmo momento.
- Dois workflows do GitHub Actions, escritos à mão e ainda não ativados: um
  reconstrói o site, outro roda `R CMD check` em três sistemas. O `.gitignore`
  ganhou a exceção `!.github/workflows/`, mantendo ignorado o resto do
  `.github/`.
- `R CMD check --as-cran`: 0 ERROR, 0 WARNING, as mesmas 2 NOTEs. Suíte em 1447
  testes, sem falha. O tarball continua com os mesmos seis arquivos de topo.

## Também nesta versão

* **`DESCRIPTION` declara `Language: pt-BR`**, como a política do CRAN pede
  para pacote que não é em inglês. Além de correto, resolve de vez a NOTE
  "The Title field should be in title case", que era o verificador aplicando a
  convenção do inglês a uma frase portuguesa. `R CMD check --as-cran` agora
  reporta apenas "New submission", o `Suggests` de `DIGCLASS` e as URLs 404 do
  repositório privado.
* **`citation("ocupacoesBR")` deixa de informar a versão errada.** O campo
  `note` do `inst/CITATION` dizia `"R package version 0.1.0"` digitado à mão, e
  continuou dizendo isso por três versões. Agora vem de `meta$Version`, e
  acompanha o `DESCRIPTION` sozinho.
* `?isei_retrospectivo` explicita que a cobertura por gênero (68,5% → 76,0%
  entre homens, 52,9% → 58,7% entre mulheres) segue medida sobre 1998–2024, e
  por quê: ela exige o painel por pessoa, que 2026 ainda não tem montado. É
  o único número do pacote que não acompanha a safra nova, e agora diz isso.
* O ferramental de assistentes de IA (`AGENTS.md`, `CLAUDE.md`, `.cursorrules`
  e afins) sai do repositório e do tarball, via `.gitignore` e `.Rbuildignore`.
* Removidos da árvore de trabalho os resíduos de build que não são fonte:
  `..Rcheck/` (de um `R CMD check .` que falhou em 28/07/2026, porque
  `Author`/`Maintainer` só existem no tarball), `ocupacoesBR.Rcheck/`, `doc/`,
  `Meta/` e `figure/`. Todos regeneráveis, nenhum versionado.

# ocupacoesBR 0.2.1

## Correção da régua ISCO-08: 21 códigos do TSE mudam de destino

Esta versão corrige o passo **TSE → ISCO-08** em 21 dos 275 códigos do
dicionário, o que equivale a **103.365 candidaturas — 3,10% do total e 4,84%
das que têm escore**. A média ponderada do ISEI-08 passa de **49,88 para
50,43** (+0,545). O efeito substantivo é distribucional, não médio: 1,29% das
candidaturas saem do primeiro decil da distribuição para perto da mediana, de
modo que cortes por quantil e dicotomias "classe alta / popular" construídas a
partir do ISEI-08 precisam ser recalculados, não só as médias.

Origem: auditoria da régua conduzida em 2026-08 contra a tabela oficial de
correspondência da OIT (ISCO-88 → ISCO-08) e contra as sintaxes do ISMF
distribuídas em `inst/extdata/fontes/ganzeboom/`.

### O que **não** mudou, e por quê

* **A ponte `isco88_isco08` está intacta.** `isco88_para_isco08("1311")`
  continua devolvendo `6130`, `"7400"` continua devolvendo `7540`. A ponte
  reproduz a correspondência oficial da OIT, que aboliu o grande grupo 13 da
  ISCO-88 e devolveu o proprietário-dirigente à ocupação exercida; quem entra
  pela ISCO-88 tem de receber isso. Nenhum valor de `data/isco88_isco08.rda`,
  `data/isco08_medidas.rda` ou `data/isco88_medidas.rda` foi alterado.
* **A régua TSE → ISCO-88 está intacta.** `tse_para_isco()`, `tse_para_isei()`,
  `tse_para_siops()`, `tse_para_egp()`, `tse_para_classe()` e
  `tse_para_estrato()` devolvem exatamente o que devolviam em 0.2.0. Nenhum
  resultado publicado em ISEI-88 se desloca.
* **Os 17 códigos sem escore continuam `NA`**, inclusive o 295 (membro das
  forças armadas). Ganzeboom pontua ISCO-08 `0000` (ISEI-08 51,25) mas deixa o
  ISCO-88 `0110` sem ISEI-88: preencher só a régua nova criaria uma linha que
  existe numa régua e não existe na outra, quebrando a comparabilidade entre a
  medida primária e a de robustez. Fica `NA` nas duas, por decisão.

### Como a correção foi implementada

`tse_para_isco08()` deixa de ser a mera composição
`isco88_para_isco08(tse_para_isco(cod))`. O código do TSE carrega duas
informações que a ponte genérica não pode ver, e as duas são usadas agora:

1. **A marca de proprietário** (`tse_isco$proprietario`), que é o `SEMPL = 2`
   do ISMF;
2. **O rótulo em português**, mais fino do que o código ISCO-88 **agregado** a
   que o dicionário associa aquele código.

A regra mora numa única função interna, `.corrige_isco08_tse()` (em
`R/isco08.R`), chamada tanto por `tse_para_isco08()` quanto por
`crosswalk_tse()` — não há duas cópias que possam divergir, e
`test-isco08-tse.R` trava a igualdade entre as duas saídas. Como
`tse_para_siops08()` e `tse_para_prestigio08()` passam por
`tse_para_isco08()`, o SIOPS-08 desses 21 códigos também se corrige.

### 1. Promoção do proprietário rural (`iskopromo.sps`)

Os três códigos abaixo recebiam, na mesma linha do `crosswalk_tse()`, EGP
`IVc: proprietário rural`, estrato "Classe alta", componente "Alta
proprietária" **e** o ISEI-08 de trabalhador agrícola. Eram as **únicas três
linhas da tabela inteira** em que "Classe alta" convivia com ISEI-08 abaixo de
40 — o teste de consistência interna que a auditoria propôs isola exatamente
estas três, e agora ele está na suíte.

| Cód. | Rótulo | ISCO-08 antes | ISEI-08 antes | ISCO-08 agora | ISEI-08 agora | % cand. |
|---|---|---|---|---|---|---|
| 234 | PRODUTOR AGROPECUÁRIO | 6130 | 17,79 | **1311** | **49,48** | 0,572 |
| 602 | PECUARISTA | 6130 | 17,79 | **1311** | **49,48** | 0,509 |
| 901 | PROPRIETÁRIO DE ESTABELECIMENTO AGRÍCOLA, DA PECUÁRIA E FLORESTAL | 6130 | 17,79 | **1311** | **49,48** | 0,212 |

**Fonte.** `iskopromo.sps` (Ganzeboom, ISMF), primeira regra do módulo, cuja
finalidade declarada é "*make sure that managers and owners with certain
employment statuses go into the right place*":

```
do repeat iii=@isko / sss=@sempl.
do if (sss eq 2).          /* proprietário / conta própria com empregados */
. recode iii (6130=1311).
end if.
end repeat.
```

O pacote já aplicava esta linha desde 0.1.0, mas **só no caminho do EGP**
(`R/egp.R`), o que é a razão de a contradição ser interna: o EGP sabia que
aquela pessoa era proprietária e o ISEI-08 não. ISCO-08 `1311` é
*Agricultural and forestry production managers*; ISEI-08 = 49,48, lido de
`isqoisei08.sps` linha 28 (`recode @isqo (1311=49.48)`).

A correção também remenda uma série que o TSE construiu homogênea e a tradução
partia ao meio: os irmãos diretos de 901 — 902 (comercial), 903 (industrial),
904 (serviços), 905 (microempresa) — recebem todos ISEI-08 51,01, com o mesmo
estrato e o mesmo componente de classe. Só o agrícola desabava para 17,79.

**Recomendação da auditoria que foi REJEITADA.** A auditoria propunha obter o
mesmo resultado recodificando a origem, TSE → ISCO-88 de `1311` para `1221`
(*department managers in agriculture*). Não foi feito: a codificação em `1311`
é deliberada (o comentário do autor em
`inst/extdata/fontes/R/classe_ocupacao.R` registra "PRODUTOR AGROPECUÁRIO:
61=23 → 1311=43 (proprietário rural)"), e a rota `1221` mudaria **também a
régua antiga**, levando o ISEI-88 de 43 para 67 e deslocando resultados já
publicados em ISEI-88. A promoção via `iskopromo.sps` chega ao mesmo ISCO-08
sem tocar em nada da ISCO-88 — e tem precedente dentro do próprio pacote.

*Efeito colateral que convém declarar:* para estes três códigos a ida e a volta
deixam de fechar. `isco08_para_isco88("1311")` devolve `1221`, porque a ponte
de volta (`isco0888.sps`) também é a da OIT. A assimetria é inerente a
`iskopromo.sps`, cuja recodificação depende do status de emprego, que a volta
não conhece.

### 2. Destinos ISCO-08 refinados pelo rótulo do TSE

Onze códigos do TSE cujo ISCO-88 é o **agregado 7400** (*other craft and
related trades workers*) caíam em ISCO-08 **7540**, que é o grupo-menor
**residual** da submajor 75 ("*other craft*": mergulhadores, dinamitadores,
classificadores de produtos). O ISEI-08 de 7540 (43,19) destoa em ~19 pontos de
toda a sua própria família (7500 = 23,97; 7510 = 23,46; 7520 = 23,65;
7530 = 22,03). A prova de que é transposição de dígito, e não escolha, está no
próprio `isco8808.sps`: ele manda cada ramo filho ao lugar certo — `7410=7510`,
`7420=7520`, `7430=7530`, `7440=7536`, `7441=7535`, `7442=7536` — e só o
agregado ao residual.

| Cód. | Rótulo | Antes | Agora | ISEI-08 | % cand. | Fonte |
|---|---|---|---|---|---|---|
| 713 | CARPINTEIRO, MARCENEIRO E ASSEMELHADOS | 7540 (43,19) | **7520** | **23,65** | 0,252 | `isco8808.sps`: 7422 (marceneiros) → 7520 |
| 228 | PADEIRO, CONFEITEIRO E ASSEMELHADOS | 7540 (43,19) | **7510** | **23,46** | 0,154 | 7412 (padeiros, confeiteiros) → 7510 |
| 710 | TRAB. DE FABRICAÇÃO E PREPARAÇÃO DE ALIMENTOS E BEBIDAS | 7540 (43,19) | **7510** | **23,46** | 0,051 | 7410 (*food processing trades*) → 7510 |
| 591 | ALFAIATE E COSTUREIRO | 7540 (43,19) | **7530** | **22,03** | 0,069 | 7430 (*textile, garment trades*) → 7530 |
| 705 | TRABALHADOR DE FABRICAÇÃO DE ROUPAS | 7540 (43,19) | **7530** | **22,03** | 0,063 | 7430 → 7530 |
| 188 | FIANDEIRO, TECELÃO, TINGIDOR E ASSEMELHADOS | 7540 (43,19) | **7530** | **22,03** | 0,005 | 743 (*textile trades*) → 7530; ver ressalva |
| 241 | TAPECEIRO | 7540 (43,19) | **7530** | **22,03** | 0,018 | 7437 (estofadores) → 7534, dentro de 753 |
| 186 | ESTOFADOR | 7540 (43,19) | **7530** | **22,03** | 0,011 | 7437 → 7534, dentro de 753 |
| 149 | CHAPELEIRO | 7540 (43,19) | **7530** | **22,03** | 0,001 | 7433 (*tailors, dressmakers and hatters*) → 7531, dentro de 753 |
| 715 | TRAB. DE FABRICAÇÃO DE CALÇADOS E ARTEFATOS DE COURO | 7540 (43,19) | **7536** | **18,07** | 0,047 | 7442 (*shoemakers arw*) → 7536, destino único |
| 250 | TRABALHADOR DE CURTIMENTO | 7540 (43,19) | **7535** | **28,08** | 0,003 | 7441 (*pelt dressers, tanners and fellmongers*) → 7535, destino único |

**Ressalva sobre o cód. 188** (0,005% das candidaturas, n = 170). Este é o
único dos onze em que a leitura fina não fecha: `isco8808.sps` manda `7431`
(*fibre preparers*) para 7318 (artesanato, ISEI-08 28,97) e `7432` (*weavers,
knitters*) para 8152 (operadores de máquina, ISEI-08 18,03) — a ISCO-08
dispersou o grupo. Como o dicionário lê este código pelo ramo **artesanal**
(ISCO-88 74, não 82), adotou-se o grupo-menor do agregado ISCO-88 743, que é
7530. As quatro leituras possíveis ficam entre 18 e 29; nenhuma se aproxima dos
43,19 anteriores, que é o que a correção precisa garantir.

Três códigos cujo ISCO-88 é o **agregado 2220** (*health professionals except
nursing*) caíam no agregado ISCO-08 2200, que é a média de **todos** os
profissionais de saúde, inclusive a enfermagem. Os rótulos do TSE nomeiam a
ocupação exata, e para cada uma a OIT dá destino **único**:

| Cód. | Rótulo | Antes | Agora | ISEI-08 | % cand. | Fonte |
|---|---|---|---|---|---|---|
| 115 | ODONTÓLOGO | 2200 (76,98) | **2261** *(Dentists)* | **88,31** | 0,299 | `isco8808.sps`: 2222 → 2261, único |
| 112 | VETERINÁRIO | 2200 (76,98) | **2250** *(Veterinarians)* | **84,14** | 0,131 | 2223 → 2250, único |
| 117 | FARMACÊUTICO | 2200 (76,98) | **2262** *(Pharmacists)* | **81,13** | 0,155 | 2224 → 2262, único |

Um código cujo ISCO-88 é **2320**, que tem exatamente dois destinos na OIT —
2320 (*vocational education teachers*) e 2330 (*secondary education
teachers*) —, e que a ponte trunca para 2330 nos dois casos:

| Cód. | Rótulo | Antes | Agora | ISEI-08 | % cand. | Fonte |
|---|---|---|---|---|---|---|
| 235 | PROFESSOR E INSTRUTOR DE FORMAÇÃO PROFISSIONAL | 2330 (82,41) | **2320** | **72,30** | 0,211 | dos 2 destinos da OIT para 2320, o que o rótulo nomeia. O 2330 fica com o cód. 266, PROFESSOR DE ENSINO MÉDIO, que não muda |

Três códigos cujo ISCO-88 é o **agregado 3470** (*artistic and cultural
associate professionals*), traduzido por 3430, que pressupõe nível técnico —
embora os rótulos do TSE reproduzam literalmente os títulos de ISCO-88 2453 e
2454, de nível profissional:

| Cód. | Rótulo | Antes | Agora | ISEI-08 | % cand. | Fonte |
|---|---|---|---|---|---|---|
| 164 | MÚSICO | 3430 (50,15) | **2652** *(Musicians, singers and composers)* | **64,44** | 0,220 | `isco8808.sps`: 2453 → 2652, único |
| 163 | CANTOR E COMPOSITOR | 3430 (50,15) | **2652** | **64,44** | 0,113 | 2453 → 2652, único |
| 165 | COREÓGRAFO E BAILARINO | 3430 (50,15) | **2653** *(Dancers and choreographers)* | **61,82** | 0,007 | 2454 → 2653, único |

Todos os valores de ISEI-08 acima foram lidos de
`inst/extdata/fontes/ganzeboom/isqoisei08.sps`; nenhum foi estimado.

### Onde esta versão diverge da auditoria

* **Cód. 250 (TRABALHADOR DE CURTIMENTO): 7535, e não 7536.** A auditoria
  propunha 7536 (ISEI-08 18,07) "via 7440". Mas 7536 é *Shoemakers arw*, e
  curtimento é curtume: `isco8808.sps` mapeia `7441` (*pelt dressers, tanners
  and fellmongers*) para **7535** (ISEI-08 28,08), destino único. 7536 e 7535
  são irmãos dentro do mesmo grupo-menor 753, e a auditoria pegou o irmão
  errado. Aplicada a leitura exata do rótulo.
* **Códigos 163, 164 e 165 foram aplicados junto com o Bloco A.** A auditoria
  os classificou como "Bloco C — precisão menor", separado. A lógica e a
  qualidade da evidência são idênticas às do Bloco A (destino único na OIT, sem
  ambiguidade de rótulo), e tratá-los à parte só deixaria três linhas
  conhecidamente erradas na tabela.
* **A recodificação de origem 1311 → 1221 foi rejeitada** (ver acima).
* **O agregado ISCO-88 2400** (26 códigos, 2,848% das candidaturas) **não foi
  tocado**: exige julgamento substantivo caso a caso sobre 26 rótulos e mudaria
  as duas réguas. Fica registrado como a maior pendência conhecida da régua.

### Pendências conhecidas, herdadas da auditoria

Nenhuma foi resolvida nesta versão; ficam anotadas para a nota de método de
quem publicar a partir do pacote.

* **Agregado ISCO-88 2400 → 2400** (2,848% das candidaturas). PSICÓLOGO,
  SOCIÓLOGO, MEMBRO DO MINISTÉRIO PÚBLICO ficam subestimados; ASSISTENTE
  SOCIAL, BIBLIOTECÁRIO, ATOR, superestimados.
* **Restante do agregado 3470** (0,433%): 166 LOCUTOR/RADIALISTA, 105
  DESENHISTA INDUSTRIAL, 193 DECORADOR, 130 ARTISTA DE CIRCO, 168 ATLETA — a
  OIT dá destinos múltiplos e o rótulo do TSE não desempata.
* **Agregado ISCO-88 9100 → 9620** (0,242%), destino no topo da faixa possível,
  e as mesmas 10 linhas com EGP `IIIa` convivendo com ISCO-08 do grande grupo 9
  — herança de `iskoroot.sps`, não decisão do pacote.
* **Cód. 303 GERENTE** (0,402%): o rótulo não desempata entre gerente
  assalariado (12xx) e proprietário-dirigente (13xx). Mantido como está.
* **Cód. 903** PROPRIETÁRIO DE ESTABELECIMENTO **INDUSTRIAL** (0,042%) recebe
  ISCO-08 1400 (*hospitality, retail and other services managers*) — setor
  errado; seria 1321 (*manufacturing managers*).
* **Códs. 906 e 907** (rentista de imóveis, capitalista de ativos financeiros)
  estão corretamente sem ISEI, mas no estrato "Fora da PEA / não informado",
  quando são por definição posições de classe proprietária. 131 candidaturas.
* **Códs. 163, 164 e 165** passam agora, na ISCO-08, do grande grupo 3 para o
  2, sem que o esquema de classes do pacote os acompanhe (seguem em
  "Profissionais de nível médio"). A régua de classe não foi tocada nesta
  versão; a decisão fica com o autor.

### Documentação e testes

* `?tse_para_isei08`, seção **"Quando *não* usar"**: o exemplo do produtor
  agropecuário "que cai cerca de 25 pontos ao mudar de âncora" era justamente o
  erro corrigido acima e foi substituído por dois deslocamentos verdadeiros —
  o enfermeiro (cód. 113), que sobe 26 pontos porque a ISCO-08 promoveu a
  enfermagem a profissão de nível superior, e o vendedor (cód. 411), que cai 13
  porque a revisão reavaliou o grupo 52 inteiro. **A advertência geral da seção
  continua valendo e foi reforçada:** para comparar candidaturas entre si,
  fique na ISCO-88, que é onde o pacote está ancorado. O mesmo exemplo foi
  trocado em `README.Rmd` e na seção 7 de `vignette("qual-regua")`.
* `?tse_para_isco08` ganhou a seção **"Não é a mera composição das duas
  etapas"**, que declara a diferença em relação a `isco88_para_isco08()`.
* **`test-isco08-tse.R` (novo, 33 asserções)** trava, uma a uma: a ponte
  ISCO-88 intacta; a régua TSE → ISCO-88 intacta; a promoção dos três agrários;
  que a promoção é **regra** e não lista (um código novo marcado proprietário
  com destino 6130 também será promovido, e nenhum não-proprietário pode ser);
  os 18 refinamentos por rótulo, um a um; que nenhum código do TSE cai mais no
  residual 7540; que `crosswalk_tse()` e as funções não podem divergir; e o
  **teste de consistência interna** descoberto pela auditoria: nenhuma linha do
  `crosswalk_tse()` pode ter estrato "Classe alta" com ISEI-08 abaixo de 40.
* `test-armadilha.R` distingue agora o deslocamento de grande grupo na **ponte
  crua** (que segue como estava: 114, 222, 234, 602, 901) do deslocamento no
  passo **TSE → ISCO-08** (114, 222, 163, 164, 165).

# ocupacoesBR 0.2.0

## `tse_para_isei08()` passa a aceitar `ano`

As portas ancoradas na ISCO-08 — `tse_para_isco08()`, `tse_para_isei08()` e
`tse_para_siops08()` — ganharam o argumento `ano`, com a mesma máscara de
vigência que as portas da ISCO-88 já tinham. Passando o ano da eleição, as
candidaturas cujo código o TSE **reutilizou** em 2002 voltam `NA` com aviso da
classe `ocupacoesBR_quebra_2002`, em vez de traduzidas pelo cadastro errado.
Antes, quem quisesse o ISEI-08 mascarado por vigência tinha de aplicar a máscara
à mão; agora é `tse_para_isei08(cod, ano = ano)`, simétrico a
`tse_para_isei(cod, ano = ano)`. Veja `?tse_vigencia` e `?checa_periodo`.

## Uma classe própria para o agricultor: criada e revertida (29/07/2026)

Nenhuma proporção publicada muda. O registro fica porque a decisão chegou a ser
implementada, e o motivo da reversão é reaproveitável.

* **O que se fez.** Os códigos 601 (agricultor) e 604 (pescador) receberam a
  classe `"Conta própria rural"`, fora dos três estratos. A justificativa era que
  os dois esquemas do pacote discordavam: `tse_para_egp()` os põe em
  `IVc: proprietário rural` e `tse_para_classe()` os mantinha nas classes
  populares.

* **Por que se desfez.** O argumento era inválido. O EGP só separa IVc de VIIb
  nas **onze** classes; nos colapsos canônicos de cinco e de três, o agricultor e
  o assalariado rural caem na mesma categoria. Comparar um esquema de onze
  classes com uma partição em três estratos é comparar resoluções diferentes, não
  encontrar divergência — e na resolução equivalente à do estrato o próprio EGP
  funde os dois.

* **O dado externo concorda com a reversão.** O ISEI do agricultor, 23, está
  dentro da faixa das classes populares (16 a 43). O patrimônio mediano de
  R$ 254.582 fica acima do máximo das populares por menos de três mil reais: põe
  o agricultor no topo da classe popular, não fora dela. A comparação original
  era contra a mediana das populares, o que inflava a distância.

* **Onde a distinção continua disponível:** em `tse_para_egp(n_classes = 11)`,
  que é onde Erikson e Goldthorpe a puseram. `test-posicao.R` agora trava os dois
  fatos — que os colapsos de 5 e 3 fundem 601 e 606, e que o de 11 os separa.

* A documentação do esquema volta a dizer **doze** categorias, e `?tse_para_classe`
  ganhou a seção que explica por que o agricultor não tem classe própria.

## Correção em `tse_validacao` (29/07/2026)

### Muda o conteúdo de um conjunto de dados publicado

* **`tse_validacao` passa de 175 para 221 linhas.** O piso de 200 declarações de
  bens, que a mediana de patrimônio exige para não ficar ruidosa, descartava a
  **linha inteira** em vez de apenas a mediana. Isso amputava do conjunto 46
  ocupações cuja escolaridade e cuja composição por gênero estão perfeitamente
  medidas e que apenas carecem de declarações de bens. Agora o piso zera a
  mediana e preserva a linha: `mediana_patrimonio` é `NA` onde
  `n_com_bens < 200`.

* **A regressão de gênero documentada em `?tse_para_isei` volta a reproduzir a
  partir do dado publicado.** Ela é calculada sobre 170 códigos com pelo menos
  500 candidaturas, mas o conjunto publicado só continha 157, e a divergência
  atravessava o limiar convencional de significância (p = 0,044 contra 0,061).
  O invariante está agora travado por teste em `test-fonte.R`, que verifica os
  170 códigos, os 28 femininos e o coeficiente de −6,14.

* **A correlação com escolaridade passa a ser reportada sobre 208 ocupações, e
  não 164**, porque a escolaridade está medida em toda linha do conjunto. O
  valor vai de 0,772 para **0,764**. A correlação com patrimônio permanece
  **0,682**, calculada sobre as mesmas 164 ocupações de antes — o que corrige,
  de passagem, o 0,671 que a vinheta `validacao` ainda reportava.

### Quem precisa mudar código

* Quem correlaciona com `mediana_patrimonio` deve filtrar
  `!is.na(mediana_patrimonio)`. Quem usa apenas `pct_superior` ou `pct_mulher`
  ganha 46 ocupações sem fazer nada.

## Segunda rodada de auditoria (27/07/2026)

Quatro revisores independentes reauditaram o estado corrigido
(`AUDITORIA_2026-07-27.md`), rodando R sobre o dado real. A fidelidade às fontes
do ISMF é byte-a-byte (zero divergências). Estas são as correções aplicadas.

### Muda resultado obtido com a versão anterior

* **Escultor, pintor e artista plástico deixam de entrar na "alta credenciada"
  com ISEI 68.** Os códigos **191, 214 e 215** caíam no agregado ISCO `2400`
  (ISEI 68) — o escore do advogado —, apesar de só 18,6%–29,7% dos que os
  declaram terem ensino superior. Passam ao código preciso `2452` (escultores,
  pintores e artistas plásticos, **ISEI 54**), que a ISCO já oferece. É a mesma
  correção de 114/222 na rodada anterior. O **estrato não muda** (seguem
  "Profissionais de nível superior" / classe alta, pelo primeiro dígito); só o
  ISEI. O alinhamento da *classe* dos artistas visuais com os performers ficou
  como decisão editorial na branch `proposta-bloco-c`.

* **`tse_para_classe(cod, superior = NA)` não imputa mais a metade baixa.** Quem
  não declarou escolaridade (`superior = NA`) permanecia, calado, em "Vínculo
  público, médio ou menos". Agora fica no rótulo residual "Vínculo público não
  especificado" — não dividido, não imputado —, coerente com a política de não
  imputação que o pacote adota no EGP. São ~16 mil candidaturas, e a ausência de
  escolaridade é correlacionada com posição social.

* **Fisioterapeuta (114) e nutricionista (222) passam a "Profissionais de nível
  superior".** A regra de classe lê o primeiro dígito da ISCO-88, e a ISCO-88 de
  1988 classificou fisioterapia e nutrição como ocupações auxiliares da medicina
  (grande grupo 3). Elas se universitarizaram, e a **própria OIT corrigiu isso em
  2008**, movendo-as ao grande grupo 2 — códigos `2264` e `2265`, que este pacote
  já computa. O critério externo concorda: 95,8% e 85,4% dos que declaram esses
  códigos têm superior completo, contra 74,7% da professora fundamental (265),
  que a régua punha um estrato **acima**. A régua estava incoerente com a sua
  própria lógica, e no caso mais feminizado da tabela.

  Efeito medido: **5.455 candidaturas (0,164%)**; a classe alta vai de 32,54%
  para 32,71%. O **ISEI não muda** (segue 60 e 51) — as duas réguas continuam
  independentes, que é o desenho do pacote.

  **A regra geral foi testada e rejeitada.** Trocar o grande grupo da ISCO-88
  pelo da ISCO-08 para todos os códigos conserta estes dois e **quebra três**:
  234, 602 e 901 cairiam de classe alta para rural, porque a ponte 88→08 do
  código `1311` tem nove destinos possíveis segundo a OIT e o truncado (`6130`)
  vale ISEI-08 17,8 contra 43 do ISCO-88. A regra de princípio sai pior que o
  remendo — desfaz um patch deliberado por uma ambiguidade da ponte, não por uma
  decisão sociológica. Por isso a correção é um patch de dois códigos, explícito
  e documentado em `.PATCH_CLASSE`, e não uma mudança de regra.

* **O EGP deixa de ler o agricultor familiar como proletário rural.** A marca
  `tse_isco$proprietario` fazia dois trabalhos ao mesmo tempo: definia a
  pertença à classe "Proprietários e empregadores" **e** alimentava o `SEMPL`
  que o EGP exige. São perguntas diferentes — "trabalha por conta própria?" não
  é "pertence à classe proprietária?" —, e enquanto compartilharam um vetor,
  marcar o agricultor como conta própria o promovia junto à classe alta, que o
  patrimônio não sustenta.

  Agora há duas colunas. `conta_propria` é superconjunto de `proprietario` e
  inclui **601 (agricultor)** e **604 (pescador)**, que trabalham por conta
  própria sem serem a classe proprietária. O esquema de classes **não muda**:
  os dois seguem em "Trabalhadores rurais" / classes populares. (Em 29/07/2026
  testou-se movê-los para uma classe própria e a mudança foi revertida; ver a
  entrada do topo deste arquivo.)

  O EGP muda muito:

  | classe EGP | antes | depois |
  |---|---|---|
  | IVc: proprietário rural | 2,02% | **16,25%** |
  | VIIb: trabalhador agrícola | 16,24% | **2,01%** |

  **14,23% das candidaturas classificadas mudam de classe.** A oferta eleitoral
  brasileira deixa de aparecer como um proletariado rural e passa a aparecer
  como o que a definição da OIT e o dado dizem que ela é: pequena propriedade
  familiar. É o ponto de Carvalhaes (2015) que `?isco88_para_egp` cita — no
  Brasil, a categoria que o EGP melhor capta é o conta própria — finalmente
  operando.

  A marcação é por **código do TSE**, não por ISCO, porque três códigos dividem
  a ISCO 6100 e não são a mesma coisa: agricultor e pescador são conta própria;
  **jardineiro é trabalho contratado** e segue em VIIb.

### As advertências saem da vinheta e entram nas páginas de ajuda

O pacote já conhecia os seus limites e os documentava — nas vinhetas. Quem faz
`?tse_para_isei`, que é o caminho de quase todo usuário, não os recebia. Três
seções novas, com números reproduzidos no dado real:

* **`?tse_para_isei` ganha "Anomalias conhecidas da escala".** A ISCO-88 é
  enviesada contra ocupações femininas: a credencial constante, um código
  majoritariamente feminino recebe **6,1 pontos de ISEI a menos** (ep 3,02;
  p = 0,044; 170 códigos com n ≥ 500). E não é falta de escolaridade — esses
  códigos têm **mais**: 29,8% de superior contra 23,9%, com ISEI médio de 46,0
  contra 48,7. O caso emblemático é a enfermagem, que a ISCO-88 põe em `2230`
  com **ISEI 43, abaixo dos escriturários (45)**, apesar de ser profissão
  universitária; a âncora da ISCO-08 dá **68,7**. Daí a recomendação explícita:
  para análise de gênero, prefira [tse_para_isei08()].

* **`?tse_para_componente_alta` declara a assimetria de confiabilidade.** A
  partição é simétrica no desenho e assimétrica na medição: "advogado"
  pressupõe inscrição na OAB; "empresário" não pressupõe nada. O patrimônio
  mediano de quem se declara 257 varia por um fator de **25** conforme o cargo
  disputado (R$ 367 mil entre candidatos a vereador, R$ 9,3 milhões entre
  candidatos a senador), sob um único ISEI e uma única classe. Um gráfico que
  compare os dois componentes compara uma quantidade ancorada em registro
  externo a outra autodeclarada que agrega posições muito distantes.

  A seção também registra **o que o dado não mostra**: não há evidência de que
  as pessoas troquem de rótulo conforme o cargo. A frequência do 257 não cresce
  com a importância do posto — tem pico em prefeito (10,6%) e cai em senador
  (7,1%) e governador (6,2%); quem cresce monotonicamente é "advogado" (1,6% a
  15,2%), o caso ancorado, e "comerciante" **cai** de 6,2% a 0%. O gradiente de
  patrimônio é consistente tanto com recrutamento seletivo quanto com
  relabeling, e estes dados não separam as duas hipóteses.

* **`?isei_retrospectivo` ganha "O que ele erra, medido".** Entre os 680.317
  pares consecutivos em que o ISEI foi observado nas duas pontas, **52,1%**
  mudam de código e **45,3%** mudam de escore, com diferença absoluta média de
  **18,9 pontos** quando muda. Mesmo com defasagem zero o escore herdado
  estaria errado em quase metade dos casos — e a defasagem não é zero: mediana
  de 4 anos, **34,6%** de 8 anos ou mais. Pior que o tamanho é a direção: o erro
  aponta sempre para o passado, então para quem ascendeu ele puxa a posição
  para baixo. É viés sistemático contra a própria quantidade que estudos de
  profissionalização política querem medir.

* **`tse_codigos_autorrotulo`** — os dez códigos cujo rótulo designa
  propriedade por autodescrição (empresário, comerciante, industrial,
  proprietário de estabelecimento) e que, por isso, não são ancorados em
  registro nenhum. São **12,2%** das candidaturas. O uso é análise de
  sensibilidade em uma linha:

  ```r
  d$isei_ancorado <- ifelse(d$cod %in% tse_codigos_autorrotulo, NA, d$isei)
  ```

  A decisão sobre o código **257 (EMPRESÁRIO) foi medir e não mover**. A
  proposta da auditoria — levá-lo à ISCO 13, ISEI 51 — é rejeitada pelo
  critério externo: 257 tem o **maior** patrimônio mediano entre os códigos
  proprietários (R$ 495.400, contra R$ 303.874 do industrial e R$ 296.088 do
  comerciante), e rebaixá-lo o poria abaixo do industrial. O problema do 257
  não é o nível, é a dispersão: dentro do código os extremos de patrimônio
  distam 81 vezes, e o mediano varia por um fator de 25 conforme o cargo
  disputado. É uma **mistura** de duas populações sob um rótulo, e mistura não
  se corrige mudando o ponto — se torna visível.

  A escolha da classe e do estrato **não dependia** dessa decisão: 257 está em
  `.COD_PROPRIETARIO`, e a regra de classe testa a pertença antes de olhar o
  ISCO.

### Correções

* **O parâmetro `ano` chega às medidas contínuas.** `tse_para_isei()`,
  `tse_para_siops()` e `tse_para_egp()` passam a aceitar `ano`, como as portas
  categóricas já faziam. Sem ele, uma série de ISEI que atravessa 2002
  classificava o período pré-reutilização pelo dicionário pós-reutilização, sem
  aviso: `tse_para_isei(215)` devolvia 68 (artista) para uma candidatura de 2000,
  quando 215 designava um cargo de direção. Agora `tse_para_isei(215, ano = 2000)`
  devolve `NA` com aviso.

* **`data-raw/03_gera_quebra_2002.R` foi aposentado.** Ele ainda montava
  `tse_quebra_2002` de uma tabela de 3 linhas digitada à mão (sem a coluna
  `tipo`) e chamava `use_data()`. Rodá-lo isolado rebaixava o dataset e desligava
  o filtro de vigência do `ano` **em silêncio**. A geração vive só em
  `04_gera_rotulos.R`. Com isso, a afirmação "nenhuma tabela é digitada à mão"
  passa a valer sem exceção.

### A medida se afere contra a PNAD

* **`isco_posicao_br`** — a posição na ocupação que o TSE não pergunta, medida
  onde ela existe. Para cada um dos 319 códigos ISCO-88 observados, a
  distribuição brasileira de conta própria, empregador e número de empregados,
  apurada nos **quatro trimestres de 2025 da PNAD Contínua** (437.880 pessoas
  distintas; 258 códigos com n ≥ 100).

  Isto só ficou possível por causa da perna COD: a PNAD usa a COD, a COD é a
  ISCO-08, e `cod_para_isco08()` a leva ao mesmo espaço em que o TSE aterrissa.

  | ISCO-88 | conta própria ou empregador |
  |---|---|
  | 61 (agrícolas qualificados) | **67,6%** |
  | 6150 (pesca) | **83,8%** |
  | 92 (rurais elementares) | 16,5% |
  | todas as ocupações | 29,4% |

  É um **prior empírico**, não uma imputação: a tabela não atribui posição a
  ninguém, informa a composição da ocupação no país. O uso legítimo é análise
  de sensibilidade; o ilegítimo é tratar a proporção como se fosse o caso
  individual.

  Dois cuidados de método ficam registrados na documentação. A PNAD é **painel
  rotativo** — 864.870 observações são de 437.880 pessoas (1,98×) —, então os
  pesos são divididos pelos quatro trimestres e a coluna de precisão é
  `n_pessoas`, não `n_obs`. E a hipótese de **sazonalidade agrícola**, que
  motivou usar o ano inteiro, **não se confirmou**: a amplitude entre
  trimestres é de 2,5 pp. O ganho do ano completo foi precisão nas células
  finas, não correção de viés.

  Os microdados (212 MB por trimestre) **não** viajam com o pacote; o que entra
  é a tabela agregada de 4,5 KB, gerada por `data-raw/07_gera_posicao.R`.

* **Conformidade:** `.claude/` deixa de entrar no tarball; a doc de
  `cod_para_isco08()` corrige a afirmação sobre forças armadas (a perna ISCO-08
  as pontua — o buraco é só na âncora ISCO-88).

### `*_para_prestigio()` passa a ser o nome canônico

No Brasil, **SIOPS** é o Sistema de Informações sobre Orçamentos Públicos em
Saúde (Ministério da Saúde, LC 141/2012). Um pacote em português que exporta
`tse_para_siops()` colide em toda busca, e a interseção de públicos — saúde,
orçamento, dados administrativos — não é pequena. Ganzeboom pode usar a sigla;
um pacote brasileiro não deveria, sem mais.

São oito portas: `tse_para_prestigio()`, `tse_para_prestigio08()`,
`isco88_para_prestigio()`, `cbo2002_para_prestigio()`,
`cbo2002_para_prestigio08()`, `cbo94_para_prestigio()`, `cod_para_prestigio()` e
`cod_para_prestigio08()`. **Nenhum número muda:** as formas `*_siops()`
continuam existindo como alias, verificados idênticos um a um, e não serão
removidas de uma vez.

Junto vem o que faltava à régua: **Treiman (1977)** citado, e a advertência de
que a escala é média de estudos de ~60 países dos anos 1960–70 — aplicá-la a
dado recente pressupõe que a ordem de prestígio é invariante no tempo, que é a
tese de Treiman e não um fato dado. Ela quebra onde a ocupação mudou de posição
desde então: bancário, professor, policial, ocupações de tecnologia.

---

Correções da auditoria de 26/07/2026 (`AUDITORIA_2026-07.md`). Cinco revisores
independentes varreram o pacote linha a linha rodando R sobre 3.334.269
candidaturas.

## Mudanças que alteram resultado

Estas mudam números já obtidos com a versão 0.1.0. Quem publicou com ela deve
reconferir.

* **`crosswalk_tse()` deixa de publicar um EGP sem pequena burguesia.** A função
  chamava `isco88_para_egp(isco, avisar = FALSE)`; o `avisar = FALSE` fixo
  silenciava o aviso de EGP degradado e a coluna saía com IVa, IVb e V zeradas.
  A marca `proprietario` do dicionário é o `SEMPL` do ISMF e estava disponível o
  tempo todo. Os códigos **169, 902, 903, 904 e 905** saem de
  `II: dirigentes e profissionais inferiores` para `IVb: conta própria`.
  `tse_para_egp()` ganha `usa_proprietario = TRUE` por padrão; passe `FALSE`
  para o comportamento antigo.

* **`cbo2002_para_isco()` devolve `NA` em família sem ISCO majoritário.** Em 19
  famílias a moda não é maioria, e o desempate anterior era mudo e ia sempre
  para o menor código ISCO — efeito da ordenação lexicográfica de `table()`.
  Como a hierarquia da ISCO é ordenada por status, o menor código tem o maior
  ISEI em 16 dos 19 casos: viés sistemático, não ruído. Use `empate = "moda"`
  para o comportamento antigo.

* **`concordancia` só é afirmada sobre família vista por inteiro.** Era apurada
  sobre as ocupações que a tábua do MTE cobre, não sobre a família real: 131
  famílias tinham uma única ocupação vista e reportavam `concordancia = 1`, e em
  **87** delas a família de fato tem mais de uma. Agora fica `NA` quando
  `cobertura_familia < 1` (261 das 436); a proporção bruta segue em
  `concordancia_vista`.

* **Código sujo de RAIS/CAGED não derruba mais o vetor.** `-1`, `0000-1`,
  `{ñ class}` e `999999` — os sentinelas que o layout da RAIS **declara** —
  viram `NA` **em silêncio**, porque são a forma declarada do "ignorado", não
  sujeira (a sujeira genuína, como `AB@CD1`, avisa com
  `ocupacoesBR_codigo_invalido`). Antes abortavam a chamada inteira, e `000-1`
  sobrevivia à limpeza como a família `0001`: uma ausência virando ocupação.
  O erro ficou reservado ao caso em que nenhum valor é válido.

* **Entrada numérica recompõe o zero à esquerda.** O Novo CAGED grava a CBO como
  número, e `010105` chega como `10105`. Vale só para entrada numérica: `"111"`
  como texto continua sendo erro, porque é código malformado e não a família
  `"0111"`.

## Correções silenciosas que passaram a fazer barulho

* `isco88_para_egp()` voltou a **avisar sobre ISCO ambíguo**. Um
  `suppressWarnings()` mal posicionado envolvia `.norm_isco()` inteiro e engolia
  o aviso que a documentação prometia por escrito: quem passasse `"110"`
  querendo forças armadas recebia, calado, a classe I.
* `n_supervisionados` como `factor` agora é **erro**. Era lido como índice de
  nível (`as.numeric(factor(c("0","5","20")))` dá `1 3 2`) e produzia tabela de
  classe errada sem aviso.
* `data.frame` ou `list` na entrada agora é **erro** em todas as portas.
  `as.character()` de um quadro faz deparse por coluna, de modo que
  `tse_para_classe(df["cod"])` devolvia **um** `NA` — que, reciclado, apaga uma
  coluna inteira. `df["cod"]` é o que `data.table` e `dplyr::select()` devolvem.
* `cbo2002_concordancia()` avisa sobre família inexistente, em vez de devolver
  uma linha inteira de `NA` em silêncio.
* Todos os avisos têm **classe** (`ocupacoesBR_codigo_ausente`,
  `ocupacoesBR_egp_incompleto`, `ocupacoesBR_isco_ambiguo`,
  `ocupacoesBR_familia_empatada`, `ocupacoesBR_quebra_2002` e outros). Antes
  eram todos `simpleWarning`: quem calava o aviso rotineiro calava junto o do
  EGP incompleto, e `options(warn = 2)` transformava o rotineiro em fatal.

## Duas vinhetas

* **`vignette("qual-regua")`** — a que faltava. O pacote oferece quatro medidas
  com a mesma facilidade e nenhuma orientação sobre qual usar, e essa facilidade
  é o principal risco de usá-lo. A vinheta é sobre escolher, e cobre os sete
  erros na ordem em que são cometidos: confundir status com prestígio, tratar
  `NA` como zero, somar categoria residual a estrato, publicar EGP de onze
  classes a partir do TSE, atravessar 2002 sem `ano`, misturar as duas âncoras
  do ISEI, e não chamar `checa_cobertura()`.

  O caso que abre a vinheta: ISEI e prestígio correlacionam-se forte — e por isso
  a diferença passa despercebida —, mas **se invertem** onde importa. O
  magistrado tem ISEI 90 e prestígio 76; o enfermeiro tem ISEI 43 e prestígio 54.
  Uma pesquisa sobre posição de topo e outra sobre valorização social vão ordenar
  as profissões de saúde de formas opostas, e as duas estarão certas.

* **`vignette("validacao")`** — a aferição contra critério externo.

## A porta do IBGE, e a ponte que faltava de volta

* **`cod_para_isco08()` e companhia** abrem a **PNAD Contínua e o Censo**. A COD
  é construída sobre a ISCO-08, e por isso **428 dos seus 434 grupos de base são
  o próprio código internacional** — não há tábua a consultar. A perna cobre
  **100%** do seu universo, contra os 49,8% da perna CBO. A diferença não é de
  esforço: é de desenho das classificações.

  As seis adaptações brasileiras estão decididas e documentadas uma a uma.
  Polícia e bombeiro militar vão para o grande grupo 5 (serviços protetivos) e
  não para o 0 (forças armadas) — são militarizados em estatuto e exercem
  serviço civil, e é a função que a classificação mede. **A distinção entre
  oficial e praça se perde**, porque a ISCO-08 não a tem, e no Brasil ela é um
  degrau de status real.

* **`isco08_para_isco88()`** — a ponte de volta. O `isco0888.sps` estava no
  repositório desde sempre e nunca havia sido lido: o parser esperava
  `recode @isko (X=Y)` uma vez por linha, e o arquivo traz o `recode` uma única
  vez seguido de 596 pares soltos com sinal negativo.

  Sem ela, quem entrava pela COD alcançava o ISEI-08 mas **não** o ISEI-88 nem o
  EGP. Com ela, a PNAD chega ao esquema de classes inteiro.

  **A ida e a volta não se cancelam:** levar um código da ISCO-88 à ISCO-08 e
  trazê-lo de volta devolve o ponto de partida em **69%** dos casos. Não é
  defeito — a OIT reparte e funde categorias entre as revisões. Um teste trava o
  número, para que ninguém "conserte" a ponte inventando volta onde não há.

* Novas funções: `cod_para_isco()`, `cod_para_isei()`, `cod_para_isei08()`,
  `cod_para_prestigio()`, `cod_para_prestigio08()`, `cod_para_egp()`,
  `checa_cobertura_cod()` e `crosswalk_cod()`. Novos dados: `cod_isco08` e
  `isco08_isco88`.

* **O único buraco vem da fonte.** As forças armadas (`0110`, `0210`) ficam sem
  ISEI, prestígio e EGP porque o ISMF não pontua o ISCO-88 `0110`. São 2 dos
  434, e `NA` é a resposta correta — inventar um escore para militares seria
  pior que a ausência dele.

## A medida passa a se aferir contra algo fora dela

Até aqui, tudo no pacote era tradução — código do TSE para ISCO, ISCO para ISEI
— e nada nessa cadeia se conferia contra coisa alguma **externa**. Um crosswalk
internamente consistente pode estar inteiramente errado.

* **`tse_validacao`** — 175 ocupações com patrimônio mediano declarado e
  escolaridade, duas variáveis que o TSE coleta e que não entram na construção
  da medida em momento nenhum. Agregado, 175 linhas, nada identificável.

* **`vignette("validacao")`** — a aferição:

  | critério | Pearson | Spearman |
  |---|---|---|
  | % com ensino superior | 0,764 | 0,845 |
  | log da mediana de patrimônio | 0,671 | 0,688 |

  E o contraste que é o verdadeiro resultado: no nível do **indivíduo**, a
  correlação entre ISEI e patrimônio é de **0,207**; no da **ocupação**, 0,671.
  Isso não é defeito, é a definição — uma medida de posição ocupacional explica
  a variância *entre* ocupações e quase nada *dentro* de cada uma. Daí a regra
  prática: **não use ISEI como proxy de renda individual.**

  A vinheta também documenta onde a medida não é monótona (comerciante e
  empresário com ISEI de classe média e patrimônio de classe alta) e quantifica
  o viés de gênero: ocupações majoritariamente femininas têm **mais**
  escolaridade e **menos** ISEI.

* **Invariante I9 na suíte.** É o único teste que amarra o pacote a algo de fora
  dele mesmo: se as correlações com patrimônio e escolaridade desabarem, é a
  medida que quebrou, não o teste.

* **`isei_retrospectivo()` exportada.** Quando um registro não traz ocupação
  classificável, carrega o último escore observado **da própria pessoa**, e
  devolve junto a marca de herança e a defasagem. Nada é modelado: usa-se apenas
  a história ocupacional do indivíduo, jamais patrimônio, partido ou
  escolaridade — de modo que o escore continua independente das variáveis com
  que se vai cruzá-lo.

  Nas candidaturas ao TSE, a cobertura do ISEI sobe de 68,5% para 76,0% entre
  homens e de **52,9% para 58,7% entre mulheres**; o ganho é maior entre elas
  porque o padrão de ausência é fortemente generificado. Reimplementada em R
  base para não acrescentar dependência, e conferida contra a implementação
  original em `data.table`: escore, marca e defasagem idênticos em 3,3 milhões
  de linhas.

## A história do cadastro do TSE

O `DS_OCUPACAO` vem ao lado do `CD_OCUPACAO` nos arquivos `consulta_cand` e está
**100% preenchido nas 14 eleições de 1998 a 2024**. O pacote supunha não tê-lo:
`?checa_periodo` dizia, por escrito, *"não por rótulo — o pacote não distribui
os rótulos do TSE — e sim pelo dado"*. A resposta exata sempre esteve na coluna
ao lado.

* **`tse_ocupacao_rotulos`** — 334 vigências `(cod_tse, de, ate, rotulo)` para os
  275 códigos. Um código que nunca mudou de nome tem uma linha; um que mudou tem
  uma por período.

* **`tse_quebra_2002` reconstruída**, de 3 para 44 códigos com rótulo alterado, e
  com a coluna **`tipo`** — que é o que impede a tabela de virar um alarme falso.
  Nem toda mudança de nome é problema:

  | tipo | códigos | o que fazer |
  |---|---|---|
  | `reutilizado` | 7 (1.582 candidaturas) | o código passou a designar outra ocupação: exclua ou reclassifique |
  | `renomeado` | 4 | mesma ocupação, nome novo: nada a fazer |
  | `redefinido` | 15 | o escopo mudou: cautela |
  | `refinado` | 18 | rótulo mais preciso |

  **Quatro das sete reutilizações são invisíveis ao método anterior.** O código
  `215` era "OCUPANTE DE CARGO DE DIREÇÃO E ASSESSORAMENTO SUPERIOR" até 2000 e
  virou "ARTISTA PLÁSTICO" a partir de 2006, com variação de escolaridade de
  **+6,5 pp** — um DAS e um artista plástico têm perfil de diploma parecido, e
  por isso a heurística que só olhava escolaridade não o via.

  Na direção oposta, `601` foi de "TRABALHADOR AGRÍCOLA" para "AGRICULTOR": muda
  todo o léxico e é o mesmo ofício. Classificá-lo como reutilização mandaria
  descartar 50.139 candidaturas válidas. Por isso `tipo` é **julgamento curado
  sobre 44 casos**, e não fórmula — mas auditável na própria tabela, que carrega
  os dois rótulos ao lado das duas evidências.

  As colunas `pct_superior_*` agora são **calculadas**. Elas reproduzem
  exatamente os seis números que a versão anterior trazia digitados à mão — que
  eram a única tabela do pacote não gerada por script, e deixaram de ser.

* **`ano` nas funções de tradução.** `tse_para_isco(cod, ano)`,
  `tse_para_classe()`, `tse_para_estrato()`, `tse_para_componente_alta()` e
  `tse_para_politico()` aceitam o ano da eleição; as candidaturas cujo código
  estava sob outra ocupação voltam `NA` com aviso, em vez de traduzidas pelo
  dicionário errado. Sem `ano`, o comportamento é o de antes.

* **`tse_vigencia()`**, **`tse_diff_cadastro()`**, **`tse_para_rotulo()`** e
  **`tse_rotulo_para_cod()`**. A última torna o pacote utilizável por quem
  recebe a ocupação como texto — o caso de quem baixa
  `br_tse_eleicoes.candidatos` no `basedosdados`.

  `tse_diff_cadastro()` descreve o que quase ninguém trata: entre 2000 e 2002 o
  TSE aposentou 13 códigos (**12,2%** das candidaturas do período antigo) e
  criou 122 (**33,1%** do novo). Quem monta série 1998–2024 mede "Proprietários
  e empregadores" com dois vocabulários incomensuráveis.

* **`crosswalk_tse()` ganha `rotulo`.** Sem ele a função não servia ao uso que a
  própria documentação anuncia: ninguém audita `169 → 1300 → 51 → Proprietários`
  sem saber que 169 é COMERCIANTE.

* **`checa_periodo()` passa a distinguir por `tipo`.** Antes marcaria os 44; agora
  marca só os 7 reutilizados, e usa o ano real da reutilização em vez de um
  corte fixo em 2000.

## Novidades

* **Escada hierárquica da CBO.** `cbo2002_para_isco(cbo, escada = TRUE)` sobe da
  ocupação de seis dígitos para a família, o subgrupo e o subgrupo principal até
  achar um nível com correspondência. Sobre o domínio oficial (2.777 ocupações),
  a cobertura vai de **49,8% para 89,8%**: 1.384 diretas, 760 pela família, 306
  pelo subgrupo, 44 pelo subgrupo principal, 283 sem rota. Onde as ocupações
  mapeadas não concordam, usa-se o ancestral comum delas na ISCO — a forma
  arredondada que o ISMF publica.

  **Para em dois dígitos de propósito.** Descer a um fecharia parte das 283
  restantes cometendo a armadilha que o pacote existe para impedir: o grande
  grupo 9 da CBO é reparação e manutenção, o da ISCO é ocupações elementares.
  O padrão é `escada = FALSE`, porque o resultado deixa de ser a ocupação
  declarada e passa a ser o seu grupo; `crosswalk_cbo2002()` expõe
  `nivel_usado` para auditar caso a caso.

* **Oito funções que faltavam**, fechando a assimetria entre as portas:
  `isco88_para_isei()`, `isco88_para_siops()`, `cbo94_para_siops()`,
  `cbo94_para_isco08()`, `cbo94_para_egp()`, `cbo2002_para_isei08()`,
  `cbo2002_para_siops08()`, `checa_cobertura_cbo94()` e `crosswalk_cbo94()`.
  O ISCO-88 é o hub do pacote e era a única origem sem porta para o ISEI —
  justamente por onde chega quem vem de survey próprio ou da PNAD via COD.
  De 27 para 50 funções exportadas.

* **`isco88_para_egp()` deduplica.** Era a única função vetorial que não passava
  por `.por_unico()`: cerca de vinte `ifelse()` sobre o vetor inteiro, cada um
  alocando cópia completa. Medido em 2 milhões de linhas, mesma máquina:
  **7,42 s → 0,59 s (12,6×) e 702 Mb → 137 Mb**, com resultado `identical()`.

* `crosswalk_tse()` ganha `nivel`, `n_destinos_tse`, `n_alt_08` e `qualidade`
  (`exata` / `agregada` / `ambígua`). Metade das candidaturas é traduzida a dois
  dígitos e 52 códigos têm mais de um destino na ISCO-08; publicar tudo com a
  mesma tipografia esconde erro de medida que é correlacionado com o estrato.
* `cbo2002_familia_isco88` ganha `n_ocupacoes_cbo`, `cobertura_familia` e
  `concordancia_vista`. O denominador passa a ser o domínio oficial da CBO-2002
  no Novo CAGED (2.777 ocupações), embarcado em `inst/extdata/fontes/`.
* `inst/extdata/PROVENIENCIA.yml` registra URL, data de acesso e `sha256` de
  cada fonte, mais as âncoras de versão que as próprias fontes publicam
  (`Build 20260707-1823` do MTE; "CBO 2002 atualizada em 23/08/2004" do layout
  da RAIS). `data-raw/00_confere_proveniencia.R` confere, e um teste falha se
  divergir.

## Infraestrutura

* **As fontes passaram de `data-raw/` para `inst/extdata/` e viajam com o
  pacote.** Os três testes que amarram as tabelas às sintaxes de Ganzeboom eram
  pulados justamente no `R CMD check` — o único lugar onde a garantia importa.
* A validação cruzada contra o `DIGCLASS` passou de **uma** célula para as
  **oito** de posição no emprego × supervisão. Zero divergência: o porte de
  `iskopromo.sps` está correto também nos ramos que nunca haviam sido testados.
* Suíte: de 562 asserções com 3 `skip` para 1.219 sem nenhum.

---

# ocupacoesBR 0.1.0

Primeira versão. Duas portas de entrada (TSE e CBO-2002/CBO-94), 27 funções
exportadas, 8 conjuntos de dados, todas as tabelas geradas por script a partir
das fontes originais.

**Mudança de dado registrada retroativamente:** durante o desenvolvimento, o
código `111` do TSE passou de ISCO-88 `2220` para `2221` (e o ISEI de 85 para
88), ao descer de dois para quatro dígitos e separar médico de enfermeiro.
Resultados obtidos antes dessa correção diferem. Não havia `NEWS.md` à época —
este parágrafo existe para que a diferença seja rastreável.
