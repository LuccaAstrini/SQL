cREATE DATABASE a3;
USE a3;

CREATE TABLE Aluno (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50),
    data_nasc DATE,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE Disciplina (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50),
    carga_horaria INT
);

CREATE TABLE Matricula (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT,
    id_disciplina INT,
    nota DECIMAL(4,2),
    FOREIGN KEY (id_aluno) REFERENCES Aluno(id),
    FOREIGN KEY (id_disciplina) REFERENCES Disciplina(id)
);

CREATE TABLE AuditoriaNota (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_matricula INT,
    nota_antiga DECIMAL(4,2),
    nota_nova DECIMAL(4,2),
    data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_matricula) REFERENCES Matricula(id)
);

/* Atualizar campo ativo ao remover aluno*/
delimiter $$
create trigger Inativar
before delete on Aluno
for each row
	signal sqlstate "45000"
    set message_text = "Não delete informações de alunos apenas os deixe inativos";
end;
$$
delimiter ;
drop trigger Inativar;
UPDATE Aluno SET ativo = FALSE WHERE id = 1;

/*Não permitir nota negativa na matrícula*/
delimiter $$
create trigger Negar_nota
before insert on Matricula
for each row
begin 
	if new.nota < 0 then
		set new.nota = 0;
	end if;
end;
$$
delimiter ;

/*Impedir notas maiores que 10*/
delimiter $$
create trigger ImpedirNotamaior
before insert on Matricula
for each row
begin
	if new.nota > 10 and new.nota < 0 then
		signal sqlstate '45000' set message_text = "Não é permitido notas maiores que 10 ou menores que 0";
	end if;
end;
$$
delimiter ;

/*Registrar alteração de nota na AuditoriaNota*/
delimiter $$
create trigger RegistrarAlterar
after update on AuditoriaNota
for each row
begin
	if old.nota != new.nota then
		insert into AuditoriaNota(id_matricula, nota_antiga, nota_nova)
        values (old.id, old.nota, new.nota);
	end if;
end;
$$
delimiter ;
drop trigger RegistrarAlterar;

/*Impedir matrícula duplicada na mesma disciplina*/
delimiter $$
create trigger Duplicata
before insert on Matricula
for each row
begin
	declare existe int;
    select count(*) into existe from matricula
    where id_aluno = new.id_aluno and id_disciplia = new.id_disciplina;
    
    if existe > 0 then
		signal sqlstate "45000" set message_text = "Erro: ALuno já matriculado";
	end if;
end;
$$
delimiter ;

-- Alunos
INSERT INTO Aluno (nome, data_nasc) VALUES ('João Silva', '2000-05-10');
INSERT INTO Aluno (nome, data_nasc) VALUES ('Maria Lima', '1999-08-15');

-- Disciplinas
INSERT INTO Disciplina (nome, carga_horaria) VALUES ('Matemática', 80);
INSERT INTO Disciplina (nome, carga_horaria) VALUES ('História', 60);

-- Matrícula válida
INSERT INTO Matricula (id_aluno, id_disciplina, nota) VALUES (1, 1, 8.5);
-- Testar nota negativa:
INSERT INTO Matricula (id_aluno, id_disciplina, nota) VALUES (1, 2, -5); -- será 0
-- Testar nota > 10:
-- INSERT INTO Matricula (id_aluno, id_disciplina, nota) VALUES (2, 2, 12); -- erro


SHOW TABLES;
