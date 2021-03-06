-- SCRIPT DML - LINGUAGEM DE MANIPULAÇÃO DOS DADOS
-- REALIZA O CRUD (MANUTENÇÃO DOS DADOS DENTRO DA ESTRUTURA)
-- COMANDOS: INSERT, UPDATE E DELETE


-- O CONTEUDO É CASE SENSITIVE - FAZ DIFERENÇA ENTRE LETRAS MAIUSCULAS E MINUSCULAS


-- OS COMANDOS NÃO SÃO CASE SENSITIVE - TANTO FAZ ESCREVER MAIUSCULO OU MINUSCULO


-- COMANDOS DML (INSERT, UPDATE, DELETE) SÃO TRANSAÇÕES QUE PRECISAM SER EFETIVADAS NO DISCO
-- PORTANTO AO TÉRMINO DOS COMANDOS DML, PRECISAMOS EXECUTAR UM COMANDO COMMIT, PARA QUE
-- OCORRA A EFETIVAÇÃO DAS TRANSAÇÕES

-- INSERIR UMA LINHA/REGISTRO NA TABELA - COMANDO COMPLETO
INSERT INTO T_SIP_DEPTO (CD_DEPTO, NM_DEPTO, SG_DEPTO) -- NOME DAS COLUNAS/ CAMPOS DA TABELA
	VALUES (1, 'FINANCEIRO', 'FIN'); -- VALORES A SEREM INSERIDOS NA MESMA ORDEM DOS CAMPOS INFORMADOS

-- INSERIR UMA LINHA/REGISTRO NA TABELA - COMANDO REDUZIDO
INSERT INTO T_SIP_DEPTO
	VALUES (2, 'MARKETING', 'MKT');

-- VISUALIZAR O CONTEUDO/DADOS DA TABELA DEPTO QUE FORAM INSERIDOS
-- COMANDO DE CONSULTA - SELECT
SELECT * FROM T_SIP_DEPTO;

-- SELECT * -> RETORNA TODAS AS COLUNAS DA TABELA
-- NA PRATICA EVITAR O SELECT * E A CONSULTA SEM WHERE, OU SEJA, EVITAR TRAZER A TABELA INTEIRA
-- PARA A MEMORIA, QUANDO A NECESSIDADE NÃO FOR UTILIZA-LA INTEIRA. VOCÊ ESTARIA DESPERDICANDO
-- RECURSOS DE MAQUINA, REDE, MEMORIA.

-- INSERCAO CONTENDO DATA/HORA
INSERT INTO T_SIP_PROJETO
	VALUES (1001, 'PROJETO ABC', TO_DATE('26/05/2020','DD/MM/YYYY')
	, TO_DATE('10/03/2021','DD/MM/YYYY'));


-- INSERINDO CONTENDO VALORES NUMERICOS DECIMAIS
INSERT INTO T_SIP_FUNCIONARIO
    VALUES (48751, 1, 'JOAO DA SILVA', TO_DATE('18/03/1995', 'DD/MM/YYYY'),
                                       TO_DATE('21/07/2012', 'DD/MM/YYYY'),
                                       'RUA X, 25',
                                       3542.62
                                       );
-- PARA VALORES DECIMAIS, USAR O PONTO DECIMAL, UMA VEZ QUE A VIRGULA SEPARA
-- O CONTEUDO DOS CAMPOS
	
	
-- INSERINDO VALORES NULOS PARA CAMPOS OPCIONAIS
-- MÉTODO IMPLICITO - OMITA A COLUNA DA LISTA DE COLUNAS
-- DT_TERMINO É OPCIONAL E SERÁ OMITIDA NA DECLARAÇÃO DO COMANDO
INSERT INTO T_SIP_PROJETO(CD_PROJETO, NM_PROJETO, DT_INICIO)
	VALUES (1002, 'PROJETO ABCD', TO_DATE('24/03/2019','DD/MM/YYYY'));
-- OBSERVE QUE OMITIMOS O CAMPO DT_TERMINO (CAMPO OPCIONAL) NA DECLARAÇÃO DAS COLUNAS, DESTA FORMA,
-- NÃO INFORMAMOS A DATA NA LISTA DE VALORES DA CLAUSULA VALUES PARA INSERÇÃO
-- O CAMPO OPCIONAL, QUE FOI OMITIDO, SERÁ PREENCHIDO COM NULL (NULO)


-- MÉTODO EXPLICITO - ESPECIFIQUE A PALAVRA-CHAVE NULL, NA CLAUSULA VALUES
-- SÃO ENVIADOS TODOS OS VALORES
INSERT INTO T_SIP_PROJETO
	VALUES (1003, 'PROJETO AIAI', TO_DATE('24/03/2019','DD/MM/YYYY'), NULL);
     -- ENVIO DE NULO PARA O CAMPO OPCIONAL DATA TERMINO DO PROJETO DE FORMA EXPLICITA



-- REALIZANDO COPIA DE DADOS DE UMA TABELA PARA OUTRA
-- CRIAR UMA TABELA PARA REALIZAR A CÓPIA
-- E UMA TABELA PARA ARMAZENAR UMA COPIA DOS PROJETOS FINALIZADOS
CREATE TABLE T_SIP_COPY_PROJETO_FIN
(
CD_PROJETO NUMBER(5) NOT NULL ,
NM_PROJETO VARCHAR2(40) NOT NULL ,
DT_INICIO DATE NOT NULL ,
DT_TERMINO DATE NOT NULL
);


-- CHAVE PRIMARIA DA TABELA COPIA PROJETOS FINALIZADOS
	ALTER TABLE T_SIP_COPY_PROJETO_FIN
ADD CONSTRAINT PK_SIP_COPY_PROJETO_FIN
	PRIMARY KEY (CD_PROJETO);



-- REALIZANDO A COPIA DOS DADOS DE UMA TABELA PARA OUTRA
-- UTILIZANDO O COMANDO INSERT E O COMANDO SELECT (SUBCONSULTA E SUBQUERY)
INSERT INTO T_SIP_COPY_PROJETO_FIN (CD_PROJETO, NM_PROJETO, DT_INICIO, DT_TERMINO)
			(SELECT CD_PROJETO, NM_PROJETO, DT_INICIO, DT_TERMINO 
				FROM T_SIP_PROJETO
				WHERE DT_TERMINO IS NOT NULL);

-- OS PROJETOS FINALIZADOS, POSSUEM A DATA TERMINO INFORMADA
-- PORTANTO A VALIDAÇÃO, PERGUNTAMOS SE A DATA TERMINO NÃO E NULA (POSSUI DATA) - IS NOT NULL
-- PARA FAZER ESTA VALIDAÇÃO UTILIZAMOS O OPERADOR IS NOT NULL
-- DESTA FORMA NÃO FUNCIONA, PORQUE NULO NAO TEM VALOR
-- DT_TERMINO = NULL
-- DT_TERMINO <> NULL
-- FUNCIONA APENAS DESTA FORMA
-- DT_TERMINO IS NULL -> DT_TERMINO E IGUAL A NULO
-- DT_TERMINO IS NOT NULL -> DT_TERMINO E DIFERENTE DE NULO


-- PODEMOS ESCREVER DE OUTRA FORMA
-- QUANDO AS TABELAS POSSUEM A MESMA ESTRUTURA E MESMO NOME
-- DAS COLUNAS, NA MESMA ORDEM, PODEMOS FAZER DESTA FORMA
INSERT INTO T_SIP_COPY_PROJETO_FIN
			(SELECT * FROM T_SIP_PROJETO
				WHERE DT_TERMINO IS NOT NULL	
						AND CD_PROJETO = 1004);


--- MAIS INSERÇÕES
INSERT INTO T_SIP_FUNCIONARIO
VALUES (95785, 2,'MARIA JOSE DAS DORES' ,
TO_DATE('12/04/1995','DD/MM/YYYY'),
TO_DATE('15/07/2015','DD/MM/YYYY'),
'RUA Y, 35',
4563.12
);

INSERT INTO T_SIP_FUNCIONARIO
VALUES (65412, 1,'JOAQUIM BARBOSA' ,
TO_DATE('05/08/1999','DD/MM/YYYY'),
TO_DATE('14/07/2016','DD/MM/YYYY'),
'RUAZ, 45',
2389.65
);


-- OUTRO EXEMPLO
INSERT INTO T_SIP_PROJETO
	VALUES (1001, 'PROJETO ABC', TO_DATE('26/05/2020','DD/MM/YYYY')
	, TO_DATE('10/03/2021','DD/MM/YYYY'));


COMMIT; -- EFETIVA A EFETIVAÇÃO NO DISCO DAQUILO QUE FOI FEITO (INSERT, UPDATE, DELETE)

-----------------------------------------------------------------------------------------
-- UPDATE
-- UPDATE -> ALTERAR UMA OU MAIS COLUNAS DE UMA TABELA, AFETANDO UMA OU MAIS LINHAS
-- ATUALIZAR DUAS OU MAIS COLUNAS EM UM COMANDO DE ATUALIZACAO
-- ALTERAR O NOME E A DATA DE NASCIMENTO DE UM FUNCIONARIO ESPECIFICO
-- CUIDADO! UPDATE SEM WHERE -> ALTERAR TODAS AS LINHAS DA TABELA
-- WHERE (FILTRO) INDICA AS LINHAS QUE SERÃO ALTERADAS
UPDATE T_SIP_PROJETO
	SET NM_PROJETO = 'PROJETO ABC ALTERADO',
		DT_TERMINO = TO_DATE('26/05/2021', 'DD/MM/YYYY')
	WHERE CD_PROJETO = 1001;


-- ATUALIZAR O SALARIO DOS FUNCIONARIOS
-- TODOS OS FUNCIONARIOS IRÃO RECEBER UM AUMENTO DE 5%
UPDATE T_SIP_FUNCIONARIO
	SET VL_SALARIO = VL_SALARIO *1.05;

-- EQUIVALE VL_SALARIO = VL_SALARIO + (VL_SALARIO * 0.05)
-- NÃO TEMOS O WHERE (CONDICAO), POIS O AUMENTO SERÁ A TODOS FUNCIONARIOS
	
-- ATUALIZACAO UTILIZANDO SUBCONSULTA
-- ALTERAR A DATA TERMINO DOS PROJETOS QUE ESTÃO ARMAZENADOS NA TABELA PROJETO,
-- UTILIZANDO A DATA TERMINO QUE ESTÁ ARMAZENADO NO PROJETO FINALIZADO DE
-- CÓDIGO IGUAL A 1001, QUE ESTÁ NA TABELA COPIA DOS PROJETOS FINALIZADOS
UPDATE T_SIP_PROJETO
	SET DT_TERMINO = (SELECT DT_TERMINO FROM T_SIP_COPY_PROJETO_FIN 
					  WHERE CD_PROJETO = 1001);

	
-----------------------------------------------------------------------------------------
-- DELETE
-- PARA ELIMINAR UMA OU MAIS LINHAS DA TABELA
-- OU TODAS AS LINHAS TABELA
-- CUIDADO! DELETE SEM WHERE -> APAGA TODAS AS LINHAS DA TABELA
-- WHERE (FILTRO) INDICA AS LINHAS QUE SERÃO APAGADAS
DELETE FROM T_SIP_DEPTO
	WHERE CD_DEPTO = 2;

-- ELIMINAR OS FUNCIONARIOS DO DEPTO FINANCEIRO (COD=1) E QUE
-- FORAM ADMITIDOS A PARTIR DE 2012
DELETE FROM T_SIP_FUNCIONARIO
	WHERE CD_DEPTO = 1
		AND DT_ADMISSAO >= TO_DATE('01/01/2012','DD/MM/YYYY');
		
-- DELEÇÃO COM SUBCONSULTA
-- ELIMINAR O PROJETO NA TABELA PROJETO, CORRESPONDENTE AO PROJETO QUE FOI
-- COPIADO PARA A TABELA COPY_PROJETO_FIN
DELETE FROM T_SIP_PROJETO
	WHERE CD_PROJETO = (SELECT CD_PROJETO FROM T_SIP_COPY_PROJETO_FIN
						WHERE CD_PROJETO = 1001);
						
						
-------------------------------------------------------------------------------------------
-- EXEMPLO COM ROLLBACK
DELETE FROM T_SIP_PROJETO;
-- DESFFAZ A TRANSAÇÃO (INSERT/UPDATE/DELETE)
ROLLBACK; -- FUNCIONA SE NÃO TIVERMOS DADO COMMIT