create or replace function GET_PLAN_TYPE_QUEUE(p_affair_id in number) return varchar2 is
  vPLAN_TYPE_TITLE varchar2(250):='';

--     @avtor Дикан
--     Функция возвращает все виды плана (классификатор 101) по плану КПУ для выбранного учетного дела
--	   06.03.2013 Создание
--     #19032013Dik убрал уникальность
begin
  with A as
-- #19032013Dik 
--(select distinct B.sPLAN_TYPE_TITLE from   
(select cl.SHORT_NAME2 as sPLAN_TYPE_TITLE,
        ap.affair_id,
        ap.family_num
  from affair_plan ap
  join affair af on af.affair_id = ap.affair_id
                and af.affair_stage = ap.affair_stage,
       CLassifier_kurs3 cl         
 where ap.archive = 0
   and ap.affair_id = p_affair_id
   and cl.ROW_NUM = ap.plan_type
   and cl.CLASSIFIER_NUM=101
 order by ap.family_num   
 ) 
 --B  )

select substr(extract(xmlagg(xmlelement("X", ', ' || a.sPLAN_TYPE_TITLE)), 'X/text()').getstringval(),2) opd
INTO vPLAN_TYPE_TITLE
from A;
  return(vPLAN_TYPE_TITLE);
end GET_PLAN_TYPE_QUEUE;
/
