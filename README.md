# consulta_academica
![Unit Tests](https://github.com/danibritods/consulta_academica/actions/workflows/python-tests.yml/badge.svg)

## About

**consulta_academica** is a project aimed at establishing the foundational infrastructure for data analysis and data-driven features within [UENF][uenf_url]'s Academic System ("[Acadêmico][academico_url]").

[Acadêmico][academico_url] manages the academic activities of Universidade Estadual do Norte Fluminense (UENF), encompassing courses, subjects, enrollments, grades, and more. However, the production database of Acadêmico contains sensitive and irrelevant data that could compromise privacy and system performance. To address this, **consulta_academica** was developed.

Our primary objective is to create an anonymized and abstracted database, enabling the development of data routines and features that contribute to a data-driven culture within our university.

This project consists of a docker compose orchestration to be run alongside the "[Acadêmico][academico_url]". This system [keeps](#message-broker) the `academico_db`, an internal copy of the appropriate cohort of the "[Acadêmico][academico_url]" production database. From `academico_db` the system [builds](#sql-scripts) the `consulta` schema with tables that refine and simplify the tables in "Academico" production database. The tables in `consulta` can be easily accessed through the [api](#api). 

## Setup
**consulta_academica** is intented to run internally alongside the "[Acadêmico][academico_url]", but you can run it locally following this instructions:

1. Clone the repository:
   ```bash
   git clone
   ```
3. Build the compose: 
   ```bash
   docker compose build
   ```
5. Running the services
   ```bash
   docker compose up
   ```

- You can stop the services with:
  ```bash
  docker compose down
  ```

## Use

### API
Access the **consulta_academica** API at port 80. You'll be greeted with a json presenting the instructions, an example and the current schema of the **consulta_academica** database:

```json
{"Saudações!":"API Consulta Acadêmica",

"Instruções":"consulte o banco de dados enviando a sua query por meio de um POST para \"/execute_query\"",

"exemplo de query:":"SELECT disciplina_id, contagem_alunos FROM demanda.contagem_aluno_por_disciplina;",

"tabelas no formato {schema/: [tabelas]}":

    {"consulta":[],

    "demanda":[]
    }
}
```

#### example query: 
For example, you can perform a query like `"SELECT * FROM consulta.aluno;"`:
```bash
curl -X 'POST' \
  'http://localhost/execute_query/?query=SELECT%20%2A%20FROM%20consulta.aluno%3B' \
  -H 'accept: application/json' \
  -d ''
```
The response will be in JSON format, providing the queried data:
```json
{"columns":["id","curso_id","matriz_id"],"data":[[1,1,1],[2,1,1],[3,1,1],[4,2,2],[5,2,2]]}
```
#### API documentation
You can access the auto-generated API documentation at `/docs`.
![api docs](docs/API_docs.png)


## Message broker 
**consulta_academica** has a RabbitMQ and python services to consume the queues at port 5672.
Currently `data_to_db` is a queue to receive tuples from the "[Acadêmico][academico_url]" database. Internally only the non-personal data is processed and copied to the internal `academico_db` database. This process syncs the `academico_db` to the production database, in such a way as to have a separate database, without sensitive data, that can be used without impacting the performance of the "[Acadêmico][academico_url]". 

The `manage` queue currently only supports the message "run_sql_scripts" which executes the [SQL scripts](#sql-scripts).

## SQL scripts
### `consulta_from_academico.sql`
This primary script builds the `consulta` schema from the tables in `academico_db`. The `consulta` schema contains an anonymized and abstracted copy of the relevant data from Acadêmico's database. It serves as a foundation for analytics and data features.

- It provides a separate source of truth, enabling queries without impacting production performance.
- Pre-processed for analytical purposes, e.g., consolidating multiple tables into one.
- Enhances data governability and privacy by restricting API access to the `consulta` schema.
- The schema is publicly accessible for creating analytics routines.

This project's services maintain `consulta` and enable querying its tables.

### `demanda_from_consulta.sql`

`demanda` is the schema of our first data feature developed from `consulta`. It builds a table containing each subject offered at UENF and its corresponding demand (in number of students) for the next period (`demanda.contagem_aluno_por_disciplina`). It also maintains all the intermediary tables necessary for the calculation because each one of them can be useful for other analysis. This schema is also accessible through the API.

## Schemas
### `consulta`
<details>
   <summary>`consulta` tables</summary>
   
   | Column name                                   | Description |
   |-----------------------------------------------|-------------|
   | aluno                                         |             |
   | disciplina_matriz                             |             |
   | disciplina                                    |             |
   | inscricao                                     |             |
   | turma                                         |             |
   | plano                                         |             |
   | participacao                                  |             |
   | atividade                                     |             |
   | aproveitamento_de_atividade                   |             |
   | equivalencia                                  |             |
   | disciplina_isencao                            |             |
   | disciplina_equivalencia_a_pedido              |             |
   | disciplina_aproveitamento_interno             |             |
   | disciplina_inscricao                          |             |
   | disciplina_participacao                       |             |
   | disciplina_cursada_ou_aproveitada             |             |
   | disciplina_cursada_aproveitada_ou_equivalente |             |
   | disciplina_cursada                            |             |
   | pre_requisito                                 |             |
   | co_requisito                                  |             |

</details>


## Structure

This project consists of the following services orchestrated by Docker Compose:
- `db`: A PostgreSQL container housing the `academico_db` database with filtered tables from "Acadêmico" and the `consulta`, and `demanda` schemas.
- `ruby`: A Ruby service to load the DB schema from "[Acadêmico][academico_url]" in `academico_db` setup.
- `rabbitMQ`: A messaging and queuing service for data synchronization and command execution.
- `python`: A service consuming RabbitMQ queues for syncing `academico_db` and running SQL scripts.
- `api`: A FastAPI providing queries exclusively to the `demanda` and `consulta` schemas. From this API future data products can be built such as dashboards and facilities to course coordinators.

### Folder Structure
```md
.
├── api
│   ├── app
│   │   ├── __init__.py
│   │   └── main.py
│   ├── requirements.txt
│   └── Dockerfile
│
├── db
│   ├── data
│   ├── scripts
│   └── Dockerfile
│
├── docs
│   └── ...
│
├── off_the_rails
│   ├── app
│   │   ├── db
│   │   │   ├── config.yml
│   │  ...  └── schema.rb
│   └── Dockerfile
│
├── python
│   ├── app
│   │   ├── __init__.py
│   │   │   
│   │   ├── data_ingestion
│   │   │   ├── __init__.py
│   │   │   ├── consumer.py
│   │   │   ├── database.py
│   │   │   ├── manager.py
│   │   │   ├── run_sql_scripts.py
│   │   │   └── sync_academico_db.py
│   │   │   
│   │   ├── sql_scripts
│   │   │   ├── consulta_from_academico.sql
│   │   │   └── demanda_from_consulta.sql
│   │   │   
│   │   ├── tests
│   │   │   ├── __init__.py
│   │   │   ├── insert_mock_data.sql
│   │   │   ├── test_manager.py
│   │   │   ├── test_run_sql_scripts.sql
│   │   │   ├── test_scripts.sql
│   │   │   └── test_sync_academico_db.py
│   │   └── requirements.txt
│   └── Dockerfile
│
├── docker-compose.yml
└── README.md
├── notebook.ipynb
```


[uenf_url]: https://uenf.br/
[academico_url]: https://academico.uenf.br/
