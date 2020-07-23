ALTER TABLE KURS3.TP_TRAFFIC
 DROP PRIMARY KEY CASCADE;

DROP TABLE KURS3.TP_TRAFFIC CASCADE CONSTRAINTS;

CREATE TABLE KURS3.TP_TRAFFIC
(
  TP_TRAFFIC_ID       NUMBER                    NOT NULL,
  TP_ID               NUMBER,
  USER_ID             NUMBER,
  LAST_CHANGE         DATE,
  WORK_PLACE_LINK_ID  NUMBER,
  NSORT               NUMBER,
  TRAFFIC_DOC_ID      NUMBER
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

COMMENT ON TABLE KURS3.TP_TRAFFIC IS 'Информация о движении ТП ';

COMMENT ON COLUMN KURS3.TP_TRAFFIC.TP_ID IS 'Идентификатор паспорта';

COMMENT ON COLUMN KURS3.TP_TRAFFIC.USER_ID IS 'Имя пользователя';

COMMENT ON COLUMN KURS3.TP_TRAFFIC.LAST_CHANGE IS 'Дата изменения';

COMMENT ON COLUMN KURS3.TP_TRAFFIC.WORK_PLACE_LINK_ID IS 'Id из таблицы WORKPLACELINK для связи кл. 132, 134, 135';

COMMENT ON COLUMN KURS3.TP_TRAFFIC.NSORT IS 'сортировка(номер строки)';

COMMENT ON COLUMN KURS3.TP_TRAFFIC.TRAFFIC_DOC_ID IS 'ид акта';



CREATE UNIQUE INDEX KURS3.TECHPASPORT_TRAFFIC_PK ON KURS3.TP_TRAFFIC
(TP_TRAFFIC_ID)
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


CREATE OR REPLACE TRIGGER KURS3."UPD#TGR_TECHPASPORT_TRAFFIC" 
BEFORE UPDATE
ON KURS3.TP_TRAFFIC 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        29.10.2012      ilonis       1. Created this trigger.
******************************************************************************/
BEGIN
      :New.last_change:=sysdate;
END UPD#TGR_TECHPASPORT_TRAFFIC;
/


CREATE OR REPLACE TRIGGER KURS3."INS#TRG_TECHPASPORT_TRAFFIC" 
BEFORE INSERT
ON KURS3.TP_TRAFFIC 
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
/******************************************************************************
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        29.10.2012      ilonis       1. Created this trigger.
******************************************************************************/
BEGIN

    if  (:New.TP_TRAFFIC_ID is null)  then
        select  SEQ_TP_TRAFFIC.NextVal into :New.TP_TRAFFIC_ID from  dual;
     end if;
        
   :NEW.LAST_CHANGE:=sysdate;
  
END INS#TRG_TECHPASPORT_TRAFFIC;
/


ALTER TABLE KURS3.TP_TRAFFIC ADD (
  CONSTRAINT TECHPASPORT_TRAFFIC_PK
  PRIMARY KEY
  (TP_TRAFFIC_ID)
  USING INDEX KURS3.TECHPASPORT_TRAFFIC_PK);

ALTER TABLE KURS3.TP_TRAFFIC ADD (
  CONSTRAINT TECHPASPORT_TRAFFIC_R01 
  FOREIGN KEY (TP_ID) 
  REFERENCES KURS3.TP_PASPORT (TP_ID),
  CONSTRAINT TECHPASPORT_TRAFFIC_R02 
  FOREIGN KEY (USER_ID) 
  REFERENCES KURS3.USERS (USER_ID),
  CONSTRAINT TECHPASPORT_TRAFFIC_R03 
  FOREIGN KEY (WORK_PLACE_LINK_ID) 
  REFERENCES KURS3.TP_WORK_PLACE_LINK (WORK_PLACE_LINK_ID),
  CONSTRAINT TP_TRAFFIC_R04 
  FOREIGN KEY (TRAFFIC_DOC_ID) 
  REFERENCES KURS3.TP_TRAFFIC_DOC (TRAFFIC_DOC_ID));
