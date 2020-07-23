create or replace package PKG_RSM2_GV
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
  -- Описание :     удаление члена семьи из дела
  -- Параметры:
  -- Входные:
  -- Выходные:
  function DelPersonFromDelo( p_user_id NUMBER, p_json varchar2)  return varchar2;
  
  
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
  function CreateDeclaration( p_user_id NUMBER, p_json varchar2)     return varchar2;
  
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
function CreateUpdatePerson( p_user_id NUMBER, p_json varchar2)     return varchar2;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
--function Update_Privilege_Document( p_user_id NUMBER, p_person_id NUMBER , p_json varchar2)     return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateStageDeclaration( p_user_id NUMBER, p_json varchar2)   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelDeclaration( p_user_id NUMBER , p_json varchar2)   return varchar2;



-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelAffair( p_user_id NUMBER, p_json varchar2)   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Create_Order( p_user_id NUMBER, p_json varchar2)   return varchar2;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function Update_Order( p_user_id NUMBER,  p_order_id number, p_json varchar2)   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CreateOrderRelease ( p_user_id number, p_json varchar2 )   return varchar2;
 
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :  аннулирование проекта выписки,  выписки
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelOrder( p_user_id NUMBER,  p_json varchar2)   return varchar2;


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
function CreateUpdateInstruction( p_user_id NUMBER,   p_json varchar2)   return varchar2;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateInstructionRelease ( p_user_id NUMBER,   p_json varchar2)   return varchar2;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelInstruction ( p_user_id NUMBER,   p_json varchar2)   return varchar2;
 
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

----------------------------------------------------------------------------------------------------------------------------  
  -- Автор  : Dik
  -- Описание :  Получить курсор на субсидию/Денежная компенсация МД из КПУ 
  -- Параметры:
  --    Входные: ID и stage КПУ (affair), p_f_num - номер элементарной семьи
procedure GetSubsid(p_user_id NUMBER, p_affair_id NUMBER, p_affair_stage NUMBER, p_f_num NUMBER, p_cur in out SYS_REFCURSOR); 

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
function UpdateSubsidKmd(p_user_id NUMBER,  p_subs_id  NUMBER, p_json varchar2) return varchar2;



  -- Автор  : Dik
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

 
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :    создание и аннулирование. гор программы  
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CreateUpdateGorProg( p_user_id NUMBER, p_json varchar2)     return varchar2;
 
end PKG_RSM2_GV;
/
create or replace package body PKG_RSM2_GV
is
--ilonis
-- пакет для работы по иНтеграции рсм2 и курс3
--SELECT *  from  category--категория дела
 
--SELECT NAME, TARGET FROM V_CATEG_AFFAIR WHERE AFFAIR_ID=33431 ORDER BY TARGET
--select row_num as cl_ID, trim(NAME) as cl_NAME  from KURS3.CLASSIFIER_KURS3 where CLASSIFIER_NUM=203 and DELETED=0
--  pkg_action_doc.UPDATE_ACTION_DOC(:P_TABLE_NAME, :P_FIELD_NAME, :P_RECORD_ID, :P_DOC_TYPE_ID, :P_DOC_NUMBER, :P_DOC_DATE, :P_DOC_NOTE, :P_DOC_REASON_ID, :P_RELATION_TABLE, :P_RELATION_FIELD, :P_RELATION_ID);
--UPDATE AFFAIR SET DELO_CATEGORY = 31WHERE AFFAIR_ID = 33431 AND AFFAIR_STAGE = 1 AND OKRUG_ID = KURS3.GET_OKRUG
--------------------------
--SELECT ROW_NUM, NAME FROM V_SGROUP ORDER BY NAME
--UPDATE    AFFAIR                        
--SET                                
 --S_GROUP = 14
--WHERE                              
 --AFFAIR_ID = 33431 AND 
 --AFFAIR_STAGE = 1 AND 
 --OKRUG_ID = KURS3.GET_OKRUG
------------------------------------
  --KURS3.SET_AFFAIR_REGISTRATION(:AFFAIR_ID, :AFFAIR_STAGE, :REG_DATE);
 -----------------------------------------------------------------------------------------------------------------------------
 -- K3_PKG_AFFAIR.Set_AFFAIR_ACTUAL_DATE(:A_ID, :A_STAGE, :P_ACTUAL_DATE);
 -------------------------------------------------
 --причина снятия
 --
-- SELECT ROW_NUM, NAME FROM V_REASON2 ORDER BY NAME
 ------------------------------------------
 
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --  Входные:
  --  Выходные:
  --текст Ошибки 
function Set_Global_Var( id_user number ) return varchar2
is 
 BEGIN
    return pkg_rsm2.Set_Global_Var( id_user );
 END Set_Global_Var;
 

function SaveMaessage( p_user_id number, p_message  IN  CLOB, p_action varchar2:=null ) return number
as
   pragma autonomous_transaction;
   l_id number;
begin

    insert into  genix_view.temp_kurs ( user_id, message, action) 
    values( p_user_id, p_message, p_action ) return id_message into l_id;
    
    commit;
    
    return (l_id);
     
end SaveMaessage;


procedure SaveResultMaessage( p_id_message  number, p_message varchar2 ) 
as
   pragma autonomous_transaction;
   l_id number;
begin

    update  genix_view.temp_kurs set ResultMessage= p_message
    where  id_message = p_id_message;
    
    commit;
    
end SaveResultMaessage;
 



function CreateResultMessage( p_ResultType number, p_message varchar2, p_id varchar2:=null) return varchar2
is 
    l_result varchar2(1000);
begin

    l_result:='{'||'"ResultType":'||p_ResultType||','||
                        '"ResultMessage":"'||p_message||'",'||
                        '"ResultId":"'||p_id||'"}';
     return (l_result);
     
 /*     {
  "ResultType": 0 -все хорошо 1-ошибка,
  "ResultMessage": "Текст ошибки",
  "ResultId":  ид 
  }  */                      
                        
end CreateResultMessage;

----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Дата создания : 
  -- Описание :     удаление члена семьи из дела
  -- Параметры:
  -- Входные:
  -- Выходные:
function DelPersonFromDelo( p_user_id NUMBER, p_json varchar2)  return varchar2
   is 
    l_user_id number:=-106;
    l_result varchar2(1000);
    l_id_message number;
    l_affair_id number;
    l_json json;
 BEGIN
    if p_user_id is not null then
        l_user_id:=p_user_id;
    end if;
    
    --сохранение входных параметров в таблицу  temp_kurs  
     l_id_message:=SaveMaessage( l_user_id, p_json, 'DelPersonFromDelo' ); 
    
    --установка глобальных переменных
     l_result:= Set_Global_Var( l_user_id );
     if (  l_result is not null ) then
        l_result:=  CreateResultMessage( 1,l_result );
        SaveResultMaessage( l_id_message, l_result );
        return ( l_result );
     end if;
 /*
 {
   
 -- p_Person_Id , p_Affair_Id , p_Affair_Stage ,
   --                              p_DelReason_id , p_ReasonDoc_num , p_ReasonDoc_date
{
  "AffairId": 0,
  "PersonId": 0,
   "DelReasonId": 0,
  "DataDoc": "2020-07-08T11:59:38.153Z",
  "NomDoc": "0",
  "User": 0
}*/
    l_json := json(p_json);
     
    l_affair_id:=l_json.get('AffairId').get_number();
      
     l_result:= pkg_rsm2.DelPersonFromDelo(  l_json.get('AffairId').get_number(),
                                                                   l_json.get('PersonId').get_number(),
                                                                   l_json.get('DelReasonId').get_number(),
                                                                   l_json.get('NomDoc').get_string( ),
                                                                   l_json.get('DataDoc').get_string( )
                                                        );
    
     if (  l_result is null ) then
        l_result:=  CreateResultMessage( 0,l_result );
     else
        l_result:=  CreateResultMessage(1,l_result );
     end if;

    
     SaveResultMaessage( l_id_message, l_result );
    
    return ( l_result );
  
END DelPersonFromDelo;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CreateDeclaration( p_user_id NUMBER, p_json varchar2)     return varchar2
is 
    l_user_id number:=-106;
    l_result varchar2(1000);
    l_id_message number;
    l_affair_id number;
    l_json json;
 BEGIN
    if p_user_id is not null then
        l_user_id:=p_user_id;
    end if;
 
 --сохранение входных параметров в таблицу  temp_kurs  
     l_id_message:=SaveMaessage( l_user_id, p_json, 'CreateDeclaration' ); 
    
    --установка глобальных переменных
     l_result:= Set_Global_Var( l_user_id );
     if ( l_result  is not  null ) then
        l_result:=  CreateResultMessage( 1,l_result );
        SaveResultMaessage( l_id_message, l_result );
        return ( l_result );
     end if;
 
    --получение параметров
    
 /* 
 DataDeclaration": "string",
  "ReasonCode": 0,
  "YearInMoscow": 0,
  "YearInAdressReg": 0,
  "GroupCode": 0,
  "KategoryCode": 0,
  "VidObespCode": 0,
  "Unom": 0,
  "Kvnom": 0,
  "TownCode": 0,
  "TownName": "string",
  "StreetCode": 0,
  "StreetName": "string",
  "DomNum": "string",
  "Korpus": "string",
  "Stroenie": "string",
  "FlatNom": "string",
  "TypeGpCode": 0,
  "TypeSobstCode": 0,
  "TypeProgivCode": 0,
  "TypeTyaletCode": 0,
  "TypeBlagCode": 0,
  "TypeBalconCode": 0,
  "Floor": 0,
  "SKitchen": 0,
  "SWithSummer": 0,
  "SWithoutSummer": 0,
  "Sliving": 0,
  "SKitchenPerson": 0,
  "SWithSummerPerson": 0,
  "SWithoutSummerPerson": 0,
  "SlivingPerson": 0,
  "CountFamyli": 0,
*/
     l_json := json(p_json);
     
    -- l_affair_id:=l_json.get('AffairId').get_number();
    
    l_result:= pkg_rsm2.CreateDeclaration(     l_json.get('Unom').get_number(), 
                                            l_json.get('Unkv').get_number(),
                                            l_json.get('Kvnom').get_string(),
                                            l_json.get('DataDeclaration').get_string(),
                                            l_json.get('GroupCode').get_number(),
                                            l_json.get('KategoryCode').get_number(),
                                            l_json.get('VidObespCode').get_number(),
                                            l_json.get('YearInMoscow').get_number(),
                                            l_json.get('YearInAdressReg').get_number(),
                                            l_json.get('ReasonCode').get_number(),
                                            l_affair_id) ;
    
     if  l_result is null then
        l_result:=  CreateResultMessage( 0,l_result, l_affair_id );
     else
        l_result:=  CreateResultMessage(1,l_result );
     end if;
    
     SaveResultMaessage( l_id_message, l_result );
    
    return ( l_result );

    
    
 END CreateDeclaration;
 
  
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateDeclaration( p_user_id NUMBER, p_json varchar2)     return varchar2
is 
 BEGIN
 
    return  pkg_rsm2.UpdateDeclaration( p_user_id , p_json )  ;
    
 END UpdateDeclaration;
 

    
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CreateUpdatePerson( p_user_id NUMBER, p_json varchar2)     return varchar2
is
     l_user_id number:=-106;
    l_result varchar2(1000);
    l_id_message number;
    l_affair_id number;
    l_json json;
    l_document json;
    
 BEGIN
    if p_user_id is not null then
        l_user_id:=p_user_id;
    end if;
 
 --сохранение входных параметров в таблицу  temp_kurs  
     l_id_message:=SaveMaessage( l_user_id, p_json, 'CreateUpdatePerson' ); 
    
    --установка глобальных переменных
     l_result:= Set_Global_Var( l_user_id );
     if ( l_result  is not  null ) then
        l_result:=  CreateResultMessage( 1,l_result );
        SaveResultMaessage( l_id_message, l_result );
        return ( l_result );
     end if;
 
 
     --получение параметров
     l_json := json(p_json);
     --документ
     l_document:=json(  l_json.get('PasportDocsPerson').get_string()  );
     
       
    l_result := pkg_rsm2.CreateUpdatePerson(
                               l_json.get('AffairId').get_number(),
                               l_json.get('AffairStage').get_number(),
                               1,-- Rnum_  NUMBER,
                               l_json.get('PersonId').get_number(),
                               l_json.get('Surname').get_string(),-- Last_Name_,
                               (substr(l_json.get('Name').get_string(),1,1)||substr( l_json.get('Patronymic').get_string(),1,1)),  -- First_Name_,
                               l_json.get('BirthDay').get_string(),
                               l_json.get('Pol').get_string(),
                               l_json.get('RelationsCode').get_number(),
                               l_document.get('TypeDoc').get_number(),-- Doc_Type_ 
                               l_document.get('SeriaDocOsn').get_string(),-- Doc_Series_       
                               l_document.get('NomDocOsn').get_string(),--Doc_Num_          
                               l_document.get('DateDocOsn').get_string(),--Date_Enter_       
                               l_document.get('DateDocOsn').get_string(),--How_Giving_      
                               l_json.get('NumFamily').get_number(),--Family_Num_ 
                               l_json.get('FlagZayavitel').get_number(), -- Master_           
                               l_json.get('RequirCode').get_number(), --Sq_Type_ требование
                               l_json.get('Patronymic').get_string(),
                               l_json.get('Name').get_string(),-- Pat_
                               l_json.get('CategoryOsnCode').get_string(),-- Person_Category_  
                              '',-- Person_Subsidy_   CHAR,
                               l_json.get('Category1DopCode').get_string(),--Person_Category_1 
                               l_json.get('Category2DopCode').get_string(),--Person_Category_2
                               l_json.get('DateCategoryDop').get_string(), -- Category_Date     
                               l_json.get('YearCategoryDop').get_number(), -- Category_Year     
                               l_json.get('DateCategory1Dop').get_string(), --Category_1_Date   
                               l_json.get('YearCategory1Dop').get_number(), --Category_1_Year  
                               l_json.get('DateCategory2Dop').get_string(), --Category_2_Date   
                               l_json.get('YearCategory2Dop').get_number(), --Category_2_Year  
                               l_json.get('YearInMoscow').get_number(),-- Year_In_City      
                               l_json.get('YearInAdressReg').get_number(),--Year_In_Place     
                               l_json.get('RightNom').get_number(),--Reg_Person  на учете
                               l_json.get('FlagSobstv').get_number(), -- Owners          
                               '',--Addr_Reg_         VARCHAR2,
                               l_json.get('FlagKvartirSiem').get_number(), --   Tenant_           
                               '',-- v_City            VARCHAR2,
                               '', --v_Okrug           VARCHAR2,
                               '',--v_Street          VARCHAR2,
                               '',--v_Build_Num       VARCHAR2,
                               '',-- v_Korp_Num        VARCHAR2,
                               '',-- v_Apart_Num       VARCHAR2,
                                l_json.get('Phone').get_string()
                               ,null --v_tel_work  
                              , l_json.get('PhoneMobail').get_string()
                              , l_json.get('EMail').get_string()
                               ,null--v_add_liv_sp_sz   
                               ,null --v_add_liv_sp_type  
                               ,null--v_add_liv_sp_comm  
                               ,  l_json.get('FamilyRelationsCode').get_number() --v_AF_F_RELATION 
                               , 0--v_ADD_REG_SPACE_ID  NUMBER      
                              , l_json.get('PlaceBirth').get_string() 
                              );                                       
                           
     if  l_result is null then
        l_result:=  CreateResultMessage( 0,l_result );
     else
        l_result:=  CreateResultMessage(1,l_result );
     end if;
    
     SaveResultMaessage( l_id_message, l_result );
    
    return ( l_result );

 END CreateUpdatePerson;
 


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание : Перевод заявления в дело     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateStageDeclaration( p_user_id NUMBER, p_json varchar2)   return varchar2
is 
    l_user_id number:=-106;
    l_result varchar2(1000);
    l_id_message number;
    l_affair_id number;
    l_json json;
 BEGIN
    if p_user_id is not null then
        l_user_id:=p_user_id;
    end if;
    
    --сохранение входных параметров в таблицу  temp_kurs  
     l_id_message:=SaveMaessage( l_user_id, p_json, 'UpdateStageDeclaration' ); 
    
    --установка глобальных переменных
     l_result:= Set_Global_Var( l_user_id );
     if (  l_result is not null ) then
        l_result:=  CreateResultMessage( 1,l_result );
        SaveResultMaessage( l_id_message, l_result );
        return ( l_result );
     end if;
 /*
 {
  "DeclarationId": 0,
  "DataDoc": "2020-07-08T11:59:38.153Z",
  "NomDoc": 0,
  "User": 0
}*/
    l_json := json(p_json);
     
    l_affair_id:=l_json.get('AffairId').get_number();
      
     l_result:= pkg_rsm2.UpdateStageDeclaration(  l_json.get('AffairId').get_number(),
                                                        l_json.get('DataDoc').get_string( ),
                                                        l_json.get('NomDoc').get_string( )
                                                        );
    
     if (  l_result is null ) then
        l_result:=  CreateResultMessage( 0,l_result );
     else
        l_result:=  CreateResultMessage(1,l_result );
     end if;

    
     SaveResultMaessage( l_id_message, l_result );
    
    return ( l_result );

 END UpdateStageDeclaration;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     аннулт=ирование заявления
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelDeclaration( p_user_id NUMBER,  p_json varchar2)   return varchar2
is 
    l_user_id number:=-106;
    l_result varchar2(1000);
    l_id_message number;
    l_affair_id number;
    l_json json;
 BEGIN
    if p_user_id is not null then
        l_user_id:=p_user_id;
    end if;
    
    --сохранение входных параметров в таблицу  temp_kurs  
     l_id_message:=SaveMaessage( l_user_id, p_json, 'CancelDeclaration' ); 
    
    --установка глобальных переменных
     l_result:= Set_Global_Var( l_user_id );
     if ( l_result  is not  null ) then
        l_result:=  CreateResultMessage( 1,l_result );
        SaveResultMaessage( l_id_message, l_result );
        return ( l_result );
     end if;
 
    --получение параметров
    
 /*   {
  "AffairId": 0,
  "DataDoc": "2020-07-08T09:36:56.491Z",
  "NomDoc": 0,
  "ReasonCode": 0,
  "User": 0
}*/
     l_json := json(p_json);
     
     l_affair_id:=l_json.get('AffairId').get_number();
      
     l_result:= pkg_rsm2.CancelDeclaration(  l_affair_id );
    
     if  l_result is null then
        l_result:=  CreateResultMessage( 0,l_result );
     else
        l_result:=  CreateResultMessage(1,l_result );
     end if;
    
     SaveResultMaessage( l_id_message, l_result );
    
    return ( l_result );

 END CancelDeclaration;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelAffair( p_user_id NUMBER , p_json varchar2)   return varchar2
is 
    l_user_id number:=-106;
    l_result varchar2(1000);
    l_id_message number;
    l_affair_id number;
    l_json json;
BEGIN
    if p_user_id is not null then
        l_user_id:=p_user_id;
    end if;
    
    --сохранение входных параметров в таблицу  temp_kurs  
     l_id_message:=SaveMaessage( l_user_id, p_json, 'CancelAffair' ); 
    
    --установка глобальных переменных
     l_result:= Set_Global_Var( l_user_id );
     if ( l_result is not null ) then
        l_result:=  CreateResultMessage( 1,l_result );
        SaveResultMaessage( l_id_message, l_result );
        return ( l_result );
     end if;
 
    --получение параметров
    
 /*   {
  "AffairId": 0,
  "DataDoc": "2020-07-08T09:36:56.491Z",
  "NomDoc": 0,
  "ReasonCode": 0,
  "User": 0
}*/


     l_json := json(p_json);
     
     l_affair_id:=l_json.get('AffairId').get_number();
      
     l_result:= pkg_rsm2.CancelAffair(  l_json.get('AffairId').get_number(),
                                                        l_json.get('DataDoc').get_string( ),
                                                        l_json.get('NomDoc').get_string( ),
                                                        l_json.get('ReasonCode').get_number( ));
     if l_result is null then
        l_result:=  CreateResultMessage( 0,l_result );
     else
        l_result:=  CreateResultMessage(1,l_result );
     end if;
    
     SaveResultMaessage( l_id_message, l_result );
    
    return ( l_result );
 
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
  -- Описание : перевод изданной выписки  всостояние выписка     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CreateOrderRelease ( p_user_id number, p_json varchar2 )   return varchar2
is 
    l_user_id number:=-106;
    l_result varchar2(1000);
    l_id_message number;
    l_json json;
 BEGIN
    if p_user_id is not null then
        l_user_id:=p_user_id;
    end if;
    
    --сохранение входных параметров в таблицу  temp_kurs  
     l_id_message:=SaveMaessage( l_user_id, p_json, 'CreateOrderRelease' ); 
    
    --установка глобальных переменных
     l_result:= Set_Global_Var( l_user_id );
     if ( l_result is not null ) then
        l_result:=  CreateResultMessage( 1,l_result );
        SaveResultMaessage( l_id_message, l_result );
        return ( l_result );
     end if;
     
 /*
 {
  "OrderId": 0,
  "DataDoc": "2020-07-08T12:40:47.373Z",
  "NomDoc": 0,
  "StatyiaYcheta": 0,
  "User": 0
}
 */
 
    l_json := json(p_json);
     
     l_result:= pkg_rsm2.CreateOrderRelease( 
             l_json.get('OrderId').get_number(),
             l_json.get('DataDoc').get_string(),
             l_json.get('NomDoc').get_string(),
             l_json.get('StatyiaYcheta').get_number()
        );
    
    if ( l_result is null ) then
        l_result:=  CreateResultMessage( 0,l_result );
     else
        l_result:=  CreateResultMessage(1,l_result );
     end if;

    
     SaveResultMaessage( l_id_message, l_result );
    
    return ( l_result );
 
 END CreateOrderRelease;
 
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :  аннулирование проекта, изданного проекта  выписки,  выписки
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelOrder( p_user_id NUMBER,  p_json varchar2)   return varchar2
 is 
    l_user_id number:=-106;
    l_result varchar2(1000);
    l_id_message number;
    l_json json;
 BEGIN
    if p_user_id is not null then
        l_user_id:=p_user_id;
    end if;
    
    --сохранение входных параметров в таблицу  temp_kurs  
     l_id_message:=SaveMaessage( l_user_id, p_json, 'CancelOrder' ); 
    
    --установка глобальных переменных
     l_result:= Set_Global_Var( l_user_id );
     if ( l_result is not null ) then
        l_result:=  CreateResultMessage( 1,l_result );
        SaveResultMaessage( l_id_message, l_result );
        return ( l_result );
     end if;
     
 /*
 {
  "OrderId": 0,
  "DataDoc": "2020-07-08T12:40:47.373Z",
  "NomDoc": 0,
  "ReasonCode": 0,
  "User": 0
}
 */
 
    l_json := json(p_json);
     
     l_result:= pkg_rsm2.CancelOrder(   
             l_json.get('OrderId').get_number(),
             l_json.get('DataDoc').get_string(),
             l_json.get('NomDoc').get_string(),
             l_json.get('ReasonCode').get_number()
        );
    
    if ( l_result is null ) then
        l_result:=  CreateResultMessage( 0,l_result );
     else
        l_result:=  CreateResultMessage(1,l_result );
     end if;

    
     SaveResultMaessage( l_id_message, l_result );
    
    return ( l_result );
 
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
function CreateUpdateInstruction( p_user_id NUMBER,   p_json varchar2)   return varchar2
is 
    l_user_id number:=-106;
    l_result varchar2(1000);
    l_id_message number;
    l_json json;
BEGIN
    if p_user_id is not null then
        l_user_id:=p_user_id;
    end if;
    
    --сохранение входных параметров в таблицу  temp_kurs  
     l_id_message:=SaveMaessage( l_user_id, p_json, 'CreateUpdateInstruction' ); 
    
    --установка глобальных переменных
     l_result:= Set_Global_Var( l_user_id );
     if ( l_result is not null ) then
        l_result:=  CreateResultMessage( 1,l_result );
        SaveResultMaessage( l_id_message, l_result );
        return ( l_result );
     end if;
 
    --получение параметров
   
 /* {
  "InstructionId": 0,
  "DataDoc": "string",
   DepartmentTo number --ведомство
   NumInDepartmentTo number --предпиятие
   Trget number ---Цель,
   Direction number -- направление
   SDelivery number  --  Статья передачи
   SCalculation number --Статья учета
   Fond number --Фонд реализации
   Year number --Учетный год
   OsnovaPeredach strung--основание передачи basis
   DopSvedenia string--дополнительные свндения ADDENUM
}*/
 


     l_json := json(p_json);
     
     l_result:= pkg_rsm2.CreateUpdateInstruction(   l_json.get('FreeSpaceId').get_number() ,
                                                                          sysdate,      
                                                                          l_json.get('DepartmentTo').get_string(),
                                                                          l_json.get('NumInDepartmentTo').get_string(),
                                                                          l_json.get('Trget').get_number(),
                                                                          l_json.get('Direction').get_number(),
                                                                          l_json.get('SDelivery').get_number(),
                                                                          l_json.get('SCalculation').get_number(),
                                                                          l_json.get('Fond').get_number(),
                                                                          l_json.get('Year').get_number(),
                                                                          l_json.get('OsnovaPeredach').get_string(),
                                                                          l_json.get('DopSvedenia').get_string()     );
                                                                          
     if ( l_result is null ) then
        l_result:=  CreateResultMessage( 0,l_result );
     else
        l_result:=  CreateResultMessage(1,l_result );
     end if;
    
     SaveResultMaessage( l_id_message, l_result );
    
    return ( l_result );
 
END CreateUpdateInstruction;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateInstructionRelease ( p_user_id NUMBER,   p_json varchar2)   return varchar2
is 
    l_user_id number:=-106;
    l_result varchar2(1000);
    l_id_message number;
    l_json json;
BEGIN
    if p_user_id is not null then
        l_user_id:=p_user_id;
    end if;
    
    --сохранение входных параметров в таблицу  temp_kurs  
     l_id_message:=SaveMaessage( l_user_id, p_json, 'UpdateInstructionRelease' ); 
    
    --установка глобальных переменных
     l_result:= Set_Global_Var( l_user_id );
     if ( l_result is not null ) then
        l_result:=  CreateResultMessage( 1,l_result );
        SaveResultMaessage( l_id_message, l_result );
        return ( l_result );
     end if;
 
    --получение параметров
    
 /* {
  "InstructionId": 0,
  "DataDoc": "string",
  "NomDoc": 0,
  "User": 0
}*/

     l_json := json(p_json);
     
     l_result:= pkg_rsm2.UpdateInstructionRelease(  l_json.get('InstructionId').get_number() ,
                                                                            l_json.get('DataDoc').get_string()   );
     if ( l_result is null ) then
        l_result:=  CreateResultMessage( 0,l_result );
     else
        l_result:=  CreateResultMessage(1,l_result );
     end if;
    
     SaveResultMaessage( l_id_message, l_result );
    
    return ( l_result );
 
 END UpdateInstructionRelease;


-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :    аннулирование проекта Ф4
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelInstruction ( p_user_id NUMBER,   p_json varchar2)   return varchar2
is 
    l_user_id number:=-106;
    l_result varchar2(1000);
    l_id_message number;
    l_json json;
BEGIN
    if p_user_id is not null then
        l_user_id:=p_user_id;
    end if;
    
    --сохранение входных параметров в таблицу  temp_kurs  
     l_id_message:=SaveMaessage( l_user_id, p_json, 'CancelInstruction' ); 
    
    --установка глобальных переменных
     l_result:= Set_Global_Var( l_user_id );
     if ( l_result is not null ) then
       l_result:=  CreateResultMessage( 1,l_result );
        SaveResultMaessage( l_id_message, l_result );
        return ( l_result );
     end if;
 
    --получение параметров
    
 /*  {
  "InstructionId": 0,
  "DataDoc": "2020-07-08T13:13:24.465Z",
  "NomDoc": 0,
  "ReasonCode": 0,
  "User": 0
}
}*/


     l_json := json(p_json);
     
     l_result:= pkg_rsm2.CancelInstruction(  l_json.get('InstructionId').get_number()  );
     if ( l_result is null ) then
        l_result:=  CreateResultMessage( 0,l_result );
     else
        l_result:=  CreateResultMessage(1,l_result );
     end if;
    
     SaveResultMaessage( l_id_message, l_result );
    
    return ( l_result );
 
 
 END CancelInstruction;

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
BEGIN
   return pkg_rsm2.IsSubsid( p_user_id , p_affair_id, p_affair_stage, p_f_num)  ;
END IsSubsid;  

----------------------------------------------------------------------------------------------------------------------------  
  -- Автор  : Dik
  -- Описание :  Получить курсор на субсидию/Денежная компенсация МД из КПУ 
  -- Параметры:
  --    Входные: ID и stage КПУ (affair), p_f_num - номер элементарной семьи
procedure GetSubsid(p_user_id NUMBER, p_affair_id NUMBER, p_affair_stage NUMBER, p_f_num NUMBER, p_cur in out SYS_REFCURSOR)
is 
BEGIN
   pkg_rsm2.GetSubsid( p_user_id , p_affair_id, p_affair_stage, p_f_num,p_cur) ;
END GetSubsid; 
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
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



-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function UpdateSubsidKmd(p_user_id NUMBER,  p_subs_id  NUMBER, p_json varchar2)   return varchar2
is 
 BEGIN
    return null;
 END UpdateSubsidKmd;




-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : Dik
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function SetSubvention ( p_user_id NUMBER,   p_affair_id NUMBER , p_json varchar2)   return varchar2
is 

 BEGIN

   return pkg_rsm2.Set_Subvention( p_user_id , p_affair_id, p_json )  ;


 END SetSubvention;

-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : Dik
  -- Описание :     
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CancelSubvention ( p_user_id NUMBER,   p_subv_id NUMBER )   return varchar2
is 
 BEGIN
   
    return  pkg_rsm2.CancelSubvention ( p_user_id ,   p_subv_id  );
    
 END CancelSubvention;
 
  
 
-----------------------------------------------------------------------------------------------------------------------------
  -- Автор  : ilonis
  -- Описание :    создание и аннулирование. гор программы  
  -- Параметры:
  --    Входные:
  --    Выходные:
        --текст Ошибки 
function CreateUpdateGorProg( p_user_id NUMBER, p_json varchar2)     return varchar2
is
     l_user_id number:=-106;
    l_result varchar2(1000);
    l_id_message number;
    l_dcr_id number;
    l_json json;
    
 BEGIN
    if p_user_id is not null then
        l_user_id:=p_user_id;
    end if;
 
 --сохранение входных параметров в таблицу  temp_kurs  
     l_id_message:=SaveMaessage( l_user_id, p_json, 'CreateUpdateGorProg' ); 
    
    --установка глобальных переменных
     l_result:= Set_Global_Var( l_user_id );
     if ( l_result  is not  null ) then
        l_result:=  CreateResultMessage( 1,l_result );
        SaveResultMaessage( l_id_message, l_result );
        return ( l_result );
     end if;
 
 
     --получение параметров
     l_json := json(p_json);
     
     /*
     {
      DcId--ид если пуст то добавление
  Action; --операция --1=добавление  --2= изменение 3- удаления
  AffairId; ид кпу
  DocNnum --документ основание номер 
  DocDate --документ основание дата
  DocType  --документ основание источник поступления 179
  
  Zdate --дата заявления
  Zstatus --статус 177
  Zinfo --доп информация
  
  DocIinfo--дополнительные документы
  DelDate --дата анулирования
  DelReason-- причина аннулирования
  GorProg --городская программа 166

  SrdNum --номер РД о переводе на субсидию
  SrdDate --дата РД о переводе на субсидию
}
     */
     
     l_dcr_id:= l_json.get('DcId').get_number();
     
      l_result := pkg_rsm2.CreateUpdateGorProg(  
                                                 l_dcr_id ,-- p_id_dcr  in out  number,
                                                 l_json.get('Action').get_number(),--- p_action number,
                                                 l_json.get('AffairId').get_number(),-- p_affair_id        number,
                                                 l_json.get('DocNnum').get_string(),-- p_dос_num        varchar2,
                                                 l_json.get('DocDate').get_string(),--p_doc_date         date,
                                                 l_json.get('DocType').get_number(), --p_doc_type         number,    
                                                 l_json.get('DocIinfo').get_string(),--p_doc_notes          varchar2,
                                                 null, --p_z_type           number,
                                                 l_json.get('Zdate').get_string(),--p_z_date           date,
                                                 l_json.get('Zstatus').get_number(), --p_z_status         number,
                                                 l_json.get('Zinfo').get_string(),--p_z_notes          varchar2,
                                                 l_json.get('DelDate').get_string(),--p_cancel_date      date,
                                                 l_json.get('DelReason').get_number(), --p_cancel_reason    number,
                                                 l_json.get('GorProg').get_number(),--p_z_cp_num_id    number,   
                                                 l_json.get('SrdNum').get_string(),--p_z_rd_number varchar2,
                                                 l_json.get('SrdDate').get_string()--p_z_rd_date   date
                                                );
                               
     if  l_result is null then
        l_result:=  CreateResultMessage( 0,l_result );
     else
        l_result:=  CreateResultMessage(1,l_result );
     end if;
    
     SaveResultMaessage( l_id_message, l_result );
    
    return ( l_result );

 END CreateUpdateGorProg; 
 
 
 
 
 

end PKG_RSM2_GV;
/
