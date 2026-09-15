CREATE DATABASE IF NOT EXISTS petshop_db;
USE petshop_db;

-- 1. CLIENTE
CREATE TABLE cliente (
    cpf VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255),
    telefone VARCHAR(15),
    email VARCHAR(100)
);

-- 2. FUNCIONARIO (Tabela pai para generalização)
CREATE TABLE funcionario (
    id_func INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    cargo VARCHAR(50) NOT NULL
);

-- Especializações de Funcionário
CREATE TABLE veterinario (
    id_func INT PRIMARY KEY,
    crmv VARCHAR(20) NOT NULL UNIQUE,
    especialidade VARCHAR(50),
    FOREIGN KEY (id_func) REFERENCES funcionario(id_func) ON DELETE CASCADE
);

CREATE TABLE tosador (
    id_func INT PRIMARY KEY,
    registro VARCHAR(20) NOT NULL UNIQUE,
    especialidade VARCHAR(50),
    FOREIGN KEY (id_func) REFERENCES funcionario(id_func) ON DELETE CASCADE
);

CREATE TABLE atendente (
    id_func INT PRIMARY KEY,
    turno VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_func) REFERENCES funcionario(id_func) ON DELETE CASCADE
);

-- 3. MICROCHIP
CREATE TABLE microchip (
    id_microchip INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    data_cadastro DATE NOT NULL
);

-- 4. PET (Entidade fraca associada ao Cliente e opcionalmente ao Microchip)
CREATE TABLE pet (
    id_pet INT AUTO_INCREMENT,
    cpf_cliente VARCHAR(11) NOT NULL,
    id_microchip INT UNIQUE NULL,
    nome VARCHAR(50) NOT NULL,
    raca VARCHAR(50),
    especie VARCHAR(50) NOT NULL,
    data_nasc DATE,
    PRIMARY KEY (id_pet, cpf_cliente),
    FOREIGN KEY (cpf_cliente) REFERENCES cliente(cpf) ON DELETE CASCADE,
    FOREIGN KEY (id_microchip) REFERENCES microchip(id_microchip) ON DELETE SET NULL
);

-- 5. PRONTUARIO (Entidade fraca associada ao Pet)
CREATE TABLE prontuario (
    id_prontuario INT AUTO_INCREMENT,
    id_pet INT NOT NULL,
    cpf_cliente VARCHAR(11) NOT NULL,
    data DATE NOT NULL,
    descricao TEXT NOT NULL,
    prescricao TEXT,
    PRIMARY KEY (id_prontuario, id_pet, cpf_cliente),
    FOREIGN KEY (id_pet, cpf_cliente) REFERENCES pet(id_pet, cpf_cliente) ON DELETE CASCADE
);

-- 6. SERVICO
CREATE TABLE servico (
    id_serv INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    duracao INT NOT NULL -- Duração em minutos
);

-- 7. AGENDAMENTO
CREATE TABLE agendamento (
    id_agenda INT AUTO_INCREMENT PRIMARY KEY,
    id_pet INT NOT NULL,
    cpf_cliente VARCHAR(11) NOT NULL,
    id_serv INT NOT NULL,
    id_func INT NOT NULL, -- Veterinário ou Tosador
    data_hora DATETIME NOT NULL,
    observacao VARCHAR(255),
    FOREIGN KEY (id_pet, cpf_cliente) REFERENCES pet(id_pet, cpf_cliente) ON DELETE CASCADE,
    FOREIGN KEY (id_serv) REFERENCES servico(id_serv) ON DELETE RESTRICT,
    FOREIGN KEY (id_func) REFERENCES funcionario(id_func) ON DELETE RESTRICT
);

-- 8. PRODUTO
CREATE TABLE produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL
);

-- 9. VENDA
CREATE TABLE venda (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    cpf_cliente VARCHAR(11) NOT NULL,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cpf_cliente) REFERENCES cliente(cpf) ON DELETE RESTRICT
);

-- 10. ITEM_VENDA (Entidade Associativa)
CREATE TABLE item_venda (
    id_venda INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_venda, id_produto),
    FOREIGN KEY (id_venda) REFERENCES venda(id_venda) ON DELETE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto) ON DELETE RESTRICT
);
-- Inserir Clientes
INSERT INTO cliente (cpf, nome, endereco, telefone, email) VALUES
('12345678901', 'Carlos Silva', 'Rua das Flores, 123', '11988887777', 'carlos@email.com'),
('98765432100', 'Ana Souza', 'Av. Paulista, 1000', '11977776666', 'ana@email.com');

-- Inserir Funcionários
INSERT INTO funcionario (nome, cpf, cargo) VALUES
('Dra. Márcia Alvez', '11122233344', 'Veterinário'),
('João Pedro', '55566677788', 'Tosador'),
('Fernanda Costa', '99988877766', 'Atendente');

INSERT INTO veterinario (id_func, crmv, especialidade) VALUES (1, 'CRMV-SP 12345', 'Dermatologia');
INSERT INTO tosador (id_func, registro, especialidade) VALUES (2, 'REG-9876', 'Tosa Bebê');
INSERT INTO atendente (id_func, turno) VALUES (3, 'Manhã');

-- Inserir Microchip
INSERT INTO microchip (codigo, data_cadastro) VALUES
('MC-9988776655', '2026-01-10');

-- Inserir Pets
INSERT INTO pet (cpf_cliente, id_microchip, nome, raca, especie, data_nasc) VALUES
('12345678901', 1, 'Thor', 'Golden Retriever', 'Cão', '2021-05-15'),
('98765432100', NULL, 'Mimi', 'Siamês', 'Gato', '2022-08-20');

-- Inserir Serviços
INSERT INTO servico (nome, preco, duracao) VALUES
('Consulta Clínica', 150.00, 30),
('Banho e Tosa', 80.00, 60);

-- Inserir Agendamentos
INSERT INTO agendamento (id_pet, cpf_cliente, id_serv, id_func, data_hora, observacao) VALUES
(1, '12345678901', 1, 1, '2026-09-20 14:00:00', 'Rotina de exames'),
(2, '98765432100', 2, 2, '2026-09-21 10:00:00', 'Sensível a secador');

-- Inserir Prontuário
INSERT INTO prontuario (id_pet, cpf_cliente, data, descricao, prescricao) VALUES
(1, '12345678901', '2026-09-20', 'Paciente apresentou dermatite leve na orelha.', 'Aplicar pomada Otoclean por 7 dias.');

-- Inserir Produtos
INSERT INTO produto (nome, preco) VALUES
('Ração Premium 10kg', 189.90),
('Shampoo Antipulgas', 35.50);

-- Inserir Vendas
INSERT INTO venda (cpf_cliente, data_hora) VALUES ('12345678901', '2026-09-14 18:00:00');

-- Inserir Itens da Venda
INSERT INTO item_venda (id_venda, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 189.90),
(1, 2, 2, 35.50);
-- CONSULTAS (SELECT)

-- 1. Listar todos os pets com os dados dos seus donos e código de microchip (se houver)
SELECT p.nome AS nome_pet, p.especie, p.raca, c.nome AS dono, c.telefone, m.codigo AS microchip
FROM pet p
JOIN cliente c ON p.cpf_cliente = c.cpf
LEFT JOIN microchip m ON p.id_microchip = m.id_microchip;

-- 2. Histórico de prontuários de um pet específico
SELECT p.nome AS pet, pr.data, pr.descricao, pr.prescricao
FROM prontuario pr
JOIN pet p ON pr.id_pet = p.id_pet AND pr.cpf_cliente = p.cpf_cliente
WHERE p.nome = 'Thor';

-- 3. Detalhar vendas com valor total calculado por item e total geral da venda
SELECT v.id_venda, c.nome AS cliente, prod.nome AS produto, iv.quantidade, iv.preco_unitario,
       (iv.quantidade * iv.preco_unitario) AS subtotal
FROM venda v
JOIN cliente c ON v.cpf_cliente = c.cpf
JOIN item_venda iv ON v.id_venda = iv.id_venda
JOIN produto prod ON iv.id_produto = prod.id_produto;

-- ATUALIZAÇÕES (UPDATE)

-- 1. Atualizar o telefone e e-mail de um cliente
UPDATE cliente 
SET telefone = '11999998888', email = 'carlos.novo@email.com' 
WHERE cpf = '12345678901';

-- 2. Reajustar o preço de um produto específico
UPDATE produto 
SET preco = 199.90 
WHERE id_produto = 1;