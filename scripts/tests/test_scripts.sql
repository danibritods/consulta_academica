-- This scrips tests the scripts that create `consulta` and `demanda` schemas 
-- This file is meant to be run by init.sh from the /home/scripts/tests.

-- Creating the test database
CREATE DATABASE test_database TEMPLATE academico_db;
\c test_database;

-- Running the scripts that create the `consulta` schema 
\i ./../consulta_from_academico.sql

-- Asertions

-- Cleaning the mess
\c postgres;
DROP DATABASE test_database;
