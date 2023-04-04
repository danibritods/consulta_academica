CREATE SCHEMA IF NOT EXISTS demanda

CREATE TABLE demanda.contagem_aluno_por_disciplina as (
  SELECT 
    disciplina_id,
    COUNT(aluno_id) AS contagem_alunos
  FROM
    demanda.disciplina_demandada 
  GROUP BY 
    disciplina_id 
);

--TODO: adicionar equivalências 
--TODO: adicionar aproveitamento interno
CREATE TABLE demanda.disciplina_aprovada AS (
  SELECT a.aluno_id, m.disciplina_id -- TODO: considerar usar WITH 
  FROM consulta.aluno AS a
  INNER JOIN consulta.disciplina_matriz AS m ON matriz_id = a.matriz_id
  INNER JOIN consulta.plano AS p on aluno_id = a.aluno_id 
  INNER JOIN consulta.inscricao AS i ON plano_id = p.plano_id
  WHERE situacao == "APR" 
);

CREATE TABLE demanda.disciplina_remanescente AS ( --TODO: melhorar o nome
  SELECT a.aluno, m.disciplina_id
  FROM consulta.aluno AS a
  INNER JOIN consulta.disciplina_matriz AS m ON matriz_id = a.matriz_id
  JOIN demanda.disciplina_aprovada AS apr ON aluno_id = a.aluno_id
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