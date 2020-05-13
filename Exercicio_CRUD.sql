CREATE DATABASE Livraria

USE Livraria

CREATE TABLE Livro (
idLivro		INT				NOT NULL,
nome		VARCHAR(100)	NULL,
lingua		VARCHAR(50)		NULL,
ano			INT				NULL
PRIMARY KEY (idLivro)
)

GO

CREATE TABLE Autor (
idAutor			INT				NOT NULL,
nome			VARCHAR(100)	NULL,
dataNasc		DATE			NULL,
pais			VARCHAR(50)		NULL,
biografia		VARCHAR(MAX)	NULL
PRIMARY KEY (idAutor)
)

GO

CREATE TABLE Edicoes (
ISBN			INT				NOT NULL,
preco			DECIMAL(7,2)	NULL,
ano				INT				NULL,
numPag			INT				NULL,
qtdEstoque		INT				NULL
PRIMARY KEY (ISBN)
)

GO

CREATE TABLE Editora (
idEditora		INT				NOT NULL,
nome			VARCHAR(50)		NULL,
logradouro		VARCHAR(255)	NULL,
num				INT				NULL,
cep				char(8)			NULL,
telefone		char(11)		NULL
PRIMARY KEY (idEditora)
)

GO

CREATE TABLE LivroAutor (
livroIdLivro	INT				NOT NULL,
autorIdAutor	INT				NOT NULL
PRIMARY KEY (livroIdLivro, autorIdAutor)
FOREIGN KEY (livroIdLivro) REFERENCES Livro (idLivro),
FOREIGN KEY (autorIdAutor) REFERENCES Autor (idAutor)
)

GO

CREATE TABLE LivroEdicoesEditora (
livroIdLivro		INT				NOT NULL,
edicoesISBN			INT				NOT NULL,
editoraIdEditora	INT				NOT NULL
PRIMARY KEY (livroIdLivro, edicoesISBN,editoraIdEditora)
FOREIGN KEY (livroIdLivro) REFERENCES Livro (idLivro),
FOREIGN KEY (edicoesISBN) REFERENCES Edicoes (ISBN),
FOREIGN KEY (editoraIdEditora) REFERENCES Editora (idEditora)
)

GO

EXEC sp_rename 'dbo.Edicoes.ano','anoEdicao','column'

ALTER TABLE Editora
ALTER COLUMN nome VARCHAR(30)

ALTER TABLE Autor
DROP COLUMN dataNasc

ALTER TABLE Autor
ADD ano INT


INSERT INTO Livro VALUES
(1001, 'CCNA 4.1', 'PT-BR', 2015),
(1002, 'HTML 5', 'PT-BR', 2017),
(1003, 'Redes de Computadores', 'EN', 2010),
(1004, 'Android em Ação', 'PT-BR', 2018)

INSERT INTO Autor VALUES
(10001, 'Inácio da Silva', 'Brasil', 'Programador WEB desde 1995', 1975),
(10002, 'Andrew Tannenbaum', 'EUA', 'Chefe de departamento de Sistemas de Computação da Universidade de Vrij', 1944),
(10003, 'Luis Rocha', 'Brasil', 'Programador Mobile desde 2000', 1967),
(10004, 'David Halliday', 'EUA', 'Físico PH.D desde 1941', 1916)

INSERT INTO Edicoes
	VALUES (0130661023,189.99,2018,653,10)

UPDATE Autor
SET biografia = 'Chefe de departamento de Sistemas de Computação da Universidade de Vrije'
WHERE idAutor = 10002 

UPDATE Edicoes
SET qtdEstoque = qtdEstoque-2
WHERE ISBN = 0130661023 

DELETE Autor
WHERE nome = 'David Halliday'