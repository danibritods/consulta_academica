-- This scrips tests the scripts that create `consulta` and `demanda` schemas 
-- This file is meant to be run by init.sh from the /home/scripts/tests.

DROP DATABASE test_database;
-- Creating the test database
CREATE DATABASE test_database TEMPLATE academico_db;
\c test_database;

-- Inserting the mock data
\i insert_mock_data.sql

-- Running the scripts that create the `consulta` and `demanda` schemas
\i ./../consulta_from_academico.sql
\i ./../demanda_from_consulta.sql

-- Asertions

-- Cleaning the mess
\c postgres;