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

select * from vendedor;

create table produto(
cod_prod int primary key,
desc_prod varchar(30),
unid_prod varchar(3),
val_unit decimal(9,2));

create table pedido(
num_ped int primary key,
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

insert into Cliente values (1, "Alberto", "Rua das Flores, 100", "São Paulo");
insert into Cliente values (2, "Solange", "Av. São Pedro, 420", "São Paulo");
insert into Cliente values (3, "Marcelo", "Rua Jacob Bitar, 1190", "Jacareí");
insert into Cliente values (4, "Lucca", "Rua Cajaiba, 389", "São Paulo");

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
insert into Pedido values (1, "2025-02-10",2,220);  
insert into Pedido values (2, "2025-03-11",1,210);  
insert into Pedido values (3, "2025-03-22",2,200);
insert into Pedido values (4, "2025-02-15",3, 220);

select * from itemPedido;
insert into itemPedido values (1,11,3, null);
insert into itemPedido values (1,13,1, null);
insert into itemPedido values(2,14,5, null); 
insert into itemPedido values(3,13,2, null); 
insert into itemPedido values(4,12,10, null); 

/*in, not in, >some
>some(<some) = maior doque pelo menos uma
>all = maior doque todos*/

/*1-Clientes que possuem pedido*/
select c.nome_cli as nome_cliente from cliente c where cod_cli in (select p.cod_cli from pedido p); 
/*2-Clientes que não possuem pedido*/
select nome_cli from cliente where cod_cli not in (select cod_cli from pedido);
/*3-Clientes que possuem pedido com o vendedor Gabriel*/
select c.nome_cli from cliente c, pedido p, vendedor v 
where c.cod_cli = p.cod_cli and p.cod_vend = v.cod_vend and v.nome_vend = "Gabriel";
#corrigido:
select nome_cli from cliente where cod_cli in (select cod_cli from pedido, vendedor 
where pedido.cod_vend = vendedor.cod_vend and vendedor.nome_vend = "Gabriel");
#forma 2:
select nome_cli from cliente where cod_cli in (select cod_cli from pedido where cod_vend 
in(select cod_vend from vendedor where nome_vend = "Gabriel"));
/*4-Exibir o nome do vendedor que possui salário maior do que pelo menos 1 vendedor de São João"*/
select v.nome_vend as nome_vendedor from vendedor v where v.salario >some 
(select v.salario from vendedor v where v.cidade = 'São João');

alter table vendedor add cidade varchar(20);
UPDATE vendedor SET cidade = 'São João' WHERE cod_vend = 220;
UPDATE vendedor SET cidade = 'São João' WHERE cod_vend = 210;
UPDATE vendedor SET cidade = 'São Paulo' WHERE cod_vend = 200;
/*5-Exibir o nome do vendedor que possui salario maior do que todos os vendedores de São João"*/
select v.nome_vend as nome_vendedor from vendedor v where v.salario >all 
(select v.salario from vendedor v where v.cidade = 'São João');

UPDATE vendedor SET salario = 2000 WHERE cod_vend = 200;
/*6-Exibir o nome do cliente e a quantidade de pedidos que realizou*/
select c.nome_cli,(select count(num_ped) from pedido p where c.cod_cli = p.cod_cli) as qtde_pedidos from cliente c;

/* 7-para cada produto, mostrar a quantidade de itens que foram vendidos deste produto */
select desc_prod,(select sum(qtde_ped) from itempedido ip where ip.cod_prod = po.cod_prod) as qtde_produto from produto po;

/* 8-para cada produto, mostrar a quantidade de itens que foram vendidos deste produto, 
mostrar também a quantidade de pedidos que comprou cada produto*/
select po.desc_prod,(select sum(ip.qtde_ped) from itempedido ip where ip.cod_prod = po.cod_prod) as qtde_produto,
(select count(num_ped) from itempedido ip where ip.cod_prod = po.cod_prod) as qtde_pedidos from produto po;
