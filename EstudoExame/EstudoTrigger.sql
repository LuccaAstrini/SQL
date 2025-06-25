CREATE DATABASE lojaDB;
USE lojaDB;
drop database lojaDB;
CREATE TABLE CLIENTE (
    codcliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    datanascimento DATE,
    cpf VARCHAR(14)
);

CREATE TABLE PRODUTO (
    codproduto INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100),
    preco DECIMAL(10,2),
    quantidade INT
);

CREATE TABLE PEDIDO (
    codpedido INT AUTO_INCREMENT PRIMARY KEY,
    codcliente INT,
    datapedido DATE,
    nf VARCHAR(20),
    valortotal DECIMAL(10,2),
    FOREIGN KEY (codcliente) REFERENCES CLIENTE(codcliente)
);

CREATE TABLE ITEMPEDIDO (
    codpedido INT,
    codproduto INT,
    valorunitario DECIMAL(10,2),
    quantidade INT,
    PRIMARY KEY (codpedido, codproduto),
    FOREIGN KEY (codpedido) REFERENCES PEDIDO(codpedido),
    FOREIGN KEY (codproduto) REFERENCES PRODUTO(codproduto)
);

INSERT INTO CLIENTE (nome, datanascimento, cpf) VALUES
('João Silva', '1985-04-12', '123.456.789-00'),
('Maria Oliveira', '1990-07-23', '987.654.321-00');

INSERT INTO PRODUTO (descricao, preco, quantidade) VALUES
('Notebook Dell', 3500.00, 10),
('Mouse Logitech', 150.00, 50);

INSERT INTO PEDIDO (codcliente, datapedido, nf, valortotal) VALUES
(1, '2023-10-01', 'NF001', 3650.00),
(2, '2023-10-02', 'NF002', 150.00);

INSERT INTO ITEMPEDIDO (codpedido, codproduto, valorunitario, quantidade) VALUES
(1, 2, 3500.00, 1),
(2, 1, 150.00, 1),
(1, 1, 150.00, 1);


/*1) Criar uma TRIGGER para atualizar o preço total do pedido a cada inserção de um item.*/
delimiter $$
create trigger AtualizarPreco 
after insert on Itempedido
for each row
begin
	update Pedido p set p.valortotal = valortotal+
    (new.valorunitario * new.quantidade)
    where p.codpedido = new.codpedido;
end;
$$
delimiter ;
select * from pedido;
drop trigger AtualizarPreco;

/*2) Crie um TRIGGER para NÃO deixar valores negativos serem INSERIDOS em ITEMPEDIDO, o valor
mínimo é 0;*/
delimiter $$
create trigger Negarvalor
before insert on ItemPedido
for each row
begin
		if new.valorunitario < 0 then
        signal sqlstate "45000" set message_text = "Valor menor que 0 não é permitido";
        end if;
end;
$$
delimiter ;
INSERT INTO ITEMPEDIDO (codpedido, codproduto, valorunitario, quantidade)
VALUES (10, 1, 50.00, 2);
select * from itempedido;

drop trigger Negarvalor;
/*3) Criar uma trigger que faça a seguinte função: No instante que for excluído um pedido da tabela
Pedido, também sejam excluídos os itens deste pedido na tabela Item_Pedido.*/
delimiter $$
create trigger Apagartabela
before delete on Pedido
for each row
	delete from itemPedido where codpedido = old.codpedido;
$$
delimiter ;
drop trigger Apagartabela;
/*4) Crie um TRIGGER para baixar o estoque de um PRODUTO quando ele for vendido;*/
delimiter $$
create trigger BaixarEstoque
after insert on itempedido
for each row
begin
	update produto 
	set quantidade = quantidade - new.quantidade
	where codproduto = new.codproduto;
end;
$$
delimiter ;
select * from produto;