ALTER TABLE KURS3.TP_SIGNER
 DROP PRIMARY KEY CASCADE;

DROP TABLE KURS3.TP_SIGNER CASCADE CONSTRAINTS;

CREATE TABLE KURS3.TP_SIGNER
(
  SIGN_ID   NUMBER                              NOT NULL,
  FIO       VARCHAR2(100 BYTE),
  DOLGNOST  VARCHAR2(100 BYTE),
  P_SERIA   VARCHAR2(10 BYTE),
  P_NOMER   NUMBER,
  P_DATA    DATE,
  P_VIDAN   VARCHAR2(250 BYTE),
  D_NOMER   NUMBER,
  D_DATA    DATE,
  D_VIDAN   VARCHAR2(250 BYTE)
)
TABLESPACE KURS3
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE KURS3.TP_SIGNER IS '���� ������������� ��������� ��� �������� ��';

COMMENT ON COLUMN KURS3.TP_SIGNER.SIGN_ID IS '��';

COMMENT ON COLUMN KURS3.TP_SIGNER.FIO IS '��� ���� �������������� ���������';

COMMENT ON COLUMN KURS3.TP_SIGNER.DOLGNOST IS '���������';

COMMENT ON COLUMN KURS3.TP_SIGNER.P_SERIA IS '����� ��������(��������� �������. ��������)';

COMMENT ON COLUMN KURS3.TP_SIGNER.P_NOMER IS '����� ���������';

COMMENT ON COLUMN KURS3.TP_SIGNER.P_DATA IS '���� ������ ���������';

COMMENT ON COLUMN KURS3.TP_SIGNER.P_VIDAN IS '��� ����� ��������';

COMMENT ON COLUMN KURS3.TP_SIGNER.D_NOMER IS '����� ������������';

COMMENT ON COLUMN KURS3.TP_SIGNER.D_DATA IS '���� �����������';

COMMENT ON COLUMN KURS3.TP_SIGNER.D_VIDAN IS '��� ������ ������������';



CREATE UNIQUE INDEX KURS3.TP_SIGNER_PK ON KURS3.TP_SIGNER
(SIGN_ID)
LOGGING
TABLESPACE KURS3
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE KURS3.TP_SIGNER ADD (
  CONSTRAINT TP_SIGNER_PK
  PRIMARY KEY
  (SIGN_ID)
  USING INDEX KURS3.TP_SIGNER_PK);

GRANT DELETE, INSERT, SELECT, UPDATE ON KURS3.TP_SIGNER TO KURS3_ADM;

GRANT SELECT ON KURS3.TP_SIGNER TO OKRUG;
