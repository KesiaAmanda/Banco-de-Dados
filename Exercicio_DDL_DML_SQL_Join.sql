USE Projetos

--a) Adicionar User
--(6; Joao; Ti_joao; 123mudar; joao@empresa.com)

INSERT INTO Users (nameUser, username, passwordUser, email) VALUES 
('Joao', 'Ti_joao', '123mudar', 'joao@empresa.com')


--b) Adicionar Project
--(10004; Atualização de Sistemas; Modificação de Sistemas Operacionais nos PC's; 12/09/2014)

INSERT INTO Projects (nameProject, descriptionProject, dateProject) VALUES
('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PCs', '12/09/2014')


--c) Consultar:
--1) Id, Name e Email de Users, Id, Name, Description e Data de Projects, dos usuários que
--participaram do projeto Name Re-folha

SELECT u.id, u.nameUser, u.email, p.id, p.descriptionProject, p.dateProject 
FROM Projects p INNER JOIN Users_Has_Projects up
ON p.id = up.projects_id
INNER JOIN Users u
ON u.id = up.users_id
WHERE p.nameProject LIKE '%Re-folha%' 


--2) Name dos Projects que não tem Users

SELECT p.nameProject
FROM Projects p LEFT OUTER JOIN Users_Has_Projects up
ON p.id = up.projects_id
WHERE up.projects_id IS NULL


--3) Name dos Users que não tem Projects 

SELECT u.nameUser
FROM Users u LEFT OUTER JOIN Users_Has_Projects up
ON u.id = up.users_id
WHERE up.users_id IS NULL

SELECT * FROM Users
SELECT * FROM Projects
SELECT * FROM Users_Has_Projects
