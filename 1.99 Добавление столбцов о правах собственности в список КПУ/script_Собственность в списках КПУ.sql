--отображение инф. о правах собственности в списках КПУ 
-- ================== Новые поля для отображения в списках КПУ V_AFFAIRS_LIST ==========================
/* 
Собств_РСЖС       OWNERSHIP_RSGS
Собств_РСЖС_Д     OWNERSHIP_RSGS_DATE
Собств_РСЖС_Д_по  OWNERSHIP_RSGS_DATE_TO
Собств_ЕГРП       OWNERSHIP_EGRP_NUM
Собств_ЕГРП_Д     OWNERSHIP_EGRP_DATE
Собств_ЕГРП_Д_по  OWNERSHIP_EGRP_DATE_TO
Требования        REQUIREMENTS
*/

        
--==Поле Собств_РСЖС  ==========
-- Проверить --
select L.*, rowid
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);
-- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'Собств_РСЖС' as FIELD_TITLE, 
60 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'OWNERSHIP_RSGS' as  FIELD_NAME,
'V_AFFAIRS_LIST' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);

--==Поле Собств_РСЖС_Д  ==========
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);
-- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'Собств_РСЖС_Д' as FIELD_TITLE, 
65 as  FIELD_W, 
3 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'OWNERSHIP_RSGS_DATE' as  FIELD_NAME,
'V_AFFAIRS_LIST' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);

--==Поле Собств_РСЖС_Д_по  ==========
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);
-- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'Собств_РСЖС_Д_по' as FIELD_TITLE, 
65 as  FIELD_W, 
3 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'OWNERSHIP_RSGS_DATE_TO' as  FIELD_NAME,
'V_AFFAIRS_LIST' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);

       
--==Поле Собств_ЕГРП  ==========
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);
-- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'Собств_ЕГРП' as FIELD_TITLE, 
70 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'OWNERSHIP_EGRP_NUM' as  FIELD_NAME,
'V_AFFAIRS_LIST' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);

--==Поле Собств_ЕГРП_Д  ==========
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);
-- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'Собств_ЕГРП_Д' as FIELD_TITLE, 
65 as  FIELD_W, 
3 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'OWNERSHIP_EGRP_DATE' as  FIELD_NAME,
'V_AFFAIRS_LIST' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);

--==Поле Собств_ЕГРП_Д_по  ==========
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);
-- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'Собств_ЕГРП_Д_по' as FIELD_TITLE, 
65 as  FIELD_W, 
3 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'OWNERSHIP_EGRP_DATE_TO' as  FIELD_NAME,
'V_AFFAIRS_LIST' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);


--==Поле Требования  ==========
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);
-- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'Требования' as FIELD_TITLE, 
80 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'REQUIREMENTS' as  FIELD_NAME,
'V_AFFAIRS_LIST' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);


--Обновить CLASSIFIER_KURS3

update CLASSIFIER_KURS3
set SHORT_NAME1=UPPER(NAME)
where CLASSIFIER_NUM=104;
commit;
--проверить
select * 
from CLASSIFIER_KURS3
where CLASSIFIER_NUM=104


 -- =============Условия отбора по «Собств_РСЖС» ==============
-- Проверить --
select *
from LIST_CONDITIONS
where --COND_ID=6020 and 
LIST_COD = 1
order by COND_ID desc
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   --(select max(COND_ID)+1 from LIST_CONDITIONS where LIST_COD = 1) 
   6020  as COND_ID, 
   1 as LIST_COD, 
   'Собств_РСЖС' as COND_NAME, 
   2 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP)+10 from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
--delete
from LIST_CONDITIONS
where COND_ID=6020 and 
LIST_COD = 1


--===============================
 -- Посмотреть
select  t.*,t.rowid from OPERATION_TYPES t
where t.list_cod=1 and t.COND_ID<7000
order by t.COND_ID desc
-- Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
--(select max(L.COND_ID)FROM LIST_CONDITIONS L
--where L.LIST_COD=1 and L.COND_TYPE=2 ) 
6020 as COND_ID,
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE ,
'AFFAIR'  as TABLE_NAME,
'(select ROW_NUM from CLASSIFIER_KURS3 where CLASSIFIER_NUM=104 and SHORT_NAME1 = REPLACE(NVL(UPPER(TRIM(get_apartment_rgs_1(affair.apart_id,''APR_STATUS''))),''НЕТ''),''.'',''''))' as FIELD_NAME,
'CLASSIFIER_NUM=104 and DELETED=0'
 as DICT_WHERE,
'CLASSIFIER_KURS3' as DICT_NAME,
'NAME /*&& ,ROW_NUM ID*/' as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
-- Проверить что вставили  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID =6020-- (select max(L.COND_ID) FROM LIST_CONDITIONS L where L.LIST_COD=1)
and t.list_cod=1


-- =============Условия отбора по «РСЖС_Д_наличие» ==============
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6021 and 
LIST_COD = 1
order by COND_ID desc
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   --(select max(COND_ID)+1 from LIST_CONDITIONS where LIST_COD = 1) 
   6021  as COND_ID, 
   1 as LIST_COD, 
   'Собств_РСЖС_Д_наличие' as COND_NAME, 
   2 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
--delete
from LIST_CONDITIONS
where COND_ID=6021 and 
LIST_COD = 1


--===============================
 -- Посмотреть
select  t.*,t.rowid from OPERATION_TYPES t
where t.list_cod=1 and t.COND_ID<7000
order by t.COND_ID desc
-- Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
--(select max(L.COND_ID)FROM LIST_CONDITIONS L
--where L.LIST_COD=1 and L.COND_TYPE=2 ) 
6021 as COND_ID,
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE ,
'AFFAIR'  as TABLE_NAME,
'NVL2(SUBSTR (get_apartment_rgs_1 (affair.apart_id,''DATE_FROM''),1,30),1,2)' as FIELD_NAME,
'CLASSIFIER_NUM = 8'
 as DICT_WHERE,
'CLASSIFIER' as DICT_NAME,
'SHORT_NAME1 /*& ,ROW_NUM ID*/' as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
-- Проверить что вставили  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID =6021
and t.list_cod=1


-- =============Условия отбора по «РСЖС_Д_по» ==============
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6022 and 
LIST_COD = 1
order by COND_ID desc
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   --(select max(COND_ID)+1 from LIST_CONDITIONS where LIST_COD = 1) 
   6022  as COND_ID, 
   1 as LIST_COD, 
   'Собств_РСЖС_Д_по' as COND_NAME, 
   2 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
--delete
from LIST_CONDITIONS
where COND_ID=6022 and 
LIST_COD = 1


--===============================
 -- Посмотреть
select  t.*,t.rowid from OPERATION_TYPES t
where t.list_cod=1 and t.COND_ID<7000
order by t.COND_ID desc
-- Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
--(select max(L.COND_ID)FROM LIST_CONDITIONS L
--where L.LIST_COD=1 and L.COND_TYPE=2 ) 
6022 as COND_ID,
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE ,
'AFFAIR'  as TABLE_NAME,
'NVL2(SUBSTR (get_apartment_rgs_1 (affair.apart_id,''DATE_TO''),1,30),1,2)' as FIELD_NAME,
'CLASSIFIER_NUM = 8'
 as DICT_WHERE,
'CLASSIFIER' as DICT_NAME,
'SHORT_NAME1 /*& ,ROW_NUM ID*/' as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
-- Проверить что вставили  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID =6022
and t.list_cod=1




-- =============Условия отбора по «Собств_ЕГРП» ==============
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6023 and 
LIST_COD = 1
order by COND_ID desc
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   --(select max(COND_ID)+1 from LIST_CONDITIONS where LIST_COD = 1) 
   6023  as COND_ID, 
   1 as LIST_COD, 
   'Собств_ЕГРП' as COND_NAME, 
   2 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
--delete
from LIST_CONDITIONS
where COND_ID=6023 and 
LIST_COD = 1


--===============================
 -- Посмотреть
select  t.*,t.rowid from OPERATION_TYPES t
where t.list_cod=3 and t.COND_ID<7000
order by t.COND_ID desc
-- Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
--(select max(L.COND_ID)FROM LIST_CONDITIONS L
--where L.LIST_COD=1 and L.COND_TYPE=2 ) 
6023 as COND_ID,
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE ,
'AFFAIR'  as TABLE_NAME,
'NVL2(SUBSTR (get_apartment_rgs_1 (affair.apart_id,''STATE_NUMB''),1,30),1,2)' as FIELD_NAME,
'CLASSIFIER_NUM = 8'
 as DICT_WHERE,
'CLASSIFIER' as DICT_NAME,
'SHORT_NAME1 /*& ,ROW_NUM ID*/' as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
-- Проверить что вставили  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID =6023
and t.list_cod=1


SELECT c.cond_name,o.* from LIST_CONDITIONS c,OPERATION_TYPES o
where 
	c.LIST_COD = 3 and
  c.cond_id=o.cond_id
  and o.list_cod=3

ORDER BY c.cond_name 



