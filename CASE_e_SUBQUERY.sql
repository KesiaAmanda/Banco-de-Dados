--Nomes completos dos Funcion�rios que est�o no
--projeto Modifica��o do M�dulo de Cadastro

SELECT nome+' '+sobrenome AS nome_completo
FROM funcionario
WHERE id IN (
SELECT id_funcionario
FROM funcproj
WHERE codigo_projeto IN
(SELECT codigo
FROM projeto
WHERE nome = 'Modifica��o do M�dulo de Cadastro'))

--Nomes completos e Idade, em anos (considere se fez ou ainda far�
--anivers�rio esse ano), dos funcion�rios

SELECT nome+' '+sobrenome AS nome_completo,
		FLOOR(DATEDIFF(DAY, data_nasc, GETDATE()) / 365.25) AS idade
FROM funcionario

