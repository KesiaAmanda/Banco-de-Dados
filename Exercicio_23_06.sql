CREATE DATABASE loja
GO
USE loja
GO

CREATE TABLE cliente(
cpf			CHAR(11)		NOT NULL,
nome		VARCHAR(100)	NOT NULL,
telefone	CHAR(8)			NOT NULL,
PRIMARY	KEY (cpf)
)

GO

CREATE TABLE fornecedor(
id			INT				IDENTITY NOT NULL,
nome		VARCHAR(100)	NOT NULL,
logradouro	VARCHAR(100)	NOT NULL,
numero		CHAR(5)			NOT NULL,
complemento VARCHAR(10)		NOT NULL,
cidade		VARCHAR(50)		NOT NULL
PRIMARY KEY (id)
)

GO

CREATE TABLE produto(
codigo		INT				IDENTITY NOT NULL,
descricao	VARCHAR(MAX)	NOT NULL,
id_forn		INT				NOT NULL,
preco		DECIMAL(7,2)	NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (id_forn) REFERENCES fornecedor (id)
)

GO

CREATE TABLE venda(
codigo			INT				NOT NULL,
cod_prod		INT				NOT NULL,
cpf_cli			CHAR(11)		NOT NULL,
quatidade		INT				NOT NULL,
valor_total		DECIMAL(7,2)	NOT NULL,
data_venda		DATE			NOT NULL
PRIMARY KEY (codigo, cod_prod, cpf_cli, data_venda)
FOREIGN KEY (cod_prod) REFERENCES produto (codigo),
FOREIGN KEY (cpf_cli) REFERENCES cliente (cpf)
)

GO

INSERT INTO cliente VALUES
('25186533710', 'Maria Antonia', '87652314'),
('34578909290',	'Julio Cesar', '82736541'),
('79182639800',	'Paulo Cesar', '90765273'),
('87627315416',	'Luiz Carlos', '61289012'),
('36587498700',	'Paula Carla', '23547888')

GO 

INSERT INTO fornecedor VALUES
('LG', 'Rod. Bandeirantes', '70000', 'Km 70', 'Itapeva'),
('Asus', 'Av. Nações Unidas', '10206', 'Sala 225', 'São Paulo'),
('AMD', 'Av. Nações Unidas', '10206', 'Sala 1095', 'São Paulo'),
('Leadership', 'Av. Nações Unidas', '10206', 'Sala 87', 'São Paulo'),
('Inno', 'Av. Nações Unidas', '10206', 'Sala 34', 'São Paulo'),
('Kingston', 'Av. Nações Unidas', '10206', 'Sala 18', 'São Paulo')

GO

INSERT INTO produto VALUES
('Monitor 19 pol.', '1', '449.99'),
('Zenfone', '2', '1599.99'),
('Gravador de DVD - Sata', '1', '99.99'),
('Leitor de CD', '1', '49.99'),
('Processador - Ryzen 5', '3', '599.99'),
('Mouse', '4', '19.99'),
('Teclado', '4', '25.99'),
('Placa de Video - RTX 2060', '2', '2399.99'),
('Pente de Memória 4GB DDR 4 2400 MHz', '5', '259.99')

GO

INSERT INTO venda VALUES
('1', '1', '25186533710', '1', '449.99', '2009-09-03'),
('1', '4', '25186533710', '1', '49.99', '2009-09-03'),
('1', '5', '25186533710', '1', '349.99', '2009-09-03'),
('2', '6', '79182639800', '4', '79.96', '2009-09-06'),
('3', '3', '87627315416', '1', '99.99', '2009-09-06'),
('3', '7', '87627315416', '1', '25.99', '2009-09-06'),
('3', '8', '87627315416', '1', '599.99', '2009-09-06'),
('4', '2', '34578909290', '2', '1399.98', '2009-09-08')


--Quantos produtos não foram vendidos ?

SELECT	COUNT(p.codigo) AS Total_Não_Vendidos
FROM produto p LEFT OUTER JOIN venda v
ON p.codigo = v.cod_prod
WHERE v.cod_prod IS NULL

--Nome do produto, Nome do fornecedor, count() do produto nas vendas

SELECT	p.descricao,
		f.nome,
		COUNT(v.quatidade) AS vendas
FROM produto p INNER JOIN fornecedor f
ON p.id_forn = f.id
INNER JOIN venda v
ON p.codigo = v.cod_prod
GROUP BY p.descricao, f.nome, p.codigo
ORDER BY p.codigo

--Nome do cliente e Quantos produtos cada um comprou ordenado pela quantidade

SELECT	c.nome,
		SUM(v.quatidade) AS quantidade
FROM cliente c INNER JOIN venda v
ON c.cpf = v.cpf_cli
GROUP BY c.nome
ORDER BY SUM(v.quatidade)

--Nome do produto e Quantidade de vendas do produto com menor valor do catálogo de produtos

SELECT	p.descricao,
		SUM(v.quatidade) AS Quantidade_Vendas
FROM produto p INNER JOIN venda v
ON p.codigo = v.cod_prod
GROUP BY p.descricao, p.preco
HAVING p.preco = ( SELECT MIN(produto.preco) FROM produto )

--Nome do Fornecedor e Quantos produtos cada um fornece

SELECT	f.nome,
		COUNT(p.codigo) AS Total_Produtos
FROM fornecedor f INNER JOIN produto p
ON f.id = p.id_forn
GROUP BY f.nome

--Considerando que hoje é 20/10/2009, consultar o código da compra, nome do cliente, telefone do cliente e quantos dias da data da compra

SELECT	v.codigo AS Codigo_Venda,
		c.nome AS Nome_Cliente,
		SUBSTRING(c.telefone, 1, 4)+'-'+SUBSTRING(c.telefone, 4, 4) AS Telefone_Cliente,
		DATEDIFF(DAY, v.data_venda, '20/10/2009') AS Qtd_Dias
FROM cliente c INNER JOIN venda v
ON c.cpf = v.cpf_cli

--CPF do cliente, mascarado (XXX.XXX.XXX-XX), Nome do cliente e quantidade que comprou mais de 2 produtos

SELECT	SUBSTRING(c.cpf,1,3)+'.'+SUBSTRING(c.cpf,3,3)+'.'+SUBSTRING(c.cpf,6,3)+'-'+SUBSTRING(c.cpf,9,2) AS CPF_Cliente,
		c.nome AS Nome_Cliente,
		SUM(v.quatidade) AS Quantidade
FROM cliente c INNER JOIN venda v
ON c.cpf = v.cpf_cli
GROUP BY c.cpf, c.nome, v.quatidade
HAVING SUM(v.quatidade) > 2

--CPF do cliente, mascarado (XXX.XXX.XXX-XX), Nome do Cliente e Soma do valor_total gasto

SELECT	SUBSTRING(c.cpf,1,3)+'.'+SUBSTRING(c.cpf,3,3)+'.'+SUBSTRING(c.cpf,6,3)+'-'+SUBSTRING(c.cpf,9,2) AS CPF_Cliente,
		c.nome AS Nome_Cliente,
		SUM(v.valor_total) AS Valor_Total
FROM cliente c INNER JOIN venda v
ON c.cpf = v.cpf_cli
GROUP BY c.cpf, c.nome, v.valor_total

--Código da compra, data da compra em formato (DD/MM/AAAA) e uma coluna, chamada dia_semana, que escreva o dia da semana por extenso

SET LANGUAGE 'Portuguese'
SELECT	v.codigo AS Codigo_Venda,
		CONVERT(varchar, v.data_venda, 103) AS Data_Venda,
		DATENAME(WEEKDAY, data_venda) AS Dia_Semana
FROM venda v