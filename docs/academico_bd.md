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
    - **aproveitamento_interno_id**,
    - inscricao_id, 
    - **disciplina_id**,
    - participacao_id)

- aproveitamentos_de_atividade(id, **aluno_id**, **participacao_id**)

- isencoes(id, **aluno_id**, **ano_semestre**)
  - disciplinas_itens_isencao(id, disciplina_id, item_isencao_id)
  - itens_isencao(id, isencao_id)

- itens_transferencia_externa(
  - **transferencia_externa_id**
  - **nome**
  - **valor**)

### Rationale 
- `disciplina_id` is the main object 

- `inscricoes` is the main course to take a subject
  - (inscricoes -> turmas -> disciplinas)
- `participacoes` is the alternative way to take a subject
  - (participacoes -> atividades -> disciplinas)
- There are four ways of completing a specific subject without taking it:
  - `equivalencias_a_pedido`
  - `aproveitamentos_internos` 
  - `isencoes`
  - `transferencia_externa`