----------------- Error message: A component named lbDocType_....... already exists ---------

--- посмотреть задвойки паспортов в делах выверки
SELECT vv.* from  V_TEST_VIVERKA_DOCS vv
where vv.object_rel_id in
(
SELECT v.object_rel_id from  V_TEST_VIVERKA_DOCS v
where v.document_user_id is null)

-- адреса дел с задвойками --
SELECT v.*,d.delo_addr from  V_TEST_VIVERKA_DOCS v ,   scan.ea_delo d  
where d.DELO_ID=v.delo_id

---============== ИСПРАВЛЕНИЕ =============
--сравнить
select t.*, t.rowid from scan.EA_DOCUMENT_ATTR t 
where t.object_rel_id in
(
SELECT v.object_rel_id from  V_TEST_VIVERKA_DOCS v
where v.document_user_id is null)    
and t.object_type_id=7
order by t.object_rel_id,t.last_change  
-----тока для правки
select t.*, t.rowid from scan.EA_DOCUMENT_ATTR t 
where t.document_id in
(
SELECT v.document_id from  V_TEST_VIVERKA_DOCS v
where v.document_user_id is null)    
and t.object_type_id=7
order by t.object_rel_id,t.last_change  

-- одним завпросом
update  scan.EA_DOCUMENT_ATTR t
set t.row_status=0,
    t.document_version=1 
where t.document_id in
(
SELECT v.document_id from  V_TEST_VIVERKA_DOCS v
where v.document_user_id is null)    
and t.object_type_id=7;

     
---==============================================



-- Дела выверки получает интерфейс выверки задвоение RNUM - ошибка
SELECT * FROM V_VERIFY_PERSON_FOR_TEST 
WHERE  -- AFFAIR_ID = 61729  AND 
AFFAIR_STAGE = 1 
AND DELO_ID = 1227318


-- Дела выверки с задвоенными паспортами (текст в V_TEST_VIVERKA_DOCS) -----------------
select *
from(           
SELECT ed.delo_id, eda.object_rel_id, count(eda.object_rel_id) as c
FROM scan.ea_document ed, scan.ea_document_attr eda
WHERE eda.document_id = ed.document_id 
AND eda.row_status = 1 
AND eda.object_type_id = 7                
group by   ed.delo_id, eda.object_rel_id  having   count(eda.object_rel_id)>1      
)

