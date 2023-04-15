-- Creating the test database
\! su -c "createdb test_database" postgres

-- Running the scripts that create `academico` and `consult` schemas
\i home/scripts/schema_academico.sql
\i home/scripts/schema_consulta.sql

-- Running the demanda creation script
\i home/scripts/create_demanda.sql


-- Asertions