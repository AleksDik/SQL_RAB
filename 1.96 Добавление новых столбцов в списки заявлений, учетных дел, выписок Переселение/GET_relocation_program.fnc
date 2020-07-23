create or replace function GET_relocation_program(p_apart_id in number) return varchar2 is
  v_relocation_program varchar2(150);

--     @avtor Dik (22.08.2013)
--     Функция возвращает список номеров программ переселения ( в строку, через запятую) 
--    

begin
  with A as
(
SELECT
  rfe.reloc_str_group_id
FROM
  v_relocation_from_emig rfe
WHERE
 rfe.reloc_apart_id=  p_apart_id
order by rfe.reloc_group_id asc 
)

select substr(extract(xmlagg(xmlelement("X", ', ' || a.reloc_str_group_id)), 'X/text()').getstringval(),2) reloc_str_group_id
INTO v_relocation_program
from A;
  return(v_relocation_program);
end GET_relocation_program;
/
