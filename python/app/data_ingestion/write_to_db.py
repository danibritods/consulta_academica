import psycopg2

conn = psycopg2.connect(
    host="db",
    port=5432,
    user="auto_academ",
    password="auto_academ",
    database="academico_db"
)

cur = conn.cursor()

cur.execute("""
        INSERT INTO alunos (id, curso_id, matriz_id) VALUES
        (5, 5, 5)
    """)
cur.execute("SELECT * FROM alunos")

rows = cur.fetchall()

for row in rows:
    print(row)

cur.close()
conn.close()