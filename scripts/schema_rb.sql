CREATE SCHEMA academico;

CREATE TABLE academico.alunos(
    id bigserial PRIMARY KEY,
    curso_id bigint REFERENCES cursos(id),
    area_de_concentracao_id bigint REFERENCES area_de_concentracaos(id),
    linha_de_pesquisa_id bigint REFERENCES linha_de_pesquisas(id),
    matriz_id bigint REFERENCES matrizs(id)
);

CREATE TABLE academico.aproveitamentos_de_atividade(
    id bigserial PRIMARY KEY,
    aluno_id bigint  NOT NULL REFERENCES alunos(id),
    participacao_id bigint  NOT NULL REFERENCES participacaos(id)
);

CREATE TABLE academico.aproveitamentos_internos(
    id bigserial PRIMARY KEY,
    aluno_id bigint  NOT NULL REFERENCES alunos(id),
    ano_semestre text  NOT NULL
);

CREATE TABLE academico.areas_de_concentracao(
    id bigserial PRIMARY KEY,
    nome text  NOT NULL,
    curso_id bigint REFERENCES cursos(id)
);

CREATE TABLE academico.atividades(
    id bigserial PRIMARY KEY,
    disciplina_id bigint REFERENCES disciplinas(id),
    descricao text,
    ano_semestre text  NOT NULL
);

CREATE TABLE academico.co_requisitos(
    id bigserial PRIMARY KEY,
    co_requisitante_id bigint REFERENCES co_requisitantes(id),
    co_requisito_id bigint REFERENCES co_requisitos(id)
);

CREATE TABLE academico.cursos(
    id bigserial PRIMARY KEY,
    nome text  NOT NULL,
    modalidade text,
    habilitacao text,
    sigla text
);

CREATE TABLE academico.disciplina_grupos(
    id bigserial PRIMARY KEY,
    disciplina_id bigint  NOT NULL REFERENCES disciplinas(id),
    grupo_id bigint  NOT NULL REFERENCES grupos(id),
    ano_semestre_inicio text,
    ano_semestre_fim text
);

CREATE TABLE academico.disciplina_matrizes(
    id bigserial PRIMARY KEY,
    disciplina_id bigint  NOT NULL REFERENCES disciplinas(id),
    matriz_id bigint  NOT NULL REFERENCES matrizs(id),
    periodo_referencia integer  NOT NULL,
    area_de_concentracao_id bigint REFERENCES area_de_concentracaos(id)
);

CREATE TABLE academico.disciplinas(
    id bigserial PRIMARY KEY,
    sigla text  NOT NULL,
    nome text  NOT NULL,
    laboratorio_id bigint REFERENCES laboratorios(id),
    ano_semestre_inicio text  NOT NULL,
    ano_semestre_fim text,
    horas_teorica integer  NOT NULL,
    horas_pratica integer  NOT NULL,
    horas_extra_classe integer  NOT NULL,
    creditos integer    NOT NULL,
    tipo_aprovacao text  NOT NULL
);

CREATE TABLE academico.disciplinas_itens_isencao(
    id bigserial PRIMARY KEY,
    disciplina_id bigint REFERENCES disciplinas(id),
    item_isencao_id bigint REFERENCES item_isencaos(id)
);

CREATE TABLE academico.equivalencias(
    id bigserial PRIMARY KEY,
    equivalida_id bigint REFERENCES equivalidas(id),
    equivalente_id bigint REFERENCES equivalentes(id)
);

CREATE TABLE academico.equivalencias_a_pedido(
    id bigserial PRIMARY KEY,
    aluno_id bigint  NOT NULL REFERENCES alunos(id),
    ano_semestre text  NOT NULL
);

CREATE TABLE academico.grupos(
    id bigserial PRIMARY KEY,
    matriz_id bigint  NOT NULL REFERENCES matrizs(id),
    nome text  NOT NULL,
    minimo_disciplinas integer,
    minimo_creditos integer,
    minimo_carga_horaria integer,
    area_de_concentracao_id bigint REFERENCES area_de_concentracaos(id)
);

CREATE TABLE academico.inscricoes(
    id bigserial PRIMARY KEY,
    plano_id bigint REFERENCES planos(id),
    turma_id bigint REFERENCES turmas(id),
    situacao text,
    faltas integer,
    nota_ef numeric(3,1),
    nota numeric(3,1)
);

CREATE TABLE academico.isencoes(
    id bigserial PRIMARY KEY,
    aluno_id bigint  NOT NULL REFERENCES alunos(id),
    ano_semestre text  NOT NULL
);

CREATE TABLE academico.itens_aproveitamento_interno(
    id bigserial PRIMARY KEY,
    aproveitamento_interno_id bigint  NOT NULL REFERENCES aproveitamento_internos(id),
    inscricao_id bigint REFERENCES inscricaos(id),
    disciplina_id bigint  NOT NULL REFERENCES disciplinas(id),
    participacao_id bigint REFERENCES participacaos(id)
);

CREATE TABLE academico.itens_equivalencia_a_pedido(
    id bigserial PRIMARY KEY,
    equivalencia_a_pedido_id bigint  NOT NULL REFERENCES equivalencia_a_pedidos(id),
    inscricao_id bigint REFERENCES inscricaos(id),
    disciplina_id bigint  NOT NULL REFERENCES disciplinas(id),
    participacao_id bigint REFERENCES participacaos(id)
);

CREATE TABLE academico.itens_isencao(
    id bigserial PRIMARY KEY,
    isencao_id bigint  NOT NULL REFERENCES isencaos(id)
);

CREATE TABLE academico.itens_transferencia_externa(
    id bigserial PRIMARY KEY,
    transferencia_externa_id bigint  NOT NULL REFERENCES transferencia_externas(id),
    nome text  NOT NULL,
    valor text  NOT NULL
    
);

CREATE TABLE academico.matrizes(
    id bigserial PRIMARY KEY,
    curso_id bigint REFERENCES cursos(id),
    ano_semestre_inicio text,
    ano_semestre_fim text,
    numero_de_periodos integer,
    creditos_obrigatorios integer,
    carga_horaria_obrigatoria integer,
    periodos_fixos integer,
    ch_total_minima integer
);

CREATE TABLE academico.participacoes(
    id bigserial PRIMARY KEY,
    aluno_id bigint REFERENCES alunos(id),
    atividade_id bigint REFERENCES atividades(id),
    faltas integer,
    nota numeric(3,1),
    satisfatoria_em date,
    insatisfatoria_em date
);

CREATE TABLE academico.planos(
    id bigserial PRIMARY KEY,
    ano_semestre text,
    aluno_id bigint REFERENCES alunos(id)
);

CREATE TABLE academico.pre_requisitos(
    id bigserial PRIMARY KEY,
    pre_requisitante_id bigint REFERENCES pre_requisitantes(id),
    pre_requisito_id bigint REFERENCES pre_requisitos(id)
);

CREATE TABLE academico.quebras_de_pre_requisito(
    id bigserial PRIMARY KEY,
    aluno_id bigint REFERENCES alunos(id),
    inscricao_id bigint REFERENCES inscricaos(id)
);

CREATE TABLE academico.turmas(
    id bigserial PRIMARY KEY,
    codigo text,
    disciplina_id bigint REFERENCES disciplinas(id),
    ano_semestre text
);
