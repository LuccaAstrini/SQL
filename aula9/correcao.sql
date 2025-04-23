CREATE DATABASE PetShop;
USE PetShop;

-- Cliente
CREATE TABLE Cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    telefone VARCHAR(20),
    cpf VARCHAR(15));

-- Animal
CREATE TABLE Animal (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    especie VARCHAR(50),
    raca VARCHAR(50),
    cliente_id INT,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(id));

-- Serviço
CREATE TABLE Servico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50),
    valor_base DECIMAL(10, 2)
);

-- Agendamento
CREATE TABLE Agendamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    animal_id INT,
    servico_id INT,
    data_agendamento DATETIME,
    status VARCHAR(20),
    valor_final DECIMAL(10, 2),
    FOREIGN KEY (animal_id) REFERENCES Animal(id),
    FOREIGN KEY (servico_id) REFERENCES Servico(id));

-- Clientes
INSERT INTO Cliente (nome, telefone, cpf) VALUES
('João Silva', '11999999999', '111.111.111-11'),
('Maria Souza', '11888888888', '222.222.222-22'),
('Carlos Lima', '11777777777', '333.333.333-33');

-- Animais
INSERT INTO Animal (nome, especie, raca, cliente_id) VALUES
('Rex', 'Cachorro', 'Labrador', 1),
('Luna', 'Gato', 'Persa', 2),
('Thor', 'Cachorro', 'Poodle', 1),
('Mia', 'Gato', 'Siamês', 3);

-- Serviços
INSERT INTO Servico (tipo, valor_base) VALUES
('Banho', 50.00),
('Tosa', 40.00),
('Vacina', 90.00);

-- Agendamentos
INSERT INTO Agendamento (animal_id, servico_id, data_agendamento, status, valor_final) VALUES
(1, 1, '2025-04-01 10:00:00', 'realizado', 50.00),
(1, 2, '2025-04-03 14:00:00', 'realizado', 40.00),
(2, 1, '2025-04-02 09:00:00', 'cancelado', 0.00),
(3, 3, '2025-04-05 11:30:00', 'pendente', 90.00),
(4, 1, '2025-04-06 08:30:00', 'realizado', 50.00);

-- QUESTÕES
-- Resolver as questões abaixo utilizando comandos SQL
-- 1.	Exibir o nome e a espécie dos animais do cliente João Silva
-- 2.	Exibir os serviços realizados pelos animais 1 e 3
-- 3.	Exibir o nome do animal e a quantidade total de serviços efetuados por cada animal (apenas os serviços realizados)
-- 4.	 Exibir os dados dos agendamentos realizados ou pendentes
-- 5.	 Exibir o nome dos clientes que têm animais com serviços pendentes (consulta aninhada)
-- 6.	 Exibir os dados dos serviços com valor maior que qualquer valor final já pago. (Consulta aninhada) 
-- Obs. Tem serviço com valor final zerado.
select * from servico where valor_base > any(select valor_final from agendamento where valor_final > 0);
-- 7.	Exibir o nome dos animais que já realizaram o serviço mais caro (consulta aninhada)
select nome from animal where id in 
(select animal_id from agendamento where servico_id = (select id from servico where 
valor_base = (select max(valor_base) from servico)) and agendamento.status = 'realizado');
-- 8.	Exibir o nome dos clientes que possuem mais de um animal com agendamento realizado (consulta aninhada)
-- 9.	 Criação da view de histórico de agendamentos com o nome do dono, nome do animal, tipo de serviço, data do agendamento, status e valor final. Exibir o comando para executar a view.
