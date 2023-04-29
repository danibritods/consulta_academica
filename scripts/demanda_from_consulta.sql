CREATE SCHEMA IF NOT EXISTS demanda;

--TODO: adicionar equivalências 
--TODO: adicionar aproveitamento interno

CREATE TABLE demanda.disciplina_cursada AS (
  SELECT a.id AS aluno_id, t.disciplina_id, i.situacao, i.nota
  FROM consulta.aluno AS a 
  INNER JOIN consulta.plano AS p ON p.aluno_id = a.id
  INNER JOIN consulta.inscricao AS i ON i.plano_id = p.id
  INNER JOIN consulta.turma AS t ON t.id = i.turma_id
);

CREATE TABLE demanda.disciplina_aprovada AS (
  SELECT aluno_id, disciplina_id 
  FROM demanda.disciplina_cursada
  WHERE situacao = 'APR'
);

CREATE TABLE demanda.disciplina_remanescente AS ( 
  SELECT a.id AS aluno_id, m.disciplina_id
  FROM consulta.aluno AS a
  INNER JOIN consulta.disciplina_matriz AS m ON m.matriz_id = a.matriz_id
  LEFT JOIN demanda.disciplina_aprovada AS apr ON apr.aluno_id = a.id 
    AND apr.disciplina_id = m.disciplina_id
  WHERE apr.disciplina_id IS NULL
);

--TODO: adicionar co-requisitos  
--TODO: Fix the error of conceding partial prerequisites 
--TODO: test which implementation performs better
-- CREATE TABLE demanda.disciplina_demandadaOG AS (
--   SELECT DISTINCT ON (r.aluno_id, r.disciplina_id)
--     r.aluno_id, r.disciplina_id
--   FROM demanda.disciplina_remanescente AS r
--   LEFT JOIN consulta.pre_requisito AS pr 
--     ON pr.pre_requisitante_id = r.disciplina_id
--   LEFT JOIN demanda.disciplina_aprovada AS apr 
--     ON apr.disciplina_id = pr.pre_requisito_id
--     AND apr.aluno_id = r.aluno_id
--   WHERE pr.pre_requisito_id IS NULL OR apr.disciplina_id IS NOT NULL
-- );

CREATE TABLE demanda.disciplina_demandada AS (
  SELECT r.aluno_id, r.disciplina_id
  FROM demanda.disciplina_remanescente AS r
  WHERE ARRAY(
    SELECT pr.pre_requisito_id 
    FROM consulta.pre_requisito AS pr
    WHERE pr.pre_requisitante_id = r.disciplina_id
  ) <@ ARRAY(
    SELECT apr.disciplina_id 
    FROM demanda.disciplina_aprovada AS apr
    WHERE apr.aluno_id = r.aluno_id
  ));

CREATE TABLE demanda.contagem_aluno_por_disciplina as (
  SELECT 
    disciplina_id,
    COUNT(aluno_id) AS contagem_alunos
  FROM
    demanda.disciplina_demandada 
  GROUP BY 
    disciplina_id 
);
