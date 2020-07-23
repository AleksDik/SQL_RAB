CREATE OR REPLACE FUNCTION gGapy  -- ���������� �� get_GLOB_affair_plan_year
   RETURN NUMBER
AS
   -- ������� ���������� AFFAIR_PLAN_YEAR �� GLOBAL_PARAMETERS
   -- ��� ����������� � ������� ������ ������ "���� ���"  
   -- 06.03.2013 �����
   n NUMBER:=0;
BEGIN
   select distinct NVL(num_value,0) into n from GLOBAL_PARAMETERS where parameter_name='AFFAIR_PLAN_YEAR';
   RETURN n;
 EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RETURN 0;
END;


 
/
