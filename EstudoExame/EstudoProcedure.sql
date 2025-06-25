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


/*1.Criar uma procedure para inserir dados na tabela Disciplina, a procedure deverá receber o nome da disciplina por parâmetro.*/ 
delimiter $$
create procedure InserirDados(in d_nomeDisc varchar(45))
begin
	if(d_nomeDisc != "") then
		insert into Disciplina(nomeDisciplina) values(d_nomeDisc);
	else 
		select "Insira um nome não vazio" as aviso;
	end if;
end;
$$
delimiter ;
call InserirDados("");
select * from disciplina;
/*2.Criar uma procedure para inserir dados na tabela Aluno, a procedure deverá receber o nome do Aluno e cpf do Aluno por parâmetro;*/
delimiter $$
create procedure InserirAluno(in dnomeAluno varchar(30), in dcpfAluno varchar(15))
begin
	if(dnomeAluno !="") and (dcpfAluno != "") then
		
end;
$$
delimiter ;
/*3.Criar uma procedure para inserir dados na tabela Nota, a procedure deverá receber o código do aluno, 
código da disciplina e a nota por parâmetro.*/
delimiter $$

end;
$$
delimiter ;
/*4.Criar uma procedure para listar o nome de todas as disciplinas;*/
delimiter $$

end;
$$
delimiter ;
/*5.Criar uma procedure para contar e retornar a quantidade de disciplinas cadastradas;*/
delimiter $$

end;
$$
delimiter ;
