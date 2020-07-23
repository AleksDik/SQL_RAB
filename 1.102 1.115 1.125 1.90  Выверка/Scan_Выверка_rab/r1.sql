select t.*, t.rowid from scan.EA_DOCUMENT_ATTR t 
where object_rel_id =  3969335

select * from scan.EA_DOCUMENT t
where 
--t.delo_id=1236721  and
(
document_id in ( 6577791)
)
                    
SELECT * from  V_TEST_VIVERKA_DOCS      

select * from  scan.ea_delo d
where d.DELO_ID=1228687


---лог привязки

select t.*, t.rowid from VERIFY_FILER t
where t.obj_type_id=8
and  t.obj_id in(  6486507,6486492)
and  t.op_type=2
and  t.obj_ext_id=4823391 


select t.*, t.rowid from scan.EA_DOCUMENT_ATTR t 
where t.user_id=-100
