# ---------------------------------------------------------------------------
# documentação dos conjuntos de dados
# ---------------------------------------------------------------------------

#' ocupacoesBR: da ocupação brasileira a medidas padronizadas de posição social
#'
#' Traduz a ocupação para a ISCO-88 e a ISCO-08 e, a partir delas, para o ISEI,
#' o SIOPS, o EGP e um esquema de classes e estratos desenhado para o dado
#' eleitoral.
#'
#' Duas portas de entrada, que levam ao mesmo lugar:
#' \describe{
#'   \item{TSE}{[tse_para_isco()] e companhia, para o código de ocupação
#'     declarado nas candidaturas.}
#'   \item{CBO}{[cbo2002_para_isco()] e companhia, para a Classificação
#'     Brasileira de Ocupações usada na RAIS, no CAGED e no eSocial; e
#'     [cbo94_para_isco()] para microdado anterior a 2003.}
#' }
#'
#' O esquema de classes e estratos ([tse_para_classe()], [tse_para_estrato()])
#' existe só para a porta do TSE: ele depende de categorias que o registro
#' eleitoral cria — proprietários nomeados pelo próprio código de ocupação e
#' vínculo público sem função — e que não têm equivalente na CBO.
#'
#' Toda tabela de conversão é **gerada por script** a partir dos arquivos
#' originais guardados em `inst/extdata/fontes/`, nunca transcrita à mão. O script
#' está em `data-raw/01_gera_dados.R` e pode ser reexecutado para reconferir
#' qualquer valor contra a sua fonte.
#'
#' @keywords internal
"_PACKAGE"

#' Dicionário de ocupações do TSE
#'
#' Uma linha por código de ocupação (`CD_OCUPACAO`) das candidaturas.
#'
#' @format `data.frame` com as colunas:
#' \describe{
#'   \item{cod_tse}{código de ocupação do TSE, como texto.}
#'   \item{isco88}{ISCO-88 de quatro dígitos; `NA` quando o código não designa
#'     ocupação (não informada, fora da PEA, vínculo sem função).}
#'   \item{nivel}{número de dígitos da classificação de origem — 2, 3 ou 4.
#'     A maioria é a dois dígitos; desce-se a três ou quatro só onde dois
#'     fundiriam posições distantes demais, como médico e enfermeiro.}
#'   \item{classe}{esquema de dez categorias para o dado eleitoral.}
#'   \item{estrato}{classe alta, média, populares, ou uma das duas residuais.}
#'   \item{componente_alta}{partição da classe alta em proprietária,
#'     credenciada e dirigentes; `NA` fora dela.}
#'   \item{politico}{a ocupação é o próprio mandato ou cargo político.}
#'   \item{proprietario}{o código nomeia explicitamente um proprietário ou
#'     empregador. Define a pertença à classe "Proprietários e empregadores"
#'     no esquema de classes.}
#'   \item{conta_propria}{a pessoa trabalha por conta própria — o `SEMPL = 2`
#'     que as sintaxes do ISMF exigem para o EGP. É um **superconjunto** de
#'     `proprietario`: o agricultor (601) e o pescador (604) trabalham por
#'     conta própria sem pertencerem à classe proprietária. As duas marcas
#'     eram uma só até julho de 2026, e enquanto foram, marcar o agricultor
#'     como conta própria — o que o EGP exige para chegar a IVc — o promovia
#'     junto à classe alta, que o patrimônio não sustenta. A evidência que
#'     separou as duas está em [isco_posicao_br].}
#' }
#' @source Construído a partir dos microdados de candidaturas do Tribunal
#'   Superior Eleitoral e da correspondência com a ISCO-88.
#' @examples
#' # O agricultor trabalha por conta própria sem ser proprietário: as duas
#' # marcas eram uma só até julho de 2026, e enquanto foram, o EGP o promovia
#' # a IVc junto à classe alta.
#' tse_isco[tse_isco$cod_tse == "601", ]
#'
#' # Quantos códigos o dicionário reconhece como o próprio mandato:
#' tse_isco$cod_tse[tse_isco$politico]
"tse_isco"

#' Medidas ancoradas na ISCO-88
#'
#' @format `data.frame` com as colunas:
#' \describe{
#'   \item{isco88}{código ISCO-88 de quatro dígitos, incluindo as formas
#'     arredondadas da hierarquia (2400 para o grande grupo 24).}
#'   \item{isei88}{escore ISEI.}
#'   \item{siops88}{escore de prestígio SIOPS, de Treiman.}
#'   \item{egp}{classe EGP da tabela-base, **antes** das regras que dependem de
#'     posição na ocupação e supervisão. Não use esta coluna diretamente: use
#'     [isco88_para_egp()], que aplica as regras.}
#'   \item{rotulo}{rótulo em inglês, quando a sintaxe original o traz.}
#' }
#' @source Módulos `iskoisei.sps`, `iskotrei.sps`, `iskoroot.sps` e
#'   `iskolab.sps` do International Stratification and Mobility File,
#'   de Harry B. G. Ganzeboom e Donald J. Treiman.
#'   <http://www.harryganzeboom.nl/ismf/index.htm>
#' @examples
#' head(isco88_medidas)
#'
#' # O ISEI e o prestígio ordenam parecido, mas não igual — e é na diferença
#' # que mora a escolha entre um e outro.
#' m <- isco88_medidas[stats::complete.cases(isco88_medidas[, c("isei88",
#'                                                              "siops88")]), ]
#' round(stats::cor(m$isei88, m$siops88, method = "spearman"), 3)
"isco88_medidas"

#' Medidas ancoradas na ISCO-08
#'
#' @format `data.frame` com as colunas:
#' \describe{
#'   \item{isco08}{código ISCO-08 de quatro dígitos.}
#'   \item{isei08}{escore ISEI-08, contínuo.}
#'   \item{siops08}{escore SIOPS-08, contínuo.}
#' }
#' @source Módulos `isqoisei08.sps` e `isqotrei08.sps` do International
#'   Stratification and Mobility File.
#'   <http://www.harryganzeboom.nl/ismf/index.htm>
#' @examples
#' head(isco08_medidas)
#'
#' # A âncora é outra: um escore da ISCO-08 não é comparável com um da
#' # ISCO-88, e misturar as duas numa mesma série é o erro mais comum.
#' nrow(isco08_medidas)
#' summary(isco08_medidas$isei08)
#'
#' # Estes escores foram estimados fora do Brasil. Para a régua estimada em
#' # dado brasileiro, com o mesmo método, veja [isco08_isei_br].
"isco08_medidas"

#' Ponte da ISCO-88 para a ISCO-08
#'
#' @format `data.frame` com as colunas:
#' \describe{
#'   \item{isco88}{código de origem.}
#'   \item{isco08}{código de destino, já truncado como manda a sintaxe.}
#'   \item{n_alternativas}{quantos destinos a Organização Internacional do
#'     Trabalho define para esse código de origem. Vale 1 quando a conversão é
#'     unívoca; acima disso, a tradução é uma escolha entre alternativas, e
#'     convém dizê-lo ao leitor.}
#' }
#' @source Módulo `isco8808.sps` do International Stratification and Mobility
#'   File. <http://www.harryganzeboom.nl/ismf/index.htm>
#' @examples
#' head(isco88_isco08)
#'
#' # A ponte não é uma bijeção: 186 dos 530 códigos têm mais de um destino
#' # possível na ISCO-08, e a tábua escolhe um deles.
#' table(isco88_isco08$n_alternativas > 1)
#'
#' # Peça a marca junto com a tradução quando a ambiguidade importar:
#' isco88_para_isco08("1229", com_ambiguidade = TRUE)
"isco88_isco08"

#' Correspondência da CBO-2002 com a ISCO-88, por ocupação
#'
#' @format `data.frame` com as colunas:
#' \describe{
#'   \item{cbo2002}{código de seis dígitos, sem hífen, como nos microdados.}
#'   \item{titulo}{título da ocupação na CBO-2002.}
#'   \item{familia}{os quatro primeiros dígitos.}
#'   \item{cbo94}{código correspondente na CBO-94, sem pontuação.}
#'   \item{isco88}{código ISCO-88 de quatro dígitos.}
#' }
#' @section Cobertura:
#' A tábua do Ministério do Trabalho é uma conversão entre a CBO-2002 e a
#' CBO-94, de modo que cobre apenas as ocupações presentes nas duas
#' classificações. As ocupações criadas na revisão de 2002 e o grande grupo 0
#' (forças armadas) não têm correspondência oficial com a CIUO-88 e não
#' aparecem aqui.
#' @source Tábua de conversão CBO2002--CBO94--CIUO88 do Ministério do Trabalho,
#'   consultada família a família em
#'   <http://www.mtecbo.gov.br/cbosite/pages/tabua/FiltroConversao_CBO2002_CBO94_CIUO88.jsf>
#' @examples
#' # A tradução ocupação a ocupação, o caminho mais curto e mais confiável:
#' cbo2002_isco88[cbo2002_isco88$cbo2002 == "252105", ]
#'
#' # Quantas ocupações a tábua do MTE cobre, e quantos ISCO distintos alcança:
#' nrow(cbo2002_isco88)
#' length(unique(stats::na.omit(cbo2002_isco88$isco88)))
"cbo2002_isco88"

#' Correspondência da CBO-2002 com a ISCO-88, por família
#'
#' Para o microdado que publica apenas a família de quatro dígitos.
#'
#' @format `data.frame` com as colunas:
#' \describe{
#'   \item{familia}{código de quatro dígitos.}
#'   \item{isco88}{ISCO-88 **majoritário** entre as ocupações da família.}
#'   \item{n_ocupacoes}{quantas ocupações da família a tábua do MTE cobre.}
#'   \item{n_ocupacoes_cbo}{quantas ocupações a família tem **de fato**, pelo
#'     domínio oficial da CBO-2002.}
#'   \item{cobertura_familia}{`n_ocupacoes / n_ocupacoes_cbo`. Vale 1 quando a
#'     família foi vista por inteiro — o caso de 175 das 436.}
#'   \item{n_isco_distintos}{quantos ISCO diferentes aparecem na família.}
#'   \item{concordancia}{proporção das ocupações que caem no ISCO majoritário,
#'     **ou `NA` quando `cobertura_familia < 1`**. Vale 1 quando a família é
#'     homogênea; abaixo disso, traduzir pela família mistura posições distintas.}
#'   \item{concordancia_vista}{a mesma proporção calculada só sobre as ocupações
#'     vistas. Sempre preenchida, mas não é diagnóstico da família.}
#'   \item{empate}{`TRUE` quando a moda **não é maioria** — o ISCO escolhido só
#'     venceu por ordenação. Tratar essas famílias como uma posição única é
#'     arbitrário, e `concordancia` sozinha não distingue "dividida" de "cara ou
#'     coroa".}
#' }
#' @section Por que há duas concordâncias:
#' A tábua do MTE cobre metade da CBO-2002, e a concordância era apurada sobre
#' as ocupações **vistas**, não sobre a família real. O resultado é que 131
#' famílias tinham uma única ocupação na tábua e reportavam `concordancia = 1`
#' — o valor que sinaliza ausência total de ambiguidade — e em **87** delas a
#' família de fato tem mais de uma ocupação. Era certeza máxima onde a evidência
#' era mínima, e o README chegava a afirmar que 1 significava "a família inteira
#' cai num único ISCO".
#'
#' A separação resolve sem descartar informação: `concordancia` só é afirmada
#' sobre família vista por inteiro; `concordancia_vista` guarda a proporção
#' bruta para quem quiser inspecioná-la sabendo o que ela é.
#' @source Agregado de [cbo2002_isco88]; o denominador vem do domínio oficial da
#'   CBO-2002 na aba `cbo2002ocupação` do layout do Novo CAGED (2.777 ocupações),
#'   distribuído em `inst/extdata/fontes/cbo2002_dominio.txt`.
#' @examples
#' # As famílias em que a tábua empata: nelas, o argumento `empate` de
#' # cbo2002_para_isco() é quem decide entre NA e o ISCO majoritário.
#' cbo2002_familia_isco88[cbo2002_familia_isco88$empate,
#'                        c("familia", "isco88", "n_ocupacoes",
#'                          "n_isco_distintos")]
"cbo2002_familia_isco88"

#' Escada hierárquica da CBO-2002 para quando a ocupação não está na tábua
#'
#' Um degrau por prefixo de CBO, para subir do código de seis dígitos até um
#' nível em que a fonte permita afirmar um ISCO. Usada por
#' [cbo2002_para_isco()] com `escada = TRUE`.
#'
#' @format `data.frame` com as colunas:
#' \describe{
#'   \item{prefixo}{prefixo da CBO-2002, de 2 a 4 dígitos.}
#'   \item{nivel}{quantos dígitos tem o prefixo: 4 = família, 3 = subgrupo,
#'     2 = subgrupo principal.}
#'   \item{isco88}{ISCO-88 comum às ocupações mapeadas sob o prefixo.}
#'   \item{n_base}{quantas ocupações mapeadas sustentam o degrau.}
#' }
#' @section Como o degrau é apurado:
#' Onde as ocupações mapeadas sob o prefixo não concordam num único ISCO, usa-se
#' o **ancestral comum** delas na hierarquia da ISCO — a forma arredondada que o
#' próprio ISMF publica: `2211` e `2212` viram `2210`; `2210` e `2230` viram
#' `2200`. Só entram degraus cujo destino exista em [isco88_medidas], porque um
#' ISCO sem ISEI não serve de nada. Não há destino inventado: sobe-se até onde a
#' fonte permite afirmar, e não além.
#'
#' @section Por que para em dois dígitos:
#' Descer a um dígito fecharia boa parte das 283 ocupações que sobram sem rota,
#' e cometeria exatamente a armadilha que este pacote existe para impedir: o
#' grande grupo 9 da CBO é reparação e manutenção (ISEI ~34) e o da ISCO é o das
#' ocupações elementares (ISEI 16 a 30). Uma cobertura maior comprada com
#' inversão de classe não é cobertura.
#' @source Agregado de [cbo2002_isco88] pela hierarquia da própria CBO.
#' @examples
#' head(cbo2002_escada)
#'
#' # A escada tem três degraus — prefixo de quatro, três e dois dígitos — e é
#' # tentada, nessa ordem, só sobre o que sobrou NA com `escada = TRUE`.
#' table(cbo2002_escada$nivel)
"cbo2002_escada"

#' Correspondência da CBO-94 com a ISCO-88
#'
#' Para microdado anterior a 2003.
#'
#' @format `data.frame` com as colunas:
#' \describe{
#'   \item{cbo94}{código da CBO-94, sem pontuação.}
#'   \item{isco88}{ISCO-88 correspondente.}
#' }
#' @section Sem agregação:
#' A tábua do MTE é 1:1 entre CBO-94 e CBO-2002 — cada linha traz um par —, de
#' modo que não há maioria a apurar. Uma versão anterior desta tabela trazia uma
#' coluna `concordancia` que era constante 1 por construção e sugeria um
#' diagnóstico que não existia.
#' @source Coluna CBO-94 da mesma tábua do Ministério do Trabalho.
#' @examples
#' head(cbo94_isco88)
#'
#' # A CBO-94 chega à ISCO-88 e para aí: não há cbo94_para_isei08() nem
#' # cbo94_para_prestigio08(). A assimetria é da tábua, não do pacote.
#' nrow(cbo94_isco88)
"cbo94_isco88"

#' Vigências do cadastro de ocupações do TSE, 1998--2026
#'
#' Uma linha por **vigência**: o período em que um código carregou um dado
#' rótulo. Um código que nunca mudou de nome tem uma linha; um que mudou tem uma
#' por período. É a diferença entre um dicionário e a história de um cadastro.
#'
#' @format `data.frame` com 334 linhas e as colunas:
#' \describe{
#'   \item{cod_tse}{código de ocupação.}
#'   \item{de, ate}{primeiro e último ano de eleição em que a vigência valeu.}
#'   \item{rotulo}{o `DS_OCUPACAO` como o TSE o escreveu, forma modal do período.}
#'   \item{n}{candidaturas na vigência.}
#' }
#' @section Vigência não é presença:
#' Um código sem candidato numa eleição continua na vigência: o contrário faria
#' uma ocupação rara "sumir e voltar" a cada pleito. A vigência se interrompe
#' quando o **rótulo** muda, não quando a frequência cai a zero.
#' @source `DS_OCUPACAO` dos arquivos `consulta_cand` do TSE, 1998--2026
#'   (3.369.244 candidaturas, campo 100% preenchido nas 15 eleições). A safra
#'   de 2026 é a geração de 01/09/2026, 12:31, e é **aberta**: o prazo de
#'   registro encerrou em 15/08/2026, mas o Tribunal ainda julga e publica
#'   candidaturas, de modo que o `n` de 2026 há de crescer. O rótulo, que é o
#'   que esta tabela guarda, não depende disso.
#' @examples
#' # O que as candidaturas mais declaram, em 1998--2026 somados:
#' r <- tse_ocupacao_rotulos
#' head(r[order(-r$n), c("cod_tse", "rotulo", "n")], 5)
#'
#' # Os códigos vigentes na safra em curso:
#' sum(r$ate == 2026)
#'
#' # Um código pode ter mais de uma vigência, com rótulos diferentes:
#' r[r$cod_tse == "215", ]
"tse_ocupacao_rotulos"

#' Códigos de ocupação do TSE que mudaram de nome ou de sentido em 2002
#'
#' O TSE reeditou a tabela de ocupações entre as eleições de 2000 e 2002. Nem
#' toda mudança de rótulo é problema, e é por isso que esta tabela tem a coluna
#' `tipo`: só `reutilizado` invalida a tradução. Use [checa_periodo()] para
#' saber se o seu dado é atingido, e [tse_vigencia()] para ver a história de um
#' código.
#'
#' @format `data.frame` com 44 linhas e as colunas:
#' \describe{
#'   \item{cod_tse}{o código.}
#'   \item{rotulo_ate_2000, rotulo_apos_2002}{como o TSE o chamava antes e depois.}
#'   \item{ultimo_ano_antigo, primeiro_ano_novo}{as eleições comparadas.}
#'   \item{n_ate_2000}{candidaturas com esse código até 2000.}
#'   \item{similaridade}{sobreposição de palavras entre os dois rótulos (0 a 1).}
#'   \item{pct_superior_ate_2000, pct_superior_apos_2002, delta_pp}{proporção com
#'     ensino superior completo em cada período, e a diferença.}
#'   \item{delta_vs_tendencia}{`delta_pp` menos a tendência geral do período
#'     (+7,8 pp). `NA` onde há menos de 30 candidaturas em algum dos lados, que é
#'     pouco para o sinal significar coisa alguma.}
#'   \item{tipo}{`reutilizado`, `renomeado`, `redefinido` ou `refinado`.}
#' }
#' @section Por que `tipo` é um julgamento, e não uma fórmula:
#' Há dois sinais disponíveis, e **nenhum dos dois basta**:
#'
#' O rótulo `601` foi de "TRABALHADOR AGRÍCOLA" para "AGRICULTOR": muda todo o
#' léxico e é o mesmo ofício — a população sob o código nem se move (+2,2 pp,
#' abaixo da tendência). Tratá-lo como reutilização mandaria descartar 52.090
#' candidaturas válidas.
#'
#' O `215` foi de "OCUPANTE DE CARGO DE DIREÇÃO E ASSESSORAMENTO SUPERIOR" para
#' "ARTISTA PLÁSTICO": reutilização inequívoca que **não move a escolaridade**
#' (+6,5 pp), porque um DAS e um artista plástico têm perfil de diploma
#' parecido. Foi por isso que a versão anterior desta tabela, que só olhava
#' escolaridade, não o via — e ela documentava 3 códigos onde há 7.
#'
#' Quatro das sete reutilizações são invisíveis ao sinal de escolaridade. A
#' distinção é semântica, e nenhuma métrica automática a alcança. São 44 casos:
#' o `tipo` foi julgado um a um, e o julgamento é **auditável na própria
#' tabela** — os dois rótulos viajam ao lado das duas evidências.
#'
#' @section O que fazer com cada tipo:
#' \describe{
#'   \item{reutilizado (7 códigos, 1.628 candidaturas)}{o código passou a
#'     designar outra ocupação. Traduzir o período antigo pelo dicionário é
#'     erro; exclua ou reclassifique.}
#'   \item{renomeado (4)}{mesma ocupação, nome novo. Não é problema — está aqui
#'     para que ninguém a confunda com reutilização ao comparar rótulos.}
#'   \item{redefinido (15)}{o escopo mudou. Cautela.}
#'   \item{refinado (18)}{mesmo posto, rótulo mais preciso.}
#' }
#' @source Rótulos e escolaridade das candidaturas de 1998 a 2026. Os valores de
#'   `pct_superior_*` reproduzem exatamente os que a versão anterior desta
#'   tabela trazia digitados à mão — que era a única tabela do pacote não
#'   gerada por script, e deixou de ser.
#' @examples
#' # Os códigos reutilizados: o mesmo número, outra ocupação. Ler qualquer um
#' # deles como série contínua de 1998 a hoje produz uma trajetória que nunca
#' # existiu.
#' tse_quebra_2002[tse_quebra_2002$tipo == "reutilizado",
#'                 c("cod_tse", "rotulo_ate_2000", "rotulo_apos_2002")]
#'
#' # A que tipo pertence cada um dos 44:
#' table(tse_quebra_2002$tipo)
"tse_quebra_2002"

#' Critério externo para aferir a medida: patrimônio e escolaridade por ocupação
#'
#' Agregado por ocupação de duas variáveis que o TSE coleta e que **não entram
#' na construção da medida em momento nenhum**: o patrimônio declarado na
#' candidatura e o grau de instrução. É contra ele que a vinheta
#' `vignette("validacao")` afere o ISEI.
#'
#' @format `data.frame` com 221 linhas e as colunas:
#' \describe{
#'   \item{cod_tse}{código de ocupação.}
#'   \item{n}{candidaturas com esse código, 1998--2026.}
#'   \item{pct_superior}{% com ensino superior completo.}
#'   \item{pct_mulher}{% de mulheres.}
#'   \item{n_com_bens}{candidaturas com patrimônio declarado maior que zero.}
#'   \item{mediana_patrimonio}{mediana do patrimônio declarado, em reais.
#'     **`NA` onde `n_com_bens < 200`** — ver a seção sobre o piso.}
#' }
#' @section Por que agregado, e por que este piso:
#' A unidade é a **ocupação**, não a candidatura, porque é nesse nível que uma
#' medida de posição ocupacional é definida, e porque um agregado de 221 linhas
#' não é microdado, não identifica ninguém e pode viajar com o pacote.
#'
#' Entram ocupações com pelo menos 200 candidaturas. A mediana de patrimônio
#' exige um segundo piso, de 200 declarações de bens, porque mediana apoiada em
#' poucas declarações é ruidosa: sem ele a correlação com o ISEI cai de 0,681
#' para cerca de 0,63, não porque a medida piore, mas porque o critério externo
#' fica instável.
#'
#' **O segundo piso zera a mediana; não descarta a linha**, e a diferença
#' importa. Até 29/07/2026 ele descartava a linha inteira, o que amputava do
#' conjunto 46 ocupações cuja escolaridade e cuja composição por gênero estão
#' perfeitamente medidas e que apenas carecem de declarações de bens. A
#' consequência era que a regressão de gênero documentada em [tse_para_isei()]
#' não se reproduzia a partir do dado publicado. Hoje reproduz. Quem correlacionar
#' com patrimônio deve filtrar `!is.na(mediana_patrimonio)`; quem usar
#' escolaridade ou gênero tem as 221 linhas à disposição.
#'
#' @section As correlações que este conjunto sustenta:
#' Contra a escolaridade, sobre as 208 ocupações com ISEI: r = 0,765 (Spearman
#' 0,812). Contra o logaritmo da mediana de patrimônio, sobre as 165 que também
#' têm mediana: r = 0,681 (Spearman 0,695). No nível do **indivíduo** a
#' correlação com patrimônio é de apenas 0,207, e o contraste entre 0,207 e 0,681
#' é o resultado, não um defeito: o ISEI explica a variação entre ocupações e
#' quase nada dentro de cada uma.
#' @section O patrimônio de 2026 não entra, e por quê:
#' A safra de 2026 contribui para `n`, `pct_superior` e `pct_mulher`, e **se
#' abstém de `n_com_bens` e da mediana de patrimônio**. A razão é de unidade,
#' não de qualidade do dado: o patrimônio está deflacionado a reais de outubro
#' de 2024, pelo número-índice do IPCA do mês da eleição, e outubro de 2026
#' ainda não aconteceu. Deflacionar por um mês que não é o da eleição poria na
#' coluna um valor que a definição da coluna desmente.
#'
#' A assimetria não é nova: `n` sempre cobriu um período mais largo do que
#' `n_com_bens`, porque o TSE só publica declaração de bens a partir de 2006 e
#' as candidaturas de 1998 a 2004 já entravam nessa mesma condição. Quando o
#' IPCA de outubro de 2026 existir, a coluna sai de graça.
#'
#' @source Declaração de bens e grau de instrução das candidaturas ao TSE,
#'   1998--2026 (patrimônio: 2006--2024; ver a seção acima).
#' @examples
#' # As ocupações com mais candidaturas no conjunto de validação:
#' head(tse_validacao[order(-tse_validacao$n), ], 5)
#'
#' # A correlação que sustenta a medida: o ISEI atribuído por tradução contra
#' # a escolaridade declarada, que o pacote nunca viu ao construir a régua.
#' v <- tse_validacao
#' v$isei <- suppressWarnings(tse_para_isei(v$cod_tse))
#' round(stats::cor(v$isei, v$pct_superior, use = "complete.obs"), 3)
"tse_validacao"

#' Dispersão do patrimônio dentro de cada nível de status
#'
#' Somatórios que reproduzem, sem microdado, a correlação entre o índice de
#' status e o patrimônio declarado **no nível do indivíduo** — o número que
#' quantifica o que uma escala de posição ocupacional não explica.
#'
#' @format `data.frame` com 29 linhas e 6 colunas:
#' \describe{
#'   \item{isei88}{escore ISEI-88, que é discreto: cada código do dicionário
#'     tem um valor só, e a tabela agrupa por ele.}
#'   \item{n}{candidaturas com escore e com patrimônio declarado positivo.}
#'   \item{soma_log}{soma do logaritmo natural do patrimônio no grupo.}
#'   \item{soma_log2}{soma dos quadrados desses logaritmos.}
#'   \item{media_log}{média do log do patrimônio, arredondada.}
#'   \item{sd_log}{desvio padrão do log do patrimônio DENTRO do grupo.}
#' }
#'
#' @section Por que somatórios e não os dados:
#' O coeficiente de Pearson é função apenas de \eqn{n}, \eqn{\sum x},
#' \eqn{\sum y}, \eqn{\sum x^2}, \eqn{\sum y^2} e \eqn{\sum xy}. Como o
#' ISEI é constante dentro do grupo, essas seis quantidades se recuperam das
#' colunas acima, e o coeficiente sai **exato** — não aproximado. O que a
#' tabela descarta é tudo o que o coeficiente não usa, isto é, a candidatura
#' individual. É o que permite publicar o número mantendo a política de não
#' distribuir microdado de patrimônio.
#'
#' @section O contraste que a tabela existe para sustentar:
#' No nível da **ocupação**, o ISEI correlaciona-se a 0,681 com o log da
#' mediana de patrimônio (veja [tse_validacao]). No nível do **indivíduo**,
#' a 0,207. A queda não é defeito de medida: é a definição operacional do que
#' uma escala de posição ocupacional faz, que é explicar a variação *entre*
#' ocupações e quase nada *dentro* de cada uma. A coluna `sd_log` mostra o
#' fenômeno diretamente — o desvio padrão do log do patrimônio dentro de um
#' mesmo nível de status é da ordem de 1,7, isto é, uma ordem de grandeza.
#' A consequência prática está em [tse_para_isei()]: **não use o ISEI como
#' proxy de renda ou de patrimônio individual.**
#'
#' @source Declaração de bens das candidaturas ao TSE, 2006--2024, agregada
#'   por `data-raw/08_gera_dispersao.R`. O patrimônio é deflacionado a reais
#'   de outubro de 2024; 2026 não entra, pela razão exposta em [tse_validacao].
#' @seealso [tse_validacao], para a validação no nível da ocupação.
#' @examples
#' # A correlação individual, recuperada dos somatórios (exata):
#' d <- tse_dispersao_patrimonio
#' N <- sum(d$n); sx <- sum(d$isei88 * d$n); sy <- sum(d$soma_log)
#' sxx <- sum(d$isei88^2 * d$n); syy <- sum(d$soma_log2)
#' sxy <- sum(d$isei88 * d$soma_log)
#' round((N * sxy - sx * sy) /
#'         sqrt((N * sxx - sx^2) * (N * syy - sy^2)), 3)
#'
#' # A dispersão dentro do nível de status, que é o mesmo fato visto de perto:
#' summary(d$sd_log)
"tse_dispersao_patrimonio"

#' Ponte da ISCO-08 de volta para a ISCO-88
#'
#' @format `data.frame` com 590 linhas:
#' \describe{
#'   \item{isco08}{código de origem.}
#'   \item{isco88}{código de destino na revisão de 1988.}
#' }
#' @section A ida e a volta não se cancelam:
#' Levar um código da ISCO-88 à ISCO-08 por [isco88_para_isco08()] e trazê-lo de
#' volta por [isco08_para_isco88()] devolve o ponto de partida em **69% dos
#' casos**. O terço restante não é defeito: a OIT reparte e funde categorias
#' entre as revisões, e a composição das duas concordâncias não é a identidade.
#'
#' Esta tabela é o que destrava o EGP e o ISEI-88 para quem entra pela COD — a
#' PNAD Contínua e o Censo aterrissam na ISCO-08, e todo o esquema de classes do
#' pacote está ancorado na ISCO-88.
#' @source Módulo `isco0888.sps` do International Stratification and Mobility
#'   File. <http://www.harryganzeboom.nl/ismf/index.htm>
#' @examples
#' head(isco08_isco88)
#'
#' # É esta tábua que permite entrar pela PNAD ou pelo Censo e chegar às
#' # medidas ancoradas na ISCO-88.
#' nrow(isco08_isco88)
"isco08_isco88"

#' Correspondência da COD do IBGE com a ISCO-08
#'
#' A Classificação de Ocupações para Pesquisas Domiciliares é a da PNAD Contínua
#' e do Censo Demográfico.
#'
#' @format `data.frame` com 434 linhas:
#' \describe{
#'   \item{cod}{grupo de base da COD, quatro dígitos.}
#'   \item{titulo}{denominação oficial.}
#'   \item{isco08}{código ISCO-08 correspondente.}
#'   \item{correspondencia}{`identidade` (428 casos), `adaptacao` (5) ou
#'     `agregacao` (1).}
#' }
#' @section Por que quase tudo é identidade:
#' A COD é construída **sobre** a ISCO-08. Não há tábua de conversão a consultar:
#' 428 dos 434 grupos de base são o próprio código internacional. O que resta são
#' seis adaptações brasileiras, documentadas uma a uma em [cod_para_isco08()] —
#' polícia e bombeiro militar, trabalhadores do sexo e pescadores.
#'
#' O contraste com a perna da CBO é de desenho, não de esforço: aquela depende de
#' uma tábua do Ministério do Trabalho que cobre metade do seu universo; esta
#' cobre 100% do seu.
#' @source Estrutura da Ocupação (COD), IBGE, distribuída em
#'   `inst/extdata/fontes/Estrutura_Ocupacao_COD.xls`.
#' @examples
#' head(cod_isco08)
#'
#' # Quase tudo é identidade — a COD do IBGE é a ISCO-08 com outro nome. As
#' # poucas exceções são onde vale olhar antes de confiar.
#' table(cod_isco08$correspondencia)
#' cod_isco08[cod_isco08$correspondencia != "identidade", ]
"cod_isco08"

#' Posição na ocupação por código ISCO-88, medida na PNAD Contínua
#'
#' A distribuição brasileira de posição no emprego — conta própria, empregador,
#' número de empregados — para cada código ISCO-88, apurada nos microdados da
#' PNAD Contínua de 2025.
#'
#' @format `data.frame` com 319 linhas:
#' \describe{
#'   \item{isco88}{código ISCO-88 de quatro dígitos.}
#'   \item{n_pessoas}{pessoas distintas observadas (a medida honesta de
#'     precisão; veja a seção sobre o painel).}
#'   \item{n_obs}{observações pessoa-trimestre.}
#'   \item{pct_conta_propria}{% que trabalha por conta própria **ou** é
#'     empregadora — o `SEMPL = 2` das sintaxes do ISMF.}
#'   \item{pct_empregador}{% que é empregadora.}
#'   \item{pct_emp_11mais}{entre os empregadores, % com 11 ou mais empregados —
#'     o limiar que separa a ISCO 12 da 13. `NA` onde há menos de 25
#'     empregadores na célula.}
#'   \item{grupo}{o grande grupo de dois dígitos.}
#'   \item{n_pessoas_grupo, pct_conta_propria_grupo, pct_empregador_grupo}{o
#'     mesmo, apurado no grupo de dois dígitos. Cada linha carrega a sua própria
#'     estimativa e a do grupo, para que quem cair numa célula fina possa recuar
#'     um nível sem refazer a conta — e veja, lado a lado, com que `n` cada uma
#'     foi apurada.}
#' }
#'
#' @section Para que serve:
#' O EGP não é função só da ocupação: as regras do ISMF pedem a posição no
#' emprego e a supervisão. O formulário do TSE não pergunta nenhuma das duas, e
#' por isso o esquema sai degradado (veja [isco88_para_egp()]). Esta tabela é o
#' **prior empírico** dessa variável ausente: não imputa a posição de ninguém,
#' e sim informa qual é a composição da ocupação no país.
#'
#' O uso legítimo é análise de sensibilidade — rodar o EGP com e sem a posição
#' provável e ver se a conclusão se move. O uso ilegítimo é tratar a proporção
#' como se fosse o caso individual.
#'
#' @section O painel rotativo:
#' A PNAD reentrevista o mesmo domicílio por cinco trimestres. Os quatro
#' trimestres de 2025 somam 864.870 observações de **437.880 pessoas
#' distintas** (1,98x). Somá-los como amostras independentes inflaria o `n` sem
#' acrescentar informação na mesma proporção. Por isso os pesos são divididos
#' pelo número de trimestres — as estimativas são a média do ano civil, com os
#' pesos somando a população e não quatro vezes ela — e a coluna de precisão é
#' `n_pessoas`.
#'
#' @section O que ela mostra, e por que isso importa:
#' A ISCO 61 é, na definição da OIT, quem **opera a própria terra**; a 92 é o
#' assalariado rural. O dado brasileiro separa as duas com folga:
#'
#' | ISCO-88 | conta própria ou empregador |
#' |---|---|
#' | 61 (agrícolas qualificados) | 67,6% |
#' | 6150 (pesca) | 83,8% |
#' | 92 (rurais elementares) | 16,5% |
#' | todas as ocupações | 29,4% |
#'
#' É a evidência externa que motivou separar `tse_isco$conta_propria` de
#' `tse_isco$proprietario`: o agricultor familiar trabalha por conta própria
#' sem pertencer à classe proprietária.
#'
#' Como candidatos são selecionados por patrimônio, tomar estas proporções
#' como piso — e não como estimativa central — é a leitura conservadora.
#'
#' @source Microdados da PNAD Contínua trimestral, IBGE, quatro trimestres de
#'   2025, acessados em 28/07/2026.
#'   <https://ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Trimestral/Microdados/>
#'   Gerada por `data-raw/07_gera_posicao.R`. Os microdados **não** viajam com o
#'   pacote (212 MB por trimestre); o que entra é esta tabela agregada.
#' @examples
#' # Dentro do mesmo ISCO convivem quem trabalha por conta própria e quem
#' # emprega. É esta tabela, medida na PNAD Contínua, que separa os dois — e
#' # foi ela que tirou o agricultor da classe alta.
#' p <- isco_posicao_br
#' head(p[order(-p$pct_conta_propria),
#'        c("isco88", "n_obs", "pct_conta_propria", "pct_empregador")], 5)
"isco_posicao_br"

#' ISEI-BR: status ocupacional estimado na PNAD Contínua
#'
#' O ISEI que o pacote carregava era importado: Ganzeboom, De Graaf e Treiman
#' (1992) escalonaram a ISCO sobre dado de dezesseis países, nenhum deles o
#' Brasil. Esta tabela é o mesmo procedimento refeito do zero sobre a PNAD
#' Contínua de 2025. Ela fecha a lacuna que `vignette("validacao")` declarava
#' em aberto.
#'
#' @format `data.frame` com 590 linhas, uma para cada chave de
#'   [isco08_medidas], e as colunas:
#' \describe{
#'   \item{isco08}{código ISCO-08 de quatro dígitos.}
#'   \item{isei_br}{escore, contínuo entre 10 e 90.}
#'   \item{n_pessoas}{pessoas distintas na célula que forneceu o escore.}
#'   \item{n_obs}{observações trimestrais nessa mesma célula.}
#'   \item{nivel}{em quantos dígitos o escore foi apurado: 4 é a própria
#'     ocupação, 3, 2 e 1 são grupos cada vez mais grossos.}
#'   \item{anos_estudo}{média de anos de estudo na célula, sem residualizar.}
#'   \item{log_renda}{média do log do rendimento habitual, sem residualizar.}
#' }
#'
#' Os atributos `theta`, `beta_direto`, `beta_total` e `parcela_mediada`
#' guardam os parâmetros da estimação.
#'
#' @section Método:
#' A ocupação entra como variável interveniente entre escolaridade e renda, e o
#' escore de cada ocupação é a combinação das médias de escolaridade e de renda
#' dos seus ocupantes que minimiza o efeito direto da escolaridade sobre a
#' renda. A amostra tem idade de 21 a 64 anos, ambos os sexos, pelo menos 30
#' horas semanais no trabalho principal e rendimento habitual positivo.
#' Escolaridade e renda entram residualizadas em idade, idade ao quadrado, sexo
#' e trimestre. O peso é dividido pelo número de trimestres, porque a PNAD é
#' painel rotativo e a mesma pessoa reaparece.
#'
#' @section O resíduo, que é achado e não defeito:
#' O procedimento de 1992 supõe que a ocupação medeia integralmente a relação
#' entre escolaridade e renda, e escolhe o ângulo onde o efeito direto zera. No
#' Brasil ele não zera. A curva tem mínimo interior e para em 0,206, contra um
#' efeito total de 0,494, de modo que a ocupação medeia 58,4% do efeito. Os
#' outros 41,6% são escolaridade que paga dentro da mesma ocupação, o que se lê
#' como heterogeneidade intraocupacional e informalidade. Adota-se o ângulo de
#' mínimo e publica-se o resíduo.
#'
#' @section Sensibilidade:
#' O ordenamento não depende do ângulo exato nem das escolhas de método. A
#' correlação de Spearman entre a escala no ângulo adotado e em mais ou menos
#' 0,15 radianos é de 0,999. Sete especificações alternativas foram testadas,
#' entre elas exigir 40 horas, dispensar a restrição de horas, usar renda-hora,
#' usar rendimento efetivo, restringir a homens como o artigo de 1992 fez, e
#' usar escolaridade em categorias: nenhuma move o ordenamento abaixo de 0,99
#' contra a especificação adotada, e a parcela mediada fica sempre entre 57,9%
#' e 60,1%.
#'
#' @section O que se perde:
#' A COD funde oficiais e praças de polícia e bombeiro militar, então a escala
#' não distingue os dois. Códigos da ISCO-08 em que nenhuma COD aterrissa
#' herdam o escore do grupo acima. Dos 407 códigos de quatro dígitos, 348 têm
#' escore próprio e 59 são herdados por terem menos de 30 pessoas na amostra.
#' As outras 183 linhas são as formas arredondadas de dois e três dígitos, que
#' existem porque a ocupação declarada ao TSE é grossa e aterrissa nelas.
#'
#' @section O que ela não é:
#' Não é substituta do ISEI-08. Comparação internacional continua exigindo a
#' âncora internacional, e uma série não troca de régua no meio. É um ano só,
#' 2025, e não forma série.
#'
#' @references
#' Ganzeboom, H. B. G., De Graaf, P. M., & Treiman, D. J. (1992). A standard
#' international socio-economic index of occupational status.
#' *Social Science Research*, 21(1), 1-56.
#'
#' @source PNAD Contínua trimestral, microdados dos quatro trimestres de 2025,
#'   IBGE. Acesso em 05/09/2026. Gerada por `data-raw/09_gera_isei_br.R`; os
#'   sha256 dos arquivos estão em `inst/extdata/PROVENIENCIA.yml`.
#' @seealso [tse_para_isei_br()] e as irmãs por COD, CBO-2002 e CBO-94.
#' @examples
#' head(isco08_isei_br)
#'
#' # Concorda com a âncora internacional sem ser cópia dela.
#' f <- isco08_isei_br[isco08_isei_br$nivel == 4, ]
#' i <- isco08_medidas$isei08[match(f$isco08, isco08_medidas$isco08)]
#' round(stats::cor(f$isei_br, i, use = "complete.obs", method = "spearman"), 3)
#'
#' # Os parâmetros da estimação viajam com a tabela.
#' attributes(isco08_isei_br)[c("theta", "parcela_mediada")]
"isco08_isei_br"
