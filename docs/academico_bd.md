# Academico database notes

## Subjects and its equivalences 
### Entity relationship model
- inscricoes(id, plano_id, turma_id, situacao, faltas, nota_ef, nota) 
  - planos(id, ano_semestre, aluno_id)
  - turmas(id, codigo, disciplina_id, ano_semestre)

- participacoes(id, aluno_id, atividade_id, faltas, nota, satisfatoria_em, insatisfatoria_em)
  - atividades(id, disciplina_id, descricao, ano_semestre)

- equivalencias(equivalida_id, equivalente_id)

- equivalencias_a_pedido(id, aluno_id, ano_semestre)
  - itens_equivalencia_a_pedido(
    - equivalencia_a_pedido_id,
    - inscricao_id,
    - **disciplina_id**,
    - participacao_id)

- aproveitamentos_internos(id, aluno_id, ano_semestre)
  - itens_aproveitamento_interno(
    - aproveitamento_interno_id,
    - inscricao_id, 
    - **disciplina_id**,
    - participacao_id)

### Rationale 
