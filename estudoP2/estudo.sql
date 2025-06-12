CREATE DATABASE loja_virtual;
USE loja_virtual;

-- Tabela de usuários
CREATE TABLE Usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50),
    email VARCHAR(100),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de produtos
CREATE TABLE Produto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50),
    preco DECIMAL(10,2),
    estoque INT
);

-- Tabela de compras
CREATE TABLE Compra (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    data_compra TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id)
);

-- Itens da compra
CREATE TABLE ItemCompra (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_compra INT,
    id_produto INT,
    quantidade INT,
    preco_unitario DECIMAL(10,2),
    FOREIGN KEY (id_compra) REFERENCES Compra(id),
    FOREIGN KEY (id_produto) REFERENCES Produto(id)
);

-- Auditoria de estoque
CREATE TABLE AuditoriaEstoque (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT,
    estoque_antigo INT,
    estoque_novo INT,
    data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_produto) REFERENCES Produto(id)
);

INSERT INTO Usuario (nome, email) VALUES 
('Ana Clara', 'ana@gmail.com'),
('Bruno Lima', 'bruno@gmail.com');

INSERT INTO Produto (nome, preco, estoque) VALUES
('Notebook', 3000.00, 10),
('Mouse Gamer', 120.00, 25),
('Teclado Mecânico', 250.00, 15);

/*Ex. 1: Atualizar valor_total da compra automaticamente ao inserir um item*/
Delimiter $$
create trigger atualizar_compra
after insert on ItemCompra
for each row
begin
	update Compra
    set valor_total = coalesce(valor_total, 0) + (new.preco_unitario * new.quantidade)
    where id = new.id_compra;
end;
$$
delimiter ;

SELECT * FROM Compra WHERE id = 1;
INSERT INTO Compra (id_usuario) VALUES (1);
INSERT INTO ItemCompra (id_compra, id_produto, quantidade, preco_unitario)
VALUES (1, 1, 2, 3000.00); 

/*Ex. 2: Impedir venda com quantidade maior que o estoque*/
delimiter $$
create trigger Impedir_venda
before insert on ItemCompra
for each row
begin 
	declare estoqueA int;
    select estoque into estoqueA from Produto where id = new.id_produto;
    if new.quantidade > estoqueA then
        set new.quantidade = null;
	end if;	
end ;
$$
delimiter ;
drop trigger Impedir_venda;
ALTER TABLE ItemCompra MODIFY quantidade INT NOT NULL;

-- 1. Veja o estoque atual do produto 1
SELECT * FROM Produto WHERE id = 1;
select * from ItemCompra;

-- 2. Tente forçar um item com quantidade maior que o estoque
INSERT INTO ItemCompra (id_compra, id_produto, quantidade, preco_unitario)
VALUES (1, 1, 160, 3000.00);

/*3: Baixar o estoque após a venda*/
delimiter $$
create trigger Baixar_estoque
after insert on ItemCompra
for each row
begin
	update Produto
    set estoque = estoque - new.quantidade
    where id = new.id_produto;
end;
$$
delimiter ;

INSERT INTO ItemCompra (id_compra, id_produto, quantidade, preco_unitario)
VALUES (1, 2, 5, 3000.00);
select * from Produto;

/*EXERCÍCIO 1 – PROCEDURE: Inserir nova compra com item manualmente*/
delimiter $$
create procedure InserirCompra(in p_id_compra int, 
in p_id_produto int, in p_quantidade int, in p_preco_unitario Decimal(10,2))
begin
	insert into ItemCompra (id_compra, id_produto, quantidade, preco_unitario)
		values(p_id_compra, p_id_produto, p_quantidade, p_preco_unitario);
end;
$$
delimiter ;
drop procedure InserirCompra;
CALL InserirCompra(2, 1, 2, 3000.00);
select * from ItemCompra;

/*PROCEDURE: Exibir todos os itens de uma compra*/
delimiter $$
create procedure ExibirItens(in p_id_compra int)
begin
	select p.nome as nome, ic.quantidade, ic.preco_unitario as preco,
    (ic.quantidade * ic.preco_unitario) as total
    from ItemCompra ic 
    join Produto p on p.id = ic.id_produto
    WHERE ic.id_compra = p_id_compra;
end;
$$
delimiter ;
drop procedure ExibirItens;
call ExibirItens(1);

/*EXERCÍCIO 4 – PROCEDURE: Consultar todas as compras feitas por um usuário*/
delimiter $$
create procedure ConsultaCompra(in p_id_usuario int)
begin
	select id_compra, c.data_compra, c.valor_total from Compra c 
    where c.id_usuario = p_id_usuario;
end;
$$
delimiter ;
drop procedure ConsultaCompra;
call ConsultaCompra(1);