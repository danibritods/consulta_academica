from app.data_ingestion import consumer as c

def test_row_to_insert_query_values():
    test_body = c.json.loads(b'{ "table_name":"alunos", "id":1, "curso_id":1, "matriz_id":1}')
    expected = (1,1,1)
    obtained = c._row_to_insert_query(test_body)[1]

    assert obtained == expected