CREATE SCHEMA IF NOT EXISTS academ;

CREATE TABLE IF NOT EXISTS academ.curso (
  id text PRIMARY KEY,
  nome text,
  centro text, -- varchar(5)?
  lab text, --varchar(5)?
);

CREATE TABLE IF NOT EXISTS academ.disciplina (
  sigla text NOT NULL, --char(10)?
  nome text NOT NULL, 
  creditos integer NOT NULL,
  carga_horaria integer NOT NULL,
  PRIMARY KEY (sigla)
);

CREATE TABLE IF NOT EXISTS academ.estudante (
  matricula text NOT NULL, -- analisar se matrícula (pseudoanonimização) é suficiente ou substituir por um ID aleatório
  curso text NOT NULL REFERENCES academ.curso(id),
  situacao text NOT NULL, -- char(n)?
  data_matricula date NOT NULL,
  creditos_acum integer NOT NULL,
  carga_horaria text NOT NULL,
  cre numeric(3,2) NOT NULL, -- text?
  PRIMARY KEY (matricula)
);

CREATE TABLE IF NOT EXISTS academ.disciplina_curso (
  disciplina text REFERENCES academ.disciplina(sigla),
  curso text REFERENCES academ.curso(id)
  PRIMARY KEY (disciplina, curso)
);

CREATE TABLE IF NOT EXISTS academ.disciplina_prerequisito (
  disciplina text REFERENCES academ.disciplina(sigla),
  prerequisito text REFERENCES academ.disciplina(sigla),
  PRIMARY KEY (disciplina)
);

CREATE TABLE IF NOT EXISTS academ.disciplina_cursada (
  matricula text NOT NULL REFERENCES academ.estudante,
  sigla text NOT NULL REFERENCES academ.disciplina,
  nota numeric(4,2) NOT NULL,
  situacao char(3) NOT NULL,
  PRIMARY KEY (estudante_matricula, disciplina_sigla),
);


CREATE TABLE IF NOT EXISTS academ.ensino_medio (
  estudante text NOT NULL REFERENCES academ.estudante(matricula),
  -- instituicao text,
  cidade text,
  ano_conclusao char(4),
  PRIMARY KEY (estudante)
);

CREATE TABLE IF NOT EXISTS academ.ingresso (
  estudante text NOT NULL REFERENCES academ.estudante(matricula),
  forma_ingresso varchar(255) NOT NULL,
  cota varchar(255) NOT NULL,
  ano_semestre char(6) NOT NULL,
  PRIMARY KEY (estudante)
);

CREATE TABLE IF NOT EXISTS academ.notas_enem (
  estudante text NOT NULL REFERENCES academ.estudante(matricula),
  redacao numeric(7,2) NOT NULL, --text?
  linguagens numeric(7,2) NOT NULL,
  matematica numeric(7,2) NOT NULL,
  cien_nat numeric(7,2) NOT NULL,
  cien_hum numeric(7,2) NOT NULL,
  curso numeric(7,2) NOT NULL,
  FOREIGN KEY (estudante) 
);