create database views;
use views;

create table Funcionario(
funcionarioid int primary key auto_increment,
nomeF varchar(20),
sexo varchar(1),
salario int,
departamentoid int,
foreign key(departamentoid) references departamento(departamentoid));

create table departamento(
departamentoid int primary key auto_increment,
nomeD varchar(20));

insert into departamento values (null, 'Eng.Sofware');
insert into departamento values (null, 'Medicina');
insert into departamento values (null, 'Odontologia');

insert into Funcionario values(null, "Lucca", "M", 1200, 1);
insert into Funcionario values(null, "Gustavo", "M", 10000, 1);
insert into Funcionario values(null, "Eduarda", "F", 2400, 1);
insert into Funcionario values(null, "Luana", "F", 30000, 2);
insert into Funcionario values(null, "João", "M", 1200, 3);

create view vw_Func as select nomeF, nomeD from Funcionario inner join Departamento
on Funcionario.departamentoid = departamento.departamentoid;

select * from vw_Func;

create view vw_funZ(nomeFunc, nomeDepto) as select nomef, nomed
from funcionario, departamento where Funcionario.departamentoid = departamento.departamentoid;

select * from vw_funz;

create view vw_total(nomeDepto, numFunc, totalSal) as select nomed, count(*), sum(salario)
from funcionario F, departamento D where F.departamentoid = d.departamentoid
group by nomed;

select * from vw_total;
SELECT nomeDepto, numFunc FROM vw_total WHERE nomeDepto = 'Eng.Sofware';

create view vw_FuncS as select funcionarioid, nomef from funcionario;

insert into vw_funcS(Funcionarioid, nomeF) values(null,"Luan");