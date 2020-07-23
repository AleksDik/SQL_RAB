select a.*, a.rowid from core_register_attribute a
where a.registerid=  1920
order by a.id; 

--select a.*, a.rowid
delete from core_register_attribute a
where a.registerid=  1920
and a.value_field in ('CULT_HERITAGE_FLAG',
'CULT_HERITAGE_REG_TYPE',
'CULT_HERITAGE_REG_TYPE_CODE',
'CULT_HERITAGE_CONDITION',
'CULT_HERITAGE_DOC_NUM',
'CULT_HERITAGE_DOC_DATE')

select a.*, a.rowid from core_register_attribute a
where a.registerid=  1920
and a.value_field in ('UNAUTHORIZED_OSZ_FLAG',
'UNAUTHORIZED_EXTENSION_FLAG')

update core_register_attribute a
set a.value_field = 'UNAUTHORIZED_FLAG',
    a.name = 'Самострой - Принадлежность (0 - Нет; 1 - Да)',
    a.internal_name = 'Unauthorized_flag'
where a.registerid=  1920
and a.value_field in ('UNAUTHORIZED_OSZ_FLAG');


update core_register_attribute a
set a.value_field = 'UNAUTHORIZED_TYPE',
    a.code_field = 'UNAUTHORIZED_TYPE_CODE',
    a.name = 'Самострой - отдельное стоящее здание или пристройка',
    a.type = 4,
    a.referenceid = 2049,
    a.internal_name = 'Unauthorized_type'
where a.registerid=  1920
and a.value_field in ('UNAUTHORIZED_EXTENSION_FLAG');



--------------
-- Add/modify columns 
alter table U_OBJECT_MANUAL_CHARACT rename column unauthorized_osz_flag to UNAUTHORIZED_FLAG;
alter table U_OBJECT_MANUAL_CHARACT rename column unauthorized_extension_flag to UNAUTHORIZED_TYPE_CODE;
alter table U_OBJECT_MANUAL_CHARACT modify unauthorized_type_code NUMBER(10);
alter table U_OBJECT_MANUAL_CHARACT add unauthorized_type VARCHAR2(50);
-- Add comments to the columns 
comment on column U_OBJECT_MANUAL_CHARACT.unauthorized_flag
  is 'Самострой - Принадлежность (0 - Нет; 1 - Да) (192002200)
';
comment on column U_OBJECT_MANUAL_CHARACT.unauthorized_type_code
  is 'Самострой - отдельное стоящее здание или пристройка (код).';
comment on column U_OBJECT_MANUAL_CHARACT.unauthorized_type
  is 'Самострой - отдельное стоящее здание или пристройка';
