ActiveRecord::Schema[7.0].define(version: 2023_03_16_034939) do
  create_table "alunos", force: :cascade do |t|
    t.bigint "curso_id"
    t.bigint "area_de_concentracao_id"
    t.bigint "linha_de_pesquisa_id"
    t.bigint "matriz_id"
  end

  create_table "aproveitamentos_de_atividade", force: :cascade do |t|
    t.bigint "aluno_id", null: false
    t.bigint "participacao_id", null: false
  end

  create_table "aproveitamentos_internos", force: :cascade do |t|
    t.bigint "aluno_id", null: false
    t.string "ano_semestre", null: false
  end

  create_table "areas_de_concentracao", force: :cascade do |t|
    t.string "nome", null: false
    t.bigint "curso_id"
  end

  create_table "atividades", force: :cascade do |t|
    t.bigint "disciplina_id"
    t.string "descricao"
    t.string "ano_semestre", null: false
  end

  create_table "co_requisitos", id: false, force: :cascade do |t|
    t.bigint "co_requisitante_id"
    t.bigint "co_requisito_id"
  end

  create_table "cursos", force: :cascade do |t|
    t.string "nome", null: false
    t.string "modalidade"
    t.string "habilitacao"
    t.string "sigla"
  end

  create_table "disciplina_grupos", force: :cascade do |t|
    t.bigint "disciplina_id", null: false
    t.bigint "grupo_id", null: false
    t.string "ano_semestre_inicio"
    t.string "ano_semestre_fim"
  end

  create_table "disciplina_matrizes", force: :cascade do |t|
    t.bigint "disciplina_id", null: false
    t.bigint "matriz_id", null: false
    t.integer "periodo_referencia", null: false
    t.bigint "area_de_concentracao_id"
  end

  create_table "disciplinas", force: :cascade do |t|
    t.string "sigla", null: false
    t.string "nome", null: false
    t.bigint "laboratorio_id"
    t.string "ano_semestre_inicio", null: false
    t.string "ano_semestre_fim"
    t.integer "horas_teorica", null: false
    t.integer "horas_pratica", null: false
    t.integer "horas_extra_classe", null: false
    t.integer "creditos", default: 0, null: false
    t.string "tipo_aprovacao", null: false
  end

  create_table "disciplinas_itens_isencao", force: :cascade do |t|
    t.bigint "disciplina_id"
    t.bigint "item_isencao_id"
  end

  create_table "equivalencias", id: false, force: :cascade do |t|
    t.bigint "equivalida_id"
    t.bigint "equivalente_id"
  end

  create_table "equivalencias_a_pedido", force: :cascade do |t|
    t.bigint "aluno_id", null: false
    t.string "ano_semestre", null: false
  end

  create_table "grupos", force: :cascade do |t|
    t.bigint "matriz_id", null: false
    t.string "nome", null: false
    t.integer "minimo_disciplinas"
    t.integer "minimo_creditos"
    t.integer "minimo_carga_horaria"
    t.bigint "area_de_concentracao_id"
  end

  create_table "inscricoes", force: :cascade do |t|
    t.bigint "plano_id"
    t.bigint "turma_id"
    t.string "situacao"
    t.integer "faltas"
    t.decimal "nota_ef", precision: 3, scale: 1
    t.decimal "nota", precision: 3, scale: 1
  end

  create_table "isencoes", force: :cascade do |t|
    t.bigint "aluno_id", null: false
    t.string "ano_semestre", null: false
  end

  create_table "itens_aproveitamento_interno", force: :cascade do |t|
    t.bigint "aproveitamento_interno_id", null: false
    t.bigint "inscricao_id"
    t.bigint "disciplina_id", null: false
    t.bigint "participacao_id"
  end

  create_table "itens_equivalencia_a_pedido", force: :cascade do |t|
    t.bigint "equivalencia_a_pedido_id", null: false
    t.bigint "inscricao_id"
    t.bigint "disciplina_id", null: false
    t.bigint "participacao_id"
  end

  create_table "itens_isencao", force: :cascade do |t|
    t.bigint "isencao_id", null: false
  end

  create_table "itens_transferencia_externa", force: :cascade do |t|
    t.bigint "transferencia_externa_id", null: false
    t.string "nome", null: false
    t.string "valor", null: false
    t.index ["transferencia_externa_id"], name: "index_itens_transferencia_externa_on_transferencia_externa_id"
  end

  create_table "matrizes", force: :cascade do |t|
    t.bigint "curso_id"
    t.string "ano_semestre_inicio"
    t.string "ano_semestre_fim"
    t.integer "numero_de_periodos"
    t.integer "creditos_obrigatorios"
    t.integer "carga_horaria_obrigatoria"
    t.integer "periodos_fixos"
    t.integer "ch_total_minima"
  end

  create_table "participacoes", force: :cascade do |t|
    t.bigint "aluno_id"
    t.bigint "atividade_id"
    t.integer "faltas"
    t.decimal "nota", precision: 3, scale: 1
    t.datetime "satisfatoria_em"
    t.datetime "insatisfatoria_em"
  end

  create_table "planos", force: :cascade do |t|
    t.string "ano_semestre"
    t.bigint "aluno_id"
  end

  create_table "pre_requisitos", id: false, force: :cascade do |t|
    t.bigint "pre_requisitante_id"
    t.bigint "pre_requisito_id"
  end

  create_table "quebras_de_pre_requisito", force: :cascade do |t|
    t.bigint "aluno_id"
    t.bigint "inscricao_id"
  end

  create_table "turmas", force: :cascade do |t|
    t.string "codigo"
    t.bigint "disciplina_id"
    t.string "ano_semestre"
  end
end
