
from data_ingestion import database
import logging
from itertools import islice
from collections import deque
import json

# Itertools recipe. Used here to efficiently apply a function to a list
def consume_iterator(iterator, n=None):
    "Advance the iterator n-steps ahead. If n is None, consume entirely."
    # Use functions that consume iterators at C speed.
    if n is None:
        # feed the entire iterator into a zero-length deque
        deque(iterator, maxlen=0)
    else:
        # advance to the empty slice starting at position n
        next(islice(iterator, n, n), None)



def callback(ch, method, properties, body):
    logging.info(f"callback_data_to_db: message received : {body}")
    message_to_db(body)

def message_to_db(body):
    """
    body expected format = [{"table_name":'table',"id":1,"col1":1,"col2":2,"col3":3},
                            {"table_name":'table',"id":2,"col1":1,"col2":2,"col3":3}
                            {"table_name":'table',"id":2,"col1":1,"col2":2,"col3":3}]
    """
    rows = body_to_rows(body)
    consume_iterator(map(_row_to_db,rows))

def body_to_rows(body):
    if b"table_name" not in body:
        logging.warning(f"|body_to_rows|Incorrect body format|{body}|\n")
        return ()
    try: 
        rows = json.loads(body)
        if type(rows) == list:
            return rows
        return (rows,)
    except json.JSONDecodeError:
        #todo: check possibility of detailing the exception type
        logging.warning(f"|body_to_rows|JSONDecodeError|{body}|\n")
        return ()
    except TypeError:
        logging.warning(f"|body_to_rows|TypeError|{body}|\n")
        return ()

def _row_to_db(row):
    with database.connect_to_db() as conn:
        with conn.cursor() as cur:
            cur.execute(*_row_to_insert_query(_filter_row(row)))
            conn.commit()
    #check faster implementations: https://stackoverflow.com/questions/8134602/psycopg2-insert-multiple-rows-with-one-query

def _row_to_insert_query(row):
        table_name = row["table_name"]
        #[1:] to remove table_name from column names and values
        columns = ", ".join( tuple(row.keys())[1:] )
        values = tuple(row.values())[1:]

        query = f"""
        INSERT INTO {table_name} ({columns})
        VALUES ({ ', '.join(['%s'] * len(values)) })
        ON CONFLICT DO NOTHING
        """
        return (query,values)

def _filter_columns(row, schema):
    expected_columns = schema[row["table_name"]]
    filtered_row = {k:v for (k,v) in row.items() if k in expected_columns}
    filtered_row.update({"table_name":row["table_name"]})
    return filtered_row

def _filter_row(row):
    schema = _get_academico_schema()
    _filter_columns(row, schema)

def _get_academico_schema():
    with database.connect_to_db() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT table_name, column_name FROM information_schema.columns WHERE table_schema = 'public'")
            results = cur.fetchall()

    schema = {}
    for result in results:
        table_name = result[0]
        column_name = result[1]
        if table_name not in schema:
            schema[table_name] = []
        schema[table_name].append(column_name)