create or replace function get_scan_error_for_affair(p_affair_id in scan.ea_delo_attr.object_rel_id%Type, p_mode in number := 0) return integer is
/* ������� ������� ������� (������������ ������) �� ��������� ID ���

p_mode - ���������� ���-�� �������� �������� ���: 
0 - ��� �������, 
������� : 1 - ����� (������� ���);
          2 - ���� (������ ���)
          3 - ���� � �����������  (���� ������)
1 - ��� �������: 
    1 - ����� (������� ���); 
    2 - ����             
22.01.2013 ����� �.
*/          
  Result integer;
  v_delo_id scan.ea_delo_attr.delo_id%Type;
begin
  
Result := 1; -- �����
v_delo_id := -1; -- init  

-- ����� ��� ���� �� ID ��� --
select max(a.delo_id) into v_delo_id   
from scan.ea_delo_attr a
where a.object_type_id in (1,7,12)   --  ��� - affair (�� ������� scan.ea_object_type )
and   a.object_rel_id= p_affair_id
and   NVL(a.row_status,0) <>0;

if NVL(v_delo_id,-1) < 0 then --������� ���
   return(Result);
end if ; 

-- ���� ������� (����) �� �������� ��� (p_affair_id)
 if p_mode > 0 then --����� ��� �������
   Result := 2;
   return(Result); --���
end if ; 

--����� ��� �������
-- �������� ���-�� ������ � ����
select count(d.label_type_id) into Result 
from scan.ea_delo_label d 
where d.delo_id= v_delo_id;

if Result>0 
   then  Result := 3; -- ���� ������
   else  Result := 2; -- ��� ������
end if;

  
 return(Result); 
end get_scan_error_for_affair;
/
