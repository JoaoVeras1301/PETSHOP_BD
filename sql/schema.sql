-- =========================================================
-- Sistema de Gestão para Petshop e Clínica Veterinária
-- Script DDL - Modelo Lógico/Físico
-- Baseado no DER Conceitual (notação de Chen)
-- =========================================================

CREATE DATABASE IF NOT EXISTS petshop_db;
USE petshop_db;

-- ---------------------------------------------------------
-- Entidade forte: CLIENTE
-- ---------------------------------------------------------
CREATE TABLE cliente (
    cpf_cliente     CHAR(11)      NOT NULL,
    nome            VARCHAR(120)  NOT NULL,
    telefone        VARCHAR(20),
    email           VARCHAR(120),
    endereco        VARCHAR(200),
    PRIMARY KEY (cpf_cliente)
);

-- ---------------------------------------------------------
-- Entidade fraca: PET (depende de CLIENTE)
-- ---------------------------------------------------------
CREATE TABLE pet (
    id_pet          INT AUTO_INCREMENT,
    cpf_cliente     CHAR(11)      NOT NULL,
    nome            VARCHAR(80)   NOT NULL,
    raca            VARCHAR(60),
    especie         VARCHAR(60),
    data_nascimento DATE,
    PRIMARY KEY (id_pet),
    FOREIGN KEY (cpf_cliente) REFERENCES cliente(cpf_cliente)
        ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- Entidade forte: MICROCHIP (relação 1:1 com PET)
-- ---------------------------------------------------------
CREATE TABLE microchip (
    codigo_microchip VARCHAR(30),
    id_pet           INT NOT NULL UNIQUE,
    data_cadastro    DATE,
    PRIMARY KEY (codigo_microchip),
    FOREIGN KEY (id_pet) REFERENCES pet(id_pet)
        ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- Entidade forte: FUNCIONARIO (generalização)
-- ---------------------------------------------------------
CREATE TABLE funcionario (
    id_func   INT AUTO_INCREMENT,
    nome      VARCHAR(120) NOT NULL,
    cpf       CHAR(11)     NOT NULL UNIQUE,
    cargo     VARCHAR(30)  NOT NULL, -- 'veterinario' | 'tosador' | 'atendente'
    PRIMARY KEY (id_func)
);

-- Especializações (subtipos de FUNCIONARIO)
CREATE TABLE veterinario (
    id_func     INT PRIMARY KEY,
    crmv        VARCHAR(20)  NOT NULL,
    especialidade VARCHAR(80),
    FOREIGN KEY (id_func) REFERENCES funcionario(id_func)
        ON DELETE CASCADE
);

CREATE TABLE tosador (
    id_func     INT PRIMARY KEY,
    registro    VARCHAR(20),
    especialidade VARCHAR(80),
    FOREIGN KEY (id_func) REFERENCES funcionario(id_func)
        ON DELETE CASCADE
);

CREATE TABLE atendente (
    id_func     INT PRIMARY KEY,
    turno       VARCHAR(20),
    FOREIGN KEY (id_func) REFERENCES funcionario(id_func)
        ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- Entidade forte: SERVICO
-- ---------------------------------------------------------
CREATE TABLE servico (
    id_serv   INT AUTO_INCREMENT,
    nome      VARCHAR(80)  NOT NULL,
    preco     DECIMAL(10,2) NOT NULL,
    duracao   TIME,
    PRIMARY KEY (id_serv)
);

-- ---------------------------------------------------------
-- Entidade forte: PRODUTO
-- ---------------------------------------------------------
CREATE TABLE produto (
    id_produto INT AUTO_INCREMENT,
    nome       VARCHAR(120) NOT NULL,
    preco      DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_produto)
);

-- ---------------------------------------------------------
-- Entidade associativa (ternária): AGENDAMENTO
-- Liga PET + FUNCIONARIO + SERVICO
-- ---------------------------------------------------------
CREATE TABLE agendamento (
    id_agenda   INT AUTO_INCREMENT,
    id_pet      INT NOT NULL,
    id_func     INT NOT NULL,
    id_serv     INT NOT NULL,
    data_hora   DATETIME NOT NULL,
    valor       DECIMAL(10,2),
    observacao  VARCHAR(200),
    PRIMARY KEY (id_agenda),
    FOREIGN KEY (id_pet)  REFERENCES pet(id_pet),
    FOREIGN KEY (id_func) REFERENCES funcionario(id_func),
    FOREIGN KEY (id_serv) REFERENCES servico(id_serv)
);

-- ---------------------------------------------------------
-- Entidade fraca: PRONTUARIO (depende de PET)
-- ---------------------------------------------------------
CREATE TABLE prontuario (
    id_prontuario INT AUTO_INCREMENT,
    id_pet        INT NOT NULL,
    data          DATE NOT NULL,
    descricao     VARCHAR(500),
    prescricao    VARCHAR(500),
    PRIMARY KEY (id_prontuario),
    FOREIGN KEY (id_pet) REFERENCES pet(id_pet)
        ON DELETE CASCADE
);

-- ---------------------------------------------------------
-- Entidade associativa: VENDA (liga CLIENTE + PRODUTO via ITEM_VENDA)
-- ---------------------------------------------------------
CREATE TABLE venda (
    id_venda    INT AUTO_INCREMENT,
    cpf_cliente CHAR(11) NOT NULL,
    data_hora   DATETIME NOT NULL,
    PRIMARY KEY (id_venda),
    FOREIGN KEY (cpf_cliente) REFERENCES cliente(cpf_cliente)
);

-- Entidade associativa (chave composta): ITEM_VENDA
CREATE TABLE item_venda (
    id_venda     INT NOT NULL,
    id_produto   INT NOT NULL,
    quantidade   INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_venda, id_produto),
    FOREIGN KEY (id_venda)   REFERENCES venda(id_venda)
        ON DELETE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);
