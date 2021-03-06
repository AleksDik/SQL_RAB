declare
 i number := 0;
 j number := 0;
 l number := 0;
v_emp_id number;
v_a_emp_id     number;
v_d           Date;
v_ub_emp_id   number;
v_id_q           number;
begin
  
--update U_BUILDING_Q ub
--set ub.norm_cn = REGEXP_REPLACE (TRIM(ub.KADASTR_NUM),'([: ]0{0,})',':')
--;
--commit;

for rw in (
  select o.*, REGEXP_REPLACE (TRIM(o.cadastral_numb),'([: ]0{0,})',':') as norm_cn
  from mv$mgr_rg_objects o 
  where UPPER(trim(o.obj_type))='BLD')
loop
  v_emp_id   := NULL;
  v_a_emp_id := NULL;
  v_ub_emp_id := NULL;
  v_d        := sysdate;
  
 select reg_object_seq.nextval into v_emp_id from dual ;
 
  insert into ep_building_o
    (id, info, deleted, "UID", enddatechange)
  values
    (v_emp_id, null, 0, 'ADMIN', v_d);

    
 select reg_quant_seq.nextval into v_id_q from dual ;    
    
  insert into ep_building_q
    (id, emp_id, 
     actual, status, 
     s_, po_, 
     unom, 
     object_type, object_type_id,
     title,
     total_area_residential_prem,
     kwq, 
     floors,
     rsm_number, 
     comments, 
     kadastr, 
     overall_area,
     close_date, 
     is_closed,
     close_occ_id, 
     building_year,
     is_hostel,
     source_id,
     source,
     id_old,
     purpose_code,
     purpose
  )
  values
    (v_id_q, --id
     v_emp_id, 
      1, --actual,
      0, --status, 
      v_d, --s_, 
      to_date('31.12.9999','DD.MM.YYYY'),   --po_, 
      rw.bld_unom,--unom, 
      '������'    --object_type, 
      ,20000002   --object_type_id,
      ,rw.name    --title,
      ,rw.bld_square_living --total_area_residential_prem
      ,rw.bld_apart_count   --kwq,
      ,rw.bld_storey_count --floors
      ,rw.reg_numb         --rsm_number,
      ,rw.comments         --comments 
      ,rw.cadastral_numb   --kadastr, 
      ,rw.bld_square_total--overall_area,
      ,rw.close_date      --close_date,
      ,rw.is_closed       -- is_closed,
      ,rw.close_occs_id   --close_occ_id,
      ,rw.bld_year        --building_year,
      ,rw.is_hostel      --is_hostel
      ,20030007          -- source_id
      ,'����'            -- source
      ,rw.id             --id_old
      ,decode(nvl(rw.is_undwelling,0),0,20140002,20140001)  --purpose_code
      ,decode(nvl(rw.is_undwelling,0),0,'����� ���','������� ������')  --purpose
      );
--------------------------  
     select reg_object_seq.nextval into v_a_emp_id from dual ;
     
     insert into ep_building_address_o
       (id, info, deleted, "UID", enddatechange)
     values
       (v_a_emp_id, null, 0, 'ADMIN', v_d);
       
     select reg_quant_seq.nextval into v_id_q from dual ; 
      
     insert into ep_building_address_q
       (id, emp_id, actual, status, s_, po_,
        street_name,
        house_number,
        korpus_number, 
        structure_number,
        bld_unad,
        ep_building_id, 
        country, 
        country_code,
        data_source, 
        data_source_code,
        full_addres
        )
     values
     (v_id_q, --id
      v_a_emp_id, 
      1, --actual,
      0, --status, 
      v_d, --s_, 
      to_date('31.12.9999','DD.MM.YYYY')  --po_,
      ,rw.bld_street            --street_name
      ,rw.bld_house_numb        --house_number,
      ,rw.bld_corp_numb         --korpus_number, 
      ,rw.bld_stroen_numb       --structure_number,
      ,rw.bld_unad
      ,v_emp_id                 -- ep_building_id
      ,'���������� ���������'   -- country, 
      ,20050001                 --  country_code,      
      ,'����'                   --  data_source, 
      ,20030007                  --data_source_code
      ,Decode(NVL(trim(rw.bld_street),'#'),'#','',trim(rw.bld_street))||
       Decode(NVL(trim(rw.bld_house_numb),'#'),'#','',' �. '||trim(rw.bld_house_numb))||
       Decode(NVL(trim(rw.bld_corp_numb),'#'),'#','',' ����. '||trim(rw.bld_corp_numb))||
       Decode(NVL(trim(rw.bld_stroen_numb),'#'),'#','',' ���. '||trim(rw.bld_stroen_numb))  -- full_addres
       );
    
   
  -------------------    
 v_ub_emp_id := NULL;
      
 if  rw.cadastral_numb  is not null
 then
   begin
      select distinct ub.emp_id into v_ub_emp_id from U_BUILDING_Q ub 
      where  ub.norm_cn = rw.norm_cn
        ;
     EXCEPTION  WHEN OTHERS
                THEN  v_ub_emp_id := NULL;
   end;   
 end if;
 
 if (v_ub_emp_id  is null) and (rw.bld_unom  is not null) then
   begin
    select distinct ub.emp_id into v_ub_emp_id from U_BUILDING_Q ub 
    where ub.unom=rw.bld_unom;
   EXCEPTION  WHEN OTHERS
             THEN  v_ub_emp_id := NULL;
   end; 
 end if;
 
 if (v_ub_emp_id  is null) 
  then i:=i+1;
  else j:=j+1; 
   update U_BUILDING_REL_Q ur
    set ur.ep_building_q_emp_id = v_emp_id
   where ur.u_building_emp_id = v_ub_emp_id;
 end if;
 
 l:=l+1;
 if l>10000 then
   commit;
   l:=0;
 end if;  
 --exit when l>1000;  
end loop;
--rollback;
 commit;

dbms_output.put_line('������� emp_id - '|| to_char(j));
dbms_output.put_line('�� ������� emp_id - '|| to_char(i));
dbms_output.put_line('����� - '|| to_char(l));
end;

