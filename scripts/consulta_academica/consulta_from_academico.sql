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

CREATE TABLE consulta.participacao AS (
  SELECT id, aluno_id, atividade_id, faltas, nota, satisfatoria_em, insatisfatoria_em
  FROM participacoes 
);

CREATE TABLE consulta.atividade AS (
  SELECT id, disciplina_id, descricao, ano_semestre
  FROM atividades
);


CREATE TABLE consulta.pre_requisito AS (
  SELECT pre_requisitante_id, pre_requisito_id
  FROM pre_requisitos
);

CREATE TABLE consulta.co_resuisito AS (
  SELECT co_requisitante_id, co_requisito_id
  FROM co_requisitos
);


CREATE TABLE consulta.equivalencia_a_pedido AS (
  SELECT id, aluno_id, ano_semestre
  FROM equivalencias_a_pedido
); 

CREATE TABLE consulta.item_equivalencia_a_pedido AS (
  SELECT equivalencia_a_pedido_id, inscricao_id, disciplina_id, participacao_id
  FROM itens_equivalencia_a_pedido
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

CREATE TABLE consulta.disciplina_cursada_equivalencia_pedido AS (
  SELECT ep.aluno_id, ep.ano_semestre, i_ep.disciplina_id, 'APR' AS situacao, COALESCE(p.nota, i.nota) AS nota
  FROM consulta.equivalencia_a_pedido AS ep 
  INNER JOIN consulta.item_equivalencia_a_pedido AS i_ep ON i_ep.equivalencia_a_pedido_id = ep.id
  LEFT JOIN consulta.participacao AS p ON p.id = i_ep.participacao_id 
  LEFT JOIN consulta.inscricao AS i ON i.id = i_ep.inscricao_id
);

CREATE TABLE consulta.disciplina_cursada AS (
  SELECT aluno_id, disciplina_id, situacao, nota, 'inscricao' AS origem
  FROM consulta.disciplina_cursada_inscricao
);
