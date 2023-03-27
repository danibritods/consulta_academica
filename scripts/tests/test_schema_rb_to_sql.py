import schema_rb_to_sql as parser

def test_read_file():
    filepath = "tests/test.rb"
    expected = 'ActiveRecord::Schema[7.0].define(version: 2023_03_16_034939) do\n  create_table "alunos", force: :cascade do |t|\n    t.string "nome", null: false\n    t.bigint "curso_id"\n    t.decimal "nota", precision: 3, scal"schema.rb"\n  end\n\n  create_table "itens_isencao", force: :cascade do |t|\n    t.bigint "isencao_id", null: false\n    t.integer "creditos", default: 0, null: false\n    t.string "tipo_aprovacao", null: false #TODO: understand\n    t.index ["transferencia_externa_id"], name: "index_itens_transferencia_externa_on_transferencia_externa_id"\n  end\nend'
    obtained = parser.read_file(filepath)
    assert expected == obtained, "test read_file"

def test_get_tables():
    pass

