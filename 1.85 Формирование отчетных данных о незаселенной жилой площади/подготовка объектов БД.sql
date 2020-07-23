
-- ======= �����  ��������� ������ ����������� ���������� (�� �����������) � ������� ���.���������  
--���������
select * from GLOBAL_PARAMETERS t
where parameter_name like 'UR_%'
--�������
insert into global_parameters
(num_value, parameter_name, value, last_change)
( select 1 as num_value,                        --� �������� ������� ��(���������� ���������� �������� �������� ) �����������
       'UR_N_PERESELENIE' as parameter_name,
       '6,16,17,18,19,33,34,35,36,58' as value, --������ ���.��������� 
        sysdate as last_change
  from dual
  union   
  select 2 as num_value, 
       'UR_N_PEREOFORMLENIE' as parameter_name,
       '25,42' as value, 
        sysdate as last_change
  from dual  
  union   
  select 3 as num_value, 
       'UR_N_OCHEREDNIKI' as parameter_name,
       '1,2,3,4,5,11,12,13,14,15,28,29,30,31,32,47' as value, 
        sysdate as last_change
  from dual    
);
commit;

--���������
select * from GLOBAL_PARAMETERS t
where parameter_name like 'UR_%'                  

--==���� ��� ����������� � ������==========
/*
�� ����������  ur_territory
�� ������������� ur_rasporyadytel
�� ����������� ur_direction
�� ���� �� ���������� ur_period_for_implement
�������� ur_territory,ur_rasporyadytel,ur_direction,ur_period_for_implement � V_HOUSING_LIST*/

--���������
select *
FROM LIST_FIELDS L
where L.LIST_COD=3 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 3);

-- �������
insert into LIST_FIELDS 
(SELECT 
 3 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 3) as FIELD_ID, 
'�� ����������' as FIELD_TITLE, 
90 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'ur_territory' as  FIELD_NAME,
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
'�� �������������' as FIELD_TITLE, 
60 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'ur_rasporyadytel' as  FIELD_NAME,
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
(select Max(FIELD_ID)+3 from LIST_FIELDS where LIST_COD = 3) as FIELD_ID, 
'�� �����������' as FIELD_TITLE, 
100 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'ur_direction' as  FIELD_NAME,
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
(select Max(FIELD_ID)+4 from LIST_FIELDS where LIST_COD = 3) as FIELD_ID, 
'�� ���� �� ����������' as FIELD_TITLE, 
100 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'ur_period_for_implement' as  FIELD_NAME,
'V_HOUSING_LIST' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual

);

commit;
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD=3 
order by L.FIELD_ID desc;

--������� ����� KURS3.MANAGEMENT_REALIZATION_DATA
-- ���� �����
GRANT EXECUTE ON KURS3.MANAGEMENT_REALIZATION_DATA TO "PUBLIC";

--�������� ���� � V_HOUSING_LIST
--  #Dik_09.04.2013 
 /*
           case 
             when  free_space.status in (1,2,4,5)
             then  management_realization_data.Get_ur_territory_title(free_space.freespace_id)
             else  NULL
           end  as ur_territory,
           case 
             when  free_space.status in (1,2,4,5)
             then  management_realization_data.Get_ur_rasporyadytel_title(free_space.freespace_id)
             else  NULL
           end  as ur_rasporyadytel,
           case 
             when ( free_space.status in (1,2,4,5)) and (free_space.LAST = 1)
             then  management_realization_data.Get_ur_direction_title(free_space.freespace_id)
             else  NULL
           end as ur_direction,
           case 
             when  free_space.status in (1,2,5)
             then  management_realization_data.Get_period_for_implement_title(free_space.freespace_id)
             else  NULL
           end as ur_period_for_implement
 */          
-- / #Dik_09.04.2013 
              
