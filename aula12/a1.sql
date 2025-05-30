create database Procedural;
use Procedural;

create table correntista(
id int auto_increment primary key,
nome varchar(50) not null unique,
cpf varchar(20) not null,
dt_cadastro timestamp default current_timestamp);

/* Exercicio 1. criar uma Procedure que permita inserir os dados na tabela Correntista (Nome, CPF), exibir uma mensagem caso os dados
não sejam fornecidos*/
delimiter $$
create procedure InserirCorrentista (
    in p_Nome varchar(100),
    in p_CPF varchar(14))
BEGIN
	if((p_nome!="")&&(p_cpf!="")) then
		insert into correntista(nome,cpf) values(p_nome, p_cpf);
	else
		select 'nome e cpf devem ser fornecidos para o cadastro!' as Msg;
	end if;
end;
END $$
delimiter ;

call InserirCorrentista("Lucca Astrini", "466.804.808-92");
call InserirCorrentista("","");
select * from Correntista;

/*Exercicio 2. Criar uma Procedure que permita alterar os dados de 1 Correntista(nome e cpf)*/
DELIMITER $$
create procedure alterarCorrentista (
    in p_id int,
    in p_nome varchar(100),
    in p_cpf varchar(20))
begin
	if((p_id > 0) && (p_cpf!=''))then
		update correntista set nome = p_nome, cpf = p_cpf 
		where id = p_id;
    else
		select "Os novos Nome e CPF devem ser informados!" as Msg;
        end if;
end;  
$$
DELIMITER ;

drop procedure alterarCorrentista;

call alterarCorrentista (2,"GoKUUUUUUUUUUUUUUU OLhas vieeeenn", "495.748.258-69");
select * from correntista;

/*Exercicio 3.Criar uma procedure para Cotar a quantidade de registros da tabela Correntista, esta procedure
deverá retornar um valor do tipo inteiro contendo a quantidade de correntistas.*/
delimiter $$
create procedure contCorrentista(out qtd int)
begin
	select count(*) into qtd from correntista;
end;
$$
delimiter ;

call contCorrentista(@total);
select @total;

/* Exercicio 4. Criar uma Procedure que receba um valor por parâmetro, calcule o quadrado desse valor e retorne o valor ao quadrado*/
delimiter $$
create procedure Quadrado(num int, out quadrado int)
begin
	select num * num as total;
end;
$$
delimiter ;
drop procedure Quadrado;
call quadrado(5, @valor);
select @valor;


/*Teste*/
delimiter $$
create procedure Ola()
begin
select "Hello World" As Mensagem;
end
$$
delimiter ;

call Ola();

Delimiter $$
create procedure msg1 (in opcao integer)
begin
	if opcao = 0 then
		select "Ola";
		end if;
    end
$$
delimiter ;

call msg1(0);