-- COMANDOS SQL - DIVISÃO DDL (LINGUAGEM DE DEFINIÇÃO DE DADOS)
-- COMANDOS DDL - PERMITEM CRIAR A ESTRUTURA DO BD
-- CREATE TABLE - CRIAR A TABELA
-- ALTER TABLE - ALTERAR/MODIFICAR A ESTRUTURA DA TABELA
-- DROP TABLE - EXCLUIR A ESTRUTURA DA TABELA

-- SCRIPT -> ROTEIRO PASSO
-- SCRIPT DDL -> ROTEIRO PASSO A PASSO PARA CRIAR A ESTRUTURA DO BD

-- MATERIAL DE APOIO: _Aula12_ADS_BAD_DDL_01_RitaCRodrigues.PDF

-- BOA PRATICA DE PROGRAMAÇÃO (TRECHOS CURTOS DE CODIGO/ MAIS SIMPLES DE MANTER)
-- COMANDO CREATE -> CRIAR A ESTRUTURA BASICA (TABELA/CAMPOS/TIPO DADO/ OBRIGATORIO)
-- COMANDO ALTER -> ADICIONAR AS CONSTRAINTS (PK, UNIQUE, CHECK)
-- COMANDO ALTER -> ADICIONAR A CONSTRAINT FK (CHAVE ESTRANGEIRA) NO FINAL DO ARQUIVO
-- DEPOIS DE TODAS AS TABELAS E PK´S CRIADAS
-- OBS: SE VOCE TENTAR CRIAR UM FK (RELACIONAMENTO) E NAO TIVER A TABELA CORRESPONDENTE
-- A RELAÇÃO, DARÁ ERRO.

-- COMANDOS DDL -> NÃO SAO CASE SENSITIVE - NÃO FAZ DIFERENÇA ENTRE MAIUSCULA
-- E MINUSCULA

-- COMANDOS PARA ELIMINAR (APAGAR) AS TABELAS DE UM BD 
-- (APAGA A TABELA E O CONTEÚDO-REGISTROS SE EXISTIR)
-- PONTO DE ATENÇÃO: ELIMINAR RESPEITANDO AS DEPENDENCIAS DOS RELACIONAMENTOS. 
-- DE MODO QUE CADA TABELA DELETADA,
-- PRECISA ELIMINAR O RELACIONAMENTO, PARA QUE AS TABELAS DEPENDENTES SEJAM SOLTAS.

DROP TABLE T_SIP_DEPENDENTE			CASCADE CONSTRAINTS; -- OPÇÃO CASCADE CONSTRAINTS ELIMINA O RELACIONAMENTO
DROP TABLE T_SIP_IMPLANTACAO		CASCADE CONSTRAINTS;
DROP TABLE T_SIP_PROJETO			CASCADE CONSTRAINTS;
DROP TABLE T_SIP_FUNCIONARIO		CASCADE CONSTRAINTS;
DROP TABLE T_SIP_DEPTO				CASCADE CONSTRAINTS;

/*BLOCO DE COMENTARIO*/

-- CRIAR TABELA DEPTO
CREATE TABLE T_SIP_DEPTO
(
	CD_DEPTO		NUMBER(3)		NOT NULL,
	NM_DEPTO		VARCHAR2(40)	NOT NULL,
	SG_DEPTO		CHAR(3)			NOT NULL
);

-- ADICIONAR A CONSTRAINT CHAVE PRIMARIA (PK)
	ALTER TABLE T_SIP_DEPTO			-- QUAL TABELA SERÁ ALTERADA
ADD CONSTRAINT PK_SIP_DEPTO			-- ADICIONAR UMA CONSTRAINT / NOME CONSTRAINT
		PRIMARY KEY (CD_DEPTO);		-- TIPO DE CONSTRAINT (PK) / CAMPO QUE E PK
	
-- ADICIONAR A CONSTRAINT UNIQUE	
	ALTER TABLE T_SIP_DEPTO			-- QUAL TABELA SERÁ ALTERADA
ADD CONSTRAINT UN_SIP_DEPTO_NOME	-- ADICIONAR UMA CONSTRAINT / NOME CONSTRAINT
		UNIQUE (NM_DEPTO);			-- TIPO DE CONSTRAINT (UN) / CAMPO QUE E UN


-- CRIAR TABELA FUNCIONARIO
CREATE TABLE T_SIP_FUNCIONARIO
(
	NR_MATRICULA		NUMBER(5)		NOT NULL,
	CD_DEPTO			NUMBER(3)		NOT NULL,
	NM_FUNCIONARIO		VARCHAR2(60)	NOT NULL,
	DT_NASCIMENTO		DATE			NOT NULL,
	DT_ADMISSAO			DATE			NOT NULL,
	DS_ENDERECO			VARCHAR2(100)	NOT NULL,
	VL_SALARIO			NUMBER(7,2)		NOT NULL
);

-- ADICIONAR A CONSTRAINT CHAVE PRIMARIA (PK)
	ALTER TABLE T_SIP_FUNCIONARIO
ADD CONSTRAINT PK_SIP_FUNCIONARIO
	PRIMARY KEY (NR_MATRICULA);
-- ADICIONAR A CONSTRAINT CHECK (VALIDAÇÃO)
	ALTER TABLE T_SIP_FUNCIONARIO
ADD CONSTRAINT CK_SIP_FUNC_SALARIO
	CHECK (VL SALARIO >= 1045);

-- CRIAR TABELA DEPENDENTE
CREATE TABLE T_SIP_DEPENDENTE
(
NR_MATRICULA NUMBER(5) NOT NULL ,
CD_DEPENDENTE NUMBER(2) NOT NULL ,
NM_DEPENDENTE VARCHAR2(60) NOT NULL ,
DT_NASCIMENTO DATE NOT NULL
);
-- ADD A CONSTRAINT CHAVE PRIMARIA
	ALTER TABLE T_SIP_DEPENDENTE
ADD CONSTRAINT PK_SIP_DEPENDENTE
	PRIMARY KEY (CD_DEPENDENTE); -- CHAVE PRIMARIA COMPOSTA POR 2 CAMPOS


-- CRIAR A TABELA PROJETO
CREATE TABLE T_SIP_PROJETO
(
    CD_PROJETO		NUMBER (5)        NOT NULL,
    NM_PROJETO      VARCHAR2(40)      NOT NULL,
    DT_INICIO       DATE              NOT NULL,
    DT_TERMINO          DATE                  NULL
	-- CAMPO OPCIONAL: ESCREVER APENAS NULL, OU NÃO ESCREVER NADA
);
-- ADD A CONSTRAINT CHAVE PRIMARIA (PK)
	ALTER TABLE T_SIP_PROJETO
ADD CONSTRAINT T_SIP_PROJETO_NOME
		UNIQUE (NM_PROJETO);
-- ADD A CONSTRAINT CHECK (VALIDACAO)
	ALTER TABLE T_SIP_PROJETO
ADD CONSTRAINT CK_SIP_PROJETO_DATA
		 CHECK (DT_TERMINO > DT_INICIO);

-- CRIAR A TABELA IMPLANTACAO
CREATE TABLE T_SIP_IMPLANTACAO
(
	CD_PROJETO		NUMBER(5)		NOT NULL,
	CD_IMPLANTACAO	NUMBER(3)		NOT NULL,
	NR_MATRICULA	NUMBER(5)		NOT NULL,
	DT_ENTRADA		DATE 			NOT NULL,
	DT_SAIDA		DATE				NULL
);
-- ADD A CONSTRAINT CHAVE PRIMARIA (PK)
	ALTER TABLE T_SIP_IMPLANTACAO
ADD CONSTRAINT PK_SIP_IMPLANTACAO
	PRIMARY KEY (CD_PROJETO,CD_IMPLANTACAO);	
-- ADD A CONSTRAINT CHECK
	ALTER TABLE T_SIP_IMPLANTACAO
ADD CONSTRAINT CK_SIP_IMPLANT_DATA
		CHECK (DT_SAIDA > DT_ENTRADA);

---------------------------------------------------------------
-- CHAVES ESTRANGEIRAS - NO FINAL DO ARQUIVO SEMPRE -----------
---------------------------------------------------------------
-- PRECISAMOS DE TODAS AS TABELAS E CHAVES PRIMARIAS CRIADAS --
-- CASO CONTRARIO, NÃO E POSSÍVEL CRIAR OS RELACIONAMENTOS ----
---------------------------------------------------------------
-- ADICIONAR A CHAVE ESTRANGEIRA
-- REFERENTE AO RELACIONAMENTO ENTRE FUNCIONARIO (DESTINO) E DEPTO (ORIGEM)	
	ALTER TABLE T_SIP_FUNCIONARIO -- COMANDO DE ALTERAÇÃO PARA INSERIR A CONSTRAINT FOREIGN KEY NA TABELA
ADD CONSTRAINT FK_SIP_FUNC_DEPTO  -- ADD A CONSTRAINT E INFORMAR O NOME DA CONSTRAINT
	FOREIGN KEY (CD_DEPTO)        -- NOME CAMPO CHAVE ESTRANGEIRA NA TABELA FUNCIONARIO (DESTINO)
		REFERENCES T_SIP_DEPTO    -- COM QUAL TABELA ORIGEM E FEITA A RELAÇÃO 
					(CD_DEPTO);   -- QUAL O CAMPO CHAVE PRIMARIA DA TABELA ORIGEM
	

-- RELACIONAMENTOS: DEPENDENTE E FUNCIONARIO
-- CHAVE ESTRANGEIRA
	ALTER TABLE T_SIP_DEPENDENTE
ADD CONSTRAINT FK_SIP_DEPENDENTE_FUNC
	FOREIGN KEY (NR_MATRICULA)
	REFERENCES T_SIP_FUNCIONARIO(NR_MATRICULA);
	
-- RELACIONAMENTOS: IMPLANTAÇÃO E PROJETO	
	ALTER TABLE T_SIP_IMPLANTACAO
ADD CONSTRAINT FK_SIP_IMPLANT_PROJETO
	FOREIGN KEY (CD_PROJETO)
	REFERENCES T_SIP_PROJETO(CD_PROJETO);

-- RELACIONAMENTOS: IMPLANTAÇÃO E FUNCIONARIO	
	ALTER TABLE T_SIP_IMPLANTACAO
ADD CONSTRAINT FK_SIP_IMPLANT_FUNC
	FOREIGN KEY (NR_MATRICULA)
	REFERENCES T_SIP_FUNCIONARIO(NR_MATRICULA);