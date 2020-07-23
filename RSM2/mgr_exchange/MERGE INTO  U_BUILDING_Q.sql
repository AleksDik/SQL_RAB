
MERGE INTO  U_BUILDING_Q cc1  
--u_premise_q cc1
USING
(
select 
distinct t.id,
t.emp_id,
r.object_id ,
t.type_gf_purpose_use, 
t.type_gf_purpose_use_code,
t.SUBTYPESPECIALHOUSINGFUND_CODE,
t.SUBTYPESPECIALHOUSINGFUND,
r.cls_id,
c.value,
c.itemid
from  
U_BUILDING_Q t,
--u_premise_q t,
(select * from (
select t.*, row_number()  over (partition by t.object_id order by t.date_from desc)  as rc from U_RSGS_TYPE_GF t
)
where rc=1) r,
CORE_REFERENCE_ITEM c 

where t.emp_id = r.object_id 
   and c.code =  r.cls_id 
   and c.referenceid in (2010) --(2011)
) p
 ON (cc1.id=p.id and cc1.emp_id=p.emp_id)
 WHEN MATCHED THEN
 UPDATE SET cc1.type_gf_purpose_use = p.value, --2010'Специализированный жилищный фонд г. Москвы', --
            cc1.type_gf_purpose_use_code =p.itemid --2010 201020100003, -- 
          --  cc1.subtypespecialhousingfund_code  = p.itemid, --2011
         --   cc1.subtypespecialhousingfund = p.value   --2011
            ;
   
