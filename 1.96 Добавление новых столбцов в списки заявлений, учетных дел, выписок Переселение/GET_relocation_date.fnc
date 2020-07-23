create or replace function GET_relocation_date(p_apart_id in number) return NUMBER is
  v_date NUMBER := NULL;

--     @avtor Dik (22.08.2013)
--     Функция возвращает Год программы переселения 
--    

begin

SELECT
  rfe.reloc_program_year into v_date
FROM
  v_relocation_from_emig rfe
WHERE
 rfe.reloc_apart_id=  p_apart_id
 and rownum = 1;
 
RETURN (v_date);

EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN(NULL);
      
end GET_relocation_date;

