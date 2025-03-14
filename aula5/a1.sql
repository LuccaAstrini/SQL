drop database Empresa;
create database Empresa;
use Empresa;

create table Cliente(
cod_cli int primary key,
nome_cli varchar(40),
endereco varchar(40),
cidade varchar(40));

create table Vendedor(
cod_vend int primary key,
nome_vend varchar(40),
salario decimal(9,2));

create table produto(
cod_prod int primary key,
desc_prod varchar(30),
unid_prod varchar(3),
val_unit decimal(9,2));

create table pedido(
num_ped int auto_increment primary key,
data_entr date,
cod_cli int,
cod_vend int,
foreign key (cod_cli) references Cliente (cod_cli),
foreign key (cod_vend) references Vendedor (cod_vend));

create table ItemPedido(
num_ped int,
cod_prod int,
qtde_ped int,
preco numeric(9,2),
primary key(num_ped, cod_prod),
foreign key(num_ped) references Pedido (num_ped),
foreign key(cod_prod) references Produto (cod_prod));

select * from Cliente;
insert into Cliente values (1, "Alberto", "Rua das Flores, 100", "São Paulo");
insert into Cliente values (2, "Solange", "Av. São Pedro, 420", "São Paulo");
insert into Cliente values (3, "Marcelo", "Rua Jacob Bitar, 1190", "Jacareí");

select * from vendedor;
insert into Vendedor values(200, "Fernando", 1200);
insert into Vendedor values(210, "Gabriel",1400);
insert into Vendedor values(220, "Carlos", 1200);

select * from Produto;
insert into Produto values(11, "Bombom","un", 1.30);
insert into Produto values(12, "Cereja","kg", 45);
insert into Produto values(13, "Bolacha", "pct", 2.90);
insert into Produto values(14, "Pão", "un", 0.50);

select * from pedido;
insert into Pedido values (null, "2025-02-10",2,220);  
insert into Pedido values (null, "2025-03-11",1,210);  
insert into Pedido values (null, "2025-03-12",2,200);
insert into Pedido values (null, "2025-02-15",3, 220);

select * from itemPedido;
insert into itemPedido values (2,11,3, null);
insert into itemPedido values (2,13,1, null);
insert into itemPedido values(3,14,5, null); 
insert into itemPedido values(4,13,2, null);

/*1.	Criar uma view para exibir a quantidade de pedidos do cliente Alberto.*/
create view vw_quantidade as select Cliente.nome_cli, count(num_ped) from cliente join pedido 
on cliente.cod_cli = pedido.cod_cli where nome_cli = "Alberto";

select * from vw_quantidade;

/* 2.	Criar uma view para exibir o número do pedido, a descrição dos produtos e o nome do vendedor de todos os pedidos.*/
create view vw_pednum as select pedido.num_ped, desc_prod, nome_vend from pedido
join vendedor on vendedor.cod_vend = pedido.cod_vend
join itempedido on pedido.num_ped = itempedido.num_ped
join produto on produto.cod_prod = itempedido.cod_prod;

select * from vw_pednum;

/* 3.	Criar uma view para exibir o nome dos vendedores que possuem pedidos a serem entregues */
create view vw_nomped as select nome_vend from vendedor, pedido where vendedor.cod_vend = pedido.cod_vend and data_entr > now();

select * from vw_nomped;
drop view vw_nomped;
/* 4.	Criar uma view para encontrar a quantidade de pedidos agrupados por cidade de origem.*/
create view vw_qtdcid as select count(*), cidade from itempedido, pedido, cliente 
where pedido.num_ped = itempedido.num_ped and cliente.cod_cli = pedido.cod_cli group by cidade;

select * from vw_qtdcid;
drop view vw_qtdcid;
/* 5.	Criar uma view para encontrar o nome dos clientes que possuem pelo menos 7 pedidos */
create view vw_cliped as select nome_cli from cliente join pedido on cliente.cod_cli = pedido.cod_cli
join itempedido on itempedido.num_ped = pedido.num_ped where itempedido.qtde_ped >= 7;

select * from vw_cliped;
drop view vw_cliped;
/* 6.	Criar uma view Encontrar o nome dos clientes que possuem pedidos com mais de 3 itens vendidos.
Obs. Eliminar os clientes duplicados. */
create view vw_vendqtd as select distinct nome_cli from cliente
join pedido on pedido.cod_cli = cliente.cod_cli
join itempedido on itempedido.num_ped = pedido.num_ped 
join produto on produto.cod_prod = itempedido.cod_prod group by pedido.num_ped having count(produto.cod_prod) > 3;

select * from vw_vendqtd;
drop view vw_vendqtd;