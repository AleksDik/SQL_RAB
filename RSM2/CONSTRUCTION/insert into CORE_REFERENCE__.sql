
insert into CORE_REFERENCE 
(REFERENCEID, DESCRIPTION, READONLY, PROGID, DEFAULTVALUE, NAME, REGISTER_ID, SIMPLE_VALUES, ISTREE)
select
11571 as REFERENCEID, 
 'Тип объекта ПИК'  as DESCRIPTION, 
1 as READONLY,
'Core.RefLib.Executors.ReferenceExecutor' as  PROGID, 
null as DEFAULTVALUE, 
null as NAME, 
null as REGISTER_ID, 
null as SIMPLE_VALUES,
0 as  ISTREE
from dual;


insert into CORE_REFERENCE_ITEM 
(ITEMID, REFERENCEID, CODE, VALUE, SHORT_TITLE, IS_ARCHIVES, USER_NAME, DATE_END_CHANGE, DATE_S, FLAG, NAME, REGISTER_ID)
select * from (
select
1301154 as ITEMID, 
11571  as REFERENCEID, 
null as CODE, 
'Отдельно-стоящее здание' as VALUE, 
null as SHORT_TITLE, 
null as IS_ARCHIVES, 
null as USER_NAME, 
null as DATE_END_CHANGE, 
null as DATE_S, 
null as FLAG, 
'DetachedBuilding' as NAME, 
null as REGISTER_ID
from dual
union
select
1301155 as ITEMID, 
11571  as REFERENCEID, 
null as CODE, 
'Встроенное-пристроенное' as VALUE, 
null as SHORT_TITLE, 
null as IS_ARCHIVES, 
null as USER_NAME, 
null as DATE_END_CHANGE, 
null as DATE_S, 
null as FLAG, 
'BuiltInAndAttached' as NAME, 
null as REGISTER_ID
from dual
union
select
1301156 as ITEMID, 
11571  as REFERENCEID, 
null as CODE, 
'Иное' as VALUE, 
null as SHORT_TITLE, 
null as IS_ARCHIVES, 
null as USER_NAME, 
null as DATE_END_CHANGE, 
null as DATE_S, 
null as FLAG, 
 'Other' as NAME, 
null as REGISTER_ID
from dual
)
;
