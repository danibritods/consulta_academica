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
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/")
def read_root():
def get_schema():
    #schema: {schema1: [table1,table2]. schema2: [table1, table2, table3]...}
    schema = defaultdict(list)
    for k, v in get_schema_tables()["data"]:
        schema[k].append(v)
    return schema

def get_schema_tables():
    query = """
    SELECT table_schema, table_name
    FROM information_schema.tables
    WHERE table_catalog = current_database()
    AND table_schema NOT LIKE 'pg_%'
    AND table_schema <> 'information_schema'
    AND table_schema <> 'public'
    AND table_type IN ('BASE TABLE', 'VIEW');
    """

    #schema_tables: {"columns":["table_schema","table_name"],"data":[["consulta","aluno"],["consulta","disciplina_matriz"],..
    schema_tables = execute_query(query)
    return schema_tables