create or replace view v_fias_socrbase_link as
Select 
    shortname,
    aolevel,
    scname,
    kod_t_st
from (
select  t1.shortname,t1.aolevel,t2.scname, To_NUMBER(t2.k) as kod_t_st from  
 ( select  t.shortname, t.aolevel from fias_addrob77 t 
  group by t.shortname, t.aolevel) t1
  join
   (select f.scname, f.aolevel, max(f.kod_t_st) as k from fias_socrbase f 
  group by  f.scname, f.aolevel) t2
  on  t1.aolevel=t2.aolevel  
  and t1.aolevel in (1,3,4,6,65,7)
  and 
   REGEXP_LIKE(t2.scname, '^('||t1.shortname||')[.]{0,1}$')
) tcut
where not exists 
(
  select * from (
    select 1 as aolevel,
           103 as kod_t_st
    from dual
    union
    select 4 as aolevel,
           401 as kod_t_st
    from dual
    union
    select 6 as aolevel,
           624 as kod_t_st
    from dual
    union
    select 65 as aolevel,
           6582 as kod_t_st
    from dual
    union
    select 65 as aolevel,
           6586 as kod_t_st
    from dual
    union
    select 7 as aolevel,
           711 as kod_t_st
    from dual
    union
    select 7 as aolevel,
           714 as kod_t_st
    from dual
    union
    select 7 as aolevel,
           729 as kod_t_st
    from dual
    union
    select 7 as aolevel,
           731 as kod_t_st
    from dual
  ) ex where ex.aolevel = tcut.aolevel and ex.kod_t_st= tcut.kod_t_st
)
order by shortname,kod_t_st
;
