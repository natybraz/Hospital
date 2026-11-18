# 🏥 Sistema de Gestão Hospitalar — Vida & Saúde

Projeto de modelagem, implementação e consulta de Banco de Dados Relacional desenvolvido em **MySQL** para o **Hospital Geral Vida & Saúde**. O sistema substitui controles legados em planilhas e papel por uma arquitetura centralizada, normalizada até a **Terceira Forma Normal (3FN)**.

---

## 🎯 Objetivos e Regras de Negócio Implementadas

* **Fim da sobreposição de agendas médicas:** restrição `UNIQUE` combinada com `TRIGGER` (`trg_bloqueia_sobreposicao_consulta`) que exige intervalo mínimo de 30 minutos entre atendimentos do mesmo médico.
* **Controle de ocupação de leitos:** gatilho (`trg_bloqueia_sobreposicao_quarto`) que impede a internação simultânea ou em datas conflitantes no mesmo quarto.
* **Proteção contra perda de histórico clínico:** chaves estrangeiras configuradas com `ON DELETE RESTRICT`, bloqueando a exclusão acidental de pacientes, médicos, consultas ou prescrições vinculadas.
* **Consistência financeira e cadastral:** validações `CHECK` (valores positivos e datas coerentes) e restrições `UNIQUE` para CPF, CRM e número de quarto.

---

## 🗂️ Estrutura do Banco de Dados (`hospital_db`)

| Tabela | Descrição |
| :--- | :--- |
| **`pacientes`** | Cadastro de pacientes, CPF único, contato e convênio médico. |
| **`medicos`** | Corpo clínico com registro profissional (CRM único) e especialidade. |
| **`quartos`** | Mapeamento físico dos leitos (número, andar, tipo e status de ocupação). |
| **`internacoes`** | Registro de entradas, saídas e valor de diária por paciente e quarto. |
| **`consultas`** | Agendamentos e atendimentos médicos com data/hora, status e valor. |
| **`prescricoes`** | Medicamentos, posologia e quantidades receitadas em cada consulta. |

---

## 📊 Diagrama Entidade-Relacionamento (DER)

![Diagrama Entidade-Relacionamento](der_hospital_vida_saude.png)

---

## 📁 Arquivos do Repositório

* **`1_ddl_hospital_vida_saude.sql`**: Script DDL e DML contendo a criação do banco `hospital_db`, tabelas, relacionamentos, triggers de integridade e carga de dados de homologação (10 registros por tabela).
* **`2_dql_consultas_hospital.sql`**: Script DQL com as 15 consultas estratégicas (`JOIN`, `GROUP BY`, `SUM`, `AVG`, `LIKE`, `BETWEEN`) para suporte à farmácia, auditoria, recepção e diretoria financeira.
* **`der_hospital_vida_saude.png`**: Diagrama lógico gerado via engenharia reversa no MySQL Workbench.

---

## 🚀 Como Executar

1. Abra o **MySQL Workbench** e conecte-se à sua instância local.
2. Abra e execute o arquivo **`1_ddl_hospital_vida_saude.sql`** completo (`Ctrl + Shift + Enter`) para criar o banco, as regras e popular as tabelas.
3. Atualize o painel **Schemas**, selecione `hospital_db` e execute as consultas do arquivo **`2_dql_consultas_hospital.sql`**.

---

## 🛠️ Tecnologias Utilizadas

* **MySQL** (SGBD Relacional)
* **MySQL Workbench** (Modelagem DER e execução SQL)
