CREATE SCHEMA IF NOT EXISTS consulta;

--TODO: situacao (do aluno no curso)
-- adicionar esse campo ajudaria a filtrar apenas os alunos ativos nos cálculos
--TODO: data_matricula, ch_acumulada, crd_acumulados, cre
-- seria interessante adicionar data de matrícula, situação, cre, créditos e CH acumulados.
-- Essa informações não são dados pessoais identificáveis e poderiam ser úteis para analisar por exemplo:
-- características da demanda de determinada disciplina, talvez faça sentido separar calouros de veteranos, 
-- as matérias com pessoas quase se formando, critérios técnicos de priorização, etc.
-- eventualmente permitir calcular quais matérias vão contribuir mais para o avanço e colação de grau dos alunos.
-- TODO: considerar se area_de_concentracao_id e linha_de_pesquisa_id seriam interessantes nesse contexto.
CREATE TABLE consulta.aluno AS (
    SELECT id, curso_id, matriz_id
    FROM alunos
);

CREATE TABLE consulta.disciplina_matriz AS (
  SELECT id, matriz_id, periodo_referencia, area_de_concentracao_id
  FROM disciplina_matrizes
);

-- TODO: perguntar se é 1 para 1 com sigla
CREATE TABLE consulta.disciplina AS (
  SELECT
    id,
    sigla,
    nome, 
    laboratorio_id, 
    ano_semestre_inicio, 
    ano_semestre_fim, 
    horas_teorica, 
    horas_pratica, 
    horas_extra_classe, 
    creditos, 
    tipo_aprovacao
  FROM disciplinas 
);

CREATE TABLE consulta.inscricao AS (
  SELECT id, turma_id, situacao, faltas, nota_ef, nota
  FROM inscricoes
);

CREATE TABLE consulta.turma AS (
  SELECT id, codigo, disciplina_id, ano_semestre 
  FROM turmas
); 

CREATE TABLE consulta.plano AS (
  SELECT id, ano_semestre, aluno_id
  FROM planos 
);

CREATE TABLE consulta.pre_requisito AS (
  SELECT pre_requisitante_id, pre_requisito_id
  FROM pre_requisitos
);

CREATE TABLE consulta.co_resuisito AS (
  SELECT co_requisitante_id, co_requisito_id
  FROM co_requisitos
);