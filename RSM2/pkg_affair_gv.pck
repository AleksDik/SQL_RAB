create or replace package pkg_affair_gv is

  -- Author  : DIKAN
  -- Created : 13.03.2019 11:56:27
  -- Purpose : Адаптация функций , процедур схемы KURS3 к схеме genix_view

  -- Public type declarations
 -- type <TypeName> is <Datatype>;

  -- Public constant declarations
 -- <ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
 -- <VariableName> <Datatype>;

  -- Public function and procedure declarations
procedure GET_AFF_AP_SPACE (p_affair in NUMBER, p_affair_stage in NUMBER, CUR_AFF_AP_SPACE out SYS_REFCURSOR ) ;



 /*
  о занимаемой площади
*/
PROCEDURE get_room_delo (p_affair_id NUMBER, p_stage NUMBER, a_rooms IN OUT  dbo.TRecordSet);


----------------------------------------------------------------------------------------------------------
-- Автор  : ilonis
-- Описание :    получить список всех кпу по квартире 
-- Параметры:                                                                                                  
--      Входные:            
--      Выходные:              
procedure  get_affair_data(  p_affair_id number, p_affair_stage number, p_data in out SYS_REFCURSOR  ) ;

----------------------------------------------------------------------------------------------------------
-- Автор  : ilonis
-- Описание :    люди по квартире 
-- Параметры:                                                                                                  
--      Входные:       GET_PERSONS_APART     
--      Выходные:        
procedure  get_persons_apart(   p_affair_id number, p_affair_stage number,  p_data in out SYS_REFCURSOR );  


--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Описание : данные из реестра договоров по квартире
    -- Параметры:  GET_RDN_REESTR                                                                                              
  -- Входные:            
  -- Выходные:              
procedure get_rdn_reestr(   p_affair_id number, p_affair_stage number,  p_data in out SYS_REFCURSOR ) ;


--------------------------------------------------------------------------------------------------------
--    --ilonis 
--    права по квартире
--    входные параметры:
--    выходные параметры:
procedure   get_rights(    p_affair_id number, p_affair_stage number,  p_data in out SYS_REFCURSOR   ) ; 


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Описание :   список комнат в квартире
    -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:              
procedure  get_room_bti(  p_affair_id number, p_affair_stage number ,  p_data in out SYS_REFCURSOR   );

---------------------------------------------------------------------------------------------------------
 --ilonis 
-- Описание :   паспортные данные людей в кпу
--    входные параметры:
--    выходные параметры:
procedure  get_person_data( p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ) ;


---------------------------------------------------------------------------------------------------------
-- ilonis
-- Описание :    незаселенка
--    входные параметры:
--    выходные параметры:
procedure  get_free_space(   p_affair_id number, p_affair_stage number ,  p_data in out SYS_REFCURSOR    );



---------------------------------------------------------------------------------------------------------
 --ilonis 
-- Описание :   льготы
--    входные параметры:
--    выходные параметры:
procedure  get_category( p_affair_id number, p_affair_stage number ,  p_data in out SYS_REFCURSOR   );

----------------------------------------------------------------------------------------------------------
--ilonis
--    субсидии
--    входные параметры:
--    выходные параметры:
procedure  get_subsid(    p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ) ;

---------------------------------------------------------------------------------------------------------
--ilonis
-- Описание :   уведомления о предложении жил.площади
--    входные параметры:
--    выходные параметры:
procedure  get_notific_data( p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ) ;

--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Описание : выписки по КПУ
  -- Входные:             GET_ORDER  
  -- Выходные:              
  --выводить только не аннулированнные выписки              
procedure  get_order( p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ) ;

-- Автор  : Dik
-- Описание : данные о человеке в КПУ
procedure  get_person_affair(p_affair_id number, p_person_id number, p_affair_stage number,  cur_person_affair in out SYS_REFCURSOR);
 
 
--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Описание : заявления на гор. программу
    -- Параметры:                                                                                               
  -- Входные:            
  -- Выходные:              
procedure  get_declaration_data( p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ); 

-- Автор  : Dik
--  Процедура получения привелегий текущего пользователя по субвенциям
procedure get_user_privs_forSubv(p_user_id in number, p_cur in out  SYS_REFCURSOR );
-- Автор  : Dik
--  Процедура получения субвенции по КПУ для интерфейса
procedure get_subvention(p_affair_id IN number, p_cur in out SYS_REFCURSOR);
--  Получить людей в КПУ с доп. инф. из субвенции по ним для интерфейса
procedure get_subvention_persons(p_affair_id IN number, p_cur in out  SYS_REFCURSOR);
--  Получить льготы людей в КПУ с доп. инф. для интерфейса субвенции
procedure get_subvention_persons_atr(p_person_id IN number, p_cur in out SYS_REFCURSOR);
--  Получить ордера в КПУ для интерфейса субвенции
procedure get_subvention_orders(p_affair_id IN number,p_subv_id in number, p_cur in out  SYS_REFCURSOR);
-- Сводная информация по субвенции
procedure get_subventionAllRef(p_subv_id in number,p_cur in out SYS_REFCURSOR);




end pkg_affair_gv;
/
create or replace package body pkg_affair_gv is


procedure GET_AFF_AP_SPACE ( p_affair in NUMBER, p_affair_stage in NUMBER, CUR_AFF_AP_SPACE out SYS_REFCURSOR ) 
AS
  p_sqo  number := 0;   --  общая квартиры  Apartment.total_space
  p_liv_sq  number := 0; --  жилая квартиры Apartment.Living_space  
  p_kh   number := 0;   --  кухни квартиры   Apartment.KITCHEN_SPACE
  p_sqb  number := 0;  --  общая без летних квартиры  Apartment.TOTAL_SPACE_WO  (get_BTI_TOTAL_SPACE(:ap_id))
  p_sqz  number := 0;  --  общая занимаемая
  p_sqL  number := 0;  --  общая без летних занимаемая
  p_sqi  number := 0; --  жилая занимаемая
  p_str  varchar2(150) := '';   -- сообщение из c_ErrStr
  p_apart_id  NUMBER := 0;
  err_num integer  := 0;   
begin
 
 begin  
  select a.apart_id into p_apart_id  
  from KURS3.AFFAIR a
  where a.AFFAIR_ID = p_affair
       and a.AFFAIR_STAGE = p_affair_stage;
 exception
  WHEN OTHERS THEN
      return;      
 end;      
err_num := KURS3.GET_AFF_SPACE (p_apart_id, p_affair,  p_affair_stage,
                                   p_sqo ,
                                   p_liv_sq , 
                                   p_kh ,
                                   p_sqb ,
                                   p_sqz ,
                                   p_sqL ,
                                   p_sqi ,
                                   p_str );
    
OPEN CUR_AFF_AP_SPACE FOR 
/*
select 
p_kh as KITCHEN_SQ,
p_liv_sq as LIV_SQ,
p_sqi as SQI,
p_sqL as SQL,
p_sqo as SQO,
p_sqz as SQZ,
p_str as ERR_STR
From dual;
*/   

select     
  AFFAIR_ID,
  AFFAIR_NUM,
  AFFAIR_STAGE,
  APART_ID,
  BUILD_ID,
  CALC_TYPE,
  CATEGORY,
  COMFORTABLE,
  COMFORTABLE_ID,
  CONDITION,
  COTTAGE,
  CR_DATE,
  FLOOR,
  GOOD,
  GOOD_ID,
  DECODE(NVL(KITCHEN_SQ,0),0,p_kh,KITCHEN_SQ)  as KITCHEN_SQ,--  кухни квартиры   Apartment.KITCHEN_SPACE
  LAST_CHANGE,
  DECODE(NVL(LIV_SQ,0),0,p_liv_sq,LIV_SQ) as LIV_SQ, --  жилая квартиры Apartment.Living_spac
  MAINT,
  MORE_FAMILY,
  OCCUPY_NUM,
  OKRUG_ID,
  REASON,
  ROOM_COUNT,
  DECODE(NVL(SQB,0),0,p_sqb,SQB) as SQB, --  общая без летних квартиры 
  p_sqi as SQI,
  p_sqL as SQL, --?
  DECODE(NVL(SQO,0),0,p_sqo,SQO) as SQO,--  общая квартиры  Apartment.total_space
  p_sqz as SQZ,--  общая занимаемая
  SQ_TYPE,
  SQ_TYPE_N,
  SSTATUS,
  (select t.name from KURS3.CLASSIFIER t where t.classifier_num = 34 and t.row_num = SSTATUS) as SSTATUS_S,
  STATUS_BTI,
  S_GROUP,
  TOILET,
  TOILET_ID,
  TYPE3,
  YEAR_IN_CITY,
  YEAR_IN_PLACE,
  p_str as ERR_STR       
FROM KURS3.V_AFFAIR_ANNOUN
WHERE
 AFFAIR_ID = p_affair
 and
 APART_ID = Decode(p_apart_id,0,APART_ID,p_apart_id)
 and
 AFFAIR_STAGE = p_affair_stage;
  
end GET_AFF_AP_SPACE;


 /*
 о занимаемой площади
*/
 PROCEDURE get_room_delo (p_affair_id NUMBER, p_stage NUMBER, a_rooms IN OUT  dbo.TRecordSet)
 AS
BEGIN
 
        PKG_K3.get_room_delo (p_affair_id, p_stage, a_rooms);
     
END get_room_delo;


----------------------------------------------------------------------------------------------------------
-- Автор  : ilonis
-- Описание :    получить список всех кпу по квартире 
-- Параметры:                                                                                                  
--      Входные:            
--      Выходные:              
procedure  get_affair_data(  p_affair_id number, p_affair_stage number, p_data in out SYS_REFCURSOR  ) 
as
begin

    p_data:=  KURS3.PKG_AFFAIR.get_affair_data(  p_affair_id, p_affair_stage   ); 
 
end get_affair_data;


----------------------------------------------------------------------------------------------------------
-- Автор  : ilonis
-- Описание :    люди по квартире 
-- Параметры:                                                                                                  
--      Входные:       GET_PERSONS_APART     
--      Выходные:        
procedure  get_persons_apart(   p_affair_id number, p_affair_stage number,  p_data in out SYS_REFCURSOR   )
as 
begin

    p_data:= KURS3.PKG_AFFAIR.get_persons_apart(   p_affair_id , p_affair_stage    ) ;
    
end get_persons_apart;


--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Описание : данные из реестра договоров по квартире
    -- Параметры:  GET_RDN_REESTR                                                                                              
  -- Входные:            
  -- Выходные:              
procedure get_rdn_reestr(   p_affair_id number, p_affair_stage number,  p_data in out SYS_REFCURSOR ) 
as
begin
    p_data:= KURS3.PKG_AFFAIR.get_rdn_reestr(   p_affair_id , p_affair_stage    ) ;
end;


--------------------------------------------------------------------------------------------------------
--    --ilonis 02.04.2018
--    права по квартире
--    входные параметры:
--    выходные параметры:
procedure   get_rights(    p_affair_id number, p_affair_stage number,  p_data in out SYS_REFCURSOR   )  
as
begin

 p_data:= KURS3.PKG_AFFAIR.get_rights(   p_affair_id , p_affair_stage    ) ;

end get_rights;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Описание :   список комнат в квартире
    -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:              
procedure  get_room_bti(  p_affair_id number, p_affair_stage number ,  p_data in out SYS_REFCURSOR   )
as
begin

    p_data:= KURS3.PKG_AFFAIR.get_room_bti(   p_affair_id , p_affair_stage    ) ;

end get_room_bti;



---------------------------------------------------------------------------------------------------------
 --ilonis 
-- Описание :   паспортные данные людей в кпу
--    входные параметры:
--    выходные параметры:
procedure  get_person_data( p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ) 
as
begin

    p_data:= KURS3.PKG_AFFAIR.get_person_data(   p_affair_id , p_affair_stage    ) ;

end get_person_data ;


---------------------------------------------------------------------------------------------------------
-- ilonis
-- Описание :    незаселенка
--    входные параметры:
--    выходные параметры:
procedure  get_free_space(   p_affair_id number, p_affair_stage number ,  p_data in out SYS_REFCURSOR    ) 
as
begin

  p_data:= KURS3.PKG_AFFAIR.get_free_space(   p_affair_id , p_affair_stage    ) ;
  
end;


---------------------------------------------------------------------------------------------------------
 --ilonis 
-- Описание :   льготы
--    входные параметры:
--    выходные параметры:
procedure  get_category( p_affair_id number, p_affair_stage number ,  p_data in out SYS_REFCURSOR   ) 
as
begin

  p_data:= KURS3.PKG_AFFAIR.get_category(   p_affair_id , p_affair_stage    ) ;

end;

----------------------------------------------------------------------------------------------------------
--ilonis
--    субсидии
--    входные параметры:
--    выходные параметры:
procedure  get_subsid(    p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ) 
as
begin

  p_data:= KURS3.PKG_AFFAIR.get_subsid(   p_affair_id , p_affair_stage    ) ;
  
end get_subsid ;


 
---------------------------------------------------------------------------------------------------------
--ilonis
-- Описание :   уведомления о предложении жил.площади
--    входные параметры:
--    выходные параметры:
procedure  get_notific_data( p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ) 
as
begin

  p_data:= KURS3.PKG_AFFAIR.get_notific_data(   p_affair_id , p_affair_stage    ) ;
  
end get_notific_data ;


--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Описание : выписки по КПУ
    -- Параметры:  GET_ORDER                                                                                              
  -- Входные:            
  -- Выходные:              
  --выводить только не аннулированнные выписки              
procedure  get_order( p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ) 
as
begin

  p_data:= KURS3.PKG_AFFAIR.get_order(   p_affair_id , p_affair_stage    ) ;
  
end get_order ;

-- Автор  : Dik
-- Описание : данные о человеке в КПУ
procedure  get_person_affair(p_affair_id number, p_person_id number, p_affair_stage number,  cur_person_affair in out SYS_REFCURSOR) 
as
begin

 open cur_person_affair for 
  select v.*
  ,(SELECT LOWER(NAME) FROM KURS3.V_PASSPORT where ID = v.doc_type ) as DOC_TYPE_STR
  ,( select vp.name from KURS3.v_person_reg vp where vp.ID= v.REG_PERSON) as REG_PERSON_STR
 , ( select vp.name from KURS3.v_person_owner vp where vp.ID= v.OWNERS) as OWNERS_STR      
       
  from KURS3.V_PERSON_AFFAIR_3 v 
  where 
      v.AFFAIR_ID = p_affair_id
  and v.AFFAIR_STAGE = p_affair_stage       
  and v.person_id = p_person_id ;
  
    
end get_person_affair ;


--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Описание : заявления на гор. программу
    -- Параметры:                                                                                               
  -- Входные:            
  -- Выходные:              
procedure  get_declaration_data( p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ) 
as
begin

  p_data:= KURS3.PKG_AFFAIR.get_declaration_data(   p_affair_id , p_affair_stage    ) ;
  
end get_declaration_data ;

-- Автор  : Dik
--  Процедура получения привелегий текущего пользователя по субвенциям
procedure get_user_privs_forSubv(p_user_id in number, p_cur in out  SYS_REFCURSOR )
as
 l_user_id number;
 s varchar2(500) := NULL;
begin
 l_user_id := p_user_id;  
 s:= pkg_rsm2.Set_Global_Var( l_user_id );
 kurs3.pkg_subvention.get_user_privs_forSubv(p_cur);
end get_user_privs_forSubv;

-- Автор  : Dik
--  Процедура получения субвенции по КПУ для интерфейса
procedure get_subvention(p_affair_id IN number, p_cur in out SYS_REFCURSOR)
 as
 begin
   kurs3.pkg_subvention.get_subvention(p_affair_id, p_cur);
 end get_subvention;
 
--  Получить людей в КПУ с доп. инф. из субвенции по ним для интерфейса
procedure get_subvention_persons(p_affair_id IN number, p_cur in out  SYS_REFCURSOR)  
 as
 begin
   kurs3.pkg_subvention.get_subvention_persons(p_affair_id, p_cur);
 end get_subvention_persons;
 
 --  Получить льготы людей в КПУ с доп. инф. для интерфейса
procedure get_subvention_persons_atr(p_person_id IN number, p_cur in out SYS_REFCURSOR)
 as
 begin
   kurs3.pkg_subvention.get_subvention_persons_atr(p_person_id, p_cur);
 end get_subvention_persons_atr;  
 
--  Получить ордера в КПУ для интерфейса субвенции
procedure get_subvention_orders(p_affair_id IN number,p_subv_id in number, p_cur in out  SYS_REFCURSOR)
 as
 begin
   kurs3.pkg_subvention.get_subvention_orders(p_affair_id, p_subv_id, p_cur);
 end get_subvention_orders;  
 
 -- Сводная информация по субвенции
procedure get_subventionAllRef(p_subv_id in number,p_cur in out SYS_REFCURSOR)
 as
 begin
   kurs3.pkg_subvention.get_subventionAllRef( p_subv_id, p_cur);
 end get_subventionAllRef;  
 
 
end pkg_affair_gv;
/
