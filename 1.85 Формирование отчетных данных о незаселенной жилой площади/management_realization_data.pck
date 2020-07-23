create or replace package management_realization_data is
  -- Author  : DIKAN
  -- Created : 09.04.2013 11:12:29
/* Purpose : ������� ��� ������������ ����� "�� ����������", "�� �������������", "�� �����������", "�� ���� �� ����������"
             (ur_territory,ur_rasporyadytel,ur_direction,ur_period_for_implement) �� view  "V_HOUSING_LIST"
             [����� ����� � 1.85]
*/
  -- Public type declarations
  TYPE TterritorySet IS VARRAY(4) OF varchar2(10) NOT NULL;
  TYPE TrasporyadytelSet IS VARRAY(8) OF varchar2(8) NOT NULL;
  TYPE TdirectionSet IS VARRAY(4) OF varchar2(20) NOT NULL;
  TYPE TCity_ProgSet IS VARRAY(3) OF varchar2(20) NOT NULL;
  -- Public constant declarations
  MosOrObl_Okrug_Id constant NUMBER := 54; --���-��������� ��
  Municipal_okrug_MosOrObl constant NUMBER := 13; --������������� ������ � ���-��������� �� ������ ��� "���.����"
  MosObl_Okrug_Id constant NUMBER := 33; --- ����.���.
  NAO_Okrug_Id    constant NUMBER := 62; -- ���
  TAO_Okrug_Id    constant NUMBER := 63; -- ���
  -- Public variable declarations
 Moscow_Okrug_Id_set  NUMBER_TABLE_TYPE := NUMBER_TABLE_TYPE(51,52,53,55,56,57,58,59,60,61);  
 Moscow_building_id_in13mo_set  NUMBER_TABLE_TYPE := NUMBER_TABLE_TYPE(113, -2489, -2491, 9979, 
                                                   -1954, -1477, -2557, -3156, -2358, 9996, 10011, 
                                                   -2521, -2381, -2546, -2488, -2311, -2547, -2274, -3246);
 VterritorySet TterritorySet := TterritorySet('������','���.����','����.���','�������');
 VrasporyadytelSet TrasporyadytelSet := TrasporyadytelSet('��','��','���','���','���.���.','���','���','��');
 VdirectionSet TdirectionSet := TdirectionSet('�����������','��������������','����������','��.�����������');
 VCity_ProgSet TCity_ProgSet := TCity_ProgSet('UR_N_PERESELENIE','UR_N_PEREOFORMLENIE','UR_N_OCHEREDNIKI');
 Vperiod_for_implement TdirectionSet := TdirectionSet('�� 3 ���','�� 3 �� 6 ���','�� 6 ��� �� 1 ����','����� 1 ����');
 
-- -----------------------------"�� ����������"---------------------------------------------- 
-- �������� ������ ��� ���������� ��  free_space.freespace_id 
-- Return: 1 - ������ , 2 - ���.����, 3 - ����.���., 4 - �������, 0 - ���� 
function Get_ur_territory_num(Afreespace_id in free_space.freespace_id%type) return NUMBER;

-- �������� ������ ��� ���������� ��  free_space.okrug_id � free_space.building_id 
-- Return: 1 - ������ , 2 - ���.����, 3 - ����.���., 4 - �������, 0 - ���� 
function Get_ur_territory_num(Aokrug_id in free_space.okrug_id%type,
                              Afree_space_building_id in building.building_id%type) return NUMBER;

-- �������� ������������ ���������� �� free_space.freespace_id 
function Get_ur_territory_title(Afreespace_id in free_space.freespace_id%type) return varchar2;   

-- -----------------------------"�� �������������"---------------------------------------------- 
-- �������� ������ ��� ������������� ��  free_space.freespace_id 
-- Return: 1 - ��, 2 - ��,3 -���,4 -���,5- ���.���.,6- ���,7 - ���,8- ��
function Get_ur_rasporyadytel_num(Afreespace_id in free_space.freespace_id%type) return NUMBER;

-- �������� ������������ ������������� �� free_space.freespace_id 
function Get_ur_rasporyadytel_title(Afreespace_id in free_space.freespace_id%type) return varchar2;  

-- -----------------------------"�� �����������"---------------------------------------------- 
-- �������� ������ ��� ����������� ��  free_space.freespace_id 
-- Return: 1- �����������,2 -��������������,3- ����������,4 - ��.�����������
function Get_ur_direction_num(Afreespace_id in free_space.freespace_id%type) return NUMBER;

-- �������� ������������ ����������� �� free_space.freespace_id 
function Get_ur_direction_title(Afreespace_id in free_space.freespace_id%type) return varchar2;

-- �������� ����� ���.���������  �� ������� Global Parameters �� free_space.freespace_id 
function Get_City_Prog_virtual_num(Afreespace_id in free_space.freespace_id%type) return NUMBER;                         

-- -----------------------------"�� ���� �� ����������"---------------------------------------------- 
-- �������� ������ ��� ����� �� ���������� ��  free_space.freespace_id 
-- Return: 1 - '�� 3 ���', 2 - '�� 3 �� 6 ���', 3 - '�� 6 ��� �� 1 ����', 4 - '����� 1 ����'
function Get_period_for_implement_num(Afreespace_id in free_space.freespace_id%type) return NUMBER;

-- �������� ������������ ����� �� ���������� �� free_space.freespace_id 
function Get_period_for_implement_title(Afreespace_id in free_space.freespace_id%type) return varchar2;


end management_realization_data;
/
create or replace package body management_realization_data is

-- �������� ������ ��� ���������� ��  free_space.freespace_id 
-- Return: 1 - ������ , 2 - ���.����, 3 - ����.���., 4 - �������, 0 - ���� 
function Get_ur_territory_num(Afreespace_id in free_space.freespace_id%type) return NUMBER
is
  Result_value NUMBER := 0;
  Vokrug_id  building.area%type := 0;
  Vfree_space_building_id building.building_id%type := 0;
begin
/* ������� ����� �� free_space
 select f.okrug_id, f.building_id into Vokrug_id, Vfree_space_building_id 
 from free_space f 
 where f.freespace_id = Afreespace_id
 and   f.status in (1,2,4,5) ;
*/  
--  ������� ����� �� building.area
 select b.area, f.building_id into Vokrug_id, Vfree_space_building_id 
 from free_space f , building b
 where f.freespace_id = Afreespace_id
    and f.building_id  = b.building_id 
 and   f.status in (1,2,4,5) ;
  if NVL(Vokrug_id,0) > 0 
    then Result_value := Get_ur_territory_num(Vokrug_id,Vfree_space_building_id);
  end if;  
 return(Result_value);
end Get_ur_territory_num;
   
-- �������� ������ ��� ���������� ��  free_space.okrug_id � free_space.building_id. 
-- Return: 1 - ������ , 2 - ���.����, 3 - ����.���., 4 - �������, 0 - ���� 
function Get_ur_territory_num(Aokrug_id in free_space.okrug_id%type, Afree_space_building_id in building.building_id%type) return NUMBER 
is
 Result_value NUMBER := 0;
 vMunicipal_okrug NUMBER := 0;
begin
 case  
  when Aokrug_id = MosObl_Okrug_Id then Result_value := 3;
  when Aokrug_id in (NAO_Okrug_Id,TAO_Okrug_Id) then Result_value := 4;
  when Aokrug_id = MosOrObl_Okrug_Id then 
   begin
      select b.municipal_okrug into vMunicipal_okrug from building b where b.building_id = Afree_space_building_id;
      if vMunicipal_okrug<>Municipal_okrug_MosOrObl 
      then  Result_value := 1;
      else begin
                SELECT Count(column_value) into Result_value
                FROM TABLE (cast(Moscow_building_id_in13mo_set as NUMBER_TABLE_TYPE ))
                where column_value = Afree_space_building_id; 
                if Result_value > 0 
                then Result_value := 1;
                else  Result_value := 2;
                end if;
           end; --begin
      end if;  
   end; --begin   
  else begin
       SELECT Count(column_value) into Result_value
       FROM TABLE (cast(Moscow_Okrug_Id_set as NUMBER_TABLE_TYPE ))
       where column_value = Aokrug_id; 
       if Result_value > 0 then
        Result_value := 1;  
       end if;
  end; --else 
 end case;
 return(Result_value);
 
end Get_ur_territory_num;

-- �������� ����������� ���������� �� free_space.freespace_id 
function Get_ur_territory_title(Afreespace_id in free_space.freespace_id%type) return varchar2
is
 Result_value varchar2(10) := '';
 Vterritory_num NUMBER := 0;
begin
 Vterritory_num := Get_ur_territory_num(Afreespace_id);
  if NVL(Vterritory_num,0) > 0 
    then 
       if VterritorySet.Exists(Vterritory_num) = TRUE
         then Result_value := VterritorySet(Vterritory_num);
       end if; 
  end if;  
 return(Result_value);
end Get_ur_territory_title;

-- �������� ������ ��� ������������� ��  free_space.freespace_id 
-- Return: 1 - ��, 2 - ��,3 -���,4 -���,5- ���.���.,6- ���,7 - ���,8- ��
function Get_ur_rasporyadytel_num(Afreespace_id in free_space.freespace_id%type) return NUMBER
is
 Result_value NUMBER := 0;
 v_p8 factory.rights%type := -1;
 v_fo NUMBER := -1;

begin
  select NVL(f.RIGHTS,-1)  into v_p8
  from  free_space fs left join factory f on 
        f.DEPARTMENT = fs.department 
        and f.NUM_IN_DEPARTMENT = fs.num_in_department
  where fs.freespace_id = Afreespace_id;
  case  
  when    v_p8 = 3 then Result_value := 8; -- ��
   when  v_p8 = 5 then Result_value := 5; --���.���.
    when  v_p8 = 12 then Result_value := 3; --���
     when  v_p8 in (30,31) then Result_value := 4; --���
      when  v_p8 = 80 then Result_value := 7; --���
       when  v_p8 = 81 then Result_value := 6; ---���
   when  v_p8 = 11 then
   begin
      select NVL(ka.fund_owner,-1) into v_fo
      from  free_space fs left join kursiv.apartment ka on
            fs.apart_id = ka.apart_id
            AND fs.building_id = ka.building_id
      where fs.freespace_id = Afreespace_id;  
      case  
       when v_fo = 845 then Result_value := 1; -- ��
       when v_fo = 1089 then Result_value := 3; --���
       else  Result_value := 2; -- ��  
      end case;    
   end; -- begin  when  v_p8 = 11  
   else Result_value := 0;       
 end case; 
  return(Result_value);
end  Get_ur_rasporyadytel_num;


-- �������� ����������� ������������� �� free_space.freespace_id 
function Get_ur_rasporyadytel_title(Afreespace_id in free_space.freespace_id%type) return varchar2
is
 Result_value varchar2(8) := '';
 Vrasporyadytel_num NUMBER := 0;
begin
 Vrasporyadytel_num := Get_ur_rasporyadytel_num(Afreespace_id);
  if NVL(Vrasporyadytel_num,0) > 0 
    then 
       if VrasporyadytelSet.Exists(Vrasporyadytel_num) = TRUE
         then Result_value := VrasporyadytelSet(Vrasporyadytel_num);
       end if; 
  end if;  
 return(Result_value);
end Get_ur_rasporyadytel_title; 

-- �������� ������ ��� ����������� ��  free_space.freespace_id 
-- Return: 1- �����������,2 -��������������,3- ����������,4 - ��.�����������
function Get_ur_direction_num(Afreespace_id in free_space.freespace_id%type) return NUMBER
is 
 Result_value NUMBER := 0;
 v_p8 factory.rights%type := -1;
 v_count NUMBER := 0;
 v_fo NUMBER := -1;
begin
  select NVL(f.RIGHTS,-1)  into v_p8
  from  free_space fs left join factory f 
        on 
        f.DEPARTMENT = fs.department and f.NUM_IN_DEPARTMENT = fs.num_in_department
  where fs.freespace_id = Afreespace_id
        and fs.Last = 1;
 case  
  when    v_p8 = 30 then 
   begin 
      v_count := Get_City_Prog_virtual_num(Afreespace_id);
      case 
          when v_count in (1,2,3) then Result_value := v_count;
           /*
           when v_count=1  then  Result_value := 1; --�����������
           when v_count=2  then  Result_value := 2; --��������������
           when v_count=3  then  Result_value := 3; --����������
           */  
           else Result_value := 4; -- ��.�����������
      end case;  
   end;  -- begin  when  v_p8 =30
  when  v_p8 in (3,5) then 
   begin
      select Count(*) into  v_count
      from  free_space fs , Instruction i 
      where fs.freespace_id = Afreespace_id  
        and fs.doc_num = i.instruction_num 
        and ((i.direction=99 and i.target in (4,5)) or (i.direction=92 and i.target=1)) ;
     if v_count > 0 then
        Result_value := 2; --��������������
     end if;        
   end; -- begin  when  v_p8 in (3,5)    
  when  v_p8 = 11 then
   begin
      select NVL(ka.fund_owner,-1) into v_fo
      from  free_space fs left join kursiv.apartment ka on
            fs.apart_id = ka.apart_id
            AND fs.building_id = ka.building_id
      where fs.freespace_id = Afreespace_id;  
      case  
       when v_fo = 845 then Result_value := 1; -- �����������
       else  Result_value := 0; 
      end case;    
   end; -- begin  when  v_p8 = 11  
   else Result_value := 0;       
 end case;         
 return(Result_value);
end Get_ur_direction_num; 

-- �������� ����� ���.���������  �� ������� Global Parameters �� free_space.freespace_id 
function Get_City_Prog_virtual_num(Afreespace_id in free_space.freespace_id%type) return NUMBER
is 
 Result_value NUMBER := 0;
 v_count NUMBER := 0;
 v_Index NUMBER := 1;
begin
   select Count (sp.cp_num) into v_count 
   from FS_City_Prog sp
   where  sp.Freespace_ID = Afreespace_id ; 
  IF v_count < 1  --��� �������� �������� ���� ������� � FS_City_Prog
  then return(Result_value);
  end if;    
 -- �������� ��������� FS_City_Prog.cp_num � ���� �� ������� �� GLOBAL_PARAMETERS , ������ ����������� � VCity_ProgSet
  v_Index := VCity_ProgSet.FIRST;
  WHILE v_Index <= VCity_ProgSet.LAST 
  LOOP
   select Count (sp.cp_num) into v_count 
   from FS_City_Prog sp
   where  sp.Freespace_ID = Afreespace_id
   and sp.cp_num in 
   (select TO_NUMBER(sTable.n) as n from    
         ( select  regexp_substr(
                                (select ','||translate(VALUE,'1 ','1')||',' from GLOBAL_PARAMETERS where PARAMETER_NAME = VCity_ProgSet(v_Index)),
                                '[^,]+',1,level
                                ) as n from dual
          connect by regexp_substr(
                                   (select ','||translate(VALUE,'1 ','1')||',' from GLOBAL_PARAMETERS where PARAMETER_NAME = VCity_ProgSet(v_Index)),
                                   '[^,]+',1,level
                                   ) is not null
          )sTable
   ) ;
       IF v_count > 0 THEN 
        Result_value :=  v_Index;  
        EXIT;               
       END IF; 
    v_Index := VCity_ProgSet.next(v_Index);    
  END LOOP;
  return(Result_value);
end Get_City_Prog_virtual_num;

-- �������� ������������ ����������� �� free_space.freespace_id 
function Get_ur_direction_title(Afreespace_id in free_space.freespace_id%type) return varchar2
is
 Result_value varchar2(16) := '';
 Vdirection_num NUMBER := 0;
begin
 Vdirection_num := Get_ur_direction_num(Afreespace_id);
  if NVL(Vdirection_num,0) > 0 
    then 
       if VdirectionSet.Exists(Vdirection_num) = TRUE
         then Result_value := VdirectionSet(Vdirection_num);
       end if; 
  end if;  
 return(Result_value);
end Get_ur_direction_title; 


-- �������� ������ ��� ����� �� ���������� ��  free_space.freespace_id 
-- Return: 1 - '�� 3 ���', 2 - '�� 3 �� 6 ���', 3 - '�� 6 ��� �� 1 ����', 4 - '����� 1 ����'
function Get_period_for_implement_num(Afreespace_id in free_space.freespace_id%type) return NUMBER
is 
 Result_value NUMBER := 0;
 vNew_Building_code Free_Space.New_Building_code%type := -1;
 v_Interv NUMBER := 0;
 T_date DATE := NULL;
 S varchar2(15) := NULL; 
begin
 select NVL(fs.New_Building_code,-1) into vNew_Building_code
  from Free_Space fs
  where fs.freespace_id = Afreespace_id;
  case  
    when  vNew_Building_code = 0 then T_date := TRUNC (get_freespace_certif_date (Afreespace_id)); -- ���� ����� �.12
    when  vNew_Building_code > 0 then 
    begin  
     S :=  get_freespace_R_P11toDep(Afreespace_id,1); --�4 ����. ��  11_�
     if NVL(S,'-1')= '-1'
       then T_date := NULL;
       else T_date := TO_DATE(S,'dd.mm.yyyy');
     end if;    
    end; 
    else T_date := NULL; 
  end case; 
  if T_date is NULL
    then  return(Result_value); 
  end if;
   v_Interv := months_between(trunc(sysdate),T_date);
   case  
    when  v_Interv < 3 then Result_value := 1;
    when  (v_Interv >= 3) and (v_Interv < 6) then Result_value := 2;  
    when  (v_Interv >= 6) and (v_Interv <= 12) then Result_value := 3; 
    when  v_Interv > 12 then Result_value := 4;
    else Result_value := 0;
   end case;  
   return(Result_value);     
end Get_period_for_implement_num;

function Get_period_for_implement_title(Afreespace_id in free_space.freespace_id%type) return varchar2
is
 Result_value varchar2(20) := '';
 V_num NUMBER := 0;
begin
 V_num := Get_period_for_implement_num(Afreespace_id);
  if NVL(V_num,0) > 0 
    then 
       if Vperiod_for_implement.Exists(V_num) = TRUE
         then Result_value := Vperiod_for_implement(V_num);
       end if; 
  end if;  
 return(Result_value);
end Get_period_for_implement_title; 



end management_realization_data;
/
