
from data_ingestion import database
from data_ingestion import run_sql_scripts
import logging
from itertools import islice
from collections import deque
import json
import threading

TIMER_DURATION_MIN = 0.5
TIMER_STATUS = False

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

    run_scripts_after_data_ingestion()

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
    filtered_row = _filter_row(row)
    if filtered_row == {}:
        pass
    else:
        with database.connect_to_db() as conn:
            with conn.cursor() as cur:
                cur.execute(*_row_to_insert_query(filtered_row))
                conn.commit()
        #check faster implementations: https://stackoverflow.com/questions/8134602/psycopg2-insert-multiple-rows-with-one-query

def _row_to_insert_query(row):
        table_name = row["table_name"]

        #remove "table_name" from row to insert the other values in db
        del row["table_name"]
        columns = ", ".join( tuple(row.keys()))
        values = tuple(row.values())

        query = f"""
        INSERT INTO {table_name} ({columns})
        VALUES ({ ', '.join(['%s'] * len(values)) })
        ON CONFLICT DO NOTHING
        """
        return (query,values)

def _filter_columns(row, schema):
    if len(row) <= 1:
        logging.warning(f'|_filter_columns| row seem empty: {row}')
        return {}
    try:
        expected_columns = schema[row["table_name"]]
    except KeyError:
        logging.warning(f'|_filter_columns| table: {row["table_name"]} not present in schema')
        return {}
    except TypeError:
        logging.warning(f'|_filter_columns| row seem empty: {row}')
        return {}
        
    filtered_row = {k:v for (k,v) in row.items() if k in expected_columns}
    filtered_row.update({"table_name":row["table_name"]})
    return filtered_row

def _filter_row(row):
    schema = _get_academico_schema()
    return _filter_columns(row, schema)

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
    return schema
        
def run_scripts_after_data_ingestion():
    global TIMER_STATUS
    timer = threading.Timer(TIMER_DURATION_MIN * 60, execute_scripts_end_timer)

    if TIMER_STATUS:
        pass
    else:
        TIMER_STATUS = True
        timer.start()

def execute_scripts_end_timer():
    global TIMER_STATUS
    run_sql_scripts.run_sql_scripts_in_db()
    TIMER_STATUS = False