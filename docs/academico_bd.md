# Academico database notes

## Disciplinas  
### Modelo Entidade Relacionamento das disciplinas no Acadêmico
- inscricoes(id, plano_id, turma_id, situacao, faltas, nota_ef, nota) 
  - planos(id, ano_semestre, aluno_id)
  - turmas(id, codigo, disciplina_id, ano_semestre)

- participacoes(id, aluno_id, atividade_id, faltas, nota, satisfatoria_em, insatisfatoria_em)
  - atividades(id, disciplina_id, descricao, ano_semestre)
- aproveitamentos_de_atividade(id, **aluno_id**, **participacao_id**) #aproveitamento AARE

- equivalencias(equivalida_id, equivalente_id) #equivalida disciplina

- equivalencias_a_pedido(id, aluno_id, ano_semestre) #aproveitamento disciplina em outra matrícula
  - itens_equivalencia_a_pedido(
    - equivalencia_a_pedido_id,
    - inscricao_id,
    - **disciplina_id**,
    - participacao_id)

- aproveitamentos_internos(id, aluno_id, ano_semestre) #aproveitamento disciplina de outra matriz
  - itens_aproveitamento_interno(
    - **aproveitamento_interno_id**,
    - inscricao_id, 
    - **disciplina_id**,
    - participacao_id)


- isencoes(id, **aluno_id**, **ano_semestre**) #aproveitamento disciplina de outra instituição
  - itens_isencao(id, **isencao_id**)
  - disciplinas_itens_isencao(id, disciplina_id, item_isencao_id)


### Modelagem pro consulta_academico

disciplinas_cursadas_aproveitadas_ou_equivalentes(
    aluno_id, 
    disciplina_id, 
    situacao, 
    nota,  
    faltas, 
    ano_semestre,
    origem : [inscricao, atividade, aprov_isencao, aprov_pedido, aprov_interno, equivalencia]
)


### Explicações 
- **inscrição**: aluno cursa turma em seu plano de estudos
- **participação**: aluno cursa AARE, cujo resultado passa por um aproveitamento de atividade para ser contabilizado
- **isenção**: aproveitamento de estudo realizado em outra instituição, relacionando disciplina externa a disciplina da matriz
- **equivalência a pedido**: aproveitamento de estudo realizado em outra matrícula na própria UENF, relacionando-o a disciplina da matriz
- **aproveitamento interno**: aproveitamento de estudo em disciplina no curso atual mas que não seja da matriz, relacionando-o a disciplina da matriz

**Isenção** estabelece disciplina porque não há uma inscrição no banco à qual se referir, uma vez que a disciplina vem de fora e não se relaciona com nada que o aluno tenha já cursado aqui.

As outras se referem a inscrição porque ou se relacionam a inscrição no curso corrente ou em curso anterior.

**Equivalência** já é um conceito diferente, é o estabelecimento de que uma disciplina da UENF equivale a outra. Então todos os conceitos que discutimos acima se aplicam a disciplinas da matriz ou a suas equivalentes. Por exemplo, existe na matriz um Cálculo I mas o aluno cursou uma disciplina mais antiga, Matemática I, que é equivalente. O fato de ter cursado (inscrição/participação) ou aproveitado (via qualquer um dos meios) Matemática I daria ao aluno Cálculo I, caso haja equivalência entre as duas.

