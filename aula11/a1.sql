create database aula;
use aula;

drop database aula;

create table teste1(a1 int);
create table teste2(a2 int);
create table teste3(a3 int not null auto_increment primary key);
create table teste4(a4 int not null auto_increment primary key, b4 int default 0);

insert into teste3 values 
(null), (null), (null), (null), (null),
(null), (null), (null), (null), (null);

insert into teste4 (a4) values
(0), (0), (0), (0), (0),
(0), (0), (0), (0), (0);

insert into teste1 values
(1), (3), (1), (7), (1), (8), (4), (4);

select * from teste4;

delimiter $$
create trigger testeref
before insert on teste1
	for each row begin
		insert into teste2 (a2) values (new.a1);
        delete from teste3 where a3 = new.a1;
        update teste4 set b4 = b4 + 1 where a4 = new.a1;
	end;
$$
delimiter ;
