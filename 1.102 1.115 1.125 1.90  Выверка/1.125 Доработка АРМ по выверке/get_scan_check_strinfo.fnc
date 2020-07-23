create or replace function get_scan_check_strinfo(p_affair_id in scan.ea_delo_attr.object_rel_id%Type,p_mode in number := 0,p_format in number:=0) return VARCHAR2 is
/* ������� ������ � ���������� ������������ ������ �� ��������� ID ��� ��� ����������� � get_affair_text
p_mode - ���������� ���-�� �������� �������� ���: 
0 - ��� �������, 
������� : 1 - ����� (������� ���);
          2 - ���� (������ ���)
          3 - ���� � �����������  (���� ������)
1 - ��� �������: 
    1 - ������� ���; 
    2 - ����  
p_format - ��� ��������������
0 - rtf, 1 - txt, 2 - html               
23.01.2013 ����� �.
*/ 
  tempStr VARCHAR2(1950);
  c_L CONSTANT binary_integer :=1950;
  c_dL CONSTANT binary_integer :=6; -- = length(c_def)+length(c_more)
  c_def CONSTANT varchar2(3) := ' - ';
  c_more CONSTANT varchar2(3):= '...'; 
  Res VARCHAR2(2000):='  ��. �����: ';
  v_delo_id scan.ea_delo_attr.delo_id%Type:= -1;
  i binary_integer := 0;
  c_yes CONSTANT varchar2(6) := '����';
  c_no_err CONSTANT varchar2(20) := ', ��� ���������.';
  c_err CONSTANT varchar2(20) := ' c �����������:';
  c_no_catalog CONSTANT varchar2(50) := '��� ���������� ������������ ��������.';
  v_CR  varchar2(10) :='\par ';-- UTL_TCP.crlf;
  v_Bold  varchar2(3) := '{\b';
  v_BoldEnd  varchar2(4) := '}';
  c_Priv constant integer := 114; -- ��� ���������� "����������� ����������� �������"
  v_user_id  who_work.user_id%Type; -- ��� �������� ������������
  v_comments  scan.ea_delo.delo_comment%Type := NULL;
  v_comments_beg  varchar2(60) := '  ����������� � ����������: \par \i '||chr(9);
  v_comments_end  varchar2(3) := '';
begin
 -- ��������� ����� --- 
    select ww.user_id into v_user_id from who_work ww
    where ww.uni_session_id =userenv('SESSIONID')
    and ww.login_date = (select max(ww1.login_date) from who_work ww1 where ww1.uni_session_id = userenv('SESSIONID'));

    /*IF get_user_priv_1 (v_user_id, c_Priv) = 0 THEN
     Res := '';
     return(Res);
    END IF;  */
-- ------------------
  case p_format 
    when 1 then  begin v_CR := UTL_TCP.crlf; v_Bold := ''; v_BoldEnd:=''; v_comments_beg:='����������� � ����������:'||UTL_TCP.crlf||chr(9); v_comments_end:=''; end;
    when 2 then  begin v_CR := '<BR/>'; v_Bold := '<b>'; v_BoldEnd:='</b>'; v_comments_beg:='����������� � ����������:<BR/>'; v_comments_end:=''; end;
    else NULL;
  end case;  
-- ����� ��� ���� �� ID ��� --
select max(a.delo_id) into v_delo_id
from scan.ea_delo_attr a
where a.object_type_id in (1,7,12)   --  ��� - affair (�� ������� scan.ea_object_type )
and   a.object_rel_id= p_affair_id
and   NVL(a.row_status,0)<>0; 

if NVL(v_delo_id,-1) < 0 then --������� ���
   Res := v_CR||Res||v_Bold||c_no_catalog||v_BoldEnd;
   return(Res);
end if ;

-- ���� ������� (����) �� �������� ��� (p_affair_id)
 if p_mode > 0 then -- ��� �������:
   Res :=  v_CR||Res||v_Bold||c_yes||'.'||v_BoldEnd;
   return(Res);
end if ;
-- ��� �������, 
-- �������� ���-�� ������ � ����
select count(d.label_type_id) into i
from scan.ea_delo_label d
where d.delo_id= v_delo_id;

if NVL(i,0) = 0 then -- ��� ������ �������
   Res := v_CR||Res||v_Bold||c_yes||c_no_err||v_BoldEnd;
   return(Res);
end if;   
-- ���� ������ �������

/*-- ������ ������� --
FOR v_err IN (  SELECT t.full_name
                FROM scan.ea_delo_label l, scan.ea_label_type t
               WHERE l.delo_id = v_delo_id AND l.label_type_id = t.label_type_id AND t.status = 1
            ORDER BY t.sort_order) 
LOOP
    IF (tempStr IS NOT NULL) THEN
      tempStr  := tempStr || v_CR;
    END IF;
    if (NVL(LENGTH(tempStr),0)+LENGTH(v_err.full_name))> (c_L-c_dL)
    then
     tempStr  := tempStr || c_def||SUBSTR(v_err.full_name,1, ((c_L-c_dL) - NVL(LENGTH(tempStr),0)))||c_more;
     exit;
    end if;     
    tempStr  := tempStr || c_def||v_err.full_name;
END LOOP;
Res := v_CR||Res||v_Bold||c_yes||c_err||v_BoldEnd||v_CR||tempStr;
*/
-- ����� ������� --
with v_err as 
(  SELECT t.full_name
   FROM scan.ea_delo_label l, scan.ea_label_type t
   WHERE l.delo_id = v_delo_id AND l.label_type_id = t.label_type_id AND t.status = 1
   ORDER BY t.sort_order) 
   
  select extract(xmlagg(xmlelement("X",v_CR||c_def|| v_err.full_name)),'X/text()').getstringval() into tempStr
  from v_err;
--����������� � ����---  
        
    select t.delo_comment into v_comments 
    from scan.EA_DELO t
    where t.delo_id=v_delo_id
    and t.delo_comment is not NULL;
    
    if LENGTH(NVL(v_comments,''))>0 then 
       tempStr := tempStr||v_CR||v_comments_beg||v_comments||v_comments_end; --||TO_CHAR(v_delo_id)
    end if;  


 if LENGTH(tempStr)> c_L then 
  tempStr  := SUBSTR(tempStr,1, (c_L-c_dL)) || c_more;
 end if; 
  
  
 Res := v_CR||Res||v_Bold||c_yes||c_err||v_BoldEnd||tempStr;
 return(Res);
end get_scan_check_strinfo;
/
