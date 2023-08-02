import psycopg2

def connect_to_db():
    conn = psycopg2.connect(
        host="db",
        port=5432,
        user="auto_academ",
        password="auto_academ",
        database="academico_db"
    )
    return conn