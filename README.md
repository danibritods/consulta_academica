# consulta_academica
![Unit Tests](https://github.com/danibritods/consulta_academica/actions/workflows/python-tests.yml/badge.svg)


consulta_academica is a project to build the foundations for data analysis and data features within [UENF][uenf_url]'s Academic System ("[Academico][academico_url]").

## About

[Academico][academico_url] is the system that manages the academic activities of the Universidade Estadual do Norte Fluminense (UENF), such as courses, subjects, enrollments, grades, etc. However, the production database of Academico is not suitable for data analysis and data features, as it contains sensitive and irrelevant data that may compromise the privacy and performance of the system. Therefore, consulta_academica was created to address this issue. Our main goal is to build an anonymized and abstracted database that will allow easy development of data routines and features contributing to a data driven culture in our university. 

### `consulta_from_academico`

The main product of this project is the database `consulta_from_academico`. This database contains an anonymized and abstracted copy of only the relevant data from the Acadêmico's database. Its schema is publicly accessible so that anyone interested in creating analytics routines can use it. 

### `demanda_from_consulta`

`demanda_from_consulta` is the name of our first data feature developed from `consulta_from_academico`. This SQL script reads the `consulta_from_academico` database and processes it into the necessary tables to arrive at a table containing each subject offered at UENF and its corresponding demand (in number of students) for the next period. 

This feature is being developed together with `consulta_from_academico` to orient the architecture decisions and developing of the project with concrete demands. 

## Structure 

This repository contains the development environment for the **consulta_academica** project. It uses Docker Compose to orchestrate two docker images: one for Postgres, which provides the database service, and one for Ruby, which creates the database from the schema.rb file.

### Folder Structure
```md
.
├── db
│   ├── data
│   ├── Dockerfile
│   └── scripts
│
├── docs
│   ├── academico_bd.md
│   ├── design.md
│   └── schema_disciplinas.rb
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
│   │   │   └── write_to_db.py
│   │   │   
│   │   ├── sql_scripts
│   │   │   ├── consulta_from_academico.sql
│   │   │   └── demanda_from_consulta.sql
│   │   │   
│   │   ├── tests
│   │   │   ├── __init__.py
│   │   │   ├── insert_mock_data.sql
│   │   │   ├── test_scripts.sql
│   │   │   └── test_consumer.py
│   │   └── requirements.txt
│   └── Dockerfile
│
├── docker-compose.yml
└── README.md
├── notebook.ipynb
```


[uenf_url]: https://uenf.br/
[academico_url]: https://academico.uenf.br/
