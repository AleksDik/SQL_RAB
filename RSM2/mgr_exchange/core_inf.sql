select a.*, a.rowid from core_register a
order by a.registerid desc

select a.*, a.rowid from core_register_attribute a
where a.registerid=  1620; --EP_PREMISE_Q  ���. ���� � �������. ������: ���������

select a.*, a.rowid from core_register_attribute a
where a.registerid= 1120 ; --U_PREMISE_Q      
       
select a.*, a.rowid from core_register_attribute a
where a.registerid=1121; --U_PREMISE_REL_Q ��������� �����

select a.*, a.rowid from core_register_attribute a
where a.registerid=1122; --U_PREMISE_REL_EXT_Q ��������� ������������� �����
-----------------------------------------------------------------------

select a.*, a.rowid from core_register_attribute a
where a.registerid=1600 ; -- EP_BUILDING_Q    ���. ���� � �������. �������: ������

select a.*, a.rowid from core_register_attribute a
where a.registerid=1100 ; -- U_BUILDING_Q    ������ ������

select a.*, a.rowid from core_register_attribute a
where a.registerid=1101 ; -- U_BUILDING_REL_Q    ������ �����


select a.*, a.rowid from core_register_attribute a
where a.registerid=1601 ; -- EP_BUILDING_ADDRESS_Q    ���. ���� � �������. �������: �����
select a.*, a.rowid from core_register_attribute a
where a.registerid=1102 ;   --- U_BUILDING_REL_EXT_Q ������ ������������� �����

---------------------------------------------------------------------
select a.*, a.rowid from core_register_attribute a
where a.registerid=1630 ; -- EP_RIGHT_Q    ���. ���� � �������. �������: ������

select a.*, a.rowid from core_register_attribute a
where a.registerid=1130 ; -- U_RIGHT_Q    ������ ������

select a.*, a.rowid from core_register_attribute a
where a.registerid=1131 ; -- U_RIGHT_REL_Q    ������ �����

-------------------- ����������� ----------------------------------
select c.* from CORE_REFERENCE ;

select c.* from CORE_REFERENCE_ITEM c 
where  c.referenceid in (2034); --�������� ������
