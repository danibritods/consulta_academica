from data_ingestion import sync_academico_db as s

def test_row_to_insert_query_values():
    test_body = s.json.loads(b'{ "table_name":"alunos", "id":1, "curso_id":1, "matriz_id":1}')
    expected = (1,1,1)
    obtained = s._row_to_insert_query(test_body)[1]

    assert obtained == expected

def test_row_to_insert_query():
    test_body = s.json.loads(b'{ "table_name":"alunos", "id":1, "curso_id":1, "matriz_id":1}')
    expected = """
        INSERT INTO alunos (id, curso_id, matriz_id)
        VALUES (%s, %s, %s)
        ON CONFLICT DO NOTHING
        """

    obtained = s._row_to_insert_query(test_body)[0]

    assert obtained == expected

def test_body_to_rows_single_tuple():
    test_body = b'{ "table_name":"alunos", "id":1, "curso_id":1, "matriz_id":1}'
    expected = ({'table_name': 'alunos', 'id': 1, 'curso_id': 1, 'matriz_id': 1},)
    obtained = s.body_to_rows(test_body)

    assert obtained == expected

def test_body_to_rows_multiple_tuples():
    test_body = b'[{ "table_name":"alunos", "id":1, "curso_id":1, "matriz_id":1},\
                  {"table_name":"alunos", "id":2, "curso_id":2, "matriz_id":2}]'
    
    expected = [{'table_name': 'alunos', 'id': 1, 'curso_id': 1, 'matriz_id': 1},
                {"table_name":"alunos", "id":2, "curso_id":2, "matriz_id":2}]
    obtained = s.body_to_rows(test_body)

    assert obtained == expected

def test_body_to_rows_invalid_body_non_json():
    test_body = b'non json string'
    
    expected = ()
    obtained = s.body_to_rows(test_body)

    assert obtained == expected


def test_body_to_rows_invalid_body_json_but_invalid_tuple_format():
    """This test asserts that valid json with different format than expected 
    is treated accordingly without catastrophic failure"""
    test_body = b'([{"a":1}])'
    
    expected = ()
    obtained = s.body_to_rows(test_body)

    assert obtained == expected


def test_filter_columns():
    row = {"table_name":"teste", "col_1": 1, "col_2": 2}
    schema = {"teste": ["col_1", "col_3"]}
    expected_row = {"table_name":"teste", "col_1": 1}

    assert s._filter_columns(row, schema) == expected_row