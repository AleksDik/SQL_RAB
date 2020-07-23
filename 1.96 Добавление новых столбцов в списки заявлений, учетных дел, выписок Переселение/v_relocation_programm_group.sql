/*
Список программ переселения (как справочник) для поиска в KURS3 
30.08.2013  Dikan 
*/
create or replace view v_relocation_programm_group as
select
'='||Trim(To_char(eg.group_id))||')' as ID,
--'%'||Trim(To_char(eg.group_id)) as STID,
Trim(To_char(eg.group_id))||' - '|| eg.group_name as NAME
from emig.emig_groups eg
where  (eg.GROUP_ID = 232 OR eg.GROUP_ID >= 282)
order by eg.group_id asc;
