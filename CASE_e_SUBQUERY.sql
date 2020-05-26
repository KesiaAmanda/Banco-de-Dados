--Nomes completos dos Funcionários que estão no
--projeto Modificação do Módulo de Cadastro

SELECT nome+' '+sobrenome AS nome_completo
FROM funcionario
WHERE id IN (
SELECT id_funcionario
FROM funcproj
WHERE codigo_projeto IN
(SELECT DISTINCT codigo
FROM projeto
WHERE nome = 'Modificação do Módulo de Cadastro'))


--Nomes completos e Idade, em anos (considere se fez ou ainda fará
--aniversário esse ano), dos funcionários

SELECT nome+' '+sobrenome AS nome_completo,
		CASE WHEN (MONTH(data_nasc)>=MONTH(GETDATE())) THEN
			CASE WHEN (MONTH(data_nasc)=MONTH(GETDATE())) THEN 
				CASE WHEN (DAY(data_nasc)>DAY(GETDATE())) THEN
					YEAR(GETDATE())-YEAR(data_nasc)-1
				ELSE
					YEAR(GETDATE())-YEAR(data_nasc)
				END
			ELSE
				YEAR(GETDATE())-YEAR(data_nasc)-1
			END
		ELSE 
			YEAR(GETDATE())-YEAR(data_nasc)
		END AS idade
FROM funcionario
