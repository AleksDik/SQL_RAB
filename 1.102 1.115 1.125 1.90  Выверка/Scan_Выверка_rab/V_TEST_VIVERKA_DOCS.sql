CREATE OR REPLACE VIEW V_TEST_VIVERKA_DOCS AS
/*
показывает дела выверки в которых привязано более одного паспорта на одного человека, что дает ошибку в интерфейсе
*/
SELECT ed.delo_id,eda.*,ed.user_id as document_user_id
            FROM scan.ea_document ed, scan.ea_document_attr eda
           WHERE eda.document_id = ed.document_id AND eda.row_status = 1 AND eda.object_type_id = 7    
           and  ed.delo_id  in 
(select delo_id
from(           
SELECT ed.delo_id, eda.object_rel_id, count(eda.object_rel_id) as c
FROM scan.ea_document ed, scan.ea_document_attr eda
WHERE eda.document_id = ed.document_id 
AND eda.row_status = 1 
AND eda.object_type_id = 7                
group by   ed.delo_id, eda.object_rel_id  having   count(eda.object_rel_id)>1      
))
order by   eda.object_rel_id ,  ed.delo_id  ,eda.last_change   
