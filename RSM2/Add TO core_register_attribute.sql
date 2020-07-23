select t.*, t.rowid from core_register t
where registerid = 437

select t.*, t.rowid from core_register_attribute t
where  registerid = 436
and id =43613101

select * from core_layout t   -- layoutid = 1105002
where registerid = 436;
 
select * from core_layout_details t
where layoutid = 1105002;1105003

-------------------------------------------------------------------------------------
insert into core_register_attribute
 (id, name, registerid, type, 
 value_field, internal_name, is_nullable)
values
 (43602301, --id
 'К_Жил d', --name
 436, --registerid
 2, --type
'SQI_d', -- value_field
'SQI_d', --internal_name,
 1 --is_nullable,
);


insert into core_register_attribute
 (id, name, registerid, type, 
 value_field, internal_name, is_nullable)
values
 (43603801, --id
 'К_Общ_Кв d', --name
 436, --registerid
 2, --type
'TOTAL_SPACE_d', -- value_field
'TOTAL_SPACE_d', --internal_name,
 1 --is_nullable,
);

insert into core_register_attribute
 (id, name, registerid, type, 
 value_field, internal_name, is_nullable)
values
 (43613201, --id
 'К_Общ(б/л)', --name
 436, --registerid
 2, --type
'SQL_d', -- value_field
'SQL_d', --internal_name,
 1 --is_nullable,
);

insert into core_register_attribute
 (id, name, registerid, type, 
 value_field, internal_name, is_nullable)
values
 (43603301, --id
 'К_Тип_Кв код', --name
 436, --registerid
 2, --type
'SQ_TYPE_COD', -- value_field
'SQ_TYPE_COD', --internal_name,
 1 --is_nullable,
);

insert into core_register_attribute
 (id, name, registerid, type, 
 value_field, internal_name, is_nullable)
values
 (43603601, --id
 'КПУ_Вид обеспеч код', --name
 436, --registerid
 2, --type
'TYPE2_COD', -- value_field
'TYPE2_COD', --internal_name,
 1 --is_nullable,
);

insert into core_register_attribute
 (id, name, registerid, type, 
 value_field, internal_name, is_nullable)
values
 (43600101, --id
 'Округ_код', --name
 436, --registerid
 2, --type
'OKRUG_ID', -- value_field
'OKRUG_ID', --internal_name,
 1 --is_nullable,
);

insert into core_register_attribute
 (id, name, registerid, type, 
 value_field, internal_name, is_nullable)
values
 (43613101 , --id
 'Адрес улица код', --name
 436, --registerid
 2, --type
'STREET_ID', -- value_field
'STREET_ID', --internal_name,
 1 --is_nullable,
);

insert into core_register_attribute
 (id, name, registerid, type, 
 value_field, internal_name, is_nullable)
values
 (43613102, --id
 'Адрес дом номер', --name
 436, --registerid
 2, --type
'HOUSE_NUM', -- value_field
'HOUSE_NUM', --internal_name,
 1 --is_nullable,
);
       
insert into core_register_attribute
 (id, name, registerid, type, 
 value_field, internal_name, is_nullable)
values
 (43613110, --id
 'Адрес корпус номер', --name
 436, --registerid
 2, --type
'BUILDING_NUM', -- value_field
'BUILDING_NUM', --internal_name,
 1 --is_nullable,
);    

insert into core_register_attribute
 (id, name, registerid, type, 
 value_field, internal_name, is_nullable)
values
 (43613120, --id
 'Адрес строение номер', --name
 436, --registerid
 2, --type
'CONSTRUCTION_NUM', -- value_field
'CONSTRUCTION_NUM', --internal_name,
 1 --is_nullable,
);

insert into core_register_attribute
 (id, name, registerid, type, 
 value_field, internal_name, is_nullable)
values
 (43602401, --id
 'КПУ_Состояние код', --name
 436, --registerid
 2, --type
'CONDITION_COD', -- value_field
'CONDITION_COD', --internal_name,
 1 --is_nullable,
);
-------------------Поиск ------------------------
select * from core_reference t;

 insert into core_reference
(referenceid, description, viddoc, readonly, progid, istree)
values
(433, --referenceid
 'К_Тип_Кв код',  --description
 4, --viddoc,
 0, -- readonly,
 'Rsm.Dal.KursExecutor, Rsm.Dal', -- progid
 0 );
         

insert into core_reference
(referenceid, description, viddoc, readonly, progid, istree)
values
(431, --referenceid
 'Курс.КПУ_Категория дела',  --description
 4, --viddoc,
 0, -- readonly,
 'Rsm.Dal.KursExecutor, Rsm.Dal', -- progid
 0 );

insert into core_reference
(referenceid, description, viddoc, readonly, progid, istree)
values
(430, --referenceid
 'Курс.КПУ_Состояние код',  --description
 4, --viddoc,
 0, -- readonly,
 'Rsm.Dal.KursExecutor, Rsm.Dal', -- progid
 0 );

insert into core_reference
(referenceid, description, viddoc, readonly, progid, istree)
values
(429, --referenceid
 'КурсКПУ Адрес Улица',  --description
 4, --viddoc,
 0, -- readonly,
 'Rsm.Dal.KursExecutor, Rsm.Dal', -- progid
 0 );
 
 
 insert into core_reference
(referenceid, description, viddoc, readonly, progid, istree)
values
(432, --referenceid
 'КПУ_Вид обеспеч код',  --description
 4, --viddoc,
 0, -- readonly,
 'Rsm.Dal.KursExecutor, Rsm.Dal', -- progid
 0 );
                                
