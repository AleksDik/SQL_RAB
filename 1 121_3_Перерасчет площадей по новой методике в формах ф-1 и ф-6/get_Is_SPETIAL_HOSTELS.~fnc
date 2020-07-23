create or replace function get_Is_SPETIAL_HOSTELS(ap_id in number) return number
as
--      17.02.2016 Dik  проверка unom , unkv  и доп условий по таблице общежитий (SPETIAL_HOSTELS)
--     return = 0  - есть u_nom и u_nkv , нет доп условий
--     return = 1  - нет u_nom
--     return = 2  -нет u_nkv , нет доп условий
--     return = 3  -нет u_nkv ,  дом считать общежитием
--     return = 4  - есть u_nkv ,  дом считать общежитием 
--     return = 5  - есть u_nkv , соответствующая квартира считается общежитием 

  nn NUMBER := 0;
  res  NUMBER := 0;
  u_nom number;
  u_nkv number;
BEGIN 
  u_nkv:=get_BTI_by_apart_1(ap_id,u_nom);
  IF NVL(u_nom,0)=0 THEN
     RETURN (1);
  END IF;
  
IF NVL(u_nkv,0)=0 THEN
   res := 2;
END IF;  

select count(*) into nn from SPETIAL_HOSTELS sh
where sh.unom = u_nom
  and sh.unkv is NULL
  and sh.status = 1; 
if nn > 0 then  -- дом считать общежитием
 if res = 2 then  
   RETURN (3) ;
 else   
   RETURN (4) ; 
 end if;  
END IF;   
 
if res <> 2 then 
  select count(*) into nn from SPETIAL_HOSTELS sh
  where sh.unom = u_nom
    and sh.unkv = u_nkv
    and sh.status = 1; 
  if nn > 0 then  -- соответствующая квартира считается общежитием и не надо производить проверку по схеме bti
    RETURN (5);
  END IF;
end if;

 RETURN(res);
END;
/
