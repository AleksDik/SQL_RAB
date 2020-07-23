/*
Список apart_id и building_id из схемы emig  входящие в определенные программы переселения (GROUP_ID = 232 OR GROUP_ID >= 282) 
для представления в KURS3
30.08.2013 Dikan
*/
create or replace view v_relocation_from_emig as
select
ap.apart_id  as reloc_apart_id,
eb.building_id  as reloc_building_id,
eb.program_year  as reloc_program_year,
eg.group_name  as reloc_group_name,
eg.group_id  as reloc_group_id,
cast(eg.group_id as VARCHAR2(10))  as reloc_str_group_id
FROM apartment ap, emig.emig_groups eg
INNER JOIN
emig.emig_building eb
ON eg.modify_user <> 2
AND eg.deleted = 0
AND emig.group_pack.building_is_in_grp2
(eg.group_mask, eb.group_mask) = 1
AND eb.status_build IN (1, 2, 3)
AND (eg.GROUP_ID = 232 OR eg.GROUP_ID >= 282)
WHERE ap.building_id=eb.building_id;
