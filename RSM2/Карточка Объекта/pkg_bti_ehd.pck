CREATE OR REPLACE PACKAGE pkg_bti_ehd
IS

TYPE curstype IS REF CURSOR; -- тип ссылка на курсор 


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :27.05.2019
  -- Описание :   Получить данные из классификатора
    -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:   
Function Get_cls_data( p_nk_cls  Number, p_kod_cls  Number:=null, p_id_cls Number:=null) return varchar2   ;

-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :28.11.2017
  -- Описание :  данные по зданию
    -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:              
procedure Get_Bti_Data_Building(  p_unom number,   p_data in out curstype );


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :28.05.2019
  -- Описание :  архивные адреса 
    -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:              
procedure  Get_Bti_Data_Arh_Address(  p_unom number,   p_data in out curstype );

-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :28.05.2019
  -- Описание : данные ЕГРН 
    -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:              
procedure  Get_Ehd_General_Data_Building(  p_unom number,   p_data in out curstype );

   -- Автор  : Dik
  -- Дата создания :16.07.2019
  -- Описание : данные об объектах, в пределах которых расположена комната ЕГРН 
             
procedure  Get_Ehd_Кmn_Data_In(  p_cadast_num varchar2,   p_data in out curstype );
-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :28.05.2019
  -- Описание : данные об объектах, в пределах которых расположено здание/сооружение ЕГРН 
    -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:              
procedure  Get_Ehd_Data_With_Building(  p_cadast_num varchar2,   p_data in out curstype );

--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :28.05.2019
  -- Описание : данные об объектах расположенныехв здании/сооружении егрн 
    -- Параметры:         
    --p_type_source->тип источника данных 0-ЕГРН, 1-БТИ 
    --p_type -> 0- 'нежилое помещение'  1-'жилое помещение                                                                                      
  -- Входные:            
  -- Выходные:              
procedure  Get_Ehd_Data_Building(  p_cadast_num varchar2, p_unom number,  p_type number:=1, p_type_source number:=0, p_data in out curstype );

-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :27.05.2019
  -- Описание :   количество жилых и не жилых помещений в доме по данным BTI
  -- p_type=1 жилые
  -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:   
Function Get_Bti_Count_Space( p_unom number, p_type number) return number;

-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :27.05.2019
  -- Описание :   количество жилых и не жилых помещений в доме по данным ЕГРН
  -- p_type=1 жилые
  -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:   
Function Get_Ehd_Count_Space( p_cadast_num varchar2, p_type number) return number;       


------------------------------------------------------------------------------------------------
--для помещения
------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :25.06.2019
  -- Описание : оновные данные по помещению 
    -- Параметры:        
    --p_cadast_num -кад помещения                                                                                          
  -- Входные:            
  -- Выходные:              
procedure  Get_Bti_Data_Space(  p_cadast_num varchar2:=null,  p_unom number:=null, p_unkv number:=null,  p_nom varchar2:=null,   p_data in out curstype );


------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :25.06.2019
  -- Описание : оновные данные по помещению  по данным ЕГРП
    -- Параметры:        
    --p_cadast_num -кад помещения                                                                                          
  -- Входные:            
  -- Выходные:              
procedure  Get_Ehd_Data_Space(  p_cadast_num varchar2:=null,  p_unom number:=null, p_unkv number:=null,  p_nom varchar2:=null,   p_data in out curstype );

  -- Автор  : Dik
  -- Дата создания :27.06.2019
  -- Описание :Объекты (комнаты) в помещении
    -- Параметры:        
procedure  Get_BTI_Rooms_in_Space( p_cadast_num varchar2:=null,  p_unom number:=null, p_unkv number:=null,  p_nom varchar2:=null,   p_data in out curstype );

-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :28.05.2019
  -- Описание : данные об объектах, в пределах которых расположено здание/сооружение ЕГРН 
    -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:              
procedure  Get_Ehd_Rooms_Data_In_Building(  p_cadast_num varchar2,   p_data in out curstype );

-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :28.05.2019
  -- Описание : данные об объектах, в пределах  помещения 
  --p_cadast_num --кадастровый номер картиры
    -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:              
procedure  Get_Bti_Space_In_Rooms( p_cadast_num varchar2:=null,  p_unom number:=null, p_unkv number:=null,  p_nom varchar2:=null,   p_data in out curstype);

------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :25.06.2019
  -- Описание :права  ЕГРП
    -- Параметры:        
    --p_cadast_num -кад помещения                                                                                          
  -- Входные:            
  -- Выходные:              
procedure  Get_Ehd_Data_Right(  p_cadast_num varchar2:=null,  p_unom number:=null, p_unkv number:=null,  p_nom varchar2:=null,   p_data in out curstype );


function get_room_space (
                                        p_unom in number, 
                                        p_unkv in number,
                                        p_room in varchar2, --номер комнаты  с индексом
                                        p_sqo out number,   --  общая квартиры  BTI appart_st_cards.ppl
                                        p_sqg out number, -- жилая квартиры BTI  appart_st_cards.gpl
                                        p_sqb out number,  --  общая без летних квартиры BTI appart_st_cards.opl (get_BTI_TOTAL_SPACE(:ap_id))
                                        p_sqz out number,  --  общая с летними комнаты
                                        p_sqL out number,  --  общая без летних комнаты
                                        p_sqi out number,  --  жилая комнаты
                                        p_unpl out number, --  комнаты(для нежилых)
                                        p_str out varchar2   -- сообщение из c_ErrStr
                                ) return number ;
                                
-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :25.06.2019
  -- Описание : оновные данные по комнате по данным БТИ
    -- Параметры:        
    --p_cadast_num -кад помещения                                                                                          
  -- Входные:            
  -- Выходные:              
procedure  Get_Bti_Data_Kmn(  p_cadast_num varchar2:=null,  p_unom number:=null, p_unkv number:=null,  p_kmi varchar2:=null,   p_data in out curstype );                                

 -- Возвращает 1, если назначение комнаты в БТИ "жилая", иначе 0
    -- snz, --  Спец. назнач. комнаты   клс.87 pkg_bti_ehd.
    -- nz - CLASS_COD в bti.CLASS_BTI where class_id = 86 
function get_room_is_zhil(p_snz in number, p_nz in number) return number;

   -- Автор  : Dik
  -- Дата создания :15.07.2019
  -- Описание : получить кадастр номер комнаты по кадастр номеру квартиры и номеру комнаты
function  Get_Ehd_Cadast_for_Kmn( p_cadast_num_b varchar2, p_cadast_num_kva varchar2,  p_kmi varchar2 ) return varchar2;

   -- Автор  : Dik
  -- Дата создания :15.07.2019
  -- Описание : оновные данные по комнате  по данным ЕГРП
    -- Параметры:        
    --p_cadast_num_kva -кад помещения - квартиры                                                                                          
         
procedure  Get_Ehd_Data_Kmn(p_cadast_num_kva varchar2, p_unom number, p_unkv number, p_kmi varchar2, p_data in out curstype );
   -- Автор  : Dik
  -- Дата создания :15.07.2019
  -- Описание : получить кадастр номер квартиры по кадастр номеру здания и номеру квартиры
function  Get_Ehd_Cadast_for_Room( p_cadast_num_b varchar2,  p_kva varchar2 ) return varchar2;

procedure  Get_Ehd_Kmn_Data_Right(  p_cadast_num varchar2:=null,  p_unom number:=null, p_unkv number:=null,  p_nom varchar2:=null,   p_data in out curstype );
   
   -- Автор  : Dik
  -- Дата создания :30.07.2019
  -- Описание : Получить кадастровый номер здания по Unom 
Function get_building_cadastr(p_unom number) return varchar2; 
 
   -- Автор  : Dik
  -- Дата создания :30.07.2019
procedure  Get_FIAS_ADDDRES(  p_search_param varchar2,  p_mode number:=0,  p_data in out curstype );
procedure  Get_FIAS_FULL_ADDDRES( p_aoguid_1_region varchar2, p_aoguid_3_area varchar2, p_aoguid_4_city varchar2, 
                                  p_aoguid_6_place varchar2, p_aoguid_65_plan varchar2, p_aoguid_7_street varchar2,  p_data in out curstype );

END pkg_bti_ehd;
/
CREATE OR REPLACE PACKAGE BODY pkg_bti_ehd
IS 

-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :27.05.2019
  -- Описание :   Получить данные из классификатора
    -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:   
Function Get_cls_data( p_nk_cls  Number, p_kod_cls  Number:=null, p_id_cls Number:=null) return Varchar2         
as
  l_result  VARCHAR2(255);
begin
     select  nm   Into l_result
     from IZK_RSM_MAIN.IMPORT_BTI_KLS@IZK_RSM_MAIN cls
     where cls.nk=p_nk_cls
            and  case when p_kod_cls is null then id else kod  end =  case when p_kod_cls is null then p_id_cls else p_kod_cls  end
            and rownum=1;

       return ( l_result );

exception
    when no_data_found then
        return null;
     when others then
        raise;
end;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :27.05.2019
  -- Описание :   количество жилых и не жилых помещений в доме по данным BTI
  -- p_type=1 жилые
  -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:   
Function Get_Bti_Count_Space( p_unom number, p_type number) return number         
as
  l_result  number;
begin
    select   count(*)  into l_result from  IZK_RSM_MAIN.IMPORT_BTI_FADS@IZK_RSM_MAIN fad
    join IZK_RSM_MAIN.IMPORT_BTI_FKVA@IZK_RSM_MAIN kva on FAD.UNOM=KVA.UNOM 
     where  
            fad.unom=p_unom 
             and fad.main_adr=1 
             and  fad.adr_type in (26796, 26795)
             and kva.kl in (select trim (regexp_substr (otypes,  '[^,]+',  1,   level)) 
                                                     from (
                                                                select  case when p_type=1 then '1' else '2,3' end as otypes   from dual
                                                            )
                                                    start with otypes is not null
                                                    connect by instr (otypes, ',', 1,  level - 1) > 0);

     
       return ( l_result );
end;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :27.05.2019
  -- Описание :   количество жилых и не жилых помещений в доме по данным ЕГРН
  -- p_type=1 жилые
  -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:   
Function Get_Ehd_Count_Space( p_cadast_num varchar2, p_type number) return number         
as
  l_result  number;
begin
    
  SELECT count(*) into l_result
            FROM IZK_RSM_MAIN.IMPORT_EHD_BUILDING_PARCEL@IZK_RSM_MAIN b  
                join IZK_RSM_MAIN.IMPORT_EHD_REGISTER@IZK_RSM_MAIN c on c.building_parcel_id = b.id 
            where 
                   c.cadastral_number_oks =p_cadast_num
                   -- c.cadastral_number_oks = '77:09:0004004:1011'
                    and b.actual is null
                    and c.assftp_cd= case when p_type=1 then  'Жилое помещение' else 'Нежилое помещение' end;
     
       return ( l_result );
end;





-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :27.05.2019
  -- Описание :  данные по зданию
    -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:              
procedure  Get_Bti_Data_Building(  p_unom number,   p_data in out curstype )
as
begin

    OPEN  p_data  FOR
    
    select 
         fad.adres          as BTI_ADRES--основной /официальный адрес
        ,fad.unad           as  BTI_UNAD--нПорядковый номер адреса для объекта
        ,fad.UNOM  
        ,pkg_bti_ehd.Get_cls_data(115, null , fad.ADR_TYPE) as   BTI_ADR_TYPE_NAME --Тип адреса. Классификатор 115
        ,fad.main_adr   as  BTI_MAIN_ADR
        ,fad.ADR_TYPE as BTI_ADR_TYPE
        ,fad.ao             as BTI_AO
        ,fad.mr            as BTI_MR
        ,pkg_bti_ehd.Get_cls_data(35, fsk.naz ,null)    as BTI_NAZ --Назначение объекта (классификатор 35)
        ,fad.KAD_N       as BTI_KAD_N --  Кадастровый номер объекта недвижимости.
        ,fad.KAD_ZU     as BTI_KAD_ZU--   Кадастровый номер земельного участка (для ОКС).
        ,fad.N_FIAS      as BTI_N_FIAS --   Код (GUID) ФИАС для адреса
        ,fsk.et              as BTI_ET--этажность   
        ,fsk.GDPOSTR   as  BTI_GDPOSTR--год постройки
        ,pkg_bti_ehd.Get_cls_data(89, fsk.sost ,null)         as BTI_SOST --Состояние статкарты. Классиф. 89
        ,fsk.NARPL       as BTI_NARPL--Площадь строения по наружнему обмеру (площадь застройки)
        ,pkg_bti_ehd.Get_cls_data(160, null, fsk.obj_type )    as BTI_OBJ_TYPE_NAME --Тип объекта недвижимости. Классификатор 160
        ,pkg_bti_ehd.Get_cls_data(531, null ,fad.p1) as  BTI_SUBJECT_NAME --сгьбъект РФ
        ,pkg_bti_ehd.Get_cls_data(44,  fad.ao, null) as BTI_OA_NAME --округ
        ,pkg_bti_ehd.Get_cls_data(45,  fad.mr, null) as  BTI_MR_NAME --район
        ,pkg_bti_ehd.Get_cls_data(534, null ,fad.p6) as  BTI_LOCALITY_NAME --населенный пункт
        ,pkg_bti_ehd.Get_cls_data(562, null ,fad.p7) as  BTI_STREET_NAME --улица
        ,decode( fad.l1_type, 26824, L1_Value,'')   as BTI_HOUSE_NUM--номер дома
        ,L2_Value           as BTI_KORP_NUM--номер корпуса
        ,L3_Value           as BTI_SRT_NUM--номер строения
        ,L4_Value           as BTI_SPC_NUM--номер помещения 
        ,decode( fad.l1_type, 26823, L1_Value,'')            as BTI_VLAD_NUM--номер владения
        ,pkg_bti_ehd.Get_cls_data(49, null ,fsk.kl ) as  BTI_KL_NAME --Назначение / класс объекта (клс.49 БТИ: жилые, нежилые и т.д.)
        ,trim(to_char( fsk.PDVPL_N, '999999999990D9','nls_numeric_characters = '',.'''  ))      as BTI_PDVPL_N--Нежилая площадь подвало
        ,trim(to_char(  (nvl(fsk.K1GPL,0)+nvl(fsk.K2GPL,0)+nvl(fsk.K3GPL,0)+nvl(fsk.K4GPL,0)+nvl(fsk.K5GPL,0)), '999999999990D9','nls_numeric_characters = '',.'''  )) as BTI_ALL_G --Жилая площадь жилых помещений
        ,trim(to_char( fsk.OPL, '999999999990D9','nls_numeric_characters = '',.'''  ) )           as BTI_OPL--Общая площадь
        ,trim(to_char( fsk.OPL_G, '999999999990D9','nls_numeric_characters = '',.'''  ) )       as BTI_OPL_G--Общая площадь жилых помещени
        ,trim(to_char( fsk.OPL_N, '999999999990D9','nls_numeric_characters = '',.'''  ))        as BTI_OPL_N-- Общая площадь нежилых помещений     
        ,fsk.PMQ_G        as BTI_PMQ_G--Количество жилых помещений
        ,fsk.KWQ           as BTI_KWQ--  Количество квартир
        ,fsk.KMQ_G        as BTI_KMQ_G --Количество комнат в жилых помещениях
        ,fsk.KWKMQ       as BTI_KWKMQ --   Количество  жилых комнат в квартирах
        ,fsk.PMQ_OKV    as BTI_PMQ_OKV--Количество помещений типа "общежитие квартирного типа"       
        ,fsk.KMQ_OKV    as BTI_KMQ_OKV --Количество жилых комнат типа "общежитие квартирного типа"     
        ,fsk.PMQ_OBS    as BTI_PMQ_OBS --Количество помещений типа "общежитие"       
        ,fsk.KMQ_OBS    as bti_KMQ_OBS  --Количество жилых комнат типа "общежитие"     
        ,fsk.PMQ_KOR    as BTI_PMQ_KOR --Количество помещений типа "коридорная система"      
        ,fsk.KMQ_KOR    as BTI_KMQ_KOR  --Количество жилых комнат типа  "коридорная система"     
        ,fsk.K1Q            as BTI_K1Q--Количество 1-комнатных квартир       
        ,trim(to_char( fsk.K1OPL, '999999999990D9','nls_numeric_characters = '',.'''  ))         as BTI_K1OPL  --Общая площадь 1-комнатных квартир     
        ,trim(to_char( fsk.K1GPL, '999999999990D9','nls_numeric_characters = '',.'''  ))         as BTI_K1GPL   --Жилая площадь 1-комнатных квартир     
        ,fsk.K2Q            as BTI_K2Q --Количество 2-комнатных квартир       
        ,trim(to_char( fsk.K2OPL, '999999999990D9','nls_numeric_characters = '',.'''  ))         as BTI_K2OPL   --Общая площадь 2-комнатных квартир     
        ,trim(to_char( fsk.K2GPL, '999999999990D9','nls_numeric_characters = '',.'''  ))         as BTI_K2GPL   --Жилая площадь 2-комнатных квартир     
        ,fsk.K3Q            as BTI_K3Q --Количество 3-комнатных квартир       
        ,trim(to_char( fsk.K3OPL, '999999999990D9','nls_numeric_characters = '',.'''  ))         as BTI_K3OPL    --Общая площадь 3-комнатных квартир      
        ,trim(to_char( fsk.K3GPL, '999999999990D9','nls_numeric_characters = '',.'''  ))         as BTI_K3GPL --Жилая площадь 3-комнатных квартир      
        ,fsk.K4Q            as BTI_K4Q --Количество 4-комнатных квартир       
        ,trim(to_char( fsk.K4OPL, '999999999990D9','nls_numeric_characters = '',.'''  ))       as BTI_K4OPL  --Общая площадь 4-комнатных квартир     
        ,trim(to_char( fsk.K4GPL, '999999999990D9','nls_numeric_characters = '',.'''  ))        as BTI_K4GPL  --Жилая площадь 4-комнатных квартир     
        ,fsk.K5Q            as BTI_K5Q--Количество 5 и более-комнатных квартир     
        ,trim(to_char( fsk.K5OPL, '999999999990D9','nls_numeric_characters = '',.'''  ))         as BTI_K5OPL   --Общая площадь 5 и более-комнатных квартир     
        ,trim(to_char( fsk.K5GPL, '999999999990D9','nls_numeric_characters = '',.'''  ))         as BTI_K5GPL  --Жилая площадь 5 и более-комнатных квартир     
        ,trim(to_char( fsk.NPL, '999999999990D9','nls_numeric_characters = '',.'''  ))             as BTI_NPL --Нежилая площадь. Включает в себя OPL_N плюс площадь жилых комнат в нежилых помещениях (OPL_U)
        ,'Выверен'        as stsObj --статус выверки объекта 
        ,pkg_bti_ehd.Get_cls_data(3,  fsk.MST ,null )    as BTI_MST -- Материал стен. Классификатор 3
        ,decode(fsk.PAMARC,1,'Да', 2 ,'Нет', ''  )  as BTI_PAMARC       --Отметка: памятник архитектуры. 1 - да, 2 - нет
        ,pkg_bti_ehd.Get_cls_data(63,  fsk.SER ,null )    as BTI_SER --Серия проекта. Классификатор 63
        ,to_char(trim( (select count(*)  from   IZK_RSM_MAIN.IMPORT_BTI_FADS@IZK_RSM_MAIN fad 
                                        where fad.main_adr<>1 and  fad.unom= p_unom))) as BTI_COUBT_ARH_ADR--количество архивных адресов
        ,pkg_bti_ehd.Get_Bti_Count_Space(p_unom, 1 )  as  BTI_COUNT_LIVE--количество жилых помещений
        ,pkg_bti_ehd.Get_Bti_Count_Space(p_unom, 2 ) as  BTI_COUNT_NOLIVE --количество нежилых помещений
         from  IZK_RSM_MAIN.IMPORT_BTI_FADS@IZK_RSM_MAIN fad 
        --join BTI_DATA.KLS@IZK_RSM_MAIN klss  on fad.ADR_TYPE=klss.id and klss.nk=115
        join IZK_RSM_MAIN.IMPORT_BTI_FSKS@IZK_RSM_MAIN fsk on fsk.obj_id=fad.obj_id and fsk.obj_type=fad.obj_type
       -- join BTI_DATA.KLS@IZK_RSM_MAIN klnaz  on fsk.naz=klnaz.kod and klnaz.nk=35
--        join BTI_DATA.KLS@IZK_RSM_MAIN klsost  on fsk.sost=klsost.kod and klsost.nk=89  
  --      join BTI_DATA.KLS@IZK_RSM_MAIN kltp  on fsk.obj_type=kltp.id and kltp.nk=160  
    where fad.main_adr=1
     and fad.adr_type in (26796, 26795)
     --and  fad.unom=1402 
     and  fad.unom=p_unom ;

end Get_Bti_Data_Building;



-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :28.05.2019
  -- Описание :  архивные адреса 
    -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:              
procedure  Get_Bti_Data_Arh_Address(  p_unom number,   p_data in out curstype )
as
begin

    OPEN  p_data  FOR
     select 
        fad.adres --основной /официальный адрес
       ,fad.unad  --нПорядковый номер адреса для объекта
       ,fad.unom 
       ,pkg_bti_ehd. Get_cls_data(115, null, fad.ADR_TYPE)    adr_type_name
       ,pkg_bti_ehd. Get_cls_data(35, fsk.naz, null) NAZ
       ,pkg_bti_ehd. Get_cls_data(160, null, fsk.obj_type) obj_type_name
     from   IZK_RSM_MAIN.IMPORT_BTI_FADS@IZK_RSM_MAIN fad 
        join IZK_RSM_MAIN.IMPORT_BTI_FSKS@IZK_RSM_MAIN fsk on fsk.obj_id=fad.obj_id and fsk.obj_type=fad.obj_type
    where fad.main_adr<>1
     --and fad.adr_type in (26796, 26795)
     and  fad.unom= p_unom 
     order by fad.unad  nulls first;

end Get_Bti_Data_Arh_Address;



-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :28.05.2019
  -- Описание : общие данные ЕГРН 
    -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:              
procedure  Get_Ehd_General_Data_Building(  p_unom number,   p_data in out curstype )
as
begin

    OPEN  p_data  FOR
        select   
                 to_char( b.area, '999999999990D9','nls_numeric_characters = '',.'''  )   as  ehd_area --Площадь, кв.м
                 ,b.type                       as  ehd_vid_object --Вид объекта
                 ,b.object_id                as  ehd_Cadast_num--Кадастровый номер здания
                 ,b.assignation_code     as  ehd_naz--Назначение
                 ,to_char(r.date_created,'dd.mm.yyyy')           as  ehd_cad_cdate--Дата присвоения кадастрового номера
                 ,to_char(r.date_removed,'dd.mm.yyyy')         as  ehd_cad_rdate--Дата снятия с кадастрового учета
                 ,r.state                       as  ehd_state_object--Статус объекта 
                 ,r.cadastral_number    as  ehd_cad_num
                 ,l.address_total           as  ehd_adrress---Адрес (полной строкой)
                 ,l.region                     as  ehd_SUBJECT_NAME--Субъект РФ
                 ,l.urban_district           as  ehd_Municipal_name --Муниципальный округ, поселение
                 ,l.locality                    as  ehd_punkt_NAME--Населенный пункт
                 ,l.street                      as ehd_street_name--Улица (пер., бульв., просп. и др.)
                 ,l.level1                      as ehd_HOUSE_NUM--Дом
                 ,l.level2                      as ehd_KORP_NUM--Корпус 
                 ,l.level3                      as ehd_SRT_NUM--Строение
                 ,e.year_used              as  ehg_year_vod --Год ввода в эксплуатацию 
                 ,e.year_built               as  ehd_year_stroi--Год завершения строительства
                 ,ec.wall                      as ehd_mst--Материал стен
                 ,f.floors                      as ehd_et --Количество этажей
                 ,f.underground_floors  as ehd_podvl--Количество этажей, в том числе подземных этажей
                 ,trim( to_char(c.value,'999G999G999G999G990D99','nls_numeric_characters = '', '''))     as ehd_cost--Кадастровая стоимость, руб. 99D99
                 ,to_char(c.cadcost_dtent,'dd.mm.yyyy')          as ehd_cost_dedit--Дата внесения стоимости
                 ,to_char(c.cadcost_dtappr,'dd.mm.yyyy')        as ehd_cost_dconfirm--Дата утверждения стоимости
                 ,to_char(c.cadcost_dtval,'dd.mm.yyyy')           as  ehd_cost_ddefin --Дата определения стоимости
                ,pkg_bti_ehd.Get_Ehd_Count_Space( r.cadastral_number, 1 )  as  ehd_count_live--количество жилых помещений
                ,pkg_bti_ehd.Get_Ehd_Count_Space( r.cadastral_number, 2 ) as  ehd_count_nolive --количество нежилых помещений
       from IZK_RSM_MAIN.IMPORT_EHD_BUILDING_PARCEL@IZK_RSM_MAIN b  
        join IZK_RSM_MAIN.IMPORT_EHD_LOCATION@IZK_RSM_MAIN l on l.building_parcel_id = b.id
        join IZK_RSM_MAIN.IMPORT_EHD_REGISTER@IZK_RSM_MAIN r on r.building_parcel_id = b.id
        left join IZK_RSM_MAIN.IMPORT_EHD_CADASTRAL_COST@IZK_RSM_MAIN c  on c.building_parcel_id = b.id
        join IZK_RSM_MAIN.IMPORT_EHD_EXPLOITATION_CHAR@IZK_RSM_MAIN e on E.BUILDING_PARCEL_ID=b.id
        join IZK_RSM_MAIN.IMPORT_EHD_ELEMENTS_CONSTRUCT@IZK_RSM_MAIN ec on EC.BUILDING_PARCEL_ID=b.id
        join IZK_RSM_MAIN.IMPORT_EHD_FLOORS@IZK_RSM_MAIN f on F.BUILDING_PARCEL_ID=b.id 
        join IZK_RSM_MAIN.IMPORT_BTI_FADS@IZK_RSM_MAIN  fad  on fad.KAD_N=R.CADASTRAL_NUMBER--  cadastral_number_oks 
        where b.actual is null
            and fad.MAIN_ADR=1 and  
            fad.adr_type in (26796, 26795)
           -- and fad.UNOM=1401
            and fad.UNOM=p_unom;

end Get_Ehd_General_Data_Building;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :28.05.2019
  -- Описание : данные об объектах, в пределах которых расположено здание/сооружение ЕГРН 
    -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:              
procedure  Get_Ehd_Data_With_Building(  p_cadast_num varchar2,   p_data in out curstype )
as
begin

    OPEN  p_data  FOR
    
        select     c.cadastral_number   as  ehd_cadast_num  -- кадастр -земельный участок для здания
                   -- ,b.type                       as  ehd_vid_object --Вид объекта
                    ,'участок'                       as  ehd_vid_object --Вид объекта
                    ,r.state                       as  ehd_state_object--Статус объекта 
                    --,b.assignation_code     as  ehd_naz--Назначение
                    ,'Для многоквартирной застройки'     as  ehd_naz--Назначение
    from IZK_RSM_MAIN.IMPORT_EHD_BUILDING_PARCEL@IZK_RSM_MAIN b 
            join IZK_RSM_MAIN.IMPORT_EHD_REGISTER@IZK_RSM_MAIN r on r.building_parcel_id = b.id  
            join IZK_RSM_MAIN.IMPORT_EHD_CAD_NUM_REF@IZK_RSM_MAIN c on r.id=c.parent_cadastral_numbers
    where b.object_id=p_cadast_num
          --  b.object_id='77:09:0004004:1011' -- кадастровый номер здания/сооружения
          and b.actual is null ;

end Get_Ehd_Data_With_Building;



-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :28.05.2019
  -- Описание : данные об объектах расположенныехв здании/сооружении егрн 
    -- Параметры:         
    --p_type_source->тип источника данных 0-ЕГРН, 1-БТИ 
    --p_type -> 0- 'нежилое помещение'  1-'жилое помещение                                                                                      
  -- Входные:            
  -- Выходные:              
procedure  Get_Ehd_Data_Building(  p_cadast_num varchar2, p_unom number,  p_type number:=1, p_type_source number:=0, p_data in out curstype )
as
    l_unom number;
begin
    
    --данные EГРН
    if (p_type_source=0) then
    
        OPEN  p_data  FOR
            SELECT 
                    rownum as rnum --номер строки
                    ,c.cadastral_number   as  cadast_num  -- кадастр -земельный участок для здания
                    ,null  unom
                    ,null  unkv
                    ,trim(to_char( b.area, '999999999990D9','nls_numeric_characters = '',.'''  ))   as opl --Площадь, кв.м
                    ,null gpl
                    ,null ppl
                    ,b.type                       as type_name --Вид объекта
                    ,l.apartment as ap_num --Номер помещения
            FROM IZK_RSM_MAIN.IMPORT_EHD_BUILDING_PARCEL@IZK_RSM_MAIN b  
                join IZK_RSM_MAIN.IMPORT_EHD_REGISTER@IZK_RSM_MAIN c on c.building_parcel_id = b.id 
                join IZK_RSM_MAIN.IMPORT_EHD_LOCATION@IZK_RSM_MAIN l on l.building_parcel_id = b.id
            where 
                    c.cadastral_number_oks =p_cadast_num
             -- c.cadastral_number_oks = '77:09:0004004:1011' 
                    and b.actual is null
                    and c.assftp_cd= case when p_type=1 then  'Жилое помещение' else 'Нежилое помещение' end
           order by
           to_number(regexp_substr(l.apartment, '[0-9]+')) nulls first, l.apartment
           -- NLSSORT( l.apartment, 'NLS_SORT=BINARY_AI')  --BINARY_AI, BINARY_CI       
           ;
           
    end if;
    
    --Даннве БТИ
    if (p_type_source=1) then
     
        l_unom:=p_unom;
      --если пуст Unom
        if  l_unom is null then
            begin
                select fad.unom into l_unom   from  IZK_RSM_MAIN.IMPORT_BTI_FADS@IZK_RSM_MAIN fad
                where  FAD.kad_n=p_cadast_num  and fad.MAIN_ADR=1 and  fad.adr_type in (26796, 26795);
            exception
            when no_data_found then
                l_unom:=null;
            end;
        end if;
         
        OPEN  p_data  FOR
        
        
            select-- kva.*,  kva.kl,
            rownum as rnum --номер строки
            ,Decode(kva.kad_n, NULL, Get_Ehd_Cadast_for_Room(p_cadast_num,kva.kvnom), kva.kad_n) as cadast_num
          --  ,kva.kad_n as cadast_num
            ,kva.unom
            ,kva.unkv
            ,trim(to_char( kva.opl, '999999999990D9','nls_numeric_characters = '',.'''  ))   as opl --Площадь общая, кв.м
            ,trim(to_char( kva.gpl, '999999999990D9','nls_numeric_characters = '',.'''  ))   as gpl --Площадьжилая, кв.м
            ,trim(to_char( kva.ppl, '999999999990D9','nls_numeric_characters = '',.'''  ))   as ppl --Площадь приведенная, кв.м
             ,pkg_bti_ehd. Get_cls_data(85,  kva.tp, null)   as  type_name   
             ,kva.kvnom as  ap_num --Номер помещения   
              from  IZK_RSM_MAIN.IMPORT_BTI_FADS@IZK_RSM_MAIN fad
            join IZK_RSM_MAIN.IMPORT_BTI_FKVA@IZK_RSM_MAIN kva on FAD.UNOM=KVA.UNOM 
            where  
                ( fad.kad_n= p_cadast_num or fad.unom=l_unom) 
                and fad.main_adr=1 
                and  fad.adr_type in (26796, 26795)
                and kva.kl in (select trim (regexp_substr (otypes,  '[^,]+',  1,   level)) 
                                                     from (
                                                                select  case when p_type=1 then '1' else '2,3' end as otypes   from dual
                                                            )
                                                    start with otypes is not null
                                                    connect by instr (otypes, ',', 1,  level - 1) > 0)
             order by
              to_number(regexp_substr(kva.kvnom, '[0-9]+')) nulls first, kva.kvnom;
           
    end if;
 

--select  kl  from   IZK_RSM_MAIN.IMPORT_BTI_FKVA@IZK_RSM_MAIN
--group by kl

end Get_Ehd_Data_Building;


------------------------------------------------------------------------------------------------
--для помещения
------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :25.06.2019
  -- Описание : оновные данные по помещению  по данным БТИ
    -- Параметры:        
    --p_cadast_num -кад помещения                                                                                          
  -- Входные:            
  -- Выходные:              
procedure  Get_Bti_Data_Space(  p_cadast_num varchar2:=null,  p_unom number:=null, p_unkv number:=null,  p_nom varchar2:=null,   p_data in out curstype )
as
    l_unom number := NULL;
    l_unkv number := NULL;
    l_kvnom varchar2(50) := NULL;
    l_bti_cadast_num_build varchar2(50):=NULL; --кадастровый номер задния
begin

    l_unom:=p_unom;
    l_unkv:=p_unkv;
    --l_kvnom:=p_nom;
    
    --попробуем найти инфу в бти
    if (l_unkv is null) and (p_cadast_num is not null) then
        begin
        select unom, unkv, kvnom  into l_unom, l_unkv, l_kvnom from  IZK_RSM_MAIN.IMPORT_BTI_FKVA@IZK_RSM_MAIN kva  where kva.kad_n = p_cadast_num;
        exception 
         when no_data_found then  l_unkv:=null;
         when others then         l_unkv:=null;
        end;
    end if;
-- Dik    
  if (l_unom is null) and (p_cadast_num is null) then
     return;
  end if;  
   
  if (l_kvnom is null) and (p_nom is not null) then 
    l_kvnom := lower(trim(substr(p_nom, REGEXP_INSTR(p_nom,'\d'))));
   end if; 
-- / Dik       
   OPEN  p_data  FOR
        
              select-- kva.*,  kva.kl,
                    adr.adres  as bti_adres      --адрес помещения
                    ,adr.KAD_ZU as bti_kad_z     --земельный участок
                    ,Decode(kva.kad_n, NULL, Get_Ehd_Cadast_for_Room(adr.kad_n,kva.kvnom), kva.kad_n) as bti_cadast_num --кадастровы    номер помещения
                   /* -- Dik
                   ,(select  kad_n  from  IZK_RSM_MAIN.IMPORT_BTI_FADS@IZK_RSM_MAIN  
                            where main_adr=1 
                            and adr_type in (26796, 26795)
                            and unom=kva.unom 
                            and rownum=1)  as bti_cadast_num_build --кадастровый номер задния
                     */
                    ,adr.kad_n as bti_cadast_num_build      
                    ,kva.unom 
                    ,kva.unkv
                    ,trim(to_char( kva.opl, '999999999990D9','nls_numeric_characters = '',.'''  ))   as bti_opl --Площадь общая, кв.м
                    ,trim(to_char( kva.gpl, '999999999990D9','nls_numeric_characters = '',.'''  ))   as bti_gpl --Площадьжилая, кв.м
                    ,trim(to_char( kva.ppl, '999999999990D9','nls_numeric_characters = '',.'''  ))   as bti_ppl --Площадь приведенная, кв.м
                    ,pkg_bti_ehd. Get_cls_data(85,  kva.tp, null)   as  bti_type_name   --тип помещения
                    ,kva.kvnom as  bti_ap_num --Номер помещения   
                    ,kva.et  as bti_et--этаж
                    ,pkg_bti_ehd. Get_cls_data(83,  kva.kl, null)   as  bti_klass --класс помещения  
                    ,kva.NSEK bti_nsek--номер подъезда
                    ,kva.KMQ  bti_kmq--Количество жилых комнат
                    ,'Выверен'   stsobj --статус объекта
                from   IZK_RSM_MAIN.IMPORT_BTI_FKVA@IZK_RSM_MAIN kva  
                join IZK_RSM_MAIN.IMPORT_BTI_FADS@IZK_RSM_MAIN adr on adr.unom= kva.unom  and adr.main_adr=1   and adr.adr_type in (26796, 26795)  
                where  
                   ((kva.kad_n = p_cadast_num) or (kva.unom = l_unom) )
                    and ( (kva.unkv = l_unkv) or (lower(trim(kva.kvnom))=l_kvnom)) 
                   and rownum=1;
                
end Get_Bti_Data_Space;


------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :25.06.2019
  -- Описание : оновные данные по помещению  по данным ЕГРП
    -- Параметры:        
    --p_cadast_num -кад помещения                                                                                          
  -- Входные:            
  -- Выходные:              
procedure  Get_Ehd_Data_Space(  p_cadast_num varchar2:=null,  p_unom number:=null, p_unkv number:=null,  p_nom varchar2:=null,   p_data in out curstype )
as
    l_cadast_num varchar2(50);
begin

    l_cadast_num:=p_cadast_num;
    
    --попробуем найти уном в бти
    if l_cadast_num is null  then
        begin
            select kva.kad_n into l_cadast_num  from  IZK_RSM_MAIN.IMPORT_BTI_FKVA@IZK_RSM_MAIN kva  where kva.unom= p_unom and ( kva.unkv=p_unkv or kva.kvnom=p_nom );
        exception 
         when no_data_found then l_cadast_num:=null;
         when others then l_cadast_num:=null;
        end;
     end if;
        
    OPEN  p_data  FOR
        
              SELECT 
                    l.ADDRESS_TOTAL  as ehd_adres    --адрес помещения
                    ,null as ehd_kad_z--земельный участок
                    ,c.cadastral_number as ehd_cadast_num --кадастровы    номер помещения
                     ,c.cadastral_number_oks as ehd_cadast_num_build --кадастровый номер задния
                    ,null  unom 
                    ,null unkv
                    ,trim(to_char( b.area, '999999999990D9','nls_numeric_characters = '',.'''  ))   as ehd_opl --Площадь общая, кв.м
                    ,null  as ehd_gpl --Площадьжилая, кв.м
                    ,null  as ehd_ppl --Площадь приведенная, кв.м
                    --, b.type   as  bti_type_name   --тип помещения
                    ,C.ASSFTP1   as ehd_type_name   --тип помещения
                    ,l.apartment as  ehd_ap_num --Номер помещения   
                    ,null  as ehd_et--этаж
                    ,C.ASSFTP_CD    as  ehd_klass --класс помещения  
                    ,null  as ehd_nsek--номер подъезда
                    ,null  as ehd_kmq--Количество жилых комнат
                    ,to_char(c.date_created,'dd.mm.yyyy')        as  ehd_cad_cdate--Дата присвоения кадастрового номера
                    ,to_char(c.date_removed,'dd.mm.yyyy')      as  ehd_cad_rdate--Дата снятия с кадастрового учета
                    ,'Выверен'   stsobj --статус объекта
                    ,trim( to_char(s.value,'999G999G999G999G990D99','nls_numeric_characters = '', '''))     as ehd_cost--Кадастровая стоимость, руб. 99D99
                    ,to_char(s.cadcost_dtent,'dd.mm.yyyy')         as ehd_cost_dedit--Дата внесения стоимости
                    ,to_char(s.cadcost_dtappr,'dd.mm.yyyy')      as ehd_cost_dconfirm--Дата утверждения стоимости
                    ,to_char(s.cadcost_dtval,'dd.mm.yyyy')         as  ehd_cost_ddefin --Дата определения стоимости
            FROM IZK_RSM_MAIN.IMPORT_EHD_BUILDING_PARCEL@IZK_RSM_MAIN b 
                join IZK_RSM_MAIN.IMPORT_EHD_REGISTER@IZK_RSM_MAIN c on c.building_parcel_id = b.id
                join IZK_RSM_MAIN.IMPORT_EHD_LOCATION@IZK_RSM_MAIN l on l.building_parcel_id = b.id
                left join IZK_RSM_MAIN.IMPORT_EHD_CADASTRAL_COST@IZK_RSM_MAIN s  on s.building_parcel_id = b.id
            where 
                    c.cadastral_number =l_cadast_num
                  -- c.cadastral_number = '77:04:0005007:4012'
                    and b.actual is null
                    and rownum=1  ;
                  -- and c.assftp_cd= case when p_type=1 then  'Жилое помещение' else 'Нежилое помещение' end
                
end Get_Ehd_Data_Space;


  -- Автор  : Dik
  -- Дата создания :27.06.2019
  -- Описание :Объекты (комнаты) в помещении
    -- Параметры:        
procedure  Get_BTI_Rooms_in_Space( p_cadast_num varchar2:=null,  p_unom number:=null, p_unkv number:=null,  p_nom varchar2:=null,   p_data in out curstype )
as  
  l_unom number;
  l_unkv number;
  l_kvnom varchar2(255);
begin
    l_unom:=p_unom;
    l_unkv:=p_unkv;
    l_kvnom:=p_nom;
   
    --попробуем найти уном в бти
    if l_unom is null  then
        begin
        select unom, unkv, kvnom  into l_unom, l_unkv, l_kvnom from  IZK_RSM_MAIN.IMPORT_BTI_FKVA@IZK_RSM_MAIN kva  where kva.kad_n=  p_cadast_num;
        exception 
         when no_data_found then l_unom:=null;  l_unkv:=null;
         when others then l_unom:=null;  l_unkv:=null;
        end;
    end if;
         
    OPEN  p_data  FOR 
     select km.kad_n as ehd_cadast_num_r, 
            km.kmi as kmi, 
            km.pl  as pl_r, 
            kl.nm  as nm_r  --, km.* 
    from  IZK_RSM_MAIN.IMPORT_BTI_FKVA@IZK_RSM_MAIN kv
    join   IZK_RSM_MAIN.IMPORT_BTI_FKMN@IZK_RSM_MAIN km  on kv.unom=km.unom and  kv.unkv=km.unkv and kv.bit0=0   and kv.unom=l_unom and kv.unkv=l_unkv
     left join      IZK_RSM_MAIN.IMPORT_BTI_KLS@IZK_RSM_MAIN kl   on kl.nk=86 and km.nz = kl.kod
     order by km.kmi; 
     
     exception 
         when no_data_found then 
            OPEN  p_data  FOR 
            select  NULL as ehd_cadast_num_r, 
                    NULL as kmi, 
                    NULL as pl_r, 
                    NULL as nm_r 
            from dual;
          when others then return;
          
end Get_BTI_Rooms_in_Space;

    


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :28.05.2019
  -- Описание : данные об объектах, в пределах которых расположено здание/сооружение ЕГРН 
    -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:              
procedure  Get_Ehd_Rooms_Data_In_Building(  p_cadast_num varchar2,   p_data in out curstype )
as
begin

    OPEN  p_data  FOR
    
        select   distinct  r.cadastral_number_oks   as  ehd_cadast_num  -- кадастр -земельный участок для здания
                    ,b.type                       as  ehd_vid_object --Вид объекта
                   -- ,'участок'                       as  ehd_vid_object --Вид объекта
                    ,r.state                       as  ehd_state_object--Статус объекта 
                    ,b.assignation_code     as  ehd_naz--Назначение
                    --,'Для многоквартирной застройки'     as  ehd_naz--Назначение
                    , b.area as ehd_area --площадь
    from  IZK_RSM_MAIN.IMPORT_EHD_REGISTER@IZK_RSM_MAIN r
            Join IZK_RSM_MAIN.IMPORT_EHD_BUILDING_PARCEL@IZK_RSM_MAIN  b  on b.actual is null and r.cadastral_number_oks = b.object_id
   Where r.cadastral_number = p_cadast_num ;
              --  r.cadastral_number ='77:04:0005007:4012';

end Get_Ehd_Rooms_Data_In_Building;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :28.05.2019
  -- Описание : данные об объектах, в пределах  помещения 
  --p_cadast_num --кадастровый номер картиры
    -- Параметры:                                                                                                  
  -- Входные:            
  -- Выходные:              
procedure  Get_Bti_Space_In_Rooms( p_cadast_num varchar2:=null,  p_unom number:=null, p_unkv number:=null,  p_nom varchar2:=null,   p_data in out curstype)
as
    l_unom number;
    l_unkv number;
    l_kvnom varchar2(255);
    l_cadastr_num_b varchar2(50) := Null;
begin

    l_unom:=p_unom;
    l_unkv:=p_unkv;
    l_kvnom:=p_nom;
    
    --попробуем найти уном в бти
    if l_unom is null  then
        begin
        select unom, unkv, kvnom  into l_unom, l_unkv, l_kvnom from  IZK_RSM_MAIN.IMPORT_BTI_FKVA@IZK_RSM_MAIN kva  where kva.kad_n=  p_cadast_num;
        --select unom, unkv, kvnom  from  IZK_RSM_MAIN.IMPORT_BTI_FKVA@IZK_RSM_MAIN kva  where kva.kad_n= '77:04:0005007:3688';
        exception 
         when no_data_found then l_unom:=null;  l_unkv:=null;
         when others then l_unom:=null;  l_unkv:=null;
        end;
    end if;
    
    l_cadastr_num_b := get_building_cadastr(l_unom);

    OPEN  p_data  FOR
    
        select 
           --   kmn.kad_n as bti_cadast_num
             decode(TRIM(kmn.kad_n),NULL, Get_Ehd_Cadast_for_Kmn(l_cadastr_num_b, p_cadast_num,  kmn.kmi ),TRIM(kmn.kad_n)) as bti_cadast_num
            ,pkg_bti_ehd.Get_cls_data(86, kmn.nz  ,  null ) as bti_naz--Назначение  
           -- ,l.nm as  ehd_naz--Назначение 
            ,kmn.kmi as bti_km_nom --номер
            ,kmn.pl as bti_km_area --площадь, кв.м.  
            from  IZK_RSM_MAIN.IMPORT_BTI_FKVA@IZK_RSM_MAIN kva
            join IZK_RSM_MAIN.IMPORT_BTI_FKMN@IZK_RSM_MAIN kmn on kmn.unom = kva.unom and kmn.kvi = kva.kvnom and kmn.bit0 = 0
           -- join bti_data.kls@IZK_RSM_MAIN l on l.kod = k.nz and l.nk = 86
            where --k.bit0 = 0 and 
            --f.unom = 10093 and f.kvnom = '500'
               (kva.kad_n= p_cadast_num or kva.unom=l_unom)
               and (kva.unkv= l_unkv or kva.kvnom=l_kvnom)
            order by kmn.npp;

end Get_Bti_Space_In_Rooms;


------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :25.06.2019
  -- Описание :права  ЕГРП
    -- Параметры:        
    --p_cadast_num -кад помещения                                                                                          
  -- Входные:            
  -- Выходные:              
procedure  Get_Ehd_Data_Right(  p_cadast_num varchar2:=null,  p_unom number:=null, p_unkv number:=null,  p_nom varchar2:=null,   p_data in out curstype )
as
    l_cadast_num varchar2(50);
begin

    l_cadast_num:=p_cadast_num;
    
    --попробуем найти уном в бти
    if l_cadast_num is null  then
        begin
            select kva.kad_n into l_cadast_num  from  IZK_RSM_MAIN.IMPORT_BTI_FKVA@IZK_RSM_MAIN kva  where kva.unom= p_unom and ( kva.unkv=p_unkv or kva.kvnom=p_nom );
        exception 
         when no_data_found then l_cadast_num:=null;
         when others then l_cadast_num:=null;
        end;
     end if;
     
      OPEN  p_data  FOR
      
        select 
            r.reg_open_regnum  as ehd_reg_num--рег. номер 
            ,o.ownertp_cd as ehd_own_type--тип правообладателя
            ,o.name  as ehd_own_name--наименование правообладателя 
            ,r.righttp_cd  as  ehd_right_type--вид права
            ,to_char(r.reg_open_regdt, 'dd.mm.yyyy')  as ehd_right_odate --дата открытия права
            ,to_char(r.reg_close_regdt, 'dd.mm.yyyy')  as ehd_right_cdate--дата закрытия права
            --,(nvl(r.SHARE_NUM,0) ||'/'||nvl(r.SHARE_DEN,0)) as ehd_share
            ,r.share_text as ehd_share
        from IZK_RSM_MAIN.IMPORT_EHD_BUILDING_PARCEL@IZK_RSM_MAIN b
        join IZK_RSM_MAIN.IMPORT_EHD_REGISTER@IZK_RSM_MAIN c on c.building_parcel_id = b.id and b.actual is null
        join IZK_RSM_MAIN.IMPORT_EHD_EGRP@IZK_RSM_MAIN  g on g.num_cadnum = c.cadastral_number and g.actual is null 
        join IZK_RSM_MAIN.IMPORT_EHD_RIGHT@IZK_RSM_MAIN r on r.egrp_id = g.id
        join IZK_RSM_MAIN.IMPORT_EHD_RIGHT_OWNER@IZK_RSM_MAIN o on o.right_id = r.id
        where 
        --b.object_id = '77:05:0006004:10478'
        b.object_id = l_cadast_num
        order by r.reg_open_regdt desc;
      

end Get_Ehd_Data_Right ;


------------------------------------------------------------------------------------------------
--для комнаты
------------------------------------------------------------------------------------------------

 -- Возвращает 1, если назначение комнаты в БТИ "жилая", иначе 0
    -- snz, --  Спец. назнач. комнаты   клс.87 pkg_bti_ehd.
    -- nz - CLASS_COD в bti.CLASS_BTI where class_id = 86 
    function get_room_is_zhil(p_snz in number, p_nz in number) return number
    as
    begin
    
        if( p_snz in (1,2,3,4,5) ) then
            return 1;
        end if;
        
        if(p_nz in (1, 2, 3, 11, 12, 84, 85, 86)) then    
            return 1;
        end if;
        
        return 0 ;
    end get_room_is_zhil;
    
    
    --  Возвращает жилую комнату, в которой находится заданная нежилая
    --                Сопоставление производится по Номеру комнат
    --08.06.2019 Dik Исправления подсчета 
                     -- function get_room_zhil_by_nezhil(p_unom number, p_unkv number, p_kmi varchar2) return number
    function get_room_zhil_by_nezhil(p_unom number, p_unkv number, p_km number) return number
    as
     begin
        for i in(
                  select npp, nz from IZK_RSM_MAIN.IMPORT_BTI_FKMN@IZK_RSM_MAIN r
                    where r.unom=p_unom and r.unkv=p_unkv 
                                and (get_room_is_zhil( r.snz,r.nz )=1) 
                                and TO_NUMBER(regexp_replace(r.kmi,'[^[[:digit:]]]*')) = p_km --08.06.2019 Dik
                    order by r.kmi nulls first, r.pl desc
        )loop
                return i.npp;
        end loop;
        
         return null;
    end get_room_zhil_by_nezhil ;

------------------------------------------------------------------------------------------------
-- Автор  : ilonis
-- Дата создания :28.05.2019
-- Описание :-расчет площадей для квартиры и комнаты
--08.06.2019 Dik Исправления подсчета 
-- Параметры:                                                                                                  
-- Входные:            
-- Выходные:
 function get_room_space (
                                        p_unom in number, 
                                        p_unkv in number,
                                        p_room in varchar2, --номер комнаты  с индексом 
                                        p_sqo out number,   --  общая квартиры  BTI ppl
                                        p_sqg out number, -- жилая квартиры BTI gpl
                                        p_sqb out number,  --  общая без летних квартиры BTi opl 
                                        p_sqz out number,  --  общая с летними комнаты
                                        p_sqL out number,  --  общая без летних комнаты
                                        p_sqi out number,  --  жилая комнаты
                                        p_unpl out number, --  комнаты(для нежилых)
                                        p_str out varchar2  -- сообщение из c_ErrStr
                                ) return number 
 AS
     type TErrStr is varray (11) of varchar2(150);
    c_ErrStr constant TErrStr := TErrStr('нет apart_id ; расчет невыполнен', --1
                                       'нет unom/unkv ; расчет невозможен', --2
                                       'неизвестная ошибка ; расчет невозможен', --3
                                       'нет комнат в rooms для apart_id; расчет невозможен ', --4
                                       'sum(rooms.opl) = 0 (LIV_SQ - жилая площадь квартиры = 0); расчет невозможен', --5
                                       'нет комнат в F12, занимаемые площади = 0; перерасчет невозможен', --6 (count(*) in ROOM_DOCUMENT = 0)
                                       'занимаемая жилая Sqi=0 расчет будет неверен', --7
                                       'общая квартиры (Sqo) и общая квартиры без летних(sqb) = 0; расчет будет неверен', --8
                                       'общая квартиры (Sqo) = 0; нет смысла считать sqz (общая комнаты с летними)',--9
                                       'общая квартиры без летних (sqb) = 0; нет смысла считать sqL ( общая комнаты без летних)', --10
                                       'старая формула расчета (KM_BTI/KMI_BTI - нет)' --11
                                       );
     err_idx integer  := 0; -- собств. код ошибки процедуры - индекс в c_ErrStr 0 - нет ошибок
    -- рабочие перемен. --
    v_precision number := 1 ;
    -- переменные площадей --
    v_liv_sq_bti number(8,2) := 0;
    v_blc  number(7,2):= 0;--  площадь балконов квартиры по данным БТИ
    v_vshk number(7,2):= 0;--  площадь встр. шкафов по данным БТИ
    v_blcInDelo  number(7,2):= 0;--  площадь балконов  в занимаемых комнатах по данным БТИ
    v_vshkInDelo number(7,2):= 0;--  площадь встр. шкафов в занимаемых комнатах по данным БТИ

    v_unom number := 0;
    v_unkv number := 0;
--08.06.2019 Dik     
  --  v_room varchar2(5);
    v_room number := NULL;
    v_room_idx  varchar2(1):= NULL;
--/08.06.2019 Dik        
    zh_npp number := NULL; -- флаг наличия встр. шкафа/балкона у комнаты
   
BEGIN

    p_sqo := 0; 
    p_sqg := 0;  
    p_sqb := 0;
    
    p_sqz := 0; 
    p_sqL := 0; 
    p_sqi := 0;
    p_unpl:= 0; 
    
    p_str := ' '; 
 
    v_unom := nvl( p_unom,0) ;
    v_unkv := nvl(p_unkv,0); 
   
    if  (v_unom = 0) or ( v_unkv = 0 ) then
        err_idx := 2;
        p_str := c_ErrStr(err_idx);
        return(err_idx);  
    end if;
  
    -- номер/индекс комнаты
    --08.06.2019 Dik    
    select  TO_NUMBER(regexp_replace(p_room,'[^[[:digit:]]]*')), NVL(UPPER(regexp_replace(p_room,'[^[[:alpha:]]]*')),'_') 
    into  v_room,  v_room_idx 
    from dual; 
    --/08.06.2019 Dik    
  
    -- получить площади для квартиры 
    select NVL(kva.opl,0) ,  NVL(kva.gpl,0) ,    NVL(kva.ppl,0)
            into    p_sqb,    --  общая без летних квартиры 
                    p_sqg, --  жилая квартиры BTI  appart_st_cards.gpl
                    p_sqo     --  общая квартиры  BTI appart_st_cards.ppl
     from  IZK_RSM_MAIN.IMPORT_BTI_FKVA@IZK_RSM_MAIN kva   where kva.unom=v_unom and kva.unkv=v_unkv;
     
     if  p_sqb > 0 then
        select DECODE(Round(p_sqb,v_precision)- Trunc(p_sqb,v_precision-1),1,Trunc(p_sqb,v_precision),Round(p_sqb,v_precision)) into p_sqb from dual; 
    end if;
     
     FOR room_rec IN(
        SELECT r.npp, -- N комнаты п/п в экспликации
                    r.kml, -- Литера комнаты
                    --08.06.2019 Dik   
                    --r.km, -- Номер  комнаты  nnnn
                    TO_NUMBER(regexp_replace(r.kmi,'[^[[:digit:]]]*')) as km,  
                    --r.kmi, -- номер с индексом
                    UPPER(regexp_replace(r.kmi,'[^[[:alpha:]]]*')) as kmi,
                    --08.06.2019 Dik    
                    NVL(r.nz,0) as nz,  --  Назначение комнаты      клс.86
                    r.plov, --Тип площади для формирования экспликации. Классификатор 163
                   NVL(r.snz,0) as snz, --Назначение комнаты. Классификатор 86
                   NVL(r.pl,0) as pl   --  Площадь комнаты
            FROM IZK_RSM_MAIN.IMPORT_BTI_FKMN@IZK_RSM_MAIN r
                WHERE  r.unom=v_unom  AND r.unkv = v_unkv --and r.bt0=0
        ) LOOP
    
            IF( Get_Room_Is_Zhil(room_rec.snz, room_rec.nz)=1) THEN
                    --Площадь всех жилых комнат
                    v_liv_sq_bti := v_liv_sq_bti + room_rec.pl;
      
                    -- жилая требуемой комнаты
--08.06.2019 Dik 
                    --   if (room_rec.km = v_room) and (room_rec.kmi = p_room)  then 
                    if (room_rec.km = v_room) and (v_room_idx = NVL(Trim(room_rec.kmi),'_')) 
--/08.06.2019 Dik                       
                     then  p_sqi := room_rec.pl; 
                    end if;
       
             ELSIF (room_rec.nz=9) THEN
                    --Жилая, в которой расположен шкаф
                   -- zh_npp := Get_Room_Zhil_By_Nezhil(v_unom, v_unkv, room_rec.kmi );
                    zh_npp := Get_Room_Zhil_By_Nezhil(v_unom, v_unkv, room_rec.km ); --08.06.2019 Dik 
                    if (zh_npp is not null) then
                        --Площадь шкафов во всех жилых комнатах
                        v_vshk := v_vshk +room_rec.pl;
                        --Площадь шкафов требуемой комнаты
                     -- if (room_rec.kmi = p_room)   then 
                        if (room_rec.km = v_room)   then --08.06.2019 Dik 
                             v_vshkInDelo := v_vshkInDelo + room_rec.pl; 
                        end if;                    
                    end if;
            
            ELSIF( room_rec.nz IN (15,17,18,27,28,29) )THEN
                --Жилая, в которой расположен балкон
                zh_npp:=Get_Room_Zhil_By_Nezhil(v_unom, v_unkv, room_rec.km );
            
                if (zh_npp is not null) then
                    --Площадь балконов во всех жилых комнатах
                    v_blc:=v_blc + room_rec.pl;
                       -- if (room_rec.kmi = p_room)   then 
                   if (room_rec.km = v_room)   then --08.06.2019 Dik 
                        v_blcInDelo := v_blcInDelo + room_rec.pl;  
                    end if;    
                    
                end if; 
              -- 08.06.2019 Dik   
              ELSIF( room_rec.nz > 0 )THEN       
                     if (room_rec.km = v_room) and (v_room_idx = NVL(Trim(room_rec.kmi),'_')) 
                      then  p_unpl := room_rec.pl; 
                    end if;
              --/08.06.2019 Dik 
            END IF;
    
    end loop;
        
    --  нет жилой квартиры в gpl, берём сумму комнат жилых
    if  NVL(p_sqg,0)=0 then 
        p_sqg := v_liv_sq_bti;
            select DECODE(Round(p_sqg,v_precision)- Trunc(p_sqg,v_precision-1),1,Trunc(p_sqg,v_precision),Round(p_sqg,v_precision)) into p_sqg from dual;   
    end if;    
    
    if p_sqg = 0 then
        if  err_idx <> 4 then err_idx := 5; end if;
        p_str := c_ErrStr(err_idx);
        return(err_idx);        
    end if;     

    select DECODE(Round(p_sqi,v_precision)- Trunc(p_sqi,v_precision-1),1,Trunc(p_sqi,v_precision),Round(p_sqi,v_precision)) into p_sqi from dual;
  
    -- посчитали Sqi  
    if p_sqi = 0 then  -- Sqi=0 дальше расчет будет неверен
         err_idx := 7;
        p_str := c_ErrStr(err_idx);
        if p_unpl = 0 then   p_unpl := v_vshkInDelo+v_blcInDelo; end if;
        return(err_idx);     
    end if ;    
  
    if (p_sqo = 0) -- общая квартиры
      and (p_sqb = 0) -- общая (без летних) квартиры
    then
         err_idx := 8;  
        p_str := c_ErrStr(err_idx);
        return(err_idx);     
    end if;
  
      
    if p_sqo > 0 then  -- имеет смысл считать  (sqz) общая комнаты с летними:
          p_sqz :=( ((p_sqo - v_vshk - v_blc) / p_sqg) *  p_sqi  ) + v_blcInDelo + v_vshkInDelo ;
            select  DECODE(Round(p_sqz,v_precision)- Trunc(p_sqz,v_precision-1),1,Trunc(p_sqz,v_precision),Round(p_sqz,v_precision)) into p_sqz from dual ;          --округлять до десятой по правилам, до едениц не округлять    
    else
        p_sqz   := 0;
        err_idx := 9;
    end if;

    if p_sqb > 0 then  -- имеет смысл считать  (sqL) занимаемая общая без летних:
        p_sqL := ( ((p_sqb - v_vshk) / p_sqg)* p_sqi  ) + v_vshkInDelo ;
        select  DECODE(Round(p_sqL,v_precision)- Trunc(p_sqL,v_precision-1),1,Trunc(p_sqL,v_precision),Round(p_sqL,v_precision)) into p_sqL from dual; 
    else
        p_sqL := 0;
        err_idx := 10;
    end if;     
 
 ----
    if err_idx > 0 then 
        p_str :=  c_ErrStr(err_idx); 
    else  
        p_str:='Ok';  
    end if;    
           
    return(err_idx);
 
 exception
  WHEN OTHERS THEN
      err_idx := 3;
      p_str := c_ErrStr(err_idx);
      return(err_idx);

end get_room_space;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания :25.06.2019
  -- Описание : оновные данные по комнате по данным БТИ
    -- Параметры:        
    --p_cadast_num -кад помещения                                                                                          
  -- Входные:            
  -- Выходные:              
procedure  Get_Bti_Data_Kmn(  p_cadast_num varchar2:=null,  p_unom number:=null, p_unkv number:=null,  p_kmi varchar2:=null,   p_data in out curstype )
as
    l_unom number;
    l_unkv number;
    l_kmi varchar2(255);
    l_bti_opl number;
    l_bti_gpl number;
    l_bti_ppl number;
    
    l_bti_kmn_opl number;
    l_bti_kmn_gpl number;
    l_bti_kmn_ppl number;
    l_bti_kmn_unpl number;
    l_err number;
    l_st_err varchar2(255);
begin

    l_unom:=p_unom;
    l_unkv:=p_unkv;
    l_kmi:=p_kmi;
    
    
     --select * fromIZK_RSM_MAIN.IMPORT_BTI_FKMN@IZK_RSM_MAIN kmn  where  unom=16721 and unkv=23  kmn.
       --kad_n  =  '77:04:0001018:8064';
     
    
    --попробуем найти уном в бти
    if l_unom is null  then
        begin
             select unom, unkv, kmi  into l_unom, l_unkv, l_kmi from IZK_RSM_MAIN.IMPORT_BTI_FKMN@IZK_RSM_MAIN kmn  where kmn.kad_n=  p_cadast_num;
            --select unom, unkv, kvnom  from  IZK_RSM_MAIN.IMPORT_BTI_FKVA@IZK_RSM_MAIN kva  where kva.kad_n= '77:04:0005007:3688';
        exception 
            when no_data_found then l_unom:=null;  l_unkv:=null;   l_kmi:=null;
            when others then l_unom:=null;  l_unkv:=null;   l_kmi:=null;
        end;
    end if;
    
    --получение расчетных площадей
    l_err:= pkg_bti_ehd.get_room_space (
                                        l_unom , 
                                        l_unkv,
                                        l_kmi, --номер комнаты  с индексом 
                                        l_bti_ppl,   --  общая квартиры  BTI ppl
                                        l_bti_gpl, -- жилая квартиры BTI gpl
                                        l_bti_opl,  --  общая без летних квартиры BTi opl 
                                        l_bti_kmn_ppl,  --  общая с летними комнаты
                                        l_bti_kmn_opl,  --  общая без летних комнаты
                                        l_bti_kmn_gpl,  --  жилая комнаты
                                        l_bti_kmn_unpl,  -- Площадь комнаты(для нежилых)
                                        l_st_err   -- сообщение из c_ErrStr
                                ) ;
                                    
         
    OPEN  p_data  FOR
        
              select-- kva.*,  kva.kl,
                    adr.adres  as bti_adres    --адрес помещения
                    ,kmn.kad_n as bti_cadast_num_kmn --кадастровы    номер комнаты
                    ,adr.KAD_ZU as bti_kad_z--земельный участок
                    ,kva.kad_n as bti_cadast_num_kva --кадастровы    номер помещения
                    ,adr.kad_n  as bti_cadast_num_build --кадастровый номер задния
                    ,kva.unom 
                    ,kva.unkv
                    ,kva.kvnom as  bti_ap_num --Номер помещения   
                    ,kmn.kmi as  bti_km_num --Номер комнаты
                    ,kmn.npp as  bti_km_npp --Номер комнаты п/п 
                    ,kmn.et  as bti_kmn_et--этаж-
                    ,trim(to_char(l_bti_kmn_opl, '999999999990D9','nls_numeric_characters = '',.'''  ))   as bti_kmn_opl --Площадь комнаты, кв.м
                    ,trim(to_char(l_bti_kmn_gpl, '999999999990D9','nls_numeric_characters = '',.'''  ))   as bti_kmn_gpl --Площадьжилая, кв.м
                    ,trim(to_char(l_bti_kmn_ppl, '999999999990D9','nls_numeric_characters = '',.'''  ))   as bti_kmn_ppl --Площадь приведенная, кв.м
                    ,trim(to_char(l_bti_kmn_unpl, '999999999990D9','nls_numeric_characters = '',.'''  ))  as bti_kmn_unpl --Площадь комнаты(для нежилых), кв.м
                    ,trim(to_char(l_bti_opl, '999999999990D9','nls_numeric_characters = '',.'''  ))   as bti_opl --Площадь квартиры, кв.м
                    ,trim(to_char(l_bti_gpl, '999999999990D9','nls_numeric_characters = '',.'''  ))   as bti_gpl --Площадьжилая квартиры, кв.м
                    ,trim(to_char(l_bti_ppl, '999999999990D9','nls_numeric_characters = '',.'''  ))   as bti_ppl --Площадь приведенная квартиры, кв.м
                    ,pkg_bti_ehd. Get_cls_data(86,  kmn.nz, null)   as  bti_naz_kmn   --назначение комнаты
                   ,pkg_bti_ehd. Get_cls_data(163,  kmn.plov, null)   as  bti_type_kmn --тип площади  
                    ,'Выверен'   stsobj --статус объекта
                from IZK_RSM_MAIN.IMPORT_BTI_FKMN@IZK_RSM_MAIN kmn 
                        join  IZK_RSM_MAIN.IMPORT_BTI_FKVA@IZK_RSM_MAIN kva on kva.Unom=kmn.unom and kva.unkv=kmn.unkv  
                        join IZK_RSM_MAIN.IMPORT_BTI_FADS@IZK_RSM_MAIN adr on adr.unom= kva.unom  and adr.main_adr=1   and adr.adr_type in (26796, 26795)  
                where  
               --(kva.kad_n= null or kva.unom=1404)
              --and (kva.unkv= 16 or kva.kvnom='III');
                    (kmn.kad_n= p_cadast_num or kmn.unom=l_unom)
                   and kmn.unkv= l_unkv and  kmn.kmi= l_kmi
                   and rownum=1;
                
end Get_Bti_Data_Kmn;



------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : Dik
  -- Дата создания :15.07.2019
  -- Описание : оновные данные по комнате  по данным ЕГРП
    -- Параметры:        
    --p_cadast_num_kva -кад помещения - квартиры                                                                                          
  -- Входные:            
  -- Выходные:              
procedure  Get_Ehd_Data_Kmn(p_cadast_num_kva varchar2, p_unom number, p_unkv number, p_kmi varchar2, p_data in out curstype )
as
    l_cadast_num_kmn varchar2(50):=Null;
    l_cadast_num_b varchar2(50):=Null;
    l_kmi  varchar2(6) := Null;
begin
   l_kmi := lower(Trim(p_kmi));
   --попробуем найти уном в бти

        begin
             select kad_n  into l_cadast_num_kmn from IZK_RSM_MAIN.IMPORT_BTI_FKMN@IZK_RSM_MAIN kmn  
             where kmn.unom = p_unom 
               and kmn.unkv = p_unkv
               and lower(Trim(kmn.kmi))= l_kmi ;
        exception 
            when no_data_found then l_cadast_num_kmn:=null; 
            when others then l_cadast_num_kmn:=null;
        end;
    
   if (l_cadast_num_kmn is null) and  (NVL(p_cadast_num_kva,'*')<>'*' and (p_unom is not null)) then
      l_cadast_num_b := get_building_cadastr(p_unom);
      l_cadast_num_kmn := Get_Ehd_Cadast_for_Kmn(l_cadast_num_b, p_cadast_num_kva, l_kmi); 
    end if;
    
    if l_cadast_num_kmn is null then
      return;
    end if; 
        
    OPEN  p_data  FOR
        
              SELECT 
                    l.ADDRESS_TOTAL  as ehd_adres    --адрес помещения
                    ,null as ehd_kad_z--земельный участок
                    ,c.cadastral_number as ehd_cadast_num --кадастровы    номер помещения
                    ,c.cadastral_number_oks as ehd_cadast_num_build --кадастровый номер задния
                    ,null  unom 
                    ,null unkv
                    ,trim(to_char( b.area, '999999999990D9','nls_numeric_characters = '',.'''  ))   as ehd_opl --Площадь общая, кв.м
                    ,null  as ehd_gpl --Площадьжилая, кв.м
                    ,null  as ehd_ppl --Площадь приведенная, кв.м
                    --, b.type   as  bti_type_name   --тип помещения
                    ,C.ASSFTP1   as ehd_type_name   --тип помещения
                    ,l.apartment as  ehd_ap_num --Номер помещения   
                    ,null  as ehd_et--этаж
                    ,C.ASSFTP_CD    as  ehd_klass --класс помещения  
                    ,null  as ehd_nsek--номер подъезда
                    ,null  as ehd_kmq--Количество жилых комнат
                    ,to_char(c.date_created,'dd.mm.yyyy')        as  ehd_cad_cdate--Дата присвоения кадастрового номера
                    ,to_char(c.date_removed,'dd.mm.yyyy')      as  ehd_cad_rdate--Дата снятия с кадастрового учета
                    ,'Выверен'   stsobj --статус объекта
                    ,trim( to_char(s.value,'999G999G999G999G990D99','nls_numeric_characters = '', '''))     as ehd_cost--Кадастровая стоимость, руб. 99D99
                    ,to_char(s.cadcost_dtent,'dd.mm.yyyy')         as ehd_cost_dedit--Дата внесения стоимости
                    ,to_char(s.cadcost_dtappr,'dd.mm.yyyy')      as ehd_cost_dconfirm--Дата утверждения стоимости
                    ,to_char(s.cadcost_dtval,'dd.mm.yyyy')         as  ehd_cost_ddefin --Дата определения стоимости
            FROM IZK_RSM_MAIN.IMPORT_EHD_BUILDING_PARCEL@IZK_RSM_MAIN b  
                join IZK_RSM_MAIN.IMPORT_EHD_REGISTER@IZK_RSM_MAIN c on c.building_parcel_id = b.id 
                join IZK_RSM_MAIN.IMPORT_EHD_LOCATION@IZK_RSM_MAIN l on l.building_parcel_id = b.id
                left join IZK_RSM_MAIN.IMPORT_EHD_CADASTRAL_COST@IZK_RSM_MAIN s  on s.building_parcel_id = b.id
            where 
                    c.cadastral_number  =l_cadast_num_kmn
                  -- c.cadastral_number = '77:04:0005007:4012'
                    and b.actual is null
                    and rownum=1  ;
                  -- and c.assftp_cd= case when p_type=1 then  'Жилое помещение' else 'Нежилое помещение' end
                
end Get_Ehd_Data_Kmn;

   -- Автор  : Dik
  -- Дата создания :15.07.2019
  -- Описание : получить кадастр номер комнаты по кадастр номеру квартиры и номеру комнаты
  -- p_cadast_num_b - кадастровый номер здания (увеличивает скорость select-a)
  
function  Get_Ehd_Cadast_for_Kmn( p_cadast_num_b varchar2, p_cadast_num_kva varchar2,  p_kmi varchar2 ) return varchar2
as
  l_count number := 0;
begin
  
  if TRIM(p_cadast_num_kva) is null then  return(NULL); end if;
  
   FOR rec IN(
   select b.id, --b.area, b.type, b.OBJECT_ID, 
    r.cadastral_number, 
    l.APARTMENT, 
    Decode(TRIM(e.NUM_FLAT),NULL,Trim(Substr(lower(l.APARTMENT),Instr(Lower(l.APARTMENT),'к.')+2)),TRIM(e.NUM_FLAT )) as NUM_FLAT
   from IZK_RSM_MAIN.IMPORT_EHD_BUILDING_PARCEL@IZK_RSM_MAIN b
    join IZK_RSM_MAIN.IMPORT_EHD_REGISTER@IZK_RSM_MAIN r on r.building_parcel_id = b.id 
    join IZK_RSM_MAIN.IMPORT_EHD_LOCATION@IZK_RSM_MAIN l on l.building_parcel_id = b.id 
    left join IZK_RSM_MAIN.IMPORT_EHD_EGRP@IZK_RSM_MAIN e on e.num_cadnum = r.cadastral_number and e.actual is null 
   where b.actual is null 
    -- and decode(p_cadast_num_b,NULL,'_',r.cadastral_number_oks) = decode(p_cadast_num_b,NULL,'_',p_cadast_num_b)
     and r.cadastral_number_oks  = p_cadast_num_b
     and r.cadastral_number_flat = p_cadast_num_kva
        ) LOOP
        l_count := 0;
        
        select count(*) into l_count from 
                          (select sTable.n as n from    
                               ( select  regexp_substr(
                                                      (select ','||translate(rec.NUM_FLAT,'1 ','1')||',' from  dual),
                                                      '[^,]+',1,level
                                                      ) as n from dual
                                connect by regexp_substr(
                                                       (select ','||translate(rec.NUM_FLAT,'1 ','1')||',' from  dual),
                                                       '[^,]+',1,level
                                                         ) is not null
                                ) sTable) 
        where p_kmi in n;
        if l_count = 1 then
           return(Trim(rec.cadastral_number));
         end if;
   end loop;
   return(NULL);
  
end Get_Ehd_Cadast_for_Kmn;


   -- Автор  : Dik
  -- Дата создания :15.07.2019
  -- Описание : получить кадастр номер квартиры по кадастр номеру здания и номеру квартиры
function  Get_Ehd_Cadast_for_Room( p_cadast_num_b varchar2,  p_kva varchar2 ) return varchar2
as
  l_cadast_num_kva varchar2(50):=Null;
  l_count number := 0;
begin
  begin
    select cadastral_number_kva into l_cadast_num_kva 
    from
    ( select  r.cadastral_number as  cadastral_number_kva
              ,Trim(Substr(lower(l.APARTMENT),Instr(Lower(l.APARTMENT),' ')+1)) as kva
        from IZK_RSM_MAIN.IMPORT_EHD_BUILDING_PARCEL@IZK_RSM_MAIN b
        join IZK_RSM_MAIN.IMPORT_EHD_REGISTER@IZK_RSM_MAIN r on r.building_parcel_id = b.id 
        join IZK_RSM_MAIN.IMPORT_EHD_LOCATION@IZK_RSM_MAIN l on l.building_parcel_id = b.id 
        where b.actual is null 
          and r.cadastral_number_oks = p_cadast_num_b 
          and r.cadastral_number_flat is null
       ) where  kva = Lower(Trim(p_kva));
 exception     
    when no_data_found then l_cadast_num_kva:=null;
    when others then l_cadast_num_kva:=null;    
  end;
   if ( l_cadast_num_kva is not null ) then
     return (l_cadast_num_kva);
   end if;
  begin
    select cadastral_number_kva into l_cadast_num_kva 
    from
    ( select  r.cadastral_number as  cadastral_number_kva
              ,Trim(Substr(lower(l.APARTMENT),Instr(Lower(l.APARTMENT),' ')+1)) as kva
              ,DECODE(lower(TRIM(r.assftp1)),'квартира',1,0) as is_kva
       from IZK_RSM_MAIN.IMPORT_EHD_BUILDING_PARCEL@IZK_RSM_MAIN b
        join IZK_RSM_MAIN.IMPORT_EHD_REGISTER@IZK_RSM_MAIN r on r.building_parcel_id = b.id 
        join IZK_RSM_MAIN.IMPORT_EHD_LOCATION@IZK_RSM_MAIN l on l.building_parcel_id = b.id 
        where b.actual is null 
          and r.cadastral_number_oks = p_cadast_num_b 
          and r.cadastral_number_flat is null
          
      ) where is_kva = 1
          and kva    = Lower(Trim(p_kva));
 exception     
    when no_data_found then l_cadast_num_kva:=null;
    when others then l_cadast_num_kva:=null;    
  end;
 return (l_cadast_num_kva);
 
end Get_Ehd_Cadast_for_Room;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : Dik
  -- Дата создания :16.07.2019
  -- Описание : данные об объектах, в пределах которых расположена комната ЕГРН 
             
procedure  Get_Ehd_Кmn_Data_In(  p_cadast_num varchar2,   p_data in out curstype )
as
begin
  
if p_cadast_num is NULL then return; end if;

    OPEN  p_data  FOR
    
        select   distinct  r2.cadastral_number  as  ehd_cadast_num  -- кадастр 
                    ,b.type                     as  ehd_vid_object --Вид объекта
                   -- ,'участок'                       as  ehd_vid_object --Вид объекта
                    ,r2.state                   as  ehd_state_object--Статус объекта 
                    ,b.assignation_code         as  ehd_naz--Назначение
                    --,'Для многоквартирной застройки'     as  ehd_naz--Назначение
                    , b.area as ehd_area --площадь
    from  IZK_RSM_MAIN.IMPORT_EHD_REGISTER@IZK_RSM_MAIN r
          Join IZK_RSM_MAIN.IMPORT_EHD_BUILDING_PARCEL@IZK_RSM_MAIN  b  on b.actual is null and r.cadastral_number_flat = b.object_id
          join IZK_RSM_MAIN.IMPORT_EHD_REGISTER@IZK_RSM_MAIN r2 on  b.actual is null and r2.cadastral_number = b.object_id
   Where r.cadastral_number = p_cadast_num ;
   
end Get_Ehd_Кmn_Data_In;


procedure  Get_Ehd_Kmn_Data_Right(  p_cadast_num varchar2:=null,  p_unom number:=null, p_unkv number:=null,  p_nom varchar2:=null,   p_data in out curstype )
as
    l_cadast_num varchar2(50):=null;
begin

    l_cadast_num:=p_cadast_num;
    
    --попробуем найти уном в бти
    if l_cadast_num is null  then
        begin
            select kva.kad_n into l_cadast_num  from IZK_RSM_MAIN.IMPORT_BTI_FKMN@IZK_RSM_MAIN kva  where kva.unom= p_unom and ( kva.unkv=p_unkv or kva.kvi=p_nom );
        exception 
         when no_data_found then l_cadast_num:=null;return;
         when others then l_cadast_num:=null; return;
        end;
     end if;
   
 
      OPEN  p_data  FOR
      
        select 
            r.reg_open_regnum  as ehd_reg_num--рег. номер 
            ,o.ownertp_cd as ehd_own_type--тип правообладателя
            ,o.name  as ehd_own_name--наименование правообладателя 
            ,r.righttp_cd  as  ehd_right_type--вид права
            ,to_char(r.reg_open_regdt, 'dd.mm.yyyy')  as ehd_right_odate --дата открытия права
            ,to_char(r.reg_close_regdt, 'dd.mm.yyyy')  as ehd_right_cdate--дата закрытия права
            ,r.share_text as ehd_share
        from IZK_RSM_MAIN.IMPORT_EHD_BUILDING_PARCEL@IZK_RSM_MAIN b
        join IZK_RSM_MAIN.IMPORT_EHD_REGISTER@IZK_RSM_MAIN c on c.building_parcel_id = b.id and b.actual is null
        join IZK_RSM_MAIN.IMPORT_EHD_EGRP@IZK_RSM_MAIN  g on g.num_cadnum = c.cadastral_number and g.actual is null
        join IZK_RSM_MAIN.IMPORT_EHD_RIGHT@IZK_RSM_MAIN r on r.egrp_id = g.id 
        join IZK_RSM_MAIN.IMPORT_EHD_RIGHT_OWNER@IZK_RSM_MAIN o on o.right_id = r.id
        where 
        b.object_id = l_cadast_num
        order by r.reg_open_regdt desc;
end Get_Ehd_Kmn_Data_Right ;


   -- Автор  : Dik
  -- Дата создания :30.07.2019
  -- Описание : Получить кадастровый номер здания по Unom 
Function get_building_cadastr(p_unom number) return varchar2         
as
  l_cadastr_b varchar2(50):=null;
begin
    
  SELECT fad.KAD_N into l_cadastr_b
    from   IZK_RSM_MAIN.IMPORT_BTI_FADS@IZK_RSM_MAIN fad 
   where  fad.main_adr=1
     and  fad.adr_type in (26796, 26795)
     and  fad.unom=p_unom;
    
  return ( l_cadastr_b );
  
  exception 
         when others then return(null);

end get_building_cadastr;


procedure  Get_FIAS_FULL_ADDDRES( p_aoguid_1_region varchar2, p_aoguid_3_area varchar2, p_aoguid_4_city varchar2, 
                                  p_aoguid_6_place varchar2, p_aoguid_65_plan varchar2, p_aoguid_7_street varchar2,  p_data in out curstype )
as

begin
   OPEN  p_data  FOR
    select fa.aoid, fa.aolevel, fa.aoguid, fa.aoguid_1_region, fa.aoguid_3_area, fa.aoguid_4_city, fa.aoguid_6_place, 
             fa.aoguid_65_plan, fa.aoguid_7_street, fa.update_date, fa2.postalcode,
             fa.offname as fias_full_addr, 
             fa.aoid as fias_record_id
      from u_fias_addrobj fa 
      join fias_addrob77 fa2 on fa2.aoid = fa.aoid
      where   NVL(fa.aoguid_1_region,'#') = NVL(p_aoguid_1_region, '#')
         and  NVL(fa.aoguid_3_area,'#')   = NVL(p_aoguid_3_area, '#')
         and  NVL(fa.aoguid_4_city,'#')   = NVL(p_aoguid_4_city, '#')
         and  NVL(fa.aoguid_6_place,'#')  = NVL(p_aoguid_6_place, '#')
         and  NVL(fa.aoguid_65_plan,'#')  = NVL(p_aoguid_65_plan, '#')
         and  NVL(fa.aoguid_7_street,'#') = NVL(p_aoguid_7_street, '#')

  ;    
end Get_FIAS_FULL_ADDDRES;
                                  

procedure  Get_FIAS_ADDDRES(  p_search_param varchar2,  p_mode number:=0,  p_data in out curstype )
as
    v_search_param varchar2(500):=null;
    v_aoguid u_fias_addrobj.aoguid%type := NULL;
    I       integer := 1;
    v_prev_level integer;
    v_level integer;
    c_level_l_region constant integer := 1; --регион РФ
    c_level_3_area  constant integer := 3; --Округ   
    c_level_4_city  constant integer := 4; --Город
    c_level_6_place constant integer := 6; --н/п 
    c_level_65_plan constant integer := 65; --Элемент планировочной структуры
    c_level_7_street constant integer := 7; --Улица
begin

case  
when p_mode = 0 then -- поиск адреса
    if (trim(p_search_param) is null) then return; end if;
    v_search_param := ' '||lower(TRIM(p_search_param))||' ';
    v_search_param := replace(v_search_param,' ','%');
    v_search_param := replace(v_search_param,'%%','%');
 
   OPEN  p_data  FOR
    select fa.aoid, fa.aolevel, fa.aoguid, fa.aoguid_1_region, fa.aoguid_3_area, fa.aoguid_4_city, fa.aoguid_6_place, 
           fa.aoguid_65_plan, fa.aoguid_7_street, fa.update_date, fa2.postalcode,
           fa.offname as fias_full_addr, 
           fa.aoid as fias_record_id
    from u_fias_addrobj fa ,fias_addrob77 fa2 
    where lower(fa.offname) like v_search_param
    and fa2.aoid=fa.aoid
    order by fa.offname;
    return;
--регион  
when p_mode = 1 then --список регионов 
 
   OPEN  p_data  FOR
    select fa.offname as fias_full_addr, 
           fa.aoguid as fias_record_id
    from  u_fias_addrobj fa where fa.aoguid= fa.aoguid_1_region;
    return;

when p_mode = 3 then --регион заданный
      if (trim(p_search_param) is null) then return; end if;
      v_search_param := TRIM(p_search_param);
     
    OPEN  p_data  FOR
      select fa.offname as fias_full_addr, 
             fa.aoguid as fias_record_id
      from  u_fias_addrobj fa where fa.aoguid = fa.aoguid_1_region and fa.aoguid=v_search_param;
   return;
  --   из адреса (Округ, город, н.п., план.стр., улица)
when p_mode in (2,4,6,9,14,19) then 
     if (trim(p_search_param) is null) then return; end if;
      v_search_param := TRIM(p_search_param);    
      select case p_mode 
              when 2 then fa.aoguid_1_region 
              when 4 then fa.aoguid_3_area
              when 6 then fa.aoguid_4_city
              when 9 then fa.aoguid_6_place
              when 14 then fa.aoguid_65_plan
              when 19 then fa.aoguid_7_street
              else fa.aoguid_1_region 
              end as aoguid , 
              decode(p_mode,2,c_level_l_region,4,c_level_3_area,6,c_level_4_city,9,c_level_6_place,14,c_level_65_plan,19,c_level_7_street) as l   
      into v_aoguid, v_level from u_fias_addrobj fa where fa.aoid=v_search_param;

    OPEN  p_data  FOR
     select Decode(NVL(trim(v.scname),'#'),'#','',trim(v.scname)||' ')||fa2.offname as fias_full_addr, 
           fa2.aoguid as fias_record_id
     from fias_addrob77 fa2 
      left join  v_fias_socrbase_link v on v.shortname= fa2.shortname and v.aolevel=fa2.aolevel and rownum=1
     where  fa2.aoguid= v_aoguid
          and fa2.aolevel=v_level
          and fa2.actstatus=1 and fa2.livestatus=1 and fa2.nextid is null;  
    return;
 when p_mode in (30) then  -- почтовый индекс по коду адреса
      if (trim(p_search_param) is null) then return; end if;
      v_search_param := TRIM(p_search_param);
      if p_mode = 31 then
        select fa.aoid into v_search_param
        from  u_fias_addrobj fa where fa.aoguid= v_search_param;
      end if;
    OPEN  p_data  FOR
     select fa2.postalcode as postalcode, 
           fa2.aoid as fias_record_id
     from fias_addrob77 fa2 
     where fa2.aoid = v_search_param;
     return;    
--Округ    
when p_mode = 5 then --список Округов по региону
       if (trim(p_search_param) is null) then return; end if;
       v_search_param := TRIM(p_search_param);
       v_level := c_level_3_area;
       v_prev_level := c_level_l_region;
-- Город   
when p_mode in (7,8) then 
      if (trim(p_search_param) is null) then return; end if;
      v_search_param := TRIM(p_search_param);
      v_level := c_level_4_city;
      select decode(p_mode,7,c_level_3_area,8,c_level_l_region) into  v_prev_level from dual;
--Населенный пункт  
when p_mode in (10,11,12) then 
      if (trim(p_search_param) is null) then return; end if;
      v_search_param := TRIM(p_search_param);
      v_level := c_level_6_place;
      select  decode(p_mode,10,c_level_4_city,11,c_level_3_area,12,c_level_l_region) into  v_prev_level from dual;
-- Элемент планировочной структуры
when p_mode in (15,16,17,18) then 
      if (trim(p_search_param) is null) then return; end if;
      v_search_param := TRIM(p_search_param);
      v_level := c_level_65_plan;
      select decode(p_mode,15,c_level_6_place,16,c_level_4_city,17,c_level_3_area,18,c_level_l_region) into v_prev_level from dual;
---улица   
else 
      v_level := 7;
       if (trim(p_search_param) is null) then return; end if;
        v_search_param := TRIM(p_search_param);
      case p_mode
        when 20 then v_prev_level := c_level_65_plan;
        when 21 then v_prev_level := c_level_6_place;
        when 22 then v_prev_level := c_level_4_city; 
        when 23 then v_prev_level := c_level_3_area;
        when 24 then v_prev_level := c_level_l_region;
       else
        return;
      end case; 
end case; 
   
   OPEN  p_data  FOR
    select --Decode(NVL(trim(v.scname),'#'),'#','',trim(v.scname)||' ')||
           fa.offname as fias_full_addr, 
           fa.aoguid  as fias_record_id
    from fias_addrob77 fa2, fias_addrob77 fa
    left join  v_fias_socrbase_link v on v.shortname= fa.shortname and v.aolevel=fa.aolevel and rownum=1
    where fa2.aoguid = v_search_param
          and fa2.aolevel=v_prev_level
          and fa2.actstatus=1 and fa2.livestatus=1 and fa2.nextid is null
          and fa.parentguid  = fa2.aoguid
          and fa.aolevel=v_level
          and fa.actstatus=1 and fa.livestatus=1 and fa.nextid is null
    order by fa.offname  ;  
             
end Get_FIAS_ADDDRES;

END pkg_bti_ehd;
/
