create database empresa;
use empresa;

drop database empresa;

create table departamento(
codD int primary key auto_increment,
nome varchar(20),
total_sal int);

create table funcionario(
codF int primary key auto_increment,
nome varchar(20),
salario int,
codD int,
foreign key funcionario(codD) references departamento(codD));

insert into departamento values(10, "Desenvolvimento", 0);
insert into departamento values(11, "suporte", 0);
insert into departamento values(12, "vendas", 0);

insert into funcionario values(1, "Antonio", 1000, 11);
insert into funcionario values(2, "Pedro", 2300, 10);
insert into funcionario values(3, "Solange", 2300, 10);
insert into funcionario values(4, "Fatima", 1200, 12);
insert into funcionario (codf, nome, codd) values(5,"Lucca", 10);

select * from funcionario;
select * from departamento;

Update funcionario set salario = 60 where codf = 3;
delete from departamento where codd = 10;

delimiter $$
Create trigger Ex1
after insert on Funcionario
for each row
begin
 if new.codD is NOT NULL THEN
		UPDATE Departamento
        Set total_sal = total_sal + NEW.salario
        where codD = new.codD;
        end if;  
	end;
$$
delimiter ;

DELIMITER $$
CREATE TRIGGER Ex2
BEFORE INSERT ON Funcionario
FOR EACH ROW
BEGIN
    IF NEW.salario IS NULL THEN
        SET NEW.salario = 1045;
    END IF;
END;
$$
DELIMITER ;

Delimiter $$
Create Trigger Verefica_salario
before update on funcionario
for each row
begin
	if new.salario > old.salario*1.05  then
		set new.salario = old.salario*1.05;
    end if;
end;
$$
delimiter ;

Delimiter $$
create trigger Excluir_departamento
before delete on departamento
for each row
begin
	delete from funcionario where codd = old.codd;
	end;
$$
delimiter ;

drop trigger Ex3;

