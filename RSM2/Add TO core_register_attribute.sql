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
 '�_��� d', --name
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
 '�_���_�� d', --name
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
 '�_���(�/�)', --name
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
 '�_���_�� ���', --name
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
 '���_��� ������� ���', --name
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
 '�����_���', --name
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
 '����� ����� ���', --name
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
 '����� ��� �����', --name
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
 '����� ������ �����', --name
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
 '����� �������� �����', --name
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
 '���_��������� ���', --name
 436, --registerid
 2, --type
'CONDITION_COD', -- value_field
'CONDITION_COD', --internal_name,
 1 --is_nullable,
);
-------------------����� ------------------------
select * from core_reference t;

 insert into core_reference
(referenceid, description, viddoc, readonly, progid, istree)
values
(433, --referenceid
 '�_���_�� ���',  --description
 4, --viddoc,
 0, -- readonly,
 'Rsm.Dal.KursExecutor, Rsm.Dal', -- progid
 0 );
         

insert into core_reference
(referenceid, description, viddoc, readonly, progid, istree)
values
(431, --referenceid
 '����.���_��������� ����',  --description
 4, --viddoc,
 0, -- readonly,
 'Rsm.Dal.KursExecutor, Rsm.Dal', -- progid
 0 );

insert into core_reference
(referenceid, description, viddoc, readonly, progid, istree)
values
(430, --referenceid
 '����.���_��������� ���',  --description
 4, --viddoc,
 0, -- readonly,
 'Rsm.Dal.KursExecutor, Rsm.Dal', -- progid
 0 );

insert into core_reference
(referenceid, description, viddoc, readonly, progid, istree)
values
(429, --referenceid
 '������� ����� �����',  --description
 4, --viddoc,
 0, -- readonly,
 'Rsm.Dal.KursExecutor, Rsm.Dal', -- progid
 0 );
 
 
 insert into core_reference
(referenceid, description, viddoc, readonly, progid, istree)
values
(432, --referenceid
 '���_��� ������� ���',  --description
 4, --viddoc,
 0, -- readonly,
 'Rsm.Dal.KursExecutor, Rsm.Dal', -- progid
 0 );
                                
