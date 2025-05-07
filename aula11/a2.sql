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

create table produto(codproduto int auto_increment primary key,
descricao varchar(20),
preco int,
quantidade int);

create table itempedido(codpedido int primary key auto_increment,
codproduto int,
valorunitario int,
quantidade int,
foreign key (codproduto) references produto(codproduto));

create table Auditoria(
id int auto_increment primary key,
codProduto int not null,
estoque_artigo int not null,
estoque_novo int not null,
data_alteracao timestamp default current_timestamp,
foreign key (codproduto) references produto(codproduto));

insert into cliente values (10, "João", null, 123);
insert into cliente values (11, "Solange", null, 456);
insert into cliente values (12, "Simone", null, 789);

insert into Produto values (1, "princel", 2, 50);
insert into Produto values (2, "apagador", 5, 33);
insert into Produto values (3, "Urubu do pix", -55, 50);

select * from produto;

insert into Pedido(codpedido, datapedido,nf,codcliente) values(1, 20250427,123, 12);

insert into itempedido values (1, 2, 5, 2);
insert into itempedido values (4, 3, 2, 10);
insert into itempedido values (2, 1, 2, 1);
insert into itempedido values (3, 3, -5, 3);
insert into itempedido values (1, 2, 25, 23);
insert into itempedido values (1, 2, 10, 11);

select * from pedido;

delete from pedido where codpedido = 1;

select * from itempedido;

select * from produto;


drop trigger precototal;
-- 1. criar uma trigger para atualizar o preço total do pedido a cada inserção de um item.
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

-- 2. Crie um TRIGGER para NÃO deixar valores negativos serem INSERIDOS em ITEMPEDIDO, o valor
-- mínimo é "0";
delimiter $$
create trigger nega_valor_negativo
before insert on itempedido
	for each row begin
	if new.valorunitario < 0 then
		set new.valorunitario = 0;
		end if;
	end;
$$
delimiter ;
-- 3. Criar uma trigger que faça a seguinte função: No instante que for excluído um pedido da tabela
-- Pedido, também sejam excluídos os itens deste pedido na tabela Item_Pedido.
delimiter $$
create trigger apagar_Pedido_e_itens
before delete on pedido
	for each row begin
	delete from itempedido where codpedido = old.codpedido;
	end;
$$
delimiter ;
-- 4. Crie um TRIGGER para baixar o estoque de um PRODUTO quando ele for vendido;
delimiter $$
create trigger baixar_estoque
after insert on itempedido
for each row begin
    update produto
    set quantidade = quantidade - new.quantidade
    where codproduto = new.codproduto;
end;
$$
delimiter ;

-- 5. Criar uma trigger para impedir a inserção de itens com a quantidade 
-- maior que o estoque disponivel
drop trigger impedir_insert;
delimiter $$
create trigger impedir_insert
before insert on itempedido
for each row begin
    if new.quantidade > (select quantidade from produto where codproduto = new.codproduto) then
        signal sqlstate '45000'
        set message_text = 'Erro: Quantidade solicitada maior que o estoque disponível.';
    end if;
end;
$$
delimiter ;

-- outra forma de fazer:
delimiter $$
create trigger checkar
before insert on itempedido
for each row begin
    declare estoque int;
    select quantidade into estoque from produto
    where codproduto = new.codproduto;
    if new.quantidade > estoque then
    signal sqlstate '45000'
    set message_text = "Estoque insuficiente";
    end if;
end;
$$
delimiter ;

-- 6. Desenvolva uma trigger que registre automaticamente todas as atualizações realizadas no estoque dos produtos
-- Sempre que o estoque de um produto for modificado Auditoria, permitindo acompanhar o histórico de todas as mudanças realizadas
