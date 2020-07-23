declare
 i number := 0;
 j number := 0;
 l number := 0;
 c number := 0;
v_emp_id number;
v_id    number;
v_d      Date;
v_kadastr u_building_rel_q.kadastr_num%type;
v_unom    u_building_rel_q.unom%type;
v_building_manual_id u_building_rel_q.building_manual_id%type; 
v_ep_building_q_emp_id  u_building_rel_q.ep_building_q_emp_id%type;
begin
  v_d        := sysdate;
  for rw in (
      select * from (
        select  u.emp_id as U_BUILDING_EMP_ID,                
                e.emp_id as ep_emp_id , 
                e.source_id, 
                u.unom,
                e.unom as e_unom,
                u.kadastr_num,
                e.kadastr as e_kadastr 
        from u_building_q u
         join ep_building_q e on ((u.norm_cn = get_norm_cadnum(e.kadastr) ) or (u.unom=e.unom)) and  e.actual=1
        where  exists (select *  from u_building_rel_q r where r.u_building_emp_id=u.emp_id and r.ep_building_q_emp_id is null and r.actual=1)
              and u.actual=1
              
              ) v  where v.ep_emp_id is not null 
  )
 loop   
  
    v_kadastr  :=  rw.kadastr_num;
    v_unom     :=  rw.unom;
    v_building_manual_id := null;
    v_ep_building_q_emp_id := null;
    
   pkg_Iport_Export_RSGS.upd_u_building_q_rel (rw.u_building_emp_id, rw.ep_emp_id, 1);
    
  /*  
  68527396
68566224
68489595
68338540
68370669

  
  
  case  when rw.source_id = 20030007  --source, 'РСЖС'                   
            then v_ep_building_q_emp_id := rw.ep_emp_id;
          when rw.source_id = 20030006  --source, ручной ввод    
            then v_building_manual_id   := rw.ep_emp_id;
          else null;
    end case;                    
    
  select reg_object_seq.nextval into v_emp_id from dual ;
 
  insert into u_building_rel_o
    (id, info, deleted, "UID", enddatechange)
  values
    (v_emp_id, null, 0, 'ADMIN', v_d);

  select reg_quant_seq.nextval into v_id from dual ;  
  
insert into u_building_rel_q (id, emp_id, 
                              actual, status, 
                               s_, po_, 
                               u_building_emp_id, 
                               kadastr_num, 
                               unom, 
                               building_manual_id, 
                               ep_building_q_emp_id, 
                               changes_user_id, 
                               changes_date)
values
    (v_id, --id
     v_emp_id, 
      1, --actual,
      0, --status, 
      v_d, --s_, 
      to_date('31.12.9999','DD.MM.YYYY'),   --po_, 
      rw.U_BUILDING_EMP_ID
      ,v_kadastr
      ,v_unom
      ,v_building_manual_id
      ,v_ep_building_q_emp_id
      ,5   --changes_user_id
      ,v_d --CHANGES_DATE
   );
  
 c:=c+1; 
 l:=l+1;
 if l>100 then
   commit;
   l:=0;
 end if;  
 --exit when l>1000;  
 */
end loop;
--rollback;
 commit;


dbms_output.put_line('всего - '|| to_char(c));
end;  
  
  
  
  
  
  
  
  
