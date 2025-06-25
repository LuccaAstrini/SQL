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
foreign key(num_ped) references pedido (num_ped),
foreign key(cod_prod) references produto (cod_prod));

INSERT INTO Cliente VALUES 
(1, 'Alberto', 'Rua das Flores, 100', 'São Paulo'),
(2, 'Solange', 'Av. São Pedro, 420', 'São Paulo'),
(3, 'Marcelo', 'Rua Jacob Bitar, 1190', 'Jacareí');
insert into Cliente values (4,"Lucca", "Pedro Cabral, 554", "Aguaí");

SELECT * FROM Cliente;

INSERT INTO Vendedor VALUES 
(200, 'Fernando', 1200),
(210, 'Gabriel', 1400),
(220, 'Carlos', 1200);

SELECT * FROM Vendedor;

INSERT INTO produto VALUES 
(11, 'Bombom', 'un', 1.30),
(12, 'Cereja', 'kg', 45.00),
(13, 'Bolacha', 'pct', 2.90),
(14, 'Pão', 'un', 0.50);

SELECT * FROM Produto;

INSERT INTO pedido VALUES 
(1, '2025-02-10', 2, 220),
(2, '2025-03-11', 1, 210),
(3, '2025-03-22', 2, 200),
(4, '2025-02-15', 3, 220);

SELECT * FROM Pedido;


select * from ItemPedido;
insert into ItemPedido values (1,11,3, null);
insert into ItemPedido values (1,13,1, null);
insert into ItemPedido values(2,14,5, null);
insert into ItemPedido values(3,13,2, null);
insert into ItemPedido values(4,12,10, null);

/*Clientes que possuem pedido*/
select nome_cli from Cliente where cod_cli in (select cod_cli from pedido);
/*Clientes que não possuem pedido*/
select nome_cli from Cliente where cod_cli not in (select cod_cli from pedido);
/*Clientes que possuem pedido com o vendedor Gabriel*/
select nome_cli from Cliente where cod_cli in ( select cod_cli from pedido p
												join Vendedor v on p.cod_vend = v.cod_vend
                                                where nome_vend = 'Gabriel');
/*Exibir o nome do vendedor que possui salário maior do que pelo 
menos 1 vendedor de São João João*/
select nome_vend from Vendedor where salario > any (select salario from Vendedor
													where cidade = "São João");
/*Exibir o nome do vendedor que possui salario maior do que todos 
os vendedores de São João*/
select nome_vend from Vendedor where salario > all (select salario from Vendedor
													where cidade = "São João");
/*Exibir o nome do cliente e a quantidade de pedidos que realizou*/
select nome_cli, (select count(*) from pedido p where p.cod_cli = Cliente.cod_cli) as qtde
 from Cliente;
/* para cada produto, mostrar a quantidade de itens que foram vendidos deste produto */
select desc_prod, (select sum(qtde_ped) from ItemPedido i where i.cod_prod = p.cod_prod) as qtde
from produto p;
/* para cada produto, mostrar a quantidade de itens que 
foram vendidos deste produto, mostrar também a
quantidade de pedidos que comprou cada produto*/
select desc_prod, (select sum(qtde_ped) from ItemPedido i where i.cod_prod = p.cod_prod) 
as qtde,
(select count(*) from ItemPedido i where i.cod_prod = p.cod_prod
) as pedidos
from produto p;


