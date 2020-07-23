create or replace view v_pasport_last as
/*
Последние состояния тех. паспартов (активных)
28.05.2013 Дикан 
*/
select 
tpa.relation_id,
tpa.tp_id,
tpa.apart_id,
--tpa.active,
tpa.last_change,
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
  ;
