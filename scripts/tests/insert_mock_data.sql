INSERT INTO alunos (id, curso_id, matriz_id) VALUES
(1, 1, 1), --Daniel
(2, 1, 1), --João
(3, 1, 1); --José

INSERT INTO disciplinas (id, nome) VALUES
(1, 'Projeto de Monografia'),
(2, 'Teste de Software'),
(3, 'Metodologia Trabalho'),
(4, 'Inglês 1')
(5, 'projmono_prereq1')
(6, 'projmono_prereq2')
(7, 'testsoft_prereq'),
(8, 'metotrab_prereq');

INSERT INTO disciplina_matrizes (id, matriz_id, disciplina_id, periodo_referencia) VALUES
(1, 1, 1, 1),
(2, 1, 2, 1),
(3, 1, 3, 1),
(4, 1, 4, 1),
(5, 1, 5, 1),
(6, 1, 6, 1),
(7, 1, 7, 1),
(8, 1, 8, 1);


INSERT INTO pre_requisitos (pre_requisitante_id, pre_requisito_id) VALUES
(1, 4),  
(1, 5),
(1, 6),
(2, 7),
(3, 8);

-- INSERT INTO co_requisitos (co_requisitante_id, co_requisito_id) VALUES
-- ;

INSERT INTO planos (id, aluno_id) VALUES
(1, 1), --Daniel 
(2, 2), --João
(3, 3); --José

INSERT INTO inscricoes (id, plano_id, turma_id, situacao) VALUES
(1, 1, 3, 'APR'),
(2, 1, 4, 'APR'),
(3, 1, 5, 'APR'),
(4, 1, 6, 'APR'),
(5, 1, 7, 'APR'),
(6, 1, 8, 'APR'),
--
(7,  2, 4, 'APR'),
(8,  2, 5, 'APR'),
(9,  2, 6, 'APR'),
(10, 2, 7, 'APR'),
(11, 2, 8, 'APR'),
--
(12, 3, 6, 'APR'),
(13, 3, 7, 'APR'),
(14, 3, 8, 'APR');

INSERT INTO turmas (id, disciplina_id) VALUES
 (1,1), --'Projeto de Monografia'),
 (2,2), --'Teste de Software'),
 (3,3), --'Metodologia Trabalho'),
 (4,4), --'Inglês 1')
 (5,5), --'projmono_prereq1')
 (6,6), --'projmono_prereq2')
 (7,7), --'testsoft_prereq'),
 (8,8); --'metotrab_prereq');

