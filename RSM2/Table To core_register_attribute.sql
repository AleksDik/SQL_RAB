
declare
v_row  core_register_attribute%rowtype:=null;
v_registerid number := 0;
j number := 0;
begin
  v_registerid:=1920;
for rw in (      
select c.COMMENTS, 
substr(a.COLUMN_NAME,1,1)||lower(substr(a.COLUMN_NAME,2,100)) as iname,
a.COLUMN_NAME,
case a.DATA_TYPE when 'NUMBER' then decode(NVL(a.DATA_PRECISION,0),1,3,1)
                 when 'VARCHAR2' then 4
                 when 'DATE' then 5 
                   else null
end as cr_type,
decode(a.NULLABLE,'N',0,1) as isnull,
0 as PK,
decode(instr(c.COMMENTS,'('||to_char(v_registerid)),0,0,1) as is_need,
substr(c.COMMENTS,instr(c.COMMENTS,'('||to_char(v_registerid))+1,9) as nn
 
from all_tab_columns a
LEFT JOIN user_col_comments c ON (a.table_name  = c.table_name AND a.column_name = c.column_name)
where a.TABLE_NAME = 'U_OBJECT_MANUAL_CHARACT'
order by a.COLUMN_ID 
)
loop
  
  if rw.is_need=1 then
    
    v_row.id := to_number(trim(rw.nn));
    v_row.name := rw.comments;
    v_row.type := rw.cr_type;
    v_row.value_field :=rw.column_name; 
    v_row.internal_name := rw.iname;
    v_row.is_nullable := rw.isnull;
     
    insert into core_register_attribute
      (id, 
       name, 
       registerid, 
       type, 
       parentid, 
       referenceid, 
       value_field, 
       code_field, 
       value_template, 
       primary_key, 
       user_key, 
       qscolumn, 
       internal_name, 
       is_nullable, 
       description, 
       layout, 
       export_column_name, 
       is_deleted)
    values
      ( v_row.id, 
      v_row.name, 
      v_registerid, 
       v_row.type,
      null,-- v_parentid, 
      null,--  v_referenceid, 
      v_row.value_field, 
      null,--  v_code_field, 
       null,-- v_value_template, 
       null,-- v_primary_key, 
      null,--  v_user_key, 
      null,--  v_qscolumn, 
      v_row.internal_name, 
      v_row.is_nullable, 
      null,--  v_description, 
      null,--  v_layout, 
      null,--  v_export_column_name, 
      null--  v_is_deleted
      );
       
 end if;



end loop;
end;

select a.*, a.rowid from core_register_attribute a
where a.registerid= 1920 ;     

-- Rsm2.ManualInputCharacteristics	Реестр характеристик ручного ввода	U_OBJECT_MANUAL_CHARACT 4	REG_OBJECT_SEQ	0	0








