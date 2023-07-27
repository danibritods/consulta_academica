-- CREATE ROLE tester;

-- \i schema_academico.sql;

-- Create a test database
\! su -c "createdb test_database" postgres

-- Create SCHEMA
CREATE SCHEMA consulta;
CREATE SCHEMA demanda;

-- Create the necessary tables
CREATE TABLE consulta.aluno (
    aluno_id INT,
    matriz_id INT
);

CREATE TABLE consulta.disciplina_matriz (
    disciplina_id INT,
    matriz_id INT
);

CREATE TABLE consulta.plano (
    plano_id INT,
    aluno_id INT
);

CREATE TABLE consulta.inscricao (
    inscricao_id INT,
    plano_id INT,
    situacao TEXT
);

-- Insert some test data
INSERT INTO consulta.aluno (aluno_id, matriz_id) VALUES (1, 1), (2, 2), (3, 3);
INSERT INTO consulta.disciplina_matriz (disciplina_id, matriz_id) VALUES (1, 1), (2, 2), (3, 3);
INSERT INTO consulta.plano (plano_id, aluno_id) VALUES (1, 1), (2, 2), (3, 3);
INSERT INTO consulta.inscricao (inscricao_id, plano_id, situacao) VALUES (1, 1, 'APR'), (2, 2, 'APR'), (3, 3, 'REJ');

-- Run the script you provided
CREATE TABLE demanda.disciplina_aprovada AS (
  SELECT a.aluno_id, m.disciplina_id 
  FROM consulta.aluno AS a
  INNER JOIN consulta.disciplina_matriz AS m ON m.matriz_id = a.matriz_id
  INNER JOIN consulta.plano AS p on p.aluno_id = a.aluno_id 
  INNER JOIN consulta.inscricao AS i ON i.plano_id = p.plano_id
  WHERE situacao = 'APR' 
);

-- Check the results
SELECT * FROM demanda.disciplina_aprovada;