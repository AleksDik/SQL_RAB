create or replace function Get_family_structure(p_affair_id in affair.affair_id%Type, p_stage in affair.affair_stage%Type) return integer is
/* Вернуть атрибут «Состав семьи» по заданному ID КПУ и affair_stage

11.06.2013 Дикан А.
*/
  Result integer := 0;
  v_REG_PERSON_col number := 0;
  i number := 0;
  
begin

-- найти Кол-во строк зарегистрировано на данной площади --
select count(*) into v_REG_PERSON_col from PERSON_RELATION_DELO prd
where prd.affair_id=p_affair_id
  and prd.affair_stage = p_stage
  and prd.reg_person =1;

-- проверить Родственные отношения (RELATION)
case  
    when ((v_REG_PERSON_col= 0) or (v_REG_PERSON_col=1))  then  Result  := v_REG_PERSON_col;
    when v_REG_PERSON_col=2 then 
         select count(*) into i from PERSON_RELATION_DELO prd
         where prd.affair_id=p_affair_id
          and prd.affair_stage = p_stage
          and prd.relation in(2,6,10,14,18,22,26,30) 
          and prd.reg_person =1;
      if i > 0
       then  Result  := 2; 
       else  Result  := 3;
      end if;                
    when v_REG_PERSON_col=3 then 
        select count(*) into i from PERSON_RELATION_DELO prd
         where prd.affair_id=p_affair_id
          and prd.affair_stage = p_stage
          and prd.relation in(2,6,10,14,18,22,26,30) 
          and prd.reg_person =1;
      if i > 0
       then  Result  := 4; 
       else  Result  := 5;
      end if;                      
    else  Result:=6;
end case;       

 return(Result);
end Get_family_structure;
/
