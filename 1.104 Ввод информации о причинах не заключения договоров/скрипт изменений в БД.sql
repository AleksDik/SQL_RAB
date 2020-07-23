--Новые поля KURS3.APARTMENT

ALTER TABLE KURS3.APARTMENT
ADD (Cause_nd NUMBER);
COMMENT ON COLUMN 
KURS3.APARTMENT.Cause_nd IS 
'Причина не заключения договора (из классификатора Classifier_KURS3 кл.146)';

ALTER TABLE KURS3.APARTMENT
ADD (Comment_Causeof_nd VARCHAR2(128 CHAR));
COMMENT ON COLUMN 
KURS3.APARTMENT.Comment_Causeof_nd IS 
'Комментарии о причине не заключения договора';

ALTER TABLE KURS3.APARTMENT
ADD (Date_Causeof_nd DATE);
COMMENT ON COLUMN 
KURS3.APARTMENT.Date_Causeof_nd IS 
'Дата последнего изменения, заполняется и сохраняется автоматически текущей датой';


-- ====== Завести новый справочник (Причины не заключения договоров) в перечень справочников (91) ==
--проверить
select *
 from CLASSIFIER_KURS3 cl 
where classifier_num = 91
order by row_num desc;
-- Завести
INSERT INTO CLASSIFIER_KURS3 
SELECT 
   91 as CLASSIFIER_NUM, 
 (select Max(cl.row_num)+1 from CLASSIFIER_KURS3 cl where classifier_num = 91) 
      as ROW_NUM, 
   sysdate as LAST_CHANGE, 
   1 as ROW_STATUS, 
   'Причины не заключения договоров' as NAME, 
   NULL as SHORT_NAME1,
   NULL as SHORT_NAME2, 
   NULL as SHORT_NAME3, 
   0 as  DELETED 
FROM DUAL;
Commit;
--проверить (146)
select cl.*,cl.rowid
 from CLASSIFIER_KURS3 cl 
where classifier_num = 91
order by row_num desc

-- === Завести строки в новый справочник (146) ==
--проверить
select t.* ,t.rowid from CLASSIFIER_KURS3 t
where classifier_num = (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91) 
-- Завести
INSERT INTO CLASSIFIER_KURS3 
SELECT 
 (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91)  as CLASSIFIER_NUM, 
  rownum as ROW_NUM, 
  sysdate as LAST_CHANGE, 
   1 as ROW_STATUS,
   Case rownum
       when 1 then 'Причина не заключения 1'
       when 2 then 'Причина не заключения 2'
       when 3 then 'Причина не заключения 3' 
    end      
   as NAME, 
   Case rownum
       when 1 then 'Причина 1'
       when 2 then 'Причина 2'
       when 3 then 'Причина 3' 
    end   
    as SHORT_NAME1, 
NULL  
    as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL100 where rownum<4 ;
commit;
--проверить
select t.*, t.rowid from CLASSIFIER_KURS3 t
where classifier_num=(select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91) 
-- ============================================

--==Поля для отображения в списке V_HOUSING_LIST *==========
/*
V_HOUSING_LIST CAUSE_ND COMMENT_CAUSEOF_ND DATE_CAUSEOF_ND

Договор_НЗ_Причина - причина не заключения договора - CAUSE_ND
Договор_НЗ_Примечание - уточнение причины не заключения договора - COMMENT_CAUSEOF_ND
Договор_НЗ_Д.изм. - дата корректировки причины не заключения договора DATE_CAUSEOF_ND
*/

--проверить
select *
FROM LIST_FIELDS L
where L.LIST_COD=3 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 3);

-- Завести
insert into LIST_FIELDS 
(SELECT 
 3 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 3) as FIELD_ID, 
'Договор_НЗ_Причина' as FIELD_TITLE, 
90 as  FIELD_W, 
2 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'CAUSE_ND' as  FIELD_NAME,
'V_HOUSING_LIST' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual
union
SELECT 
 3 as LIST_COD, 
(select Max(FIELD_ID)+2 from LIST_FIELDS where LIST_COD = 3) as FIELD_ID, 
'Договор_НЗ_Примечание' as FIELD_TITLE, 
90 as  FIELD_W, 
2 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'COMMENT_CAUSEOF_ND' as  FIELD_NAME,
'APARTMENT' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual
union
SELECT 
 3 as LIST_COD, 
(select Max(FIELD_ID)+3 from LIST_FIELDS where LIST_COD = 3) as FIELD_ID, 
'Договор_НЗ_Д.изм.' as FIELD_TITLE, 
100 as  FIELD_W, 
3 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'DATE_CAUSEOF_ND' as  FIELD_NAME,
'APARTMENT' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual
);
commit;
-- Проверить --
select L.rowid,L.*
FROM LIST_FIELDS L
where L.LIST_COD=3 
order by L.FIELD_ID desc;

--- добавить поля в V_HOUSING_LIST  - CAUSE_ND, COMMENT_CAUSEOF_ND, DATE_CAUSEOF_ND

--==Поля для отображения в списке Ордеров V_ORDER_LIST (LIST_COD=6) *==========
/*
V_ORDER_LIST CAUSE_ND COMMENT_CAUSEOF_ND DATE_CAUSEOF_ND

Договор_НЗ_Причина - причина не заключения договора - CAUSE_ND
Договор_НЗ_Примечание - уточнение причины не заключения договора - COMMENT_CAUSEOF_ND
Договор_НЗ_Д.изм. - дата корректировки причины не заключения договора DATE_CAUSEOF_ND
*/

--проверить
select *
FROM LIST_FIELDS L
where L.LIST_COD=6 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 6);

-- Завести
insert into LIST_FIELDS 
(SELECT 
6 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 6) as FIELD_ID, 
'Договор_НЗ_Причина' as FIELD_TITLE, 
90 as  FIELD_W, 
2 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'CAUSE_ND' as  FIELD_NAME,
'V_ORDER_LIST' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual
union
SELECT 
6 as LIST_COD, 
(select Max(FIELD_ID)+2 from LIST_FIELDS where LIST_COD = 6) as FIELD_ID, 
'Договор_НЗ_Примечание' as FIELD_TITLE, 
90 as  FIELD_W, 
2 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'COMMENT_CAUSEOF_ND' as  FIELD_NAME,
'V_ORDER_LIST' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual
union
SELECT 
6 as LIST_COD, 
(select Max(FIELD_ID)+3 from LIST_FIELDS where LIST_COD = 6) as FIELD_ID, 
'Договор_НЗ_Д.изм.' as FIELD_TITLE, 
70 as  FIELD_W, 
3 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'DATE_CAUSEOF_ND' as  FIELD_NAME,
'V_ORDER_LIST' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual
);
commit;
-- Проверить --
select L.rowid,L.*
FROM LIST_FIELDS L
where L.LIST_COD=6 
order by L.FIELD_ID desc;

--- добавить поля в V_ORDER_LIST  - CAUSE_ND, COMMENT_CAUSEOF_ND, DATE_CAUSEOF_ND

*/
--	Переименование привилегии 109 «Причина незаселения» в «Ввод информации о причинах незаселения или не заключения договоров»;
update PRIV_TYPES p
set p.priv_name = 'Ввод информации о причинах незаселения или не заключения договоров'
where p.priv_id=109;
commit;
--  ======Синонимы  и права на пакет PKG_APARTMENT
CREATE SYNONYM KURS3.K3_PKG_APARTMENT FOR KURS3.PKG_APARTMENT;
CREATE SYNONYM KURSIV.K3_PKG_APARTMENT FOR KURS3.PKG_APARTMENT;
CREATE SYNONYM O51.K3_PKG_APARTMENT FOR KURS3.PKG_APARTMENT;
CREATE SYNONYM O52.K3_PKG_APARTMENT FOR KURS3.PKG_APARTMENT;
CREATE SYNONYM O53.K3_PKG_APARTMENT FOR KURS3.PKG_APARTMENT;
CREATE SYNONYM O54.K3_PKG_APARTMENT FOR KURS3.PKG_APARTMENT;
CREATE SYNONYM O55.K3_PKG_APARTMENT FOR KURS3.PKG_APARTMENT;
CREATE SYNONYM O56.K3_PKG_APARTMENT FOR KURS3.PKG_APARTMENT;
CREATE SYNONYM O57.K3_PKG_APARTMENT FOR KURS3.PKG_APARTMENT;
CREATE SYNONYM O58.K3_PKG_APARTMENT FOR KURS3.PKG_APARTMENT;
CREATE SYNONYM O59.K3_PKG_APARTMENT FOR KURS3.PKG_APARTMENT;
CREATE SYNONYM O60.K3_PKG_APARTMENT FOR KURS3.PKG_APARTMENT;
CREATE SYNONYM O61.K3_PKG_APARTMENT FOR KURS3.PKG_APARTMENT;
CREATE SYNONYM O62.K3_PKG_APARTMENT FOR KURS3.PKG_APARTMENT;
CREATE SYNONYM O63.K3_PKG_APARTMENT FOR KURS3.PKG_APARTMENT;

GRANT EXECUTE ON KURS3.PKG_APARTMENT TO KURSIV;
GRANT EXECUTE ON KURS3.PKG_APARTMENT TO O51;
GRANT EXECUTE ON KURS3.PKG_APARTMENT TO O52;
GRANT EXECUTE ON KURS3.PKG_APARTMENT TO O53;
GRANT EXECUTE ON KURS3.PKG_APARTMENT TO O54;
GRANT EXECUTE ON KURS3.PKG_APARTMENT TO O55;
GRANT EXECUTE ON KURS3.PKG_APARTMENT TO O56;
GRANT EXECUTE ON KURS3.PKG_APARTMENT TO O57;
GRANT EXECUTE ON KURS3.PKG_APARTMENT TO O58;
GRANT EXECUTE ON KURS3.PKG_APARTMENT TO O59;
GRANT EXECUTE ON KURS3.PKG_APARTMENT TO O60;
GRANT EXECUTE ON KURS3.PKG_APARTMENT TO O61;
GRANT EXECUTE ON KURS3.PKG_APARTMENT TO O62;
GRANT EXECUTE ON KURS3.PKG_APARTMENT TO O63;

/* DELPHI: добавить в uListsKurs3wo ,FreeFloorU, uReasonNSAgr-новая
  ORACLE:
   PACKAGE  pkg_apartment
   PROCEDURE kursiv.do_for_tfreefloor
   PROCEDURE kursiv.do_for_tkurslists
*/

-- =============== ОТБОР по новым полям  V_HOUSING_LIST  (LIST_COD = 3) ========================
/*
Договор_НЗ_Причина  – выбор из нового классификатора «Причины не заключения договоров»;
Договор_НЗ_Д.изм.- выбор условия фильтрации из: =, <, <=, >, >= и проставление даты вручную / выбор значения из календаря.

*/
 -- =============Условия отбора Договор_НЗ_Причина ==============
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID>6009 and LIST_COD = 3
order by COND_ID desc
-- Завести в LIST_CONDITIONS
insert into LIST_CONDITIONS 
SELECT 
   6010  as COND_ID, --!!
   3 as LIST_COD, 
   'Договор_НЗ_Причина' as COND_NAME, 
   2 as COND_TYPE, --выбор из списка
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP)+10 from LIST_CONDITIONS where LIST_COD = 3 )  as COND_GROUP, --Новая группа условий
   1 as STATUS from dual;
   commit;
 -- =============Условия отбора Договор_НЗ_Д.изм. ==============   
insert into LIST_CONDITIONS 
SELECT 
   6011  as COND_ID, --!!
   3 as LIST_COD, 
   'Договор_НЗ_Д.изм.' as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 3 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;
   
insert into LIST_CONDITIONS 
SELECT 
   6012  as COND_ID, --!!
   3 as LIST_COD, 
   'Договор_НЗ_Д.изм.' as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 3 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   6013  as COND_ID, --!!
   3 as LIST_COD, 
   'Договор_НЗ_Д.изм.' as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 3 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   6014  as COND_ID, --!!
   3 as LIST_COD, 
   'Договор_НЗ_Д.изм.' as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 3 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   6015  as COND_ID, --!!
   3 as LIST_COD, 
   'Договор_НЗ_Д.изм.' as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 3 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   6016  as COND_ID, --!!
   3 as LIST_COD, 
   'Договор_НЗ_Д.изм.' as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 3 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;               
   
-- Проверить --
select *
--delete
from LIST_CONDITIONS
where COND_ID >= 6010 and 
LIST_COD = 3

--====== Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
6010 as COND_ID, --!!
3 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'APARTMENT'  as TABLE_NAME,
'CAUSE_ND'  as FIELD_NAME,
'CLASSIFIER_NUM=K3_PKG_APARTMENT.get_R_NSAgr and DELETED=0'
 as DICT_WHERE,
'CLASSIFIER_KURS3' as DICT_NAME,
'SHORT_NAME1 /*&& ,ROW_NUM ID*/' as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
------------------------ DATE_CAUSEOF_ND -------------------------
INSERT INTO OPERATION_TYPES 
(
SELECT 
6011 as COND_ID, --!!
3 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
3 as FIELD_TYPE , -- date
'APARTMENT'  as TABLE_NAME,
'DATE_CAUSEOF_ND'  as FIELD_NAME, 
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;

INSERT INTO OPERATION_TYPES 
(
SELECT 
6012 as COND_ID, --!!
3 as LIST_COD,
2 as OPERATION_COD, 
'>' as OPERATION_NAME,   
3 as FIELD_TYPE , -- date
'APARTMENT'  as TABLE_NAME,
'DATE_CAUSEOF_ND'  as FIELD_NAME, 
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
INSERT INTO OPERATION_TYPES 
(
SELECT 
6013 as COND_ID, --!!
3 as LIST_COD,
3 as OPERATION_COD, 
'>=' as OPERATION_NAME,   
3 as FIELD_TYPE , -- date
'APARTMENT'  as TABLE_NAME,
'DATE_CAUSEOF_ND'  as FIELD_NAME, 
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
INSERT INTO OPERATION_TYPES 
(
SELECT 
6014 as COND_ID, --!!
3 as LIST_COD,
4 as OPERATION_COD, 
'<' as OPERATION_NAME,   
3 as FIELD_TYPE , -- date
'APARTMENT'  as TABLE_NAME,
'DATE_CAUSEOF_ND'  as FIELD_NAME, 
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
INSERT INTO OPERATION_TYPES 
(
SELECT 
6015 as COND_ID, --!!
3 as LIST_COD,
5 as OPERATION_COD, 
'<=' as OPERATION_NAME,   
3 as FIELD_TYPE , -- date
'APARTMENT'  as TABLE_NAME,
'DATE_CAUSEOF_ND'  as FIELD_NAME, 
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
INSERT INTO OPERATION_TYPES 
(
SELECT 
6016 as COND_ID, --!!
3 as LIST_COD,
6 as OPERATION_COD, 
'<>' as OPERATION_NAME,   
3 as FIELD_TYPE , -- date
'APARTMENT'  as TABLE_NAME,
'DATE_CAUSEOF_ND'  as FIELD_NAME, 
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;

-- Проверить что вставили  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID >6009
and t.list_cod=3

-- =============== ОТБОР по новым полям   V_ORDER_LIST LIST_COD=6  ========================
/*
Договор_НЗ_Причина  – выбор из нового классификатора «Причины не заключения договоров»;
Договор_НЗ_Д.изм.- выбор условия фильтрации из: =, <, <=, >, >= и проставление даты вручную / выбор значения из календаря.
*/
 -- =============Условия отбора Договор_НЗ_Причина ==============
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID>6009 and LIST_COD = 6
order by COND_ID desc
-- Завести в LIST_CONDITIONS
insert into LIST_CONDITIONS 
SELECT 
   6010  as COND_ID, --!!
   6 as LIST_COD, 
   'Договор_НЗ_Причина' as COND_NAME, 
   2 as COND_TYPE, --выбор из списка
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP)+10 from LIST_CONDITIONS where LIST_COD = 6 )  as COND_GROUP, --Новая группа условий
   1 as STATUS from dual;
   commit;
 -- =============Условия отбора Договор_НЗ_Д.изм. ==============   
insert into LIST_CONDITIONS 
SELECT 
   6011  as COND_ID, --!!
   6 as LIST_COD, 
   'Договор_НЗ_Д.изм.' as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 6 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;
   
insert into LIST_CONDITIONS 
SELECT 
   6012  as COND_ID, --!!
   6 as LIST_COD, 
   'Договор_НЗ_Д.изм.' as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 6 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   6013  as COND_ID, --!!
   6 as LIST_COD, 
   'Договор_НЗ_Д.изм.' as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 6 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   6014  as COND_ID, --!!
  6 as LIST_COD, 
   'Договор_НЗ_Д.изм.' as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 6 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   6015  as COND_ID, --!!
  6 as LIST_COD, 
   'Договор_НЗ_Д.изм.' as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 6 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   6016  as COND_ID, --!!
   6 as LIST_COD, 
   'Договор_НЗ_Д.изм.' as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 6 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;               
   
-- Проверить --
select *
--delete
from LIST_CONDITIONS
where COND_ID >= 6010 and 
LIST_COD = 6

--====== Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
6010 as COND_ID, --!!
6 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'DOCUMENT'  as TABLE_NAME,
'NVL((select ap.CAUSE_ND from apartment ap where DOCUMENT.apart_id = ap.apart_id),0)'  as FIELD_NAME,
'CLASSIFIER_NUM=K3_PKG_APARTMENT.get_R_NSAgr and DELETED=0'
 as DICT_WHERE,
'CLASSIFIER_KURS3' as DICT_NAME,
'SHORT_NAME1 /*&& ,ROW_NUM ID*/' as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
------------------------ DATE_CAUSEOF_ND -------------------------
INSERT INTO OPERATION_TYPES 
(
SELECT 
6011 as COND_ID, --!!
6 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
3 as FIELD_TYPE , -- date
'DOCUMENT'  as TABLE_NAME,
'(select Trunc(ap.DATE_CAUSEOF_ND) from apartment ap where DOCUMENT.apart_id = ap.apart_id)'  as FIELD_NAME, 
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;

INSERT INTO OPERATION_TYPES 
(
SELECT 
6012 as COND_ID, --!!
6 as LIST_COD,
2 as OPERATION_COD, 
'>' as OPERATION_NAME,   
3 as FIELD_TYPE , -- date
'DOCUMENT'  as TABLE_NAME,
'(select Trunc(ap.DATE_CAUSEOF_ND) from apartment ap where DOCUMENT.apart_id = ap.apart_id)'  as FIELD_NAME,  
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
INSERT INTO OPERATION_TYPES 
(
SELECT 
6013 as COND_ID, --!!
6 as LIST_COD,
3 as OPERATION_COD, 
'>=' as OPERATION_NAME,   
3 as FIELD_TYPE , -- date
'DOCUMENT'  as TABLE_NAME,
'(select Trunc(ap.DATE_CAUSEOF_ND) from apartment ap where DOCUMENT.apart_id = ap.apart_id)'  as FIELD_NAME,  
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
INSERT INTO OPERATION_TYPES 
(
SELECT 
6014 as COND_ID, --!!
6 as LIST_COD,
4 as OPERATION_COD, 
'<' as OPERATION_NAME,   
3 as FIELD_TYPE , -- date
'DOCUMENT'  as TABLE_NAME,
'(select Trunc(ap.DATE_CAUSEOF_ND) from apartment ap where DOCUMENT.apart_id = ap.apart_id)'  as FIELD_NAME, 
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
INSERT INTO OPERATION_TYPES 
(
SELECT 
6015 as COND_ID, --!!
6 as LIST_COD,
5 as OPERATION_COD, 
'<=' as OPERATION_NAME,   
3 as FIELD_TYPE , -- date
'DOCUMENT'  as TABLE_NAME,
'(select Trunc(ap.DATE_CAUSEOF_ND) from apartment ap where DOCUMENT.apart_id = ap.apart_id)'  as FIELD_NAME,  
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
INSERT INTO OPERATION_TYPES 
(
SELECT 
6016 as COND_ID, --!!
6 as LIST_COD,
6 as OPERATION_COD, 
'<>' as OPERATION_NAME,   
3 as FIELD_TYPE , -- date
'DOCUMENT'  as TABLE_NAME,
'(select Trunc(ap.DATE_CAUSEOF_ND) from apartment ap where DOCUMENT.apart_id = ap.apart_id)'  as FIELD_NAME,  
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;


-- Проверить что вставили  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID >6009
and t.list_cod=6
