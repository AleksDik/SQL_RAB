/*
create or replace view v_tp_reports_gn 
--����� � �������������� ����� ������� � ����� ������������,
--����������� �� ���� ������� ���������� �������
as

select * From(
select   
       v.apart_id, 
       v.building_id, 
       v.apartment_num, 
       v.apartment_idx, 
       oo.order_id,
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
From(
select ap.apart_id, 
       ap.building_id, 
       ap.apartment_num, 
       ap.apartment_idx,
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
and wpl.to_wp = cl_to.row_num) tp on tp.apart_id=ap.apart_id, 
free_space fs, factory f,
(select  i1.building_id , TO_CHAR(i1.department_who)||'/'||TO_CHAR(i1.num_in_department_who) as department_who from instruction i1,
(select i.building_id, max(i.instruction_num) inum 
from instruction i 
 where --i.building_id = 5950 and 
      i.department_who=753
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
and   fs.LAST IN (1, 2) --��������� ���������
and f.department=fs.department
and f.num_in_department=fs.num_in_department
and f.RIGHTS<>10
) v
left join 
(SELECT * from orders o
 where o.order_id in
 (SELECT document_num
  FROM (SELECT d.document_num, d.last_change FROM document d
        WHERE d.document_type in --�������� - �����
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
)
--order by apartment_num,apartment_idx


*/ 
select
       TO_CHAR(rownum) as A1,
     -- v.apart_id,
    INSTR (NVL(PLAN_YEARS,' '),'2013') as ii,
       ANUM as A2,
       o_name as A3,
       TO_CHAR(resolution_num) as A4,
       TO_CHAR(resolution_date,'DD.MM.YYYY') as A5,
       cl_11_short_name2 as A6,
       tp_from as A7,
       tp_to as A8,
       department_who as A9
from v_tp_reports_gn v
    
where building_id=1177

 --anda.apart_id=v.apart_id

--��� �������� � ����
and  free_space_status in (1,2,4,5) order by apartment_num,apartment_idx
--��������������
/*
and (((factory_rights=30) and (free_space_status=4)) --����������+��������
     or ((factory_rights<>30) and (free_space_status=2)) -- �� ���������� + � ���������
   ) 
*/
