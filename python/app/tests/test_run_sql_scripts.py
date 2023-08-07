from data_ingestion import run_sql_scripts

def test_test():
    assert run_sql_scripts._fetch_sql_scripts().keys() == {'consulta_from_academico.sql', 'demanda_from_consulta.sql'}