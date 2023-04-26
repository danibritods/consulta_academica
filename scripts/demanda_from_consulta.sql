CREATE SCHEMA IF NOT EXISTS demanda;

--TODO: adicionar equivalências 
--TODO: adicionar aproveitamento interno
CREATE TABLE demanda.disciplina_aprovada AS (
  SELECT a.id AS aluno_id, m.disciplina_id -- TODO: considerar usar WITH 
  FROM consulta.aluno AS a
  INNER JOIN consulta.plano AS p on p.aluno_id = a.id 
  INNER JOIN consulta.inscricao AS i ON i.plano_id = p.id
  INNER JOIN consulta.disciplina_matriz AS m ON m.id = a.matriz_id
  WHERE situacao = 'APR'
);

CREATE TABLE demanda.disciplina_remanescente AS ( --TODO: melhorar o nome
  SELECT a.id AS aluno_id, m.disciplina_id
  FROM consulta.aluno AS a
  JOIN demanda.disciplina_aprovada AS apr ON apr.aluno_id = a.id
  INNER JOIN consulta.disciplina_matriz AS m ON m.id = a.matriz_id
  WHERE m.disciplina_id <> apr.disciplina_id
);

--TODO: adicionar co-requisitos  
CREATE TABLE demanda.disciplina_demandada AS (
  SELECT r.aluno_id, r.disciplina_id 
  FROM demanda.disciplina_remanescente AS r
  LEFT JOIN consulta.pre_requisito AS pr 
    ON pr.pre_requisitante_id = r.disciplina_id
  LEFT JOIN demanda.disciplina_aprovada AS apr 
    ON apr.disciplina_id = pr.pre_requisito_id
    AND apr.aluno_id = r.aluno_id
  WHERE pr.pre_requisito_id IS NULL OR apr.disciplina_id IS NOT NULL
);

CREATE TABLE demanda.contagem_aluno_por_disciplina as (
  SELECT 
    disciplina_id,
    COUNT(aluno_id) AS contagem_alunos
  FROM
    demanda.disciplina_demandada 
  GROUP BY 
    disciplina_id 
);
