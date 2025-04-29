create database a2;
use a2;

drop database a2;

create table Cliente(codcliente int auto_increment primary key,
nome varchar(20),
datanascimento date,
cpf int);

create table Pedido(codpedido int auto_increment primary key,
datapedido date,
cpf int,
nf int,
valortotal int,
codcliente int,
foreign key (codcliente) references cliente(codcliente));

create table itempedido(codpedido int primary key auto_increment,
codproduto int,
valorunitario int,
quantidade int,
foreign key (codproduto) references produto(codproduto));

create table produto(codproduto int auto_increment primary key,
descricao varchar(20),
preco int,
quantidade int);

insert into cliente values (10, "João", null, 123);
insert into cliente values (11, "Solange", null, 456);
insert into cliente values (12, "Simone", null, 789);

insert into Produto values (1, "princel", 2, 50);
insert into Produto values (2, "apagador", 5, 33);

insert into Pedido(codpedido, datapedido,nf,codcliente) values(1, 20250427,123, 12);

insert into itempedido values (1, 2, 5, 2);
insert into itempedido values (1, 1, 2, 1);


select * from pedido;


drop trigger precototal;
-- criar uma trigger para atualizar o preço total do pedido a cada inserção de um item.
delimiter $$
create trigger precototal
after insert on itempedido
	for each row begin
		update pedido p
			set p.valortotal = coalesce(valortotal,0)+
            (new.valorunitario * new.quantidade)
            where p.codpedido = new.codpedido;
	end;
$$
delimiter ;
