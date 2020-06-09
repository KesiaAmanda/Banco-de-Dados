CREATE DATABASE exaula10
GO
USE exaula10

CREATE TABLE Fornecedor(
	codigo		INT IDENTITY(1001,1),  
	nome		VARCHAR(100) NOT NULL,
	atividade	VARCHAR(100) NOT NULL,
	telefone	CHAR(8) NOT NULL
	PRIMARY KEY(codigo)
)

INSERT INTO Fornecedor VALUES 
('Estrela', 'Brinquedo', '41525898'),
('Lacta', 'Chocolate', '42698596'),
('Asus', 'Informática', '52014596'),
('Tramontina', 'Utensílios Domésticos', '50563985'),
('Grow', 'Brinquedos', '47896325'),
('Mattel', 'Bonecos', '59865898')

CREATE TABLE Cliente(
	codigo				INT IDENTITY(33601,1),
	nome				VARCHAR(100) NOT NULL,
	logradouro			VARCHAR(100) NOT NULL,
	numero_porta		INT NOT NULL,
	telefone			CHAR(8) NOT NULL,
	data_nascimento		DATE NOT NULL
	PRIMARY KEY(codigo)
)

INSERT INTO Cliente VALUES
('Maria Clara','R. 1° de Abril', '870','96325874','1990-04-15'),
('Alberto Souza','R. XV de Novembro', '987','95873625','1975-12-25'),
('Sonia Silva','R. Voluntários da Pátria', '1152','75418596','1944-06-03'),
('José Sobrinho','Av. Paulista', '250','85236547','1982-10-12'),
('Carlos Camargo','Av. Tiquatira', '9652','75896325','1975-02-27')


CREATE TABLE Produto(
	codigo				INT IDENTITY,
	nome				VARCHAR(100) NOT NULL,
	valor_unitario		DECIMAL(7,2) NOT NULL,
	quantidade_estoque	INT,
	descricao			VARCHAR(255) NOT NULL,
	codigo_fornecedor	INT NOT NULL
	PRIMARY KEY(codigo)
	FOREIGN KEY(codigo_fornecedor) REFERENCES Fornecedor(codigo)
)

INSERT INTO Produto VALUES
('Banco Imobiliário', 65.00, 15, 'Versão Super Luxo', 1001),
('Puzzle 5000 peças', 50.00, 5, 'Mapas Mundo', 1005),
('Faqueiro', 350.00, 0,'120 peças', 1004),
('Jogo para churrasco', 75.00, 3,'7 peças', 1004),
('Eee Pc', 750.00, 29,'Netbook com 4 Gb de HD', 1003),
('Detetive', 49.00, 0,'Nova Versão do Jogo', 1001),
('Chocolate com Paçoquinha', 6.00, 0, 'Barra', 1002),
('Galak', 5.00, 65, 'Barra', 1002)


CREATE TABLE Pedido(
	codigo_pedido		INT IDENTITY(99001,1),
	codigo_cliente		INT NOT NULL,
	codigo_produto		INT NOT NULL,
	quantidade			INT NOT NULL,
	previsao_entrega	DATE NOT NULL
	PRIMARY KEY(codigo_pedido)
	FOREIGN KEY(codigo_cliente) REFERENCES Cliente(codigo),
	FOREIGN KEY(codigo_produto) REFERENCES Produto(codigo)
)

INSERT INTO Pedido VALUES
(33601, 1, 1, '2017-07-07'),
(33601, 2, 1, '2017-07-07'),
(33601, 8, 3, '2017-07-07'),
(33602, 2, 1, '2017-07-09'),
(33602, 4, 3, '2017-07-09'),
(33605, 5, 1, '2017-07-15')

--Codigo do produto, nome do produto, quantidade em estoque,
--uma coluna dizendo se está baixo, bom ou confortável,
--uma coluna dizendo o quanto precisa comprar para que o estoque fique minimamente confortável

SELECT codigo, nome, quantidade_estoque,
		CASE 
		WHEN ( quantidade_estoque > 20 ) THEN 
			'CONFORTÁVEL'
		WHEN ( quantidade_estoque >= 10 ) THEN 
			'BOM'
		ELSE
			'BAIXO'
		END AS Situação_Estoque,
		CASE WHEN (quantidade_estoque < 21) THEN
			 (21 - quantidade_estoque) 
		END AS Faltantes_Para_Confortável
FROM Produto


--Consultar o nome e o telefone dos fornecedores que não tem produtos cadastrados
SELECT * FROM Produto
SELECT * FROM Fornecedor

SELECT	f.nome, 
		SUBSTRING(f.telefone,1,4)+'-'+SUBSTRING(f.telefone,4,4) as Telefone
FROM Fornecedor f LEFT OUTER JOIN Produto p
ON f.codigo = p.codigo_fornecedor
WHERE p.codigo_fornecedor IS NULL

--Consultar o nome e o telefone dos clientes que não tem pedidos cadastrados
SELECT * FROM Cliente
SELECT * FROM Pedido

SELECT	c.nome,
		SUBSTRING(c.telefone,1,4)+'-'+SUBSTRING(c.telefone,4,4) as Telefone
FROM Cliente c LEFT OUTER JOIN Pedido p
ON c.codigo = p.codigo_cliente
WHERE p.codigo_cliente is NULL

--Considerando a data do sistema, consultar o nome do cliente, 
--endereço concatenado com o número de porta
--o código do pedido e quantos dias faltam para a data prevista para a entrega
--criar, também, uma coluna que escreva ABAIXO para menos de 25 dias de previsão de entrega,
--ADEQUADO entre 25 e 30 dias e ACIMA para previsão superior a 30 dias
--as linhas de saída não devem se repetir e ordenar pela quantidade de dias

SELECT	c.nome,
		c.logradouro+', '+CAST(c.numero_porta AS CHAR(5)) AS Endereço_Completo,
		p.codigo_pedido,
		DATEDIFF(DAY,p.previsao_entrega,GETDATE()) AS Dias_Faltantes,
		CASE 
			WHEN ( DATEDIFF(DAY,p.previsao_entrega,GETDATE()) < 25 ) THEN
				'ABAIXO'
			WHEN ( DATEDIFF(DAY,p.previsao_entrega,GETDATE())  <= 30 ) THEN
				'ADEQUADO'
			ELSE
				'ACIMA'
		END AS Situação
FROM Cliente c INNER JOIN Pedido p
ON c.codigo = p.codigo_cliente
ORDER BY DATEDIFF(DAY,p.previsao_entrega,GETDATE())


--Consultar o Nome do cliente, o código do pedido, 
--a soma do gasto do cliente no pedido e a quantidade de produtos por pedido
--ordenar pelo nome do cliente

SELECT	c.nome,
		p.codigo_pedido,
		(p.quantidade * pd.valor_unitario) AS Total,
		p.quantidade
FROM Cliente c, Pedido p, Produto pd
WHERE	c.codigo = p.codigo_cliente
		AND pd.codigo = p.codigo_produto
ORDER BY c.nome

--Consultar o Código e o nome do Fornecedor e 
--a contagem de quantos produtos ele fornece

SELECT	f.codigo,
		f.nome,
		COUNT(p.nome) AS Total 
FROM Fornecedor f INNER JOIN Produto p
ON f.codigo = p.codigo_fornecedor
GROUP BY f.codigo, f.nome

--Consultar o nome e o telefone dos clientes que tem menos de 2 compras feitas
--A query não deve considerar quem fez 2 compras

SELECT	c.nome,
		SUBSTRING(c.telefone,1,4)+'-'+SUBSTRING(c.telefone,4,4) as Telefone
FROM Cliente c INNER JOIN Pedido p
ON c.codigo = p.codigo_cliente
GROUP BY c.nome, c.telefone
HAVING COUNT(p.codigo_cliente) > 2

--Consultar o Codigo do pedido que tem o maior valor unitário de produto

SELECT p.codigo_pedido
FROM Pedido p INNER JOIN Produto pd
ON p.codigo_produto = pd.codigo
WHERE pd.valor_unitario = (
	SELECT MAX(valor_unitario)
	FROM Produto)

--Consultar o Codigo_Pedido, o Nome do cliente e o valor total da compra do pedido
--O valor total se dá pela somatória de valor_Unitário * quantidade comprada

SELECT  c.nome,
        p.codigo_pedido,
        (p.quantidade * pd.valor_unitario) AS Total
FROM Cliente c, Pedido p, Produto pd
WHERE    c.codigo = p.codigo_cliente
        AND pd.codigo = p.codigo_produto
ORDER BY c.nome


SELECT  c.nome,
        SUM(p.quantidade * pd.valor_unitario) AS Total
FROM Cliente c, Pedido p, Produto pd
WHERE   c.codigo = p.codigo_cliente
        AND pd.codigo = p.codigo_produto
GROUP BY c.nome
ORDER BY c.nome