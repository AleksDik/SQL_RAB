select t.*, t.rowid from core_register t
where registerid = 437

select t.*, t.rowid from core_register_attribute t
where  registerid = 437
and id =43602300

select * from core_layout t   -- layoutid = 1105002
where registerid = 437;
 
select * from core_layout_details t
where layoutid = 1105003;


select * from core_reference t;

insert into core_reference
(referenceid, description, viddoc, readonly, progid, istree)
values
(434, --referenceid
 'Жил/Пл Мун округ',  --description
 4, -- viddoc,
 0, -- readonly,
 'Rsm.Dal.KursExecutor, Rsm.Dal', -- progid
 0 );
 
 
 
 
 
