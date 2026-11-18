USE hospital_db;

-- 1. Relatório completo de prescrições para a farmácia
SELECT 
    p.nome_paciente,
    m.nome_medico,
    c.data_consulta,
    pr.medicamento,
    pr.quantidade
FROM prescricoes pr
INNER JOIN consultas c ON pr.id_consulta = c.id_consulta
INNER JOIN pacientes p ON c.id_paciente = p.id_paciente
INNER JOIN medicos m ON c.id_medico = m.id_medico;

-- 2. Histórico de internações para auditoria
SELECT 
    p.nome_paciente,
    q.numero_quarto,
    q.andar,
    i.data_entrada,
    i.valor_diaria
FROM internacoes i
INNER JOIN pacientes p ON i.id_paciente = p.id_paciente
INNER JOIN quartos q ON i.id_quarto = q.id_quarto;

-- 3. Listagem de todos os pacientes, convênios, médicos atendentes e especialidades
-- (Usa LEFT JOIN para incluir pacientes cadastrados que ainda não passaram por consulta)
SELECT DISTINCT
    p.nome_paciente,
    p.convenio,
    m.nome_medico,
    m.especialidade
FROM pacientes p
LEFT JOIN consultas c ON p.id_paciente = c.id_paciente
LEFT JOIN medicos m ON c.id_medico = m.id_medico;

-- 4. Lista de todas as prescrições emitidas pela coordenação médica
SELECT 
    m.nome_medico,
    m.especialidade,
    p.nome_paciente,
    pr.medicamento
FROM prescricoes pr
INNER JOIN consultas c ON pr.id_consulta = c.id_consulta
INNER JOIN medicos m ON c.id_medico = m.id_medico
INNER JOIN pacientes p ON c.id_paciente = p.id_paciente;

-- 5. Cruzamento sem duplicidades de pacientes que foram internados e também tiveram consultas
SELECT DISTINCT
    p.nome_paciente,
    q.numero_quarto,
    m.nome_medico,
    c.data_consulta
FROM pacientes p
INNER JOIN internacoes i ON p.id_paciente = i.id_paciente
INNER JOIN quartos q ON i.id_quarto = q.id_quarto
INNER JOIN consultas c ON p.id_paciente = c.id_paciente
INNER JOIN medicos m ON c.id_medico = m.id_medico;

-- 6. Consultas registradas ordenadas das mais recentes para as mais antigas
SELECT 
    p.nome_paciente,
    m.nome_medico,
    c.data_consulta
FROM consultas c
INNER JOIN pacientes p ON c.id_paciente = p.id_paciente
INNER JOIN medicos m ON c.id_medico = m.id_medico
ORDER BY c.data_consulta DESC;

-- 7. Listagem financeira de internações ordenada do menor valor de diária para o maior
SELECT 
    p.nome_paciente,
    q.numero_quarto,
    i.valor_diaria
FROM internacoes i
INNER JOIN pacientes p ON i.id_paciente = p.id_paciente
INNER JOIN quartos q ON i.id_quarto = q.id_quarto
ORDER BY i.valor_diaria ASC;

-- 8. Valor médio praticado nas consultas médicas registradas
SELECT 
    ROUND(AVG(valor_consulta), 2) AS valor_medio_consultas
FROM consultas;

-- 9. Valor total arrecadado exclusivamente com consultas agendadas ou realizadas
SELECT 
    SUM(valor_consulta) AS total_arrecadado_consultas
FROM consultas
WHERE status_consulta IN ('Agendada', 'Realizada');

-- 10. Consultas realizadas por pacientes da família "Silva"
SELECT 
    p.nome_paciente,
    m.nome_medico,
    c.data_consulta
FROM consultas c
INNER JOIN pacientes p ON c.id_paciente = p.id_paciente
INNER JOIN medicos m ON c.id_medico = m.id_medico
WHERE p.nome_paciente LIKE '%Silva%';

-- 11. Consultas conduzidas por médicos de áreas ligadas à Cardiologia
SELECT 
    p.nome_paciente,
    m.nome_medico,
    m.especialidade
FROM consultas c
INNER JOIN pacientes p ON c.id_paciente = p.id_paciente
INNER JOIN medicos m ON c.id_medico = m.id_medico
WHERE m.especialidade LIKE '%Cardio%';

-- 12. Internações com data de entrada no primeiro semestre de 2026
SELECT 
    p.nome_paciente,
    q.numero_quarto,
    i.data_entrada
FROM internacoes i
INNER JOIN pacientes p ON i.id_paciente = p.id_paciente
INNER JOIN quartos q ON i.id_quarto = q.id_quarto
WHERE i.data_entrada BETWEEN '2026-01-01' AND '2026-06-30';

-- 13. Valor total investido em consultas por pacientes do convênio "Unimed"
SELECT 
    p.nome_paciente,
    p.convenio,
    SUM(c.valor_consulta) AS total_investido
FROM consultas c
INNER JOIN pacientes p ON c.id_paciente = p.id_paciente
WHERE p.convenio LIKE '%Unimed%'
GROUP BY p.id_paciente, p.nome_paciente, p.convenio
ORDER BY total_investido DESC;

-- 14. Custo total das diárias de internação por andar para pacientes com sobrenome "Oliveira"
SELECT 
    q.andar,
    SUM(i.valor_diaria) AS soma_valores_diarias,
    SUM(DATEDIFF(COALESCE(i.data_saida, CURDATE()), i.data_entrada) * i.valor_diaria) AS custo_total_periodo
FROM internacoes i
INNER JOIN pacientes p ON i.id_paciente = p.id_paciente
INNER JOIN quartos q ON i.id_quarto = q.id_quarto
WHERE p.nome_paciente LIKE '%Oliveira%'
GROUP BY q.andar
ORDER BY q.andar ASC;

-- 15. Faturamento total em consultas agrupado pelas especialidades cirúrgicas
SELECT 
    m.especialidade,
    SUM(c.valor_consulta) AS total_arrecadado
FROM consultas c
INNER JOIN medicos m ON c.id_medico = m.id_medico
WHERE m.especialidade LIKE '%Cirurgia%'
GROUP BY m.especialidade
ORDER BY total_arrecadado DESC;