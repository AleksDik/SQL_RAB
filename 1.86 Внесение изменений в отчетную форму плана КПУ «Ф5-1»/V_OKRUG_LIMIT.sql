CREATE OR REPLACE VIEW V_OKRUG_LIMIT AS
/* Лимиты по округам для вычисления поля "Выполнение ТЕКУЩЕГО плана в %%" 
  в отчете "План КПУ Ф5-1..." , поле a234 в V_PL_KPU_SUM_O_PR
  26.04.2013 Дикан.
*/
select l.limit_year as limit_year,
       l.okrug_id as okrug_id, 
       l.okrug_limit as okrug_limit, 
       a.short_name1 as okrug_short_name
From (
  select 2013 as limit_year, 51 as okrug_id,  21 as okrug_limit from dual
 union
  select 2013 as limit_year, 52 as okrug_id,  44 as okrug_limit from dual
 union 
  select 2013 as limit_year, 53 as okrug_id,  53 as okrug_limit from dual
 union
  select 2013 as limit_year, 54 as okrug_id,  29 as okrug_limit from dual
union
  select 2013 as limit_year, 55 as okrug_id,  105 as okrug_limit from dual
 union 
  select 2013 as limit_year, 56 as okrug_id,  18 as okrug_limit from dual
 union
  select 2013 as limit_year, 57 as okrug_id,  20 as okrug_limit from dual
 union
  select 2013 as limit_year, 58 as okrug_id,  35 as okrug_limit from dual
union
  select 2013 as limit_year, 59 as okrug_id,  69 as okrug_limit from dual
 union 
  select 2013 as limit_year, 60 as okrug_id,  4 as okrug_limit from dual
 union
  select 2013 as limit_year, 62 as okrug_id,  1 as okrug_limit from dual
 union
  select 2013 as limit_year, 63 as okrug_id,  1 as okrug_limit from dual
) l, area a
where l.okrug_id=a.okrug_id;
--GRANT SELECT ON V_OKRUG_LIMIT TO "PUBLIC";

