create or replace function GET_AFFAIR_requirements(p_affair_id in number) return varchar2 is
  v_sq_type_text varchar2(4000);
  Res_text varchar2(250);
--     @avtor Dik
--     ������� ���������� ���������� � ��������� ����� ����������, ��������� � ������ � ����� � ���
--

begin
  with A as (
                SELECT  pa.family_num, pa.sq_type_text  FROM  V_PERSON_AFFAIR_3 pa
                WHERE  pa.AFFAIR_ID = p_affair_id AND  pa.AFFAIR_STAGE = 1
                 group by pa.family_num, pa.sq_type_text
                )
    select substr(extract(xmlagg(xmlelement("X", ', ' || a.sq_type_text)), 'X/text()').getstringval(), 2)   INTO v_sq_type_text from A;   
   if LENGTH(NVL(v_sq_type_text,' '))>250 
    then Res_text:=substr(v_sq_type_text,246)+'...' ; 
    else Res_text:=v_sq_type_text;
   end if;  
   return(Res_text);
exception
    when others then      
       return( '������. ���������� ����� ��������!' );
       
end GET_AFFAIR_requirements;
/
