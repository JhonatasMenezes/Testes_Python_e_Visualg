-- CRIANDO UMA TABELA
CREATE TABLE TB_CARRO (
    CODIGO  NUMBER(10)      PRIMARY KEY NOT NULL
,   NOME    VARCHAR2(50)    UNIQUE NOT NULL
,   MARCA   VARCHAR2(20)
,   TIPO    CHAR(20)
,   ANO_FAB DATE            DEFAULT SYSDATE
);

-- CRIAR TABELA CLONE PARA AUDITORIA
CREATE TABLE TB_CARRO_AUDIT AS (
SELECT * FROM TB_CARRO);

-- ADICIONAR CAMPOS PARA INFORMA��ES DE AUDITORIA
ALTER TABLE TB_CARRO_AUDIT MODIFY  
DATA_MANIPUL DATE DEFAULT SYSDATE;
ALTER TABLE TB_CARRO_AUDIT ADD  
TIPO_MANIPUL VARCHAR2(50);
ALTER TABLE TB_CARRO_AUDIT ADD  
USU�RIO CHAR(10);

-- CRIAR TRIGGER PARA GERAR AS INFROMA��ES DE AUDITORIA
CREATE OR REPLACE TRIGGER TRG_TB_CARRO
BEFORE INSERT OR UPDATE OR DELETE ON TB_CARRO
FOR EACH ROW

DECLARE

BEGIN 
IF INSERTING THEN
  INSERT INTO TB_CARRO_AUDIT
  VALUES (:NEW.CODIGO,:NEW.NOME,
          :NEW.MARCA,:NEW.TIPO,:NEW.ANO_FAB,SYSDATE,
          'INSERT',USER);
ELSIF UPDATING THEN 
  INSERT INTO TB_CARRO_AUDIT
  VALUES (:NEW.CODIGO,:NEW.NOME,
          :NEW.MARCA,:NEW.TIPO,:NEW.ANO_FAB,SYSDATE,
          'INSERT',USER);
  INSERT INTO TB_CARRO_AUDIT
  VALUES (:OLD.CODIGO,:OLD.NOME,
          :OLD.MARCA,:OLD.TIPO,:OLD.ANO_FAB,SYSDATE,
          'INSERT',USER);
        
ELSIF DELETING THEN
  INSERT INTO TB_CARRO_AUDIT
  VALUES (:OLD.CODIGO,:OLD.NOME,
          :OLD.MARCA,:OLD.TIPO,:OLD.ANO_FAB,SYSDATE,
          'INSERT',USER);
END IF;
END;

-- INSERIR DADOS NA TABELA
INSERT INTO TB_CARRO VALUES(
4,'COROLLA','TOYOTA','SEDAN EXECUTIVO','01/01/17'
);