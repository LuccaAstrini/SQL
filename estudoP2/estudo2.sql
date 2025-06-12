CREATE DATABASE banco_procedures;
USE banco_procedures;

CREATE TABLE correntista (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL UNIQUE,
    cpf VARCHAR(20) NOT NULL,
    dt_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Carga inicial
INSERT INTO correntista VALUES (NULL, 'Valter', '123', NULL);
INSERT INTO correntista VALUES (NULL, 'Pedro', '345', NULL);

/*Mostrar mensagem simples*/
delimiter $$
create procedure Mensagem()
begin
	select "Hello World" as Mensagem;
end;
$$
delimiter ;
call Mensagem;

/*Parâmetro de entrada simples*/
delimiter $$
create procedure Entrada(in op int)
begin 
if op = 0 then
	select "Ola" as mensagem;
else
	select "Erro" as aviso;
end if;
end;
$$
delimiter ;
drop procedure Entrada;
call Entrada(2);

/*Inserir Correntista com validação*/
delimiter $$
create procedure InserirCorrentista(in p_nome varchar(20), in p_cpf varchar(20))
begin
if((p_nome != '') and (p_cpf!='')) then
	insert into correntista(nome, cpf) values(p_nome, p_cpf);
else
	select "Preencha todas as tabelas necessárias" as Aviso;
end if;
end;
$$
delimiter ;
call InserirCorrentista("Lucca", "123.456.789-00");
select * from correntista;

/*Atualizar correntista por ID*/
delimiter $$
create procedure AtualizarCorrentista(in p_id int,in p_nome varchar(20),in p_cpf varchar(20))
begin
if((p_id > 0) and (p_nome != '') and (p_cpf != '')) then
	update correntista set nome = p_nome, cpf = p_cpf
    where id = p_id;
else
	select "Selecione um id válido" as Aviso;
end if;
end;
$$
delimiter ;
drop procedure AtualizarCorrentista;
call AtualizarCorrentista(2, "Pedrocaa", "1256");
select * from correntista;

/*Contar correntistas (OUT)*/
delimiter $$
create procedure Contagem(out qtd int)
begin
	select count(*) into qtd from correntista;
end;
$$
delimiter ;
call Contagem(@todos);
select @todos;

/*Calcular quadrado com OUT*/
delimiter $$
create procedure calculo(in valor int, out quadrado int)
begin
	set quadrado = valor * valor;
end;
$$
delimiter $$
call calculo(5,@total);
select @total;

/*WHILE: string de 1 a 5*/
delimiter $$
create procedure ex_While(in valor int)
begin
declare x int default 1;
declare str varchar(100) default '';
while x<valor do
	set str = concat(str, x, ' ');
    set x = x + 1;
end while;

select str as resultado;
end;
$$
delimiter ;
drop procedure ex_While;
call ex_While(10);

/**/