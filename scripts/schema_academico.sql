CREATE TABLE alunos(
    curso_id bigint,
    area_de_concentracao_id bigint ,
    linha_de_pesquisa_id bigint,
    matriz_id bigint
);

CREATE TABLE aproveitamentos_de_atividade(
    aluno_id bigint  NOT NULL,
    participacao_id bigint  NOT NULL
);

CREATE TABLE aproveitamentos_internos(
    aluno_id bigint  NOT NULL,
    ano_semestre text  NOT NULL
);

CREATE TABLE areas_de_concentracao(
    nome text  NOT NULL,
    curso_id bigint
);

CREATE TABLE atividades(
    disciplina_id bigint,
    descricao text,
    ano_semestre text  NOT NULL
);

CREATE TABLE co_requisitos(
    co_requisitante_id bigint,
    co_requisito_id bigint
);

CREATE TABLE cursos(
    nome text  NOT NULL,
    modalidade text,
    habilitacao text,
    sigla text
);

CREATE TABLE disciplina_grupos(
    disciplina_id bigint  NOT NULL,
    grupo_id bigint  NOT NULL,
    ano_semestre_inicio text,
    ano_semestre_fim text
);

CREATE TABLE disciplina_matrizes(
    disciplina_id bigint  NOT NULL,
    matriz_id bigint  NOT NULL,
    periodo_referencia integer  NOT NULL,
    area_de_concentracao_id bigint
);

CREATE TABLE disciplinas(
    sigla text  NOT NULL,
    nome text  NOT NULL,
    laboratorio_id bigint,
    ano_semestre_inicio text  NOT NULL,
    ano_semestre_fim text,
    horas_teorica integer  NOT NULL,
    horas_pratica integer  NOT NULL,
    horas_extra_classe integer  NOT NULL,
    creditos integer    NOT NULL,
    tipo_aprovacao text  NOT NULL
);

CREATE TABLE disciplinas_itens_isencao(
    disciplina_id bigint,
    item_isencao_id bigint
);

CREATE TABLE equivalencias(
    equivalida_id bigint,
    equivalente_id bigint
);

CREATE TABLE equivalencias_a_pedido(
    aluno_id bigint  NOT NULL,
    ano_semestre text  NOT NULL
);

CREATE TABLE grupos(
    matriz_id bigint  NOT NULL,
    nome text  NOT NULL,
    minimo_disciplinas integer,
    minimo_creditos integer,
    minimo_carga_horaria integer,
    area_de_concentracao_id bigint
);

CREATE TABLE inscricoes(
    plano_id bigint,
    turma_id bigint,
    situacao text,
    faltas integer,
    nota_ef numeric(3,1),
    nota numeric(3,1)
);

CREATE TABLE isencoes(
    aluno_id bigint  NOT NULL,
    ano_semestre text  NOT NULL
);

CREATE TABLE itens_aproveitamento_interno(
    aproveitamento_interno_id bigint  NOT NULL,
    inscricao_id bigint,
    disciplina_id bigint  NOT NULL,
    participacao_id bigint
);

CREATE TABLE itens_equivalencia_a_pedido(
    equivalencia_a_pedido_id bigint  NOT NULL,
    inscricao_id bigint,
    disciplina_id bigint  NOT NULL,
    participacao_id bigint
);

CREATE TABLE itens_isencao(
    isencao_id bigint  NOT NULL
);

CREATE TABLE itens_transferencia_externa(
    transferencia_externa_id bigint  NOT NULL,
    nome text  NOT NULL,
    valor text  NOT NULL,
    index_itens_transferencia_externa_on_transferencia_externa_id     t.index ["transferencia_externa_id"]  name:
);

CREATE TABLE matrizes(
    curso_id bigint,
    ano_semestre_inicio text,
    ano_semestre_fim text,
    numero_de_periodos integer,
    creditos_obrigatorios integer,
    carga_horaria_obrigatoria integer,
    periodos_fixos integer,
    ch_total_minima integer
);

CREATE TABLE participacoes(
    aluno_id bigint,
    atividade_id bigint,
    faltas integer,
    nota numeric(3,1),
    satisfatoria_em date,
    insatisfatoria_em date
);

CREATE TABLE planos(
    ano_semestre text,
    aluno_id bigint
);

CREATE TABLE pre_requisitos(
    pre_requisitante_id bigint,
    pre_requisito_id bigint
);

CREATE TABLE quebras_de_pre_requisito(
    aluno_id bigint,
    inscricao_id bigint
);

CREATE TABLE turmas(
    codigo text,
    disciplina_id bigint,
    ano_semestre text
);
