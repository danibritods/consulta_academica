from app.data_ingestion import consumer as c

def test_row_to_insert_query():
    test_body = c.json.loads('{ "table_name":"test", "name":"John", "age":30, "city":"New York"}')
    expected = ('John', 30, 'New York')
    obtained = c._row_to_insert_query(test_body)[1]

    assert obtained == expected