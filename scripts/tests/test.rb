ActiveRecord::Schema[7.0].define(version: 2023_03_16_034939) do
  create_table "alunos", force: :cascade do |t|
    t.string "nome", null: false
    t.bigint "curso_id"
    t.decimal "nota", precision: 3, scal"schema.rb"
  end

  create_table "itens_isencao", force: :cascade do |t|
    t.bigint "isencao_id", null: false
    t.integer "creditos", default: 0, null: false
    t.string "tipo_aprovacao", null: false #TODO: understand
    t.index ["transferencia_externa_id"], name: "index_itens_transferencia_externa_on_transferencia_externa_id"
  end
end