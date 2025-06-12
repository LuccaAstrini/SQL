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
create procedure Entrada(in op)
begin 
if op = 0 then
	select "Ola" as mensagem;
else
	select "Erro" as aviso;
end if;
end;
$$
delimiter ;
call Entrada()