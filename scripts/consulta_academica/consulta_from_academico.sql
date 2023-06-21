CREATE SCHEMA IF NOT EXISTS consulta;

CREATE TABLE consulta.aluno AS (
    SELECT id, curso_id, matriz_id
    FROM alunos
);

CREATE TABLE consulta.disciplina_matriz AS (
  SELECT id, matriz_id, disciplina_id, periodo_referencia, area_de_concentracao_id
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
  SELECT id, plano_id, turma_id, situacao, faltas, nota_ef, nota
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

--TODO: adicionar equivalências 
--TODO: adicionar aproveitamento interno
CREATE TABLE consulta.disciplina_cursada_inscricao AS (
  SELECT a.id AS aluno_id, t.disciplina_id, i.situacao, i.nota
  FROM consulta.aluno AS a 
  INNER JOIN consulta.plano AS p ON p.aluno_id = a.id
  INNER JOIN consulta.inscricao AS i ON i.plano_id = p.id
  INNER JOIN consulta.turma AS t ON t.id = i.turma_id
);

CREATE TABLE consulta.disciplina_cursada AS (
  SELECT aluno_id, disciplina_id, situacao, nota, 'inscricao' AS origem
  FROM consulta.disciplina_cursada_inscricao
);
