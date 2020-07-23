create or replace package PKG_RSM2
is
--ilonis
-- пакет для работы по иНтеграции рсм2 и курс3 
 
-- Описания пакетных переменных
TYPE curstype IS REF CURSOR;  


 -----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
 function Set_Global_Var( id_user number ) return varchar2;

----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Дата создания : 
  -- Описание :     удаление члена семьи из дела или заявления
  -- Параметры:
  -- Входные:
  -- Выходные:
  function DelPersonFromDelo(p_Person_Id NUMBER, p_Affair_Id NUMBER, p_Affair_Stage NUMBER:=0,
            p_DelReason_id number := NULL, p_ReasonDoc_num varchar2 := NULL, p_ReasonDoc_date DATE := NULL )  return varchar2;


 
  ----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Дата создания :
  -- Описание :     процедура  создания состава семьи в деле
  -- Параметры:
  -- Входные:
  -- Выходные:
function CreateUpdatePerson(
                               Affair_Id_        NUMBER,
                               Affair_Stage_     NUMBER,
                               Rnum_             NUMBER,
                               Person_Id_        NUMBER,
                               Last_Name_        CHAR,
                               First_Name_       CHAR,
                               Birthday_         DATE,
                               Persex_           CHAR,
                               Relation_Cod_     NUMBER,
                               Doc_Type_         NUMBER,
                               Doc_Series_       CHAR,
                               Doc_Num_          CHAR,
                               Date_Enter_       DATE,
                               How_Giving_       CHAR,
                               Family_Num_       NUMBER,
                               Master_           NUMBER,
                               Sq_Type_          NUMBER,
                               Patronymic_       CHAR,
                               Pat_              CHAR,
                               Person_Category_  VARCHAR2,
                               Person_Subsidy_   CHAR,
                               Person_Category_1 VARCHAR2,
                               Person_Category_2 VARCHAR2,
                               Category_Date     DATE,
                               Category_Year     NUMBER,
                               Category_1_Date   DATE,
                               Category_1_Year   NUMBER,
                               Category_2_Date   DATE,
                               Category_2_Year   NUMBER,
                               Year_In_City      NUMBER,
                               Year_In_Place     NUMBER,
                               Reg_Person        NUMBER,
                               Owners            NUMBER := NULL,
                               Addr_Reg_         VARCHAR2,
                               Tenant_           NUMBER,
                               v_City            VARCHAR2,
                               v_Okrug           VARCHAR2,
                               v_Street          VARCHAR2,
                               v_Build_Num       VARCHAR2,
                               v_Korp_Num        VARCHAR2,
                               v_Apart_Num       VARCHAR2,
                               v_tel_home          VARCHAR2
                                ,v_tel_work          VARCHAR2
                                ,v_tel_mob           VARCHAR2
                                ,v_e_mail            VARCHAR2 
                               ,v_add_liv_sp_sz     VARCHAR2 := NULL
                               ,v_add_liv_sp_type  VARCHAR2 := NULL
                               ,v_add_liv_sp_comm   VARCHAR2 := NULL
                               ,v_AF_F_RELATION     NUMBER := NULL
                               ,v_ADD_REG_SPACE_ID  NUMBER := 0      
                              , birth_place          VARCHAR2) return varchar2;
                               
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
 function Create_Apartment(  p_unom  NUMBER, p_unkv NUMBER ) return varchar2;
 
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CreateDeclaration(   p_unom number, p_unkv number, p_apart_num varchar2, p_Decl_Date varchar2,
                                            p_Group_Id number,
                                            p_Delo_Category_Id number,
                                            p_Type2_Id number,
                                            p_Year_In_City number,
                                            p_Year_In_Place number,
                                            p_Reason number,
                                            p_affair_id in out number)     return varchar2;
  
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
    function UpdateDeclaration( p_user_id NUMBER, p_json varchar2)     return varchar2;
    
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
   function CreatePerson( p_user_id NUMBER, p_affair_id number, p_json varchar2)     return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
   function Update_person( p_user_id NUMBER, p_affair_id NUMBER, p_person_id NUMBER, p_json varchar2)     return varchar2;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CreatePasportdata( p_user_id NUMBER, p_json varchar2)     return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Update_Pasport_data( p_user_id NUMBER, p_person_id NUMBER , p_json varchar2)     return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Update_Privilege_Document( p_user_id NUMBER, p_person_id NUMBER , p_json varchar2)     return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Update_ApartmentRooms( p_user_id NUMBER, p_affair_id NUMBER , p_json varchar2)     return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Update_Person_Relation_Data( p_user_id NUMBER, p_person_id NUMBER , p_json varchar2)   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateStageDeclaration(  p_affair_id NUMBER, p_doc_date varchar2, p_doc_num varchar2 )   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     аннулирование заявления
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelDeclaration(  p_affair_id NUMBER )   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateDeclDate( p_user_id NUMBER, p_affair_id NUMBER , p_json varchar2)   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateAffairActualDate( p_user_id NUMBER, p_affair_id NUMBER , p_json varchar2)   return varchar2;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateAffairCategory( p_user_id NUMBER, p_affair_id NUMBER , p_json varchar2)   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateAffairGroup ( p_user_id NUMBER, p_affair_id NUMBER , p_json varchar2)   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateAffairVidType ( p_user_id NUMBER, p_affair_id NUMBER , p_json varchar2)   return varchar2;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelAffair(  p_affair_id NUMBER, p_doc_date varchar2, p_doc_num varchar2, p_reason number )   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CreateOrder( p_user_id NUMBER, p_json varchar2)   return varchar2;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :   издание проекта выписки  и оформление выписки  
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CreateOrderRelease ( p_order_id number, p_doc_date varchar2:=null, p_doc_num varchar2:=null, 
                                                                            p_doc_Type number:=null, p_s_calac number:=null  )   return varchar2;

 
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :   анулирование издаого проекта выписеиЮ выписки  
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelOrder(  p_order_id number, p_docDate varchar2:=null, p_docNom varchar2:=null, p_reason number:=null )   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Create_Certificate ( p_user_id NUMBER,   p_json varchar2)   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Update_Certificate_Release ( p_user_id NUMBER,   p_json varchar2)   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Cancel_Certificate ( p_user_id NUMBER,   p_json varchar2)   return varchar2;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CreateUpdateInstruction(  
                                         p_free_space_id number
                                        ,p_instruction_date varchar2
                                        ,p_department_to varchar2
                                        ,p_num_in_department_to varchar2
                                        ,p_target number
                                        ,p_direction number
                                        ,p_year number 
                                        ,p_s_delivery number
                                        ,p_s_calculation number
                                        ,p_fund number
                                        ,p_basis varchar2
                                        ,p_addenum varchar2)   return varchar2;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateInstructionRelease ( p_instruction_id number, p_instruction_date date )   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelInstruction (  p_instruction_id number )   return varchar2;
 



-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 

function UpdateSubsid(p_user_id NUMBER,  p_subs_id  NUMBER, p_json varchar2)   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateCompensation (p_user_id NUMBER,  p_subs_id  NUMBER, p_json varchar2)   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function SetSubvention ( p_user_id NUMBER,   p_affair_id NUMBER , p_json varchar2)   return varchar2;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : Dik
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelSubvention ( p_user_id NUMBER,   p_subv_id NUMBER )   return varchar2;



----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Дата создания :
  -- Описание :     создание и аннулирование. гор программы
  -- Входные:
  -- Выходные:
function CreateUpdateGorProg(   p_id_dcr  in out  number,
                                                p_action number,
                                                p_affair_id        number,
                                                p_dос_num        varchar2,
                                                p_doc_date         varchar2,
                                                p_doc_type         number,    
                                                p_doc_notes          varchar2,
                                                p_z_type           number,
                                                p_z_date           varchar2,
                                                p_z_status         number,
                                                p_z_notes          varchar2,
                                                p_cancel_date      varchar2,
                                                p_cancel_reason    number,          
                                                p_z_cp_num_id    number,   
                                                p_z_rd_number varchar2,
                                                p_z_rd_date   varchar2
                                                  ) return varchar2;
-----------------------------------------------------------------------------------------------------------------------------  
  -- Автор  : Dik
  -- Описание : Проверяет возможность работы с Субсидийным делом     
  -- Параметры:
  --    Входные: ID и stage КПУ (affair), p_f_num - номер элементарной семьи
  --    Выходные: 
   /*     {
  "ResultType": 0 -все хорошо 1-ошибка,
  "ResultMessage": Наименование вида обеспечения (Cубсидия / Денежная компенсация МД) или (ResultId=0) сообщение пользователю
   "ErrMessage": "Текст ошибки тех.",
  "ResultId":  Код вида обеспечения (22 - субсидия;  39 - Денежная компенсация МД ; 0 -вид обеспечения не субсидия)
  }  */  
function IsSubsid(p_user_id NUMBER, p_affair_id NUMBER, p_affair_stage NUMBER, p_f_num NUMBER) return varchar2;
                                                
  -- Автор  : Dik
  -- Описание :  Получить курсор на субсидию/Денежная компенсация МД из КПУ 
  -- Параметры:
  --    Входные: ID и stage КПУ (affair), p_f_num - номер элементарной семьи
procedure GetSubsid(p_user_id NUMBER, p_affair_id NUMBER, p_affair_stage NUMBER, p_f_num NUMBER, p_cur in out SYS_REFCURSOR); 

end PKG_RSM2;
/
create or replace package body PKG_RSM2
is
--ilonis
-- пакет для работы по иНтеграции рсм2 и курс3 

 -----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Set_Global_Var( id_user number ) return varchar2
is 
    l_users users%rowtype;
    l_department number;
    l_factory number;
    l_okrug number;
    l_direct number;
 BEGIN
    KURS3_VAR.global_user_id:=id_user;
    kurs3_var.global_okrug_id   := 58;
      
    kurs3_var.global_department   := 958;
    kurs3_var.global_factory      :=    280;
    kurs3_var.direction_id   :=  1;  
    
    select * into l_users  from users where user_id=id_user;
    
     kurs3_var.global_user_name:='M280';--substr(l_users.last_name,1,18);
    
 
 
    return null;
    
    select * into l_users  from users where user_id=id_user;
    
    --ведомство
    select  P.VALUE into l_department from users_priv p where P.USER_ID= id_user and P.PRIV_ID=2;
    --предприятие
    select P.VALUE into l_factory from users_priv p where P.USER_ID= id_user and P.PRIV_ID=3; 
    -- направление 
    select P.VALUE into l_direct from users_priv p where P.USER_ID= id_user and P.PRIV_ID=1 and rownum=1;
  --   select * from priv_types
 
    kurs3_var.global_okrug_id   := l_users.okrug_id;  
    kurs3_var.global_department   := l_department;
    kurs3_var.global_factory      :=l_factory;
    kurs3_var.direction_id   :=l_direct;  
    KURS3_VAR.global_user_id:=id_user;
    return null;
    
    exception 
    when no_data_found then 
        return 'Пользователь с идентификатором "'||id_user||'" не найден!';
        
 END Set_Global_Var;
 
 
function set_affair_reason2 (affair_id_     NUMBER
                                                       ,reason2_       NUMBER
                                                       ,reason2_date_  DATE
                                                       ,provide_       NUMBER := NULL
                                                       ,reason2_num_   VARCHAR2 := NULL
                                                       )  return varchar2  AS
  --    Процедура снятия с учета
  --
    a_status NUMBER;
    nn       NUMBER;
    v_aff_type2 affair.type2%type := 0;  --  12.11.2018 Dik
    TYPE Tv_a_p_id IS TABLE OF affair_plan.affair_plan_id%type INDEX BY PLS_INTEGER; 
    v_a_p_id   Tv_a_p_id;
BEGIN
  -- Проверка на наличие активных (не архивных) записей План_КПУ в состоянии "в плане"/"в приоритетах"
  SELECT COUNT (*)
    INTO nn
    FROM affair_plan
   WHERE affair_plan.affair_id = affair_id_ AND affair_plan.status IN (1, 3) AND affair_plan.archive = 0;

  IF nn > 0 THEN
   return  'Есть активные записи в Плане_КПУ';
  END IF;

  ---------------------------------------------------------------------------------
  SELECT a.status, a.type2    --  12.11.2018 Dik
    INTO a_status, v_aff_type2
    FROM affair a
   WHERE a.affair_id = affair_id_ AND a.affair_stage = 1;

  IF a_status > 1 THEN
       return 'Данная операция может проводится только с делами, стоящими на учете';
  END IF;

  FOR rec IN (SELECT *
                FROM affair_sublease asl1
               WHERE asl1.sublease_id = (SELECT MAX (asl2.sublease_id)
                                           FROM affair_sublease asl2
                                          WHERE affair_id = affair_id_)) LOOP
    IF rec.doc_type = 1 /* РД на участие */
                        --    12.03.2010  BlackHawk  Закрыл по просьбе округа и с согласия Мартынова Ю.Д.
                        --    OR  (rec.doc_type = 2 /* прекращение участия */
                        --                         AND rec.cancel_reason <> 4 /* в связи со снятием с учета */
                        --                                                   )
     THEN
     return 'КПУ принимает участие в программе компенсации поднайма ';
    END IF;
  END LOOP;

  UPDATE affair
     SET reason2 = reason2_, 
         reason2_date = reason2_date_, 
         reason2_num = reason2_num_, 
         reason2_calc = sysdate, --onvikova 23.12.2015 #1.182
         status = 5
   WHERE affair_id = affair_id_ AND affair_stage = 1 AND okrug_id = kurs3_var.global_okrug_id;

--  12.11.2018 Dik
  if v_aff_type2 in (PKG_DECLARATION.subsidy_code_md) then
      select affair_plan.affair_plan_id BULK COLLECT INTO v_a_p_id
        from affair_plan
         WHERE affair_plan.affair_id = affair_id_
           AND affair_plan.affair_stage = 1
           AND (NVL (affair_plan.status, 8) IN (1, 3, 4, 8, 5, 9) or NVL (affair_plan.owner, 0) = 4) 
           AND affair_plan.family_num IN (SELECT person_relation_delo.family_num
                                            FROM person_relation_delo
                                           WHERE person_relation_delo.affair_id = affair_id_ AND person_relation_delo.affair_stage = 1)
           and affair_plan.family_type = PKG_DECLARATION.subsidy_code_md ;
  end if; 
 -- / 12.11.2018 Dik 
   -- добавлена проверка значения поля OWNER для снятия с учета очередников, 
    -- включенных в План_КПУ, ранее из него исключавшихся
    -- OWNER заполняется в триггере CHG_AFFAIR_PLAN таблицы Affair_Plan
    
  IF get_provide_reason2 (reason2_) = 7 THEN -- С обеспечением
    --if provide=1 then          -- С обеспечением
    UPDATE affair_plan
       SET type2         = DECODE (affair_plan.type2,  1, 7,  NULL, 7,  5, 7,  7)
          , -- СсО, ОсС
           --   update affair_plan set type2=decode(affair_plan.type2,1,7,null,7,5,4,4),       -- СсО, ОсС
           -- 10.09.2004 Kirillov     status=decode(affair_plan.status,null,8,1,8,3,8,4,2,affair_plan.status),
           status        = DECODE (affair_plan.status,  NULL, 9,  1, 9,  3, 9,  8, 9,  4, 2, 
                                          decode(affair_plan.owner, 4,9, affair_plan.status) )
          ,direct_num    = DECODE (affair_plan.direct_num, NULL, reason2_num_, affair_plan.direct_num)
          ,direct_date   = DECODE (affair_plan.direct_date, NULL, reason2_date_, affair_plan.direct_date)
          ,plan_year     =
             (SELECT NVL (num_value, TO_NUMBER (TO_CHAR (SYSDATE, 'yyyy')))
                FROM global_parameters
               WHERE UPPER (parameter_name) = 'AFFAIR_PLAN_YEAR' AND ROWNUM = 1)
         , OWNER =NULL
     WHERE affair_plan.affair_id = affair_id_
       AND affair_plan.affair_stage = 1
       AND (NVL (affair_plan.status, 8) IN (1, 3, 4, 8, 5, 9) or NVL (affair_plan.owner, 0) = 4) 
       AND affair_plan.family_num IN (SELECT person_relation_delo.family_num
                                        FROM person_relation_delo
                                       WHERE person_relation_delo.affair_id = affair_id_ AND person_relation_delo.affair_stage = 1);
     -- RETURNING affair_plan.affair_plan_id INTO v_a_p_id ;  --  12.11.2018 Dik 
  ELSE -- Без обеспечения
    UPDATE affair_plan
       SET type2         = DECODE (affair_plan.type2,  1, 6,  NULL, 6,  5, 6,  6)
          , -- СбО, ОсС
           --   update affair_plan set type2=decode(affair_plan.type2,1,6,null,6,5,4,4),       -- СбО, ОсС
           -- 10.09.2004 Kirillov     status=decode(affair_plan.status,null,8,1,8,3,8,4,2,affair_plan.status),
           status        = DECODE (affair_plan.status,  NULL, 9,  1, 9,  3, 9,  8, 9,  4, 2,
                                          decode(affair_plan.owner, 4,9, affair_plan.status) )
          ,direct_num    = DECODE (affair_plan.direct_num, NULL, reason2_num_, affair_plan.direct_num)
          ,direct_date   = DECODE (affair_plan.direct_date, NULL, reason2_date_, affair_plan.direct_date)
          ,plan_year     =
             (SELECT NVL (num_value, TO_NUMBER (TO_CHAR (SYSDATE, 'yyyy')))
                FROM global_parameters
               WHERE UPPER (parameter_name) = 'AFFAIR_PLAN_YEAR' AND ROWNUM = 1)
          , OWNER =NULL
     WHERE affair_plan.affair_id = affair_id_
       AND affair_plan.affair_stage = 1
       AND (NVL (affair_plan.status, 8) IN (1, 3, 4, 8, 5, 9) or NVL (affair_plan.owner, 0) = 4) 
       AND affair_plan.family_num IN (SELECT person_relation_delo.family_num
                                        FROM person_relation_delo
                                       WHERE person_relation_delo.affair_id = affair_id_ AND person_relation_delo.affair_stage = 1);
    --  RETURNING affair_plan.affair_plan_id INTO v_a_p_id ;    --  12.11.2018 Dik                                    
  END IF;
 
   --  12.11.2018 Dik "Денежная компенсация МД", аналогичный блоку "Субсидии" 
    --  перевод заявления на гор программу в статус типа исполнено
   if v_aff_type2 in (PKG_DECLARATION.subsidy_code,PKG_DECLARATION.subsidy_code_md) then
      update DECLARATION d 
       set d.z_status = PKG_DECLARATION.decl_status_end
      where d.affair_id = affair_id_
        and d.z_status = 1 --(актуально -> исп/пог ?
        and d.z_cp_num_id = (select aqct.cp_num from affair_queue_cpnum_type2 aqct where aqct.type2 = v_aff_type2);
     if v_aff_type2 in (PKG_DECLARATION.subsidy_code_md) then
        FOR i IN 1 .. v_a_p_id.COUNT
        loop  
         set_provide_subsid (v_a_p_id(i),1,reason2_date_ , reason2_num_); --снятие с учёта субсидии , компенсации МД
        end loop; 
     end if;    
   end if;
   
   return null;
   
  -- журнализация снятия дела с учета
  kurs3.  LOG (kurs3_var.access_log_type
      ,450
      ,get_user_unique_id (kurs3_var.global_user_id)
      ,kurs3_var.global_okrug_id
      ,'REMOVAL_FROM_ACCOUNT = ' || TO_CHAR (affair_id_)
      );
EXCEPTION
  WHEN NO_DATA_FOUND THEN
   return 'Не найдено учетное дело';
END;


--перевод заявления в кПУ
function announ_to_affair_1 (a_id NUMBER, dec_num CHAR, dec_date DATE) return varchar2 AS
  nn          NUMBER;
  l_decl_date DATE;
  reason_     NUMBER;
  t2          NUMBER;
  t2_date     DATE;
  s_y         NUMBER;
  l_pers_count number;
BEGIN
  SELECT COUNT (*)
    INTO nn
    FROM affair
   WHERE affair_id = a_id AND okrug_id = kurs3_var.global_okrug_id AND affair_stage > 0;

  IF nn > 0 THEN
    RETURN 'Заявление не найдено';
  END IF;

  SELECT decl_date, reason, type2
    INTO l_decl_date, reason_, t2
    FROM affair
   WHERE affair_id = a_id AND affair_stage = 0;

-- 08.09.2008 Anissimova    - проверка вида обеспечения и направления учета
  IF (t2 = 16 AND reason_ = 21) OR reason_ <> 21 THEN
    t2_date := NULL;
  ELSE
    t2_date := dec_date;
  END IF;

---------------------------------------------------------------------------
  IF (l_decl_date IS NULL)  AND (reason_ IN (1, 21)) THEN   -- 23.09.2008 Anissimova
    return  'Нет даты завления!';
  END IF;

  IF (dec_date < NVL (l_decl_date, TO_DATE ('01.01.1900', 'dd.mm.yyyy')))  AND (reason_ IN (1, 21)) THEN   -- 23.09.2008 Anissimova
    return  'Дата решения меньше даты заявления!';
  END IF;

--- 20.01.2009 Anissimova
--- проверка возможности создания КПУ с годом постановки = текущий год-1
 --ilonis 13.05.2015
     IF dec_date < TO_DATE ('01.07.' || TO_CHAR (SYSDATE, 'yyyy'), 'dd.mm.yyyy')
        AND l_decl_date IS NOT NULL 
                AND TO_NUMBER (TO_CHAR (l_decl_date, 'yyyy')) = TO_NUMBER (TO_CHAR (SYSDATE, 'yyyy')) - 1 THEN      
--    если дата решения < 1 июля текущего года и год заявления = текущий-1 - оформляем КПУ с годом постановки = текущий год-1
--     , то оформляем КПУ с годом постановки по дате заявления
    s_y := 1;
  ELSE
    -- оформляем КПУ с годом постановки = текущий год
    s_y := 0;
  END IF;
  
  --про людей
  SELECT count(*) into  l_pers_count  FROM  V_PERSON_AFFAIR_3 WHERE  affair_id =a_id and  affair_stage = 0 ;
    if (l_pers_count=0) then
        return 'В заявлении должен быть заявитель.';
    end if;

-------------------------------------------------------
  UPDATE affair
-- 20.01.2009 Anissimova
--     SET stand_year = TO_NUMBER (TO_CHAR (DECODE (reason, 97, SYSDATE, DECODE (l_decl_date, NULL, SYSDATE, l_decl_date)), 'YYYY'))
  SET stand_year = TO_NUMBER (TO_CHAR (DECODE (reason, 97, SYSDATE, DECODE (s_y, 1, l_decl_date, SYSDATE)), 'YYYY'))
------------------------
  WHERE  affair_id = a_id AND okrug_id = kurs3_var.global_okrug_id AND affair_stage = 0;

  UPDATE affair
--  04.03.2009 Lvova    
--     SET calc_year = TO_NUMBER (TO_CHAR (l_decl_date, 'YYYY'))
     SET calc_year = TO_NUMBER (TO_CHAR (DECODE(s_y, 1, l_decl_date, SYSDATE), 'YYYY'))
   WHERE affair_id = a_id AND okrug_id = kurs3_var.global_okrug_id AND affair_stage = 0 AND reason = 1;

  nn := get_new_delo_num (a_id);

  UPDATE affair
     SET affair_stage = 1
        ,decision_num = dec_num
        ,delo_date = dec_date
        ,delo_num = nn
        ,type2_date = t2_date   -- 08.09.2008 Anissimova -- дата установки вида обеспечения
   WHERE affair_id = a_id AND okrug_id = kurs3_var.global_okrug_id AND affair_stage = 0;

  UPDATE room_delo
     SET affair_stage = 1
   WHERE affair_id = a_id AND okrug_id = kurs3_var.global_okrug_id AND affair_stage = 0;

  UPDATE person_relation_delo
     SET affair_stage = 1
   WHERE affair_id = a_id AND area = kurs3_var.global_okrug_id AND affair_stage = 0;

  -- журнализация оформления дела
  kurs3.LOG (kurs3_var.access_log_type
            ,448
            ,get_user_unique_id (kurs3_var.global_user_id)
            ,kurs3_var.global_okrug_id
            , 'ANNOUN_TO_AFFAIR = ' || TO_CHAR (a_id)
            );

    commit;         
    return null;
    

    EXCEPTION
    WHEN OTHERS THEN
      Kurs3_Var.Global_Action := 'ERROR CREATE AFFAIR -20089';
      Registration_1;
      --  l_error_txt:=l_error_txt || SQLCODE || ':' || SQLERRM;
        --    l_error_txt:=l_error_txt||';'||l_mail_err||'; ' || substr(dbms_utility.format_error_stack(),1,200);
      --RETURN 'Ошибка при создании заявления: ' || substr(dbms_utility.format_error_stack(),1,200);
      rollback;
      return replace(replace(regexp_replace(dbms_utility.format_error_stack(), 'ORA-\d+:\s+', ''), chr(13), ''), chr(10), '');
 
END;


/*
издание ф4
*/
function  set_instr ( instruction_num NUMBER, instruction_date DATE ) return varchar2 
AS
    p_to  NUMBER;
    p_who NUMBER;
    temp1 NUMBER;
  BEGIN
    IF (instruction_date >= SYSDATE) THEN
     return  'Дата введена неверно! Должна быть меньше текущей!';
    END IF;

    IF test_instruction_rpi (instruction_num) = 0 THEN
     return  'Проверьте параметры распоряжения по таблице УПП';
    END IF;

    SELECT f2.rights -- P8_TO
                    , f1.rights -- P8_WHO
      INTO p_to, p_who
      FROM kurs3.instruction in1, kurs3.factory f1, kurs3.factory f2
     WHERE     (f1.department = in1.department_who AND f1.num_in_department = in1.num_in_department_who)
           AND (f2.department = in1.department_to AND f2.num_in_department = in1.num_in_department_to)
           AND in1.instruction_num = set_instr.instruction_num;

    IF ( p_who = 30) OR (p_to = 30)   OR  (p_who = 11)  OR ( p_to = 11) -- 11.07.2016 Dikan [ Задача 1.198 Изменение функционала передачи жилого помещения]                 
   THEN
      IF test_instruction_crpi (set_instr.instruction_num) = 0 THEN
        return 'Проверьте параметры распоряжения по таблице ГУПП ';
      END IF;
   END IF;

    temp1   := 0;
    IF (p_who = 30) AND (p_to IN (10, 11, 80)) THEN
      SELECT COUNT (*)
        INTO temp1
        FROM free_space
       WHERE     status = 5
             AND NVL (doc2_num, 0) = set_instr.instruction_num
             AND NVL (doc2_type, 0) = 1
             AND LAST = 1
             AND get_incoming_instr_p8_30 (freespace_id) <> -1;

      IF (temp1 > 0) AND (get_ip_global_parameters ('F4_224', 0) <> 1) THEN
         return 'Площадь изъята из ЦАЖ по статье 224, для издания обращайтесь в АСУ ДЖПиЖФ';
      END IF;
    END IF;

    -- 03.07.2008 кон
    -- AVL 16.05.2007 кон
    set_instr_2 (instruction_num, instruction_date);
    --------!!!!!!!!!!!!!!
    declare_instr (instruction_num, instruction_date);
    --------!!!!!!!!!!!!!!
    set_instr_1 (instruction_num, instruction_date);
    
   kurs3. LOG (kurs3_var.access_log_type, 434, kurs3_var.global_user_id, kurs3_var.global_okrug_id, 'Set_Instr= ' || TO_CHAR (instruction_num));

    auto_instruction_cp_change (instruction_num, instruction_date); -- AVL 2011.06.20

    return null;
    
     COMMIT; -- 10.01.2013 Ikonnikov
  END set_instr;
  
/*
аннулирование Ф4
*/
--------------------------------------------------------------------------------------------------------------
function  Delete_instr_1(  instruction_num_  number) return varchar2 
as
nn number;
b_id number;
--
begin
    if GET_INSTRUCTION_DATE(instruction_num_) is not null then
       return 'Попытка аннулировать изданное распоряжение';
    end if;
    
    delete from instruction where INSTRUCTION_NUM=instruction_num_;
    delete from room_document  where Document_NUM=instruction_num_  and document_type=1;
    
    delete from document  where Document_NUM=instruction_num_    and document_type=1;
    delete from documents where Document_NUM=instruction_num_     and document_type=1;

    update free_space set doc2_num=null,
                                          doc2_type=null,
                                          document_date2=null,
                                          last_change=sysdate,
                                          status=1,
                                          last=1
           where free_space.doc2_num=instruction_num_
           and free_space.STATUS=5
           and free_space.doc2_type=1;

    KURSIV.kurs3_exchange.DELETE_INSTR_OF_KURS3(instruction_num_);

    DEB_UG (1,'Delete Instr','instr_num= '||to_char(instruction_num_),418,kurs3_var.global_user_id);
end Delete_instr_1;


/*
передача площади по Ф4
*/
-------------------------------------------------------------------------------------------------------------------------------------------
function Update_Instr_3(
                                        instruction_num         NUMBER
                                        ,department_to           NUMBER
                                        ,num_in_department_to    NUMBER
                                        ,target                  NUMBER
                                        ,direction               NUMBER
                                        ,YEAR                    NUMBER
                                        ,s_delivery              NUMBER
                                        ,s_calculation           NUMBER
                                        ,FUND                    NUMBER
                                        ,basis_str1           IN VARCHAR2
                                        ,basis_str2           IN VARCHAR2
                                        ,basis_str3           IN VARCHAR2
                                        ,addenum_str1         IN VARCHAR2
                                        ,addenum_str2         IN VARCHAR2
                                        ,addenum_str3         IN VARCHAR2
                                        ,addenum_str4         IN VARCHAR2
                                        ,addenum_str5         IN VARCHAR2
                                        ,print_dep            IN NUMBER := 1) return varchar2
AS
    v_index    NUMBER;
    tot_sp     NUMBER;
    liv_sp     NUMBER;
    liv_sp_all NUMBER;
    nn         NUMBER;
    d_who      NUMBER;--  ведомство кто для Р-тек
    f_who      NUMBER;--  предприятие кто для Р-тек
    p8_who     NUMBER;--  Р8 кто для Р-тек
    p8_to      NUMBER;--  Р8 кому для Р-тек 
    temp1      NUMBER; -- Для буферизации значений 
    temp2      NUMBER; -- Для буферизации значений
    temp3      NUMBER; -- Для буферизации значений    
    nbc        NUMBER;
    s_del      NUMBER;
    fund1      NUMBER;  
    cp_num1    NUMBER;
    space_type1 NUMBER;
    multi_cp   NUMBER;
    multi_ap   NUMBER;
    ap_cnt     NUMBER;
    flag_diff_r1 NUMBER; -- флаг, разрешающий передачу неск. кв-р н/с с разными р-1 для р8=30       
    cp_num2    NUMBER;
    s_del2     NUMBER;
    dir2       NUMBER;
    targ2      NUMBER;
    fund2      NUMBER;  
    regplan    number;
BEGIN

    SELECT COUNT(*)   INTO nn    FROM DOCUMENT
    WHERE DOCUMENT.document_num = Update_Instr_3.instruction_num AND DOCUMENT.all_rooms <> 1;

    IF nn = 0 THEN
        -- подсчет площадей для отдельных квартир
        SELECT SUM(APARTMENT.total_space), SUM(APARTMENT.living_space)   INTO tot_sp, liv_sp
        FROM DOCUMENT, APARTMENT
        WHERE DOCUMENT.document_num = Update_Instr_3.instruction_num
                 AND DOCUMENT.document_type = 1
                AND DOCUMENT.apart_id = APARTMENT.apart_id;
    ELSE
        -- подсчет площадей для коммунальной квартиры
        SELECT SUM(APARTMENT.total_space), SUM(APARTMENT.living_space)
        INTO tot_sp, liv_sp_all
        FROM DOCUMENT, APARTMENT
        WHERE DOCUMENT.document_num = Update_Instr_3.instruction_num
                    AND DOCUMENT.document_type = 1
            AND DOCUMENT.apart_id = APARTMENT.apart_id;

        SELECT SUM(ROOM.room_space)    INTO liv_sp
        FROM ROOM_DOCUMENT, ROOM
        WHERE ROOM_DOCUMENT.document_num = Update_Instr_3.instruction_num
                AND ROOM_DOCUMENT.document_type = 1
                AND ROOM_DOCUMENT.apart_id = ROOM.apart_id
                AND ROOM_DOCUMENT.building_id = ROOM.building_id
                AND ROOM_DOCUMENT.room_num = ROOM.room_num;


        --    Вычисление приведенной площади в случае коммунальной квартиры
        tot_sp   := Round(tot_sp * liv_sp / liv_sp_all,1);
     END IF;

    UPDATE INSTRUCTION
         SET department_to = Update_Instr_3.department_to
                ,num_in_department_to = Update_Instr_3.num_in_department_to
                ,target = Update_Instr_3.target
                ,direction = Update_Instr_3.direction
                ,YEAR = Update_Instr_3.YEAR
                ,s_delivery = Update_Instr_3.s_delivery
                ,s_calculation = Update_Instr_3.s_calculation
                ,FUND = Update_Instr_3.FUND
                ,basis =Update_Instr_3.basis_str1 || CHR(10) || Update_Instr_3.basis_str2 || CHR(10) || Update_Instr_3.basis_str3
                ,AREA = Get_Factory_Registration_1(Update_Instr_3.department_to, Update_Instr_3.num_in_department_to)
                ,addenum =
                        Update_Instr_3.addenum_str1
                        || CHR(10)
                        || Update_Instr_3.addenum_str2
                        || CHR(10)
                        || Update_Instr_3.addenum_str3
                        || CHR(10)
                        || Update_Instr_3.addenum_str4
                        || CHR(10)
                        || Update_Instr_3.addenum_str5
                        || CHR(10)
                ,reducted_space = tot_sp
                ,living_space = liv_sp
                ,print_dep = Update_Instr_3.print_dep
    WHERE INSTRUCTION.instruction_num = Update_Instr_3.instruction_num;
   
    SELECT f2.RIGHTS -- P8_TO
           ,f1.RIGHTS -- P8_WHO 
           ,in1.DEPARTMENT_WHO, in1.NUM_IN_DEPARTMENT_WHO, nvl(in1.NEW_BUILDING_CODE,0), nvl(s_delivery,0)
           ,decode(is_apartment,1,1,2) space_type
      INTO  p8_to, p8_who, d_who, f_who, nbc, s_del, space_type1
      FROM INSTRUCTION in1, Kurs3.FACTORY f1, Kurs3.FACTORY f2
      WHERE (f1.DEPARTMENT = in1.department_who
       AND f1.num_in_department = in1.num_in_department_who)
       AND (f2.DEPARTMENT(+) = Update_Instr_3.department_to
       AND f2.num_in_department(+) = Update_Instr_3.num_in_department_to)
       AND in1.INSTRUCTION_NUM=Update_Instr_3.instruction_num; 
       
      IF (p8_who in (3,5,80,81) AND (p8_to=30) and (nbc>0) and (s_del=110)) then
        Update instruction  set fund=decode(p8_who,80,724,3,710,81,710,5,710)
        where INSTRUCTION.instruction_num = Update_Instr_3.instruction_num;
    ELSIF (p8_who in (3,5,80,81) AND (p8_to<>30) and (nbc>0)) then
         SELECT Get_Freespace_Fond_1(FREE_SPACE.doc_num)  into fund1
            FROM FREE_SPACE
            WHERE FREE_SPACE.status = 5
                AND NVL(FREE_SPACE.doc2_num, 0) = Update_Instr_3.instruction_num
                AND FREE_SPACE.LAST = 1
                AND ROWNUM = 1;
                  
         Update instruction   set fund=fund1
        where INSTRUCTION.instruction_num = Update_Instr_3.instruction_num;
    END IF;


    temp1:=0;
    if ( (p8_who=30) and (p8_to=30) 
           and (Update_Instr_3.department_to<>d_who)  
     ) then
        return 'Нельзя передать от одной префектуры на другую напрямую!';  
    end if;

    if ( (p8_who=30) and (p8_to=30) and (Update_Instr_3.s_delivery in (235,236)) ) then
    begin
        select cpc1.CP_NUM2, cpc1.S_DELIVERY2, cpc1.FUND2, cpc1.DIRECTION2, cpc1.TARGET2
        into cp_num2, s_del2, fund2, dir2, targ2
        from city_prog_change cpc1
       where cpc1.CP_NUM1=test_auto_instruction_crpi(p8_who, p8_to, d_who, f_who, Update_Instr_3.department_to,
                                 Update_Instr_3.num_in_department_to, nbc, Update_Instr_3.direction,
                                 Update_Instr_3.target,
                                 Update_Instr_3.s_delivery, Update_Instr_3.s_calculation,
                                 Update_Instr_3.fund,space_type1)
         and cpc1.S_DELIVERY1=Update_Instr_3.s_delivery
         and cpc1.DIRECTION1=Update_Instr_3.DIRECTION 
         and cpc1.TARGET1=Update_Instr_3.target
         and rownum=1; 
    exception when others then
      cp_num2:=-1;
      s_del2:=-1;
      fund2:=-1;
      dir2:=-1;
      targ2:=-1;
    end;
    
    if ( (cp_num2=-1) or (s_del2=-1) or (fund2=-1) or (dir2=-1) or (targ2=-1) ) then
      return 'Для данного распоряжения не возможно создать автораспоряжение';
    else
        if test_auto_instruction_rpi(p8_who, p8_to, d_who, f_who, Update_Instr_3.department_to,
                                     Update_Instr_3.num_in_department_to, nbc, dir2,
                                     s_del2, Update_Instr_3.s_calculation,
                                     fund2)=0 then
           return 'Для данного распоряжения не возможно создать автораспоряжение по УПП';                             
        end if;
        if ( (test_auto_instruction_crpi(p8_who, p8_to, d_who, f_who, Update_Instr_3.department_to,
                                     Update_Instr_3.num_in_department_to, nbc, dir2,
                                     targ2,
                                     s_del2, Update_Instr_3.s_calculation,
                                     fund2,space_type1)=0) or
           (test_auto_instruction_crpi(p8_who, p8_to, d_who, f_who, Update_Instr_3.department_to,
                                     Update_Instr_3.num_in_department_to, nbc, dir2,
                                     targ2,
                                     s_del2, Update_Instr_3.s_calculation,
                                     fund2,space_type1)<>cp_num2) )
        then
         return 'Для данного распоряжения не возможно создать автораспоряжение по ГУПП';                             
        end if;           
     end if;                          
  end if;            
  
    flag_diff_r1:=0;
    IF Test_Instruction_Rpi(Update_Instr_3.instruction_num) = 0 THEN
        return  'Проверьте параметры распоряжения по таблице УПП';
    ELSIF (Get_Global_Param_Num_Value('USE_DOPOLN_RPI')=1) THEN
        Test_Instruction_Dopoln_UPP(Update_Instr_3.instruction_num);  
    END IF;
 
    if ((p8_who=30) or (p8_to=30)) and (p8_who<>11) /*and (not(((p8_who=30) and (p8_to=31)) or  ((p8_who=31) and (p8_to=30)) ) ) */ then   
    IF Test_Instruction_crpi(Update_Instr_3.instruction_num) = 0 THEN
        return 'Проверьте параметры распоряжения по таблице ГУПП';
    ELSIF Test_Instruction_crpi(Update_Instr_3.instruction_num) <> 10000 THEN
        cp_num1:=0;
    if ((p8_who<>10) and (s_del<>110)) then 
        select nvl(all_rooms,-1), count(apart_id) into space_type1, ap_cnt
        from document doc1, instruction in1 
        where in1.instruction_num=doc1.DOCUMENT_NUM
          and in1.document_type=doc1.DOCUMENT_TYPE 
          and in1.instruction_num=Update_Instr_3.instruction_num
        group by all_rooms;  
        if ((space_type1=1) and (ap_cnt>1)) then   -- рассмотрим о/к
         begin 
            select cp_num into cp_num1 
            from free_space fs1, fs_city_prog fcp1
            where fs1.FREESPACE_ID=fcp1.FREESPACE_ID
              and fs1.apart_id =  (select apart_id
                                       from document doc1, instruction in1 
                                    where in1.instruction_num=doc1.DOCUMENT_NUM
                                      and in1.DOCUMENT_TYPE=doc1.DOCUMENT_TYPE 
                                      and in1.instruction_num=Update_Instr_3.instruction_num
                                      and rownum=1)
              and fs1.last=1
              and fs1.SPACE_TYPE=1
              and rownum=1;
              
            select count(cp_num) -- кол-во пометок любого вида
            into multi_cp 
            from free_space fs1, fs_city_prog fcp1
            where fs1.FREESPACE_ID=fcp1.FREESPACE_ID
              and fs1.apart_id in  (select apart_id
                                       from document doc1,instruction in1 
                                    where in1.instruction_num=doc1.DOCUMENT_NUM
                                      and in1.DOCUMENT_TYPE=doc1.DOCUMENT_TYPE 
                                      and in1.instruction_num=Update_Instr_3.instruction_num
                                      and rownum=1)
              and fs1.last=1
              and fs1.SPACE_TYPE=1
              and fcp1.CP_NUM=cp_num1;
              
            select count(apart_id)
            into multi_ap 
            from free_space fs1
            where fs1.apart_id in  (select apart_id
                                       from document doc1,instruction in1 
                                    where in1.instruction_num=doc1.DOCUMENT_NUM
                                      and in1.DOCUMENT_TYPE=doc1.DOCUMENT_TYPE 
                                      and in1.instruction_num=Update_Instr_3.instruction_num
                                      and rownum=1)
              and fs1.last=1
              and fs1.SPACE_TYPE=1;
            if (multi_ap<>multi_cp) then 
                return 'В распоряжении не может быть неск кв с разными гор прог!';
            end if;                      
            
         exception when no_data_found then
            return 'Пл в распоряжени не размечена гор прог!';     
         end;
       elsif (space_type1<>1) then   
         begin 
           select cp_num
             into cp_num1 
             from free_space fs1, fs_city_prog fcp1
            where fs1.FREESPACE_ID=fcp1.FREESPACE_ID
              and fs1.apart_id =  (select distinct apart_id
                                       from room_document rd1, instruction in1 
                                    where in1.instruction_num=rd1.DOCUMENT_NUM
                                      and in1.document_type=rd1.DOCUMENT_TYPE 
                                      and in1.instruction_num=Update_Instr_3.instruction_num)
              and fs1.last=1
              and fs1.DOC2_NUM=Update_Instr_3.instruction_num
              and fs1.SPACE_TYPE<>1;     
         exception when no_data_found then
            return 'Пл в распоряжении не размечена гор прог!!';     
         end;
       elsif ((space_type1=1) and (ap_cnt=1)) then
         begin   
           select cp_num
             into cp_num1 
             from free_space fs1, fs_city_prog fcp1
            where fs1.FREESPACE_ID=fcp1.FREESPACE_ID
              and fs1.apart_id =  (select apart_id
                                       from document doc1, instruction in1 
                                    where in1.instruction_num=doc1.DOCUMENT_NUM
                                      and in1.DOCUMENT_TYPE=doc1.DOCUMENT_TYPE 
                                      and in1.instruction_num=Update_Instr_3.instruction_num)
              and fs1.last=1
              and fs1.SPACE_TYPE=1;
         exception when no_data_found then
            return 'Пл в распоряжении не размечена гор прог!!';     
         end;                                                  
       end if;
       if Test_Instruction_crpi(Update_Instr_3.instruction_num)<> cp_num1 then
        return 'Проверьте параметры распоряжения по таблице ГУПП';   
       end if; 
    end if; -- кесли p8who<>10             
  END IF;  
end if;  

 nn := Get_Instruction_Rpi_Adjust(Update_Instr_3.instruction_num);

  IF NVL(nn, 0) = 0 THEN
   UPDATE INSTRUCTION
      SET adjust = nn,
        adjust_date_in = NULL,
     adjust_date_out = NULL
    WHERE INSTRUCTION.instruction_num = Update_Instr_3.instruction_num;
  ELSIF nn = 1 THEN
   UPDATE INSTRUCTION
      SET adjust = nn,
        adjust_date_in = SYSDATE,
     adjust_date_out = NULL
    WHERE INSTRUCTION.instruction_num = Update_Instr_3.instruction_num;
  END IF;
   
END;



----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Дата создания : 
  -- Описание :     удаление члена семьи из дела или заявления
  -- Параметры:
  -- Входные:
  -- Выходные:
  function DelPersonFromDelo(p_Person_Id NUMBER, p_Affair_Id NUMBER, p_Affair_Stage NUMBER:=0,
            p_DelReason_id number := NULL, p_ReasonDoc_num varchar2 := NULL, p_ReasonDoc_date DATE := NULL )  return varchar2
   IS
  BEGIN
  
     Kurs3.del_person_from_delo (p_Person_Id , p_Affair_Id , p_Affair_Stage ,
                                 p_DelReason_id , p_ReasonDoc_num , p_ReasonDoc_date ) ;
    --Kurs3.Del_Person_From_Delo(p_Person_Id, p_Affair_Id, p_Affair_Stage);
    commit;
    return null;
  EXCEPTION
    WHEN OTHERS THEN
      Kurs3_Var.Global_Action := 'ERROR CREATE AFFAIR -20089';
      Registration_1;
      --  l_error_txt:=l_error_txt || SQLCODE || ':' || SQLERRM;
        --    l_error_txt:=l_error_txt||';'||l_mail_err||'; ' || substr(dbms_utility.format_error_stack(),1,200);
      --RETURN 'Ошибка при создании заявления: ' || substr(dbms_utility.format_error_stack(),1,200);
      rollback;
      return replace(replace(regexp_replace(dbms_utility.format_error_stack(), 'ORA-\d+:\s+', ''), chr(13), ''), chr(10), '');
      
  END DelPersonFromDelo;
  
  
  ----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Дата создания :
  -- Описание :     процедура  создания состава семьи в деле
  -- Параметры:
  -- Входные:
  -- Выходные:
  -- ins_person_to_delo_9 
function CreateUpdatePerson(
                               Affair_Id_        NUMBER,
                               Affair_Stage_     NUMBER,
                               Rnum_             NUMBER,
                               Person_Id_        NUMBER,
                               Last_Name_        CHAR,
                               First_Name_       CHAR,
                               Birthday_         DATE,
                               Persex_           CHAR,
                               Relation_Cod_     NUMBER,
                               Doc_Type_         NUMBER,
                               Doc_Series_       CHAR,
                               Doc_Num_          CHAR,
                               Date_Enter_       DATE,
                               How_Giving_       CHAR,
                               Family_Num_       NUMBER,
                               Master_           NUMBER,
                               Sq_Type_          NUMBER,
                               Patronymic_       CHAR,
                               Pat_              CHAR,
                               Person_Category_  VARCHAR2,
                               Person_Subsidy_   CHAR,
                               Person_Category_1 VARCHAR2,
                               Person_Category_2 VARCHAR2,
                               Category_Date     DATE,
                               Category_Year     NUMBER,
                               Category_1_Date   DATE,
                               Category_1_Year   NUMBER,
                               Category_2_Date   DATE,
                               Category_2_Year   NUMBER,
                               Year_In_City      NUMBER,
                               Year_In_Place     NUMBER,
                               Reg_Person        NUMBER,
                               Owners            NUMBER := NULL,
                               Addr_Reg_         VARCHAR2,
                               Tenant_           NUMBER,
                               v_City            VARCHAR2,
                               v_Okrug           VARCHAR2,
                               v_Street          VARCHAR2,
                               v_Build_Num       VARCHAR2,
                               v_Korp_Num        VARCHAR2,
                               v_Apart_Num       VARCHAR2,
                               v_tel_home          VARCHAR2
                                ,v_tel_work          VARCHAR2
                                ,v_tel_mob           VARCHAR2
                                ,v_e_mail            VARCHAR2 
                               ,v_add_liv_sp_sz     VARCHAR2 := NULL
                               ,v_add_liv_sp_type  VARCHAR2 := NULL
                               ,v_add_liv_sp_comm   VARCHAR2 := NULL
                               ,v_AF_F_RELATION     NUMBER := NULL
                               ,v_ADD_REG_SPACE_ID  NUMBER := 0      
                              , birth_place          VARCHAR2) return varchar2
 IS
    l_Person_Category VARCHAR2(60);
    l_affair_stage number;
  BEGIN
  
    begin
        select affair_stage into l_affair_stage from affair where affair_id = Affair_Id_ and rownum=1;
    exception 
        when no_data_found then
            return 'Нет такой записи Affair_Id= '||Affair_Id_;        
    end;
    
    Kurs3.Ins_Person_To_Delo(
                             Affair_Id_,
                             l_affair_stage,
                             Rnum_,
                             case when  ( Person_Id_=-1) then null else Person_Id_ end,
                             Last_Name_,
                             First_Name_,
                             Birthday_,
                             Persex_,
                             Relation_Cod_,
                             Doc_Type_,
                             Doc_Series_,
                             Doc_Num_,
                             Date_Enter_,
                             How_Giving_,
                             Family_Num_,
                             Master_,
                             Sq_Type_,
                             Patronymic_,
                             Pat_,
                             Person_Category_,
                             Person_Subsidy_,
                             Person_Category_1,
                             Person_Category_2,
                             Category_Date,
                             Category_Year,
                             Category_1_Date,
                             Category_1_Year,
                             Category_2_Date,
                             Category_2_Year,
                             Year_In_City,
                             Year_In_Place,
                             Reg_Person,
                             Owners,
                             Addr_Reg_,
                             Tenant_,
                             v_City,
                             v_Okrug,
                             v_Street,
                             v_Build_Num,
                             v_Korp_Num,
                             v_Apart_Num,
                              v_tel_home
                                ,v_tel_work
                                ,v_tel_mob 
                                ,v_e_mail   
                               ,v_add_liv_sp_sz   
                               ,v_add_liv_sp_type 
                               ,v_add_liv_sp_comm 
                               ,v_AF_F_RELATION  
                               ,v_ADD_REG_SPACE_ID 
                             );
                                       
--ins_person_to_delo_9
                             
       pkg_persons.set_pasport_data_attr ( Person_Id_   ,'birth_place',   substr(birth_place,1,150)    );
        commit;     
       return null;
 EXCEPTION
    WHEN OTHERS THEN
      --  l_error_txt:=l_error_txt || SQLCODE || ':' || SQLERRM;
        --    l_error_txt:=l_error_txt||';'||l_mail_err||'; ' || substr(dbms_utility.format_error_stack(),1,200);
      --RETURN 'Ошибка при создании заявления: ' || substr(dbms_utility.format_error_stack(),1,200);
      rollback;
      return replace(replace(regexp_replace(dbms_utility.format_error_stack(), 'ORA-\d+:\s+', ''), chr(13), ''), chr(10), '');
                             
    -- ins_person_to_delo_8                              
  END CreateUpdatePerson;
  
  
----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Дата создания : 
  -- Описание :     
  -- Параметры:
  -- Входные:
  -- Выходные:  
 FUNCTION Get_Building_Id(p_Unom_ NUMBER) RETURN NUMBER IS
    l_Build_Id_ NUMBER;
  BEGIN
    SELECT Building_Id
      INTO l_Build_Id_
      FROM Apartment
     WHERE Unom_Bti = p_Unom_
           AND Rownum < 2;
    RETURN(l_Build_Id_);
  EXCEPTION
    WHEN No_Data_Found THEN    
            begin
                select building_id into  l_Build_Id_ from bti.building_bti where building_bti.unom=p_Unom_;
                RETURN(l_Build_Id_);
            EXCEPTION
             WHEN No_Data_Found THEN    
                 RETURN(0);
            end;
  END Get_Building_Id;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Create_Apartment(  p_unom  NUMBER, p_unkv NUMBER ) return varchar2
is 
  l_Build_Id NUMBER;
 l_Apart_Num NUMBER;
 l_Apart_Idx CHAR;
 l_Apart_Id NUMBER;
 l_Code NUMBER;
 l_New_Build_Code NUMBER := NULL;
 BEGIN
    l_Build_Id:= Get_Building_Id(p_unom);
    if (l_Build_Id=0) then
        return 'Дом не найден в БТИ';
    end if;
    
    begin
        select AP.KV, AP.KVI into l_Apart_Num, l_Apart_Idx  from BTI.APPART_ST_CARDS ap where AP.UNOM=p_unom and AP.UNKV= p_unkv and rownum=1;
    exception when no_data_found then
        return 'Квартира  не найдена в БТИ';         
    end;
    
     Pkg_Apartment.Create_Apartment_Kais( l_Build_Id, l_Apart_Num, l_Apart_Idx, l_Apart_Id, l_Code, Kurs3_Var.User_Id, l_New_Build_Code, 0);

    l_Apart_Id:= Pkg_Apartment.change_apart_from_bti_kais( l_Apart_Id, 0 );
    
 --   return l_Apart_Id;
 END Create_Apartment;
 

 
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :    создание заявления 
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CreateDeclaration(    p_unom number, 
                                            p_unkv number,
                                            p_apart_num varchar2,
                                            p_Decl_Date varchar2,
                                            p_Group_Id number,
                                            p_Delo_Category_Id number,
                                            p_Type2_Id number,
                                            p_Year_In_City number,
                                            p_Year_In_Place number,
                                            p_Reason number,
                                            p_affair_id in out number)     return varchar2
is 
 l_Build_Id NUMBER;
 l_Apart_Id NUMBER;
 l_Affair_Id NUMBER;
 l_Aff_Kais_Id NUMBER;
 
 l_Decl_Date DATE;
 s_Type number;
 l_Group_Id  number;
 l_Delo_Category_Id  number;
 l_Type2_Id  number;
 l_Year_In_City number;
 l_Year_In_Place  number;
 l_Apart_Num NUMBER;
 l_Apart_Idx CHAR;
 l_Code NUMBER;
 l_New_Build_Code NUMBER := NULL;
  
 BEGIN

    --тип документа
    kurs3_var.tmp_doc_type:=1;
    
    if (nvl(p_Reason,0)=0) then
        return 'Укажите направление учета';
    end if;
    
    if (nvl(p_Type2_Id,0)=0) then
        return 'Укажите вид обеспечения';
    end if;
    
     
     --создание площади
    l_Build_Id:= Get_Building_Id( p_unom );
    if (l_Build_Id=0) then
        return 'Дом не найден в БТИ';
    end if;
 
    begin
        select ap.kv, ap.kvi into l_Apart_Num, l_Apart_Idx  from BTI.APPART_ST_CARDS ap where ap.unom=p_unom and ap.unkv= p_unkv  and rownum=1;
    exception when no_data_found then
        return 'Квартира  не найдена в БТИ';         
    end;
     
    Pkg_Apartment.Create_Apartment_Kais( l_Build_Id, l_Apart_Num, l_Apart_Idx, l_Apart_Id, l_Code, Kurs3_Var.User_Id, l_New_Build_Code, 0);

    --l_Apart_Id:= Pkg_Apartment.change_apart_from_bti_kais( l_Apart_Id, 0 );
    l_Apart_Id:= Pkg_Apartment.change_apart_from_bti( l_Apart_Id );
    
     
    SELECT Seq_Affair_Id.Nextval INTO l_Affair_Id FROM Dual;
    
    p_affair_id:=l_Affair_Id;
    l_Decl_Date:=  p_Decl_Date;
    
    Kurs3_Var.Global_Action := 'BEGIN CREATE AFFAIR ' || l_Affair_Id;
    Registration_1;
  
    INSERT INTO Affair
      (Okrug_Id, --Округ
       Affair_Id, --Внутренний номер дела
       Affair_Stage, --Стадия дела (0 - заявление, 1 - дело, 2, 3 ... - копии)
       Build_Id, --Внутренний номер здания
       Apart_Id, --Внутренний номер квартиры
       Delo_Category, --Категория дела
       Factory_Id, --Код предприятия
       Stand_Year, --Год постановки
       Delo_Num, --Реальный номер дела
       Reg_Person_Cnt, --Всего человек на учете
       Person_In_Family, --Всего человек в семье
       Year_In_City, --С какого года в Москве
       Year_In_Place, --С какого года на площади
       Occupy_Num, --Количество занимаемых комнат
       More_Family, --Еще семей в квартире
       Plan_Year, --Год плана
       Last_Change, --Дата ввода/корректировки
       Ordered, --Выдавался ли ордер
       Department_Id, --Код ведомства
       Inspector,
       Status, -- 0 из 70 CLASSIFIER (поставлен на учет)
       s_Group, -- 14 из 9 CLASSIFIER (прочие)
       Type2, -- 1 из 11 CLASSIFIER (социальный найм тип обеспечения жильем)
       Reason, --направление 1 кл.
       Sq_Type, --тип площади --
       Kk_Num,
       Sqi,
       Sqo,
       Comfortable,
       Kitchen_Sq,
       Toilet,
       Good,
       Decl_Date, -- utk: дата заявления для переселенческих дел
       Calc_Year --,                   -- учетно-плановый год
       ,AFF_FROM_KAIS  --признак создания из РСМ2
       )
      SELECT Kurs3_Var.Global_Okrug_Id,
             l_Affair_Id,
             0,
             l_Build_Id,
             l_Apart_Id,
             p_Delo_Category_Id, -- 39, --Категория дела (Общие основания)
             Kurs3_Var.Global_Factory, --Код предприятия
             To_Number(To_Char( l_Decl_Date, 'YYYY')), --Год постановки
             0, --Реальный номер дела
             0, --Всего человек на учете
             0, --Всего человек в семье
             p_Year_In_City, --TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),
             p_Year_In_Place, --TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),
             0,
             0,
             0, --TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),
             SYSDATE,
             0,
             Kurs3_Var.Global_Department, -- Ведомство пользователя
             Kurs3_Var.Global_User_Name, -- Код инспектора
             0,
             p_Group_Id,--14, -- 14 из 9 CLASSIFIER (прочие)
             p_Type2_Id,--Decode(Kurs3_Var.Direction_Id, 21, 16, 1), -- вид обеспечения (клс.11) -- 02.09.2008 Anissimova - для 21 н/у
             p_Reason,--Kurs3_Var.Direction_Id,
             Space_Type,
             Room_Count,
             Living_Space,
             Total_Space,
             Condition, -- COMFORTABLE,
             Kitchen_Space,
             Lavatory,
             Good_For_Living,
             l_Decl_Date, --  decode(KURS3_VAR.Direction_id, 97, sysdate,1,sysdate, 21, sysdate, null), -- utk: дата заявления для переселенческих дел
             decode(p_Reason,1,To_Number(To_Char(SYSDATE, 'YYYY')), NULL), --Decode(Kurs3_Var.Direction_Id, 1, To_Number(To_Char(SYSDATE, 'YYYY')), NULL) --,  -- учетно-плановый год Lvova 04.03.2009
             2  --AFF_FROM_KAIS
        FROM Apartment
       WHERE Apart_Id = l_Apart_Id;
  
    SELECT Aff_Kais_Id INTO l_Aff_Kais_Id FROM Affair WHERE Affair_Id =l_Affair_Id;
  
    --   Квартира в учетном деле
    UPDATE Apartment SET Version = -5 WHERE Apart_Id = l_Apart_Id;
  
    -- Тип площади (TP) (Клс.05)
    SELECT Affair.Sq_Type
      INTO s_Type
      FROM Affair
     WHERE Affair.Affair_Id = l_Affair_Id
           AND Affair.Affair_Stage = 0;
  
   -- IF (s_Type = 1) THEN
      -- отдельная квартира
      --Описывает параметры комнат включенных в дело очередника
      INSERT INTO Room_Delo
        (Okrug_Id, Affair_Id, Affair_Stage, Building_Id, Apart_Id, Room_Num)
        SELECT Kurs3_Var.Global_Okrug_Id, l_Affair_Id, 0, Room.Building_Id, Room.Apart_Id, Room.Room_Num FROM Room WHERE Room.Apart_Id = l_Apart_Id;
    
      -- Количество занимаемых комнат (UX)
      UPDATE Affair
         SET Affair.Occupy_Num =
             (SELECT COUNT(*)
                FROM Room_Delo
               WHERE Room_Delo.Okrug_Id = Kurs3_Var.Global_Okrug_Id
                     AND Room_Delo.Affair_Id = l_Affair_Id
                     AND Room_Delo.Affair_Stage = 0)
       WHERE Affair.Okrug_Id = Kurs3_Var.Global_Okrug_Id
             AND Affair.Affair_Id = l_Affair_Id
             AND Affair.Affair_Stage = 0;
   -- END IF;
  
--select * from DIRECTION_TARGET d where D.DIRECTION=70
 --категория дела Delo_Category   Категория дела (KD) по таблице DIRECTION_TARGET       
 --вид обеспечения Type2
 --      S_GROUP     Общественная группа (OG) (Клс.09)             
 
    UPDATE Affair
       SET s_Group = p_Group_Id,  Delo_Category = p_Delo_Category_Id,  Type2 = p_Type2_Id, Year_In_City = p_Year_In_City, Year_In_Place = p_Year_In_Place
     WHERE Affair_Id = l_Affair_Id
           AND Okrug_Id = Kurs3_Var.Global_Okrug_Id
           AND Affair_Stage = 0;
 
  --  IF (Iscommit > 0) THEN
      COMMIT;
   -- END IF;
  
    Kurs3_Var.Global_Action := 'END CREATE AFFAIR ' || l_Affair_Id;
    Registration_1;
  
    -- журнализация создания заявления
    Log_1(Kurs3_Var.Access_Log_Type, 404, Get_User_Unique_Id(Kurs3_Var.Global_User_Id), Kurs3_Var.Global_Okrug_Id, 'New_ANNOUN = ' || To_Char(l_Affair_Id));
    
   
    RETURN null;
  
  EXCEPTION
    WHEN OTHERS THEN
      Kurs3_Var.Global_Action := 'ERROR CREATE AFFAIR -20089';
      Registration_1;
      --  l_error_txt:=l_error_txt || SQLCODE || ':' || SQLERRM;
        --    l_error_txt:=l_error_txt||';'||l_mail_err||'; ' || substr(dbms_utility.format_error_stack(),1,200);
      --RETURN 'Ошибка при создании заявления: ' || substr(dbms_utility.format_error_stack(),1,200);
      rollback;
      return replace(replace(regexp_replace(dbms_utility.format_error_stack(), 'ORA-\d+:\s+', ''), chr(13), ''), chr(10), '');
    
 END CreateDeclaration;
 
  
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     перевод заявления  в КПУ
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateDeclaration( p_user_id NUMBER, p_json varchar2)     return varchar2
is 
     Nn          NUMBER;
    l_Decl_Date DATE;
    l_Dec_Num varchar2(15);
    l_Dec_Date DATE;
    Reason_     NUMBER;
    T2          NUMBER;
    T2_Date     DATE;
    s_y         NUMBER;
    l_Affair_Id number;
 BEGIN
      --dec_num  -- номер решения
      --dec_date_ -- дата решения
 
    --Code_ := 0;
    l_Dec_Date:=sysdate;
    l_Dec_Num:='';
  
    IF (Nvl(TRIM(l_Dec_Num), ' ') = ' ') OR l_Dec_Date IS NULL THEN
      RETURN 'нет даты или номера решения';
    END IF;
  
    --уже не заявление
    SELECT COUNT(*)  INTO Nn FROM Affair
     WHERE Affair_Id = l_Affair_Id   AND Okrug_Id = Kurs3_Var.Global_Okrug_Id   AND Affair_Stage > 0
     ;
    IF Nn > 0 THEN
      RETURN 'КПУ уже не в статусе заяаления ';
    END IF;
  
    SELECT Decl_Date, Reason, Type2
      INTO l_Decl_Date, Reason_, T2
      FROM Affair
      WHERE Affair_Id = l_Affair_Id   AND Affair_Stage = 0;
  
    -- 08.09.2008 Anissimova    - проверка вида обеспечения и направления учета
    IF (T2 = 16 AND Reason_ = 21) OR Reason_ <> 21 THEN
      T2_Date := NULL;
    ELSE
      T2_Date := l_Dec_Date;
    END IF;
  
    IF (l_Decl_Date IS NULL) AND (Reason_ IN (1, 21)) THEN
      -- raise_application_error (-20298, 'Нет даты завления!');
      RETURN 'Нет даты заявления';
    END IF;
  
    IF (l_Dec_Date < Nvl(l_Decl_Date, To_Date('01.01.1900', 'dd.mm.yyyy'))) AND (Reason_ IN (1, 21)) THEN
      --raise_application_error (-20288, 'Дата решения меньше даты заявления!');
      RETURN 'Дата решения меньше даты заявления!';
    END IF;
  
    --- 20.01.2009 Anissimova
    --- проверка возможности создания КПУ с годом постановки = текущий год-1
    IF l_Dec_Date < To_Date('01.04.' || To_Char(SYSDATE, 'yyyy'), 'dd.mm.yyyy') AND To_Number(To_Char(l_Decl_Date, 'yyyy')) = To_Number(To_Char(SYSDATE, 'yyyy')) - 1 THEN
      -- если дата решения < 1 апреля текущего года и год заявления = текущий-1 - оформляем КПУ с годом постановки = текущий год-1
      s_y := 1;
    ELSE
      -- оформляем КПУ с годом постановки = текущий год
      s_y := 0;
    END IF;
  
    UPDATE Affair
       SET Stand_Year = To_Number(To_Char(Decode(Reason, 97, SYSDATE, Decode(s_y, 1, l_Decl_Date, SYSDATE)), 'YYYY'))
     WHERE Affair_Id = l_Affair_Id
           AND Okrug_Id = Kurs3_Var.Global_Okrug_Id
           AND Affair_Stage = 0;
  
    UPDATE Affair
       SET Calc_Year = To_Number(To_Char(Decode(s_y, 1, l_Decl_Date, SYSDATE), 'YYYY'))
     WHERE Affair_Id = l_Affair_Id
           AND Okrug_Id = Kurs3_Var.Global_Okrug_Id
           AND Affair_Stage = 0
           AND Reason = 1;
  
    Nn := Get_New_Delo_Num(l_Affair_Id);
  
    UPDATE Affair
       SET Affair_Stage = 1, Decision_Num = l_Dec_Num, Delo_Date = l_Dec_Date, Delo_Num = Nn, Type2_Date = T2_Date --  дата установки вида обеспечения
     WHERE Affair_Id = l_Affair_Id
           AND Okrug_Id = Kurs3_Var.Global_Okrug_Id
           AND Affair_Stage = 0;
  
    UPDATE Room_Delo
       SET Affair_Stage = 1
     WHERE Affair_Id = l_Affair_Id
           AND Okrug_Id = Kurs3_Var.Global_Okrug_Id
           AND Affair_Stage = 0;
  
    UPDATE Person_Relation_Delo
       SET Affair_Stage = 1
     WHERE Affair_Id = l_Affair_Id
           AND Area = Kurs3_Var.Global_Okrug_Id
           AND Affair_Stage = 0;
  
   -- IF (Iscommit > 0) THEN
      COMMIT;
    --END IF;
  
    --полный номер дела 
    --Po_Affair_Num := Substr(Get_Affair_Num_Fmt(a_Id, 1), 1, 40);
  
    -- журнализация оформления дела
    Kurs3.Log(Kurs3_Var.Access_Log_Type, 448, Get_User_Unique_Id(Kurs3_Var.Global_User_Id), Kurs3_Var.Global_Okrug_Id, 'ANNOUN_TO_AFFAIR = ' || To_Char(l_Affair_Id));

    return null;
    
 END UpdateDeclaration;
 

    
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CreatePerson( p_user_id NUMBER, p_affair_id number, p_json varchar2)     return varchar2
is 
   l_Surname VARCHAR2(25); --фамилия
   l_LastName VARCHAR2(35);
   l_First_Name VARCHAR2(2);
   l_Patronymic VARCHAR2(25);
   l_Birthday DATE;
   l_Sex_Code NUMBER;
   l_Person_Id_ NUMBER;
  -- l_First_Name VARCHAR(2);
  BEGIN
  
    l_First_Name := Substr(TRIM(l_LastName), 1, 1) || Substr(TRIM(l_Patronymic), 1, 1);
  
    SELECT Seq_Person_Id.Nextval INTO l_Person_Id_ FROM Dual;
  
    INSERT INTO Person
      (Person_Id, Last_Name, First_Name, Birthday, Persex, Last_Change, Patronymic, Pat)
    VALUES
      (l_Person_Id_, l_Surname, l_First_Name, l_Birthday,l_Sex_Code, SYSDATE, l_Patronymic, l_LastName);
  
    RETURN(l_Person_Id_);
    
 END CreatePerson;
 



-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Update_person( p_user_id NUMBER, p_affair_id NUMBER, p_person_id NUMBER, p_json varchar2)     return varchar2
is 
 BEGIN
    return null;
 END Update_person;
 


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки
        
         
function CreatePasportData( p_user_id NUMBER, p_json varchar2)     return varchar2
is 
    l_Person_Id_ NUMBER;
    l_Doc_Type_ NUMBER;
    l_Doc_Series_ CHAR(200);
    l_Doc_Num_ CHAR(200); 
    l_Date_Enter_ DATE;
    l_How_Giving_ CHAR(200);
    l_status_ number:=0;
    l_birth_place  VARCHAR2(200);
    l_Pasport_Kais_Id NUMBER;
    l_status Number;
  BEGIN
    --актуальность документа   
     select decode(nvl(l_status_,0), 0, 2,l_status_) into l_status from dual;
                  
      --если актуальный бокумент, то все остальные не актульные
    if  (l_status=1) then
       update  Pasport_Data set STATUS=2 where  Person_Id=l_Person_Id_;       
       l_status:=null;
    end if;
  
    INSERT INTO Pasport_Data
      (Person_Id, Document_Type, Document_Series, Document_Num, Date_Enter, How_Giving,STATUS )
    VALUES
      (l_Person_Id_, l_Doc_Type_, l_Doc_Series_, l_Doc_Num_, l_Date_Enter_, l_How_Giving_,l_status )
    RETURNING Pasport_Kais_Id INTO l_Pasport_Kais_Id;
  
    --SELECT Pasport_Kais_Id INTO l_Pasport_Kais_Id FROM Pasport_Data WHERE Person_Id = Person_Id_;
    
      --ilonis 07.12.2016                     
    pkg_persons.set_pasport_data_attr ( l_Person_Id_   ,'birth_place',   substr(l_birth_place,1,150)    );      

  
    RETURN(l_Pasport_Kais_Id);
 END CreatePasportData;
 


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Update_Pasport_data( p_user_id NUMBER, p_person_id NUMBER , p_json varchar2)     return varchar2
is 
 BEGIN
    return null;
 END Update_Pasport_data;
 

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Update_Privilege_Document( p_user_id NUMBER, p_person_id NUMBER , p_json varchar2)     return varchar2
is 
 BEGIN
    return null;
 END Update_Privilege_Document;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Update_ApartmentRooms( p_user_id NUMBER, p_affair_id NUMBER , p_json varchar2)     return varchar2
is 
 BEGIN
    return null;
 END Update_ApartmentRooms;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Update_Person_Relation_Data( p_user_id NUMBER, p_person_id NUMBER , p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END Update_Person_Relation_Data;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateStageDeclaration(  p_affair_id NUMBER, p_doc_date varchar2, p_doc_num varchar2 )   return varchar2
is 
 BEGIN
 
    if (trim(p_doc_date)='') then
        return 'Не указана дата распоряжения об аннулировании!';
    end if;
  
    if (trim(p_doc_num)='') then
        return 'Не указан номер распоряжения об аннулировании!';
    end if;
 
    return   PKG_RSM2.announ_to_affair_1 (p_affair_id
                                                       ,p_doc_num       
                                                       ,p_doc_date  
                                                          );
 
  END UpdateStageDeclaration;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание : аннулирование заявления     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelDeclaration(  p_affair_id NUMBER )   return varchar2
is 
 BEGIN
 
    del_announ_1( p_affair_id);
    delete_affair_1 ( p_affair_id, kurs3_var.global_okrug_id);
    commit;
    return null;
 END CancelDeclaration;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateDeclDate( p_user_id NUMBER, p_affair_id NUMBER , p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END UpdateDeclDate;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateAffairActualDate( p_user_id NUMBER, p_affair_id NUMBER , p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END UpdateAffairActualDate;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateAffairCategory( p_user_id NUMBER, p_affair_id NUMBER , p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END UpdateAffairCategory;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateAffairGroup ( p_user_id NUMBER, p_affair_id NUMBER , p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END UpdateAffairGroup;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateAffairVidType ( p_user_id NUMBER, p_affair_id NUMBER , p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END UpdateAffairVidType;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelAffair(  p_affair_id NUMBER, p_doc_date varchar2, p_doc_num varchar2, p_reason number )   return varchar2
is 
 BEGIN
    --проверка входных параметров
    if (nvl(p_reason,0)=0) then
        return 'Не указана причина аннулирования!';
    end if;
 
    if (trim(p_doc_date)='') then
        return 'Не указана дата распоряжения об аннулировании!';
    end if;
  
    if (trim(p_doc_num)='') then
        return 'Не указан номер распоряжения об аннулировании!';
    end if;
 
    return   set_affair_reason2 (p_affair_id
                                                       ,p_reason       
                                                       ,p_doc_date  
                                                       ,  NULL
                                                       ,p_doc_num   );
 
 END CancelAffair;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CreateOrder( p_user_id NUMBER, p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END CreateOrder;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :   издание проекта выписки  и оформление выписки  
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CreateOrderRelease ( p_order_id number, p_doc_date varchar2:=null, p_doc_num varchar2:=null, 
                                                                            p_doc_Type number:=null, p_s_calac number:=null  )   return varchar2
is 
    l_code_ number;
    l_order_stage number;
    l_error varchar2(100);
    
    l_order orders%rowtype;
    l_docType  number;--тип распоряжения
    l_docdate date;
    l_docnum varchar2(25);
    l_s_calac number; --статья учета
    l_year number; --год учета
    l_young number; --признак молодой семьи
      
 BEGIN
      begin
        select * into l_order  from orders o where O.ORDER_ID=p_order_id;
    exception when no_data_found then
        return 'Не удалось найти выписку ид='||p_order_id;        
    end;        
 
    --статья учета
   l_s_calac:= p_s_calac;
   l_year:= l_order.year;
   l_young:=l_order.order_young;
 
    --че распоряженние
    l_docType :=p_doc_Type;
    if (l_order.order_stage in (1)) then   
         l_docType :=l_order.resolution_type   ;     
         --статья учета              
         l_s_calac:=l_order.s_calculation;
    end if;
     
    if l_docType is null then
        return 'Укажите тип распоряжения';
    end if;

    if l_s_calac is null then
        return 'Укажите статью учета';
    end if;

    --номер и дата
    begin
        l_docdate:=TO_DATE (p_doc_date, 'dd.mm.yyyy');
        l_docnum:=p_doc_num;
        if (l_order.order_stage in (1)) then   
            l_docdate :=l_order.resolution_date   ;
            l_docnum :=l_order.resolution_num   ;        
        end if;
    
        IF (TRIM(l_docnum) is null) OR (TRIM (REPLACE (l_docdate, '.', '')) IS NULL) THEN
              return 'Введите и номер и дату распоряжения!';
        END IF;
        
       IF (l_docdate > TRUNC (SYSDATE, 'dd')) AND (l_docdate <= TO_DATE('01.01.1970','dd.mm.yyyy')) then
            return  'Дата распоряжения введена неверно!';  
       end if;
          
    EXCEPTION
             WHEN OTHERS THEN
                    return  'Дата распоряжения введена неверно!';  
    end;       
    
    
    --издание сохраненого проекта выписки(stage=1)
    if (l_order.order_stage in (0)) then
                  
         KURS3.SET_PORDER( p_order_id, l_docnum,  l_docdate, l_code_, l_docType);
        if (l_code_<>0) then
         return  'Ошибка при  издании проекта выписки ';
        end if;
         
    end if;
    
    --первод в статус выписки (stage-2)
    if (l_order.order_stage in (1)) then         
        KURS3.TEST_PORDER_TO( p_order_id, l_code_, l_young);
        if (l_code_<>0) then
         return  'Ошибка при оформлении выписки ';
        end if;
        KURS3.PORDER_TO_ORDER( p_order_id, l_docnum, l_docdate, l_s_calac, l_year, l_young );
    end if;
    
    commit;
    
    return null;
    
 EXCEPTION
    WHEN OTHERS THEN
      rollback;
      return replace(replace(regexp_replace(dbms_utility.format_error_stack(), 'ORA-\d+:\s+', ''), chr(13), ''), chr(10), '');
 
 END CreateOrderRelease;
 
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :   анулирование издаого проекта выписеиЮ выписки  
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelOrder(  p_order_id number, p_docDate varchar2:=null, p_docNom varchar2:=null, p_reason number:=null )   return varchar2
is 
    l_docdate date;
    l_code_ number;
    l_order_stage number;
    l_zerodate date:=sysdate;
    l_reason number:=2;--ошибка ввода
    l_error varchar2(100);
 BEGIN
 
    begin
        select nvl(o.order_stage,0) into l_order_stage  from orders o where O.ORDER_ID=p_order_id;
    exception when no_data_found then
        return 'Не удалось найти выписку ид='||p_order_id;        
    end;        
 
    --причина
    l_reason:=p_reason;
    
    if (l_order_stage in (0)) then   
         l_reason :=2;        
    end if;
    
    --проверка на заполнение
     if (nvl(l_reason,0) =0) then   
          return 'Необходимо указать причину аннулирования'; 
    end if;
    
    --сохраненный проект
    --изданный проект
    if (l_order_stage in (1,2)) then
         IF (TRIM(p_docNom) is null) OR (TRIM (REPLACE (p_docDate, '.', '')) IS NULL) THEN
              return 'Введите и номер и дату РП об аннулировании выписки!';
        END IF;
     
        begin       
            l_docdate := TO_DATE (p_docDate, 'dd.mm.yyyy');
             
            IF (l_docdate <= TRUNC (SYSDATE, 'dd')) AND (l_docdate >= TO_DATE('01.01.1970','dd.mm.yyyy')) THEN
        
                 IF (pkg_orders.get_orders_ext_data_ver (p_order_id, 87) = 0) THEN
                     pkg_orders.orders_ext_data_add (p_order_id, 87, p_docNom);
                ELSE
                     pkg_orders.orders_ext_data_modify (p_order_id, 87, p_docNom, 0);        
                END IF;

                IF (pkg_orders.get_orders_ext_data_ver (p_order_id, 88) = 0) THEN
                     pkg_orders.orders_ext_data_add (p_order_id, 88, l_docdate);
                ELSE
                     pkg_orders.orders_ext_data_modify (p_order_id, 88, l_docdate, 0);        
                END IF;
             
            ELSE
                   return  'Дата введена неверно!';  
            END IF; 
        
        EXCEPTION
             WHEN OTHERS THEN
                    return  'Дата введена неверно!';  
        end;               
    end if;

    if (l_order_stage in (1.2)) then   
        l_reason:=p_reason;
    end if;
                
    l_zerodate:=SYSDATE;
      
    if (l_order_stage in (0,1)) then              
        KURS3.DELETE_PORDER(p_order_id, l_reason, l_zerodate, 0, l_code_);
    end if;
    
   --выписка 
    if (l_order_stage = 2 ) then              
        KURS3.DELETE_PORDER(p_order_id, l_reason, l_zerodate, 0, l_code_);
    end if;
         
     if (l_code_<>0) then
     
        select case when (l_order_stage =0) then 'проекта выписки!'
          when (l_order_stage =1) then 'изданного проекта выписки!'
          when (l_order_stage =2) then 'выписки!' end into  l_error 
         from dual;
     
         return  'Ошибка при аннулировании '|| l_error;
     end if;
    
    return null;
 END CancelOrder;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Create_Certificate ( p_user_id NUMBER,   p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END Create_Certificate;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Update_Certificate_Release ( p_user_id NUMBER,   p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END Update_Certificate_Release;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Cancel_Certificate ( p_user_id NUMBER,   p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END Cancel_Certificate;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CreateUpdateInstruction(  
                                         p_free_space_id number
                                        ,p_instruction_date varchar2
                                        ,p_department_to varchar2
                                        ,p_num_in_department_to varchar2
                                        ,p_target number
                                        ,p_direction number
                                        ,p_year number 
                                        ,p_s_delivery number
                                        ,p_s_calculation number
                                        ,p_fund number
                                        ,p_basis varchar2
                                        ,p_addenum varchar2
                                       )   return varchar2
is 
    l_instruction_date date;
    l_crpi   city_reg_plan_index%rowtype;
    l_free_space free_space%rowtype;
    l_instruction_signature number;
    l_instruction_num instruction.instruction_num%type:= null;       
    l_document_type number:=1;
    l_total_space number;
    l_apartment apartment%rowtype;
    
    l_instruction_date_prev  date;
    l_count number;
    l_freespace_id_new number;
    
    l_room_space   room.room_space%type; 
    l_rooms rooms_cnt1.rooms%type; 
    l_room_count number;     
      
    l_room_space_p   room.room_space%type; 
    l_rooms_p rooms_cnt1.rooms%type; 
    l_room_count_p number;
    
    l_freespace_id_new_ number;
     
 BEGIN
 
      --проверка на возможность создания ф4
      begin
            select fs.* into  l_free_space from free_space fs where FS.FREESPACE_ID=p_free_space_id and last=1;
      exception when no_data_found then
            return 'Не удалось найти площадь';
       end;
       
       if ( l_free_space.status<>1 )   or ( NVL(l_free_space.doc2_num, 0) <> 0)  then
            return 'Площадь должна быть свободна';
       end if;
       
       --параметры площади
        begin
            select ap.* into l_apartment
            from APARTMENT ap 
            where ap.apart_id = l_free_space.apart_id;
        exception
         when no_data_found then  
               return 'Жилплощадь не найдена. Apart_id='|| to_char(  l_free_space.apart_id);
        end;
                        
      
      --проверка по упп
       --get_possible_upp(:D_TO, :F_TO, :D_WHO, :F_WHO, :FUND_, :NEW_BUILD, :ALL_, :POSSIBLE_UPP);
      
      /* SELECT COUNT(*) INTO ch
        FROM REG_PLAN_INDEX
        WHERE Test_N_V_2_Template_No_All(d_who, department_who) = 1
        AND Test_N_V_2_Template_No_All(d_to, department_to) = 1
        AND Test_N_V_2_Template_No_All(f_who, factory_who) = 1
        AND Test_N_V_2_Template_No_All(f_to, factory_to) = 1     
        AND  NVL(DELETED,0)=0;
     
      SELECT 50 + ROWNUM o_num
                        FROM type_orders
                        WHERE ROWNUM <= DECODE(INSTR(in_v_ch, 'OO'), 0, 1, 11 )*/
       -- direction_target 
        
        
       --проверка по УПП
        begin  
        
            select * into    l_crpi
            from city_reg_plan_index crpi
            where  crpi.status=1 and CRPI.DOCUMENT_TYPE=1 
            and CRPI.DEPARTMENT_WHO=l_free_space.DEPARTMENT
            and CRPI.NUM_IN_DEPARTMENT_WHO=l_free_space.NUM_IN_DEPARTMENT
            and CRPI.DEPARTMENT_TO=p_department_to
            and CRPI.NUM_IN_DEPARTMENT_TO=p_num_in_department_to
            and CRPI.FUND=p_fund
            and CRPI.TARGET=p_target
            and CRPI.DIRECTION=p_direction
            and  s_del_calc=p_s_delivery;
                              
        exception 
            when NO_DATA_FOUND then
                    return 'Отсутствует путь предачи в таблице "city_reg_plan_index" ';                
            when TOO_MANY_ROWS then        
                return 'Неоднозначно определен путь предачи в таблице "city_reg_plan_index" ';
        end; 
 
       --дата распоряжения должна быть текущая
       l_instruction_date:=trunc(sysdate);
   
       --формирование номера  
       l_instruction_num := Get_Next_Instr_Num;    
       
       if ( to_number (to_char ( l_instruction_date, 'YYYY')) <  trunc ( l_instruction_num / 10000000) + 1900 )then 
            return 'Дата издания распоряжения не соответствует номеру!';
       end if;
     --DECODE (fs.doc_type, 1, fs.doc_num, NULL)

    --  проверка на соответствие даты предыдущему распоряжению
         begin
            select instruction_date  into  l_instruction_date_prev  from instruction   where instruction_num = DECODE (l_free_space.doc_type, 1, l_free_space.doc_num, NULL) ;

            if ( l_instruction_date_prev > l_instruction_date ) then   
               return 'Дата издания распоряжения меньше даты предшествующего распоряжения!';
            end if;
            
         exception
             when no_data_found then
                null;
         end;
         
        --подпись 
       l_instruction_signature:= PKG_INSTRUCTION.get_instruction_signature(  l_free_space.DEPARTMENT, l_free_space.NUM_IN_DEPARTMENT );
      
       --создаем документ
        INSERT INTO DOCUMENTS  (document_num, document_type) VALUES  (l_instruction_num,  l_document_type );
        
         INSERT INTO DOCUMENT
             (building_id, apart_id, document_num, document_type, last_change, all_rooms)
        VALUES
             ( l_free_space.building_id , l_free_space.apart_id,   l_instruction_num, l_document_type,  SYSDATE,   case when ( l_free_space.space_type   in (1, 3) )  then 1 else 0 end);

        INSERT INTO ROOM_DOCUMENT
             (building_id, apart_id, document_num, document_type, room_num)
               SELECT l_free_space.building_id , l_free_space.apart_id,  l_instruction_num, l_document_type, room_num   FROM ROOM
                                          WHERE ROOM.apart_id =  l_free_space.apart_id AND ROOM.free_space_id = l_free_space.freespace_id;

         --    Вычисление приведенной площади в случае коммунальной квартиры
         IF ( l_free_space.space_type not  in (1, 3) ) THEN
            l_total_space := TRUNC(  l_apartment.total_space * l_free_space.living_sq / l_apartment.living_space, 1);
            END IF;
      
        --создаем распоряжение      
         INSERT INTO INSTRUCTION
                    (instruction_num,
                     instruction_date,
                     department_who,
                     num_in_department_who, 
                     department_to ,
                     num_in_department_to,
                     new_building_code,
                     YEAR,
                     building_id,
                     reducted_space,
                     living_space,
                     is_apartment,
                     is_office,
                     AREA,
                     last_change,
                     okrug_id,
                     s_calculation, --Статья учета    
                     s_delivery,  --Статья передачи
                     fund,
                     target,
                     direction,
                     signature2_id, ADDENUM, BASIS  )
            VALUES ( l_instruction_num,
                     l_instruction_date,  
                     l_free_space.department,
                     l_free_space.num_in_department,
                     p_department_to,
                     p_num_in_department_to,
                     l_free_space.new_building_code,
                     TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),
                     l_free_space.building_id,
                     l_total_space,
                     l_free_space.living_sq,
                     case when ( l_free_space.space_type   in (1, 3) )  then 1 else 2 end,
                     0,
                     NVL(Get_Factory_Registration_1( p_department_to, p_num_in_department_to ), 61), --округ кому
                     SYSDATE,
                     l_free_space.okrug_id,  --где находилось площадь окркг
                     p_s_calculation,     
                     p_s_delivery,
                     p_fund,
                     p_target,
                     p_direction,
                     l_instruction_signature,p_basis,p_addenum  );       
                     
                     -- к передаче распоряжением                                 
            update FREE_SPACE  set status = 5 
                                    ,doc2_num =  l_instruction_num
                                    ,doc2_type =  l_document_type
             where freespace_id = l_free_space.freespace_id;                     
       
        /* 
          --комуналтка, комнаты в квартире
         IF ( l_free_space.space_type not  in (1, 3) ) THEN      
         
           select count (*)    into l_count 
           from (
                    select room.room_num
                    from room
                    where room.apart_id = l_free_space.apart_id and room.free_space_id = l_free_space.freespace_id
                    minus
                    select room_document.room_num
                    from room_document
                    where room_document.document_num =l_instruction_num and room_document.document_type = 1);
               
            IF  (l_count = 0) THEN -- все свободные комнаты квартиры    
            
                SELECT seq_free_space.NEXTVAL INTO  l_freespace_id_new FROM DUAL;

                INSERT INTO free_space (
                                freespace_id
                               ,building_id
                               ,department
                               ,num_in_department
                               ,inspector
                               ,new_building_code
                               ,doc_num
                               ,rooms_number
                               ,doc_type
                               ,rooms
                               ,apart_id
                               ,space_type
                               ,doc2_num
                               ,living_sq
                               ,doc2_type
                               ,status
                               ,last_change
                               ,sstatus
                               ,document_date
                               ,document_date2
                               ,rooms2
                               ,okrug_id
                               ,LAST
                               ,remaind_year
                               ,apart_id2
                               )
                        SELECT  l_freespace_id_new
                                    ,building_id
                                    ,p_department_to
                                    ,p_num_in_department_to
                                    ,NULL
                                    ,new_building_code
                                    ,l_instruction_num
                                    ,rooms_number
                                    ,1
                                    ,rooms
                                    ,apart_id
                                    ,space_type
                                    ,NULL
                                    ,living_sq
                                    ,NULL
                                    ,1  --   ,STATUS
                                    ,SYSDATE
                                    ,sstatus
                                    ,SYSDATE
                                    ,NULL
                                    ,0
                                    ,get_factory_registration_1 (p_department_to, p_num_in_department_to) --кому округ    
                                    ,1
                                    ,remaind_year
                                    ,apart_id2
                        FROM free_space
                        WHERE freespace_id =l_free_space.freespace_id;

                        --  Исправление предыдущих записей с LAST=2
                        UPDATE free_space   SET LAST   = 0
                            WHERE LAST = 2 
                                    AND okrug_id = get_factory_registration_1 (p_department_to, p_num_in_department_to)        
                                    AND apart_id = l_free_space.apart_id;

                        -- замена "к передаче" на "передано"
                        UPDATE free_space   
                                 SET document_date2   = l_instruction_date
                                       ,last_change      = SYSDATE
                                       ,rooms2           = rooms
                                       ,LAST             = DECODE (okrug_id, get_factory_registration_1 (p_department_to, p_num_in_department_to), 0, 2) ,-- если в другой округ, то 2  
                                       status           = 3 -- передано
                        WHERE freespace_id = l_free_space.freespace_id AND free_space.status = 5   AND doc2_type = 1;

                        -- исправление пометок свободных комнат
                        UPDATE room   SET free_space_id   = l_freespace_id_new
                        WHERE apart_id = l_free_space.apart_id AND free_space_id =  l_free_space.freespace_id;
                                                                    
                        --- объединение записей FREE_SPACE!!!
                        change_free_space_join (  l_freespace_id_new );   
                        
                        --привязка к номеру горпрограммы и году
                        PKG_INSTRUCTION.create_fs_city_prog( l_freespace_id_new, l_crpi.cp_num );
                         
            else    -- часть комнат квартиры 
                        
                --те которые в распоряжении
                 SELECT
                         SUM ( r.room_space ),
                         COUNT( * ),
                         SUM ( rc.rooms )
                 INTO 
                        l_room_space,
                        l_room_count,
                        l_rooms
                 FROM room r, rooms_cnt1 rc
                 WHERE  r.apart_id = l_free_space.apart_id
                            AND r.room_num = rc.room_num
                            AND r.room_num IN (
                                                                SELECT room_num FROM room
                                                                WHERE room.apart_id = l_free_space.apart_id AND room.free_space_id =l_free_space.freespace_id
                                                                INTERSECT
                                                                SELECT room_document.room_num   FROM room_document
                                                                WHERE room_document.document_num = l_instruction_num AND room_document.document_type = 1);

                l_room_space_p:= l_room_space;
                l_room_count_p:=l_room_count;
                l_rooms_p:=l_rooms;
                -- room_n_p   := room_n;
               -- rs_p       := rs;
               -- liv_sp_p   := liv_sp;

                SELECT seq_free_space.NEXTVAL INTO l_freespace_id_new FROM DUAL;

                --
                INSERT INTO free_space (
                               freespace_id
                               ,building_id
                               ,department
                               ,num_in_department
                               ,inspector
                               ,new_building_code
                               ,doc_num
                               ,rooms_number
                               ,doc_type
                               ,rooms
                               ,apart_id
                               ,space_type
                               ,doc2_num
                               ,living_sq
                               ,doc2_type
                               ,status
                               ,last_change
                               ,sstatus
                               ,document_date
                               ,document_date2
                               ,rooms2
                               ,okrug_id
                               ,LAST
                               ,remaind_year
                               ,apart_id2
                               )
                    SELECT l_freespace_id_new
                            ,building_id
                            ,p_department_to
                            ,p_num_in_department_to
                            ,NULL
                            ,new_building_code
                            ,l_instruction_num
                            ,l_room_count
                            ,1
                            ,l_rooms
                            ,apart_id
                            ,DECODE (space_type,  1, 2,  3, 2,  space_type)
                            ,NULL
                            ,l_room_space
                            ,NULL
                            ,1--     STATUS
                            ,SYSDATE
                            ,sstatus
                            ,SYSDATE
                            ,NULL
                            ,0
                            ,get_factory_registration_1 (p_department_to, p_num_in_department_to)   
                            ,1
                            ,remaind_year
                            ,apart_id2
                    FROM free_space fre
                    WHERE fre.freespace_id = l_free_space.freespace_id;

                --  Исправление предыдущих записей с LAST=2
                UPDATE free_space    SET LAST   = 0
                WHERE   LAST = 2
                             AND okrug_id = get_factory_registration_1 (p_department_to, p_num_in_department_to)    
                            AND apart_id = l_free_space.apart_id
                            AND rooms =  l_rooms;
                                                          
                --те которые не включены в распоряжение            
                SELECT SUM (room.room_space),
                            COUNT (*),
                            SUM (rooms_cnt1.rooms)
                INTO l_room_space,
                        l_room_count,
                        l_rooms
                FROM room, rooms_cnt1
                WHERE     room.apart_id =  l_free_space.apart_id
                AND room.room_num = rooms_cnt1.room_num
                AND room.room_num IN (SELECT room.room_num
                                       FROM room
                                      WHERE room.apart_id = l_free_space.apart_id AND room.free_space_id = l_free_space.freespace_id
                                     MINUS
                                     SELECT room_document.room_num
                                       FROM room_document
                                      WHERE room_document.document_num = l_instruction_num AND room_document.document_type = 1);

                SELECT seq_free_space.NEXTVAL INTO  l_freespace_id_new_    FROM DUAL;

                --
                INSERT INTO free_space (freespace_id
                               ,building_id
                               ,department
                               ,num_in_department
                               ,inspector
                               ,new_building_code
                               ,doc_num
                               ,rooms_number
                               ,doc_type
                               ,rooms
                               ,apart_id
                               ,space_type
                               ,doc2_num
                               ,living_sq
                               ,doc2_type
                               ,status
                               ,last_change
                               ,sstatus
                               ,document_date
                               ,document_date2
                               ,rooms2
                               ,okrug_id
                               ,LAST
                               ,remaind_year
                               ,apart_id2
                               )
                SELECT l_freespace_id_new_
                ,building_id
                ,department
                ,num_in_department
                ,NULL
                ,new_building_code
                ,doc_num
                ,l_room_count
                ,doc_type
                ,l_rooms
                ,apart_id
                ,DECODE (space_type,  1, 2,  3, 2,  space_type)
                ,NULL
                ,l_room_space
                ,NULL
                ,1 --FRE.STATUS
                ,SYSDATE
                ,sstatus
                ,document_date
                ,NULL
                ,0
                ,okrug_id
                ,1
                ,remaind_year
                ,apart_id2
                FROM free_space fre
                WHERE fre.freespace_id = l_free_space.freespace_id ;
                         
                -- замена "к передаче" на "передано"
                UPDATE free_space 
                                        SET document_date2   = l_instruction_date
                                        ,last_change  = SYSDATE
                                        ,rooms       =l_rooms_p
                                        ,rooms_number     =l_room_count_p
                                        ,living_sq       = l_room_space_p
                                        ,space_type   = DECODE (space_type,  1, 2,  3, 2,  space_type)         
                                        ,LAST   = DECODE (okrug_id, get_factory_registration_1 (p_department_to, p_num_in_department_to), 0, 2),-- если в другой округ, то 2
                                        status  = 3 -- передано
                    WHERE freespace_id =l_free_space.freespace_id 
                                AND status = 5 -- к передаче
                                AND doc2_type = 1;

                -- исправление типа квартиры
                UPDATE apartment  SET space_type   = 2
                WHERE apartment.apart_id = l_free_space.apart_id AND apartment.space_type IN (1, 3);

                -- исправление пометок свободных комнат
                UPDATE room    SET room.free_space_id   =l_freespace_id_new
                WHERE     room.apart_id = l_free_space.apart_id
                                AND room.free_space_id =l_free_space.freespace_id
                                AND room.room_num IN (
                                                                    SELECT room_document.room_num
                                                                    FROM room_document
                                                                    WHERE room_document.document_num = l_instruction_num 
                                                                            AND room_document.document_type = 1
                                                                     );

                UPDATE room
                SET room.free_space_id   = l_freespace_id_new_
                WHERE     room.apart_id = l_free_space.apart_id
               AND room.free_space_id =l_free_space.freespace_id
               AND room.room_num NOT IN (SELECT room_document.room_num
                                           FROM room_document
                                          WHERE room_document.document_num = l_instruction_num AND room_document.document_type = 1);
                                                                              
                --- объединение записей FREE_SPACE!!!                                           
               change_free_space_join ( l_freespace_id_new );       
               
               --привязка к номеру горпрограммы и году
              PKG_INSTRUCTION.create_fs_city_prog( l_freespace_id_new,  l_crpi.cp_num );
            
            end if;  
            
        ELSE -- квартира целиком                     
 
            -- создаем новую запись
            SELECT seq_free_space.NEXTVAL INTO  l_freespace_id_new FROM DUAL;

            INSERT INTO free_space (
                              freespace_id
                             ,building_id
                             ,department
                             ,num_in_department
                             ,inspector
                             ,new_building_code
                             ,doc_num
                             ,rooms_number
                             ,doc_type
                             ,rooms
                             ,apart_id
                             ,space_type
                             ,doc2_num
                             ,living_sq
                             ,doc2_type
                             ,status
                             ,last_change
                             ,sstatus
                             ,document_date
                             ,document_date2
                             ,rooms2
                             ,okrug_id
                             ,LAST
                             ,remaind_year
                             ,apart_id2
                             )
                    SELECT 
                         l_freespace_id_new
                        ,building_id
                        ,p_department_to
                        ,p_num_in_department_to
                        ,NULL
                        ,new_building_code
                        ,l_instruction_num
                        ,rooms_number
                        ,1
                        ,rooms
                        ,apart_id
                        ,space_type
                        ,NULL
                        ,living_sq
                        ,NULL
                        ,1 --FRE.STATUS
                        ,SYSDATE
                        ,sstatus
                        ,SYSDATE
                        ,NULL
                        ,0
                        ,get_factory_registration_1 (p_department_to, p_num_in_department_to)  
                        ,1
                        ,remaind_year
                        ,apart_id2
            FROM free_space 
            WHERE freespace_id = l_free_space.freespace_id;

            -- исправление пометок свободных комнат
            UPDATE room  SET room.free_space_id   = l_freespace_id_new
            WHERE room.apart_id = l_free_space.apart_id;

            --  Исправление предыдущих записей с LAST=2
            UPDATE free_space   SET LAST   = 0
            WHERE     free_space.LAST = 2
                AND free_space.okrug_id = get_factory_registration_1 (p_department_to, p_num_in_department_to)   
                AND free_space.apart_id = l_free_space.apart_id;

            -- замена "к передаче" на "передано"
            UPDATE free_space
                 SET document_date2   =  l_instruction_date
                        ,last_change      = SYSDATE
                        ,rooms2           = rooms
                        ,LAST             = DECODE (free_space.okrug_id, get_factory_registration_1 (p_department_to, p_num_in_department_to), 0, 2),-- если в другой округ, то 2   
                        status           = 3 -- передано
            WHERE free_space.freespace_id = l_free_space.freespace_id AND free_space.status = 5  AND free_space.doc2_type = 1;     
            
            --привязка к номеру горпрограммы и году
            PKG_INSTRUCTION.create_fs_city_prog( l_freespace_id_new,  l_crpi.cp_num );

         end if;            
                                    
        --дата документа
        UPDATE free_space  SET document_date   = l_instruction_date
        WHERE free_space.doc_num =  l_instruction_num AND free_space.doc_type = 1;
   
        -- возврат переданной площади в свободную
        UPDATE free_space
                    SET doc2_num = NULL, doc2_type = NULL, document_date2 = NULL, last_change = SYSDATE, status = 1 -- свободная
        WHERE free_space.doc2_num = l_instruction_num AND free_space.status = 5  AND free_space.doc2_type = 1;
        
                     
        --передача в KURSIV                                                                                                                                                             
        begin
             EXEC_SQL( 'begin KURSIV.KURS3_EXCHANGE.INSTRUCTION_EXCHANGE('||TO_CHAR(l_instruction_num)||');end;' );
        exception   
        when OTHERS then
            rollback;
             return 'Ошибка при запси в KURSIV! INSTRUCTION_NUM='||TO_CHAR(l_instruction_num)||'.'||TO_CHAR(SQLCODE)||' '||SQLERRM(SQLCODE);
        end;
        commit;
        */
        return null; 
        
 END CreateUpdateInstruction;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :   Изданне проекта выписки ф4  
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateInstructionRelease (  p_instruction_id number, p_instruction_date date )   return varchar2
is 
 BEGIN
    return set_instr (  p_instruction_id,  p_instruction_date  ) ;
 END UpdateInstructionRelease;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     аннулироване проекта Ф4
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelInstruction (  p_instruction_id number )   return varchar2
is 
 BEGIN
    return Delete_instr_1(  p_instruction_id );
 END CancelInstruction;
 

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateCompensation  (p_user_id NUMBER,  p_subs_id  NUMBER, p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END UpdateCompensation;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
 
function SetSubvention ( p_user_id NUMBER,   p_affair_id NUMBER , p_json varchar2)   return varchar2
is 
 c integer := 0;
 i integer;
 s_result varchar2(2000);
 i_result number := 0;
 del_list_str varchar2(2000) := NULL;
 
 l_number  number;
 l_string  varchar2(2000); 
 l_date    date; 
 l_bool    boolean;
 l_err     varchar2(2000) := NULL;
  
  subv_id        NUMBER :=0;
  affair_id      NUMBER :=0;
  order_id       NUMBER(9);
  subv_status    NUMBER(4):=1;
  fin_status     NUMBER(4) := 1;
  reg_year       NUMBER(4);
  reg_quarter    NUMBER(1):=0;
  dog_date       DATE;
  apart_cost     NUMBER(9):=0;
  fed_budget_sum NUMBER(9):=0 ;
  subv_userid    NUMBER ;
 -- last_change    DATE default sysdate not null,
  comments       VARCHAR2(250):='';
  soc_help_type  NUMBER(4):=1;
 
-- SUBVENTION_PERSON
--------
  person_id      NUMBER(9);
  lgota_id       NUMBER(8);
  main_person    NUMBER(1);
  first_ref_date DATE;
  fed_law_num    NUMBER(4) ;
--------   
    jv genix_view.json_value :=  genix_view.json_value.makenull;
    JL genix_view.json_list;
    JO genix_view.json;
 BEGIN
   s_result :=  Set_Global_Var( p_user_id ) ;
   if (s_result is not NULL) then
       s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, s_result, 'PKG_RSM2.Set_Global_Var',TO_CHAR(p_user_id));
      return (s_result); 
    end if; 
        
   JO := genix_view.json(p_json); 
        
    affair_id := genix_view.PKG_K3_UTILS.get_number_from_json(p_json,'affair_id');
    if NVL(affair_id,0) < 1 then
      s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, 'Нет кода КПУ', 'PKG_RSM2.Set_Subvention',TO_CHAR(p_affair_id));
      return (s_result); 
    end if;
    
    subv_id := NVL(genix_view.PKG_K3_UTILS.get_number_from_json(p_json,'subv_id'),0);
    
  -- люди -----------------    
     if  JO.exist('Persons') then
        jv := genix_view.json_ext.get_json_value( JO, 'Persons');
        if (not genix_view.json_ac.jv_is_null(jv)) then
          if  (genix_view.json_ac.jv_is_array(jv)) then
                    JL :=  genix_view.json_list(jv); 
                    c :=  genix_view.json_ac.array_count(JL); 
           end if;
        end if;
      end if; 
     
      if (subv_id = 0) and (c = 0)then
            s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, 'Нет людей в cубвенции', 'PKG_RSM2.Set_Subvention',TO_CHAR(subv_id));
           return (s_result);     
       end if;  
      
 if c > 0 then  
                --  список person_id на удаление из субв.
       if subv_id > 0 then
          with A as ( 
          select TO_CHAR(sp.person_id) as s_name 
           from subvention_person sp
          where sp.subv_id = subv_id
            ) 
          select substr(extract(xmlagg(xmlelement("X", ', ' ||  substr(a.s_name,instr(a.s_name,'*')+1,length(a.s_name)))), 'X/text()').getstringval(), 2) 
          into del_list_str from A;
        end if;  
     
        l_string :=genix_view.json_ac.array_to_char(JL,false);
        
     For i in 1..c 
     loop 
          jv := genix_view.PKG_K3_UTILS.get_json_value_from_list_i(l_string,'person_id' ,i);
          if (genix_view.json_ac.jv_is_null(jv)) or (not genix_view.json_ac.jv_is_number(jv)) then 
             s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, 'Нет секци кода person_id ', 'PKG_RSM2.Set_Subvention',TO_CHAR(subv_id));
             return (s_result);
          end if;
          person_id :=NVL( genix_view.json_ac.jv_get_number(jv),0);
       
          if (person_id=0) then 
             s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, 'Нет кода person_id ', 'PKG_RSM2.Set_Subvention',TO_CHAR(subv_id));
             return (s_result);
          end if;
          
          if (del_list_str is not null) then
             del_list_str := REPLACE(del_list_str,to_char(person_id),'');
          end if;
          
          
          jv := genix_view.PKG_K3_UTILS.get_json_value_from_list_i(l_string,'lgota_id' ,i);
          if (genix_view.json_ac.jv_is_null(jv)) or (not genix_view.json_ac.jv_is_number(jv)) then 
             s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, 'Нет кода льготы', 'PKG_RSM2.Set_Subvention',TO_CHAR(subv_id));
             return (s_result);
          end if;
          lgota_id := NVL(genix_view.json_ac.jv_get_number(jv),0);
       
          jv := genix_view.PKG_K3_UTILS.get_json_value_from_list_i(l_string,'main_person' ,i);
          if (genix_view.json_ac.jv_is_null(jv)) or (not genix_view.json_ac.jv_is_number(jv)) then 
             main_person :=0 ;
          else
             main_person := NVL(genix_view.json_ac.jv_get_number(jv),0);  
          end if;
         
          jv := genix_view.PKG_K3_UTILS.get_json_value_from_list_i(l_string,'first_ref_date' ,i);
          if (genix_view.json_ac.jv_is_null(jv)) or (not genix_view.json_ext.is_date(jv)) then 
             s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, 'Нет секции даты первой справки', 'PKG_RSM2.Set_Subvention',TO_CHAR(subv_id));
             return (s_result);
          end if; 
          first_ref_date := TO_DATE(genix_view.json_ac.jv_get_string(jv),'DD.MM.YYYY');
          
          if (first_ref_date is null) then
            s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, 'Нет даты первой справки', 'PKG_RSM2.Set_Subvention',TO_CHAR(subv_id));
            return (s_result);
          end if;  

          jv := genix_view.PKG_K3_UTILS.get_json_value_from_list_i(l_string,'fed_law_num' ,i);
          if (genix_view.json_ac.jv_is_null(jv)) or (not genix_view.json_ac.jv_is_number(jv)) then 
             s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, 'Нет секции номера ФЗ', 'PKG_RSM2.Set_Subvention',TO_CHAR(subv_id));
             return (s_result);
          end if;
          fed_law_num := genix_view.json_ac.jv_get_number(jv);
          
          if fed_law_num is null then
            s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, 'Нет номера ФЗ', 'PKG_RSM2.Set_Subvention',TO_CHAR(subv_id));
            return (s_result);
          end if; 
       
          pkg_subvention.set_subvention_personRows(subv_id, person_id, lgota_id,main_person, first_ref_date, fed_law_num,i);
          
     end loop; 
     
        reg_year := genix_view.PKG_K3_UTILS.get_number_from_json(p_json,'reg_year');
        if reg_year is null then
          s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, 'Не задан год', 'PKG_RSM2.Set_Subvention',TO_CHAR(subv_id));
          return (s_result);
        end if; 
        reg_quarter := genix_view.PKG_K3_UTILS.get_number_from_json(p_json,'reg_quarter');
        if reg_year is null then
          s_result := 'Не задан квартал';
          s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, 'Не задан квартал', 'PKG_RSM2.Set_Subvention',TO_CHAR(subv_id));         
          return (s_result);
        end if;
           
        subv_id := pkg_subvention.Run_subvention_personRows(affair_id,reg_year,reg_quarter, del_list_str);
      
        if subv_id < 1 then
           s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, 'Ошибка изменения субвенции', 'PKG_RSM2.Run_subvention_personRows',TO_CHAR(subv_id));         
           return (s_result);
        end if;
          
end if;        
 ------------order -------  
   
     order_id := genix_view.PKG_K3_UTILS.get_number_from_json(p_json,'order_id');
     dog_date := genix_view.PKG_K3_UTILS.get_date_from_json(p_json,'dog_date'); 
     comments := genix_view.PKG_K3_UTILS.get_string_from_json(p_json,'comments'); 
     
    l_number := pkg_subvention.set_subvention_order(subv_id,order_id,dog_date,comments);
-----------finans----

    apart_cost := NVL(genix_view.PKG_K3_UTILS.get_number_from_json(p_json,'apart_cost'),0);
    fed_budget_sum := NVL(genix_view.PKG_K3_UTILS.get_number_from_json(p_json,'fed_budget_sum'),0);

    l_number := pkg_subvention.set_subvention_finans(subv_id,apart_cost,fed_budget_sum);

--- status ---
  if  JO.exist('subv_status') then
      subv_status  := genix_view.PKG_K3_UTILS.get_number_from_json(p_json,'subv_status');
     if (NVL(subv_status,-1)  in  (3,4))  then
       l_number :=  pkg_subvention.set_subvention_inReport(subv_id) ;
     end if;
  end if;

s_result := genix_view.PKG_K3_UTILS.GetResultJsonStr(0,'','',to_char(subv_id));
return (s_result);
exception 
    when OTHERS then
          s_result := genix_view.PKG_K3_UTILS.GetResultJsonStr(1,SQLERRM,DBMS_UTILITY.FORMAT_ERROR_STACK || ' BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,TO_CHAR(subv_id));
          return (s_result);
          
END SetSubvention ;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : Dik
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelSubvention ( p_user_id NUMBER,   p_subv_id NUMBER )   return varchar2
is 
 s_result varchar2(2000); 
 res integer := 0;
 
 BEGIN
   s_result :=  Set_Global_Var( p_user_id ) ;
   if (s_result is not NULL) then
       s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, s_result, 'PKG_RSM2.Set_Global_Var',TO_CHAR(p_user_id));
      return (s_result); 
    end if;

res := pkg_subvention.del_subvention(p_subv_id);

if (NVL(p_subv_id,0) > 0) and (res = 0) then
    s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, 'Ошибка удаления субвенции', 'PKG_RSM2.Cancel_Subvention',TO_CHAR(p_subv_id));
 else  
    s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 0, '', '',TO_CHAR(p_subv_id));
end if;

    return (s_result);
     
END CancelSubvention;
 
----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Дата создания :
  -- Описание :     создание и аннулирование. гор программы
  -- Входные:
  -- Выходные:
function CreateUpdateGorProg(   p_id_dcr  in out  number,
                                                p_action number,
                                                p_affair_id        number,
                                                p_dос_num        varchar2,
                                                p_doc_date         varchar2,
                                                p_doc_type         number,    
                                                p_doc_notes          varchar2,
                                                p_z_type           number,
                                                p_z_date           varchar2,
                                                p_z_status         number,
                                                p_z_notes          varchar2,
                                                p_cancel_date      varchar2,
                                                p_cancel_reason    number,          
                                                p_z_cp_num_id    number,   
                                                p_z_rd_number varchar2,
                                                p_z_rd_date   varchar2
                                                  ) return varchar2
 IS
    l_count number;
  BEGIN
  
  
    --проверка на наличие 
    l_count:=PKG_DECLARATION.get_exist_declaration ( p_affair_id , p_z_cp_num_id );
    if (l_count >0) and (p_action=1) then
        return 'Данная городская программа уже добавлена';
    end if;  
    
     l_count:=PKG_DECLARATION.get_readonly  (p_affair_id, 1);
     case 
     when (l_count=112) then
        return 'КПУ закрыто';
     when (l_count=1) then
         return 'База заблокирована';
      when (l_count=133) then
         return 'Блокировка КПУ другим пользователям';    
      when (l_count=613) then
            return ' Нет  привилегии 172';
        when (l_count=101) then
             return ' Неправильное направление учета';
        when (l_count=108) then             
            return ' выдан смотровой ордер';
        when (l_count=107) then            
            return 'Ппредоставлена жилая площадь';
        when (l_count=106) then            
             return 'Передано в ордерную группу';
        when (l_count=102) then             
            return  'Cнят с учета';
        when (l_count=121) then            
            return ' Архивная копия';
        when (l_count=198) then
            return 'КПУ заблокировано';
     else              
        null;             
     end case;

    PKG_DECLARATION.update_declaration( p_id_dcr ,
                                             p_action ,
                                             p_affair_id        ,
                                             p_dос_num        ,
                                             p_doc_date         ,
                                             p_doc_type         ,    
                                             p_doc_notes          ,
                                             p_z_type           ,
                                             p_z_date           ,
                                             p_z_status         ,
                                             p_z_notes          ,
                                             p_cancel_date      ,
                                             p_cancel_reason    ,          
                                             p_z_cp_num_id    ,   
                                             p_z_rd_number ,
                                             p_z_rd_date   ,
                                            0); 
    
        commit;     
       return null;
 EXCEPTION
    WHEN OTHERS THEN
      --  l_error_txt:=l_error_txt || SQLCODE || ':' || SQLERRM;
        --    l_error_txt:=l_error_txt||';'||l_mail_err||'; ' || substr(dbms_utility.format_error_stack(),1,200);
      --RETURN 'Ошибка при создании заявления: ' || substr(dbms_utility.format_error_stack(),1,200);
      rollback;
      return replace(replace(regexp_replace(dbms_utility.format_error_stack(), 'ORA-\d+:\s+', ''), chr(13), ''), chr(10), '');
                             
    -- ins_person_to_delo_8                              
  END CreateUpdateGorProg;
  
  -----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : Dik
  -- Описание : Проверяет возможность работы с Субсидийным делом     
  -- Параметры:
  --    Входные: ID и stage КПУ (affair), p_f_num - номер элементарной семьи
  --    Выходные: 
   /*     {
  "ResultType": 0 -все хорошо 1-ошибка,
  "ResultMessage": Наименование вида обеспечения (Cубсидия / Денежная компенсация МД) или (ResultId=0) сообщение пользователю
   "ErrMessage": "Текст ошибки тех.",
  "ResultId":  Код вида обеспечения (22 - субсидия;  39 - Денежная компенсация МД ; 0 -вид обеспечения не субсидия)
  }  */  
function IsSubsid(p_user_id NUMBER, p_affair_id NUMBER, p_affair_stage NUMBER, p_f_num NUMBER) return varchar2
is 
 s_result varchar2(2000); 
 res      integer := 0;
 v_f_type NUMBER;
BEGIN 
  s_result :=  Set_Global_Var( p_user_id ) ;
  if (s_result is not NULL) then
     s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, s_result, 'PKG_RSM2.IsSubsid.Set_Global_Var',TO_CHAR(p_user_id));
   --  res:=genix_view.pkg_rsm2_gv.SaveMaessage( p_user_id, s_result, 'IsSubsid.Set_Global_Var' ); 
     return (s_result); 
  end if;
  begin 
    SELECT NVL(family_type,0)
    INTO v_f_type
    FROM  affair_plan ap
    WHERE ap.affair_id = p_affair_id  AND ap.affair_stage = p_affair_stage AND ap.family_num = p_f_num;
   exception
    when others then
       s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr(1, 'Нет в плане КПУ.', DBMS_UTILITY.FORMAT_ERROR_STACK || ' BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,'0');
    --   res:=genix_view.pkg_rsm2_gv.SaveMaessage( p_user_id, s_result, 'IsSubsid' ); 
     return (s_result);   
  end;
  if v_f_type in (PKG_DECLARATION.subsidy_code, PKG_DECLARATION.subsidy_code_md)
     then 
       select trim(cl.name) into s_result  from CLASSIFIER cl where cl.classifier_num = 11 and cl.row_num = v_f_type;
       s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr(0 ,s_result, '',TO_CHAR(v_f_type));
      else
       s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr(1 ,'Вид обеспечения не Субсидия', '','0');
  end if;     

 return (s_result);
   
  exception 
    when OTHERS then
          s_result := genix_view.PKG_K3_UTILS.GetResultJsonStr(1,SQLERRM,DBMS_UTILITY.FORMAT_ERROR_STACK || ' BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,TO_CHAR(p_affair_id)||'/'||TO_CHAR(p_f_num));
        --  res:=genix_view.pkg_rsm2_gv.SaveMaessage( p_user_id, s_result, 'IsSubsid' ); 
          return (s_result); 
             
END IsSubsid;

procedure GetSubsidForm(p_affair_id NUMBER, p_affair_stage NUMBER, p_family_type NUMBER, p_affair_plan_id NUMBER, p_cur in out SYS_REFCURSOR)
is
  l_count NUMBER := 0; 
  v_subs_id  NUMBER := 0; 
 BEGIN  
   
  --проверить, есть ли запись о субсидии
   select count(*)  into  l_count  from kurs3.affair_plan_subs WHERE affair_plan_id = p_affair_plan_id ;
   if ( l_count = 0 ) then --нет
       --проверить, есть ли заявление на гор программу
        select  count(*)  into  l_count 
        from declaration d    
             join affair_plan  ap  on ap.AFFAIR_ID=D.affair_id and  ap.affair_stage = 1  and d.affair_plan_id = ap.affair_plan_id and d.family_num=ap.family_num
             JOIN affair_queue_cpnum_type2 AQ  ON AP.FAMILY_TYPE=AQ.type2   
        where AP.FAMILY_TYPE  in (select column_value from Table(PKG_DECLARATION.subsidies_codes))
                and ap.affair_plan_id = p_affair_plan_id
                and ap.family_type = p_family_type
                and ap.affair_id  = p_affair_id;
                
       if ( l_count = 0 ) then --нет
         RAISE_APPLICATION_ERROR (-20012, 'Нет заявления на гор. программу');
       end if;           
     -- завести пустую запись о субсидии  
                insert into  kurs3.affair_plan_subs sub  ( SUB.AFFAIR_PLAN_ID, SUB.STATUS_SUB, SUB.LAST_CHANGE, AFFAIR_ID )
                values( p_affair_plan_id, 1, sysdate,  p_affair_id );
    end if;
   
    v_subs_id :=(p_affair_plan_id * 100);
   
 OPEN p_cur FOR
	SELECT  vv.sub_id as subs_id   -- ID субсидии
	       ,vv.affair_id           --ID КПУ
	       ,vv.affair_plan_id      --ID плана КПУ
		     ,vv.sub_decision_num    -- № РП о постановке на субсидии  [RP_UDS_NUM]
         ,vv.sub_decision_date   -- дата РП о постановке на субсидии       [RP_UDS_DATE]
         ,vv.sub_rs_num          -- № РП о предоставлении субсидии       [RP_SUBS_NUM]
         ,vv.sub_rs_date         --  дата РП о предоставлении субсидии           [RP_SUBS_DATE]
         ,vv.status3_num as  num_rp_remove -- № РП о снятии УДС с учета  [RP_REMOVE_NUM]
         ,vv.status3_date as date_rp_remove -- дата РП о снятии УДС с учета      [RP_REMOVE_DATE]
         ,vv.reason               -- причина снятия УДС с учета     classifier_num=123 [lcbSCANC]
         ,vv.certif_num           -- № свидетельства                     [SERTIF_NUM]
         ,vv.certif_date           -- дата свидетельства                          [SERTIF_DATE]
         ,vv.sertif_cancel_date    -- дата аннулирования свидетельства          [SERTIF_CANCEL_DATE]
         ,vv.certif_cancel_reas    -- причина аннулирования свидетельства  classifier_num=124	[lcbSeCANC]
         ,vv.z_ka_num              -- № заявки о перечислении                              [ZKA_NUM]
         ,vv.z_ka_date             -- дата заявки о перечислении 									  [ZKA_DATE]
         ,vv.z_ka_cancel_date      -- дата аннулирования заявки о перечислении 		      [ZKA_CANCEL_DATE]
         ,vv.z_ka_cancel_reas      -- причина аннулирования заявки  classifier_num=125 [lcbZCANC]
         ,vv.rs_dmg_num            -- № РП о перечислении денежных средств               [DGP_NUM]
         ,vv.rs_dmg_date           -- дата РП о перечислении денежных средств                 [DGP_DATE]
         ,vv.pds_date              -- Дата перечисления денежных средств                          [PDS_DATE]
		     ,vv.sub_priopritet     -- первоочередное право  classifier_num=121              [lcbPRAV] 
         ,vv.soc_norm           -- Социальная норма площади                                 [sc_norm]
		     ,vv.size_of_sub        -- размер субсидии %                                      [s_size] 
         ,vv.old_flat           -- занимаемое жилое помещение classifier_num=122               [lcbZPM ]  
         ,vv.ibcs_num           -- № реестра на зачисление денежных средств на ИБЦС  [IBCS_NUM]       
         ,vv.ibcs_date          -- Дата реестра на зачисление денежных средств на ИБЦС           [IBCS_DATE]
        ,vv.cost1    -- сумма выделенных средств                                   [s_cost1]
        ,vv.cost2    -- сумма перечисленных средств                                 [s_cost2]
        ,vv.cost3    -- сумма возвращенных средств                                  [s_cost3]
        ,vv.kpu_remove -- признак снятия КПУ с учета                                [s_KPU]
   		  ,vv.rs_cancel_num     -- № РП об отмене предоставления                     [ZERO_NUM]
        ,vv.rs_cancel_date    -- дата РП об отмене предоставления                            [ZERO_DATE]  

        ,vv.status_sub         -- Этап оформления субсидии (клс.126)
        ,vv.aff_plan_status    -- состояние плана (v_affair_plan_status )
        ,vv.aff_plan_type2     -- Состояние обеспечения (V_AFFAIR_PLAN_PROVIDE)    
        ,vv.aff_family_type    -- вид обеспечения субсидия (11)
        ,NVL(vv.arch,0) as arch  -- 1 - дело в архиве
        ,decode (vv.affair_stage, 
                1,
                decode(NVL(vv.arch,0),0,decode(vv.aff_plan_status,1,1,3,1,4,1,5,1,0),0),
                0) as is_change    -- возможность сохранить изменения 1-да, 0- нет
     FROM   v_affair_plan_subs vv
     WHERE  vv.sub_id = v_subs_id ; -- (affair_plan_id * 100) = subs_id
  commit;   
exception  
   when OTHERS 
   then 
      rollback ; 
      RAISE;  
 END GetSubsidForm;
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : Dik
  -- Описание :  Получить курсор на субсидию/Денежная компенсация МД из КПУ 
  -- Параметры:
  --    Входные: ID и stage КПУ (affair), p_f_num - номер элементарной семьи
procedure GetSubsid(p_user_id NUMBER, p_affair_id NUMBER, p_affair_stage NUMBER, p_f_num NUMBER, p_cur in out SYS_REFCURSOR)
is
  s_result varchar2(2000);
  v_f_type NUMBER;
  v_affair_plan_id NUMBER; 
  res NUMBER;
 BEGIN
  s_result :=  Set_Global_Var( p_user_id ) ;
  if (s_result is not NULL) then
     s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, s_result, 'PKG_RSM2.GetSubsid.Set_Global_Var',TO_CHAR(p_user_id));
    -- dbms_output.put_line(s_result);
      res:=genix_view.pkg_rsm2_gv.SaveMaessage( p_user_id, s_result, 'GetSubsid' ); 
     return; 
  end if;
  
      SELECT NVL(ap.family_type,0) as family_type, ap.affair_plan_id 
      INTO v_f_type, v_affair_plan_id
      FROM affair_plan ap
      WHERE ap.affair_id = p_affair_id AND ap.affair_stage = p_affair_stage AND ap.family_num = p_f_num;
  if v_f_type=PKG_DECLARATION.subsidy_code then
     GetSubsidForm(p_affair_id , p_affair_stage ,v_f_type, v_affair_plan_id,  p_cur);
  elsif v_f_type=PKG_DECLARATION.subsidy_code_md then
     GetSubsidForm(p_affair_id , p_affair_stage ,v_f_type, v_affair_plan_id,  p_cur);
  else
    s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, 'Вид обеспечения '||v_f_type||' не Субсидия', 'PKG_RSM2.GetSubsid',TO_CHAR(p_user_id));
     dbms_output.put_line(s_result);
    return; 
  end if;
  
   exception 
    when OTHERS then
          s_result := genix_view.PKG_K3_UTILS.GetResultJsonStr(1,SQLERRM,DBMS_UTILITY.FORMAT_ERROR_STACK || ' BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,TO_CHAR(p_affair_id)||'/'||TO_CHAR(p_f_num));
          res:=genix_view.pkg_rsm2_gv.SaveMaessage( p_user_id, s_result, 'GetSubsid' ); 
       --   dbms_output.put_line(s_result);
          return ;      
      
 END GetSubsid;
 
 -----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : Dik
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 

function UpdateSubsid(p_user_id NUMBER,  p_subs_id  NUMBER, p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END UpdateSubsid;

end PKG_RSM2;
/
