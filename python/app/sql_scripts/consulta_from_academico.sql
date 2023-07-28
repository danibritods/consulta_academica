DROP SCHEMA IF EXISTS consulta CASCADE;
CREATE SCHEMA IF NOT EXISTS consulta;
CREATE ROLE query_consulta PASSWORD 'query_consulta';
GRANT USAGE ON SCHEMA consulta TO query_consulta;
ALTER DEFAULT PRIVILEGES IN SCHEMA consulta GRANT SELECT ON TABLES TO query_consulta;

CREATE TABLE consulta.aluno AS (
    SELECT id, curso_id, matriz_id
    FROM alunos
);

CREATE TABLE consulta.disciplina_matriz AS (
  SELECT id, matriz_id, disciplina_id, periodo_referencia, area_de_concentracao_id
  FROM disciplina_matrizes
);

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


CREATE TABLE consulta.participacao AS (
  SELECT id, aluno_id, atividade_id, faltas, nota, satisfatoria_em, insatisfatoria_em
  FROM participacoes 
);
CREATE TABLE consulta.atividade AS (
  SELECT id, disciplina_id, descricao, ano_semestre
  FROM atividades
);
CREATE TABLE consulta.aproveitamento_de_atividade AS (
  SELECT id, aluno_id, participacao_id
  FROM aproveitamentos_de_atividade
);

CREATE TABLE consulta.equivalencia AS (
  SELECT equivalida_id, equivalente_id
  FROM equivalencias
);

CREATE TABLE consulta.disciplina_isencao AS (
  SELECT i.id, i.aluno_id, dii.disciplina_id, i.ano_semestre
  FROM isencoes AS i
  INNER JOIN itens_isencao AS ii
    ON ii.isencao_id = i.id
  INNER JOIN disciplinas_itens_isencao AS dii
    ON dii.item_isencao_id = ii.id
);

-- TODO: confirmar que apesar da tabela ter relação com inscrição e participação
--  apenas uma apresentará dados ()
CREATE TABLE consulta.disciplina_equivalencia_a_pedido AS (
  SELECT 
    ep.id,
    ep.aluno_id, 
    i_ep.disciplina_id,
    -- COALESCE(i.situacao) AS situacao,
    COALESCE(p.nota, i.nota) AS nota,
    COALESCE(p.faltas, i.faltas) AS faltas,
    ep.ano_semestre
  FROM equivalencias_a_pedido AS ep 
  INNER JOIN itens_equivalencia_a_pedido AS i_ep 
    ON i_ep.equivalencia_a_pedido_id = ep.id
  LEFT JOIN consulta.participacao AS p 
    ON p.id = i_ep.participacao_id 
  LEFT JOIN consulta.inscricao AS i 
    ON i.id = i_ep.inscricao_id
);

CREATE TABLE consulta.disciplina_aproveitamento_interno AS (
  SELECT 
    ai.id,
    ai.aluno_id, 
    i_ai.disciplina_id,
    -- COALESCE(i.situacao) AS situacao,
    COALESCE(p.nota, i.nota) AS nota,
    COALESCE(p.faltas, i.faltas) AS faltas,
    ai.ano_semestre
  FROM aproveitamentos_internos AS ai 
  INNER JOIN itens_aproveitamento_interno AS i_ai 
    ON i_ai.aproveitamento_interno_id = ai.id
  LEFT JOIN consulta.participacao AS p 
    ON p.id = i_ai.participacao_id 
  LEFT JOIN consulta.inscricao AS i 
    ON i.id = i_ai.inscricao_id
);

CREATE TABLE consulta.disciplina_inscricao AS (
  SELECT 
    p.aluno_id, 
    t.disciplina_id, 
    i.situacao, 
    i.nota, 
    i.nota_ef, 
    i.faltas, 
    t.ano_semestre
  FROM consulta.plano AS p
  INNER JOIN consulta.inscricao AS i 
    ON i.plano_id = p.id
  INNER JOIN consulta.turma AS t 
    ON t.id = i.turma_id
);

CREATE TABLE consulta.disciplina_participacao AS (
  SELECT
    p.aluno_id,
    a.disciplina_id,
    p.nota,
    p.faltas,
    a.descricao,
    a.ano_semestre,
    CASE
      WHEN EXISTS (
        SELECT ap.id
        FROM consulta.aproveitamento_de_atividade AS ap
        WHERE ap.aluno_id = p.aluno_id
          AND ap.participacao_id = p.id
      ) THEN 'APR'
      ELSE NULL::VARCHAR(6) 
    END AS situacao
  FROM consulta.participacao AS p
  INNER JOIN consulta.atividade AS a
    ON p.atividade_id = a.id
);


CREATE TABLE consulta.disciplina_cursada_ou_aproveitada AS (
  SELECT aluno_id, disciplina_id, situacao, nota, faltas, ano_semestre,
    'inscricao' AS origem
  FROM consulta.disciplina_inscricao

  UNION ALL 
  SELECT aluno_id, disciplina_id, situacao, nota, faltas, ano_semestre,
    'participacao' AS origem
  FROM consulta.disciplina_participacao


  UNION ALL
  SELECT aluno_id, disciplina_id, 'APR' AS situacao, nota, faltas, ano_semestre,
    'aprov_interno' AS origem
  FROM consulta.disciplina_aproveitamento_interno

  UNION ALL
  SELECT aluno_id, disciplina_id, 'APR' AS situacao, nota, faltas, ano_semestre,
    'aprov_pedido' AS origem
  FROM consulta.disciplina_equivalencia_a_pedido

  UNION ALL
  SELECT aluno_id, disciplina_id, 'APR' AS situacao, NULL AS nota, NULL AS faltas, ano_semestre,
    'aprov_isencao' AS origem
  FROM consulta.disciplina_isencao
);

CREATE TABLE consulta.disciplina_cursada_aproveitada_ou_equivalente AS (
  SELECT aluno_id, disciplina_id, situacao, nota, faltas, ano_semestre, origem
  FROM consulta.disciplina_cursada_ou_aproveitada

  UNION ALL 
  SELECT 
    dca.aluno_id, 
    e.equivalente_id AS disciplina_id,
    'APR' AS situacao,
    NULL AS nota,
    NULL AS faltas, 
    NULL AS ano_semestre,
    'equivalencia' AS origem
  FROM consulta.disciplina_cursada_ou_aproveitada AS dca
  INNER JOIN consulta.equivalencia AS e
    ON e.equivalida_id = dca.disciplina_id
);

CREATE VIEW consulta.disciplina_cursada AS (
  SELECT *
  FROM consulta.disciplina_cursada_aproveitada_ou_equivalente
);


CREATE TABLE consulta.pre_requisito AS (
  SELECT pre_requisitante_id, pre_requisito_id
  FROM pre_requisitos
);

CREATE TABLE consulta.co_resuisito AS (
  SELECT co_requisitante_id, co_requisito_id
  FROM co_requisitos
);

