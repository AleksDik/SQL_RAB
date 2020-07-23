--Ввод и отображение на экранной форме «Учетное дело» нового атрибута – «Состав семьи» и столбец «Кол-во зарег.» (количество зарегистрированных) 

-- СПРАВОЧНИКИ Заведение справочника - «Состав семьи»--

-- ====== Завести новый справочник в перечень справочников (91) ==
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
   'Состав семьи' as NAME, 
   'Состав семьи' as SHORT_NAME1,
   NULL as SHORT_NAME2, 
   NULL as SHORT_NAME3, 
   0 as  DELETED 
FROM DUAL;
Commit;
--проверить (143)
select cl.*,cl.rowid

 from CLASSIFIER_KURS3 cl 
where classifier_num = 91
order by row_num desc

-- === Завести строки в новый справочник ==
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
       when 1 then '1'
       when 2 then '2 чел (супруги)'
       when 3 then '2 чел (не супруги)' 
       when 4 then '3 чел (супруги)'
       when 5 then '3 чел (не супруги)' 
       when 6 then '4 и более' 
    end      
   as NAME, 
   Case rownum
       when 1 then '1'
       when 2 then '2 чел (супруги)'
       when 3 then '2 чел (не супруги)' 
       when 4 then '3 чел (супруги)'
       when 5 then '3 чел (не супруги)'  
       when 6 then '4 и более' 
    end   
    as SHORT_NAME1, 
NULL  
    as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL100 where rownum<7 ;
commit;
--проверить
select t.*, t.rowid from CLASSIFIER_KURS3 t
where classifier_num=139 (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91) 
-- ============================================
        
--==Поле «Состав семьи» для отображения в списках КПУ V_AFFAIRS_LIST  ==========
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);
-- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'Состав семьи' as FIELD_TITLE, 
65 as  FIELD_W, 
2 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'FAMILY_STRUCTURE' as  FIELD_NAME,
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

/* === Првка View V_AFFAIRS_LIST====
добавить поле FAMILY_STRUCTURE в заголовок и тело View
 FAMILY_STRUCTURE=
         (SELECT cl.short_name1 FROM classifier_kurs3 cl WHERE CL.CLASSIFIER_NUM = $ROW AND cl.row_num = Get_family_structure(affair.affair_id,affair.affair_stage)
          as FAMILY_STRUCTURE
 --------------------------------         
 где $ROW = (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91) =139
*/  


--==Поле «Кол-во зарег.» (количество зарегистрированных)  для отображения в списках КПУ V_AFFAIRS_LIST  ==========
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);
-- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'Кол-во зарег.' as FIELD_TITLE, 
40 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'COUNT_REG_PERSON' as  FIELD_NAME,
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

/* === Првка View V_AFFAIRS_LIST====
добавить поле COUNT_REG_PERSON в заголовок и тело View
COUNT_REG_PERSON affair.affair_id,affair.affair_stage

(select count(*) from PERSON_RELATION_DELO prd
where prd.affair_id=affair.affair_id
  and prd.affair_stage = affair.affair_stage
  and prd.reg_person =1) as COUNT_REG_PERSON
*/

 -- =============Условия отбора по «Состав семьи» ==============
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6000 and LIST_COD = 1
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   --(select max(COND_ID)+1 from LIST_CONDITIONS where LIST_COD = 1) 
   6000  as COND_ID, 
   1 as LIST_COD, 
   'Состав семьи' as COND_NAME, 
   2 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP)+10 from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
--delete
from LIST_CONDITIONS
where COND_ID=6000 and 
LIST_COD = 1

--===============================
 -- Посмотреть
select t.* from OPERATION_TYPES t
where t.list_cod=1
order by t.COND_ID desc
-- Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
--(select max(L.COND_ID)FROM LIST_CONDITIONS L
--where L.LIST_COD=1 and L.COND_TYPE=2 ) 
6000 as COND_ID,
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE ,
'AFFAIR'  as TABLE_NAME,
'Get_family_structure(affair.affair_id,affair.affair_stage)'  as FIELD_NAME,
'CLASSIFIER_NUM='||TO_CHAR((select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91))||' and DELETED=0'
 as DICT_WHERE,
'CLASSIFIER_KURS3' as DICT_NAME,
'SHORT_NAME1 /*&& ,ROW_NUM ID*/' as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
-- Проверить что вставили  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID =6000-- (select max(L.COND_ID) FROM LIST_CONDITIONS L where L.LIST_COD=1)
and t.list_cod=1










