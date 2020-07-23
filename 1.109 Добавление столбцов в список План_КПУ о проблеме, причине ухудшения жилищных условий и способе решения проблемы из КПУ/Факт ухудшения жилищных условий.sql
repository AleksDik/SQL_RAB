--���� � ����������� ���� ��������� �������� ������� (�����������);


/* ��������� ���������� � AFFAIR_EXT_DATA (�������������� ������ ��� ���)

classifier_num = 120 ROW_NUM = 6 (���� ��������� �������� �������)
-----------
data_id - '����. ID';
data_type_id  = 6 'ID ���� �������� ���������� (���.120)';
affair_id -  '��� ��� �� AFFAIR';
data_n  - ��� ������� ������� ��������� �������� ������� (���������� 140; classifier_num =140 )
data_s  - ������ ����������
data_d   - ���� ��������� �������� �������
data_version = 0 '������ (�������) �������� ���������� (0-���������, n-�������������)';

classifier_num = 120 ROW_NUM = 7 (���������� � ������� ���������� ��������)
---------
data_id - '����. ID';
data_type_id  = 7 'ID ���� �������� ���������� (���.120)';
affair_id -  '��� ��� �� AFFAIR';
data_n  - ��� �������� (�����������) (���������� 141; classifier_num =141 )
data_s  - ������ ����������
data_d   - ���� ������������� ��������
data_version = 0 '������ (�������) �������� ���������� (0-���������, n-�������������)';

classifier_num = 120 ROW_NUM = 8 (���������� � ������� ���������� ��������)
---------
data_id - '����. ID';
data_type_id  = 8 'ID ���� �������� ���������� (���.120)';
affair_id -  '��� ��� �� AFFAIR';
data_n  - ��� ������� ������� �������� (�����������)(���������� 142; classifier_num =142 )
data_s  - ������ ����������
data_d   - ���� ������� ��������
data_version = 0 '������ (�������) �������� ���������� (0-���������, n-�������������)';

*/



/*==����� ���� ��� ����������� � ������� ���� ��� V_PLAN_KPU_LIST  ==========
��������� ���. ������� �� 5 ���    UHUD_ZIL_USL - ����� �/���_ 5 ���
������� ����. (������� ���������); REASON_UHUD_ZIL_USL - ����� �/���_ �������
�_����. (���� ���������);  DATE_UHUD_ZIL_USL - ����� �/���_ �
����������_���� (���������� _���������) PRIM_UHUD_ZIL_USL - ����� �/���_ ����������

��������; PROBLEM_PERES - �_��������
����������_�����. (����������_��������) PRIM_PROBLEM_PERES  - �_��������_����������
������ ���. �����. (������ ������� ��������); TYPE_SOLUTION - �_��������_������� -- ���
�_���. �����. (���� ������� ��������) DATE_SOLUTION         - �_��������_�_�������

���� ��������  DATE_PROBLEM_PERES         - �_��������_�

*/
-- ��������� --
select rowid ,L.*
FROM LIST_FIELDS L
where L.LIST_COD = 17 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 17);
-- ������� � ������ ���� ��� V_PLAN_KPU_LIST  List_Cod = 17  
insert into LIST_FIELDS 
SELECT 
 17 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 17) as FIELD_ID, 
'����� �/���_ 5 ���' as FIELD_TITLE, 
65 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'UHUD_ZIL_USL' as  FIELD_NAME,
'V_PLAN_KPU_LIST' as TABLE_NAME, 
--'AFFAIR_EXT_DATA' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 17 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 17);
-- ������� � ������ ���� ��� V_PLAN_KPU_LIST  List_Cod = 17
insert into LIST_FIELDS 
SELECT 
 17 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 17) as FIELD_ID, 
'����� �/���_ �������' as FIELD_TITLE, 
80 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'REASON_UHUD_ZIL_USL' as  FIELD_NAME,
'V_PLAN_KPU_LIST' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 17 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 17);
 
-- ������� � ������ ���� ��� V_PLAN_KPU_LIST  List_Cod = 17 
insert into LIST_FIELDS 
SELECT 
 17 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 17) as FIELD_ID, 
'����� �/���_ �' as FIELD_TITLE, 
50 as  FIELD_W, 
3 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'DATE_UHUD_ZIL_USL' as  FIELD_NAME,
'AFFAIR_EXT_DATA' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 17 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 17);
-- ������� � ������ ���� ��� V_PLAN_KPU_LIST  List_Cod = 17 
insert into LIST_FIELDS 
SELECT 
 17 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 17) as FIELD_ID, 
'����� �/���_ ����������' as FIELD_TITLE, 
65 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'PRIM_UHUD_ZIL_USL' as  FIELD_NAME,
'AFFAIR_EXT_DATA' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 17 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 17);
-- ������� � ������ ���� ��� V_PLAN_KPU_LIST  List_Cod = 17  
insert into LIST_FIELDS 
SELECT 
 17 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 17) as FIELD_ID, 
'�_��������' as FIELD_TITLE, 
80 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'PROBLEM_PERES' as  FIELD_NAME,
'V_PLAN_KPU_LIST' as TABLE_NAME, 
--'AFFAIR_EXT_DATA' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 17 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 17); 

-- ������� � ������ ���� ��� V_PLAN_KPU_LIST  List_Cod = 17  
insert into LIST_FIELDS 
SELECT 
 17 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 17) as FIELD_ID, 
'�_��������_����������' as FIELD_TITLE, 
80 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'PRIM_PROBLEM_PERES' as  FIELD_NAME,
'AFFAIR_EXT_DATA' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 17 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 17); 

/*
-- ������� � ������ ���� ��� V_PLAN_KPU_LIST  List_Cod = 17  
insert into LIST_FIELDS 
SELECT 
 17 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 17) as FIELD_ID, 
'�_��������_�������' as FIELD_TITLE, 
80 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'TYPE_SOLUTION' as  FIELD_NAME,
'V_PLAN_KPU_LIST' as TABLE_NAME, 
--'AFFAIR_EXT_DATA' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 17 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 17); 
*/


-- ������� � ������ ���� ��� V_PLAN_KPU_LIST  List_Cod = 17  
insert into LIST_FIELDS 
SELECT 
 17 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 17) as FIELD_ID, 
'�_��������_�' as FIELD_TITLE, 
60 as  FIELD_W, 
3 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'DATE_PROBLEM_PERES' as  FIELD_NAME,
'AFFAIR_EXT_DATA' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 17 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 17); 

-- ������� � ������ ���� ��� V_PLAN_KPU_LIST  List_Cod = 17  
insert into LIST_FIELDS 
SELECT 
 17 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 17) as FIELD_ID, 
'�_��������_�_�������' as FIELD_TITLE, 
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
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 17 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 17); 

-- =============== ����� �� ����� ����� ========================
/*
������� ��������� �� /��� - ����� �/���_ �������_�������
���� ���������    �� /��� - ����� �/���_ �_�������
���������� ���������  �� /��� - ����� �/���_ ����������_�������
������� ���������� ��������   �� /��� - �_��������_�������
������� ���������� ��������   �� /��� - �_��������_�������_�������
���� �������   �� /��� - �_��������_� �������_�������
�_��������_����������_�������  �� /��� 
*/
 -- =============������� ������ �� ������� ��������� �� /��� ==============
-- ��������� --
select rowid ,l.*
from LIST_CONDITIONS l
where COND_ID=6005 and 
LIST_COD = 17
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6005  as COND_ID, --!!
   17 as LIST_COD, 
   '����� �/���_ �������_�������' as COND_NAME, 
   2 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) + 10 from LIST_CONDITIONS where LIST_COD = 17 )  as COND_GROUP, --����� ������
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6005 and 
LIST_COD = 17

--====== �������
INSERT INTO OPERATION_TYPES 
(
SELECT 
6005 as COND_ID, --!!
17 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number �.�. CLASSIFIER.CLASSIFIER_NUM=8 (��/���) ������ (1/2) � 'NVL2(pkg_affair.get_affair_ext_data_d (affair.affair_id,9,0),1,2)' ������ (1/2)
'AFFAIR'  as TABLE_NAME,
'NVL2(pkg_affair.get_affair_ext_data_n(affair.affair_id,pkg_affair.get_uhud_type_id,0),1,2)'  as FIELD_NAME, --��� ������ ...._type_id
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
-- ��������� ��� ��������  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID =6005
and t.list_cod=17

 -- =============������� ������ �� ���� ���������    �� /��� ==============
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6006 and LIST_COD = 17
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6006  as COND_ID, --!!
   17 as LIST_COD, 
   '����� �/���_�_�������' as COND_NAME, 
   2 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 17 )  as COND_GROUP, --������� ������
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6006 and 
LIST_COD = 17

--====== �������
INSERT INTO OPERATION_TYPES 
(
SELECT 
6006 as COND_ID, --!!
17 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'NVL2(pkg_affair.get_affair_ext_data_d(affair.affair_id,pkg_affair.get_uhud_type_id,0),1,2)'  as FIELD_NAME, --��� ������ ...._type_id
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
-- ��������� ��� ��������  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID =6006
and t.list_cod=17


 -- =============������� ������ �� ���������� ���������   �� /��� ==============
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6007 and LIST_COD = 17
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6007  as COND_ID, --!!
   17 as LIST_COD, 
   '����� �/���_ ����������_�������' as COND_NAME, 
   2 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 17 )  as COND_GROUP, --������� ������
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6007 and 
LIST_COD = 17

--====== �������
INSERT INTO OPERATION_TYPES 
(
SELECT 
6007 as COND_ID, --!!
17 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'NVL2(pkg_affair.get_affair_ext_data_s(affair.affair_id,pkg_affair.get_uhud_type_id,0),1,2)'  as FIELD_NAME, --��� ������ ...._type_id
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
-- ��������� ��� ��������  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID =6007
and t.list_cod=17


 -- =============������� ������ �� ������� ���������� ��������   �� /��� ==============
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6008 and LIST_COD = 17
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6008  as COND_ID, --!!
   17 as LIST_COD, 
   '�_��������_�������' as COND_NAME, 
   2 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) +10 from LIST_CONDITIONS where LIST_COD = 17 )  as COND_GROUP, --����� ������
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6008 and 
LIST_COD = 17

--====== �������
INSERT INTO OPERATION_TYPES 
(
SELECT 
6008 as COND_ID, --!!
17 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'DECODE(pkg_affair.get_affair_ext_data_ver(affair.affair_id,pkg_affair.get_problem_type_id),0,2,1)'  as FIELD_NAME, --��� ������ ...._type_id
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
-- ��������� ��� ��������  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID =6008
and t.list_cod=17

 -- =============������� ������ �� ������� ���������� ��������   �� /��� ==============
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6009 and LIST_COD = 17
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6009  as COND_ID, --!!
   17 as LIST_COD, 
   '�_��������_�������_�������' as COND_NAME, 
   2 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 17 )  as COND_GROUP, --������� ������
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6009 and 
LIST_COD = 17

--====== �������
INSERT INTO OPERATION_TYPES 
(
SELECT 
6009 as COND_ID, --!!
17 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'DECODE(pkg_affair.get_affair_ext_data_ver(affair.affair_id,pkg_affair.get_solution_type_id),0,2,1)'  as FIELD_NAME, --��� ������ ...._type_id
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
-- ��������� ��� ��������  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID =6009
and t.list_cod=17

 -- =============������� ������ �� ���� �������   �� /��� ==============
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6010 and LIST_COD = 17
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6010  as COND_ID, --!!
   17 as LIST_COD, 
   '�_��������_� �������_�������' as COND_NAME, 
   2 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 17 )  as COND_GROUP, --������� ������
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6010 and 
LIST_COD = 17

--====== �������
INSERT INTO OPERATION_TYPES 
(
SELECT 
6010 as COND_ID, --!!
17 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'NVL2(pkg_affair.get_affair_ext_data_d(affair.affair_id,pkg_affair.get_solution_type_id,0),1,2)'  as FIELD_NAME, --��� ������ ...._type_id
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
-- ��������� ��� ��������  
select t.*,t.rowid  from OPERATION_TYPES t
where 
 t.list_cod=17
 order by t.cond_id desc


 -- =============������� ������ �� ��������� ���. ������� �� 5 ���   ==============
 /*
  ����� �/���_ 5 ���
 ��� ���
��, < 5���
��, > 5���
 */
-- ����� ������� ��� ������ �� ��������� ���. ������� �� 5 ��� 
-- pkg_affair.get_affair_ext_data_uhud5year(p_affair_id IN NUMBER) RETURN NUMBER;
 

-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6011 and LIST_COD = 17
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6011  as COND_ID, --!!
   17 as LIST_COD, 
   '����� �/���_ 5 ���' as COND_NAME, 
   2 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP)-10 from LIST_CONDITIONS where LIST_COD = 17 )  as COND_GROUP, --���������� ������
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6011 
and LIST_COD = 17

--====== �������
INSERT INTO OPERATION_TYPES 
(
SELECT 
6011 as COND_ID, --!!
17 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'pkg_affair.get_affair_ext_data_uhud5year(affair.affair_id)'  as FIELD_NAME, 
'CLASSIFIER_NUM=144 and DELETED=0'
 as DICT_WHERE,
'CLASSIFIER_KURS3' as DICT_NAME,
'SHORT_NAME1 /*&& ,ROW_NUM ID*/' as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
-- ��������� ��� ��������  
select t.*,t.rowid  from OPERATION_TYPES t
where
t.COND_ID = 6011
and 
t.list_cod=17

 -- =============������� ������ �� �_��������_�   ==============
select *
from LIST_CONDITIONS
where COND_ID>=6020 and LIST_COD = 17
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6020  as COND_ID, --!!
   17 as LIST_COD, 
   '�_��������_�' as COND_NAME, 
   1 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP)+10 from LIST_CONDITIONS where LIST_COD = 17 )  as COND_GROUP, --���������� ������
   1 as STATUS from dual;
   commit;

insert into LIST_CONDITIONS 
SELECT 
   6021  as COND_ID, --!!
   17 as LIST_COD, 
   '�_��������_�' as COND_NAME, 
   1 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 17 )  as COND_GROUP,
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   6022  as COND_ID, --!!
   17 as LIST_COD, 
   '�_��������_�' as COND_NAME, 
   1 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 17 )  as COND_GROUP,
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   6023  as COND_ID, --!!
   17 as LIST_COD, 
   '�_��������_�' as COND_NAME, 
   1 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 17 )  as COND_GROUP,
   1 as STATUS from dual;
   commit;   
 
insert into LIST_CONDITIONS 
SELECT 
   6024  as COND_ID, --!!
   17 as LIST_COD, 
   '�_��������_�' as COND_NAME, 
   1 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 17 )  as COND_GROUP,
   1 as STATUS from dual;
   commit; 

insert into LIST_CONDITIONS 
SELECT 
   6025  as COND_ID, --!!
   17 as LIST_COD, 
   '�_��������_�' as COND_NAME, 
   1 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 17 )  as COND_GROUP,
   1 as STATUS from dual;
   commit; 
--------------------------------------------------------------------------------
INSERT INTO OPERATION_TYPES 
(
SELECT 
6020 as COND_ID, --!!
17 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
3 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'pkg_affair.get_affair_ext_data_d(affair.affair_id,pkg_affair.get_problem_type_id)'  as FIELD_NAME, 
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
6021 as COND_ID, --!!
17 as LIST_COD,
2 as OPERATION_COD, 
'>' as OPERATION_NAME,   
3 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'pkg_affair.get_affair_ext_data_d(affair.affair_id,pkg_affair.get_problem_type_id)'  as FIELD_NAME, 
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
6022 as COND_ID, --!!
17 as LIST_COD,
3 as OPERATION_COD, 
'>=' as OPERATION_NAME,   
3 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'pkg_affair.get_affair_ext_data_d(affair.affair_id,pkg_affair.get_problem_type_id)'  as FIELD_NAME, 
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
6023 as COND_ID, --!!
17 as LIST_COD,
4 as OPERATION_COD, 
'<' as OPERATION_NAME,   
3 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'pkg_affair.get_affair_ext_data_d(affair.affair_id,pkg_affair.get_problem_type_id)'  as FIELD_NAME,  
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
6024 as COND_ID, --!!
17 as LIST_COD,
5 as OPERATION_COD, 
'<=' as OPERATION_NAME,   
3 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'pkg_affair.get_affair_ext_data_d(affair.affair_id,pkg_affair.get_problem_type_id)'  as FIELD_NAME, 
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
6025 as COND_ID, --!!
17 as LIST_COD,
6 as OPERATION_COD, 
'<>' as OPERATION_NAME,   
3 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'pkg_affair.get_affair_ext_data_d(affair.affair_id,pkg_affair.get_problem_type_id)'  as FIELD_NAME, 
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;

-- ��������� ��� ��������  
select t.*,t.rowid  from OPERATION_TYPES t
where
FIELD_TYPE=3 
and 
t.list_cod=17
order by COND_ID desc
