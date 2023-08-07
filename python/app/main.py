import data_ingestion.consumer as consumer 
import logging

def main():
    logging.getLogger().setLevel(logging.INFO)
    consumer.consume_queue()

if __name__ == "__main__":
    main()
