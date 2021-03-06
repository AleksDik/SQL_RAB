declare
 i number := 0;
 j number := 0;
v_emp_id number;
begin

for rw in (
  select roc.id as id, 
         roc.cls_id as cls_id, 
         roc.obj_id as OBJECT_ID_IN_SOURCE, 
         roc.date_from as date_from, 
         roc.date_to as date_to, 
         roc.is_actual as is_actual, 
         roc.create_user_id, 
         roc.create_date, 
         roc.modify_user_id, 
         roc.modify_date, 
         roc.cls_id_tree  as  cls_id_tree 
         ,o.obj_type
         ,o.cadastral_numb
         ,o.bld_unom
         ,o.apr_unkv
  from local_rg_object_class roc, MV$MGR_RG_OBJECTS o
  where roc.obj_id=o.id
    )
loop
  v_emp_id := NULL;
  
 if  rw.cadastral_numb  is not null
 then
   begin
    select distinct ub.emp_id into v_emp_id from U_BUILDING_Q ub 
    where
    TRIM(ub.kadastr_num) = TRIM(rw.cadastral_numb)
     -- (REGEXP_REPLACE (TRIM(ub.kadastr_num),'([: ]0{0,})',':') = REGEXP_REPLACE (TRIM(rw.cadastral_numb),'([: ]0{0,})',':')) 
      ;
   EXCEPTION  WHEN OTHERS
             THEN  --dbms_output.put_line('EXCEPTION on kadastr_num U_BUILDING_Q '||rw.cadastral_numb);
               v_emp_id := NULL;
   end;   
   if v_emp_id  is null then  
     begin
        select distinct up.emp_id into v_emp_id from u_premise_q up 
        where 
        TRIM(up.kadastr_num) = TRIM(rw.cadastral_numb)
      --   (REGEXP_REPLACE (TRIM(up.kadastr_num),'([: ]0{0,})',':') = REGEXP_REPLACE (TRIM(rw.cadastral_numb),'([: ]0{0,})',':')) 
       ;
        EXCEPTION  WHEN OTHERS
             THEN  --dbms_output.put_line('EXCEPTION on kadastr_num u_premise_q '||rw.cadastral_numb);
                   v_emp_id := NULL;
     end;   
   
   end if;
 end if;
 if (v_emp_id  is null) and (rw.bld_unom  is not null) then
  if (rw.apr_unkv) is null then
    begin
    select distinct ub.emp_id into v_emp_id from U_BUILDING_Q ub 
    where ub.unom=rw.bld_unom;
   EXCEPTION  WHEN OTHERS
             THEN  --dbms_output.put_line('EXCEPTION on unom U_BUILDING_Q '|| to_char(rw.bld_unom));
               v_emp_id := NULL;
   end; 
  else 
     begin
        select distinct up.emp_id into v_emp_id from u_premise_q up 
        where up.unom = rw.bld_unom
              and up.unkv = rw.apr_unkv;
        EXCEPTION  WHEN OTHERS
             THEN  --dbms_output.put_line('EXCEPTION on unkv u_premise_q '|| to_char(rw.apr_unkv));
                   v_emp_id := NULL;
     end;   
     
  end if;   
   
 end if;
 
 if (v_emp_id  is null) then i:=i+1;
 else j:=j+1; end if;
 
  --dbms_output.put(to_char(i));
insert into u_rsgs_type_gf
  (id, object_id, object_id_in_source, 
   cls_id, cls_id_tree, 
   source, source_code, 
   changes_user_id, 
   changes_date, 
   is_actual, 
   date_from, 
   date_to)

 
 values
  (reg_object_seq.nextval,
   v_emp_id,
   rw.object_id_in_source, 
   rw.cls_id, 
   rw.cls_id_tree,
   '����', -- source,  
    7 ,     -- source_code
    5,   -- changes_user_id, 
    sysdate, --changes_date
    rw.is_actual, 
    rw.date_from, 
    rw.date_to
     );
 commit;    
end loop;



dbms_output.put_line('������� emp_id - '|| to_char(j));
dbms_output.put_line('�� ������� emp_id - '|| to_char(i));
end;

