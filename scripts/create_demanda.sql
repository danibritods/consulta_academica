CREATE SCHEMA IF NOT EXISTS demanda

CREATE TABLE demanda.contagem_aluno_por_disciplina as (
  SELECT 
    disciplina_id,
    COUNT(aluno_id) as contagem_alunos
  FROM
    demanda.aluno_por_disciplina 
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

CREATE TABLE demanda.disciplina_demandada AS (
  SELECT aluno_id, disciplina_id 
  FROM demanda.disciplina_remanescente AS r
  

  WHERE pre_requisito_id IN 
--TODO: adicionar pré-requisitos
--TODO: adicionar co-requisitos  

);








CREATE TABLE demanda.aluno_disciplina_demandada AS (
  SELECT aluno_id, disciplina_id
  FROM academico.alunos
  JOIN academico.disciplina_matrizes 
  ON matriz_id = matriz_id 
  WHERE 
    disciplina_id IN 
      (SELECT disciplina_id FROM academico.disciplina_matrizes)
    AND disciplina_id NOT IN 
      (SELECT disciplina_id 
      FROM academico.disciplina_matrizes
      WHERE aluno_id)
);


