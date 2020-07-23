declare
 i number := 0;
 j number := 0;
 l number := 0;
v_emp_id number;
begin

for rw in (
  select roc.*
  from local_rg_object_class_tmp roc --local_rg_object_class roc, mgr_exchange.mv$mgr_rg_objects@kurs3 o
 -- where roc.obj_id=o.id
    )
loop
  v_emp_id := NULL;
  
 if  rw.cadastral_numb  is not null
 then
   begin
    select distinct ub.emp_id into v_emp_id from U_BUILDING_Q ub 
    where
 --TRIM(ub.kadastr_num) = TRIM(rw.cadastral_numb)
      ub.norm_cn = rw.norm_cn
      ;
   EXCEPTION  WHEN OTHERS
             THEN  --dbms_output.put_line('EXCEPTION on kadastr_num U_BUILDING_Q '||rw.cadastral_numb);
               v_emp_id := NULL;
   end;   
   if v_emp_id  is null then  
     begin
        select distinct up.emp_id into v_emp_id from u_premise_q up 
        where 
     -- TRIM(up.kadastr_num) = TRIM(rw.cadastral_numb)
       --   REGEXP_REPLACE (TRIM(up.kadastr_num),'([: ]0{0,})',':') = rw.norm_cn
      up.norm_cn = rw.norm_cn
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
   'РСЖС', -- source,  
    7 ,     -- source_code
    5,   -- changes_user_id, 
    sysdate, --changes_date
    rw.is_actual, 
    rw.date_from, 
    rw.date_to
     );
 --commit;  
 l:=l+1;
 if l>10000 then
   commit;
   l:=0;
 end if;  
 --exit when l>1000;  
end loop;
--rollback;
 commit;

dbms_output.put_line('Найдено emp_id - '|| to_char(j));
dbms_output.put_line('НЕ Найдено emp_id - '|| to_char(i));
dbms_output.put_line('всего - '|| to_char(l));
end;

