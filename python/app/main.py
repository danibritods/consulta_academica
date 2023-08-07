import data_ingestion.consumer as consumer 
import logging

def main():
    logging.basicConfig(filename='main.log', encoding='utf-8', level=logging.INFO, format='%(asctime)s %(message)s')
    logging.info("---------------| running main.py |------------------")
    consumer.consume_queue()

if __name__ == "__main__":
    main()
