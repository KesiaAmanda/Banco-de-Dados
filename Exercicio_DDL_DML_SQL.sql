CREATE DATABASE Projetos
GO
USE Projetos

CREATE TABLE Users (
id				INT				NOT NULL IDENTITY(1,1),
nameUser		VARCHAR(45)		NOT NULL,
username		VARCHAR(45)		NOT NULL UNIQUE,
passwordUser	VARCHAR(45)		NOT NULL DEFAULT('123mudar'),
email			VARCHAR(45)		NOT NULL
PRIMARY KEY (id)
)

GO

CREATE TABLE Projects (
id					INT				NOT NULL IDENTITY(10001,1),
nameProject			VARCHAR(45)		NOT NULL,
descriptionProject	VARCHAR(45)		NULL,
dateProject			DATE			NOT NULL CHECK(dateProject > (CAST('01-09-2014' AS DATE)))
PRIMARY KEY (id)
)

GO

CREATE TABLE Users_Has_Projects (
users_id		INT		NOT NULL,
projects_id		INT		NOT NULL
PRIMARY KEY (users_id, projects_id)
FOREIGN KEY (users_id) REFERENCES Users (id),
FOREIGN KEY (projects_id) REFERENCES Projects (id)
)

GO

--Modificar a coluna username da tabela Users para varchar(10) 
EXEC sp_help Users

ALTER TABLE Users
DROP CONSTRAINT UQ__Users__F3DBC57281705631;

ALTER TABLE Users
ALTER COLUMN username VARCHAR(10)

ALTER TABLE Users
ADD CONSTRAINT UQ__Users__F3DBC57281705631 UNIQUE(username);

--Modificar a coluna password da tabela Users para varchar(8) 
ALTER TABLE Users
ALTER COLUMN passwordUser VARCHAR(10)


--Usuarios
INSERT INTO Users (nameUser, username, email) VALUES 
('Maria', 'Rh_maria', 'maria@empresa.com')

INSERT INTO Users (nameUser, username, passwordUser, email) VALUES 
('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com')

INSERT INTO Users (nameUser, username, email) VALUES 
('Ana', 'Rh_ana', 'ana@empresa.com'),
('Clara', 'Ti_clara', 'clara@empresa.com')

INSERT INTO Users (nameUser, username, passwordUser, email) VALUES 
('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')

--Projetos
INSERT INTO Projects (nameProject, descriptionProject, dateProject) VALUES
('Re‐folha', 'Refatoração das Folhas', '05-09-2014'),
('Manutenção PC´s', 'Manutenção PC´s', '06-09-2014')

INSERT INTO Projects (nameProject, dateProject) VALUES
('Auditoria', '07-09-2014')

--Usuario_Projeto
INSERT INTO Users_Has_Projects (users_id, projects_id) VALUES
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002)

--O projeto de Manutenção atrasou, mudar a data para 12/09/2014
UPDATE Projects
SET dateProject = '12-09-2014'
WHERE nameProject LIKE 'Manutenção%'

--O username de aparecido (usar o nome como condição de mudança) está feio, mudar para Rh_cido 
UPDATE Users
SET username = 'Rh_cido'
WHERE nameUser LIKE 'Aparecido'

--Mudar o password do username Rh_maria (usar o username como condição de mudança) 
--para 888@*, mas a condição deve verificar se o password dela ainda é 123mudar
UPDATE Users
SET passwordUser = '888@*'
WHERE username = 'Rh_maria' AND passwordUser = '123mudar'

--O user de id 2 não participa mais do projeto 10002, removê‐lo da associativa
DELETE Users_Has_Projects
WHERE users_id = 2 and projects_id = 10002

--Adicionar uma coluna budget DECIMAL(7,2) NULL na tabela Project
ALTER TABLE Projects
ADD budget DECIMAL(7,2) NULL

--Atualizar a coluna budget
UPDATE Projects
SET budget = 5750.00
WHERE id = 10001

UPDATE Projects
SET budget = 7850.00
WHERE id = 10002

UPDATE Projects
SET budget = 9530.00
WHERE id = 10003

--Consultar:
--username e password da Ana
SELECT	username,
		passwordUser
FROM	Users
WHERE	nameUser LIKE 'Ana'

--nome, budget e valor hipotético de um budget 25% maior
SELECT	nameProject,
		budget,
		CONVERT(DECIMAL(7,2), budget*1.25) as '25% maior'
FROM	Projects

--id, nome e e-mail do usuário que ainda mantém o password padrão (123mudar)
SELECT	id,
		nameUser,
		email
FROM	Users
WHERE	passwordUser = '123mudar'

--id, nome dos budgets cujo valor está entre 2000.00 e 8000.00
SELECT	id,
		nameProject
FROM	Projects
WHERE	budget BETWEEN 2000.00 AND 8000.00


SELECT * FROM Projects
