select a.*, a.rowid from core_register a
where a.registerid in  (1150,1151,1152,1153,1650,1651,1653)
order by a.registerid ;


select a.*, a.rowid from core_register_attribute a
where a.registerid=  1150
order by a.id; 
select a.*, a.rowid from core_register_attribute a
where a.registerid=  1151
order by a.id; 
select a.*, a.rowid from core_register_attribute a
where a.registerid=  1152
order by a.id; 
select a.*, a.rowid from core_register_attribute a
where a.registerid=  1153
order by a.id; 

select a.*, a.rowid from core_register_attribute a
where a.registerid=  1650
order by a.id; 
select a.*, a.rowid from core_register_attribute a
where a.registerid=  1651
order by a.id; 
select a.*, a.rowid from core_register_attribute a
where a.registerid=  1653
order by a.id; 
