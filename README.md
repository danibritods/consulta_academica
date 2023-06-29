# consulta_academica

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
├── data · · · · · · · · · · · · · · · ·Postgres folder (docker-compose volume).
├── scripts · · · · · · · · · · · · · · Script's folder, synced with images (docker-compose volume).
│   ├── **consulta_academica** · · · · · · ·Main project folder. 
│   │   ├── consulta_from_academico.sql· · · · ·Script to generate the `consulta` database.  
│   │   └── demanda_from_consulta.sql· · · · · ·Script to generate the `demanda` schema views.
│   ├── off_the_rails · · · · · · · · · · · Ruby script to build the academico_db database and tables from `schema.rb`.
│   │   ├── bin · · · · · · · · · · · · · · · · Binstubs' folder (executables around Ruby gems).
│   │   ├── db· · · · · · · · · · · · · · · · · Database config files within the Ruby script. 
│   │   │   ├── config.yml· · · · · · · · · · · · · Configuration file for database settings and options.
│   │   │   └── schema.rb · · · · · · · · · · · · · Ruby file that defines the structure of the Academico's db tables and columns.
│   │   ├── Gemfile · · · · · · · · · · · · · · File that specifies the gem dependencies for the project.
│   │   ├── Gemfile.lock  · · · · · · · · · · · File that records the exact versions of the gems installed for the project. 
│   │   └── Rakefile· · · · · · · · · · · · · · File that defines tasks to run with the rake command. 
│   ├── tests · · · · · · · · · · · · · · · Test cases. 
│   │   └── test_scripts.sql· · · · · · · · · · Test cases for the SQL scripts. 
│   ├── init.sh · · · · · · · · · · · · · Script to run the tests and build the databases. 
│   └── pg_init.sql · · · · · · · · · · · Script to create the the auto_academ role (used by the Ruby script)
├── docker-compose.yml· · · · · · · · · Docker-compose config file. 
├── Dockerfile-postgres.yml · · · · · · Postgres container's config file. 
├── Dockerfile-ruby.yml · · · · · · · · Ruby container's config file.
└── README.md · · · · · · · · · · · · · Project presentation. This file!  
```

[uenf_url]: https://uenf.br/
[academico_url]: https://academico.uenf.br/
