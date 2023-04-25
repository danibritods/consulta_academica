# GINFO

Integrate new query databases into UENF’s Academic System to offer new features such as automatically calculating the demand for each course's subjects. 


## Structure 

This repository is the development environment of the project. 

### Folder Structure
```md
.
├── data · · · · · · · · · · · · · · · ·  Postgres folder  (docker-compose volume).
├── scripts · · · · · · · · · · · · · · · Script's folder synced with db image (docker-compose volume).
│   ├── academico · · · · · · · · · · · · · · Scripts to build the pertinent cohort of Academico's db.
│   │   ├── schema_academico.sql · · · · · · · · · Manually modified version of schema_rb.sql. 
│   │   ├── schema_rb.sql· · · · · · · · · · · · · Generated SQL version of schema.rb.  
│   │   ├── schema.rb· · · · · · · · · · · · · · · Original excerpt from Academico's db. 
│   │   └── schema_rb_to_sql.py· · · · · · · · · · Script to generate schema_rb.sql
│   ├── tests · · · · · · · · · · · · · · Test cases. 
│   │   ├── test_schema_rb_to_sql.py· · · · · Test cases for the rb -> SQL script. 
│   │   └── test_scripts.sql· · · · · · · · · Test cases for the SQL scripts. 
│   ├── consulta_from_academico.sql · · · Script to build the query database from Academico's db. 
│   ├── create_demand.sql · · · · · · · · Script to generate each student's subject demand. 
│   ├── init.sh · · · · · · · · · · · · · Script to run the tests and build the databases. 
│   └── schema_consulta.sql · · · · · · · Draft schema to the query database.
├── docker-compose.yml· · · · · · · · · Docker-compose config file. 
├── Dockerfile-postgres.yml · · · · · · Postgres container's config file. 
├── Dockerfile-ruby.yml · · · · · · · · Ruby container's config file.
└── README.md · · · · · · · · · · · · · Project presentation. This file!  
```
