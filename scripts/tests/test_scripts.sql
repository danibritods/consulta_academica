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
    -- Checking the number of rows in demanda.disciplina_cursada
    SELECT COUNT(*)
    INTO disciplinas_cursadas_count
    FROM demanda.disciplina_cursada;
    ASSERT disciplinas_cursadas_count = 15, 'Incorrect number of taken subjects.';

    -- Checking the number of rows in demanda.disciplina_aprovadas
    SELECT COUNT(*)
    INTO disciplinas_aprovadas_count  
    FROM demanda.disciplina_aprovada;
    ASSERT disciplinas_aprovadas_count = 14, 'Incorrect number of approved subjects.';

    ASSERT ( 3 = (
        SELECT COUNT(*) 
        FROM demanda.disciplina_remanescente 
        WHERE aluno_id = 1
        )), 'Should remain 3 subjects to student 1';

    ASSERT (ARRAY[1,2,9]::bigint[] = ARRAY(
        SELECT disciplina_id
        FROM demanda.disciplina_demandada
        WHERE aluno_id = 1)
    ), 'Student 1 should demand 1, 2 and 9';

    ASSERT (ARRAY[1,2,3,9]::bigint[] = ARRAY(
        SELECT disciplina_id
        FROM demanda.disciplina_demandada
        WHERE aluno_id = 2)
    ), 'Student 2 should demand 1, 2, 3 and 9';

    ASSERT (ARRAY[2,3,4,5,9]::bigint[] = ARRAY(
        SELECT disciplina_id
        FROM demanda.disciplina_demandada
        WHERE aluno_id = 3)
    ), 'Student 3 should demand 2, 3, 4, 5 and 9';
  END;
  $$;

-- Committing the transaction
COMMIT;
-- -- Cleaning the mess
-- \c postgres;
-- ROLLBACK;
-- DROP DATABASE test_dabase;
