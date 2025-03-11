create database boletim;
use boletim;
drop database boletim;

create table instituicao(
codigoinst int primary Key auto_increment,
nome varchar(20));

create table Curso(
codigocurso int primary key auto_increment,
descricao varchar(50));

create table Aluno(
ra int primary key,
nome varchar(20),
estatus varchar(10));

create table Professor(
CodProf int primary key auto_increment,
nome varchar(20));

create table Disciplina(
coddisc int auto_increment,
nome varchar(20),
codigocurso int,
foreign key(codigocurso) references curso(codigocurso),
primary key(coddisc,codigocurso));

create table Matricula(
codMatr int auto_increment,
codcurso int,
ra int,
ano int,
semestre int,
foreign key(codcurso) references curso(codigocurso),
foreign key(ra) references aluno(ra),
primary key(codMatr,codcurso,ra));

create table DisciplinaMatr(
idmatr int auto_increment,
coddisc int,
codprof int,
nota float,
falta int,
situacao varchar(10),
foreign key(coddisc) references disciplina(coddisc),
foreign key(codprof) references professor(codprof),
primary key(idmatr,coddisc,codprof));

insert into curso values(null, "Engenharia de Software");
insert into curso values(null, "Administração");

insert into professor values(null, "Adriana");
insert into professor values(null, "Juditi");

insert into instituicao values(229202, "UNIFAE");

insert into aluno values (84892, "Lucca", "Ativo");
insert into aluno values (55281, "Pedro", "Ativo");
insert into aluno values (52145, "João", "Inativo");

insert into disciplina values (null, "Banco de Dados II", 1);
insert into disciplina values (null, "Calculos III", 2);

insert into matricula values(null, 1, 84892, 2025, 5);
insert into matricula values(null, 2, 55281, 2025, 3);
insert into matricula values(null, 1, 52145, 2025, 7);

insert into disciplinamatr values(null, 1, 1, 10, 1, "Aprovado");
insert into disciplinamatr values(null, 1, 2, 5, 1, "Reprovado");
insert into disciplinamatr values(null, 1, 1, 6, 3, "Aprovado");

select aluno.nome from aluno inner join matricula
on aluno.ra = matricula.ra
inner join curso
on curso.codigocurso = matricula.codcurso
where curso.descricao = "Engenharia de Software";

select * from matricula;

select aluno.nome from aluno 
inner join Matricula
on aluno.ra = matricula.ra
inner join curso
on curso.codigocurso = matricula.codcurso
inner join DisciplinaMatr
on DisciplinaMatr.idmatr = matricula.codMatr
inner join disciplina
on disciplina.coddisc = DisciplinaMatr.coddisc
where disciplina.nome = "Bando de dados II";

-- Exibir a quantodade de alunos matriculados na engenharia de software --

select count(aluno.ra) as total from aluno inner join Matricula
on matricula.ra = aluno.ra inner join curso
on curso.codigocurso = matricula.codcurso where curso.descricao = "Engenharia de Software";
