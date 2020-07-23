-- =============Условия отбора в списке "План КПУ" по "№ в списке обеспечения"(AFFAIR_PLAN.OPD) ==============
--!! #06032013Dik в V_PLAN_KPU_LIST

-- 1 Проверить --
select rowid, LIST_CONDITIONS.*
from LIST_CONDITIONS
where LIST_COD =17
order by COND_ID
-- 2 Проверить --
select t.*
from LIST_FIELDS t
  where t.list_cod = 17
  and   t.field_id = 47;
--where COND_ID in (5040,5050)-- (select max(COND_ID) from LIST_CONDITIONS where LIST_COD = 17);

-- 3 Завести
insert into LIST_CONDITIONS 
SELECT 
   (select max(COND_ID)+1 from LIST_CONDITIONS where LIST_COD = 17)   as COND_ID, 
   t.list_cod as LIST_COD, 
   t.field_title as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   NULL as COND_GROUP, 
   1 as STATUS --from dual;
   from LIST_FIELDS t
  where t.list_cod = 17
  and   t.field_id = 47;
   commit;

-- 4 Проверить --
select *
from LIST_CONDITIONS
where COND_ID= (select max(COND_ID) from LIST_CONDITIONS where LIST_COD = 17 and COND_TYPE=1 );
--===============================

 --5 Проверить
select rowid,t.* from OPERATION_TYPES t
where t.list_cod=17 
order by t.COND_ID desc

--6 Завести
INSERT INTO OPERATION_TYPES 
(
SELECT 
(select max(L.COND_ID)FROM LIST_CONDITIONS L
where L.LIST_COD=17 and L.COND_TYPE=1 ) as COND_ID,
17 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE ,
' (NVL(AFFAIR_PLAN.PLAN_YEAR,0)= gGapy) and nvl(AFFAIR_PLAN'  as TABLE_NAME,
'OPD, 0)'  as FIELD_NAME,
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;

--7 Проверить что вставили  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID = (select max(L.COND_ID) FROM LIST_CONDITIONS L where L.LIST_COD=17)
and t.list_cod=17

