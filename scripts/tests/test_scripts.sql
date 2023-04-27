-- This scrips tests the scripts that create `consulta` and `demanda` schemas 
-- This file is meant to be run by init.sh from the /home/scripts/tests.

-- Dropping the test database if it exists
DROP DATABASE IF EXISTS test_database;

-- Creating the test database from the academico_db template and specifying the owner
CREATE DATABASE test_database TEMPLATE academico_db OWNER tester;

-- Connecting to the test database
\c test_database;

-- Starting a transaction
BEGIN;

-- Inserting the mock data
\i insert_mock_data.sql

-- Running the scripts that create the `consulta` and `demanda` schemas
\i ./../consulta_from_academico.sql
\i ./../demanda_from_consulta.sql

-- Asserting that the output matches the expected data
  DO $$
  DECLARE 
    disciplinas_cursadas_count INTEGER;
    disciplinas_aprovadas_count INTEGER;
  BEGIN
    -- Counting the number of rows in demanda.disciplina_cursada
    SELECT COUNT(*)
    INTO disciplinas_cursadas_count
    FROM demanda.disciplina_cursada;

    -- Checking if the count matches the expected value
    ASSERT disciplinas_cursadas_count = 15, 'Incorrect number of taken subjects.';

    SELECT COUNT(*)
    INTO disciplinas_aprovadas_count  
    FROM demanda.disciplina_aprovada;
    ASSERT disciplinas_aprovadas_count = 14, 'Incorrect number of approved subjects.';
  END;
  $$;

-- Committing the transaction
COMMIT;
-- -- Cleaning the mess
-- \c postgres;
-- ROLLBACK;
-- DROP DATABASE test_dabase;
