import data_ingestion.consumer as consumer 
import data_ingestion.run_sql_scripts as sql_runner
import logging

def main():
    logging.basicConfig(filename='main.log', encoding='utf-8', level=logging.INFO, format='%(asctime)s %(message)s')
    logging.info("---------------| running main.py |------------------")

    #run sql scrips on startup (consulta_from_academico, demanda_from_consulta)
    sql_runner.run_sql_scripts_in_db()
    logging.info("Executed SQL startup scripts.")

    consumer.consume_queue()

if __name__ == "__main__":
    main()
