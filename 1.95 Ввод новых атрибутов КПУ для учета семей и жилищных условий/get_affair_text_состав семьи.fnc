CREATE OR REPLACE FUNCTION get_affair_text (a_id IN NUMBER, a_st IN NUMBER, param_ IN NUMBER)
  RETURN VARCHAR2 IS
  --
  --  22.08.2001  PVTar       Создание
  --  02.07.2002  PVTar       Исправлено кол-во чел. на учете под выкуп
  --  12.09.2002  PVTar       Исправил "под выкуп"
  --  19.12.2002  PVTar       Переделан под новый вызов функции get_space_type_affair
  --  27.04.2004  frolov      Добавил информацию о согласовании с Департаментом
  --  28.05.2004              Добавил информацию о дате заявления
  --  09.12.2004              Добавил информацию по ДСЗН
  --  07.07.2005              Добавлена информация о разрешении
  --  16.01.2008  Lvova       Добавлена информация о решении суда
  --  19.05.2008  Lvova       Добавлена информация об учетно-плановом годе
  --  08.09.2008  Anissimova  дата установки вида обеспечения
  --  13.11.2008  BlackHawk   Добавил инфрмацию об "участие" КПУ в программе "компенсации поднайма" (для отдельного окна)
  --  01.12.2008  BlackHawk   Добавил вывод информации об "обманутых вкладчиках"
  --  10.02.2009  Anissimova  № и дата протокола ГЖК для 21 н/у
  --  18.03.2009  BlackHawk   Подправил селект для вывода нескольких комнат для поднайма
  --  25.03.2009  BlackHawk   Подправил текст для поднайма
  --  20.07.2009  BlackHawk   Переделал получение данных о поднайме на функцию из пакета pkg_affair_sublease.
  --                          Добавил вызов функции с информацией о "поднайме" в rtf окна КПУ (УИТ-627/2009)
  --  11.01.2010  Lvova       Изменила получение номера и серии выданного ранее ордера, исп. ф-цию get_order_num_2(orders.order_id,'NS')
  --  13.07.2010  Lvova       Добавила выдачу сообщения о номере и дате РП об аннулировании выданного ордера (выписки)
  --  11.03.2011  Anissimova  Вид очереди
  --  06.07.2011  BlackHawk   Добавил показ поля "Номер в очереди по Москве"
  --  08.07.2011  BlackHawk   Немного подправил вывод со строки про ДСЗН
  --  13.12.2011  BlackHawk   Убрал "Данные МЖР"
  --                          Добавил "Данные УФРС"
  --  20.03.2012  AVB         Добавил документ о малоимущности
  --  03.05.2012  AVB         Добавил информацию о договоре, заключенном по оформленной выписке
  --  30.05.2012  Ikonnikov   Изменён расчет общей и жилой площади с учетом проживающих на данной площадь граждан (там где: 'жил./' и 'общ. } кв.м/чел.)')
  --  20.09.2012  Gladkov     Изменен алгоритм расчета значения "общ. кв.м/чел." (вместо sqo используется поле sqz)
  -- / #D11.02.2013 (Дикан)   добавлено состояние электронного архива 
  --  #D14.06.2013  (Дикан)   добавлено Состав семьи
  --  #D19.06.2013  (Дикан)   добавлено  Ухудшение жил. условий за последние 5
  --
  result VARCHAR2 (32000);
  i1     NUMBER;
  i2     NUMBER;
  i3     NUMBER;
  i4     NUMBER;
  i5     NUMBER;

  CURSOR pers IS
      SELECT person_relation_delo.person_num
            ,RTRIM (get_person (person_relation_delo.person_id)) last_name
            ,DECODE (get_person_sex (person_relation_delo.person_id), 1, 'М', 'Ж') sex
            ,TO_CHAR (get_person_birthday (person_relation_delo.person_id), 'DD.MM.YYYY') birthday
            ,RTRIM (relations.name) rel_name
            ,RTRIM (family.name) frel_name
            ,RTRIM (SUBSTR (get_person_categs_1 (person_relation_delo.person_id), 1, 40)) categ
        FROM affair, person_relation_delo, relations, family
       WHERE     affair.affair_id = a_id
             AND person_relation_delo.affair_id = affair.affair_id
             AND affair.affair_stage = a_st
             AND person_relation_delo.affair_stage = affair.affair_stage
             AND person_relation_delo.relation = relations.row_num(+)
             AND person_relation_delo.frelation = family.row_num(+)
    ORDER BY person_num;
-- #D14.06.2013     
  c_family_structure_pref constant VARCHAR2 (140) := ' \par   {\bСостав семьи} - в соответствии со ст. 20 закона г. Москвы №29 - {\b '; 
-- /#D14.06.2013   
BEGIN
  result   := '';

  IF param_ = 1 THEN
    SELECT    '{\b   '
           || DECODE (TO_CHAR (affair.sq_type), '1', '', TO_CHAR (get_room_cnt (affair.affair_id, affair.affair_stage)) || ' комн. в ')
           || TO_CHAR (affair.kk_num)
           || ' комн. '
           || RTRIM (get_space_type_affair (affair.affair_id, affair.affair_stage))
           || '  '
           || TO_CHAR (sqi, '99999.9')
           || '} кв.м '
           || '\par '
           || CHR (10)
           || DECODE (get_classifier (34, affair.sstatus)
                     ,NULL, ' '
                     ,' ', ' '
                     ,'  Вид заселения: {\b' || get_classifier (34, affair.sstatus) || '}\par '
                     )
           || DECODE (get_classifier (85, get_och_type_1 (affair.delo_num, affair.stand_year))
                     ,NULL, ' '
                     ,' ', ' '
                     ,'  Вид очереди: {\b' || get_classifier (85, get_och_type_1 (affair.delo_num, affair.stand_year)) || '}\par '
                     )
           || '  с {\b '
           || affair.year_in_place
           || '}  ( в Москве c {\b '
           || affair.year_in_city
           || '} года )'
           || '\par '
           || CHR (10)
           || '  всего в семье {\b '
           || TO_CHAR (affair.person_in_family)
           || '} чел., на учете {\b '
           || reg_person_cnt
           || '} чел., зарегистрировано на указанной площади {\b '
           || get_person_reg_cnt_all(affair.affair_id, affair.affair_stage)
           || '} чел.'
           || DECODE (affair.reason, 8, DECODE (affair.type2, 3, ' (уч. в выкупе)', ''), '')
           || ' ({\b '
           || LTRIM (TO_CHAR (
                             DECODE (affair.person_in_family
                                    , 0, 0, 
                                    affair.sqi / get_person_reg_cnt_all(affair.affair_id, affair.affair_stage)
                                    )
                             , '99999.9'
                             )
                    )
           || ' жил./'
           || LTRIM (
                TO_CHAR (
                  DECODE (affair.person_in_family
                         ,0, 0
                         ,DECODE (get_Is_BTI_hostel_kurs3_not(apartment.apart_id,affair.affair_id,affair.affair_stage)
                                 ,0,
                                 DECODE (apartment.living_space
                                        ,0,0                 
                                        ,(affair.sqi * affair.sqo) / (get_person_reg_cnt_all(affair.affair_id, affair.affair_stage) * get_apart_liv (affair.apart_id))
                                        )
                                 ,affair.sqz / get_person_reg_cnt_all(affair.affair_id, affair.affair_stage)
                                 )   
                         )
                         ,'99999.9'
                         )
                     )
           || ' общ. } кв.м/чел.) '
-- #D14.06.2013             
           || (SELECT case when NVL(cl.short_name1, ' ')=' ' then ' ' else c_family_structure_pref||cl.short_name1||'}' end case FROM classifier_kurs3 cl WHERE CL.CLASSIFIER_NUM = 139 AND cl.row_num =Get_family_structure(a_id,a_st))
-- / #D14.06.2013 
--  #D19.06.2013 
           ||get_uhud_usl_strinfo(affair_id)           
-- / #D19.06.2013 
           || DECODE (affair.decl_date, NULL, ' ', ' \par   Дата заявления: {\b ' || TO_CHAR (affair.decl_date, 'DD.MM.YYYY') || '}')
           || DECODE (
                affair.decision_num
               ,NULL, ' '
               ,   ' \par   Номер решения {\b '
                || RTRIM (affair.decision_num)
                || '} от {\b '
                || TO_CHAR (affair.delo_date, 'DD.MM.YYYY')
                || '}'
              )
           || get_subsid_message (affair.affair_id)
           || DECODE (get_prohibitionaf (affair.affair_id), 0, ' ', '\par {\b Есть разрешение }')
           || DECODE (
                get_kpu_decree_num (affair.affair_id, affair.affair_stage)
               ,NULL, ' '
               ,   ' \par   Дело открыто по решению суда:  номер {\b '
                || RTRIM (TO_CHAR (get_kpu_decree_num (affair.affair_id, affair.affair_stage)))
                || '} от {\b '
                || NVL (TO_CHAR (get_kpu_decree_date (affair.affair_id, affair.affair_stage), 'DD.MM.YYYY'), ' ')
                || '}'
              )
           || DECODE (get_affair_queue_01_num (affair_id)
                     ,NULL, ''
                     ,'\par   Номер в очереди по Москве: {\b ' || get_affair_queue_01_num (affair_id) || '}'
                     )
           || ( SELECT '\par   Документ о малоимущности: {\b '
                     || (SELECT NAME FROM CLASSIFIER_KURS3
                          WHERE CLASSIFIER_NUM = 130 AND ROW_STATUS = 1 AND DELETED = 0 AND ROW_NUM = ae.DATA_N)
                     || ' № '|| DATA_S ||' от '|| to_char(DATA_D,'dd.mm.yyyy')
                     || '}'
                 FROM AFFAIR_EXT_DATA ae
                WHERE AFFAIR_ID = affair.affair_id AND DATA_TYPE_ID = 5 AND DATA_VERSION = 0 )
      INTO result
      FROM affair, apartment
     WHERE affair_id = a_id AND affair_stage = a_st AND apartment.building_id = affair.build_id AND apartment.apart_id = affair.apart_id;
  ELSIF param_ = 2 THEN
    SELECT    get_affair_permit_chr (affair.affair_id, affair.affair_stage, 'rtf')
           --          DECODE(get_affair_permit(affair.affair_id, affair.affair_stage, 1), 1, ' {\b Дело согласовано по 26 ошибке } \par ', '')
           --       ||DECODE(get_affair_permit(affair.affair_id, affair.affair_stage, 2), 1, ' {\b Дело согласовано по 25 ошибке } \par ', '')
           --       ||DECODE(get_affair_permit(affair.affair_id, affair.affair_stage, 4), 1, ' {\b Дело согласовано по 29 ошибке } \par ', '')
           || '  Округ постановки :  {\b '
           || SUBSTR (get_okrug (affair.okrug_id), 1, 200)
           || '} \par '
           || CHR (10)
           || '  Год постановки : {\b '
           || TO_CHAR (affair.stand_year)
           || '} \par '
           || CHR (10)
           || '  Льготная категория :{\b '
           || get_kateg_all (affair.delo_category, affair.reason)
           || ' '
           || get_obfb_obdt (affair.affair_id)
           || '} '
           || DECODE (
                affair.reason || '#' || affair.delo_category
               ,'8#26', DECODE (get_affair_num_om (affair.affair_id)
                               ,NULL, ''
                               ,' Постановка в о/м: {\b ' || get_affair_num_4 (get_affair_num_om (affair.affair_id)) || '}'
                               )
               ,''
              )
           || '\par '
           || DECODE (affair.delo_category_old
                     ,0, ''
                     ,NULL, ''
                     ,'  Старая категория :{\b ' || get_kateg_all (affair.delo_category_old, affair.reason) || '} \par '
                     )
           || '  Общественная группа :{\b '
           || get_sgroup (affair.s_group)
           || '} \par '
           || CHR (10)
           || '  Вид обеспеч.жил.площ. :{\b '
           || get_classifier (11, type2)
           || '}'
           || DECODE (datatime, NULL, ' ', ' \par   Обещано к :{\b ' || TO_CHAR (datatime, 'dd.mm.yyyy') || '}')
           || ' '
           || get_affair_plan_message_2 (affair.affair_id, affair.affair_stage)
           || ' \par '
           || '  Состояние постановки :{\b '
           || get_status (affair.status)
           || DECODE (
                affair.status
               ,1, DECODE (affair.plan_year,  NULL, ' ',  0, ' ',  CHR (10) || '{\b   ' || TO_CHAR (affair.plan_year) || '} г')
               ,3, DECODE (affair.plan_year,  NULL, ' ',  0, ' ',  CHR (10) || '}, план {\b   ' || TO_CHAR (affair.plan_year) || '} г{')
               ,4, DECODE (affair.plan_year,  NULL, ' ',  0, ' ',  CHR (10) || '}, план {\b   ' || TO_CHAR (affair.plan_year) || '} г{')
               ,5, '}, \par       причина снятия - { \b ' || get_reason2 (affair.reason2) || ' } '
                   || DECODE (affair.reason2_date
                             ,NULL, ' '
                             ,' \par   Дата снятия с учета - { \b ' || TO_CHAR (affair.reason2_date, 'dd.mm.yyyy') || '} '
                             )
                   || DECODE (affair.reason2_num, NULL, ' ', '  распоряжение № { \b ' || affair.reason2_num || '} ')
                   || '{'
               ,' '
              )
           || '} '
           || DECODE (
                affair.ordered
               ,1, ' '
                   || DECODE (
                        get_number_order (affair.affair_id, affair.affair_stage)
                       ,0, ' '
                       ,   '\par {\b   Выдавался ордер} № '
                        /*                                 || get_order_num_1 (get_number_order (affair.affair_id, affair.affair_stage))
                                                           || ' '
                                                           || TRIM (get_order_ser (get_number_order (affair.affair_id, affair.affair_stage)))
                        */
                        || get_order_num_2 (get_number_order (affair.affair_id, affair.affair_stage), 'NS')
                        || ' от '
                        || get_order_date (get_number_order (affair.affair_id, affair.affair_stage))
                        || DECODE (affair.status
                                  ,5, ''
                                  ,' по адресу ' || addr_apartmento_fmt (get_number_order (affair.affair_id, affair.affair_stage))
                                  )
                        --                                   || DECODE (get_order_deleted (get_number_order (affair.affair_id, affair.affair_stage)), 1, ' (аннулирован)', '')
                        || DECODE (
                             get_order_deleted (get_number_order (affair.affair_id, affair.affair_stage))
                            ,1,    ' (аннулирован по РП номер '
                                || NVL (pkg_orders.get_orders_ext_data_s (get_number_order (affair.affair_id, affair.affair_stage), 87, 0), ' ')
                                || ' от '
                                || NVL (
                                     TO_CHAR (pkg_orders.get_orders_ext_data_d (get_number_order (affair.affair_id, affair.affair_stage), 88, 0)
                                             ,'DD.MM.YYYY'
                                             )
                                    ,' '
                                   )
                                || ')'
                            ,''
                           )
                      )
               --                      || DECODE(get_affair_order(affair.affair_id, affair.affair_stage)
               --                                ,NULL, ' '
               --                                ,0, ' '
               --                                , '\par {\b   Выдавался ордер} № '
               --                                  || get_order_num(get_affair_order(affair.affair_id, affair.affair_stage))
               --                                  || get_order_ser(get_affair_order(affair.affair_id, affair.affair_stage))
               --                                  || ' от '
               --                                  || get_order_date(get_affair_order(affair.affair_id, affair.affair_stage))
               --           || DECODE(affair.status
               --              , 5, ''
               --             , DECODE(affair_blocked(affair.affair_id)
               --               , 1, ' по адресу ' || addr_apartmento_fmt(get_affair_order(affair.affair_id, affair.affair_stage))
               --              , ''))
               --                                  || DECODE(get_order_deleted(get_affair_order(affair.affair_id, affair.affair_stage))
               --                                           ,1, ' (аннулирован)'
               --                                           ,''))
               ,' '
              )
           || '\par '
           || CHR (10)       --  03.05.2012  AVB   УИТ_179_2012   -->>
            || DECODE (
                  affair.ordered,
                  1, ''
                     || DECODE (
                           NVL(get_number_order (affair.affair_id, affair.affair_stage),0),
                           0, '',
                           (Select NVL2(DECODE(o.type3, 3, o.agreement_num, ag.agr_num_spec),
                                     '{\b   Договор} № {\b '||DECODE(o.type3, 3, o.agreement_num, ag.agr_num_spec)
                                     ||' } от  {\b '||TO_CHAR(DECODE (o.type3, 3, o.order_date, ag.agreement_date),'dd.mm.yyyy')
                                     ||' }\par ','')
                                FROM orders o, agreement ag
                               Where o.order_id = ag.order_id(+)
                                 and o.order_id = get_number_order (affair.affair_id, affair.affair_stage) )
                        ),
                  '')
            || DECODE (
                  affair.ordered,
                  1, ''
                     || DECODE (
                           NVL(get_number_order (affair.affair_id, affair.affair_stage),0),
                           0, '',
                           NVL2(get_order_agreementdate4affair (get_number_order (affair.affair_id, affair.affair_stage)),
                            '  Дата учета подписанного договора : {\b '
                            ||TO_CHAR(get_order_agreementdate4affair (get_number_order (affair.affair_id, affair.affair_stage)),'dd.mm.yyyy')
                            ||' }\par ','')
                        ),
                  '')              -- <<--
           || DECODE (affair.registration_date
                     ,NULL, ''
                     ,'  Дата перерегистрации :{\b ' || TO_CHAR (affair.registration_date, 'dd.mm.yyyy') || ' }\par '
                     )
           || DECODE (affair.creation_date
                     ,NULL, '  Дата создания КПУ:{\b ' || TO_CHAR (affair.delo_date, 'dd.mm.yyyy') || '} \par '
                     ,'  Дата создания КПУ:{\b ' || TO_CHAR (affair.creation_date, 'dd.mm.yyyy') || '} \par '
                     )
           || DECODE (affair.decl_date
                     ,NULL, ''
                     ,'  Дата подачи завления:{\b ' || TO_CHAR (affair.decl_date, 'dd.mm.yyyy') || '} \par'
                     )
           ---------------- 08.09.2008 Anissimova -- дата установки вида обеспечения
           || DECODE (affair.type2_date
                     ,NULL, ''
                     ,'   Дата установки вида обеспечения:{\b ' || TO_CHAR (affair.type2_date, 'dd.mm.yyyy') || '} \par'
                     )
           -------------------------------------------------------------------------
           ---------------- 10.02.2009 Anissimova -- номер и дата протокола ГЖК
           || DECODE (
                affair.dc_date
               ,NULL, ''
               ,'   Протокол ГЖК № {\b ' || affair.dc_num || '}' || ' от {\b ' || TO_CHAR (affair.dc_date, 'dd.mm.yyyy') || '} \par'
              )
           -------------------------------------------------------------------------
           || DECODE (
                affair.calc_year
               ,NULL, ''
               ,'   Учетно-плановый год: {\b ' || TO_CHAR (affair.calc_year) || '}'
                || DECODE (
                     affair.calc_change
                    ,NULL, ''
                    ,   ' изменен {\b '
                     || TO_CHAR (affair.calc_change, 'dd.mm.yyyy')
                     || '} , {\b '
                     || get_classifier_kurs3 (114, affair.calc_reason, 'NAME')
                     || '}'
                   )
                || ' \par '
              )
           || get_affair_fraud (affair.affair_id, NULL, 'rtf')
           || test_kpu_1 (affair.affair_id)
           --|| '  Данные МЖР: {\b ' --Временная заглушка обязательно убрать (Frolov)
           --|| NVL (get_mgr_apart_info (affair.apart_id), ' нет ')
           --|| '}'
           --|| ' \par   '
          --25.09.2012 Ilonis
           || '  Данные о собственности: '      
           --|| '  Данные УФРС: '
           || pkg_ufrs_req.get_affair_request_info (affair_id, affair_stage)
           || dszn.get_dszn_affair_info (affair.affair_id)
           || DECODE (get_affair_46deliver (affair_id, affair_stage)
                     ,1, '\par   {\b Присоединение по 46 статье}'
                     ,2, '\par   {\b Высвобождение по 46 статье}'
                     ,''
                     )
           || SUBSTR (get_affair_excl_list (affair_id, affair_stage), 1, 2000)
           || SUBSTR (pkg_affair_sublease.get_affair_sublease_text (get_affair_text.a_id, 2), 1, 2000)
-- #D11.02.2013           
           || get_scan_check_strinfo(affair_id,0,0) 
-- / #D11.02.2013            
      INTO result
      FROM affair, apartment
     WHERE affair_id = a_id AND affair_stage = a_st AND apartment.building_id = affair.build_id AND apartment.apart_id = affair.apart_id;
  --  i1:=0;
  --  i2:=0;

  ------  Информация из ARS
  /*
  FOR v1 IN (SELECT '\par {\b\cf2 ' || NAME || ' }' a1
               FROM classifier_kurs3
              WHERE classifier_num = 102 AND INSTR (ars_data.format_message (a_id, a_st), row_num) > 0) LOOP
    RESULT := RESULT || v1.a1;
  END LOOP;
  */
  ------
   /*for v_Temp in (
  SELECT
  ars_DATA.GET_FAMILY_NUM(a_ID,a_St,person_id)as ARS_F_NUM
     ,SIGN(NVL(ars_DATA.GET_FAMILY_ARS_MASTER(A_ID,a_ST,person_id),0)) as ARS_MASTER
     ,FAMILY_NUM
     ,NVL(FAMILY_MASTER,0)as FAMILY_MASTER
 FROM V_FAMILY_PERSON
 WHERE AFFAIR_ID= a_id AND AFFAIR_STAGE=a_st) loop

i1:=i1+v_Temp.ARS_F_NUM;

IF v_Temp.ARS_F_NUM<>v_Temp.FAMILY_NUM or v_Temp.ARS_MASTER<>v_Temp.FAMILY_MASTER THEN
   i2:=1;
END IF;

IF i1<>0 and i2<>0 THEN
   exit;
end if;
END LOOP;

IF i1<>0 THEN
 IF i2<>0 THEN
   Result:=Result||'\par   {\b\cf2 Появилась новая ЭС. Проверяйте разбивку на ЭС КПУ и включайте в План_КПУ - ПрогМС }';
ELSE
   select Count(*)
   INTO i2
   from affair_plan
      where AFFAIR_ID= a_id AND AFFAIR_STAGE=a_st
        and PLAN_TYPE<>3;

   IF i2=0 THEN
      Result:=Result||'\par   {\b\cf2 МС прошла перерегистрацию в Агентстве }';
   ELSE
      Result:=Result||'\par   {\b\cf2 Появилась новая МС, включайте в ПрогМС }';
   END IF;
END IF;

select NVL(sum(PERSON_CNT),0)
INTO i2
from affair_ars_data
WHERE AFFAIR_ID= a_id
      AND AFFAIR_STAGE=a_st;

IF i2>0 THEN
   Result:=Result||'\par   {\b\cf2 Есть члены МС, которые не внесены в КПУ }';
END IF;
END IF;*/
  ---------------------
  ELSIF param_ = 3 THEN
    i1   := 0;
    i2   := 0;
    i3   := 0;
    i4   := 0;
    i5   := 0;

    FOR rec IN pers LOOP
      result      :=
           result
        || rtf.get_first_row
        || TO_CHAR (rec.person_num)
        || rtf.get_between_cels
        || rec.last_name
        || rtf.get_between_cels
        || rec.sex
        || rtf.get_between_cels
        || rec.birthday
        || rtf.get_between_cels
        || rec.rel_name
        || rtf.get_between_cels
        || rec.frel_name
        || rtf.get_between_cels
        || rec.categ
        || rtf.get_between_cels
        || rtf.get_last_row;

      IF i1 < LENGTH (TO_CHAR (rec.person_num)) THEN
        i1   := LENGTH (TO_CHAR (rec.person_num));
      END IF;

      IF i2 < LENGTH (rec.last_name) THEN
        i2   := LENGTH (rec.last_name);
      END IF;

      IF i3 < LENGTH (rec.rel_name) THEN
        i3   := LENGTH (rec.rel_name);
      END IF;

      IF i4 < LENGTH (rec.frel_name) THEN
        i4   := LENGTH (rec.frel_name);
      END IF;

      IF i5 < LENGTH (rec.categ) THEN
        i5   := LENGTH (rec.categ);
      END IF;
    END LOOP;

    i2   := i2 + 2;
    i3   := i3 + 1;
    i4   := i4 + 2;
    i5   := i5 + 2;
    result      :=
         rtf.get_tab_header
      || rtf.get_cels
      || TO_CHAR (i1 * 200)
      || CHR (13)
      || CHR (10)
      || rtf.get_cels
      || TO_CHAR (i1 * 200 + i2 * 112)
      || CHR (13)
      || CHR (10)
      || rtf.get_cels
      || TO_CHAR (i1 * 200 + i2 * 112 + 400)
      || CHR (13)
      || CHR (10)
      || rtf.get_cels
      || TO_CHAR (i1 * 200 + i2 * 112 + 400 + 1300)
      || CHR (13)
      || CHR (10)
      || rtf.get_cels
      || TO_CHAR (i1 * 200 + i2 * 112 + 400 + 1300 + i3 * 112)
      || CHR (13)
      || CHR (10)
      || rtf.get_cels
      || TO_CHAR (i1 * 200 + i2 * 112 + 400 + 1300 + i3 * 112 + i4 * 112)
      || CHR (13)
      || CHR (10)
      || rtf.get_cels
      || TO_CHAR (i1 * 200 + i2 * 112 + 400 + 1300 + i3 * 112 + i4 * 112 + i5 * 112)
      || CHR (13)
      || CHR (10)
      || result;
  ELSIF param_ = 4 THEN
    IF kurs3_var.number_version <= 771 THEN
      result   := '}';
    END IF;
  ELSIF param_ = 5 THEN
    result   := pkg_affair_sublease.get_affair_sublease_text (get_affair_text.a_id, 1);
  END IF;

  RETURN result;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
  WHEN OTHERS THEN
    RETURN NULL;
END get_affair_text;
/
