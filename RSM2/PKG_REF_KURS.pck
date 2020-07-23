CREATE OR REPLACE PACKAGE PKG_REF_KURS
  IS
    
  --
  --2019.03.01  shulgin Классификаторы и справочники из Курса и РД для РСМ2.
  -- Создан на основе PСKG_REF_KURS, но задано смещение в классивфикаторах, чтобы лежали в диапазоне 400
  --

  PROCEDURE Get_Reference(
    a_ReferenceId integer
    , a_Filter     VARCHAR2
    , a_RS     OUT dbo.TRecordSet
  );

   PROCEDURE Get_Reference_Ext(
    a_ReferenceId integer
    , a_Filter     VARCHAR2
    , a_CurrentId number := null
    , a_RS   in  OUT dbo.TRecordSet
  );

  --03.02.2020    shulgin Get_Reference_Ext в виде функции - для проверки справочников
  function Get_Reference_Ext_F(a_ReferenceId number) return dbo.TRecordSet;

END PKG_REF_KURS;
/
CREATE OR REPLACE PACKAGE BODY PKG_REF_KURS
  IS

  --
  --2019.03.01  shulgin Классификаторы и справочники из Курса и РД для РСМ2.
  -- Создан на основе PСKG_REF_KURS, но задано смещение в классивфикаторах, чтобы лежали в диапазоне 400
  --


  PROCEDURE Get_Reference(
    a_ReferenceId integer
    , a_Filter     VARCHAR2
    , a_RS     OUT dbo.TRecordSet
    --, a_CurrentId number := null
  )
    IS
      v_STR VARCHAR2(1000);
    BEGIN
      
      IF LENGTH(a_Filter) > 0
      THEN
        v_STR := replace(a_Filter, '''','');
      END IF;
      
      IF (a_ReferenceId = 420)THEN --Улицы Курс-3
      
        v_STR := '
              select 
                bti_id as ItemID
                , bti_id as Code
                , full_name as SName
                , full_name as value
                , full_name as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from rdn_v_street '
              || ' where bti_id is not null and deleted = 0 '
              || (case when v_STR is null then '' else ' and '||v_STR end)
              ||' order by full_name';
      
      ELSIF (a_ReferenceId = 421)THEN --Типы
      
        v_STR := '
              select 
                row_num as ItemID
                , row_num as Code
                , value_rp as SName
                , value_rp as value
                , value_rp as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , row_num as name_for_sort 
              from rdn_v_classifier '
              || ' where cl_num = 2 and status = 1 and row_num <> 0'
              || (case when v_STR is null then '' else ' and '||v_STR end)
              ||' order by row_num  ';
      
       ELSIF (a_ReferenceId = 422)THEN --Источники
      
        v_STR := '
              select 
                row_num as ItemID
                , row_num as Code
                , value as SName
                , value as value
                , value as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from rdn_v_classifier '
              || ' where cl_num = 6 and status = 1 and row_num <> 0'
              || (case when v_STR is null then '' else ' and '||v_STR end)
              ||' order by row_num ';
      
      ELSIF (a_ReferenceId = 424)THEN --Статусы договоров
      
        v_STR := '
              select 
                row_num as ItemID
                , row_num as Code
                , value as SName
                , value as value
                , value as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from rdn_v_classifier '
              || ' where cl_num = 1 and status = 1 and row_num <> 0'
              || (case when v_STR is null then '' else ' and '||v_STR end)
              ||' order by row_num ';
      
      ELSIF (a_ReferenceId = 425)THEN --Причины расторжения
      
        v_STR := '
              select 
                row_num as ItemID
                , row_num as Code
                , value as SName
                , value as value
                , value as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from rdn_v_classifier '
              || ' where cl_num = 7 and status = 1 and row_num <> 0'
              || (case when v_STR is null then '' else ' and '||v_STR end)
              ||' order by row_num ';
              
      ELSIF (a_ReferenceId = 423)THEN --Округа
      
        v_STR := '
              select 
                okrug_id as ItemID
                , okrug_id as Code
                , okrug_short as SName
                , okrug_short as value
                , okrug_short as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from rdn_v_okrug '
              || ' where okrug_id <> 61 '
              || (case when v_STR is null then '' else ' and '||v_STR end)
              ||' order by decode(okrug_id, 50,62, 33, 62, okrug_id) ';
              
      ELSIF (a_ReferenceId = 426)THEN --Районы
      
        v_STR := '
              select 
                municipal_id  as ItemID
                , municipal_id as Code
                , municipal_name as SName
                , municipal_name as value
                , municipal_name as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from rdn_v_municipality '
              ||' order by municipal_name ';
              
 ELSIF (a_ReferenceId = 427)THEN --Направление учета ilonis 04.03.20019
      
        v_STR := '
              select 
                  id  as ItemID
                , ID as Code
                , short_name1 as SName
                , name as value
                , name as full_name
                , null as ParentID 
                , null as subject_rf_id
                , null as short_name
                , null as name_for_sort 
              from kurs3.v_direction '
              ||' order by ID ';              
      
     ELSIF (a_ReferenceId = 428)THEN --Подписанты договоров
      
        v_STR := '
             select 
                s_id  as ItemID
                , s_id as Code
                , to_char(null) as SName
                ,  v.name || '' '' || v.pat || '' ''
                    || (CASE
                           WHEN     title = ''-''
                                AND v.department_id = 753
                                AND v.factory_id = 881
                           THEN
                              ''Департамент городского имущества''
                           ELSE
                              v.title
                        END) as value
                , to_char(null) as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from v_signature v
              where s_agree = 1
              order by 4 ';           
 
      END IF;
      
      OPEN a_RS FOR v_STR;
      
    END;

    PROCEDURE Get_Reference_Ext(
    a_ReferenceId integer
    , a_Filter     VARCHAR2
    , a_CurrentId number := null
    , a_RS in OUT dbo.TRecordSet
  )
    IS
      v_STR VARCHAR2(1000);
    BEGIN
      
      IF LENGTH(a_Filter) > 0
      THEN
        v_STR := replace(a_Filter, '''','');
      END IF;
      
      IF (a_ReferenceId = 420)THEN --Улицы Курс-3
      
        v_STR := '
              select 
                bti_id as ItemID
                , bti_id as Code
                , full_name as SName
                , full_name as value
                , full_name as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from rdn_v_street '
              || ' where bti_id is not null and deleted = 0 '
              || (case when v_STR is null then '' else ' and '||v_STR end)
              ||' order by full_name';
      
      ELSIF (a_ReferenceId = 421)THEN --Типы
      
        v_STR := '
              select 
                row_num as ItemID
                , row_num as Code
                , case when row_num >= 80 then value else ''Договор ''||value_rp end as SName
                , case when row_num >= 80 then value else ''Договор ''||value_rp end as value
                , case when row_num >= 80 then value else ''Договор ''||value_rp end as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , row_num as name_for_sort 
              from rdn_v_classifier '
              || ' where cl_num = 2 and (status = 1 or row_num >= 80) and row_num <> 0'
              || (case when v_STR is null then '' else ' and '||v_STR end)
              ||' order by row_num  ';
      
       ELSIF (a_ReferenceId = 422)THEN --Источники
      
        v_STR := '
              select 
                row_num as ItemID
                , row_num as Code
                , value as SName
                , value as value
                , value as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from rdn_v_classifier '
              || ' where cl_num = 6 and status = 1 and row_num <> 0'
              || (case when v_STR is null then '' else ' and '||v_STR end)
              ||' order by row_num ';
      
      ELSIF (a_ReferenceId = 424)THEN --Статусы договоров
      
        v_STR := '
              select 
                row_num as ItemID
                , row_num as Code
                , value as SName
                , value as value
                , value as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from rdn_v_classifier '
              || ' where cl_num = 1 and status = 1 and row_num <> 0'
              || (case when v_STR is null then '' else ' and '||v_STR end)
              ||' order by row_num ';
      
      ELSIF (a_ReferenceId = 425)THEN --Причины расторжения
      
        v_STR := '
              select 
                row_num as ItemID
                , row_num as Code
                , value as SName
                , value as value
                , value as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from rdn_v_classifier '
              || ' where cl_num = 7 and status = 1 and row_num <> 0'
              || (case when v_STR is null then '' else ' and '||v_STR end)
              ||' order by row_num ';
              
      ELSIF (a_ReferenceId = 423)THEN --Округа
      
        v_STR := '
              select 
                okrug_id as ItemID
                , okrug_id as Code
                , okrug_short as SName
                , okrug_short as value
                , okrug_short as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from rdn_v_okrug '
              || ' where okrug_id <> 61 '
              || (case when v_STR is null then '' else ' and '||v_STR end)
              ||' order by decode(okrug_id, 50,62, 33, 62, okrug_id) ';
              
      ELSIF (a_ReferenceId = 426)THEN --Районы
      
        v_STR := '
              select 
                municipal_id  as ItemID
                , municipal_id as Code
                , municipal_name as SName
                , municipal_name as value
                , municipal_name as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from rdn_v_municipality '
              ||' order by municipal_name ';
              
 ELSIF (a_ReferenceId = 427)THEN --Направление учета ilonis 04.03.20019
      
        v_STR := '
              select 
                  id  as ItemID
                , ID as Code
                , short_name1 as SName
                , To_Char(ID)||''.  ''||name as value
                , name as full_name
                , null as ParentID 
                , null as subject_rf_id
                , null as short_name
                , null as name_for_sort 
              from kurs3.v_direction '
              ||' order by ID ';   
              
      
     ELSIF (a_ReferenceId = 428)THEN --Подписанты договоров
      
        v_STR := '
             select 
                s_id  as ItemID
                , s_id as Code
                , to_char(null) as SName
                ,  v.name || '' '' || v.pat || '' ''
                    || (CASE
                           WHEN     title = ''-''
                                AND v.department_id = 753
                                AND v.factory_id = 881
                           THEN
                              ''Департамент городского имущества''
                           ELSE
                              v.title
                        END) as value
                , to_char(null) as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from v_signature v
              where s_agree = 1'
              ||(case when a_CurrentId is not null then ' OR s_id='||a_CurrentId else '' end)
              ||'
              order by 4 '; 
              
 ELSIF (a_ReferenceId = 429) THEN --КурсКПУ Адрес Улица Dik 24.05.2019
      
        v_STR := '
              select 
                  street_id  as ItemID
                , street_id as Code
                , full_name as SName
                , full_name as value
                , full_name as full_name
                , null as ParentID 
                , null as subject_rf_id
                , null as short_name
                , null as name_for_sort 
              from kurs3.v_street order by full_name '
              ;     
               
   ELSIF (a_ReferenceId in (430,432,433) ) THEN 
   v_STR := '';
     case a_ReferenceId 
       when 430 then  
      PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (70, --код спр. Состояние дела 
                                            2,  -- поле наименований значений спр. 
                                            a_RS); 
                                            
      when 432 then  
      PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (11, --код спр. Вид обеспеч
                                            1, 
                                            a_RS);
      when 433 then  
      PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (5, --код спр. Тип_Кв
                                            1,  -- поле наименований значений спр. 
                                            a_RS);                                                                                      
     else  v_STR :=''; 
     end case;
   return;
    
    ELSIF (a_ReferenceId in (431) ) THEN  --категория дела по направлению учета  ил цель
        
        v_STR := '
              select 
                 max(rtrim(name)) as ItemID
                , target     as Code
                , max(rtrim(name)) as SName
                , max(rtrim(name)) as value
                , max(rtrim(name)) as full_name
                , null as ParentID 
                , null as subject_rf_id
                , null as short_name
                ,null as name_for_sort 
              from kurs3.direction_target group by direction,target '
              ;   
               
  ELSIF (a_ReferenceId in (434) ) THEN   --муниципалитеты
        
        v_STR := '
              select 
                  full_name as ItemID
                , AREA as Code
                , trim(full_name) as SName
                , trim(full_name) as value
                , trim(full_name) as full_name
                , null as ParentID 
                , null as subject_rf_id
                , null as short_name
                , null as name_for_sort 
              from KURS3.municipality order by full_name '
              ;     
         
     
   ELSIF (a_ReferenceId in (435) ) THEN  
        
        v_STR := '
              select 
              Case rownum
               when 1 then  ''о/к''
               else ''к/к''
               end  as  ItemID,
               rownum as Code,
               NULL as SName, 
               Case rownum
                   when 1 then ''отдельная квартира''
                   else  ''коммунальная квартира''
               end as value 
               , NULL as full_name                 
               , null as ParentID 
               , null as subject_rf_id
               , null as short_name
               , null as name_for_sort 
            FROM DUAL100 where rownum<3'
               ;     
   ELSIF (a_ReferenceId in (436) ) THEN  --сьатус  площади
        
        v_STR := '
              select 
                  row_num as ItemID
                , row_num as Code
                , trim(Name) as SName
                , trim(Name) as value
                , trim(Name) as full_name
                , null as ParentID 
                , null as subject_rf_id
                , SHORT_NAME2 as short_name
                , null as name_for_sort 
              from KURS3.cl_s  where DELETED=0 order by row_num '
              ;  
 ELSIF (a_ReferenceId in (437) ) THEN  --Организации
        
        v_STR := '
              select 
                TRIM(TO_CHAR(department * 1000 + num_in_department,''000000'')) as ItemID
                , TRIM(TO_CHAR(department * 1000 + num_in_department,''000000'')) as Code
                , FULL_NAME_EXT ||'' ''||TO_CHAR(department * 1000 + num_in_department,''000000'') as SName
                , FULL_NAME_EXT ||'' ''||TO_CHAR(department * 1000 + num_in_department,''000000'') as value
                , FULL_NAME_EXT ||'' ''||TO_CHAR(department * 1000 + num_in_department,''000000'') as full_name
                , null as ParentID 
                , null as subject_rf_id
                , null as short_name
                , null as name_for_sort 
              from (SELECT FULL_NAME, trim(regexp_replace(FULL_NAME, ''(<|>|\"|'''')'','''')) AS FULL_NAME_EXT, department, num_in_department 
              FROM KURS_V_FACTORY where row_status=1 and full_name is not null and nvl(deleted, 0) = 0) order by FULL_NAME '
              ;    --   order by SHORT_NAME TO_NUMBER(TRIM(TO_CHAR(department * 1000 + num_in_department,''000000''))) 
              
    ELSIF (a_ReferenceId in (438) ) THEN  --РД: семейно-родственные
        
        v_STR := '
              select 
                num as ItemID
                , num as Code
                , null as SName
                , relation as value
                , null as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from visa.rdn_rel_sex '
              ||' order by sort_order ';
     
    ELSIF (a_ReferenceId in (439) ) THEN  --РД+Курс: удостоверения личности
        
        v_STR := '
              select 
                row_num as ItemID
                , row_num as Code
                , null as SName
                , name as value
                , null as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from kurs3.classifier  
              where classifier_num = 95
              order by row_num ';
              
    ELSIF (a_ReferenceId in (440) ) THEN  --2020.03.13 shulgin РД: типы допсоглашений

              v_STR := '
              select 
                row_num as ItemID
                , row_num as Code
                , value as SName
                , value as value
                , value as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from rdn_v_classifier '
              || ' where cl_num = 29 and status = 1 and row_num <> 0'
              ||' order by row_num ';
     
     ELSIF (a_ReferenceId in (441) ) THEN  --2020.03.13 shulgin РД: статусы допсоглашений

              v_STR := '
              select 
                row_num as ItemID
                , row_num as Code
                , value as SName
                , value as value
                , value as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from rdn_v_classifier '
              || ' where cl_num = 15 and status = 1 and row_num <> 0'
              ||' order by row_num ';
         
     ELSIF (a_ReferenceId in (442) ) THEN  --2020.03.13 shulgin РД: районы с новым кодом БТИ

              v_STR := '
              select 
                row_num as ItemID
                , row_num as Code
                , value as SName
                , value as value
                , value as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from  ( select  replace(nvl(mun.nm, mun.name), ''?'','''') as value, class_cod as row_num  from BTI_V_CLASS_BTI mun where mun.class_id=45 ) '
              ||' order by value ';
              
     ELSIF (a_ReferenceId in (443) ) THEN  --2020.04.24 shulgin РД: виды помещений

              v_STR := '
              select 
                row_num as ItemID
                , row_num as Code
                , value as SName
                , value as value
                , value as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from rdn_v_classifier '
              || ' where cl_num = 10 and status = 1 and row_num <> 0'
              ||' order by row_num ';
              
     ELSIF (a_ReferenceId in (444) ) THEN  --2020.05.05 shulgin РД: особые виды договоров

              v_STR := '
              select 
                row_num as ItemID
                , row_num as Code
                , value as SName
                , value as value
                , value as full_name
                , null as ParentID, null as subject_rf_id, null as short_name
                , null as name_for_sort 
              from rdn_v_classifier '
              || ' where cl_num = 19 and status = 1 and row_num <> 0'
              ||' order by row_num ';
              
          ---------------------------------------------------------------
     ELSIF (a_ReferenceId in (445) ) THEN  --07.06.2020 ilonis: категори ядела
     v_STR := '
            SELECT 
            a.CATEG_ID  as ItemID
            ,a.CATEG_ID  as Code
            ,a.v_name as SName
            ,a.v_name as value
            ,a.v_name as full_name
            , null as ParentID 
            , null as subject_rf_id
            , null as short_name
            , null as name_for_sort 
        FROM (
                SELECT   CATEG_ID,
                    Trim(cl.name) as v_name             
            FROM  KURS3.category cl
            where    Cl.DELETED = 0
            order by cl.CATEG_ID) a';
     ELSIF (a_ReferenceId in (446) ) THEN  --07.06.2020 ilonis: общественная группа
     v_STR := '
            SELECT 
            a.ROW_NUM  as ItemID
            ,a.ROW_NUM  as Code
            ,a.v_name as SName
            ,a.v_name as value
            ,a.v_name as full_name
            , null as ParentID 
            , null as subject_rf_id
            , null as short_name
            , null as name_for_sort 
        FROM (
                SELECT   ROW_NUM,
                   Trim(cl.name) as v_name                
            FROM  KURS3.V_SGROUP cl
            where    Cl.DELETED = 0
            order by cl.ROW_NUM) a';
      
                          
        ELSIF (a_ReferenceId in (447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483  ) ) THEN 
        v_STR := '';
            case a_ReferenceId 
            when 447 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (20,    1,  a_RS); ---причина стнятия с учета 
                                            
             when 448 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (12, 1,  a_RS); --родственные отношения
                
            when 449 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (10,  1,    a_RS); --семейные отношения
                
            when 450 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (36,  1,    a_RS); --Требования
                
            when 451 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (32,  1,    a_RS); --типы санузлов

            when 452 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (7,  1,    a_RS); -- Благоустроенность дома

             when 453 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (21,  1,    a_RS); -- Пригодность к проживанию
                
             when 454 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (34,  1,    a_RS); -- Типы занимаемой площади(накм, аренда)

             when 455 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (177,  1,    a_RS); -- Статусы заявлений на горпрограмму

             when 456 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (179,  1,    a_RS); -- Источник поступления документа
                
             when 457 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (178,  1,    a_RS); --Причина аннулирования заявления на гор.прграмму
                
             when 458 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (166,  1,    a_RS); -- Горпрограмма для очереди
                
                when 464 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (33,  1,    a_RS); -- Балкон наличие
                
                 when 465 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (44,  1,    a_RS); -- Округа а КУРС
                
                when 466 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (48,  1,    a_RS); -- Причина аннулирования Ф6
                   when 467 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (158,  1,    a_RS); -- Признак освобождения жилой полщади
                
                   when 468 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (188,  1,    a_RS); -- Причина исключения субъекта из дела
                   when 469 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (113,  1,    a_RS); -- Тип документа основания для льготы
                   when 470 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (31,  1,    a_RS); --Характеристика комнаты (справочный код справочник  № 31
                   when 471 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (148,  0,    a_RS); --Статус субвенции
                   when 472 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (149,  0,    a_RS); --Статус финансовых данных по субвенции
                  when 473 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (150,  0,    a_RS); --Федеральные Законы (субвенции)
                  when 474 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (153,  0,    a_RS); --Вид социальной помощи
                  when 476 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (152,  0,    a_RS); --Тмпы документов для воостановления и предоставления
                 when 477 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (161,  0,    a_RS); --Тмпы документов для Ф12
                 when 478 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (121,  0,    a_RS); --Курс Субсидии_Первоочередное право 
                 when 479 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (122,  0,    a_RS); --Курс Субсидии_Использование занимаемого жилого помещения 
                 when 480 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (123,  0,    a_RS); --Курс Субсидии_Причина снятия УДС  
                 when 481 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (124,  0,    a_RS); --Курс Субсидии_Причина аннулирования свидетельства                                                                
                 when 482 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (125,  0,    a_RS); --Курс Субсидии_Причина аннулирования заявки
                 when 483 then  
                PKG_K3_UTILS.GET_CLASSIFIER_FOR_FIND (126,  0,    a_RS); --Курс Субсидии_Этап оформления субсидии                          
                                                                                                     
     else  v_STR :=''; 
     end case;
      return;
 ELSIF (a_ReferenceId in (459) ) THEN  --07.06.2020 ilonis: --ведомство 
     v_STR := '
            SELECT 
            a.ROW_NUM  as ItemID
            ,a.ROW_NUM  as Code
            ,a.v_name as SName
            ,a.v_name as value
            ,a.v_name as full_name
            , null as ParentID 
            , null as subject_rf_id
            , null as short_name
            , null as name_for_sort 
        FROM (
                SELECT   ROW_NUM
                    , case p_outfield 
                         when 1 then Trim(cl.SHORT_NAME1)
                         when 2 then Trim(cl.SHORT_NAME2)
                         when 3 then Trim(cl.SHORT_NAME3)
                        else  Trim(cl.name)
                    end  as v_name              
            FROM  KURS3.department cl
            where    Cl.DELETED = 0
            order by cl.ROW_NUM) a';    
 ELSIF (a_ReferenceId in (460) ) THEN  --07.06.2020 ilonis: --предприятие 
     v_STR := '
            SELECT 
            a.ROW_NUM  as ItemID
            ,a.ROW_NUM  as Code
            ,a.v_name as SName
            ,a.v_name as value
            ,a.v_name as full_name
            , null as ParentID 
            , null as subject_rf_id
            , null as short_name
            , null as name_for_sort 
        FROM (
                SELECT  NUM_IN_DEPARTMENT  as  ROW_NUM
                    , case p_outfield 
                         when 1 then Trim(cl.SHORT_NAME)
                         when 2 then null
                         when 3 then  null
                        else  Trim(cl.FULL_NAMEname)
                    end  as v_name              
            FROM  KURS3.factory cl
            where    Cl.DELETED = 0
            order by cl.NUM_IN_DEPARTMENT) a';      
            
 ELSIF (a_ReferenceId in (461) ) THEN  --07.06.2020 ilonis: --статья передачи
     v_STR := '
            SELECT 
            a.ROW_NUM  as ItemID
            ,a.ROW_NUM  as Code
            ,a.v_name as SName
            ,a.v_name as value
            ,a.v_name as full_name
            , null as ParentID 
            , null as subject_rf_id
            , null as short_name
            , null as name_for_sort 
        FROM (
                SELECT  id  ROW_NUM
                    , case p_outfield 
                         when 1 then Trim(cl.SHORT_NAME1)
                         when 2 then Trim(cl.SHORT_NAME2)
                         when 3 then Trim(cl.SHORT_NAME3)
                        else  Trim(cl.name)
                    end  as v_name              
            FROM  KURS3.V_S_Delivery_ALL cl
            where    Cl.DELETED = 0
            order by cl.id) a';    
ELSIF (a_ReferenceId in (462) ) THEN  --07.06.2020 ilonis: --ствтья учета
     v_STR := '
            SELECT 
            a.ROW_NUM  as ItemID
            ,a.ROW_NUM  as Code
            ,a.v_name as SName
            ,a.v_name as value
            ,a.v_name as full_name
            , null as ParentID 
            , null as subject_rf_id
            , null as short_name
            , null as name_for_sort 
        FROM (
                SELECT id  ROW_NUM,
                     Trim(cl.name)  as v_name              
            FROM  KURS3.V_S_Calculation_ALL cl
            where    Cl.DELETED = 0
            order by cl.id) a';                
                                    
ELSIF (a_ReferenceId in (463) ) THEN  --07.06.2020 ilonis: --фонд
     v_STR := '
            SELECT 
            a.ROW_NUM  as ItemID
            ,a.ROW_NUM  as Code
            ,a.v_name as SName
            ,a.v_name as value
            ,a.v_name as full_name
            , null as ParentID 
            , null as subject_rf_id
            , null as short_name
            , null as name_for_sort 
        FROM (
                SELECT   ROW_NUM
                    , case p_outfield 
                         when 1 then Trim(cl.SHORT_NAME1)
                         when 2 then Trim(cl.SHORT_NAME2)
                         when 3 then Trim(cl.SHORT_NAME3)
                        else  Trim(cl.name)
                    end  as v_name              
            FROM  KURS3.fund cl
            where    Cl.DELETED = 0
            order by cl.ROW_NUM) a';  

ELSIF (a_ReferenceId in (475) ) THEN  --08.08.2020 Dik: --Справочник кварталов для отчета епо субвенциям
     v_STR := '
           SELECT 
             rownum as ItemID, 
             rownum as Code, 
             Case rownum
                 when 5 then ''Весь год''  
                 else to_char(rownum)   
              end      
             as SName
            ,Case rownum
                 when 5 then ''Весь год''  
                 else to_char(rownum)   
              end      
             as value
            ,Case rownum
                 when 5 then ''Весь год''  
                 else to_char(rownum)   
              end  as full_name
            , null as ParentID 
            , null as subject_rf_id
            , null as short_name
            , null as name_for_sort  
          FROM DUAL100 where rownum<6
          order by ItemID asc';                
                        
 /*
 select short_name1 into n from department where department.ROW_NUM=d_id;
 --передприятие
 select short_name into n from factory where   factory.DEPARTMENT=d_id and factory.NUM_IN_DEPARTMENT=f_id;
 --напрваление 
 кл 1
 --цель
   SELECT RTRIM(DECODE(UPPER(fmt), NULL, NAME, 'NAME', NAME, 'SH', short_name, ' '))
    INTO n
    FROM direction_target
   WHERE direction = d_id AND target = t_id;
--статья передачи
select name into n from V_S_Delivery_ALL where V_S_Delivery_ALL.id=s_id;
--ствтья учета
select DECODE(param, 1, name1, name) into n from V_S_Calculation_ALL where V_S_Calculation_ALL.id=s_id;
--фонд
   SELECT TRIM (DECODE (UPPER (fmt), 'SH1', fund.short_name1, 'SH2', fund.short_name2, 'SH3', fund.short_name3, NAME))
    INTO n
    FROM fund
   WHERE fund.row_num = f_id;*/
          
         
   END IF;    
      
    OPEN a_RS FOR v_STR;
      
END Get_Reference_Ext;

--03.02.2020    shulgin Get_Reference_Ext в виде функции - для проверки справочников
function Get_Reference_Ext_F(a_ReferenceId number) return dbo.TRecordSet as
l_cursor dbo.TRecordSet;
begin
    Get_Reference_Ext(a_ReferenceId, null, null, l_cursor);
    return l_cursor;
end;
  
 ------------------------------------------   
  BEGIN
    -- Initialization
    NULL;
  END PKG_REF_KURS;
/
