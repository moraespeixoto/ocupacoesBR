# Artefatos da auditoria de 26/07/2026

O que os cinco pareceristas de fato **rodaram** para chegar aos números de
[`../../AUDITORIA_2026-07.md`](../../AUDITORIA_2026-07.md). Preservado aqui em
27/07/2026 porque vivia no scratchpad da sessão (`/tmp`), que é apagado.

Este diretório está dentro de `data-raw/`, logo fora do tarball
(`.Rbuildignore`). Não afeta o `R CMD check`.

## Os dois arquivos que valem mais

| arquivo | o que é | serve para |
|---|---|---|
| `vig.rds` | 334 vigências `(cod, de, ate, rotulo)` do cadastro do TSE, 1998–2024 | **é o entregável do B1**, já computado |
| `oc.rds` | 164 ocupações com `n`, `isei`, `med_patrim`, `pct_sup` | **é o dataset `tse_validacao` do B3**, já computado |

Ambos derivam de `/home/nerd/novissimos_dados_tse/resultados_eleicoes_98_24.Rda`
(397 MB) e de `DADOS/raw/microdados_classe_v2.rds` (51 MB), que não estão em git.
São agregados — nenhum caso individual, nada identificável.

**Não os adote sem conferir.** São material de auditoria, não de produção: foram
gerados uma vez, por um parecerista, sem teste. O `PLANO_29-07.md` manda
reconstruí-los por script versionado em `data-raw/`. O valor deles aqui é (a)
servir de resultado esperado para conferir a reconstrução, e (b) evitar
recomputar a partir de 5,1 GB só para saber se o número bate.

## `modelos/`

Os scripts de R na forma em que foram executados. Os que sustentam números
citados no relatório:

| script | modelo |
|---|---|
| `m7.R` | linearidade do ISEI — `lm(y ~ isei88)` vs `poly(...,3)` vs `factor(...)`; é de onde vem o R² 0,0428 / 0,0520 / 0,0761 |
| `m2.R`, `m6.R` | correlação ISEI-88 × ISEI-08 e as inversões de ordem da ponte |
| `verif*.R`, `chk*.R` | as verificações independentes (EGP degradado, códigos sujos da RAIS, `DS_OCUPACAO`, código 215) |

São scripts de sessão: caminhos absolutos, sem `set.seed`, sem cabeçalho. Leia-os
como registro do que foi feito, não como código reaproveitável.

## `fontes/`

Documentos oficiais baixados durante a auditoria. Preservados porque dependem de
sites de governo continuarem no ar, e porque são os **denominadores** de
afirmações do relatório:

| arquivo | papel |
|---|---|
| `caged_cbo_dominio.txt` | domínio oficial da CBO-2002 no Novo CAGED — **2.778 códigos**, o denominador dos 49,8% de cobertura |
| `Estrutura_Ocupacao_COD.xls` | estrutura da COD do IBGE, 434 grupos de base — insumo do **B2** (98,6% de cobertura) |
| `layout_caged.xlsx` | layout do Novo CAGED — declara `999999` e a gravação numérica que quebra o `A4` |
| `CBO2002_-_*.csv` | espelhos da estrutura da CBO |
| `Estrutura_Atividade_CNAE_Domiciliar_2_0.xls` | tradutor CNAE-Dom ↔ CNAE 2.0 (frente adiada) |

Falta a data de acesso e o hash de cada um — é justamente o que o
`PROVENIENCIA.yml` do bloco D deve passar a registrar.

## O registro completo

Toda a execução dos cinco pareceristas — cada comando e cada saída — está nas
transcrições, que são duráveis:

```
~/.claude/projects/-home-nerd-vices-do-brasil/2a8c8af0-.../subagents/agent-*.jsonl
```

| parecerista | id |
|---|---|
| engenharia R/CRAN | `a4bd50a3e1c881f84` |
| sociologia do trabalho | `a4397b95e97092119` |
| ciência política / eleitoral | `a30556092ca135b77` |
| dados administrativos | `a15a0a47514888dc0` |
| econometria / medida | `a24686b89cab9a0de` |

São ~3,2 MB de JSONL. Para consultar um número específico, `grep` neles — não
abra inteiro.

**Não preservado:** `cand_slim.rds` (874 MB), base intermediária de um
parecerista. Reconstruível a partir do `.Rda` do TSE; grande demais para versionar.
