from .. import consumer

def test_message_to_db():
    test_body = consumer.json.loads('{ "table_name":"test", "name":"John", "age":30, "city":"New York"}')
    expected = ('test', 'John', 30, 'New York')
    obtained = consumer._row_to_insert_query(test_body)[1]

    assert obtained == expected