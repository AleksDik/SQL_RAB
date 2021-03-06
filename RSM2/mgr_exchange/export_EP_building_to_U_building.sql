declare
 i number := 0;
 j number := 0;
 l number := 0;
 c number := 0;
v_emp_id number;
v_ub_emp_id number;
v_id_q     number;
v_d        Date;
v_actual   number; 
v_status   number;
v_s_       date; 
v_po_      date;

v_kadastr u_building_rel_q.kadastr_num%type;
v_unom    u_building_rel_q.unom%type;

v_ep_building_q_emp_id  u_building_rel_q.ep_building_q_emp_id%type;
begin


  
for rw in (
select eb.*,
        REGEXP_REPLACE (TRIM(eb.kadastr),'([: ]0{0,})',':') as norm_cn,
        ea.street_name,
        ea.house_number,
        ea.korpus_number, 
        ea.structure_number,
        ea.bld_unad,
        ea.country,
        ea.country_code,
        ea.full_addres
from  ep_building_q eb, ep_building_address_q ea
where eb.actual = 1
 and  eb.source_id = 20030007
 and  ea.actual = 1
 and  ea.ep_building_id = eb.emp_id 
 and  not exists (select * from u_building_rel_q ur where ur.ep_building_q_emp_id=eb.emp_id and ur.actual=1)
)
loop
  v_emp_id   := NULL;
  v_d        := NULL;
  v_ub_emp_id := NULL; 
 if  rw.kadastr  is not null
 then
   begin
      select distinct ub.emp_id into v_ub_emp_id from U_BUILDING_Q ub 
      where  ub.norm_cn = rw.norm_cn
       and   ub.actual = 1
        ;
     EXCEPTION  WHEN OTHERS
                THEN  v_ub_emp_id := NULL;
   end;   
 end if;
 if (v_ub_emp_id  is null) and (rw.unom  is not null) then
   begin
    select distinct ub.emp_id into v_ub_emp_id from U_BUILDING_Q ub 
    where ub.unom=rw.unom
    and   ub.actual = 1;
   EXCEPTION  WHEN OTHERS
             THEN  v_ub_emp_id := NULL;
             
   end; 
 end if;
 
if (v_ub_emp_id  is null) 
then
  i:=i+1;
  pkg_Iport_Export_RSGS.get_q_servce_values(v_id_q, v_ub_emp_id,v_actual ,v_status, v_d ,v_po_);
  insert into u_building_o
    (id, info, deleted, "UID", enddatechange)
  values
    (v_ub_emp_id, null, 0, 'ADMIN', v_d);
  
  insert into u_building_q
    (id, emp_id, actual, status, s_, po_, 
      kadastr_num, 
      area, 
      type_object_code, 
      type_object, 
      country_code, 
      country, 
      unom, 
      purpose_code, 
      purpose, 
      floors, 
      full_address, 
      source_address, 
      source_address_code, 
      street, 
      house, 
      corpus, 
      structure, 
      rsm_number,
      total_area_residential_prem,
      kwq, 
      note,
      year_build,
      norm_cn
)
  values
    (v_id_q,
     v_ub_emp_id,
     v_actual,
     v_status
     ,v_d
     ,v_po_
     ,rw.kadastr
     ,rw.overall_area
     ,rw.object_type_id
     ,rw.object_type
     ,rw.country_code
     ,rw.country
     ,rw.unom
     ,rw.purpose_code
     ,rw.purpose
     ,rw.floors
     ,rw.full_addres
     ,rw.source
     ,rw.source_id
     ,rw.street_name
     ,rw.house_number
     ,rw.korpus_number
     ,rw.structure_number
     ,rw.rsm_number
     ,rw.total_area_residential_prem
     ,rw.kwq
     ,rw.comments
     ,rw.building_year
     ,rw.norm_cn
     );
     
  pkg_Iport_Export_RSGS.get_q_servce_values(v_id_q, v_emp_id,v_actual ,v_status, v_d ,v_po_);
 
  insert into u_building_rel_o
    (id, info, deleted, "UID", enddatechange)
  values
    (v_emp_id, null, 0, 'ADMIN', v_d);


insert into u_building_rel_q (id, emp_id, 
                              actual, status, 
                               s_, po_, 
                               u_building_emp_id, 
                               kadastr_num, 
                               unom, 
                               ep_building_q_emp_id, 
                               changes_user_id, 
                               changes_date)
values
    (v_id_q, --id
     v_emp_id, 
     v_actual, --actual,
     v_status, --status, 
     v_d, --s_, 
     v_po_
      ,v_ub_emp_id
      ,rw.kadastr
      ,rw.unom
      ,rw.emp_id
      ,5   --changes_user_id
      ,v_d --CHANGES_DATE
   );
 
 else j:=j+1;     
end if;
--
 c:=c+1; 
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
dbms_output.put_line('����� - '|| to_char(c));
end;

