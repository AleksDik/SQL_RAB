select id, cls_id, obj_id, date_from, date_to, is_actual, create_user_id, create_date, modify_user_id, modify_date, cls_id_tree
  into v_id, v_cls_id, v_obj_id, v_date_from, v_date_to, v_is_actual, v_create_user_id, v_create_date, v_modify_user_id, v_modify_date, v_cls_id_tree
  from mgr_exchange.local_rg_object_class
 where ;


for c in (
 select * from local_rg_object_class roc where roc.id not in(
--create table tmp_local_rg_object_class as 
select id from( 
  select roc.id as id, 
         roc.cls_id as cls_id, 
         roc.obj_id as OBJECT_ID_IN_SOURCE, 
         roc.date_from as S_, 
         roc.date_to as PO_, 
         roc.is_actual as actual, 
         roc.create_user_id, 
         roc.create_date, 
         roc.modify_user_id, 
         roc.modify_date, 
         roc.cls_id_tree  as  cls_id_tree 
         ,o.obj_type
         ,o.cadastral_numb
         ,o.bld_unom
         ,o.apr_unkv
  from mgr_exchange.local_rg_object_class roc, MV$MGR_RG_OBJECTS o
  where roc.obj_id=o.id
  )
    )
loop
  

end loop;

mgr_rg_rights

