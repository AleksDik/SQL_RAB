drop table TMP_AFFAIR_SPACE_UP;  
begin
 UPDATE_AFFAIR_SPACE;
end;


/*
select ((((vd.sqo-vd.vshk)-vd.blc)/vd.liv_sq) * vd.sqi)+vd.vshkindelo+vd.blcindelo  as z, (((vd.sqb-vd.vshk)/vd.liv_sq) * vd.sqi)+vd.vshkindelo as l,
vd.*  
from  V_DIFF_AFFAIR_SPACE vd
where vd.affair_id=587138 --617015 -- 588248
*/

drop table DIFF_AFFAIR_SPACE_HIST;  
 
create table DIFF_AFFAIR_SPACE_HIST as   
select ((vd.sqo-vd.vshk)-vd.blc) as z, (vd.sqb-vd.vshk)as l,  
        ((((vd.sqo-vd.vshk)-vd.blc)/vd.liv_sq) * vd.sqi)+vd.vshkindelo+vd.blcindelo  as SQZ_NF, (((vd.sqb-vd.vshk)/vd.liv_sq) * vd.sqi)+vd.vshkindelo as SQL_NF,
        (vd.sqo* vd.sqi)/vd.liv_sq as SQZ_OF,(vd.sqb* vd.sqi)/vd.liv_sq as SQL_OF,
vd.*  
from  V_DIFF_AFFAIR_SPACE vd
where 
 --((NVL(vd.sqz,-1)>0) or (NVL(vd.sql,-1)>0)) and
  ((NVL(vd.sqz,-1)<>NVL(vd.r_sqz,0)) or (NVL(vd.sql,-1)<>NVL(vd.r_sql,0))or (NVL(vd.sqb,-1)<>NVL(vd.r_sqb,0)))
  and vd.is_err in (0,11) 
  and vd.calc_type<>1
  and vd.liv_sq>0
order by vd.is_err

  --and 
  --для посмотреть все 'Oк'
  -- and vd.is_err <> 0 --для посмотреть c ошибками
  -- and vd.is_err in (1,2,3,4,5,6,7,8,9,10) --для посмотреть выбрать ошибки по вкусу
  -- and  NVL(vd.calc_type,0) = 0 --  выбрать: 0 - расчет автомат. или 1 - ручн. 
  -- and vd.affair_stage in (1,0) 
  -- and vd.calc_type=0 -- 0 -- расчет автомат (1-ручн) 
  -- and .....      -- доп условия  выбрать по вкусу
select   *  from affair a where a.affair_id=588248 

            select count(*) 
            FROM    room r
            WHERE  r.apart_id   = 7546815
                 and r.building_id = (select distinct ap.building_id from apartment ap where ap.apart_id=7546815 )
                 and ((NVL(r.km_bti,-1) >-1)  or (NVL(r.kmi_bti,' ') <> ' ' ) );











