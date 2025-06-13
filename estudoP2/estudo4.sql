create database aula03_06;
use aula03_06;
create table Disciplina(
codDisciplina int AUTO_INCREMENT primary key,
nomeDisciplina varchar(45));
create table aluno(
codAluno int AUTO_INCREMENT primary key,
nomeAluno varchar(45),
cpfAluno varchar(45));
create table Notas(
codNota int AUTO_INCREMENT primary key,
codAluno int,
codDisciplina int,
nota float,
foreign key (codDisciplina) references Disciplina (codDisciplina),
foreign key (codAluno) references Aluno (codAluno));

/*1. Criar uma procedure para inserir dados na tabela Disciplina, a procedure
deverá receber o nome da disciplina por parâmetro.*/
delimiter ||
create procedure Inserir(in p_nomeDisciplina varchar(45))
begin
if(p_nomeDisciplina != "") then
	insert into Disciplina (nomeDisciplina) values (p_nomeDisciplina);
end if;
end;
||
delimiter ;
call Inserir("Ed. Fisica");
select * from disciplina;

/*2. Criar uma procedure para inserir dados na tabela Aluno, a procedure
deverá receber o nome do Aluno e cpf do Aluno por parâmetro;*/
delimiter $$
create procedure InserirAluno(in p_nomeAluno varchar(20), in p_cpfAluno varchar(45))
begin
if((p_nomeAluno != '') and (p_cpfAluno != '')) then
	insert into Aluno(nomeAluno, cpfAluno) values (p_nomeAluno, p_cpfAluno);
end if;
end;
$$
delimiter ;
call InserirAluno("Lucca", "12345678900");
select * from aluno;

create user lucca@localhost identified by "123";
grant select, update on aula03_06. * to lucca@localhost;
delete from mysql.user where user = "lucca" and host = "localhost";