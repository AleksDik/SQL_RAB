declare
 i number := 0;
 j number := 0;
 l number := 0;
 c number := 0;
 cc number := 0;
 e number := 0;
 d number := 0;
 w number := 0;
 fl_k number := 0;
 fl_u number := 0;
v_emp_id number;
v_up_emp_id number;
v_id_q     number;
v_d        Date;
v_actual   number; 
v_status   number;
v_s_       date; 
v_po_      date;
v_u_building_emp_id u_premise_q.u_building_emp_id%type; 


begin


  
for rw in (
  select ep.*, get_norm_cadnum(ep.kadastr) as norm_cn,upper(trim(ep.kvnom)||trim(ep.apr_ind)) as ep_kvnom
  from  EP_PREMISE_Q ep --,  U_PREMISE_Q up
  where ep.actual =1
  and  ep.source_id = 20030007
  and NVL(ep.is_closed,0) = 0
-- and  ((get_norm_cadnum(ep.kadastr)=get_norm_cadnum(up.kadastr_num)) or ((ep.unom=up.unom)and(ep.unkv=up.unkv)) )
--and up.actual=1
--and not exists (select * from u_PREMISE_rel_q ur where ur.u_premise_emp_id=up.emp_id and ur.actual=1)

)
loop
  v_emp_id   := NULL;
  v_d        := NULL;
  v_up_emp_id := NULL; 

 if  rw.kadastr  is not null
 then
   begin
      select up.emp_id into v_up_emp_id from U_PREMISE_Q up
      where  get_norm_cadnum(up.kadastr_num)= rw.norm_cn
       and   up.actual = 1
       and   up.unom= rw.unom
       and NVL2(up.unkv,up.unkv,upper(trim(up.kvnom))) = NVL2(up.unkv,rw.unkv,rw.ep_kvnom)
      -- and (decode(NVL(up.unkv,-1),-1,upper(trim(up.kvnom)),up.unkv) = decode(NVL(up.unkv,-1),-1,rw.ep_kvnom,rw.unkv))
        ;
        fl_k :=  fl_k +1; 
     EXCEPTION  WHEN OTHERS
                THEN  v_up_emp_id := NULL;
   end;   
 end if;
 
 if (v_up_emp_id  is null) and (rw.unom  is not null) and (rw.unkv is not null)  and (trim(rw.kadastr) is null) then
   begin
    select distinct up.emp_id into v_up_emp_id from U_PREMISE_Q up
    where up.unom = rw.unom
   --  and (decode(NVL(up.unkv,-1),-1,upper(trim(up.kvnom)),up.unkv) = decode(NVL(up.unkv,-1),-1,rw.ep_kvnom,rw.unkv))
      and  up.actual = 1
      and NVL2(up.unkv,up.unkv,upper(trim(up.kvnom))) = NVL2(up.unkv,rw.unkv,rw.ep_kvnom);
     fl_u :=  fl_u +1; 
   EXCEPTION  WHEN OTHERS
             THEN  v_up_emp_id := NULL;
             
   end; 
 end if;
 
if (v_up_emp_id  is null) --�������� � U_PREMISE_Q �� EP_PREMISE_Q
then
  i:=i+1;
 /* 
  pkg_Iport_Export_RSGS.get_q_servce_values(v_id_q, v_up_emp_id,v_actual ,v_status, v_d ,v_po_);
  
if rw.unom is null
  then  v_u_building_emp_id := 0;
  else
      begin
    select ub.emp_id into v_u_building_emp_id 
    from  U_BUILDING_Q  ub
    where ub.unom = rw.unom;
    EXCEPTION  WHEN OTHERS
               THEN  v_u_building_emp_id := 0;
  end;
end if;
  
  insert into U_PREMISE_O
    (id, info, deleted, "UID", enddatechange)
  values
    (v_up_emp_id, null, 0, 'ADMIN', v_d);
  
  insert into u_premise_q
    (id, 
    emp_id, 
    actual,  
    status,
    s_, 
    po_, 
    kvnom, 
    unom, 
    unkv, 
    rsm_number, 
    kadastr_num, 
    name, 
    type_object_code, 
    type_object,   
    kmq,      
    gpl,  
    opl, 
    ppl,     
    note,
    type_pom_code, 
    type_pom,  
    et,
    purpose_code, 
    purpose, 
    changes_date, 
    changes_user_id,
    u_building_emp_id
)
  values (
     v_id_q, --id
     v_up_emp_id, 
     v_actual ,
     v_status,
     v_d ,
     v_po_
     ,Trim(rw.kvnom)||Trim(rw.apr_ind) --kvnom
     ,rw.unom
     ,rw.unkv
     ,rw.rsm_number
     ,rw.kadastr
     ,rw.name
     ,rw.type_object_code
     ,rw.type_object
     ,rw.kmq
     ,rw.gpl
     ,rw.total_area --opl
     ,rw.ppl
     ,rw.comments --note
     ,rw.type_pom_code
     ,rw.type_pom
     ,rw.et
     ,rw.purpose_code
     ,rw.purpose
     ,v_d --CHANGES_DATE
     ,0   -- changes_user_id
     ,v_u_building_emp_id
    ) ;
    
    pkg_Iport_Export_RSGS.upd_u_premise_rel_q (v_up_emp_id,rw.emp_id, 1);   
   */ 
 else 
 j:=j+1;  
  select count(*) into cc  from u_premise_rel_q ur where ur.actual=1 and ur.u_premise_emp_id = v_up_emp_id and ur.ep_premise_q_emp_id = rw.emp_id; --���� ����� � EP_PREMISE_Q
  if cc>0 then l:=l+1; 
  else
      select count(*) into cc  from u_premise_rel_q ur where ur.actual=1 and ur.u_premise_emp_id = v_up_emp_id and ur.ep_premise_q_emp_id is null;  -- ��� �����  � EP_PREMISE_Q
      if cc>0 then 
        e:=e+1; 
       else select count(*) into cc  from u_premise_rel_q ur where ur.actual=1 and ur.u_premise_emp_id = v_up_emp_id and ur.ep_premise_q_emp_id <> rw.emp_id  and  get_norm_cadnum(ur.kadastr_num) = rw.norm_cn ; 
        if cc>0 then --�������� ��� ������� ������ ������� ���� � ����� ��������� 
          d:=d+1; 
          dbms_output.put_line('select '|| TO_CHAR(rw.emp_id)||' as ep_emp_id_NEED, ur.u_premise_emp_id, ur.ep_premise_q_emp_id, ur.* from u_premise_rel_q ur where ur.actual=1 and ur.u_premise_emp_id = '|| to_char(v_up_emp_id)||';');
          else -- ��������, ��� ������ � ������ rw.emp_id
             dbms_output.put_line('select '|| TO_CHAR(rw.emp_id)||' as ep_emp_id_NEED, ur.u_premise_emp_id, ur.ep_premise_q_emp_id, '||NVL(rw.kadastr,'NULL')||' as rw_kadastr, ur.kadastr_num, ur.* from u_premise_rel_q ur where ur.actual=1 and ur.u_premise_emp_id = '|| to_char(v_up_emp_id)||';');
            w:=w+1;
        end if;
      end if;
  end if;
  
 --pkg_Iport_Export_RSGS.upd_u_premise_rel_q (v_up_emp_id,rw.emp_id, 1);  
end if;
--
 c:=c+1; 
 /*l:=l+1;
 if l>10000 then
   commit;
   l:=0;
 end if;  */
 --exit when l>1000;  

end loop;
rollback;
--commit;

dbms_output.put_line('������������  emp_id - '|| to_char(j)||' ������ - '||to_char(fl_k) ||' �� unom (��� �������) - '||to_char(fl_u));
dbms_output.put_line('������� ��������� emp_id  - '|| to_char(l));
dbms_output.put_line('������� �� ��������� emp_id  - '|| to_char(d));
dbms_output.put_line('��� ������ � ������ rw.emp_id - '|| to_char(w));
dbms_output.put_line('��� ����� emp_id  - '|| to_char(e));

dbms_output.put_line('�������� emp_id - '|| to_char(i));
dbms_output.put_line('����� - '|| to_char(c));
end;
