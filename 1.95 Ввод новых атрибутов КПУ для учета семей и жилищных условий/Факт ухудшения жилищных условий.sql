--���� � ����������� ���� ��������� �������� ������� (�����������);
-- ����������� ��������� ����������� -������� ��������� �������� ������� (�����������)

-- ====== ������� ����� ���������� � �������� ������������ (91) ==
--���������
select *
 from CLASSIFIER_KURS3 cl 
where classifier_num = 91
order by row_num desc;
-- �������
INSERT INTO CLASSIFIER_KURS3 
SELECT 
   91 as CLASSIFIER_NUM, 
 (select Max(cl.row_num)+1 from CLASSIFIER_KURS3 cl where classifier_num = 91) 
      as ROW_NUM, 
   sysdate as LAST_CHANGE, 
   1 as ROW_STATUS, 
   '������� ��������� �������� ������� (�����������)' as NAME, 
   '������� �����. ���. ���.' as SHORT_NAME1,
   NULL as SHORT_NAME2, 
   NULL as SHORT_NAME3, 
   0 as  DELETED 
FROM DUAL;
Commit;
--��������� (140)
select *
 from CLASSIFIER_KURS3 cl 
where classifier_num = 91
order by row_num desc

-- === ������� ������ � ����� ���������� ==
--���������
select t.* from CLASSIFIER_KURS3 t
where classifier_num = (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91) 
-- �������
INSERT INTO CLASSIFIER_KURS3 
SELECT 
 (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91)  as CLASSIFIER_NUM, 
  rownum as ROW_NUM, 
  sysdate as LAST_CHANGE, 
   1 as ROW_STATUS,
   Case rownum
       when 1 then ''
       when 2 then '��������� ������� �����. ���. ���. ����� ���������� ������' --���������� ������'
       when 3 then '����� ������ �����������' 
       when 4 then '�����.�����.���-��� � �����.�/�,��������� �����.� ���.����'--��������, ��������� ��������� ������� � �������� �������'
       when 5 then '�����.������� �����, � �.�.� ���������� ����������� �����' -- ����� �����' 
       when 6 then '�������� � �/� ���� ��� (�� ������.������.������.�������)' --�������� ��������� �������)' 
       when 7 then '����� ���� ������������� ����� ���������' 
       when 8 then '��������.���������� � �����.������� � ������ �� ����� �/�' --����� ������ ��������� ��� ������ ������ ���������' 
    end      
   as NAME, 
   null as SHORT_NAME1, 
    NULL as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL100 where rownum<9 ;
commit;
--���������
select t.*, t.rowid from CLASSIFIER_KURS3 t
where classifier_num=140
-- ============================================
        
--==--���� � ����������� ���������� � ������� ���������� �������� � �� �������(�����������);
-- ����������� ��������� ����������� -o	��������  ==========
--���������
select *
 from CLASSIFIER_KURS3 cl 
where classifier_num = 91
order by row_num desc;
-- �������
INSERT INTO CLASSIFIER_KURS3 
SELECT 
   91 as CLASSIFIER_NUM, 
 (select Max(cl.row_num)+1 from CLASSIFIER_KURS3 cl where classifier_num = 91) 
      as ROW_NUM, 
   sysdate as LAST_CHANGE, 
   1 as ROW_STATUS, 
   '�������� (�����������)' as NAME, 
   '��������' as SHORT_NAME1,
   NULL as SHORT_NAME2, 
   NULL as SHORT_NAME3, 
   0 as  DELETED 
FROM DUAL;
Commit;
--��������� (141)
select *
 from CLASSIFIER_KURS3 cl 
where classifier_num = 91
order by row_num desc

-- === ������� ������ � ����� ���������� ==
--���������
select t.* from CLASSIFIER_KURS3 t
where classifier_num = (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91) 
-- �������
INSERT INTO CLASSIFIER_KURS3 
SELECT 
 (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91)  as CLASSIFIER_NUM, 
  rownum as ROW_NUM, 
  sysdate as LAST_CHANGE, 
   1 as ROW_STATUS,
   Case rownum
       when 1 then ''
       when 2 then '����������'
       when 3 then '���������� ������������ � ���������' 
       when 4 then '��������� ����� ���������'
       when 5 then '���������� �� �������� �����'
       when 6 then '������� ����������� �������� ��������� ������������� �������'
    end      
   as NAME, 
   null as SHORT_NAME1, 
    NULL as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL100 where rownum<7 ;
commit;
--���������
select t.*, t.rowid from CLASSIFIER_KURS3 t
where classifier_num = (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91) 


-- ����������� ��������� ����������� -o	������ ������� ��������  ==========
--���������
select *
 from CLASSIFIER_KURS3 cl 
where classifier_num = 91
order by row_num desc;
-- �������
INSERT INTO CLASSIFIER_KURS3 
SELECT 
   91 as CLASSIFIER_NUM, 
 (select Max(cl.row_num)+1 from CLASSIFIER_KURS3 cl where classifier_num = 91) 
      as ROW_NUM, 
   sysdate as LAST_CHANGE, 
   1 as ROW_STATUS, 
   '������ ������� �������� (�����������)' as NAME, 
   '������ ���. �����.' as SHORT_NAME1,
   NULL as SHORT_NAME2, 
   NULL as SHORT_NAME3, 
   0 as  DELETED 
FROM DUAL;
Commit;
--��������� (142)
select *
 from CLASSIFIER_KURS3 cl 
where classifier_num = 91
order by row_num desc

-- === ������� ������ � ����� ���������� ==
--���������
select t.* from CLASSIFIER_KURS3 t
where classifier_num = (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91) 
-- �������
INSERT INTO CLASSIFIER_KURS3 
SELECT 
 (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91)  as CLASSIFIER_NUM, 
  rownum as ROW_NUM, 
  sysdate as LAST_CHANGE, 
   1 as ROW_STATUS,
   Case rownum
       when 1 then ''
       when 2 then '������� ������ ��������� � ������������� ������'
       when 3 then '���������' 
       when 4 then '�������������� �������� �����'
       when 5 then '�������������� ��������� �������'
    end      
   as NAME, 
   null as SHORT_NAME1, 
    NULL as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL100 where rownum<6 ;
commit;
--���������
select t.*, t.rowid from CLASSIFIER_KURS3 t
where classifier_num = (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91) 
-- ============================================
--ID ���� �������� ���������� (���.120) � AFFAIR_EXT_DATA (�������������� ������ ��� ���)
--���������
select t.* from CLASSIFIER_KURS3 t
where classifier_num =120 
--
INSERT INTO CLASSIFIER_KURS3 
SELECT 
 120 as CLASSIFIER_NUM, 
 (select Max(cl.row_num)+1 from CLASSIFIER_KURS3 cl where classifier_num = 120)  as ROW_NUM,  --�������� - 6
  sysdate as LAST_CHANGE, 
  1 as ROW_STATUS,
  '���� ��������� �������� �������' as NAME, --��� �������� ���������� � AFFAIR_EXT_DATA
    null as SHORT_NAME1, 
    NULL as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL ;
commit;

INSERT INTO CLASSIFIER_KURS3 
SELECT 
 120 as CLASSIFIER_NUM, 
 (select Max(cl.row_num)+1 from CLASSIFIER_KURS3 cl where classifier_num = 120)  as ROW_NUM,  --�������� - 7
  sysdate as LAST_CHANGE, 
  1 as ROW_STATUS,
  '���������� � ������� ���������� ��������' as NAME,
    null as SHORT_NAME1, 
    NULL as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL ;
commit;
INSERT INTO CLASSIFIER_KURS3 
SELECT 
 120 as CLASSIFIER_NUM, 
 (select Max(cl.row_num)+1 from CLASSIFIER_KURS3 cl where classifier_num = 120)  as ROW_NUM, --�������� - 8
  sysdate as LAST_CHANGE, 
  1 as ROW_STATUS,
  '���������� � ������� ���������� ��������' as NAME, 
   null as SHORT_NAME1, 
    NULL as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL ;
commit;
--���������
select t.*, t.rowid from CLASSIFIER_KURS3 t
where classifier_num =120 

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
-- ============== ������� ���� �������������� ������ ��� ���  ===================
--ID ���� �������� ���������� (���.120) � AFFAIR_EXT_DATA (�������������� ������ ��� ���)
INSERT INTO CLASSIFIER_KURS3 
SELECT 
 120 as CLASSIFIER_NUM, 
 (select Max(cl.row_num)+1 from CLASSIFIER_KURS3 cl where classifier_num = 120)  as ROW_NUM, --�������� - 9
  sysdate as LAST_CHANGE, 
  1 as ROW_STATUS,
  '���� ������ � ���. ����� � ���' as NAME, 
   null as SHORT_NAME1, 
    NULL as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL ;
commit;
INSERT INTO CLASSIFIER_KURS3 
SELECT 
 120 as CLASSIFIER_NUM, 
 (select Max(cl.row_num)+1 from CLASSIFIER_KURS3 cl where classifier_num = 120)  as ROW_NUM, --�������� - 10
  sysdate as LAST_CHANGE, 
  1 as ROW_STATUS,
  '���� ������ �����' as NAME, 
   null as SHORT_NAME1, 
    NULL as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL ;
commit;
--���������
select t.*, t.rowid from CLASSIFIER_KURS3 t
where classifier_num =120 

/* ��������� ���������� � AFFAIR_EXT_DATA (�������������� ������ ��� ���)

classifier_num = 120 ROW_NUM = 9 (���� ������ � ���. ����� � ���)
-----------
data_id - '����. ID';
data_type_id  = 9 'ID ���� �������� ���������� (���.120)';
affair_id -  '��� ��� �� AFFAIR';
data_n  - NULL
data_s  - NULL
data_d   - ���� ���� ������ � ���. ����� � ���
data_version = 0 '������ (�������) �������� ���������� (0-���������, n-�������������)';

classifier_num = 120 ROW_NUM = 10 (���� ������ �����)
-----------
data_id - '����. ID';
data_type_id  = 10  'ID ���� �������� ���������� (���.120)';
affair_id -  '��� ��� �� AFFAIR';
data_n  - NULL
data_s  - NULL
data_d   - ���� ������ �����
data_version = 0 '������ (�������) �������� ���������� (0-���������, n-�������������)';
*/
-- ================ �������� ����� KURS3.PKG_AFFAIR ===========================

--  ======�������� �� ����� KURS3.PKG_AFFAIR ==========
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
--  ======����� �� ����� KURS3.PKG_AFFAIR ==========
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

-- ����� ������� function get_uhud_usl_strinfo  (������� ������ ��������� ���. ������� �� ��������� 5 ��� �� ��������� ID ��� ��� ����������� � get_affair_text)
-- �������� ������� FUNCTION get_affair_text (�������� ���)
-- ��������� (ilonis 17.06.2013  to Dikan) � PROCEDURE kursiv.do_for_taffair

/*==����� ���� ��� ����������� � ������� ��� V_AFFAIRS_LIST  ==========
�_������ � ���. �����_�
�_����� �����_�
*/
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);
-- ������� � ������ ��� V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'�_������ � ���. �����_�' as FIELD_TITLE, 
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
-- ��������� --
select l.*, l.rowid
FROM LIST_FIELDS L
where L.LIST_COD = 1 
order by L.FIELD_ID desc
-- ������� � ������ ��� V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'�_����� �����_�' as FIELD_TITLE, 
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
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);


/*==����� ���� ��� ����������� � ������� ��� V_AFFAIRS_LIST  ==========
��������� ���. ������� �� 5 ���    UHUD_ZIL_USL - ����� �/���_ 5 ���
������� ����. (������� ���������); REASON_UHUD_ZIL_USL - ����� �/���_ �������
�_����. (���� ���������);  DATE_UHUD_ZIL_USL - ����� �/���_ �
����������_���� (���������� _���������) PRIM_UHUD_ZIL_USL - ����� �/���_ ����������

��������; PROBLEM_PERES - �_��������
����������_�����. (����������_��������) PRIM_PROBLEM_PERES  - �_��������_����������
������ ���. �����. (������ ������� ��������); TYPE_SOLUTION - �_��������_�������
�_���. �����. (���� ������� ��������) DATE_SOLUTION         - �_��������_� �������

*/
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);
-- ������� � ������ ��� V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'����� �/���_ 5 ���' as FIELD_TITLE, 
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
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);
-- ������� � ������ ��� V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'����� �/���_ �������' as FIELD_TITLE, 
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
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);
 
-- ������� � ������ ��� V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'����� �/���_ �' as FIELD_TITLE, 
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
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);
-- ������� � ������ ��� V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'����� �/���_ ����������' as FIELD_TITLE, 
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
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1);
 -- ������� � ������ ��� V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'�_��������' as FIELD_TITLE, 
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
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1); 

 -- ������� � ������ ��� V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'�_��������_����������' as FIELD_TITLE, 
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
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1); 
 -- ������� � ������ ��� V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'�_��������_�������' as FIELD_TITLE, 
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
-- ��������� --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1); 

-- ������� � ������ ��� V_AFFAIRS_LIST  List_Cod = 1  
insert into LIST_FIELDS 
SELECT 
 1 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 1) as FIELD_ID, 
'�_��������_� �������' as FIELD_TITLE, 
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
where L.LIST_COD = 1 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 1); 

-- =============== ����� �� ����� ����� ========================
/*
������� ���� ������ � ���. ����� � ���		�� /��� - �_������ � ���. �����_� �������
���� ������ � ���. ����� � ��� 	����� �������� �� ���������	 - �_������ � ���. �����_�
������� ���� ������ �����			�� /��� - �_����� �����_� �������
���� ������ �����		����� �������� �� ��������� - �_����� �����_�
*/
 -- =============������� ������ �� ������� ���� ������ � ���. ����� � ��� ==============
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6001 and LIST_COD = 1
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6001  as COND_ID, --!!
   1 as LIST_COD, 
   '�_������ � ���. �����_� �������' as COND_NAME, 
   2 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP)+10 from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --����� ������ �������
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
--delete
from LIST_CONDITIONS
where COND_ID=6001 and 
LIST_COD = 1

--====== �������
INSERT INTO OPERATION_TYPES 
(
SELECT 
6001 as COND_ID, --!!
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number �.�. CLASSIFIER.CLASSIFIER_NUM=8 (��/���) ������ (1/2) � 'NVL2(pkg_affair.get_affair_ext_data_d (affair.affair_id,9,0),1,2)' ������ (1/2)
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
-- ��������� ��� ��������  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID =6001
and t.list_cod=1
 -- =============������� ������ �� ���� ������ � ���. ����� � ��� ==============
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6002 and LIST_COD = 1
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6002  as COND_ID, 
   1 as LIST_COD, 
   '�_������ � ���. �����_�' as COND_NAME, 
   1 as COND_TYPE, --��������� ������ ����.
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
--delete
from LIST_CONDITIONS
where COND_ID=6002 and 
LIST_COD = 1

--====== �������
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
-- ��������� ��� ��������  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID <6020
and t.list_cod=1
order by t.cond_id desc
 -- =============������� ������ �� ������� ���� ������ ����� ==============
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6003 and LIST_COD = 1
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6003  as COND_ID, --!!
   1 as LIST_COD, 
   '�_����� �����_� �������' as COND_NAME, 
   2 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6003 and 
LIST_COD = 1

--====== �������
INSERT INTO OPERATION_TYPES 
(
SELECT 
6003 as COND_ID, --!!
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number �.�. CLASSIFIER.CLASSIFIER_NUM=8 (��/���) ������ (1/2) � 'NVL2(pkg_affair.get_affair_ext_data_d (affair.affair_id,9,0),1,2)' ������ (1/2)
'AFFAIR'  as TABLE_NAME,
'NVL2(pkg_affair.get_affair_ext_data_d(affair.affair_id,pkg_affair.get_export_fam_type_id,0),1,2)'  as FIELD_NAME, --��� ������ ...._type_id
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
t.COND_ID =6003
and t.list_cod=1
 -- =============������� ������ �� ���� ������ ����� ==============
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6004 and LIST_COD = 1
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6004  as COND_ID, 
   1 as LIST_COD, 
   '�_����� �����_�' as COND_NAME, 
   1 as COND_TYPE, --��������� ������ ����.
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, 
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6004 and 
LIST_COD = 1

--====== �������
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
-- ��������� ��� ��������  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID =6004
and t.list_cod=1

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
select *
from LIST_CONDITIONS
where COND_ID=6005 and LIST_COD = 1
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6005  as COND_ID, --!!
   1 as LIST_COD, 
   '����� �/���_ �������_�������' as COND_NAME, 
   2 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) + 10 from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --����� ������
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6005 and 
LIST_COD = 1

--====== �������
INSERT INTO OPERATION_TYPES 
(
SELECT 
6005 as COND_ID, --!!
1 as LIST_COD,
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
and t.list_cod=1

 -- =============������� ������ �� ���� ���������    �� /��� ==============
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6006 and LIST_COD = 1
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6006  as COND_ID, --!!
   1 as LIST_COD, 
   '����� �/���_ �_�������' as COND_NAME, 
   2 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --������� ������
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6006 and 
LIST_COD = 1

--====== �������
INSERT INTO OPERATION_TYPES 
(
SELECT 
6006 as COND_ID, --!!
1 as LIST_COD,
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
and t.list_cod=1


 -- =============������� ������ �� ���������� ���������   �� /��� ==============
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6007 and LIST_COD = 1
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6007  as COND_ID, --!!
   1 as LIST_COD, 
   '����� �/���_ ����������_�������' as COND_NAME, 
   2 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --������� ������
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6007 and 
LIST_COD = 1

--====== �������
INSERT INTO OPERATION_TYPES 
(
SELECT 
6007 as COND_ID, --!!
1 as LIST_COD,
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
and t.list_cod=1


 -- =============������� ������ �� ������� ���������� ��������   �� /��� ==============
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6008 and LIST_COD = 1
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6008  as COND_ID, --!!
   1 as LIST_COD, 
   '�_��������_�������' as COND_NAME, 
   2 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) +10 from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --����� ������
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6008 and 
LIST_COD = 1

--====== �������
INSERT INTO OPERATION_TYPES 
(
SELECT 
6008 as COND_ID, --!!
1 as LIST_COD,
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
and t.list_cod=1

 -- =============������� ������ �� ������� ���������� ��������   �� /��� ==============
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6009 and LIST_COD = 1
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6009  as COND_ID, --!!
   1 as LIST_COD, 
   '�_��������_�������_�������' as COND_NAME, 
   2 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --������� ������
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6009 and 
LIST_COD = 1

--====== �������
INSERT INTO OPERATION_TYPES 
(
SELECT 
6009 as COND_ID, --!!
1 as LIST_COD,
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
and t.list_cod=1

 -- =============������� ������ �� ���� �������   �� /��� ==============
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6010 and LIST_COD = 1
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6010  as COND_ID, --!!
   1 as LIST_COD, 
   '�_��������_� �������_�������' as COND_NAME, 
   2 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --������� ������
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6010 and 
LIST_COD = 1

--====== �������
INSERT INTO OPERATION_TYPES 
(
SELECT 
6010 as COND_ID, --!!
1 as LIST_COD,
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
 t.list_cod=1
 order by t.cond_id desc

-- =============������� ������ �� ���������� � ��������   �_��������_����������_�������  �� /��� ==============
-- ��������� --
select t.*,t.rowid
from LIST_CONDITIONS t
where  t.LIST_COD = 1 and t.cond_id<6999 order by  t.COND_ID desc
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6012  as COND_ID, --!!
   1 as LIST_COD, 
   '�_��������_����������_�������' as COND_NAME, 
   2 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --������� ������
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6012 and 
LIST_COD = 1

--====== �������
INSERT INTO OPERATION_TYPES 
(
SELECT 
6012 as COND_ID, --!!
1 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , -- number 
'AFFAIR'  as TABLE_NAME,
'NVL2(pkg_affair.get_affair_ext_data_s(affair.affair_id,pkg_affair.get_problem_type_id,0),1,2)'  as FIELD_NAME, --��� ������ ...._type_id
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
t.COND_ID =6012
and t.list_cod=1

 -- =============������� ������ �� ��������� ���. ������� �� 5 ���   ==============
 /*
  ����� �/���_ 5 ���
 ��� ���
��, < 5���
��, > 5���
 */
-- ����� ������� ��� ������ �� ��������� ���. ������� �� 5 ��� 
-- pkg_affair.get_affair_ext_data_uhud5year(p_affair_id IN NUMBER) RETURN NUMBER;
 
 -- ����������� ��������� ����������� ������� ������ �� ��������� ���. ������� �� 5 ���  ==========
--���������
select *
 from CLASSIFIER_KURS3 cl 
where classifier_num = 91
order by row_num desc;
-- �������
INSERT INTO CLASSIFIER_KURS3 
SELECT 
   91 as CLASSIFIER_NUM, 
 (select Max(cl.row_num)+1 from CLASSIFIER_KURS3 cl where classifier_num = 91) 
      as ROW_NUM, 
   sysdate as LAST_CHANGE, 
   1 as ROW_STATUS, 
   '������� ������ �� ��������� ���. ������� �� 5 ���' as NAME, 
   NULL as SHORT_NAME1,
   NULL as SHORT_NAME2, 
   NULL as SHORT_NAME3, 
   0 as  DELETED 
FROM DUAL;
Commit;
--��������� (143)
select *
 from CLASSIFIER_KURS3 cl 
where classifier_num = 91
order by row_num desc

-- === ������� ������ � ����� ���������� ==
--���������
select t.* from CLASSIFIER_KURS3 t
where classifier_num = (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91) 
-- �������
INSERT INTO CLASSIFIER_KURS3 
SELECT 
 (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91)  as CLASSIFIER_NUM, 
  rownum as ROW_NUM, 
  sysdate as LAST_CHANGE, 
   1 as ROW_STATUS,
   Case rownum
       when 1 then '��� ���'
       when 2 then '��, < 5���'
       when 3 then '��, > 5���' 
    end      
   as NAME, 
      Case rownum
       when 1 then '��� ���'
       when 2 then '��, < 5���'
       when 3 then '��, > 5���' 
    end 
     as SHORT_NAME1, 
    NULL as SHORT_NAME2,
    NULL as SHORT_NAME3,
    0  as  DELETED 
FROM DUAL100 where rownum<4 ;
commit;
--���������
select t.*, t.rowid from CLASSIFIER_KURS3 t
where classifier_num = (select Max(cl.row_num) from CLASSIFIER_KURS3 cl where classifier_num = 91) 

-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6011 and LIST_COD = 1
-- �������
insert into LIST_CONDITIONS 
SELECT 
   6011  as COND_ID, --!!
   1 as LIST_COD, 
   '����� �/���_ 5 ���' as COND_NAME, 
   2 as COND_TYPE, --����� �� ������
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP)-10 from LIST_CONDITIONS where LIST_COD = 1 )  as COND_GROUP, --���������� ������
   1 as STATUS from dual;
   commit;
-- ��������� --
select *
from LIST_CONDITIONS
where COND_ID=6011 and 
LIST_COD = 1

--====== �������
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
-- ��������� ��� ��������  
select t.*,t.rowid  from OPERATION_TYPES t
where 
t.COND_ID =6011
and t.list_cod=1


 







