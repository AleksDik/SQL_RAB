create or replace function GET_OPD_QUEUE(p_affair_id in number) return varchar2 is
  OPD varchar2(100);

--     @avtor ONovikova
--     Функция возвращает все номера в списке обеспечения (ОПД) по плану КПУ для выбранного учетного дела
--	   08.02.2013 Создание
--     #06032013Dik добавил условие - текущий плановый год в affair_plan = значению параметра AFFAIR_PLAN_YEAR из GLOBAL_PARAMETERS 
--
begin
  with A as
(select distinct B.opd from  
(select ap.opd,
        ap.affair_id,
        ap.family_num --   #06032013Dik
  from affair_plan ap
  join affair af on af.affair_id = ap.affair_id
                and af.affair_stage = ap.affair_stage,
       GLOBAL_PARAMETERS gp         
 where ap.archive = 0
   and ap.status is not null
   and ap.opd is not null
   and ap.affair_id = p_affair_id
   --   #06032013Dik
   and gp.parameter_name='AFFAIR_PLAN_YEAR'
   and NVL(gp.num_value,-1)=ap.PLAN_YEAR
   order by ap.family_num
   -- / #06032013Dik
 ) B )

select substr(extract(xmlagg(xmlelement("X", ', ' || a.opd)), 'X/text()').getstringval(),2) opd
INTO OPD
from A;
  return(OPD);
end GET_OPD_QUEUE;
/
