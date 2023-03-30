CREATE SCHEMA IF NOT EXISTS consulta;

CREATE TABLE IF NOT EXISTS consulta.curso (
  id text PRIMARY KEY,
  nome text,
  centro text, -- varchar(5)?
  lab text --varchar(5)?
);

CREATE TABLE IF NOT EXISTS consulta.disciplina (
  sigla text NOT NULL, --char(10)?
  nome text NOT NULL, 
  creditos integer NOT NULL,
  carga_horaria integer NOT NULL,
  PRIMARY KEY (sigla)
);

CREATE TABLE IF NOT EXISTS consulta.estudante (
  matricula text NOT NULL, -- analisar se matrícula (pseudoanonimização) é suficiente ou substituir por um ID aleatório
  curso text NOT NULL REFERENCES consulta.curso (id),
  situacao text NOT NULL, -- char(n)?
  data_matricula date NOT NULL,
  creditos_acum integer NOT NULL,
  carga_horaria text NOT NULL,
  cre numeric(3,2) NOT NULL, -- text?
  PRIMARY KEY (matricula)
);

CREATE TABLE IF NOT EXISTS consulta.disciplina_curso (
  disciplina text REFERENCES consulta.disciplina (sigla),
  curso text REFERENCES consulta.curso (id),
  PRIMARY KEY (disciplina, curso)
);

CREATE TABLE IF NOT EXISTS consulta.disciplina_prerequisito (
  disciplina text REFERENCES consulta.disciplina (sigla),
  prerequisito text REFERENCES consulta.disciplina (sigla),
  PRIMARY KEY (disciplina)
);

CREATE TABLE IF NOT EXISTS consulta.disciplina_cursada (
  matricula text NOT NULL REFERENCES consulta.estudante,
  sigla text NOT NULL REFERENCES consulta.disciplina,
  nota numeric(4,2) NOT NULL,
  situacao char(3) NOT NULL,
  PRIMARY KEY (matricula, sigla)
);


CREATE TABLE IF NOT EXISTS consulta.ensino_medio (
  estudante text NOT NULL REFERENCES consulta.estudante (matricula),
  -- instituicao text,
  cidade text,
  ano_conclusao char(4),
  PRIMARY KEY (estudante)
);

CREATE TABLE IF NOT EXISTS consulta.ingresso (
  estudante text NOT NULL REFERENCES consulta.estudante (matricula),
  forma_ingresso varchar(255) NOT NULL,
  cota varchar(255) NOT NULL,
  ano_semestre char(6) NOT NULL,
  PRIMARY KEY (estudante)
);

CREATE TABLE IF NOT EXISTS consulta.notas_enem (
  estudante text NOT NULL REFERENCES consulta.estudante (matricula),
  redacao numeric(7,2) NOT NULL, --text?
  linguagens numeric(7,2) NOT NULL,
  matematica numeric(7,2) NOT NULL,
  cien_nat numeric(7,2) NOT NULL,
  cien_hum numeric(7,2) NOT NULL,
  curso numeric(7,2) NOT NULL,
  PRIMARY KEY (estudante) 
);