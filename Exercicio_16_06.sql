CREATE DATABASE aula1606
GO
USE aula1606

CREATE TABLE cliente(
cod			INT				IDENTITY(1001,1),
nome		VARCHAR(100)	NULL,
logradouro	VARCHAR(100)	NULL,
numero		INT				NULL,
telefone	VARCHAR(9)		NULL
PRIMARY KEY (cod)
)

CREATE TABLE autor(
cod			INT				IDENTITY(10001,1),
nome		VARCHAR(100)	NULL,
pais		VARCHAR(50)		NULL,
biografia	VARCHAR(255)	NULL
PRIMARY KEY (cod)
)

CREATE TABLE corredor(
cod		INT				IDENTITY(3251,1),
tipo	VARCHAR(50)		NULL
PRIMARY KEY (cod)
)

CREATE TABLE livro(
cod				INT				IDENTITY,
cod_autor		INT				NOT NULL,
cod_corredor	INT				NOT NULL,
nome			VARCHAR(100)	NULL,
pag				INT				NULL,
idioma			VARCHAR(50)		NULL
PRIMARY KEY (cod)
FOREIGN KEY (cod_autor) REFERENCES autor (cod),
FOREIGN KEY (cod_corredor) REFERENCES corredor (cod)
)

CREATE TABLE emprestimo(
cod_cli		INT		NOT NULL,
cod_livro	INT		NOT NULL,
dataEmp		DATE	NULL
PRIMARY KEY (cod_cli, cod_livro)
FOREIGN KEY (cod_cli) REFERENCES cliente (cod),
FOREIGN KEY (cod_livro) REFERENCES livro (cod)
)

INSERT INTO cliente VALUES
('Luis Augusto', 'R. 25 de Março', 250, '996529632'),
('Maria Luisa', 'R. XV de Novembro', 890, '998526541'),
('Claudio Batista', 'R. Anhaia', 112, '996547896'),
('Wilson Mendes', 'R. do Hipódromo', 1250, '991254789'),
('Ana Maria', 'R. Augusta', 896, '999365589'),
('Cinthia Souza', 'R. Voluntários da Pátria', 1023, '984256398'),
('Luciano Britto', NULL, NULL, '995678556'),
('Antônio do Valle', 'R. Sete de Setembro',	1894, NULL)

INSERT INTO autor VALUES
('Ramez E. Elmasri', 'EUA', 'Professor da Universidade do Texas'),
('Andrew Tannenbaum', 'Holanda', 'Desenvolvedor do Minix'),
('Diva Marília Flemming', 'Brasil', 'Professora Adjunta da UFSC'),
('David Halliday', 'EUA', 'Ph.D. da University of Pittsburgh'),
('Marco Antonio Furlan de Souza', 'Brasil', 'Prof. do IMT'),
('Alfredo Steinbruch', 'Brasil', 'Professor de Matemática da UFRS e da PUCRS')

INSERT INTO corredor VALUES
('Informática'),
('Matemática'),
('Física'),
('Química')

INSERT INTO livro VALUES
(10001, 3251, 'Sistemas de Banco de dados', 720, 'Português'),
(10002,	3251, 'Sistemas Operacionais Modernos', 580, 'Português'),
(10003,	3252, 'Calculo A', 290, 'Português'),
(10004,	3253, 'Fundamentos de Física I', 185, 'Português'),
(10005,	3251, 'Algoritmos e Lógica de Programação', 90, 'Português'),
(10006,	3252, 'Geometria Analítica', 75, 'Português'),
(10004,	3253, 'Fundamentos de Física II', 150, 'Português'),
(10002,	3251, 'Redes de Computadores', 493, 'Inglês'),
(10002,	3251, 'Organização Estruturada de Computadores', 576, 'Português')

INSERT INTO emprestimo VALUES
(1001, 1, '2012-05-10'),
(1001, 2, '2012-05-10'),
(1001, 8, '2012-05-10'),
(1002, 4, '2012-05-11'),
(1002, 7, '2012-05-11'),
(1003, 3, '2012-05-12'),
(1004, 5, '2012-05-14'),
(1001, 9, '2012-05-15')

-- Fazer uma consulta que retorne o nome do cliente e a data do empréstimo formatada padrão BR (dd/mm/yyyy)
SELECT	c.nome,
		CONVERT(varchar, e.dataEmp,103) as dataEmprestimo
FROM emprestimo e INNER JOIN cliente c
ON e.cod_cli = c.cod

-- Fazer uma consulta que retorne Nome do autor e Quantos livros foram escritos por Cada autor, ordenado pelo número de livros. Se o nome do autor tiver mais de 25 caracteres, mostrar só os 13 primeiros.
SELECT	CASE WHEN (LEN(a.nome) > 25) THEN
			SUBSTRING(a.nome,1,13)+'.'
		ELSE
			a.nome
		END AS nome,
		COUNT(l.nome) AS qtdLivros
FROM autor a INNER JOIN livro l
ON a.cod = l.cod_autor
GROUP BY a.nome
ORDER BY COUNT(l.nome)

-- Fazer uma consulta que retorne o nome do autor e o país de origem do livro com maior número de páginas cadastrados no sistema
SELECT	a.nome,
		a.pais 
FROM autor a INNER JOIN livro l
ON l.cod_autor = a.cod
WHERE l.pag = (SELECT MAX(pag)
			   FROM Livro)

-- Fazer uma consulta que retorne nome e endereço concatenado dos clientes que tem livros emprestados
SELECT DISTINCT	c.nome,
				c.logradouro+', '+CAST(c.numero AS VARCHAR(50)) AS endereço,
				COUNT(m.cod_cli) AS totalEmprestimos
FROM cliente c INNER JOIN emprestimo m
ON c.cod = m.cod_cli
GROUP BY c.nome, c.logradouro, c.numero

/*
Nome dos Clientes, sem repetir e, concatenados como
enderço_telefone, o logradouro, o numero e o telefone) dos
clientes que Não pegaram livros. Se o logradouro e o 
número forem nulos e o telefone não for nulo, mostrar só o telefone. Se o telefone for nulo e o logradouro e o número não forem nulos, mostrar só logradouro e número. Se os três existirem, mostrar os três.
O telefone deve estar mascarado XXXXX-XXXX
*/

SELECT	c.nome,
		CASE WHEN (c.logradouro IS NOT NULL AND c.telefone IS NOT NULL) THEN
			c.logradouro+', '+CAST(c.numero AS VARCHAR(50))+', '+SUBSTRING(c.telefone,1,5)+'-'+SUBSTRING(c.telefone,5,4)
		WHEN (c.logradouro IS NULL) THEN
			SUBSTRING(c.telefone,1,5)+'-'+SUBSTRING(c.telefone,5,4)
		ELSE
			c.logradouro+', '+CAST(c.numero AS VARCHAR(50))
		END AS endereço_telefone
FROM cliente c LEFT OUTER JOIN emprestimo m
ON c.cod = m.cod_cli
WHERE m.cod_cli IS NULL

-- Fazer uma consulta que retorne Quantos livros não foram emprestados
SELECT COUNT(l.cod) AS TotalNãoEmprestados
FROM livro l LEFT OUTER JOIN emprestimo m
ON l.cod = m.cod_livro
WHERE m.cod_livro IS NULL

-- Fazer uma consulta que retorne Nome do Autor, Tipo do corredor e quantos livros, ordenados por quantidade de livro
SELECT	a.nome,
		c.tipo,
		COUNT(l.cod) AS QtdLivros
FROM autor a INNER JOIN livro l
ON a.cod = l.cod_autor
INNER JOIN corredor c
ON l.cod_corredor = c.cod
GROUP BY a.nome, c.tipo
ORDER BY COUNT(l.cod)

-- Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do cliente, o nome do livro, o total de dias que cada um está com o livro e, 
-- uma coluna que apresente, caso o número de dias seja superior a 4, apresente 'Atrasado', caso contrário, apresente 'No Prazo'
SELECT	c.nome AS NomeCliente,
		l.nome AS NomeLivro,
		DATEDIFF(DAY, m.dataEmp, '18/05/2012') AS TotalDias,
		CASE WHEN (DATEDIFF(DAY, m.dataEmp, '18/05/2012') > 4) THEN
			'Atrasado'
		ELSE
			'No Prazo'
		END AS Situação
FROM cliente c INNER JOIN emprestimo m
ON c.cod = m.cod_cli
INNER JOIN livro l
ON l.cod = m.cod_livro


-- Fazer uma consulta que retorne cod de corredores, tipo de corredores e quantos livros tem em cada corredor
SELECT	c.cod,
		c.tipo,
		COUNT(l.cod) AS QtdLivros
FROM corredor c INNER JOIN livro l
ON l.cod_corredor = c.cod
GROUP BY c.cod, c.tipo

-- Fazer uma consulta que retorne o Nome dos autores cuja quantidade de livros cadastrado é maior ou igual a 2.
SELECT a.nome
FROM autor a INNER JOIN livro l
ON a.cod = l.cod_autor
GROUP BY a.nome
HAVING COUNT(l.cod) >= 2

-- Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do cliente, o nome do livro dos empréstimos que tem 7 dias ou mais
SELECT	c.nome AS NomeCliente,
		l.nome AS NomeLivro
FROM cliente c INNER JOIN emprestimo m
ON c.cod = m.cod_cli
INNER JOIN livro l
ON l.cod = m.cod_livro
GROUP BY c.nome, l.nome, m.dataEmp
HAVING DATEDIFF(DAY, m.dataEmp, '18/05/2012') >= 7
