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
 fl integer :=0;
v_emp_id_old number;
v_up_emp_id number;
v_rel_type  number := 1620; --EP_PREMISE_Q;

begin
/*  
 cc :=  pkg_Iport_Export_RSGS.IsEqualPremise (105852026,96130256);
       dbms_output.put_line(to_char(cc)||' где 0 оставить старую; -2задвойка; -1; -- связьc new');
   return;
*/ 
for rw in (
  select ep.*, get_norm_cadnum(ep.kadastr) as norm_cn,upper(trim(ep.kvnom)||trim(ep.apr_ind)) as ep_kvnom
  from  EP_PREMISE_Q ep --,  U_PREMISE_Q up
  where ep.actual =1
  and  ep.source_id = 20030007
  and NVL(ep.is_closed,0) = 0
  and ep.emp_id=96308431
-- and  ((get_norm_cadnum(ep.kadastr)=get_norm_cadnum(up.kadastr_num)) or ((ep.unom=up.unom)and(ep.unkv=up.unkv)) )
--and up.actual=1
--and not exists (select * from u_PREMISE_rel_q ur where ur.u_premise_emp_id=up.emp_id and ur.actual=1)

)
loop
  --v_emp_id   := NULL;
 -- v_d        := NULL;
  v_up_emp_id := NULL; 
  fl:=0;
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
 
if (v_up_emp_id  is null) --вставить в U_PREMISE_Q из EP_PREMISE_Q
then
 i:= i+1;
 
 --v_up_emp_id := pkg_Iport_Export_RSGS.InsInUPfromEP_premise(rw.emp_id);
 -- pkg_Iport_Export_RSGS.upd_u_premise_rel_q (v_up_emp_id,rw.emp_id, 1);   
  
 else 
 j:=j+1; 
   select count(*) into cc  from u_premise_rel_q ur where ur.actual=1 and ur.u_premise_emp_id = v_up_emp_id and ur.ep_premise_q_emp_id = rw.emp_id; --есть связь с EP_PREMISE_Q
   if cc>0 then l:=l+1; 
   else
        select count(*) into cc  from u_premise_rel_q ur where (ur.actual=1 and ur.u_premise_emp_id = v_up_emp_id) and (ur.ep_premise_q_emp_id is null);-- and  (get_norm_cadnum(ur.kadastr_num) = rw.norm_cn);  -- нет связи  с EP_PREMISE_Q
        if cc>0 then 
          e:=e+1; fl :=1 ;
          else select count(*) into cc  from u_premise_rel_q ur where ur.actual=1 and ur.u_premise_emp_id = v_up_emp_id and ur.ep_premise_q_emp_id <> rw.emp_id  and  get_norm_cadnum(ur.kadastr_num) = rw.norm_cn ; 
          if cc>0 then --разборки как связать разные объекты рсжс с одним кадастром 
            d:=d+1; fl:=2; if (NVL(rw.is_closed,0)<> 0) then  fl:=4; end if;
            dbms_output.put_line('select '|| TO_CHAR(rw.emp_id)||' as ep_emp_id_NEED, ur.u_premise_emp_id, ur.ep_premise_q_emp_id, ur.* from u_premise_rel_q ur where ur.actual=1 and ur.u_premise_emp_id = '|| to_char(v_up_emp_id)||'; --fl=2');
            else -- разборки, что делать с данным rw.emp_id
               dbms_output.put_line('select '|| TO_CHAR(rw.emp_id)||' as ep_emp_id_NEED, ur.u_premise_emp_id, ur.ep_premise_q_emp_id, '||NVL(rw.kadastr,'NULL')||' as rw_kadastr, ur.kadastr_num, ur.* from u_premise_rel_q ur where ur.actual=1 and ur.u_premise_emp_id = '|| to_char(v_up_emp_id)||'; fl=3');
              w:=w+1; if (NVL(rw.is_closed,0) = 0) then fl:=3; else fl:=4; end if;
          end if;
        end if;
   end if;

 case  when fl = 0 
      then null;
      when fl in (1) -- нет связи  с EP_PREMISE_Q
      then 
         cc :=  pkg_Iport_Export_RSGS.IsEqualPremise (v_up_emp_id,rw.emp_id);
         if ( cc = pkg_Iport_Export_RSGS.c_new  )   --нет связи с 
            then  
              dbms_output.put_line(fl||' сс=-1 ; Связать для emp_id= '|| to_char(rw.emp_id));
              pkg_Iport_Export_RSGS.upd_u_premise_rel_q (v_up_emp_id,rw.emp_id, 1);  
           else  
             dbms_output.put_line(fl||' сс= '|| to_char(cc)||' связь с '|| to_char(v_up_emp_id)|| ' не равна связи с '||to_char(rw.emp_id));
             v_up_emp_id := pkg_Iport_Export_RSGS.InsInUPfromEP_premise(rw.emp_id);
             pkg_Iport_Export_RSGS.upd_u_premise_rel_q (v_up_emp_id,rw.emp_id, 1);   
         end if;
           
      when fl in (2,3)  -- 2 - связать разные объекты рсжс с одним кадастром 3- связать разные объекты рсжс 
      then cc :=  pkg_Iport_Export_RSGS.IsEqualPremise (v_up_emp_id,rw.emp_id);
           case 
             when cc = 0  then  --оставить старую; 
                   dbms_output.put_line(fl||' сс=0 -оставить старую;  завести новую v_up_emp_id ; завести новую  связьи с '||to_char(rw.emp_id));
                   v_up_emp_id := pkg_Iport_Export_RSGS.InsInUPfromEP_premise(rw.emp_id); --завести новую 
                   pkg_Iport_Export_RSGS.upd_u_premise_rel_q (v_up_emp_id,rw.emp_id, 1);  --завести новую  связь
              when cc = -1  then  -- связь c new;
                       ---получить old emp_id
                       select ur.ep_premise_q_emp_id into v_emp_id_old  from u_premise_rel_q ur where ur.actual=1 and ur.u_premise_emp_id = v_up_emp_id and ur.ep_premise_q_emp_id <> rw.emp_id ;-- and  get_norm_cadnum(ur.kadastr_num) = rw.norm_cn ; 
                       if fl = 2 then
                         pkg_Iport_Export_RSGS.set_premise_rel_ext (v_up_emp_id, v_emp_id_old ,v_rel_type); --записать задвойку со старой    
                         pkg_Iport_Export_RSGS.upd_u_premise_rel_q (v_up_emp_id,rw.emp_id, 2); -- связать с новой
                           dbms_output.put_line('fl2 сс=-1 -записать задвойку со старой '|| to_char(v_emp_id_old) ||' связать с новой '||to_char(rw.emp_id));
                        else  -- fl=3 
                          pkg_Iport_Export_RSGS.upd_u_premise_rel_q (v_up_emp_id,rw.emp_id, 2); -- связать с новой
                          v_up_emp_id := pkg_Iport_Export_RSGS.InsInUPfromEP_premise(v_emp_id_old); --завести старую 
                          pkg_Iport_Export_RSGS.upd_u_premise_rel_q (v_up_emp_id,v_emp_id_old,1);  -- связать старую
                            dbms_output.put_line('fl3 сс=-1 -cвязать с новой '|| to_char(rw.emp_id) ||'завести старую, связать старую '||to_char(v_emp_id_old));
                       end if;
              when cc = -2  then  -- записать задвойку с новой;
                      dbms_output.put_line(fl||' сс=-2 записать задвойку с новой; '|| to_char(rw.emp_id));
                     pkg_Iport_Export_RSGS.set_premise_rel_ext (v_up_emp_id,rw.emp_id,v_rel_type);   
             else    dbms_output.put_line('Нет нет операций для emp_id= '|| to_char(rw.emp_id));
             end case;     
      else  --fl=4 -- записать задвойку
             dbms_output.put_line(' fl4 записать задвойку для emp_id= '|| to_char(rw.emp_id));
           pkg_Iport_Export_RSGS.set_premise_rel_ext (v_up_emp_id,rw.emp_id,v_rel_type); 
 end case;  

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
--rollback;
commit;

dbms_output.put_line('Сопоставлено  emp_id - '|| to_char(j)||' строго - '||to_char(fl_k) ||' по unom (нет кадастр) - '||to_char(fl_u));
dbms_output.put_line('Связано правильно emp_id  - '|| to_char(l));
dbms_output.put_line('Связано НЕ правильно emp_id  - '|| to_char(d));
dbms_output.put_line('Что делать с данным rw.emp_id - '|| to_char(w));
dbms_output.put_line('Нет связи emp_id  - '|| to_char(e));

dbms_output.put_line('Добавить emp_id - '|| to_char(i));
dbms_output.put_line('всего - '|| to_char(c));
end;

