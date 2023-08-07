from data_ingestion import run_sql_scripts
import logging

def callback(ch, method, properties, body):
    functions = {b"run_sql_scripts":run_sql_scripts.run_sql_scripts_in_db}
    try:
        functions[body]()
        logging.info(f"callback_manage: message received : {body}")
    except Exception as e:
        logging.error(f"|callback_manage|exception: {e}|")
