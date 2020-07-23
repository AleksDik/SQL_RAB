CREATE OR REPLACE VIEW V_TP_REPORTS_GN AS
select
       v.apart_id,
       v.building_id,
       v.apartment_num,
       v.apartment_idx,
       oo.order_id,
       v.PLAN_YEARS,
       v.ANUM,  --A2
       a.name as o_name,  --A3
       oo.resolution_num, --A4
       oo.resolution_date,--A5
       cl.short_name2 as cl_11_short_name2, --A6
       v.tp_from,  --A7
       v.tp_to,    --A8
       v.department_who, --A9
       v.status as free_space_status,
       v.rights as factory_rights
From
( select ap.apart_id,
       ap.building_id,
       ap.apartment_num,
       ap.apartment_idx,
       GET_PLAN_YEARS((select max(af.affair_id) from affair af where  af.build_id = ap.building_id AND af.apart_id = ap.apart_id)) as PLAN_YEARS,
       To_CHAR(ap.apartment_num)||' '||ap.apartment_idx as ANUM,
       fs.doc2_num,
       fs.status,
       f.rights,
       tp.tp_from as tp_from,
       tp.tp_to as tp_to,
       ii.department_who
from  APARTMENT ap

left join (
select tpa.apart_id,
case when cl_from.row_num=20 then cl_from.name else cl_to.name end as tp_from,
cl_to.name as tp_to
select * , wpl.doc_type_id
from TP_RELATION_APART tpa,  tp_traffic tpt, tp_work_place_link wpl,
(select tpt1.tp_id , Max(tpt1.nsort) as nsort from tp_traffic tpt1 group by tpt1.tp_id) tpt2,
(select cl_132.row_num,cl_132.name from classifier_kurs3 cl_132
where classifier_num = 132) cl_from,
(select cl_132.row_num,cl_132.name from classifier_kurs3 cl_132
where classifier_num = 132) cl_to
where tpt.tp_id=tpa.tp_id
and tpt.tp_id=tpt2.tp_id
and tpt.nsort=tpt2.nsort
and wpl.work_place_link_id=tpt.work_place_link_id
and wpl.from_wp=cl_from.row_num
and wpl.to_wp = cl_to.row_num
and tpa.active=1) tp on tp.apart_id=ap.apart_id, 

/*
--<Ilonis> 
select tpa.*,
cl_st.row_num as tp_status_num,
cl_st.Name as tp_status,
cl_from.row_num as tp_from_num,
cl_from.name as tp_from,
cl_to.row_num as tp_to_num,
cl_to.name as tp_to,
cl_doc.row_num as tp_doc_num,
cl_doc.name as tp_doc
from tp_traffic tpt
inner join  tp_work_place_link wpl  on  TPT.WORK_PLACE_LINK_ID=WPL.WORK_PLACE_LINK_ID
inner join  classifier_kurs3 cl_from  on   cl_from.row_num=WPL.FROM_WP and  cl_from.classifier_num = 132
inner join  classifier_kurs3 cl_to     on    cl_to.row_num= WPL.TO_WP and  cl_to.classifier_num = 132
inner join  classifier_kurs3 cl_st     on    cl_st.row_num= WPL.STATUS_ID and  cl_st.classifier_num = 135
inner join  classifier_kurs3 cl_doc     on    cl_doc.row_num = WPL.doc_type_id and  cl_doc.classifier_num = 134
inner join  TP_RELATION_APART tpa on   TPT.TP_ID=TPA.TP_ID
where TPA.ACTIVE=1
and
 (tpt.tp_id,tpt.nsort)=(select tp_id , Max(nsort) as nsort from tp_traffic where tp_id=tpt.tp_id group by tp_id ) 
  
*/

free_space fs, factory f,

(select  i1.building_id , get_factory_name (i1.department_who, i1.num_in_department_who) as department_who 
 from instruction i1,
                      (select i.building_id, max(i.instruction_num) inum
                      from instruction i
                      where i.department_who=753
                      and   i.department_to=753
                      and   i.document_type=1
                      and  ((((i.num_in_department_who =220) and (i.num_in_department_to=222))) or ((i.num_in_department_who =222) and (i.num_in_department_to=220)))
                      group by i.building_id
                      ) i2
 where i1.instruction_num=i2.inum  and i1.building_id=i2.building_id
) ii

where ap.version = 0
and   ap.apart_id = fs.apart_id
and   fs.building_id = ap.building_id
and   ii.building_id = ap.building_id
and   fs.LAST IN (1, 2) --последнее состояние
and f.department=fs.department
and f.num_in_department=fs.num_in_department
and f.RIGHTS<>10
) v
left join
(SELECT * from orders o
 where o.order_id in
 (SELECT document_num
  FROM (SELECT d.document_num, d.last_change FROM document d
        WHERE d.document_type in --документ - ордер
                            (select TO_NUMBER(sTable.n) as n from
                               ( select  regexp_substr(
                                                      (select ','||translate(VALUE,'1 ','1')||',' from KURS3.GLOBAL_PARAMETERS where PARAMETER_NAME = 'ORDER_TYPES'),
                                                      '[^,]+',1,level
                                                      ) as n from dual
                                connect by regexp_substr(
                                                         (select ','||translate(VALUE,'1 ','1')||',' from KURS3.GLOBAL_PARAMETERS where PARAMETER_NAME = 'ORDER_TYPES'),
                                                         '[^,]+',1,level
                                                         ) is not null
                                )sTable)
        GROUP BY d.document_num, d.last_change having d.last_change=max(d.last_change)
       )
)) oo on  oo.order_id=v.doc2_num
left join CLASSIFIER cl on  cl.row_num=oo.type3 and cl.classifier_num=11
left join area a on a.okrug_id=oo.okrug_id

order by apartment_num,apartment_idx


/*
where building_id=1177

--все квартиры в доме
and  free_space_status in (1,2,4,5)
--распределенные

--and ( ((factory_rights=30) and (free_space_status=4)) --префектуры+заселена
 --     or ((factory_rights<>30) and (free_space_status=2)) -- не префектуры + к заселению
   --   )

*/;
