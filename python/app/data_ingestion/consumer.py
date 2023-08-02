import psycopg2
import pika
from itertools import islice
from collections import deque
import json
import logging

# Itertools recipe. Used here to efficiently apply a function to a list
def consume(iterator, n=None):
    "Advance the iterator n-steps ahead. If n is None, consume entirely."
    # Use functions that consume iterators at C speed.
    if n is None:
        # feed the entire iterator into a zero-length deque
        deque(iterator, maxlen=0)
    else:
        # advance to the empty slice starting at position n
        next(islice(iterator, n, n), None)


def connect_to_db():
    conn = psycopg2.connect(
        host="db",
        port=5432,
        user="auto_academ",
        password="auto_academ",
        database="academico_db"
    )
    return conn


def connect_to_queue():
    connection = pika.BlockingConnection(pika.ConnectionParameters(host='rabbitmq'))
    channel = connection.channel()
    logging.info("connected to the rabbitMQ host")
    channel.queue_declare(queue='data_to_db')
    channel.basic_consume(queue='data_to_db', on_message_callback=callback_data_to_db, auto_ack=True)

    return channel


def callback_data_to_db(ch, method, properties, body):
    logging.info(f"callback_data_to_db: message received : {body}")
    message_to_db(body)


def message_to_db(body):
    """
    body expected format = [{"table_name":'table',"id":1,"col1":1,"col2":2,"col3":3},
                            {"table_name":'table',"id":2,"col1":1,"col2":2,"col3":3}
                            {"table_name":'table',"id":2,"col1":1,"col2":2,"col3":3}]
    """
    
    rows = body_to_rows(body)
    consume(map(_row_to_db,rows))

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
        logging.warning(f"|body_to_rows|JSONDecodeError|{body}|\n")
        return ()

        

def _row_to_db(row):
    with connect_to_db() as conn:
        with conn.cursor() as cur:
            cur.execute(*_row_to_insert_query(row))
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


def main():
    logging.getLogger().setLevel(logging.INFO)
    channel = connect_to_queue()
    try:
        print(' [*] Waiting for messages. To exit press CTRL+C')
        channel.start_consuming()
    except KeyboardInterrupt:
        channel.stop_consuming()

if __name__ == "__main__":
    main()