# Package index

## Escolher a régua

As réguas não são intercambiáveis, e trocar uma pela outra custa uma
letra no nome da função. Esta tabela diz qual delas responde a qual
pergunta, e quando cada uma é a escolha errada.

- [`reguas`](https://moraespeixoto.github.io/ocupacoesBR/reference/reguas.md)
  : Qual régua responde a qual pergunta

## A porta do TSE

O código de ocupação declarado nas candidaturas é a porta principal.
Cada função traduz um vetor de códigos e devolve um vetor do mesmo
comprimento. Todas aceitam `ano`, que é o que resolve a quebra de
cadastro de 2002.

- [`tse_para_isco()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isco.md)
  : Traduz a ocupação declarada ao TSE em ISCO-88
- [`tse_para_isco08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isco08.md)
  : ISCO-08 da ocupação declarada ao TSE
- [`tse_para_isei()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei.md)
  : Índice socioeconômico ISEI da ocupação declarada ao TSE
- [`tse_para_isei08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei08.md)
  : ISEI-08 da ocupação declarada ao TSE
- [`tse_para_isei_br()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_isei_br.md)
  : ISEI-BR: status ocupacional estimado em dado brasileiro
- [`tse_para_prestigio()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_prestigio.md)
  : Prestigio ocupacional de Treiman
- [`tse_para_prestigio08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_prestigio08.md)
  : Prestigio de Treiman ancorado na ISCO-08, a partir do TSE
- [`tse_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_egp.md)
  : Classe EGP da ocupação declarada ao TSE
- [`tse_para_classe()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_classe.md)
  : Classe social da ocupação declarada ao TSE
- [`tse_para_estrato()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_estrato.md)
  : Estrato social da ocupação declarada ao TSE
- [`tse_para_componente_alta()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_componente_alta.md)
  : Partição da classe alta em proprietária, credenciada e dirigente
- [`tse_para_politico()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_politico.md)
  : A ocupação declarada é um mandato ou cargo político?
- [`crosswalk_tse()`](https://moraespeixoto.github.io/ocupacoesBR/reference/crosswalk_tse.md)
  : Tabela completa de tradução, do TSE a todas as medidas

## O cadastro do TSE ao longo do tempo

O cadastro não é estável: rótulos mudam, códigos são reaproveitados e
ocupações deixam de ser declaradas. Estas funções tornam a história do
cadastro consultável em vez de suposta.

- [`tse_para_rotulo()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_rotulo.md)
  : Rótulo da ocupação, como o TSE o escreveu
- [`tse_vigencia()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_vigencia.md)
  : Em que eleições cada código esteve em vigor, e com que nome
- [`tse_diff_cadastro()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_diff_cadastro.md)
  : O que mudou no cadastro entre duas eleições
- [`tse_rotulo_para_cod()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_rotulo_para_cod.md)
  : Encontra o código a partir do rótulo da ocupação
- [`tse_codigos_autorrotulo`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_codigos_autorrotulo.md)
  : Códigos cujo rótulo é autodescrição, sem registro externo que o
  valide
- [`checa_periodo()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_periodo.md)
  : Verifica se o seu dado é atingido pela quebra de cadastro do TSE em
  2002

## A porta da CBO

A Classificação Brasileira de Ocupações, que é o que a RAIS, o CAGED e o
eSocial usam. A tradução vem da tábua oficial do Ministério do Trabalho.
`empate` decide o que fazer com famílias sem ISCO majoritário; `escada`
resgata códigos ausentes subindo a hierarquia.

- [`cbo2002_para_isco()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_isco.md)
  : Traduz a CBO-2002 em ISCO-88
- [`cbo2002_para_isco08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_isco08.md)
  : ISCO-08 a partir da CBO-2002
- [`cbo2002_para_isei()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_isei.md)
  : Indice socioeconomico ISEI a partir da CBO-2002
- [`cbo2002_para_isei08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_isei08.md)
  : ISEI-08 a partir da CBO-2002
- [`cbo2002_para_isei_br()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_isei_br.md)
  : ISEI-BR a partir da CBO-2002
- [`cbo2002_para_prestigio()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_prestigio.md)
  : Prestigio de Treiman a partir da CBO-2002
- [`cbo2002_para_prestigio08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_prestigio08.md)
  : Prestigio de Treiman ancorado na ISCO-08, a partir da CBO-2002
- [`cbo2002_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_egp.md)
  : Classe EGP a partir da CBO-2002
- [`cbo2002_concordancia()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_concordancia.md)
  : Quao homogenea e a familia da CBO-2002?
- [`crosswalk_cbo2002()`](https://moraespeixoto.github.io/ocupacoesBR/reference/crosswalk_cbo2002.md)
  : Tabela completa de traducao a partir da CBO-2002
- [`cbo94_para_isco()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo94_para_isco.md)
  : Traduz a CBO-94 em ISCO-88
- [`cbo94_para_isco08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo94_para_isco08.md)
  : ISCO-08 a partir da CBO-94
- [`cbo94_para_isei()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo94_para_isei.md)
  : Indice socioeconomico ISEI a partir da CBO-94
- [`cbo94_para_prestigio()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo94_para_prestigio.md)
  : Prestigio de Treiman a partir da CBO-94
- [`cbo94_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo94_para_egp.md)
  : Classe EGP a partir da CBO-94
- [`crosswalk_cbo94()`](https://moraespeixoto.github.io/ocupacoesBR/reference/crosswalk_cbo94.md)
  : Tabela completa de traducao a partir da CBO-94

## A porta do IBGE

A COD, usada na PNAD Contínua e no Censo, é quase a ISCO-08 com outro
nome. É por aqui que se compara candidatura com população.

- [`cod_para_isco()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cod_para_isco.md)
  : ISCO-88 a partir da COD
- [`cod_para_isco08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cod_para_isco08.md)
  : Traduz a COD do IBGE em ISCO-08
- [`cod_para_isei()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cod_para_isei.md)
  : ISEI-88 a partir da COD
- [`cod_para_isei08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cod_para_isei08.md)
  : ISEI-08 a partir da COD
- [`cod_para_isei_br()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cod_para_isei_br.md)
  : ISEI-BR a partir da COD
- [`cod_para_prestigio()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cod_para_prestigio.md)
  : Prestigio de Treiman a partir da COD
- [`cod_para_prestigio08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cod_para_prestigio08.md)
  : Prestigio de Treiman ancorado na ISCO-08, a partir da COD
- [`cod_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cod_para_egp.md)
  : Classe EGP a partir da COD
- [`crosswalk_cod()`](https://moraespeixoto.github.io/ocupacoesBR/reference/crosswalk_cod.md)
  : Tabela completa de traducao a partir da COD

## A partir da ISCO

Para quem já tem um código internacional e quer apenas a medida, ou quer
atravessar de uma revisão da ISCO para a outra.

- [`isco88_para_isei()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_para_isei.md)
  : Indice socioeconomico ISEI a partir do ISCO-88
- [`isco88_para_prestigio()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_para_prestigio.md)
  : Prestigio de Treiman a partir do ISCO-88
- [`isco88_para_egp()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_para_egp.md)
  : Traduz ISCO-88 no esquema de classes EGP
- [`isco88_para_isco08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_para_isco08.md)
  : Converte ISCO-88 em ISCO-08
- [`isco08_para_isco88()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco08_para_isco88.md)
  : Converte ISCO-08 em ISCO-88
- [`isco08_para_isei_br()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco08_para_isei_br.md)
  : ISEI-BR a partir da ISCO-08

## Cobertura, antes de analisar

Rodar uma destas antes de qualquer análise é a diferença entre uma
medida e um vetor de `NA` silencioso. Quase todo problema de cobertura é
de formato do código, não de dicionário.

- [`checa_cobertura()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_cobertura.md)
  : Verifica se todos os códigos observados estão no dicionário
- [`checa_cobertura_cbo2002()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_cobertura_cbo2002.md)
  : Verifica a cobertura de códigos da CBO-2002
- [`checa_cobertura_cbo94()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_cobertura_cbo94.md)
  : Verifica a cobertura de codigos da CBO-94
- [`checa_cobertura_cod()`](https://moraespeixoto.github.io/ocupacoesBR/reference/checa_cobertura_cod.md)
  : Verifica a cobertura de codigos da COD

## Carregamento retrospectivo

Quando a mesma pessoa aparece em eleições sucessivas, o escore de um
registro sem ocupação informada pode ser herdado do registro anterior
dela própria, com marca de herança e defasagem.

- [`isei_retrospectivo()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isei_retrospectivo.md)
  : Carrega o último escore conhecido da própria pessoa

## As tabelas

Todas as tábuas de conversão são dados do pacote, geradas por script a
partir dos arquivos originais e nunca transcritas à mão. Consultá-las
diretamente é legítimo e recomendado.

- [`tse_isco`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_isco.md)
  : Dicionário de ocupações do TSE
- [`tse_ocupacao_rotulos`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_ocupacao_rotulos.md)
  : Vigências do cadastro de ocupações do TSE, 1998–2026
- [`tse_quebra_2002`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_quebra_2002.md)
  : Códigos de ocupação do TSE que mudaram de nome ou de sentido em 2002
- [`tse_validacao`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_validacao.md)
  : Critério externo para aferir a medida: patrimônio e escolaridade por
  ocupação
- [`tse_dispersao_patrimonio`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_dispersao_patrimonio.md)
  : Dispersão do patrimônio dentro de cada nível de status
- [`tse_autorrotulo_patrimonio`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_autorrotulo_patrimonio.md)
  : Patrimônio por trás dos códigos que são autodescrição
- [`isco88_medidas`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_medidas.md)
  : Medidas ancoradas na ISCO-88
- [`isco08_medidas`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco08_medidas.md)
  : Medidas ancoradas na ISCO-08
- [`isco88_isco08`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_isco08.md)
  : Ponte da ISCO-88 para a ISCO-08
- [`isco08_isco88`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco08_isco88.md)
  : Ponte da ISCO-08 de volta para a ISCO-88
- [`cbo2002_isco88`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_isco88.md)
  : Correspondência da CBO-2002 com a ISCO-88, por ocupação
- [`cbo2002_familia_isco88`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_familia_isco88.md)
  : Correspondência da CBO-2002 com a ISCO-88, por família
- [`cbo2002_escada`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_escada.md)
  : Escada hierárquica da CBO-2002 para quando a ocupação não está na
  tábua
- [`cbo94_isco88`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo94_isco88.md)
  : Correspondência da CBO-94 com a ISCO-88
- [`cod_isco08`](https://moraespeixoto.github.io/ocupacoesBR/reference/cod_isco08.md)
  : Correspondência da COD do IBGE com a ISCO-08
- [`isco_posicao_br`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco_posicao_br.md)
  : Posição na ocupação por código ISCO-88, medida na PNAD Contínua
- [`isco08_isei_br`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco08_isei_br.md)
  : ISEI-BR: status ocupacional estimado na PNAD Contínua

## Alias depreciados

Estas funções continuam existindo para não quebrar código antigo. O nome
“SIOPS” foi trocado por “prestígio” porque colide com o Sistema de
Informações sobre Orçamentos Públicos em Saúde, que é outra coisa
inteiramente. Prefira as funções `*_prestigio*`.

- [`tse_para_siops()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_siops.md)
  : Prestígio ocupacional SIOPS da ocupação declarada ao TSE
- [`tse_para_siops08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/tse_para_siops08.md)
  : SIOPS-08 da ocupação declarada ao TSE
- [`isco88_para_siops()`](https://moraespeixoto.github.io/ocupacoesBR/reference/isco88_para_siops.md)
  : Prestigio ocupacional de Treiman (SIOPS) a partir do ISCO-88
- [`cbo2002_para_siops()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_siops.md)
  : Prestigio ocupacional SIOPS a partir da CBO-2002
- [`cbo2002_para_siops08()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo2002_para_siops08.md)
  : Prestigio ancorado na ISCO-08 a partir da CBO-2002
- [`cbo94_para_siops()`](https://moraespeixoto.github.io/ocupacoesBR/reference/cbo94_para_siops.md)
  : Prestigio ocupacional de Treiman a partir da CBO-94

## O pacote

A visão geral, com as duas portas de entrada e a política de
proveniência.

- [`ocupacoesBR`](https://moraespeixoto.github.io/ocupacoesBR/reference/ocupacoesBR-package.md)
  [`ocupacoesBR-package`](https://moraespeixoto.github.io/ocupacoesBR/reference/ocupacoesBR-package.md)
  : ocupacoesBR: da ocupação brasileira a medidas padronizadas de
  posição social
