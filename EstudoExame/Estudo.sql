CREATE DATABASE EstudoJoins;
USE EstudoJoins;

drop database EstudoJoins;

-- Tabela de Clientes
CREATE TABLE Clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    cidade VARCHAR(50)
);

-- Tabela de Pedidos
CREATE TABLE Pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    data_pedido DATE,
    valor DECIMAL(10,2),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id)
);

-- Tabela de Produtos
CREATE TABLE Produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    preco DECIMAL(10,2)
);

-- Tabela de Itens do Pedido
CREATE TABLE ItensPedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT,
    produto_id INT,
    quantidade INT,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id),
    FOREIGN KEY (produto_id) REFERENCES Produtos(id)
);

-- Clientes
INSERT INTO Clientes (nome, cidade) VALUES
('Alice', 'São Paulo'),
('Bruno', 'Rio de Janeiro'),
('Carla', 'Curitiba'),
('Daniel', 'São Paulo');

-- Pedidos
INSERT INTO Pedidos (cliente_id, data_pedido, valor) VALUES
(1, '2024-01-10', 200.00),
(2, '2024-02-15', 350.00),
(1, '2024-03-20', 150.00);

-- Produtos
INSERT INTO Produtos (nome, preco) VALUES
('Notebook', 3000.00),
('Mouse', 50.00),
('Teclado', 100.00),
('Monitor', 900.00);

-- Itens do Pedido
INSERT INTO ItensPedido (pedido_id, produto_id, quantidade) VALUES
(1, 2, 2),
(1, 3, 1),
(2, 1, 1),
(3, 4, 1);

/* INNER JOIN */
/* Exercício 1: Liste o nome dos clientes e a data dos seus pedidos.*/
select nome, data_pedido from Clientes c 
join Pedidos p on c.id = p.cliente_id;

/* Exercício 2: Liste os nomes dos produtos e as quantidades vendidas em cada pedido. */
select nome, quantidade from Produtos p
join ItensPedido ip on p.id = ip.produto_id;

/* CROSS JOIN */
/*Exercício 1: Mostre todas as combinações possíveis entre clientes e produtos.*/
select c.nome as cliente, p.nome as Produto from Clientes c
Cross join Produtos p;


/*LEFT JOIN*/
/*Exercício 1: Liste todos os clientes e seus pedidos (mesmo que não tenham nenhum).*/
select nome, data_pedido from Clientes c
left join Pedidos p on c.id = p.cliente_id;
/*Exercício 2: Mostre todos os pedidos e os itens que os compõem, incluindo pedidos sem itens.*/
SELECT p.id, ip.produto_id, pr.nome
FROM Pedidos p
LEFT JOIN ItensPedido ip ON p.id = ip.pedido_id
left join Produtos pr on ip.produto_id = pr.id;

/*RIGHT JOIN*/
/*Exercício 1: Liste todos os produtos 
e os pedidos nos quais aparecem (mesmo que não tenham sido vendidos ainda).*/
select ip.pedido_id, pr.nome from ItensPedido ip
right join Produtos pr on ip.produto_id = pr.id;

/*Exercício 2: Veja todos os clientes que aparecem na base, 
mesmo que não tenham feito pedidos.*/
select nome, data_pedido from Pedidos p
right join Clientes c on p.cliente_id = c.id;

/*Exemplo UNION	*/
SELECT nome FROM Clientes
UNION
SELECT nome FROM Produtos;

-- Parte 1: todos os clientes com ou sem pedidos
SELECT c.nome, p.id AS pedido_id
FROM Clientes c
LEFT JOIN Pedidos p ON c.id = p.cliente_id
UNION
-- Parte 2: todos os pedidos com ou sem cliente
SELECT c.nome, p.id AS pedido_id
FROM Clientes c
RIGHT JOIN Pedidos p ON c.id = p.cliente_id;


/*ALTER TABLE*/
/*Exercício 1: Adicione uma coluna email na tabela Clientes.*/
alter table Clientes remove email  varchar(30);

/*Exercício 2: Renomeie a coluna valor da tabela Pedidos para total.*/
alter table Pedidos change valor total decimal(10,2);

/*UPDATE TABLE*/
/*Exercício 1: Atualize a cidade de todos os clientes que moram em “São Paulo” para “SP”.*/
Update Clientes set cidade = "SP" where cidade = "São Paulo";
select * from Clientes;
SET SQL_SAFE_UPDATES = 0;

/*Exercício 2: Dê um desconto de 10% em todos os produtos acima de R$500.*/
update Produtos set preco = preco * 0.9 where preco > 500;
select * from Produtos;




