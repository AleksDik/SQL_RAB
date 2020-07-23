--Ввод и отображение Факт ухудшения жилищных условий (переселение);
-- СПРАВОЧНИКИ Заведение справочника -Причины ухудшения жилищных условий (переселение)

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
   'Причины ухудшения жилищных условий (переселение)' as NAME, 
   'Причины ухудш. жил. усл.' as SHORT_NAME1,
   NULL as SHORT_NAME2, 
   NULL as SHORT_NAME3, 
   0 as  DELETED 
FROM DUAL;
Commit;
--проверить (140)
select *
 from CLASSIFIER_KURS3 cl 
where classifier_num = 91
order by row_num desc

-- === Завести строки в новый справочник ==
--проверить
select t.* from CLASSIFIER_KURS3 t
where classifier_num = (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91) 
-- Завести
INSERT INTO CLASSIFIER_KURS3 
SELECT 
 (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91)  as CLASSIFIER_NUM, 
  rownum as ROW_NUM, 
  sysdate as LAST_CHANGE, 
   1 as ROW_STATUS,
   Case rownum
       when 1 then ''
       when 2 then 'Изменение порядка польз. жил. пом. путем совершения сделок' --совершения сделок'
       when 3 then 'Обмен жилыми помещениями' 
       when 4 then 'Невып.услов.дог-ров о польз.ж/п,повлекшее высел.в суд.поря'--ещениями, повлекшее выселение граждан в судебном порядке'
       when 5 then 'Измен.состава семьи, в т.ч.в результате расторжения брака' -- жения брака' 
       when 6 then 'Вселение в ж/п иных лиц (за исключ.вселен.времен.жильцов)' --вселения временных жильцов)' 
       when 7 then 'Выдел доли собственникам жилых помещений' 
       when 8 then 'Отчужден.имеющегося в собст.граждан и членов их семей ж/п' --семей жилого помещения или частей жилого помещения' 
    end      
   as NAME, 
   null as SHORT_NAME1, 
    NULL as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL100 where rownum<9 ;
commit;
--проверить
select t.*, t.rowid from CLASSIFIER_KURS3 t
where classifier_num=140
-- ============================================
        
--==--Ввод и отображение Информация о наличии проблемной ситуации и ее решении(переселение);
-- СПРАВОЧНИКИ Заведение справочника -o	Проблема  ==========
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
   'Проблема (переселение)' as NAME, 
   'Проблема' as SHORT_NAME1,
   NULL as SHORT_NAME2, 
   NULL as SHORT_NAME3, 
   0 as  DELETED 
FROM DUAL;
Commit;
--проверить (141)
select *
 from CLASSIFIER_KURS3 cl 
where classifier_num = 91
order by row_num desc

-- === Завести строки в новый справочник ==
--проверить
select t.* from CLASSIFIER_KURS3 t
where classifier_num = (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91) 
-- Завести
INSERT INTO CLASSIFIER_KURS3 
SELECT 
 (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91)  as CLASSIFIER_NUM, 
  rownum as ROW_NUM, 
  sysdate as LAST_CHANGE, 
   1 as ROW_STATUS,
   Case rownum
       when 1 then ''
       when 2 then 'Самозахват'
       when 3 then 'Отсутствие собственника – выморочка' 
       when 4 then 'Служебное жилое помещение'
       when 5 then 'Проживание по договору ренты'
       when 6 then 'Одиноко проживающие граждане требующие персонального подхода'
    end      
   as NAME, 
   null as SHORT_NAME1, 
    NULL as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL100 where rownum<7 ;
commit;
--проверить
select t.*, t.rowid from CLASSIFIER_KURS3 t
where classifier_num = (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91) 


-- СПРАВОЧНИКИ Заведение справочника -o	Способ решения проблемы  ==========
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
   'Способ решения проблемы (переселение)' as NAME, 
   'Способ реш. пробл.' as SHORT_NAME1,
   NULL as SHORT_NAME2, 
   NULL as SHORT_NAME3, 
   0 as  DELETED 
FROM DUAL;
Commit;
--проверить (142)
select *
 from CLASSIFIER_KURS3 cl 
where classifier_num = 91
order by row_num desc

-- === Завести строки в новый справочник ==
--проверить
select t.* from CLASSIFIER_KURS3 t
where classifier_num = (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91) 
-- Завести
INSERT INTO CLASSIFIER_KURS3 
SELECT 
 (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91)  as CLASSIFIER_NUM, 
  rownum as ROW_NUM, 
  sysdate as LAST_CHANGE, 
   1 as ROW_STATUS,
   Case rownum
       when 1 then ''
       when 2 then 'Перевод жилого помещения в собственность Москвы'
       when 3 then 'Выселение' 
       when 4 then 'Перезаключение договора ренты'
       when 5 then 'Переоформление служебной площади'
    end      
   as NAME, 
   null as SHORT_NAME1, 
    NULL as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL100 where rownum<6 ;
commit;
--проверить
select t.*, t.rowid from CLASSIFIER_KURS3 t
where classifier_num = (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91) 
-- ============================================
--ID типа хранимой информации (клс.120) в AFFAIR_EXT_DATA (Дополнительные данные для КПУ)
--проверить
select t.* from CLASSIFIER_KURS3 t
where classifier_num =120 
--
INSERT INTO CLASSIFIER_KURS3 
SELECT 
 120 as CLASSIFIER_NUM, 
 (select Max(cl.row_num)+1 from CLASSIFIER_KURS3 cl where classifier_num = 120)  as ROW_NUM,  --получили - 6
  sysdate as LAST_CHANGE, 
  1 as ROW_STATUS,
  'Факт ухудшения жилищных условий' as NAME, --тип хранимой информации в AFFAIR_EXT_DATA
    null as SHORT_NAME1, 
    NULL as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL ;
commit;

INSERT INTO CLASSIFIER_KURS3 
SELECT 
 120 as CLASSIFIER_NUM, 
 (select Max(cl.row_num)+1 from CLASSIFIER_KURS3 cl where classifier_num = 120)  as ROW_NUM,  --получили - 7
  sysdate as LAST_CHANGE, 
  1 as ROW_STATUS,
  'Информация о наличии проблемной ситуации' as NAME,
    null as SHORT_NAME1, 
    NULL as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL ;
commit;
INSERT INTO CLASSIFIER_KURS3 
SELECT 
 120 as CLASSIFIER_NUM, 
 (select Max(cl.row_num)+1 from CLASSIFIER_KURS3 cl where classifier_num = 120)  as ROW_NUM, --получили - 8
  sysdate as LAST_CHANGE, 
  1 as ROW_STATUS,
  'Информация о решении проблемной ситуации' as NAME, 
   null as SHORT_NAME1, 
    NULL as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL ;
commit;
--проверить
select t.*, t.rowid from CLASSIFIER_KURS3 t
where classifier_num =120 

/* Структура информации в AFFAIR_EXT_DATA (Дополнительные данные для КПУ)

classifier_num = 120 ROW_NUM = 6 (Факт ухудшения жилищных условий)
-----------
data_id - 'уник. ID';
data_type_id  = 6 'ID типа хранимой информации (клс.120)';
affair_id -  'Код КПУ из AFFAIR';
data_n  - код причины Причины ухудшения жилищных условий (справочник 140; classifier_num =140 )
data_s  - строка примечание
data_d   - дата ухудшения жилищных условий
data_version = 0 'Версия (история) хранимой информации (0-последняя, n-предпоследняя)';

classifier_num = 120 ROW_NUM = 7 (Информация о наличии проблемной ситуации)
---------
data_id - 'уник. ID';
data_type_id  = 7 'ID типа хранимой информации (клс.120)';
affair_id -  'Код КПУ из AFFAIR';
data_n  - код Проблема (переселение) (справочник 141; classifier_num =141 )
data_s  - строка примечание
data_d   - дата возникновения Проблемы
data_version = 0 'Версия (история) хранимой информации (0-последняя, n-предпоследняя)';

classifier_num = 120 ROW_NUM = 8 (Информация о решении проблемной ситуации)
---------
data_id - 'уник. ID';
data_type_id  = 8 'ID типа хранимой информации (клс.120)';
affair_id -  'Код КПУ из AFFAIR';
data_n  - код Способа решения проблемы (переселение)(справочник 142; classifier_num =142 )
data_s  - строка примечание
data_d   - дата решения проблемы
data_version = 0 'Версия (история) хранимой информации (0-последняя, n-предпоследняя)';

*/
-- ============== Завести типы Дополнительных данных для КПУ  ===================
--ID типа хранимой информации (клс.120) в AFFAIR_EXT_DATA (Дополнительные данные для КПУ)
INSERT INTO CLASSIFIER_KURS3 
SELECT 
 120 as CLASSIFIER_NUM, 
 (select Max(cl.row_num)+1 from CLASSIFIER_KURS3 cl where classifier_num = 120)  as ROW_NUM, --получили - 9
  sysdate as LAST_CHANGE, 
  1 as ROW_STATUS,
  'Дата снятия с рег. учета в ПВС' as NAME, 
   null as SHORT_NAME1, 
    NULL as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL ;
commit;
INSERT INTO CLASSIFIER_KURS3 
SELECT 
 120 as CLASSIFIER_NUM, 
 (select Max(cl.row_num)+1 from CLASSIFIER_KURS3 cl where classifier_num = 120)  as ROW_NUM, --получили - 10
  sysdate as LAST_CHANGE, 
  1 as ROW_STATUS,
  'Дата вывоза семьи' as NAME, 
   null as SHORT_NAME1, 
    NULL as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL ;
commit;
--проверить
select t.*, t.rowid from CLASSIFIER_KURS3 t
where classifier_num =120 

/* Структура информации в AFFAIR_EXT_DATA (Дополнительные данные для КПУ)

classifier_num = 120 ROW_NUM = 9 (Дата снятия с рег. учета в ПВС)
-----------
data_id - 'уник. ID';
data_type_id  = 9 'ID типа хранимой информации (клс.120)';
affair_id -  'Код КПУ из AFFAIR';
data_n  - NULL
data_s  - NULL
data_d   - дата Дата снятия с рег. учета в ПВС
data_version = 0 'Версия (история) хранимой информации (0-последняя, n-предпоследняя)';

classifier_num = 120 ROW_NUM = 10 (Дата вывоза семьи)
-----------
data_id - 'уник. ID';
data_type_id  = 10  'ID типа хранимой информации (клс.120)';
affair_id -  'Код КПУ из AFFAIR';
data_n  - NULL
data_s  - NULL
data_d   - Дата вывоза семьи
data_version = 0 'Версия (история) хранимой информации (0-последняя, n-предпоследняя)';
*/
-- ================ ДОПИСАТЬ пакет KURS3.PKG_AFFAIR ===========================

--  ======Синонимы на пакет KURS3.PKG_AFFAIR ==========
CREATE SYNONYM KURS3.K3_PKG_AFFAIR FOR KURS3.PKG_AFFAIR;
CREATE SYNONYM O51.K3_PKG_AFFAIR FOR KURS3.PKG_AFFAIR;
CREATE SYNONYM O52.K3_PKG_AFFAIR FOR KURS3.PKG_AFFAIR;
CREATE SYNONYM O53.K3_PKG_AFFAIR FOR KURS3.PKG_AFFAIR;
CREATE SYNONYM O54.K3_PKG_AFFAIR FOR KURS3.PKG_AFFAIR;
CREATE SYNONYM O55.K3_PKG_AFFAIR FOR KURS3.PKG_AFFAIR;
CREATE SYNONYM O56.K3_PKG_AFFAIR FOR KURS3.PKG_AFFAIR;
CREATE SYNONYM O57.K3_PKG_AFFAIR FOR KURS3.PKG_AFFAIR;
CREATE SYNONYM O58.K3_PKG_AFFAIR FOR KURS3.PKG_AFFAIR;
CREATE SYNONYM O59.K3_PKG_AFFAIR FOR KURS3.PKG_AFFAIR;
CREATE SYNONYM O60.K3_PKG_AFFAIR FOR KURS3.PKG_AFFAIR;
CREATE SYNONYM O61.K3_PKG_AFFAIR FOR KURS3.PKG_AFFAIR;
CREATE SYNONYM O62.K3_PKG_AFFAIR FOR KURS3.PKG_AFFAIR;
CREATE SYNONYM O63.K3_PKG_AFFAIR FOR KURS3.PKG_AFFAIR;
--  ======Права на пакет KURS3.PKG_AFFAIR ==========
GRANT EXECUTE ON KURS3.PKG_AFFAIR TO O51;
GRANT EXECUTE ON KURS3.PKG_AFFAIR TO O52;
GRANT EXECUTE ON KURS3.PKG_AFFAIR TO O53;
GRANT EXECUTE ON KURS3.PKG_AFFAIR TO O54;
GRANT EXECUTE ON KURS3.PKG_AFFAIR TO O55;
GRANT EXECUTE ON KURS3.PKG_AFFAIR TO O56;
GRANT EXECUTE ON KURS3.PKG_AFFAIR TO O57;
GRANT EXECUTE ON KURS3.PKG_AFFAIR TO O58;
GRANT EXECUTE ON KURS3.PKG_AFFAIR TO O59;
GRANT EXECUTE ON KURS3.PKG_AFFAIR TO O60;
GRANT EXECUTE ON KURS3.PKG_AFFAIR TO O61;
GRANT EXECUTE ON KURS3.PKG_AFFAIR TO O62;
GRANT EXECUTE ON KURS3.PKG_AFFAIR TO O63;

-- Новая функция function get_uhud_usl_strinfo  (Вернуть строку Ухудшение жил. условий за последние 5 лет по заданному ID КПУ для подстановки в get_affair_text)
-- Дописать функцию FUNCTION get_affair_text (карточка КПУ)
-- Изменения (ilonis 17.06.2013  to Dikan) в PROCEDURE kursiv.do_for_taffair

/*==НОВЫЕ ПОЛЯ для отображения в списках КПУ V_AFFAIRS_LIST  ==========
П_снятие с рег. учета_Д
П_вывоз семьи_Д
*/
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);
-- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'П_снятие с рег. учета_Д' as FIELD_TITLE, 
65 as  FIELD_W, 
3 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'DEREG_PVS_DATE' as  FIELD_NAME,
--'V_AFFAIRS_LIST' as TABLE_NAME, 
'AFFAIR_EXT_DATA' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- Проверить --
select l.*, l.rowid
FROM LIST_FIELDS L
where L.LIST_COD = 1 
order by L.FIELD_ID desc
-- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'П_вывоз семьи_Д' as FIELD_TITLE, 
65 as  FIELD_W, 
3 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'EXPORT_FAM_DATE' as  FIELD_NAME,
--'V_AFFAIRS_LIST' as TABLE_NAME, 
'AFFAIR_EXT_DATA' as TABLE_NAME, 
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


/*==НОВЫЕ ПОЛЯ для отображения в списках КПУ V_AFFAIRS_LIST  ==========
Ухудшение жил. условий за 5 лет    UHUD_ZIL_USL - Ухудш ж/усл_ 5 лет
Причина ухуд. (причина ухудшения); REASON_UHUD_ZIL_USL - Ухудш ж/усл_ причина
Д_ухуд. (Дата ухудшения);  DATE_UHUD_ZIL_USL - Ухудш ж/усл_ Д
Примечание_ухуд (Примечание _ухудшения) PRIM_UHUD_ZIL_USL - Ухудш ж/усл_ примечание

Проблема; PROBLEM_PERES - П_Проблема
Примечание_пробл. (примечание_проблемы) PRIM_PROBLEM_PERES  - П_Проблема_примечание
Способ реш. пробл. (способ решения проблемы); TYPE_SOLUTION - П_Проблема_решение
Д_реш. пробл. (Дата решения проблемы) DATE_SOLUTION         - П_Проблема_Д решения

*/
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);
-- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'Ухудш ж/усл_ 5 лет' as FIELD_TITLE, 
65 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'UHUD_ZIL_USL' as  FIELD_NAME,
'V_AFFAIRS_LIST' as TABLE_NAME, 
--'AFFAIR_EXT_DATA' as TABLE_NAME, 
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
-- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'Ухудш ж/усл_ причина' as FIELD_TITLE, 
80 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'REASON_UHUD_ZIL_USL' as  FIELD_NAME,
'V_AFFAIRS_LIST' as TABLE_NAME, 
--'AFFAIR_EXT_DATA' as TABLE_NAME, 
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
 
-- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'Ухудш ж/усл_ Д' as FIELD_TITLE, 
50 as  FIELD_W, 
3 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'DATE_UHUD_ZIL_USL' as  FIELD_NAME,
--'V_AFFAIRS_LIST' as TABLE_NAME, 
'AFFAIR_EXT_DATA' as TABLE_NAME, 
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
-- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'Ухудш ж/усл_ примечание' as FIELD_TITLE, 
65 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'PRIM_UHUD_ZIL_USL' as  FIELD_NAME,
--'V_AFFAIRS_LIST' as TABLE_NAME, 
'AFFAIR_EXT_DATA' as TABLE_NAME, 
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
 -- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'П_Проблема' as FIELD_TITLE, 
80 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'PROBLEM_PERES' as  FIELD_NAME,
'V_AFFAIRS_LIST' as TABLE_NAME, 
--'AFFAIR_EXT_DATA' as TABLE_NAME, 
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

 -- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'П_Проблема_примечание' as FIELD_TITLE, 
80 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'PRIM_PROBLEM_PERES' as  FIELD_NAME,
--'V_AFFAIRS_LIST' as TABLE_NAME, 
'AFFAIR_EXT_DATA' as TABLE_NAME, 
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
 -- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'П_Проблема_решение' as FIELD_TITLE, 
80 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'TYPE_SOLUTION' as  FIELD_NAME,
'V_AFFAIRS_LIST' as TABLE_NAME, 
--'AFFAIR_EXT_DATA' as TABLE_NAME, 
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

-- Завести в список КПУ V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'П_Проблема_Д решения' as FIELD_TITLE, 
60 as  FIELD_W, 
3 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'DATE_SOLUTION' as  FIELD_NAME,
--'V_AFFAIRS_LIST' as TABLE_NAME, 
'AFFAIR_EXT_DATA' as TABLE_NAME, 
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

-- =============== ОТБОР по новым полям ========================
/*
Наличие даты снятия с рег. учета в ПВС		Да /нет - П_снятие с рег. учета_Д наличие
Дата снятия с рег. учета в ПВС 	Выбор значения из календаря	 - П_снятие с рег. учета_Д
Наличие даты вывоза семьи			Да /нет - П_вывоз семьи_Д наличие
Дата вывоза семьи		Выбор значения из календаря - П_вывоз семьи_Д
*/
 -- =============Условия отбора по Наличие даты снятия с рег. учета в ПВС ==============
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6001 and LIST_COD = 1
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   6001  as COND_ID, --!!
   1 as LIST_COD, 
   'П_снятие с рег. учета_Д наличие' as COND_NAME, 
   2 as COND_TYPE, --выбор из списка
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP)+10 from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --Новая группа условий
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
--delete
from LIST_CONDITIONS
where COND_ID=6001 and 
LIST_COD = 1

--====== Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
6001 as COND_ID, --!!
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number т.к. CLASSIFIER.CLASSIFIER_NUM=8 (Да/Нет) вернет (1/2) и 'NVL2(pkg_affair.get_affair_ext_data_d (affair.affair_id,9,0),1,2)' вернет (1/2)
'AFFAIR'  as TABLE_NAME,
'NVL2(pkg_affair.get_affair_ext_data_d(affair.affair_id,pkg_affair.get_dereg_pvs_type_id,0),1,2)'  as FIELD_NAME,
'CLASSIFIER_NUM=8 and DELETED=0'
 as DICT_WHERE,
'CLASSIFIER' as DICT_NAME,
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
t.COND_ID =6001
and t.list_cod=1
 -- =============Условия отбора по Дата снятия с рег. учета в ПВС ==============
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6002 and LIST_COD = 1
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   6002  as COND_ID, 
   1 as LIST_COD, 
   'П_снятие с рег. учета_Д' as COND_NAME, 
   1 as COND_TYPE, --равенство введен знач.
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
--delete
from LIST_CONDITIONS
where COND_ID=6002 and 
LIST_COD = 1

--====== Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
6002 as COND_ID, --!!
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
3 as FIELD_TYPE , -- Date
'AFFAIR'  as TABLE_NAME,
'pkg_affair.get_affair_ext_data_d(affair.affair_id,pkg_affair.get_dereg_pvs_type_id,0)'  as FIELD_NAME,
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
t.COND_ID <6020
and t.list_cod=1
order by t.cond_id desc
 -- =============Условия отбора по Наличие даты вывоза семьи ==============
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6003 and LIST_COD = 1
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   6003  as COND_ID, --!!
   1 as LIST_COD, 
   'П_вывоз семьи_Д наличие' as COND_NAME, 
   2 as COND_TYPE, --выбор из списка
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6003 and 
LIST_COD = 1

--====== Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
6003 as COND_ID, --!!
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number т.к. CLASSIFIER.CLASSIFIER_NUM=8 (Да/Нет) вернет (1/2) и 'NVL2(pkg_affair.get_affair_ext_data_d (affair.affair_id,9,0),1,2)' вернет (1/2)
'AFFAIR'  as TABLE_NAME,
'NVL2(pkg_affair.get_affair_ext_data_d(affair.affair_id,pkg_affair.get_export_fam_type_id,0),1,2)'  as FIELD_NAME, --тут менять ...._type_id
'CLASSIFIER_NUM=8 and DELETED=0'
 as DICT_WHERE,
'CLASSIFIER' as DICT_NAME,
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
t.COND_ID =6003
and t.list_cod=1
 -- =============Условия отбора по Дата вывоза семьи ==============
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6004 and LIST_COD = 1
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   6004  as COND_ID, 
   1 as LIST_COD, 
   'П_вывоз семьи_Д' as COND_NAME, 
   1 as COND_TYPE, --равенство введен знач.
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6004 and 
LIST_COD = 1

--====== Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
6004 as COND_ID, --!!
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
3 as FIELD_TYPE , -- Date
'AFFAIR'  as TABLE_NAME,
'pkg_affair.get_affair_ext_data_d(affair.affair_id,pkg_affair.get_export_fam_type_id,0)'  as FIELD_NAME,
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
t.COND_ID =6004
and t.list_cod=1

-- =============== ОТБОР по новым полям ========================
/*
Причина ухудшения Да /нет - Ухудш ж/усл_ причина_наличие
Дата ухудшения    Да /нет - Ухудш ж/усл_ Д_наличие
Примечание ухудшения  Да /нет - Ухудш ж/усл_ примечание_наличие
Наличие проблемной ситуации   Да /нет - П_Проблема_наличие
Решение проблемной ситуации   Да /нет - П_Проблема_решение_наличие
Дата решения   Да /нет - П_Проблема_Д решения_наличие
П_Проблема_примечание_наличие  Да /нет 
*/
 -- =============Условия отбора по Причина ухудшения Да /нет ==============
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6005 and LIST_COD = 1
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   6005  as COND_ID, --!!
   1 as LIST_COD, 
   'Ухудш ж/усл_ причина_наличие' as COND_NAME, 
   2 as COND_TYPE, --выбор из списка
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) + 10 from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --Новая группа
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6005 and 
LIST_COD = 1

--====== Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
6005 as COND_ID, --!!
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number т.к. CLASSIFIER.CLASSIFIER_NUM=8 (Да/Нет) вернет (1/2) и 'NVL2(pkg_affair.get_affair_ext_data_d (affair.affair_id,9,0),1,2)' вернет (1/2)
'AFFAIR'  as TABLE_NAME,
'NVL2(pkg_affair.get_affair_ext_data_n(affair.affair_id,pkg_affair.get_uhud_type_id,0),1,2)'  as FIELD_NAME, --тут менять ...._type_id
'CLASSIFIER_NUM=8 and DELETED=0'
 as DICT_WHERE,
'CLASSIFIER' as DICT_NAME,
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
t.COND_ID =6005
and t.list_cod=1

 -- =============Условия отбора по Дата ухудшения    Да /нет ==============
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6006 and LIST_COD = 1
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   6006  as COND_ID, --!!
   1 as LIST_COD, 
   'Ухудш ж/усл_ Д_наличие' as COND_NAME, 
   2 as COND_TYPE, --выбор из списка
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --текущая группа
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6006 and 
LIST_COD = 1

--====== Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
6006 as COND_ID, --!!
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'NVL2(pkg_affair.get_affair_ext_data_d(affair.affair_id,pkg_affair.get_uhud_type_id,0),1,2)'  as FIELD_NAME, --тут менять ...._type_id
'CLASSIFIER_NUM=8 and DELETED=0'
 as DICT_WHERE,
'CLASSIFIER' as DICT_NAME,
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
t.COND_ID =6006
and t.list_cod=1


 -- =============Условия отбора по Примечание ухудшения   Да /нет ==============
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6007 and LIST_COD = 1
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   6007  as COND_ID, --!!
   1 as LIST_COD, 
   'Ухудш ж/усл_ примечание_наличие' as COND_NAME, 
   2 as COND_TYPE, --выбор из списка
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --текущая группа
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6007 and 
LIST_COD = 1

--====== Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
6007 as COND_ID, --!!
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'NVL2(pkg_affair.get_affair_ext_data_s(affair.affair_id,pkg_affair.get_uhud_type_id,0),1,2)'  as FIELD_NAME, --тут менять ...._type_id
'CLASSIFIER_NUM=8 and DELETED=0'
 as DICT_WHERE,
'CLASSIFIER' as DICT_NAME,
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
t.COND_ID =6007
and t.list_cod=1


 -- =============Условия отбора по Наличие проблемной ситуации   Да /нет ==============
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6008 and LIST_COD = 1
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   6008  as COND_ID, --!!
   1 as LIST_COD, 
   'П_Проблема_наличие' as COND_NAME, 
   2 as COND_TYPE, --выбор из списка
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) +10 from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --Новая группа
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6008 and 
LIST_COD = 1

--====== Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
6008 as COND_ID, --!!
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'DECODE(pkg_affair.get_affair_ext_data_ver(affair.affair_id,pkg_affair.get_problem_type_id),0,2,1)'  as FIELD_NAME, --тут менять ...._type_id
'CLASSIFIER_NUM=8 and DELETED=0'
 as DICT_WHERE,
'CLASSIFIER' as DICT_NAME,
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
t.COND_ID =6008
and t.list_cod=1

 -- =============Условия отбора по Решение проблемной ситуации   Да /нет ==============
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6009 and LIST_COD = 1
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   6009  as COND_ID, --!!
   1 as LIST_COD, 
   'П_Проблема_решение_наличие' as COND_NAME, 
   2 as COND_TYPE, --выбор из списка
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --текущая группа
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6009 and 
LIST_COD = 1

--====== Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
6009 as COND_ID, --!!
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'DECODE(pkg_affair.get_affair_ext_data_ver(affair.affair_id,pkg_affair.get_solution_type_id),0,2,1)'  as FIELD_NAME, --тут менять ...._type_id
'CLASSIFIER_NUM=8 and DELETED=0'
 as DICT_WHERE,
'CLASSIFIER' as DICT_NAME,
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
t.COND_ID =6009
and t.list_cod=1

 -- =============Условия отбора по Дата решения   Да /нет ==============
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6010 and LIST_COD = 1
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   6010  as COND_ID, --!!
   1 as LIST_COD, 
   'П_Проблема_Д решения_наличие' as COND_NAME, 
   2 as COND_TYPE, --выбор из списка
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --текущая группа
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6010 and 
LIST_COD = 1

--====== Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
6010 as COND_ID, --!!
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'NVL2(pkg_affair.get_affair_ext_data_d(affair.affair_id,pkg_affair.get_solution_type_id,0),1,2)'  as FIELD_NAME, --тут менять ...._type_id
'CLASSIFIER_NUM=8 and DELETED=0'
 as DICT_WHERE,
'CLASSIFIER' as DICT_NAME,
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
 t.list_cod=1
 order by t.cond_id desc

-- =============Условия отбора по Примечание к Проблеме   П_Проблема_примечание_наличие  Да /нет ==============
-- Проверить --
select t.*,t.rowid
from LIST_CONDITIONS t
where  t.LIST_COD = 1 and t.cond_id<6999 order by  t.COND_ID desc
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   6012  as COND_ID, --!!
   1 as LIST_COD, 
   'П_Проблема_примечание_наличие' as COND_NAME, 
   2 as COND_TYPE, --выбор из списка
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --текущая группа
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6012 and 
LIST_COD = 1

--====== Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
6012 as COND_ID, --!!
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'NVL2(pkg_affair.get_affair_ext_data_s(affair.affair_id,pkg_affair.get_problem_type_id,0),1,2)'  as FIELD_NAME, --тут менять ...._type_id
'CLASSIFIER_NUM=8 and DELETED=0'
 as DICT_WHERE,
'CLASSIFIER' as DICT_NAME,
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
t.COND_ID =6012
and t.list_cod=1

 -- =============Условия отбора по Ухудшение жил. условий за 5 лет   ==============
 /*
  Ухудш ж/усл_ 5 лет
 Нет инф
да, < 5лет
да, > 5лет
 */
-- Новая функция для отбора по Ухудшение жил. условий за 5 лет 
-- pkg_affair.get_affair_ext_data_uhud5year(p_affair_id IN NUMBER) RETURN NUMBER;
 
 -- СПРАВОЧНИКИ Заведение справочника условий отбора по Ухудшение жил. условий за 5 лет  ==========
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
   'Условия отбора по Ухудшение жил. условий за 5 лет' as NAME, 
   NULL as SHORT_NAME1,
   NULL as SHORT_NAME2, 
   NULL as SHORT_NAME3, 
   0 as  DELETED 
FROM DUAL;
Commit;
--проверить (143)
select *
 from CLASSIFIER_KURS3 cl 
where classifier_num = 91
order by row_num desc

-- === Завести строки в новый справочник ==
--проверить
select t.* from CLASSIFIER_KURS3 t
where classifier_num = (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91) 
-- Завести
INSERT INTO CLASSIFIER_KURS3 
SELECT 
 (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91)  as CLASSIFIER_NUM, 
  rownum as ROW_NUM, 
  sysdate as LAST_CHANGE, 
   1 as ROW_STATUS,
   Case rownum
       when 1 then 'Нет инф'
       when 2 then 'да, < 5лет'
       when 3 then 'да, > 5лет' 
    end      
   as NAME, 
      Case rownum
       when 1 then 'Нет инф'
       when 2 then 'да, < 5лет'
       when 3 then 'да, > 5лет' 
    end 
     as SHORT_NAME1, 
    NULL as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL100 where rownum<4 ;
commit;
--проверить
select t.*, t.rowid from CLASSIFIER_KURS3 t
where classifier_num = (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91) 

-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6011 and LIST_COD = 1
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   6011  as COND_ID, --!!
   1 as LIST_COD, 
   'Ухудш ж/усл_ 5 лет' as COND_NAME, 
   2 as COND_TYPE, --выбор из списка
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP)-10 from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --предыдущая группа
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
from LIST_CONDITIONS
where COND_ID=6011 and 
LIST_COD = 1

--====== Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
6011 as COND_ID, --!!
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'pkg_affair.get_affair_ext_data_uhud5year(affair.affair_id)'  as FIELD_NAME, 
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
t.COND_ID =6011
and t.list_cod=1


 







