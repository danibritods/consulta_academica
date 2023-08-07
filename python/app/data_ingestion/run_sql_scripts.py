from data_ingestion import database
import logging
import os

def _fetch_sql_scripts():
    scripts_folder = "sql_scripts"
    sql_scripts = {script_filename : _read_script(f"{scripts_folder}/{script_filename}") 
                   for script_filename in os.listdir(scripts_folder)}
    return sql_scripts

def _read_script(script_path):
    with open(script_path, "r") as file:
        sql_script_content = file.read()
        return sql_script_content   

def run_sql_scripts_in_db():
    sql_scripts = _fetch_sql_scripts()
    with database.connect_to_db() as conn:
        with conn.cursor() as cur:
            for sql_script_name, sql_script in sql_scripts.items():
                try:
                    cur.execute(sql_script)
                except Exception as e:
                    logging.error(f"Error executing SQL script {sql_script_name}: {e}")
                else:
                    logging.info("Successfully executed SQL script.")
            conn.commit()