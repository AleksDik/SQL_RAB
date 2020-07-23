
select 
a.affair_id, 
a.apart_id, 
a.affair_stage,
a.calc_type,
NVL(get_Is_BTI_hostel_kurs3_not(a.apart_id,a.affair_id,a.affair_stage,0),2) as Not_Eq_bti,
a.sqo,
a.sqb,
NVL(get_BTI_TOTAL_SPACE( a.apart_id),0) as sqb_r,
--(select ap.total_space_wo from apartment ap where ap.apart_id=a.apart_id) as total_space_wo,
a.sqz,
a.sql,
a.sqi,
a.creation_date,
a.* 
--get_BTI_TOTAL_SPACE( a.apart_id) as ts 
from affair a
where
a.apart_id is not null
and a.okrug_id>=51 and a.okrug_id<=60
and a.affair_stage in (1,0)
and  a.creation_date >= cast('01.09.2012' as date)
and a.sq_type not in (1,4,6) -- коммунальная квартира,  квартира гостиничного типа, коридорная система
and NVL(a.calc_type,0) = 0 -- расчет автомат (1-ручн)                                                                              
and NVL(get_Is_BTI_hostel_kurs3_not(a.apart_id,a.affair_id,a.affair_stage,0),2)=0 --нет расхождений с бти (не общаги по бти)
and ((NVL(a.sqb,-1) > 0) or --есть общая квартиты без летних 
     (NVL(get_BTI_TOTAL_SPACE( a.apart_id),0)>0) -- или общую квартиты без летних можно посчитать
    )
and ((NVL(a.sqz,-1)<=0) or 
     (NVL(a.sql,-1)<=0) 
    )
--and NVL(a.sqo,-1) <= 0 нет таких
order by a.creation_date




SELECT --rd.affair_id, rd.affair_stage , rd.building_id, rd.apart_id, 
count(r.room_num) as cr, count(r.km_bti) as c , count (r.kmi_bti) as ci
        FROM affair a, room r, room_delo rd
        WHERE    a.affair_id = rd.affair_id   
             AND a.apart_id =  rd.apart_id  
             AND a.affair_stage = rd.affair_stage
             AND a.okrug_id = rd.okrug_id
             AND r.apart_id =  rd.apart_id
             and r.building_id = rd.building_id 
             AND r.room_num =  rd.room_num
             AND a.affair_stage = 1
             AND a.affair_id = 586605
group by rd.affair_id, rd.affair_stage , rd.building_id, rd.apart_id, rd.room_num  
