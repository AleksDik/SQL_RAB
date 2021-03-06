create or replace function GET_PLAN_YEARS(p_affair_id in number) return varchar2 is
  tpg varchar2(100);

--     @avtor ONovikova
--     ������� ���������� ��� �������� ���� �� ����� ��� ��� ���������� �������� ����
--	   08.02.2013 ��������
--      --#06032013Dik ������� ����������
--       #19032013Dik ����� ������������

begin
  with A as
-- #19032013Dik
  --   (select distinct B.plan_year FROM  
(select  ap.plan_year,
         ap.affair_id,
         ap.family_num --#06032013Dik
  from affair_plan ap
  join affair af on af.affair_id = ap.affair_id
                and af.affair_stage = ap.affair_stage
 where ap.archive = 0
   and ap.status is not null
   and ap.plan_year is not null
   and ap.affair_id = p_affair_id
 order by ap.family_num   --#06032013Dik
  )
  --B  )

select substr(extract(xmlagg(xmlelement("X", ', ' || a.plan_year)), 'X/text()').getstringval(),2) TPG
INTO tpg
from A;


  return(tpg);
end GET_PLAN_YEARS;
/
