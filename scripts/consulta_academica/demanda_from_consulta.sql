CREATE SCHEMA IF NOT EXISTS demanda;

CREATE VIEW demanda.disciplina_aprovada AS (
  SELECT aluno_id, disciplina_id 
  FROM consulta.disciplina_cursada
  WHERE situacao = 'APR'
);


CREATE VIEW demanda.disciplina_remanescente AS ( 
  SELECT a.id AS aluno_id, m.disciplina_id
  FROM consulta.aluno AS a
  INNER JOIN consulta.disciplina_matriz AS m ON m.matriz_id = a.matriz_id
  LEFT JOIN demanda.disciplina_aprovada AS apr ON apr.aluno_id = a.id 
    AND apr.disciplina_id = m.disciplina_id
  WHERE apr.disciplina_id IS NULL
);

--TODO: adicionar co-requisitos?  
CREATE VIEW demanda.disciplina_demandada AS (
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
  
CREATE VIEW demanda.contagem_aluno_por_disciplina as (
  SELECT 
    disciplina_id,
    COUNT(aluno_id) AS contagem_alunos
  FROM
    demanda.disciplina_demandada 
  GROUP BY 
    disciplina_id 
);

--TODO: Fix the error of conceding partial prerequisites in this implementation
--TODO: test which implementation performs better
-- CREATE VIEW demanda.disciplina_demandadaOG AS (
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


-- EXPLAIN ANALYZE SELECT * FROM demanda.contagem_aluno_por_disciplina;