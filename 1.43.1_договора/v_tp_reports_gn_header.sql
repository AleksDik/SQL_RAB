create or replace view v_tp_reports_gn_header as
--заголовок отчета о предоставлении жилой площади в домах новостройках,
--построенных за счет средств городского бюджета
select b.building_id,
        a.name as okrug,
        ADDR_BUILDING(b.building_id) as addr,
        case NVL(xn.addr_id_s,0)
         when 0 then ''
        else GET_ADDR2(xn.addr_id_s,1)
       end as addr_s
 from  building b,area a,
 ( select ap.building_id, max(ap.new_building_code)as bc from APARTMENT ap
 group by ap.building_id ) nbc
left join kursiv.xns xn on nbc.bc=xn.zsn
 where
  b.area=a.okrug_id
  and nbc.building_id = b.building_id;
