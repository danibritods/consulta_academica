from typing import Union

import psycopg2
from fastapi import FastAPI

app = FastAPI()

# Database connection configuration
db_config = {
    "dbname": "academico_db",
    "user": "query_consulta",
    "password": "query_consulta_password",
    "host": "db",
    "port": "5432"
}

def execute_query(query: str):
    # Establish a database connection
    with psycopg2.connect(**db_config) as conn:
        with conn.cursor() as cur:
            cur.execute(query)
            columns = [desc[0] for desc in cur.description]
            rows = cur.fetchall()
            return {"columns": columns, "data": rows}

@app.post("/execute_query/")
def execute_sql_query(query: str):
    try:
        result = execute_query(query)
        return result
    except Exception as e:
        return {"error": str(e)}

@app.get("/")
def read_root():
    return {"Hello": "World"}
