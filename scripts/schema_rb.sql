CREATE SCHEMA academico;

CREATE TABLE academico.alunos(
    id BIGSERIAL PRIMARY KEY,
    curso_id BIGINT REFERENCES cursos(id),
    area_de_concentracao_id BIGINT REFERENCES area_de_concentracaos(id),
    linha_de_pesquisa_id BIGINT REFERENCES linha_de_pesquisas(id),
    matriz_id BIGINT REFERENCES matrizs(id)
);

CREATE TABLE academico.aproveitamentos_de_atividade(
    id BIGSERIAL PRIMARY KEY,
    aluno_id BIGINT  NOT NULL REFERENCES alunos(id),
    participacao_id BIGINT  NOT NULL REFERENCES participacaos(id)
);

CREATE TABLE academico.aproveitamentos_internos(
    id BIGSERIAL PRIMARY KEY,
    aluno_id BIGINT  NOT NULL REFERENCES alunos(id),
    ano_semestre TEXT  NOT NULL
);

CREATE TABLE academico.areas_de_concentracao(
    id BIGSERIAL PRIMARY KEY,
    nome TEXT  NOT NULL,
    curso_id BIGINT REFERENCES cursos(id)
);

CREATE TABLE academico.atividades(
    id BIGSERIAL PRIMARY KEY,
    disciplina_id BIGINT REFERENCES disciplinas(id),
    descricao TEXT,
    ano_semestre TEXT  NOT NULL
);

CREATE TABLE academico.co_requisitos(
    id BIGSERIAL PRIMARY KEY,
    co_requisitante_id BIGINT REFERENCES co_requisitantes(id),
    co_requisito_id BIGINT REFERENCES co_requisitos(id)
);

CREATE TABLE academico.cursos(
    id BIGSERIAL PRIMARY KEY,
    nome TEXT  NOT NULL,
    modalidade TEXT,
    habilitacao TEXT,
    sigla TEXT
);

CREATE TABLE academico.disciplina_grupos(
    id BIGSERIAL PRIMARY KEY,
    disciplina_id BIGINT  NOT NULL REFERENCES disciplinas(id),
    grupo_id BIGINT  NOT NULL REFERENCES grupos(id),
    ano_semestre_inicio TEXT,
    ano_semestre_fim TEXT
);

CREATE TABLE academico.disciplina_matrizes(
    id BIGSERIAL PRIMARY KEY,
    disciplina_id BIGINT  NOT NULL REFERENCES disciplinas(id),
    matriz_id BIGINT  NOT NULL REFERENCES matrizs(id),
    periodo_referencia INTEGER  NOT NULL,
    area_de_concentracao_id BIGINT REFERENCES area_de_concentracaos(id)
);

CREATE TABLE academico.disciplinas(
    id BIGSERIAL PRIMARY KEY,
    sigla TEXT  NOT NULL,
    nome TEXT  NOT NULL,
    laboratorio_id BIGINT REFERENCES laboratorios(id),
    ano_semestre_inicio TEXT  NOT NULL,
    ano_semestre_fim TEXT,
    horas_teorica INTEGER  NOT NULL,
    horas_pratica INTEGER  NOT NULL,
    horas_extra_classe INTEGER  NOT NULL,
    creditos INTEGER    NOT NULL,
    tipo_aprovacao TEXT  NOT NULL
);

CREATE TABLE academico.disciplinas_itens_isencao(
    id BIGSERIAL PRIMARY KEY,
    disciplina_id BIGINT REFERENCES disciplinas(id),
    item_isencao_id BIGINT REFERENCES item_isencaos(id)
);

CREATE TABLE academico.equivalencias(
    id BIGSERIAL PRIMARY KEY,
    equivalida_id BIGINT REFERENCES equivalidas(id),
    equivalente_id BIGINT REFERENCES equivalentes(id)
);

CREATE TABLE academico.equivalencias_a_pedido(
    id BIGSERIAL PRIMARY KEY,
    aluno_id BIGINT  NOT NULL REFERENCES alunos(id),
    ano_semestre TEXT  NOT NULL
);

CREATE TABLE academico.grupos(
    id BIGSERIAL PRIMARY KEY,
    matriz_id BIGINT  NOT NULL REFERENCES matrizs(id),
    nome TEXT  NOT NULL,
    minimo_disciplinas INTEGER,
    minimo_creditos INTEGER,
    minimo_carga_horaria INTEGER,
    area_de_concentracao_id BIGINT REFERENCES area_de_concentracaos(id)
);

CREATE TABLE academico.inscricoes(
    id BIGSERIAL PRIMARY KEY,
    plano_id BIGINT REFERENCES planos(id),
    turma_id BIGINT REFERENCES turmas(id),
    situacao TEXT,
    faltas INTEGER,
    nota_ef NUMERIC(3,1),
    nota NUMERIC(3,1)
);

CREATE TABLE academico.isencoes(
    id BIGSERIAL PRIMARY KEY,
    aluno_id BIGINT  NOT NULL REFERENCES alunos(id),
    ano_semestre TEXT  NOT NULL
);

CREATE TABLE academico.itens_aproveitamento_interno(
    id BIGSERIAL PRIMARY KEY,
    aproveitamento_interno_id BIGINT  NOT NULL REFERENCES aproveitamento_internos(id),
    inscricao_id BIGINT REFERENCES inscricaos(id),
    disciplina_id BIGINT  NOT NULL REFERENCES disciplinas(id),
    participacao_id BIGINT REFERENCES participacaos(id)
);

CREATE TABLE academico.itens_equivalencia_a_pedido(
    id BIGSERIAL PRIMARY KEY,
    equivalencia_a_pedido_id BIGINT  NOT NULL REFERENCES equivalencia_a_pedidos(id),
    inscricao_id BIGINT REFERENCES inscricaos(id),
    disciplina_id BIGINT  NOT NULL REFERENCES disciplinas(id),
    participacao_id BIGINT REFERENCES participacaos(id)
);

CREATE TABLE academico.itens_isencao(
    id BIGSERIAL PRIMARY KEY,
    isencao_id BIGINT  NOT NULL REFERENCES isencaos(id)
);

CREATE TABLE academico.itens_transferencia_externa(
    id BIGSERIAL PRIMARY KEY,
    transferencia_externa_id BIGINT  NOT NULL REFERENCES transferencia_externas(id),
    nome TEXT  NOT NULL,
    valor TEXT  NOT NULL
    
);

CREATE TABLE academico.matrizes(
    id BIGSERIAL PRIMARY KEY,
    curso_id BIGINT REFERENCES cursos(id),
    ano_semestre_inicio TEXT,
    ano_semestre_fim TEXT,
    numero_de_periodos INTEGER,
    creditos_obrigatorios INTEGER,
    carga_horaria_obrigatoria INTEGER,
    periodos_fixos INTEGER,
    ch_total_minima INTEGER
);

CREATE TABLE academico.participacoes(
    id BIGSERIAL PRIMARY KEY,
    aluno_id BIGINT REFERENCES alunos(id),
    atividade_id BIGINT REFERENCES atividades(id),
    faltas INTEGER,
    nota NUMERIC(3,1),
    satisfatoria_em DATE,
    insatisfatoria_em DATE
);

CREATE TABLE academico.planos(
    id BIGSERIAL PRIMARY KEY,
    ano_semestre TEXT,
    aluno_id BIGINT REFERENCES alunos(id)
);

CREATE TABLE academico.pre_requisitos(
    id BIGSERIAL PRIMARY KEY,
    pre_requisitante_id BIGINT REFERENCES pre_requisitantes(id),
    pre_requisito_id BIGINT REFERENCES pre_requisitos(id)
);

CREATE TABLE academico.quebras_de_pre_requisito(
    id BIGSERIAL PRIMARY KEY,
    aluno_id BIGINT REFERENCES alunos(id),
    inscricao_id BIGINT REFERENCES inscricaos(id)
);

CREATE TABLE academico.turmas(
    id BIGSERIAL PRIMARY KEY,
    codigo TEXT,
    disciplina_id BIGINT REFERENCES disciplinas(id),
    ano_semestre TEXT
);
