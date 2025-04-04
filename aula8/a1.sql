Drop database Empresa01_04;
create database Empresa01_04;
use Empresa01_04;

create table Cliente(
codcliente int primary key,
nome varchar(40),
endereco varchar(40),
cidade varchar(40));

create table produto(
codProduto int primary key,
nome varchar(30),
preco decimal(9,2));

create table pedido(
codPedido int primary key,
data date,
codCliente int,
foreign key (codCliente) references Cliente (codCliente));

create table Item(
codPedido int,
codProduto int,
qtde int,
preco numeric(9,2),
primary key(codPedido, codProduto),
foreign key(codPedido) references Pedido (codPedido),
foreign key(codProduto) references Produto (codProduto));

select * from Cliente;
insert into Cliente values (1, "Alberto", "Rua das Flores, 100", "São Paulo");
insert into Cliente values (2, "Solange", "Av. São Pedro, 420", "São Paulo");
insert into Cliente values (3, "Marcelo", "Rua Jacob Bitar, 1190", "Jacareí");
insert into Cliente values (4, "Sérgio", "Rua João Junqueira, 450", "São João");
insert into Cliente values (5, "Wanderléia", "Rua Mariana Menezes, 21", "São João");

select * from Produto;
insert into Produto values(11, "Teclado", 42);
insert into Produto values(12, "Mouse", 29.33);
insert into Produto values(13, "Notebook",2779);
insert into Produto values(14, "Carregador de celular", 59);

select * from pedido;
insert into Pedido values (1,"2025-02-15",2);  
insert into Pedido values (2,"2025-02-27",1);  
insert into Pedido values (3, "2025-03-17",2);
insert into Pedido values (4, "2025-03-28",3);
insert into Pedido values (5, "2025-03-28",4);
insert into Pedido values (6, "2025-03-28",5);
insert into Pedido values (7, "2025-04-01",4);


select * from item;
insert into item values (1,11,3, 42);
insert into item values (1,13,1, 2600);
insert into item values (2,14,5, 59);
insert into item values(3,13,2, 2779);
insert into item values(4,13,1, 2779);
insert into item values(5,13,1, 2779);
insert into item values(5,12,2, 28);
insert into item values(6,13,1, 2779);
insert into item values(7,14,2, 59);

-- 1 Listar os nomes dos cliente cujo sobrenome seja 'Silva'
select nome from cliente where nome like '%Silva';

-- 2 Listar os nomes de todos os produtos ordenados pelo nome
select nome from produto order by nome;

-- 3 Listar o código do pedido, a data e o valor total do pedido
select p.codPedido as Codigo, p.data, sum(qtde * preco) as total from pedido p, item i 
where p.codPedido = i.codPedido group by p.codpedido;

-- 4 Listar o código do pedido, o nome do cliente, a data e o valor total do pedido
select p.codPedido as Codigo, c.nome, data,sum(qtde * preco) as total from pedido p, item i, cliente c 
where p.codPedido = i.codPedido and c.codcliente = p.codcliente group by p.codpedido;

-- Consultas Aninhadas
-- 5 Listar o nome do cliente e o total de todos os pedidos de cada cliente
select nome from cliente c where 
(select count(p.codpedido) as total from pedido p where p.codcliente = c.codcliente) group by p.codpedido;

-- 6 Listar o nome do produto mais caro
select nome from produto p where preco >all(select preco from produto where produto.codproduto <> p.codproduto);

-- outro método de fazer
select nome from produto where preco = (select max(preco) from produto);

-- 7 Listar os nomes dos clientes que possuem dois ou mais pedidos 
select nome from cliente where codcliente in
(select codcliente from pedido group by codcliente having count(codpedido) >= 2);

-- outra método de fazer
select nome from cliente where
(select count(*) from pedido where pedido.codCliente = cliente.codcliente)>=2;

-- 8 Listar os nomes dos clientes que fizeram pedidos
select nome from cliente where codcliente in(select codcliente from pedido);

-- outro método
select nome from cliente where exists(select * from pedidox
where pedido.codCliente = cliente.codCliente);


-- 9 Listar os nomes dos clientes que não fizeram pedidos
select nome from cliente where codcliente not in(select codcliente from pedido);

insert into cliente values(6,"Lucca","Rua Mario Beni,41", "Casa Branca");
select * from cliente;

-- 10 Listar os nomes dos produtos que Sérgio e Wanderléia compraram
select (select nome from cliente where p.codcliente = codcliente) as nome, 
(select nome from produto where codproduto = i.codproduto) as produto from pedido p, item i
where codcliente in (select codcliente from cliente where nome in("Sérgio", "Wanderléia")) and i.codpedido = p.codpedido;

-- 11 Listar os nomes dos produtos comprados por Sérgio e Wanderléia
SELECT 
(SELECT nome FROM cliente WHERE p.codCliente = codCliente) AS nome, 
(SELECT nome FROM produto WHERE codProduto = i.codProduto) AS produto 
FROM pedido p, item i
WHERE p.codCliente IN (SELECT codCliente FROM cliente WHERE nome IN ("Sérgio", "Wanderléia"))
AND i.codPedido = p.codPedido;

-- 12 Listar os nomes dos produtos comprados por Sérgio e não por Wanderléia	
SELECT 
(SELECT nome FROM cliente WHERE p.codCliente = codCliente) AS nome, 
(SELECT nome FROM produto WHERE codProduto = i.codProduto) AS produto 
FROM pedido p, item i
WHERE p.codCliente = (SELECT codCliente FROM cliente WHERE nome = "Sérgio")
AND i.codPedido = p.codPedido
AND p.codCliente NOT IN (SELECT codCliente FROM cliente WHERE nome = "Wanderléia");
	 

-- 13 Listar os nomes dos produtos comprados por Wanderléia e não por Sérgio
SELECT 
(SELECT nome FROM cliente WHERE p.codCliente = codCliente) AS nome, 
(SELECT nome FROM produto WHERE codProduto = i.codProduto) AS produto 
FROM pedido p, item i
WHERE p.codCliente = (SELECT codCliente FROM cliente WHERE nome = "Wanderléia")
AND i.codPedido = p.codPedido
AND p.codCliente NOT IN (SELECT codCliente FROM cliente WHERE nome = "Sérgio");


-- 14 Listar os nomes dos produtos que têm preço acima dos preços dos prod. comprados por Wanderléia
SELECT nome
FROM produto
WHERE preco > all (select preco FROM Item WHERE codPedido IN 
(select codPedido FROM pedido WHERE codCliente = (select codCliente from Cliente WHERE nome = "Wanderléia")));
               
-- 15 Listar os nomes dos produtos que têm preço acima de algum prod. comprado por Wanderléia
SELECT nome
FROM produto
WHERE preco > some (select preco FROM Item WHERE codPedido IN 
(select codPedido FROM pedido WHERE codCliente = (select codCliente from Cliente WHERE nome = "Wanderléia")));
