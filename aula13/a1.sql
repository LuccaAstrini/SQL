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
delimiter $$
create procedure InsertDados(d_nome varchar(30))
begin
	if(d_nome!="") then
		insert into disciplina(nomeDisciplina) values(d_nome);
	else
		select 'Nome deve ser fornecido para ser adicionado na tabela!' as Aviso;
	end if;
end;
$$
delimiter ;
drop procedure InsertDados;
call InsertDados("Banco de Dados I");
call InsertDados("Banco de Dados II");
select * from Disciplina;

/*2. Criar uma procedure para inserir dados na tabela Aluno, a procedure
deverá receber o nome do Aluno e cpf do Aluno por parâmetro;*/
delimiter $$
create procedure InsertAluno(a_nome varchar(20), a_cpf varchar(20))
begin
	if((a_nome!="") and (a_cpf!="")) then
		insert into aluno (nomeAluno, cpfAluno) values(a_nome, a_cpf);
	else
		select "Nome e CPF não foram informados corretamente para ser adicionado!" as Aviso;
	end if;
end;
$$
delimiter ;
drop procedure InsertAluno;
call InsertAluno("Lucca Astrini", "466.804.808-92");
call InsertAluno("Gustavo Counti", "32215685235");
select * from aluno;

/*3. Criar uma procedure para inserir dados na tabela Nota, a procedure
deverá receber o código do aluno, código da disciplina e a nota por
parâmetro.*/
delimiter $$
create procedure InserirNota(n_aluno int, n_disciplina int, n_nota float)
begin
    if ((n_aluno > 0) and (n_disciplina > 0) and (n_nota >= 0)) then
        insert into Notas (codAluno, codDisciplina, nota) 
        values (n_aluno, n_disciplina, n_nota);
    else
        select "Parâmetros inválidos para inserir a nota!" as Aviso;
    end if;
end;
$$
delimiter ;
drop procedure InserirNota;
call InserirNota(1,2, 2.5);
call InserirNota(2,2, 5.2);
select * from notas;

/*4. Criar uma procedure para listar o nome de todas as disciplinas;*/
delimiter $$
create procedure Ex4()
begin
	select nomeDisciplina from disciplina;
end;
$$
delimiter ;
call ex4();

/*5. Criar uma procedure para contar e retornar a quantidade de disciplinas
cadastradas;*/
delimiter $$


$$
delimiter ;