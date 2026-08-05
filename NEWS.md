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
