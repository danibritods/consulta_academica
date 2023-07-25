# consumer
import psycopg2
import pika
from itertools import islice
from collections import deque
import json


conn = psycopg2.connect(
    host="db",
    port=5432,
    user="auto_academ",
    password="auto_academ",
    database="academico_db"
)
cur = conn.cursor()

# connection = pika.BlockingConnection(pika.ConnectionParameters(host='rabbitmq'))
# channel = connection.channel()


def consume(iterator, n=None):
    "Advance the iterator n-steps ahead. If n is None, consume entirely."
    # Use functions that consume iterators at C speed.
    if n is None:
        # feed the entire iterator into a zero-length deque
        deque(iterator, maxlen=0)
    else:
        # advance to the empty slice starting at position n
        next(islice(iterator, n, n), None)

def message_to_db(body):
    """
    body example = [{"table_name":'table',"id":1,"col1":1,"col2":2,"col3":3},
                    {"table_name":'table',"id":2,"col1":1,"col2":2,"col3":3}
                    {"table_name":'table',"id":2,"col1":1,"col2":2,"col3":3}]
    """
    rows = json.loads(body)
    consume(map(_row_to_db,rows))
    conn.commit()

def _row_to_db(row):
    cur.executemany(*_row_to_insert_query(row))

def _row_to_insert_query(row):
        table_name = row.get("table_name")
        columns = ", ".join(row.keys())
        values = tuple(row.values())

        query = f"INSERT INTO {table_name} ({columns}) VALUES ({ '?, ' * len(values)}))"
        return (query,values)


# def callback(ch, method, properties, body):
#     message_to_db(body)

# channel.basic_consume(queue='data_to_db', on_message_callback=callback, auto_ack=True)

# print(' [*] Waiting for messages. To exit press CTRL+C')
# channel.start_consuming()

