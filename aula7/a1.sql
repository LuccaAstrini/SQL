create database empresa;
use empresa;
drop database empresa;

create table Funcionario(
funcionarioid int primary key,
nomeF varchar(20),
cidade varchar(30),
dataNascimento date,
salario float(10.2),
sexo varchar(1),
supervisor int,
departamentoID int,
foreign key (departamentoID) references departamento(departamentoid),
foreign key (supervisor) references funcionario(funcionarioid));

create table departamento(
departamentoid int primary key,
nomeD varchar(20),
gerente int);

alter table departamento add foreign key(gerente) references funcionario(funcionarioid);

select * from departamento;
insert into departamento values(1, 'RH', 1);
insert into departamento values(2, 'Financeiro', 2);
insert into departamento values(3, 'Compras', 3);
insert into departamento values(4, 'Vendas', 4);

select * from funcionario;
insert into Funcionario values(1, 'José da Silva', 'Campinas', '1980-01-12', 3500.00, 'M', NULL, 1);
insert into Funcionario values(2, 'Maria Oliveira', 'São Carlos', '1995-01-22', 4500.00, 'F', NULL, 2);
insert into Funcionario values(3, 'Rosana Pereira', 'Campinas', '1993-03-15', 1500.00, 'F', NULL, 3);
insert into Funcionario values(4, 'Carla Santana', 'Campinas', '1990-10-13', 2500.00, 'F', 3, 3);
insert into Funcionario values(5, 'Joao Serrana', 'Aguai', '2000-11-23', 2750.00, 'M', 3, 3);
insert into Funcionario values(6, 'Paulo Cardoso', 'São João da Boa Vista', '1993-11-11', 1250.00, 'M', 1, 1);
insert into Funcionario values(7, 'Sebastiana Pontes', 'Vargem Grande do Sul', '1987-11-14', 1750.00, 'F', 1, 1);
insert into Funcionario values(8, 'Lauro Muniz', 'Vargem Grande do Sul', '1989-12-01', 1950.00, 'F', 2, 2);
insert into Funcionario values(9, 'Guidofredo Santos', 'São Carlos', '2002-07-21', 2950.00, 'M', 2, 2);
insert into Funcionario values(10, 'Gustavo Pedreiro', 'Vargem', '2000-07-21', 1550.00, 'M', 2, null);

update funcionario set departamentoid = 3 where funcionarioid = 9;
#Comando JOIN
#1. Listar os nomes dos departamentos e dos seus gerentes.
select d.nomeD as Departamento, f.nomeF as Gerente 
from departamento d join funcionario f 
on d.gerente = f.funcionarioid;
#2. Mostrar os nomes dos funcionários e os nomes dos departamentos que eles trabalham.
select f.nomef as funcionario, d.nomed as Departamento 
from Funcionario f join departamento d 
on d.departamentoid = f.departamentoid;

#outro método para fazer o exercício
#Natural join só funciona quando o relacionamento tem o mesmo nome EX = departamentoid
select f.nomef as funcionario, nomed as Departamen
from Funcionario f natural join departamento;

#3. Mostrar o nome dos funcionários e o nome de seus supervisores.
select f.nomeF as Funcionario, s.nomeF as Supervisor 
from funcionario f left join funcionario s 
on f.supervisor = s.funcionarioid;

#Subconsultas
#1. Qual o nome do funcionário que possui o maior salário?
select f.nomef as funcionario, salario as salario from funcionario f
where f.salario = (select max(salario) from funcionario);

#Outro método de se fazer:
select nomeF from funcionario where salario = (select max(salario) from funcionario);
#2. Listar o nome dos funcionários que não são gerentes.
select nomef from funcionario where funcionarioid 
not in (select gerente from departamento);
#3. Listar o nome dos funcionários que não trabalham em nenhum departamento.
select nomef as funcionario from funcionario f
where not exists(select * from departamento d 
where f.departamentoid = d.departamentoid);
#4. Listar o nome dos departamentos que não possuem funcionários.
select nomed as departamento from departamento d where departamentoid not in
(select f.departamentoid from funcionario f where f.departamentoid = d.departamentoid);
#outro método de finalização
select nomed from departamento d
where not exists(select * from funcionario f where f.departamentoid = d.departamentoid);
#5. Listar o nome dos departamentos que possuem funcionários.
select d.nomed from departamento d where d.departamentoid in
(select departamentoid from funcionario);
#outro método de finalização
select nomed from departamento d
where exists(select * from funcionario f where f.departamentoid = d.departamentoid);
#6. Listar os nomes dos funcionários que possuem salário maior do que o salário de todos os funcionários do departamento 1.
select nomef as funcionario from funcionario f
where salario >all(select salario from funcionario where departamentoid = 1);
#Outras consultas
#1. Listar os nomes dos funcionários que não possuem supervisor.
select nomef from funcionario where supervisor is null;
#2. Listar os nomes dos funcionários que trabalham nos departamentos 1 ou 2.
select nomef from funcionario where departamentoid in(1,2);
#3. Listar os nomes dos funcionários que ganham entre 2000.00 e 3000.00.
select nomef from funcionario
where salario between 2000 and 3000;
#4. Listar os nomes dos funcionários que possuem sobrenome ‘Silva’.
select nomef from funcionario where nomef like "%Silva";
#5. Listar a quantidade de funcionários em cada departamento.
select departamentoid as departamento, count(*) as Qtde 
from funcionario group by departamentoid;
#6. Listar para os departamentos com mais de 3 funcionários, o número do departamento e a quantidade de funcionários.
select departamentoid as departamento, count(*) as Qtde 
from funcionario group by departamentoid having count(*) > 3;

select * from funcionario;


