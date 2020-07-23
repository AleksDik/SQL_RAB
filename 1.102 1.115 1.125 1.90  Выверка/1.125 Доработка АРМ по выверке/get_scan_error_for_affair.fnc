create or replace function get_scan_error_for_affair(p_affair_id in scan.ea_delo_attr.object_rel_id%Type, p_mode in number := 0) return integer is
/* Вернуть статусы выверки (Электронного архива) по заданному ID КПУ

p_mode - определяет кол-во выходных статусов КПУ: 
0 - три статуса, 
статусы : 1 - Пусто (выверки нет);
          2 - Есть (ошибок нет)
          3 - Есть с замечаниями  (есть ошибки)
1 - два статуса: 
    1 - Пусто (выверки нет); 
    2 - Есть             
22.01.2013 Дикан А.
*/          
  Result integer;
  v_delo_id scan.ea_delo_attr.delo_id%Type;
begin
  
Result := 1; -- пусто
v_delo_id := -1; -- init  

-- найти код дела по ID КПУ --
select max(a.delo_id) into v_delo_id   
from scan.ea_delo_attr a
where a.object_type_id in (1,7,12)   --  тип - affair (по таблице scan.ea_object_type )
and   a.object_rel_id= p_affair_id
and   NVL(a.row_status,0) <>0;

if NVL(v_delo_id,-1) < 0 then --выверки нет
   return(Result);
end if ; 

-- есть выверка (дело) по заданной КПУ (p_affair_id)
 if p_mode > 0 then --режим два статуса
   Result := 2;
   return(Result); --все
end if ; 

--режим три статуса
-- получить кол-во ошибок в деле
select count(d.label_type_id) into Result 
from scan.ea_delo_label d 
where d.delo_id= v_delo_id;

if Result>0 
   then  Result := 3; -- есть ошибки
   else  Result := 2; -- нет ошибок
end if;

  
 return(Result); 
end get_scan_error_for_affair;
/
