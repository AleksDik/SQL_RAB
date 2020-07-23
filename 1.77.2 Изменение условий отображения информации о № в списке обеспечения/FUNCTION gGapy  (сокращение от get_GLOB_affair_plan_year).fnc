CREATE OR REPLACE FUNCTION gGapy  -- сокращение от get_GLOB_affair_plan_year
   RETURN NUMBER
AS
   -- Функция возвращает AFFAIR_PLAN_YEAR из GLOBAL_PARAMETERS
   -- для подстановки в условие отбора списка "План КПУ"  
   -- 06.03.2013 Дикан
   n NUMBER:=0;
BEGIN
   select distinct NVL(num_value,0) into n from GLOBAL_PARAMETERS where parameter_name='AFFAIR_PLAN_YEAR';
   RETURN n;
 EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RETURN 0;
END;


 
/
