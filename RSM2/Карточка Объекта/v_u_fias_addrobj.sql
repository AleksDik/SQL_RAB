TRUNCATE TABLE U_FIAS_ADDROBJ;

INSERT INTO U_FIAS_ADDROBJ (AOID,AOLEVEL,AOGUID,AOGUID_1_REGION,AOGUID_3_AREA,AOGUID_4_CITY,AOGUID_6_PLACE,AOGUID_65_PLAN,AOGUID_7_STREET,OFFNAME)
    SELECT
 t.aoid, t.aolevel, t.aoguid, 
case when t.aolevel=1 then t.aoguid 
     when tt1.aolevel=1 then tt1.aoguid 
     when tt1.aolevel2=1 then tt1.aoguid2 
     when tt1.aolevel3=1 then tt1.aoguid3  
     when tt1.aolevel4=1 then tt1.aoguid4   
     when tt1.aolevel5=1 then tt1.aoguid5             
     else NULL end as AOGUID_1_REGION,
/*
     case when t.aolevel=2 then t.aoguid 
     when tt1.aolevel=2 then tt1.aoguid 
     when tt1.aolevel2=2 then tt1.aoguid2 
     when tt1.aolevel3=2 then tt1.aoguid3 
     when tt1.aolevel4=2 then tt1.aoguid4
     when tt1.aolevel5=2 then tt1.aoguid5                
     else NULL end as G2,
       */
case when t.aolevel=3 then t.aoguid 
     when tt1.aolevel=3 then tt1.aoguid 
     when tt1.aolevel2=3 then tt1.aoguid2  
     when tt1.aolevel3=3 then tt1.aoguid3  
     when tt1.aolevel4=3 then tt1.aoguid4
     when tt1.aolevel5=3 then tt1.aoguid5                
     else NULL end as AOGUID_3_AREA,
case when t.aolevel=4 then t.aoguid 
     when tt1.aolevel=4 then tt1.aoguid 
     when tt1.aolevel2=4 then tt1.aoguid2 
     when tt1.aolevel3=4 then tt1.aoguid3 
     when tt1.aolevel4=4 then tt1.aoguid4
     when tt1.aolevel5=4 then tt1.aoguid5                
     else NULL end as AOGUID_4_CITY,
case when t.aolevel=6 then t.aoguid
     when tt1.aolevel=6 then tt1.aoguid
     when tt1.aolevel2=6 then tt1.aoguid2 
     when tt1.aolevel3=6 then tt1.aoguid3 
     when tt1.aolevel4=6 then tt1.aoguid4
     when tt1.aolevel5=6 then tt1.aoguid5                
     else NULL end as AOGUID_6_PLACE,
case when t.aolevel=65 then t.aoguid
     when tt1.aolevel=65 then tt1.aoguid 
     when tt1.aolevel2=65 then tt1.aoguid2
     when tt1.aolevel3=65 then tt1.aoguid3
     when tt1.aolevel4=65 then tt1.aoguid4        
     when tt1.aolevel5=65 then tt1.aoguid5                  
     else NULL end as AOGUID_65_PLAN, 
case when t.aolevel=7 then t.aoguid 
    when tt1.aolevel=7 then tt1.aoguid 
    when tt1.aolevel2=7 then tt1.aoguid2
    when tt1.aolevel3=7 then tt1.aoguid3
    when tt1.aolevel4=7 then tt1.aoguid4 
    when tt1.aolevel5=7 then tt1.aoguid5               
    else NULL end as AOGUID_7_STREET,  
decode (tt1.n,NULL,'',tt1.n||', ')||(select v.scname from v_fias_socrbase_link v where v.shortname=t.shortname and v.aolevel=t.aolevel and rownum=1)||
' '|| t.offname  as OFFNAME
from fias_addrob77 t 
left join (select t1.aolevel, tt2.aolevel as aolevel2, tt2.aolevel3, tt2.aolevel4, aolevel5, t1.aoguid, tt2.aoguid as aoguid2, tt2.aoguid3 , tt2.aoguid4, aoguid5,
           decode (tt2.n,NULL,'',tt2.n||', ')||(select v.scname from v_fias_socrbase_link v where v.shortname=t1.shortname and v.aolevel=t1.aolevel and rownum=1)||' ' || t1.offname as n from fias_addrob77 t1
               left join 
                         (select  t2.aolevel ,  tt3.aolevel as aolevel3, tt3.aolevel4,aolevel5, t2.aoguid, tt3.aoguid as aoguid3, tt3.aoguid4, aoguid5, 
                         decode (tt3.n,NULL,'',tt3.n||', ')||(select v.scname from v_fias_socrbase_link v where v.shortname=t2.shortname and v.aolevel=t2.aolevel and rownum=1)
                         ||' '||t2.offname as n 
                         from fias_addrob77 t2
                          left join 
                          (select  t3.aolevel , tt4.aolevel as aolevel4,aolevel5, t3.aoguid,  tt4.aoguid as aoguid4, aoguid5,
                           decode (tt4.n,NULL,'',tt4.n||', ')||(select v.scname from v_fias_socrbase_link v where v.shortname=t3.shortname and v.aolevel=t3.aolevel and rownum=1)
                           ||' ' ||t3.offname as n 
                           from fias_addrob77 t3
                           left join 
                           (select  t4.aolevel ,tt5.aolevel as aolevel5 , t4.aoguid, tt5.aoguid as aoguid5, 
                           decode (tt5.n,NULL,'',tt5.n||', ')||(select v.scname from v_fias_socrbase_link v where v.shortname=t4.shortname and v.aolevel=t4.aolevel and rownum=1)
                           ||' ' ||t4.offname as n 
                           from fias_addrob77 t4
                              left join 
                                (select  t5.aolevel , t5.aoguid, 
                               (select v.scname from v_fias_socrbase_link v where v.shortname=t5.shortname and v.aolevel=t5.aolevel and rownum=1) ||' ' ||t5.offname as n 
                                from fias_addrob77 t5
                                 where  t5.actstatus=1 and t5.livestatus=1 and t5.nextid is null
                                ) tt5  on t4.parentguid=tt5.aoguid
                             where  t4.actstatus=1 and t4.livestatus=1 and t4.nextid is null
                           ) tt4  on t3.parentguid=tt4.aoguid
                            where  t3.actstatus=1 and t3.livestatus=1 and t3.nextid is null
                          ) tt3  on t2.parentguid=tt3.aoguid
                         where  t2.actstatus=1 and t2.livestatus=1 and t2.nextid is null 
                         )tt2  on t1.parentguid=tt2.aoguid
            where  t1.actstatus=1 and t1.livestatus=1   and t1.nextid is null
          ) tt1 on t.parentguid=tt1.aoguid
where 
t.actstatus=1 and t.livestatus=1 and t.nextid is null
order by t.aolevel;
commit;
