create or replace package PKG_RSM2_tmp_dik
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


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : Dik
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
procedure GetSubsid(p_user_id NUMBER, p_affair_id NUMBER, p_affair_stage NUMBER, p_f_num NUMBER, p_cur in out SYS_REFCURSOR);

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
-----------------------------------------------------------------------------------------------------------------------------
-- Описание :  UPDATE субсидии
  -- Параметры:
  --    Входные: p_user_id,  p_subs_id - ID субсидии
  --    Выходные:
    /*     {
  "ResultType": 0 -все хорошо 1-ошибка,
  "ResultMessage": "сообщение пользователю"
   "ErrMessage": "Текст ошибки тех.",
  "ResultId":   ID субсидии 
  }  */  
function UpdateSubsid( p_user_id NUMBER,  p_subs_id  NUMBER, p_json varchar2)   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Cancel_Subsid( p_user_id NUMBER,   p_affair_id NUMBER , p_json varchar2)   return varchar2;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Create_Compensation( p_user_id NUMBER,   p_affair_id NUMBER , p_json varchar2)   return varchar2;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Update_Compensation ( p_user_id NUMBER,   p_affair_id NUMBER , p_json varchar2)   return varchar2;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Cancel_Compensation ( p_user_id NUMBER,   p_affair_id NUMBER , p_json varchar2)   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : Dik
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Set_Subvention ( p_user_id NUMBER,   p_affair_id NUMBER , p_json varchar2)   return varchar2;



-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : dik
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Cancel_Subvention ( p_user_id NUMBER,   p_subv_id NUMBER )   return varchar2;
 
end PKG_RSM2_tmp_dik;
/
create or replace package body PKG_RSM2_tmp_dik
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
 BEGIN
    kurs3_var.global_okrug_id   := null;  
    kurs3_var.global_department   := null;
    kurs3_var.global_factory      :=null;
    kurs3_var.direction_id   :=null;  
    KURS3_VAR.global_user_id:=id_user;
    return null;
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
            
    return null;
                
END;



----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Дата создания : 
  -- Описание :     удаление члена семьи из дела
  -- Параметры:
  -- Входные:
  -- Выходные:
  function DelPersonFromDelo(p_Person_Id NUMBER, p_Affair_Id NUMBER, p_Affair_Stage NUMBER)  return varchar2
   IS
  BEGIN
    Kurs3.Del_Person_From_Delo(p_Person_Id, p_Affair_Id, p_Affair_Stage);
    return null;
  END DelPersonFromDelo;
  
  
  ----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Дата создания :
  -- Описание :     процедура  создания состава семьи в деле
  -- Параметры:
  -- Входные:
  -- Выходные:
  -- ins_person_to_delo_9 
function InsPersonToDelo(
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
                               birth_place          VARCHAR2) return varchar2
 IS
    l_Person_Category VARCHAR2(60);
  BEGIN
    /*BEGIN
      SELECT Category.Name INTO l_Person_Category FROM Category WHERE Categ_Id = Person_Category_;
    EXCEPTION
      WHEN No_Data_Found THEN
        l_Person_Category := 'на общих основаниях';
    END;*/
  
    Kurs3.Ins_Person_To_Delo(Affair_Id_,
                             Affair_Stage_,
                             Rnum_,
                             Person_Id_,
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
                             null,
                             null,
                             null,
                             null,
                             null,
                             null,
                             null,
                             null
                             );
                                       
      --ilonis 07.12.2016
        pkg_persons.set_pasport_data_attr ( Person_Id_   ,'birth_place',   substr(birth_place,1,150)    );     
       return null;                      
    -- ins_person_to_delo_8                              
  END InsPersonToDelo;
  
  
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
        return 'Объект не найден в БТИ';
    end if;
    
     kurs3_var.tmp_doc_type:=2;
     
     Pkg_Apartment.Create_Apartment_Kais( l_Build_Id, l_Apart_Num, l_Apart_Idx, l_Apart_Id,l_Code, Kurs3_Var.User_Id, l_New_Build_Code, 0);

    l_Apart_Id:= Pkg_Apartment.change_apart_from_bti_kais( l_Apart_Id, 0 );
    
    return l_Apart_Id;
 END Create_Apartment;
 

 
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :    создание заявления 
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CreateDeclaration(  p_user_id NUMBER,  p_json varchar2)     return varchar2
is 
 l_Build_Id NUMBER;
 l_Apart_Id NUMBER;
 l_Affair_Id NUMBER;
 l_Aff_Kais_Id NUMBER;
 l_Decl_Date DATE;
 s_Type number;
 l_uom number;
 l_unkv number;
 l_Group_Id  number;
 l_Delo_Category_Id  number;
 l_Type2_Id  number;
 l_Year_In_City number;
 l_Year_In_Place  number; 
 BEGIN
 
     --создание площади
    l_Build_Id:= Get_Building_Id( l_uom );
    if (l_Build_Id=0) then
        return 'Объект не найден в БТИ';
    end if;
     
    l_Apart_Id:= Create_Apartment(  l_uom , l_unkv );
     
     
    SELECT Seq_Affair_Id.Nextval INTO l_Affair_Id FROM Dual;
    
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
       ,AFF_FROM_KAIS  --13.11.2014 ilonis
       )
      SELECT Kurs3_Var.Global_Okrug_Id,
             l_Affair_Id,
             0,
             l_Build_Id,
             l_Apart_Id,
             39, --Категория дела (Общие основания)
             Kurs3_Var.Global_Factory, --Код предприятия
             To_Number(To_Char( l_Decl_Date, 'YYYY')), --Год постановки
             0, --Реальный номер дела
             0, --Всего человек на учете
             0, --Всего человек в семье
             0, --TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),
             0, --TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),
             0,
             0,
             0, --TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),
             SYSDATE,
             0,
             Kurs3_Var.Global_Department, -- Ведомство пользователя
             Kurs3_Var.Global_User_Name, -- Код инспектора
             0,
             14, -- 14 из 9 CLASSIFIER (прочие)
             Decode(Kurs3_Var.Direction_Id, 21, 16, 1), -- вид обеспечения (клс.11) -- 02.09.2008 Anissimova - для 21 н/у
             Kurs3_Var.Direction_Id,
             Space_Type,
             Room_Count,
             Living_Space,
             Total_Space,
             Condition, -- COMFORTABLE,
             Kitchen_Space,
             Lavatory,
             Good_For_Living,
             l_Decl_Date, --  decode(KURS3_VAR.Direction_id, 97, sysdate,1,sysdate, 21, sysdate, null), -- utk: дата заявления для переселенческих дел
             Decode(Kurs3_Var.Direction_Id, 1, To_Number(To_Char(SYSDATE, 'YYYY')), NULL) --,  -- учетно-плановый год Lvova 04.03.2009
             ,1  --13.11.2014 ilonis
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
       SET s_Group = l_Group_Id,  Delo_Category = l_Delo_Category_Id,  Type2 = l_Type2_Id, Year_In_City = l_Year_In_City, Year_In_Place = l_Year_In_Place
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
      RETURN 'Ошибка при создании заявления' ;
    
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
function UpadateStageDeclaration(  p_affair_id NUMBER, p_doc_date varchar2, p_doc_num varchar2 )   return varchar2
is 
 BEGIN
 
    if (trim(p_doc_date)='') then
        return 'Не указана дата распоряжения об аннулировании!';
    end if;
  
    if (trim(p_doc_num)='') then
        return 'Не указан номер распоряжения об аннулировании!';
    end if;
 
    return   announ_to_affair_1 (p_affair_id
                                                       ,p_doc_num       
                                                       ,p_doc_date  
                                                          );
 
 
    return null;
 END UpadateStageDeclaration;


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
function Create_Order( p_user_id NUMBER, p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END Create_Order;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Update_Order( p_user_id NUMBER,  p_order_id number, p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END Update_Order;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Create_Order_Release ( p_user_id NUMBER, p_order_id number, p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END Create_Order_Release;
 
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Cancel_Order( p_user_id NUMBER,  p_order_id number, p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END Cancel_Order;


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
function Create_Instruction( p_user_id NUMBER,   p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END Create_Instruction;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Update_Instruction_Release ( p_user_id NUMBER,   p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END Update_Instruction_Release;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Cancel_Instruction ( p_user_id NUMBER,   p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END Cancel_Instruction;
 



-----------------------------------------------------------------------------------------------------------------------------
-- Описание :  UPDATE субсидии
  -- Параметры:
  --    Входные: p_user_id,  p_subs_id - ID субсидии
  --    Выходные:
    /*     {
  "ResultType": 0 -все хорошо 1-ошибка,
  "ResultMessage": "сообщение пользователю"
   "ErrMessage": "Текст ошибки тех.",
  "ResultId":   ID субсидии 
  }  */  
function UpdateSubsid( p_user_id NUMBER,  p_subs_id  NUMBER, p_json varchar2)   return varchar2
is
 
 s_result varchar2(2000):= ' ';
 res NUMBER;
 is_err integer := 0;
--------
affair_plan_id NUMBER;  --ID плана КПУ
status_sub NUMBER(2);-- Этап оформления субсидии (клс.126)
-- Отображаемые поля	  
sub_decision_num VARCHAR2(15); -- № РП о постановке на субсидии  
sub_decision_date DATE;-- дата РП о постановке на субсидии      
sub_rs_num VARCHAR2(15); -- № РП о предоставлении субсидии     
sub_rs_date DATE;--  дата РП о предоставлении субсидии          
num_rp_remove VARCHAR2(15); -- № РП о снятии УДС с учета   (status3_num)
date_rp_remove DATE; -- дата РП о снятии УДС с учета    (status3_date)
reason     NUMBER(4);-- причина снятия УДС с учета   (клс.480)
certif_num  VARCHAR2(9); -- № свидетельства                    
certif_date DATE;-- дата свидетельства                         
sertif_cancel_date  DATE; -- дата аннулирования свидетельства         
certif_cancel_reas  NUMBER(3); -- причина аннулирования свидетельства  (клс.481)
z_ka_num  VARCHAR2(15); -- № заявки о перечислении                            
z_ka_date DATE;-- дата заявки о перечислении 									  
z_ka_cancel_date DATE; -- дата аннулирования заявки о перечислении 		      
z_ka_cancel_reas NUMBER(4); -- причина аннулирования заявки (клс.482)
rs_dmg_num  VARCHAR2(15);  -- № РП о перечислении денежных средств              
rs_dmg_date  DATE;    -- дата РП о перечислении денежных средств                
pds_date  DATE ;  -- Дата перечисления денежных средств                         
sub_priopritet NUMBER(4); -- первоочередное право  (клс.478)            
soc_norm  NUMBER(6,2);-- Социальная норма площади                                
size_of_sub NUMBER(3); -- размер субсидии %                                     
old_flat NUMBER(4);-- занимаемое жилое помещение (клс.479)            
ibcs_num    VARCHAR2(15);    -- № реестра на зачисление денежных средств на ИБЦС
ibcs_date  DATE ;-- Дата реестра на зачисление денежных средств на ИБЦС         
cost1  NUMBER(11,2);-- сумма выделенных средств                                 
cost2 NUMBER(11,2);-- сумма перечисленных средств                               
cost3 NUMBER(11,2);-- сумма возвращенных средств                                
kpu_remove NUMBER(1);-- признак снятия КПУ с учета                              
rs_cancel_num  VARCHAR2(15);  -- № РП об отмене предоставления                   
rs_cancel_date DATE;  -- дата РП об отмене предоставления   
--------   
    jv genix_view.json_value :=  genix_view.json_value.makenull;
    JL genix_view.json_list;
    JO genix_view.json;
BEGIN
   s_result :=  Set_Global_Var( p_user_id ) ;
   if (s_result is not NULL) then
       s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, s_result, 'PKG_RSM2.UpdateSubsid',TO_CHAR(p_user_id));
       res:=genix_view.pkg_rsm2_gv.SaveMaessage( p_user_id, s_result, 'UpdateSubsid' ); 
       return (s_result); 
    end if; 
        
   JO := genix_view.json(p_json); 
   
    affair_plan_id := genix_view.PKG_K3_UTILS.get_number_from_json(p_json,'affair_plan_id');
    if NVL(affair_plan_id,0) < 1 then
      s_result := s_result||'Нет кода Плана КПУ; ';
      is_err := 1;
      -- genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, 'Нет кода Плана КПУ', 'PKG_RSM2.UpdateSubsid',TO_CHAR(affair_plan_id));
      -- return (s_result); 
    end if;
 
    status_sub := genix_view.PKG_K3_UTILS.get_number_from_json(p_json,'status_sub');
    if NVL(status_sub,0) < 1 then
      s_result := s_result||'Нет статуса субсидии; ';
      is_err := 1;
    end if;
    sub_decision_num  := genix_view.PKG_K3_UTILS.get_string_from_json(p_json,'sub_decision_num');
    sub_decision_date := genix_view.PKG_K3_UTILS.get_date_from_json(p_json,'sub_decision_date');
   
    sub_rs_num  := genix_view.PKG_K3_UTILS.get_string_from_json(p_json,'sub_rs_num');
    sub_rs_date := genix_view.PKG_K3_UTILS.get_date_from_json(p_json,'sub_rs_date'); 
        
  --  

    affair_plan_id := genix_view.PKG_K3_UTILS.get_number_from_json(p_json,'affair_plan_id');
    if NVL(affair_plan_id,0) < 1 then
      s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, 'Нет кода Плана КПУ', 'PKG_RSM2.UpdateSubsid',TO_CHAR(affair_plan_id));
      return (s_result); 
    end if;
    affair_plan_id := genix_view.PKG_K3_UTILS.get_number_from_json(p_json,'affair_plan_id');
    if NVL(affair_plan_id,0) < 1 then
      s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, 'Нет кода Плана КПУ', 'PKG_RSM2.UpdateSubsid',TO_CHAR(affair_plan_id));
      return (s_result); 
    end if;
    affair_plan_id := genix_view.PKG_K3_UTILS.get_number_from_json(p_json,'affair_plan_id');
    if NVL(affair_plan_id,0) < 1 then
      s_result :=  genix_view.PKG_K3_UTILS.GetResultJsonStr( 1, 'Нет кода Плана КПУ', 'PKG_RSM2.UpdateSubsid',TO_CHAR(affair_plan_id));
      return (s_result); 
    end if;            

return (s_result);
exception 
    when OTHERS then
          s_result := genix_view.PKG_K3_UTILS.GetResultJsonStr(1,SQLERRM,DBMS_UTILITY.FORMAT_ERROR_STACK || ' BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,trim(TO_CHAR(p_subs_id)));
          res:=genix_view.pkg_rsm2_gv.SaveMaessage( p_user_id, s_result, 'UpdateSubsid' );      
     return (s_result);
END UpdateSubsid;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Cancel_Subsid( p_user_id NUMBER,   p_affair_id NUMBER , p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END Cancel_Subsid;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Create_Compensation( p_user_id NUMBER,   p_affair_id NUMBER , p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END Create_Compensation;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Update_Compensation ( p_user_id NUMBER,   p_affair_id NUMBER , p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END Update_Compensation;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Cancel_Compensation ( p_user_id NUMBER,   p_affair_id NUMBER , p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END Cancel_Compensation;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : Dik
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
 
function Set_Subvention ( p_user_id NUMBER,   p_affair_id NUMBER , p_json varchar2)   return varchar2
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
          
END Set_Subvention ;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : Dik
  -- Описание :     
  --  Удалить данные о  субвенции
function Cancel_Subvention ( p_user_id NUMBER,   p_subv_id NUMBER )   return varchar2
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
     
END Cancel_Subvention;


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
  -- Описание :  Получить курсор на субсидию из КПУ 
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
 


end PKG_RSM2_tmp_dik;
/
