create or replace function GET_AFFAIR_PLAN_STATUS(p_affair_id in number) return varchar2 is
  Status varchar2(150);

--     @avtor ONovikova
--     Функция возвращает все статусы по плану КПУ для выбранного учетного дела
--	   08.02.2013 Создание
--     #06032013Dik исключить статус "Без плана" 
--     #19032013Dik убрал уникальность состояния
--

begin
  with A as
--(select distinct B.Status from   --     #19032013Dik 
(
select v.name  as Status,
        ap.affair_id,
        ap.family_num  --#06032013Dik
  from affair_plan ap
  join affair af on af.affair_id = ap.affair_id
                and af.affair_stage = ap.affair_stage
  join V_AFFAIR_PLAN_STATUS v on ap.Status = v.ID
 where ap.archive = 0
   and ap.Status is not null
   and ap.Status <> 8 --#06032013Dik
   and ap.affair_id = p_affair_id
 order by ap.family_num  --#06032013Dik
 --) B   --     #19032013Dik 
)

select substr(extract(xmlagg(xmlelement("X", ', ' || a.Status)), 'X/text()').getstringval(),2) Status
INTO Status
from A;
  return(Status);
end GET_AFFAIR_PLAN_STATUS;
/
