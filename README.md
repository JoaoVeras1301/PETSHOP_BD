# Sistema de Gestão para Petshop e Clínica Veterinária

Trabalho de Modelagem de Banco de Dados — projeto de estudo desenvolvido para a disciplina de Banco de Dados.

## 1. Tema

Sistema de banco de dados para centralizar o cadastro de clientes, pets, funcionários, serviços, produtos, agendamentos, histórico clínico (prontuário) e microchip de identificação de cada animal.

## 2. Contexto e Justificativa

Petshops e clínicas veterinárias costumam depender de controle manual ou planilhas para gerenciar suas operações, o que dificulta o acompanhamento do histórico de cada pet, a agenda dos profissionais e o controle de estoque. Este projeto propõe um modelo de banco de dados relacional que resolve esses problemas centralizando as informações em uma estrutura única e consistente.

- **Social:** histórico clínico completo e acessível para cada pet, favorecendo diagnósticos mais precisos.
- **Econômica:** gestão mais eficiente para pequenos e médios negócios, reduzindo erros de agenda e perdas de venda.
- **Tecnológica:** aplicação prática de modelagem conceitual, lógica e física em um cenário com relacionamentos binários, ternário e de generalização/especialização.

## 3. Escopo

**Contempla:**
- Cadastro de clientes e seus pets (um cliente pode ter múltiplos pets)
- Cadastro de funcionários (veterinário, tosador, atendente)
- Cadastro de serviços (banho, tosa, consulta, vacina) e produtos (ração, brinquedos, medicamentos)
- Agendamento de serviços (cliente + pet + funcionário + serviço)
- Histórico de atendimentos/prontuário de cada pet
- Cadastro de microchip de identificação (relação 1:1 com o pet)
- Registro de vendas de produtos

**Não contempla:**
- Controle financeiro/contábil completo
- Programa de fidelidade
- Integração com meios de pagamento online

## 4. Estrutura do Repositório

```
petshop-db/
├── README.md              # este arquivo
├── docs/
│   ├── tema-e-contexto.pdf     # documento com tema, contexto e prévia das entidades
│   └── der-conceitual.png      # imagem do DER (notação de Chen)
└── sql/
    └── schema.sql          # script DDL do modelo lógico/físico (MySQL/PostgreSQL)
```

## 5. Modelo Conceitual (DER)

Elaborado segundo a notação de Chen, contemplando entidades fortes, fracas, associativas e especializadas, com relacionamentos binários, ternário e de generalização/especialização.

| Tipo | Entidade | Observação |
|---|---|---|
| Forte | Cliente | Dono do(s) pet(s) |
| Fraca | Pet | Depende da entidade Cliente |
| Forte | Funcionário | Generaliza as especializações abaixo |
| Especializada | Veterinário / Tosador / Atendente | Subtipos de Funcionário |
| Forte | Serviço | Banho, tosa, consulta, vacina |
| Forte | Produto | Itens disponíveis para venda |
| Associativa | Agendamento | Liga Pet + Funcionário + Serviço |
| Fraca | Prontuário | Depende do Pet; guarda histórico clínico |
| Associativa | Venda | Liga Cliente + Produto |
| Forte | Microchip | Relação 1:1 com o Pet |

## 6. Modelo Lógico/Físico

Ver [`sql/schema.sql`](sql/schema.sql) para o script de criação das tabelas (DDL), com chaves primárias, estrangeiras e as tabelas de especialização de Funcionário.

## 7. Como usar

```bash
# clonar o repositório
git clone https://github.com/<seu-usuario>/petshop-db.git
cd petshop-db

# rodar o script no MySQL, por exemplo
mysql -u root -p < sql/schema.sql
```

## 8. Autor

João Victor Veras Agapito — Engenharia de Software, UCB
