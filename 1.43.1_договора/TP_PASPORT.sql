ALTER TABLE KURS3.TP_PASPORT
 DROP PRIMARY KEY CASCADE;

DROP TABLE KURS3.TP_PASPORT CASCADE CONSTRAINTS;

CREATE TABLE KURS3.TP_PASPORT
(
  TP_ID        NUMBER                           NOT NULL,
  SOURCE_ID    NUMBER,
  REGNUM       VARCHAR2(30 BYTE),
  REGDATE      DATE,
  INVENT_NUM   VARCHAR2(30 BYTE),
  USER_ID      NUMBER,
  DATE_CHANGE  DATE
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

COMMENT ON TABLE KURS3.TP_PASPORT IS 'Атрибуты технического паспорта ';

COMMENT ON COLUMN KURS3.TP_PASPORT.TP_ID IS 'Идентификатор паспорта';

COMMENT ON COLUMN KURS3.TP_PASPORT.SOURCE_ID IS 'Источник поступления (кл.133)';

COMMENT ON COLUMN KURS3.TP_PASPORT.REGNUM IS 'Регистрационный номер ТП';

COMMENT ON COLUMN KURS3.TP_PASPORT.REGDATE IS 'Дата регистрации ТП';

COMMENT ON COLUMN KURS3.TP_PASPORT.INVENT_NUM IS 'Инвентарный номер дела';

COMMENT ON COLUMN KURS3.TP_PASPORT.USER_ID IS 'Пользователь сформировавший ТП';

COMMENT ON COLUMN KURS3.TP_PASPORT.DATE_CHANGE IS 'Дата ввода пользователем ТП ';



CREATE UNIQUE INDEX KURS3.TECHPASPORT_PK ON KURS3.TP_PASPORT
(TP_ID)
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


CREATE OR REPLACE TRIGGER KURS3."UPD#TGR_TECHPASPORT" 
BEFORE UPDATE
ON KURS3.TP_PASPORT 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
/******************************************************************************
   NAME:       UPD#TGR_WORKPLACE
   PURPOSE:    
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        29.10.2012      ilonis       1. Created this trigger.
******************************************************************************/
BEGIN
      :New.date_change:=sysdate;
END UPD#TGR_TECHPASPORT;
/


CREATE OR REPLACE TRIGGER KURS3."INS#TRG_TECHPASPORT" 
BEFORE INSERT
ON KURS3.TP_PASPORT 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
--declare   tmpVar number;
/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        29.10.2012      ilonis       1. Created this trigger.
******************************************************************************/
BEGIN

   if  (:New.TP_ID is null)  then
        select  SEQ_TP_PASPORT.NextVal into :New.TP_ID from  dual;
     end if; 
   :New.date_change:=sysdate;
                
     
  -- select SEQ_TECHPASPORT.NextVal into tmpVar from dual;
  --:New.TECHPASPORT_ID:=tmpVar;
  
END INS#TRG_TECHPASPORT;
/


ALTER TABLE KURS3.TP_PASPORT ADD (
  CONSTRAINT TECHPASPORT_PK
  PRIMARY KEY
  (TP_ID)
  USING INDEX KURS3.TECHPASPORT_PK);

ALTER TABLE KURS3.TP_PASPORT ADD (
  CONSTRAINT TECHPASPORT_R01 
  FOREIGN KEY (USER_ID) 
  REFERENCES KURS3.USERS (USER_ID));
