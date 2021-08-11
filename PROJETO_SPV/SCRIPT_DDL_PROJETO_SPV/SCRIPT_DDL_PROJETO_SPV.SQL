
/*
DROP TABLE t_spv_classif_fiscal CASCADE CONSTRAINTS;

DROP TABLE t_spv_cliente CASCADE CONSTRAINTS;

DROP TABLE t_spv_item_nf CASCADE CONSTRAINTS;

DROP TABLE t_spv_nota_fiscal CASCADE CONSTRAINTS;

DROP TABLE t_spv_produto CASCADE CONSTRAINTS;

DROP TABLE t_spv_unid_cml CASCADE CONSTRAINTS;
*/

CREATE TABLE t_spv_classif_fiscal (
    nr_cfop               NUMBER(4) NOT NULL,
    ds_tipo_operacao      NUMBER(1) NOT NULL,
    nm_natureza_operacao  VARCHAR2(30) NOT NULL,
    ds_natureza_operacao  VARCHAR2(200) NOT NULL
);

COMMENT ON COLUMN t_spv_classif_fiscal.ds_tipo_operacao IS
    '1 - ENTRADA
	 2 - SAIDA';

ALTER TABLE t_spv_classif_fiscal
    ADD CONSTRAINT ck_spv_clfiscal_tipoop CHECK ( ds_tipo_operacao = 1
                                                  OR ds_tipo_operacao = 2 );

ALTER TABLE t_spv_classif_fiscal ADD CONSTRAINT pk_spv_classif_fiscal PRIMARY KEY ( nr_cfop );

ALTER TABLE t_spv_classif_fiscal ADD CONSTRAINT un_spv_clfiscal_nome UNIQUE ( nm_natureza_operacao );

CREATE TABLE t_spv_cliente (
    cd_cliente     NUMBER(5) NOT NULL,
    nm_cliente     VARCHAR2(60) NOT NULL,
    dt_nascimento  DATE,
    ds_genero      CHAR(2) NOT NULL,
    nr_cpf         NUMBER(9) NOT NULL,
    nr_cpf_digito  NUMBER(2) NOT NULL,
    nr_rg          NUMBER(8) NOT NULL,
    nr_rg_digito   CHAR(1) NOT NULL,
    ds_endereco    VARCHAR2(100) NOT NULL,
    nr_telefone    NUMBER(11),
    ds_email       VARCHAR2(60)
);

ALTER TABLE t_spv_cliente
    ADD CONSTRAINT ck_spv_cliente_genero CHECK ( upper(ds_genero) IN ( 'H', 'M', 'NB' ) );

ALTER TABLE t_spv_cliente ADD CONSTRAINT pk_spv_cliente PRIMARY KEY ( cd_cliente );

CREATE TABLE t_spv_item_nf (
    nr_nota_fiscal     NUMBER(5) NOT NULL,
    cd_produto         NUMBER(5) NOT NULL,
    qt_comercializada  NUMBER(4) NOT NULL,
    vl_preco_unit      NUMBER(7, 2) NOT NULL,
    vl_total_item      NUMBER(8, 2) NOT NULL
);

ALTER TABLE t_spv_item_nf ADD CONSTRAINT ck_spv_itemnf_qtde CHECK ( qt_comercializada > 0 );

ALTER TABLE t_spv_item_nf ADD CONSTRAINT ck_spv_itemnf_preuni CHECK ( vl_preco_unit > 0 );

ALTER TABLE t_spv_item_nf ADD CONSTRAINT pk_spv_item_nf PRIMARY KEY ( cd_produto,nr_nota_fiscal );

CREATE TABLE t_spv_nota_fiscal (
    nr_nota_fiscal  NUMBER(5) NOT NULL,
    cd_cliente      NUMBER(5) NOT NULL,
    nr_cfop         NUMBER(4) NOT NULL,
    dt_emissao      DATE NOT NULL,
    dt_saida        DATE NOT NULL,
    vl_total_nf     NUMBER(9, 2) NOT NULL,
    vl_desconto     NUMBER(3, 1) NOT NULL
);

COMMENT ON COLUMN t_spv_nota_fiscal.vl_desconto IS
    'RN21 – O valor do desconto praticado por nossa empresa varia de 0,0% a 25,0%, nunca ultrapassando este valor. Quando nenhum desconto for praticado, deve-se armazenar ZERO.
|1| - ESCALA = 1
DESCONTO = 25,0
| 3 | PRECISAO=3
DESCONTO = 12,5%';

ALTER TABLE t_spv_nota_fiscal
    ADD CONSTRAINT ck_spv_nf_desconto CHECK ( vl_desconto >= 0 AND vl_desconto <= 25 );

ALTER TABLE t_spv_nota_fiscal ADD CONSTRAINT ck_spv_nf_data CHECK ( dt_saida >= dt_emissao );

ALTER TABLE t_spv_nota_fiscal ADD CONSTRAINT pk_spv_nota_fiscal PRIMARY KEY ( nr_nota_fiscal );

CREATE TABLE t_spv_produto (
    cd_produto           NUMBER(5) NOT NULL,
    cd_unid_cml          NUMBER(3) NOT NULL,
    ds_produto           VARCHAR2(40) NOT NULL,
    ds_produto_completa  VARCHAR2(100) NOT NULL,
    qt_estoque           NUMBER(4) NOT NULL,
    vl_preco_unit        NUMBER(7, 2) NOT NULL
);

ALTER TABLE t_spv_produto ADD CONSTRAINT ck_spv_produto CHECK ( vl_preco_unit > 0 );

ALTER TABLE t_spv_produto ADD CONSTRAINT pk_spv_produto PRIMARY KEY ( cd_produto );

ALTER TABLE t_spv_produto ADD CONSTRAINT un_spv_produto_desc UNIQUE ( ds_produto );

CREATE TABLE t_spv_unid_cml (
    cd_unid_cml  NUMBER(3) NOT NULL,
    sg_unid_cml  CHAR(6) NOT NULL,
    ds_unid_cml  VARCHAR2(30) NOT NULL
);

ALTER TABLE t_spv_unid_cml ADD CONSTRAINT pk_spv_unid_cml PRIMARY KEY ( cd_unid_cml );

ALTER TABLE t_spv_unid_cml ADD CONSTRAINT un_spv_unidcml_desc UNIQUE ( ds_unid_cml );

ALTER TABLE t_spv_item_nf
    ADD CONSTRAINT fk_spv_itemnf_nf FOREIGN KEY ( nr_nota_fiscal )
        REFERENCES t_spv_nota_fiscal ( nr_nota_fiscal );

ALTER TABLE t_spv_item_nf
    ADD CONSTRAINT fk_spv_itemnf_produto FOREIGN KEY ( cd_produto )
        REFERENCES t_spv_produto ( cd_produto );

ALTER TABLE t_spv_nota_fiscal
    ADD CONSTRAINT fk_spv_nf_classif_fiscal FOREIGN KEY ( nr_cfop )
        REFERENCES t_spv_classif_fiscal ( nr_cfop );

ALTER TABLE t_spv_nota_fiscal
    ADD CONSTRAINT fk_spv_nf_cliente FOREIGN KEY ( cd_cliente )
        REFERENCES t_spv_cliente ( cd_cliente );

ALTER TABLE t_spv_produto
    ADD CONSTRAINT fk_spv_produto_unidcml FOREIGN KEY ( cd_unid_cml )
        REFERENCES t_spv_unid_cml ( cd_unid_cml );
