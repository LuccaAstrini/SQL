create database aula1;
use aula1;

create table empregado(
codigo int primary key,
 nome varchar(20),
 cidade varchar(20),
 salario float(10,2)
);

create table dependentes(
coddep int,
codigo int,
nome varchar(50),
primary key(codigo,coddep),
foreign key(codigo) references empregado(codigo)
);

insert into Empregado  values(1, "Adriana", "São João", 1000.00);
insert into dependentes values(1, 1, "Matheus");
insert into dependentes values(2,1,"Marido");
insert into dependentes values(3,1,"Luana");

insert into Empregado values(2,"Alessandro", "São Paulo", 8000);
insert into dependentes values(4,2,"Lucca");

select nome, cidade from empregado;
select nome, cidade from empregado where salario > 1200;
select empregado.nome, dependentes.nome from empregado, dependentes where empregado.codigo = dependentes.codigo;

select empregado.nome, dependentes.nome from empregado inner join dependentes on empregado.codigo = dependentes.codigo;

select count(codigo) from dependentes;

select count(*) from dependentes, empregado where dependentes.codigo = empregado.codigo and empregado.nome = "Adriana";
select empregado.nome, count(dependentes.codigo) as Membros from empregado, dependentes where dependentes.codigo = empregado.codigo 
group by empregado.nome;