from data_ingestion import manager
from data_ingestion import sync_academico_db

import pika
import logging

def connect_to_queue():
    connection = pika.BlockingConnection(pika.ConnectionParameters(host='rabbitmq'))
    channel = connection.channel()
    logging.info("connected to the rabbitMQ host")
    channel.queue_declare(queue='data_to_db')
    channel.basic_consume(queue='data_to_db', on_message_callback=sync_academico_db.callback, auto_ack=True)

    channel.queue_declare(queue='manage')
    channel.basic_consume(queue='manage', on_message_callback=manager.callback, auto_ack=True)

    return channel

def consume_queue():
    channel = connect_to_queue()
    try:
        print(' [*] Waiting for messages. To exit press CTRL+C')
        channel.start_consuming()
    except KeyboardInterrupt:
        channel.stop_consuming()

def main():
    logging.getLogger().setLevel(logging.INFO)
    consume_queue()

if __name__ == "__main__":
    main()