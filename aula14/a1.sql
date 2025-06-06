create database Estado;
use estado;

create table estado(
idestado char(2) primary key,
nomeestado varchar (30));
drop table estado;

Create User adriana@localhost identified by "123";
grant select, insert on teste. * to adriana@Localhost;

create user secretaria1@localhost identified by 'sec123';
grant all on teste.* to secretaria1@localhost with grant option;

insert into estado values("SP", "São Paulo");
insert into estado values("RJ", "Rio de Janeuri");
insert into estado values("MG", "Minas Gerais");

create user joao@localhost identified by "123";
grant select, insert on estado. * to joao@localhost;

select * from mysql.user;

delete from mysql.user where user ="secretaria1" and host="localhost";