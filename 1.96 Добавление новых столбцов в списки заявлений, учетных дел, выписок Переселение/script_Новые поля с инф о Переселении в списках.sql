/* Oтображение инф. о Переселении в списках:
Учетных дел   V_AFFAIRS_LIST (LIST_COD=1
Заявлений      V_ANNOUN_LIST (LIST_COD=2)
Жилой площади  V_HOUSING_LIST  (LIST_COD=3)
Ордеров (площадь откуда осуществляется переселение). V_ORDER_LIST (LIST_COD=6)

======================== Надо создать ================================================
v_relocation_from_emig     -  Список apart_id и building_id из схемы emig  входящие в программы переселения (определенные в постановке задачи); 
v_relocation_programm_group - Список программ переселения(определенных в постановке задачи)  (как справочник) для поиска в KURS3
function GET_relocation_program(apart_id) - возвращает (из v_relocation_from_emig) программы переселения в которые входит apart_id в виде строки с кодами программ через запятую

================== Новые поля ============================================
---------- График переселения_год 	RELOC_PROGRAM_YEAR ненадо!!! ---------
График переселения_наименование RELOC_GROUP_NAME
График переселения_факт RELOC_YESNO
*/
-- ================== Новые поля для отображения в списках КПУ V_AFFAIRS_LIST (List_Cod = 1) ==========================
-- Проверить --
select L.*, rowid
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);

/*  ---------- В последней постановке 1.96 поле RELOC_PROGRAM_YEAR вычеркнуто!! ---------------------
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'График переселения_год' as FIELD_TITLE, 
60 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'RELOC_PROGRAM_YEAR' as  FIELD_NAME,
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
*/

insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'График переселения_наименование' as FIELD_TITLE, 
95 as  FIELD_W, 
2 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'RELOC_GROUP_NAME' as  FIELD_NAME,
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

insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'График переселения_факт' as FIELD_TITLE, 
60 as  FIELD_W, 
2 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'RELOC_YESNO' as  FIELD_NAME,
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

-- =============Условия отбора по Факт отнесения  ==============
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID>6021 and 
LIST_COD = 1
order by COND_ID desc
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   6030  as COND_ID, 
   1 as LIST_COD, 
   'Факт отнесения' as COND_NAME, 
   2 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP)+10 from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;
-- Проверить --
select l.*,rowid
--delete
from LIST_CONDITIONS l
where COND_ID>=6030 and 
LIST_COD = 1

 -- Посмотреть
select  t.*,t.rowid from OPERATION_TYPES t
where t.list_cod=1 and t.COND_ID>=6030
order by t.COND_ID asc
-- Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
6030 as COND_ID,
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE ,
'AFFAIR'  as TABLE_NAME,
'NVL2((select v.reloc_apart_id from v_relocation_from_emig v where v.reloc_apart_id=AFFAIR.apart_id and rownum=1),1,2)'  as FIELD_NAME,
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
t.COND_ID =6030
and t.list_cod=1


/*  В последней постановке 1.96 поле RELOC_PROGRAM_YEAR вычеркнуто!!
 -- =============Условия отбора по Год программы  (= > < >= <= ) ==============
select *
from LIST_CONDITIONS
where COND_ID>=6030 and LIST_COD = 1
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   6031  as COND_ID, --!!
   1 as LIST_COD, 
   'Год программы' as COND_NAME, 
   1 as COND_TYPE, --выбор из списка
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   6032  as COND_ID, --!!
   1 as LIST_COD, 
   'Год программы' as COND_NAME, 
   1 as COND_TYPE, --выбор из списка
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   6033  as COND_ID, --!!
   1 as LIST_COD, 
   'Год программы' as COND_NAME, 
   1 as COND_TYPE, --выбор из списка
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   6034  as COND_ID, --!!
   1 as LIST_COD, 
   'Год программы' as COND_NAME, 
   1 as COND_TYPE, --выбор из списка
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   6035  as COND_ID, --!!
   1 as LIST_COD, 
   'Год программы' as COND_NAME, 
   1 as COND_TYPE, --выбор из списка
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   6036  as COND_ID, --!!
   1 as LIST_COD, 
   'Год программы' as COND_NAME, 
   1 as COND_TYPE, --выбор из списка
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;            
-- =========

INSERT INTO OPERATION_TYPES 
(
SELECT 
6031 as COND_ID, --!!
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'GET_relocation_date(affair.apart_id)'  as FIELD_NAME, 
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
6032 as COND_ID, --!!
1 as LIST_COD,
2 as OPERATION_COD, 
'>' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'GET_relocation_date(affair.apart_id)'  as FIELD_NAME, 
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
6033 as COND_ID, --!!
1 as LIST_COD,
3 as OPERATION_COD, 
'>=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'GET_relocation_date(affair.apart_id)'  as FIELD_NAME, 
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
6034 as COND_ID, --!!
1 as LIST_COD,
4 as OPERATION_COD, 
'<' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'GET_relocation_date(affair.apart_id)'  as FIELD_NAME, 
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
6035 as COND_ID, --!!
1 as LIST_COD,
5 as OPERATION_COD, 
'<=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'GET_relocation_date(affair.apart_id)'  as FIELD_NAME, 
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
6036 as COND_ID, --!!
1 as LIST_COD,
6 as OPERATION_COD, 
'<>' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'GET_relocation_date(affair.apart_id)'  as FIELD_NAME, 
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
*/

-- =============Условия отбора по Наименование графика переселения  ==============
insert into LIST_CONDITIONS 
SELECT 
   6037  as COND_ID, 
   1 as LIST_COD, 
   'Наименование графика переселения' as COND_NAME, 
   2 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;

INSERT INTO OPERATION_TYPES 
(
SELECT 
6037 as COND_ID, --!!
1 as LIST_COD,
1 as OPERATION_COD, 
'' as OPERATION_NAME,   
1 as FIELD_TYPE , 
'AFFAIR'  as TABLE_NAME,
--'GET_relocation_program(affair.apart_id)'  as FIELD_NAME, 
'AFFAIR.apart_id=(select v.reloc_apart_id from v_relocation_from_emig v where v.reloc_apart_id=AFFAIR.apart_id and v.reloc_group_id' as FIELD_NAME, 
NULL as DICT_WHERE,
'KURS3.V_RELOCATION_PROGRAMM_GROUP' as DICT_NAME,
'NAME' as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
-- Проверить что вставили  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID >=6030
and t.list_cod=1


------------------- Проверить что вставили  ---------------------------
select l.cond_name,l.cond_type,t.* --,t.rowid  
from OPERATION_TYPES t, LIST_CONDITIONS l
where
l.list_cod=t.list_cod and l.cond_id=t.cond_id
and t.list_cod=1
order by t.list_cod, t.COND_ID desc  


-- ================== Новые поля для отображения в списках Заявлений  V_ANNOUN_LIST LIST_COD=2 ==========================
-- Проверить --
select L.*, rowid
FROM LIST_FIELDS L
where L.LIST_COD = 2 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 2);

insert into LIST_FIELDS 
SELECT 
2 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 2) as FIELD_ID, 
'График переселения_наименование' as FIELD_TITLE, 
95 as  FIELD_W, 
2 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'RELOC_GROUP_NAME' as  FIELD_NAME,
'V_ANNOUN_LIST' as TABLE_NAME, 
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
where L.LIST_COD = 2 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 2);

insert into LIST_FIELDS 
SELECT 
2 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 2) as FIELD_ID, 
'График переселения_факт' as FIELD_TITLE, 
60 as  FIELD_W, 
2 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'RELOC_YESNO' as  FIELD_NAME,
'V_ANNOUN_LIST' as TABLE_NAME, 
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
where L.LIST_COD = 2 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 2);

--редактировать V_ANNOUN_LIST--

-- =============Условия отбора по Факт отнесения  ==============
-- Проверить --
select *
from LIST_CONDITIONS
where -- COND_ID>6021 and 
LIST_COD = 2
order by COND_ID desc
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   6000  as COND_ID, 
   2 as LIST_COD, 
   'Факт отнесения' as COND_NAME, 
   2 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP)+10 from LIST_CONDITIONS where LIST_COD = 2 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;
-- Проверить --
select l.*,rowid
from LIST_CONDITIONS l
where COND_ID>=6000 and 
LIST_COD = 2

 -- Посмотреть
select  t.*,t.rowid from OPERATION_TYPES t
where t.list_cod=2 and t.COND_ID>=6000
order by t.COND_ID asc
-- Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
6000 as COND_ID,
2 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE ,
'AFFAIR'  as TABLE_NAME,
'NVL2((select v.reloc_apart_id from v_relocation_from_emig v where v.reloc_apart_id=AFFAIR.apart_id and rownum=1),1,2)'  as FIELD_NAME,
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
t.COND_ID =6000
and t.list_cod=2

-- =============Условия отбора по Наименование графика переселения  ==============
insert into LIST_CONDITIONS 
SELECT 
   6001  as COND_ID, 
   2 as LIST_COD, 
   'Наименование графика переселения' as COND_NAME, 
   2 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 2 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;

INSERT INTO OPERATION_TYPES 
(
SELECT 
6001 as COND_ID, --!!
2 as LIST_COD,
1 as OPERATION_COD, 
'' as OPERATION_NAME,   
1 as FIELD_TYPE , 
'AFFAIR'  as TABLE_NAME,
'AFFAIR.apart_id=(select v.reloc_apart_id from v_relocation_from_emig v where v.reloc_apart_id=AFFAIR.apart_id and v.reloc_group_id' as FIELD_NAME, 
NULL as DICT_WHERE,
'KURS3.V_RELOCATION_PROGRAMM_GROUP' as DICT_NAME,
'NAME' as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
-- Проверить что вставили  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID >=6000
and t.list_cod=2

-- ================== Новые поля для отображения в списках Жилой площади  V_HOUSING_LIST  LIST_COD=3 ==========================
-- Проверить --
select L.*, rowid
FROM LIST_FIELDS L
where L.LIST_COD = 3 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 3);

insert into LIST_FIELDS 
SELECT 
3 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 3) as FIELD_ID, 
'График переселения_наименование' as FIELD_TITLE, 
95 as  FIELD_W, 
2 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'RELOC_GROUP_NAME' as  FIELD_NAME,
'V_HOUSING_LIST' as TABLE_NAME, 
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
where L.LIST_COD =3 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 3);

insert into LIST_FIELDS 
SELECT 
3 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 3) as FIELD_ID, 
'График переселения_факт' as FIELD_TITLE, 
60 as  FIELD_W, 
2 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'RELOC_YESNO' as  FIELD_NAME,
'V_HOUSING_LIST' as TABLE_NAME, 
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
where L.LIST_COD = 3 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 3);

--редактировать V_HOUSING_LIST--

-- =============Условия отбора по Факт отнесения  ==============
-- Проверить --
select *
from LIST_CONDITIONS
where  COND_ID>5000 and 
LIST_COD = 3
order by COND_ID desc
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   6020  as COND_ID, 
   3 as LIST_COD, 
   'Факт отнесения' as COND_NAME, 
   2 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP)+10 from LIST_CONDITIONS where LIST_COD = 3 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;
-- Проверить --
select l.*,rowid
--delete
from LIST_CONDITIONS l
where COND_ID>=6000 and 
LIST_COD = 3

 -- Посмотреть
select  t.*,t.rowid from OPERATION_TYPES t
where t.list_cod=3 and t.COND_ID>=6000
order by t.COND_ID asc
-- Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
6020 as COND_ID,
3 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE ,
'FREE_SPACE'  as TABLE_NAME,
'NVL2((select v.reloc_apart_id from v_relocation_from_emig v where v.reloc_apart_id=FREE_SPACE.apart_id and rownum=1),1,2)'  as FIELD_NAME,
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
t.COND_ID >=6020
and t.list_cod=3

-- =============Условия отбора по Наименование графика переселения  ==============
insert into LIST_CONDITIONS 
SELECT 
   6021  as COND_ID, 
   3 as LIST_COD, 
   'Наименование графика переселения' as COND_NAME, 
   2 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 3 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
from LIST_CONDITIONS
where  COND_ID>5000 and 
LIST_COD = 3
order by COND_ID desc

INSERT INTO OPERATION_TYPES 
(
SELECT 
6021 as COND_ID, --!!
3 as LIST_COD,
1 as OPERATION_COD, 
'' as OPERATION_NAME,   
1 as FIELD_TYPE , 
'FREE_SPACE'  as TABLE_NAME,
'FREE_SPACE.apart_id=(select v.reloc_apart_id from v_relocation_from_emig v where v.reloc_apart_id=FREE_SPACE.apart_id and v.reloc_group_id' as FIELD_NAME, 
NULL as DICT_WHERE,
'KURS3.V_RELOCATION_PROGRAMM_GROUP' as DICT_NAME,
'NAME' as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
-- Проверить что вставили  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID >=6000
and t.list_cod=3

-- ================== Новые поля для отображения в списках Ордеров  V_ORDER_LIST (LIST_COD=6 )==========================

-- Проверить --
select L.*, rowid
FROM LIST_FIELDS L
where L.LIST_COD = 6 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 6);

insert into LIST_FIELDS 
SELECT 
6 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 6) as FIELD_ID, 
'График переселения_наименование' as FIELD_TITLE, 
95 as  FIELD_W, 
2 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'RELOC_GROUP_NAME' as  FIELD_NAME,
'V_ORDER_LIST' as TABLE_NAME, 
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
where L.LIST_COD =6 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD =6);

insert into LIST_FIELDS 
SELECT 
6 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 6) as FIELD_ID, 
'График переселения_факт' as FIELD_TITLE, 
60 as  FIELD_W, 
2 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'RELOC_YESNO' as  FIELD_NAME,
'V_ORDER_LIST' as TABLE_NAME, 
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
where L.LIST_COD = 6 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 6);

--редактировать V_ORDER_LIST--


-- =============Условия отбора по Факт отнесения  ==============
-- Проверить --
select *
from LIST_CONDITIONS
where  COND_ID>5000 and 
LIST_COD = 6
order by COND_ID desc
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   6020  as COND_ID, 
   6 as LIST_COD, 
   'Факт отнесения' as COND_NAME, 
   2 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP)+10 from LIST_CONDITIONS where LIST_COD = 6 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;
-- Проверить --
select l.*,rowid
--delete
from LIST_CONDITIONS l
where COND_ID>=6000 and 
LIST_COD = 6

 -- Посмотреть
select  t.*,t.rowid from OPERATION_TYPES t
where t.list_cod=6 and t.COND_ID>=6000
order by t.COND_ID asc
-- Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
6020 as COND_ID,
6 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE ,
'AFFAIR'  as TABLE_NAME,
'NVL2((select v.reloc_apart_id from v_relocation_from_emig v where AFFAIR.apart_id is not NULL and v.reloc_apart_id=AFFAIR.apart_id and rownum=1),1,2)'  as FIELD_NAME,
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
t.COND_ID >=6020
and t.list_cod=6

-- =============Условия отбора по Наименование графика переселения  ==============
insert into LIST_CONDITIONS 
SELECT 
   6021  as COND_ID, 
   6 as LIST_COD, 
   'Наименование графика переселения' as COND_NAME, 
   2 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 6 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
from LIST_CONDITIONS
where  COND_ID>5000 and 
LIST_COD = 6
order by COND_ID desc

INSERT INTO OPERATION_TYPES 
(
SELECT 
6021 as COND_ID, --!!
6 as LIST_COD,
1 as OPERATION_COD, 
'' as OPERATION_NAME,   
1 as FIELD_TYPE , 
'AFFAIR'  as TABLE_NAME,
'AFFAIR.apart_id=(select v.reloc_apart_id from v_relocation_from_emig v where AFFAIR.apart_id is not NULL and v.reloc_apart_id=AFFAIR.apart_id and v.reloc_group_id'  as FIELD_NAME, 
NULL as DICT_WHERE,
'KURS3.V_RELOCATION_PROGRAMM_GROUP' as DICT_NAME,
'NAME' as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
-- Проверить что вставили  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID >=6021
and t.list_cod=6


