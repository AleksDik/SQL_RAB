CREATE OR REPLACE PROCEDURE kursiv.do_for_taffair (form_class_name IN     VARCHAR2
                                                  ,form_name       IN     VARCHAR2
                                                  ,form_handle     IN     NUMBER
                                                  ,form_event      IN     VARCHAR2
                                                  ,out_props       IN     VARCHAR2
                                                  ,qcommand        IN OUT pckg_tree.curstype
                                                  ) IS
  --
  --  01.09.2008  Anissimova  проверки для 21 направления учета
  --  10.09.2008  Anissimova  изменения в пункте меню "Вид обеспечения" для 21 н/у
  --  01.12.2008  BlackHawk   Добавил пункт меню "Обманутые вкладчики"
  --  09.02.2009  Anissimova  создание пункта меню "Номер и дата протокола ГЖК" для 21 н/у
  --  10.02.2009  Jarikov     Добавлен пункт "Коттеджи для многодетных"
  --  20.04.2009  BlackHawk   Убрал пункт меню "Мониторинг поднайма"
  --  20.07.2009  BlackHawk   Открыл пункт меню "Поднайм" для КПУ, у который есть Выписка с order_stage=1 (УИТ-627/2009)
  --  24.01.2011  BlackHawk   Добаивил пункт меню "Возврат Поставновки в РУЖП"
  --  17.05.2011  BlackHawk   Переделал название пункта меню miDopPasp
  --  07.07.2011  BlackHawk   Переименовал название пункта меню miCottage (УИТ-620/2010)
  --                          Добавил проверку на показывание пункта miCottage (УИТ-620/2010)
  --  12.07.2011  BlackHawk   Добавил пункт меню miSendToEirc и его обработку
  --  27.10.2011  Anissimova  Обработка п.меню "Подбор жилплощади" для субсидий
  --  14.11.2011  BlackHawk   Убрал обработку п.меню "Подбор жилплощади" для субсидий (перенёс это в процедуру сохранения проекта Распоряжения)
  --  03.02.2012  AVB         Открыл пункт меню miDeclDate(Работа с делом/Дата заявления) для КПУ по 08 направлению УЖУ для ведомств (под учетной записью VD)
  --  20.03.2012  AVB         Добавил малоимущность   
 -- 12.12.2012 Ilonis-- пункт меню "Номер и дата протокола ГЖК" для 21 н/у переименовал  и привязал к привилегии 110
  --  ilonis 17.06.2013  to Dikan    
  --
  
  a_id           NUMBER;
  a_st           NUMBER;
  r_o            NUMBER;
  a              VARCHAR2 (2000);
  b              VARCHAR2 (20);
  c              VARCHAR2 (20);
  c1             VARCHAR2 (20);
  t2             NUMBER;
  o_id           NUMBER;
  p_f_h          NUMBER;
  l_decl_date    DATE;
  nn             NUMBER;
  can_del        NUMBER (1);
  date_          DATE;
  num_           NUMBER;
  c_year         NUMBER;
  c_reason       NUMBER;
  d_categ        NUMBER;
  cottage_yes_no NUMBER (1);
BEGIN
  p_f_h   := get_id_param ('ParentFormHandle', out_props);
  a       := UPPER (out_props);
  b       := 'AFFAIR_ID=';

  SELECT SUBSTR (a, INSTR (a, b) + LENGTH (b), INSTR (SUBSTR (a, INSTR (a, b)), ';') - LENGTH (b) - 1) INTO c FROM DUAL;

  a_id    := TO_NUMBER (c);
  b       := 'AFFAIR_STAGE=';

  SELECT SUBSTR (a, INSTR (a, b) + LENGTH (b), INSTR (SUBSTR (a, INSTR (a, b)), ';') - LENGTH (b) - 1) INTO c FROM DUAL;

  a_st    := TO_NUMBER (c);
  b       := 'READONLY_=';

  SELECT SUBSTR (a, INSTR (a, b) + LENGTH (b), INSTR (SUBSTR (a, INSTR (a, b)), ';') - LENGTH (b) - 1) INTO c FROM DUAL;

  r_o     := TO_NUMBER (c);

  --------------------------------------------------------------------------
  IF form_event = 'PRINT_AFFAIR' THEN
    OPEN qcommand FOR
        SELECT *
          FROM (SELECT 1 AS cmd_id, 'LoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL
                UNION
                SELECT 2 AS cmd_id
                      ,'CreateObject;ClassName=TfmRepRTF;Owner=Application;Name=frmPrintAffair;'
                       || 'Caption=Печать справки о заявителе;TypeReport=1;'
                         AS cmd_lines
                  FROM DUAL
                UNION
                SELECT 3 AS cmd_id, 'CreateObject;ClassName=TOraQuery;Owner=frmPrintAffair;Name=qHeader;SQL=;' AS cmd_lines FROM DUAL
                UNION
                SELECT 4 AS cmd_id
                      ,'SELECT * FROM V_F1_NEW WHERE AFFAIR_ID = ' || TO_CHAR (a_id) || ' AND AFFAIR_STAGE = ' || TO_CHAR (a_st) || '' AS cmd_lines
                  FROM DUAL
                UNION
                SELECT 5 AS cmd_id, 'EndSQL;Active=1;' AS cmd_lines FROM DUAL
                UNION
                SELECT 5.3 AS cmd_id, 'CreateObject;ClassName=TOraQuery;Owner=frmPrintAffair;Name=qBody;SQL=;' AS cmd_lines FROM DUAL
                UNION
                SELECT 5.4 AS cmd_id
                      ,   'SELECT * FROM KURS3.V_F1_PERSONS WHERE AFFAIR_ID = '
                       || TO_CHAR (a_id)
                       || ' AND AFFAIR_STAGE = '
                       || TO_CHAR (a_st)
                       || ' ORDER BY A1 '
                         AS cmd_lines
                  FROM DUAL
                UNION
                SELECT 5.5 AS cmd_id, 'EndSQL;Active=1;' AS cmd_lines FROM DUAL
                UNION
                SELECT 6 AS cmd_id
                      ,'Window;Name=frmPrintAffair;AddHeader=qHeader;AddBody=qBody;AddFooter=qHeader;' || 'StartReport=1;Free=;' AS cmd_lines
                  FROM DUAL
                UNION
                SELECT 7 AS cmd_id, 'UnLoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL)
      ORDER BY cmd_id;
  --------------------------------------------------------------------------
  ELSIF form_event = 'FormCreate' THEN
    OPEN qcommand FOR
        SELECT *
          FROM (SELECT 1 AS cmd_id
                      ,'CreateObject;ClassName=TMenuItem;Name=miPermitOn;CopyAction=MenuCommandAction;Caption=Согласование;'
                       || 'Owner=Self;ItemsAdd=PopupMenu1;Enabled=0;Visible=0;Reset;'
                         AS cmd_lines
                  FROM kurs3.global_parameters gl
                 WHERE USERENV ('TERMINAL') = UPPER (gl.VALUE) AND gl.parameter_name = 'PERMIT_AFFAIR'
                UNION ALL
                SELECT 1.5 AS cmd_id
                      ,'CreateObject;ClassName=TMenuItem;Name=miPermit1983On;CopyAction=MenuCommandAction;Caption=Разрешение;'
                       || 'Owner=Self;ItemsAdd=PopupMenu1;Enabled=1;Visible=1;Reset;'
                         AS cmd_lines
                  FROM kurs3.global_parameters gl
                 WHERE USERENV ('TERMINAL') = UPPER (gl.VALUE) AND gl.parameter_name = 'PERMIT_AFFAIR'
                UNION ALL
                SELECT 2 AS cmd_id
                      ,'CreateObject;ClassName=TmenuItem;Name=miDeclDate;CopyAction=MenuCommandAction;Caption=Дата заявления;'
                       || 'Owner=Self;ItemsAdd=PopupMenu1;Enabled=0;Visible=1;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 2 AS cmd_id
                      ,'CreateObject;ClassName=TmenuItem;Name=miXPOrder;CopyAction=MenuCommandAction;Caption=Смотровой ордер;'
                       || 'Owner=Self;ItemsAdd=PopupMenu1;'
                         AS cmd_lines
                  FROM DUAL
                 WHERE kurs3_var.get_okrug_id >= 50 AND kurs3_var.get_okrug_id <= 60 AND get_user_priv (62) = 1
                UNION ALL
                SELECT 3 AS cmd_id
                      ,'CreateObject;ClassName=TmenuItem;Name=miSetPersonDocs;CopyAction=MenuCommandAction;Caption=Документы на льготы;'
                       || 'Owner=Self;ItemsAdd=PopupMenu2;Visible=0;Enabled=0;'
                         AS cmd_lines
                  FROM DUAL
               --   WHERE kurs3_var.get_okrug_id >= 50 AND kurs3_var.get_okrug_id <= 60
                WHERE kurs3_var.get_okrug_id in (50,51,52,53,54,55,56,57,58,59,60,62,63)
                UNION ALL
                SELECT 4 AS cmd_id
                      ,'CreateObject;ClassName=TmenuItem;Name=miCalcYear;CopyAction=MenuCommandAction;Caption=Учетно-плановый год;'
                       || 'Owner=Self;ItemsAdd=N1;Visible=1;Enabled=0;MenuIndex=5;'
                         AS cmd_lines
                  FROM kurs3.global_parameters gl
                 WHERE USERENV ('TERMINAL') = UPPER (gl.VALUE) AND gl.parameter_name = 'AFFAIR_CALC_YEAR'
                UNION ALL
                SELECT 5 AS cmd_id
                      ,'CreateObject;ClassName=TmenuItem;Name=miKPU_COURT;CopyAction=MenuCommandAction;Caption=Номер и дата решения суда;'
                       || 'Owner=Self;ItemsAdd=PopupMenu1;Visible=1;Enabled=0;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                ------ 09.02.2009 Anissimova -- пункт меню "Номер и дата протокола ГЖК" для 21 н/у
--                SELECT 6 AS cmd_id
--                    ,'CreateObject;ClassName=TmenuItem;Name=miGGhK;CopyAction=MenuCommandAction;Caption=Номер и дата протокола ГЖК;'
--                   || 'Owner=Self;ItemsAdd=PopupMenu1;Visible=1;Enabled=0;'
--                         AS cmd_lines
--                  FROM kurs3.global_parameters gl
--                 WHERE USERENV ('TERMINAL') = UPPER (gl.VALUE) AND gl.parameter_name = 'PROTOCOL_GGK_21' AND kurs3_var.direction_id = 21
--              UNION ALL
                ------ 12.12.2012 Ilonis-- пункт меню "Номер и дата протокола ГЖК" для 21 н/у переименовал  и привязал к привилегии 110
               SELECT 6 AS cmd_id
                      ,'CreateObject;ClassName=TmenuItem;Name=miGGhK;CopyAction=MenuCommandAction;Caption=Поручение на предоставление ж/пл;'
                       || 'Owner=Self;ItemsAdd=PopupMenu1;'
                       ||'Visible='||case when (kurs3_var.direction_id = 21) then 1 else 0 end||';'
                       ||'Enabled=' ||case when ((get_user_priv(110)=1) and (kurs3_var.direction_id = 21)) then 1 else 0 end ||';'
                         AS cmd_lines
                  FROM DUAL 
                 
                UNION ALL
           
                -----------------------------------------------------------------------------------
                ------ 10.09.2008 Anissimova -- пункт меню "Вид обеспечения" для 21 н/у
                SELECT 7 AS cmd_id
                      ,'CreateObject;ClassName=TmenuItem;Name=miType2;CopyAction=MenuCommandAction;Caption=Вид обеспечения;'
                       || 'Owner=Self;ItemsAdd=N1;Visible=1;Enabled=0;MenuIndex=6;'
                         AS cmd_lines
                  FROM DUAL
                 WHERE kurs3_var.direction_id = 21
                UNION ALL
                ------ 20.03.2012 AVB малоимущность
                SELECT 7.1 AS cmd_id
                      ,'CreateObject;ClassName=TmenuItem;Name=miDocPoor;CopyAction=MenuCommandAction;Caption=Документ о малоимущности;'
                       || 'Owner=Self;ItemsAdd=PopupMenu1;Visible=1;Enabled=0;'
                         AS cmd_lines
                  FROM DUAL
                 WHERE kurs3_var.direction_id = 1
                UNION ALL
                ------------------------------------------------------------------------
                SELECT 8 AS cmd_id, 'CreateObject;ClassName=TMenuItem;Name=miSubleaseLine;Owner=Self;Caption=-;ItemsAdd=PopupMenu1;' AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 9 AS cmd_id
                      ,'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSublease;Caption=Найм (поднайм);CopyAction=MenuCommandAction;'
                       || 'ItemsAdd=PopupMenu1;Enabled=1;Visible=1;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 10 AS cmd_id
                      ,'CreateObject;ClassName=TmenuItem;Name=miSetFraud;CopyAction=MenuCommandAction;Caption=Обманутые вкладчики;'
                       || 'Owner=Self;ItemsAdd=PopupMenu2;Visible=0;Enabled=0;'
                         AS cmd_lines
                  FROM DUAL
                 WHERE kurs3_var.get_okrug_id >= 50 AND kurs3_var.get_okrug_id <= 60
                UNION ALL
                SELECT 11 AS cmd_id
                      ,'CreateObject;ClassName=TmenuItem;Name=miDopPasp;CopyAction=MenuCommandAction;Caption=Доп. паспортные данные, СНИЛС, ИНН;'
                       || 'Owner=Self;ItemsAdd=PopupMenu2;Visible=1;Enabled=1;'
                         AS cmd_lines
                  FROM DUAL
                --WHERE kurs3_var.get_okrug_id >= 50 AND kurs3_var.get_okrug_id <= 60
                UNION ALL
                SELECT 12 AS cmd_id
                      ,'CreateObject;ClassName=TmenuItem;Name=miCottage;CopyAction=MenuCommandAction;Caption=Согласие/отказ от коттеджа/кв. инв-коляс/кв.превыш.соц.норму;'
                       || 'Owner=Self;ItemsAdd=PopupMenu1;Visible=1;Enabled=0;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 13 AS cmd_id
                      ,'CreateObject;ClassName=TmenuItem;Name=miReturnToRujp;CopyAction=MenuCommandAction;Caption=Вернуть Постановку в РУЖП;'
                       || 'Owner=Self;ItemsAdd=PopupMenu1;Visible=0;Enabled=0;'
                         AS cmd_lines
                  FROM DUAL
                 WHERE get_global_param_num_value ('USE_RUJP') = 1
--                UNION ALL
--                SELECT 14 AS cmd_id
--                      ,'CreateObject;ClassName=TmenuItem;Name=miSendToEirc;CopyAction=MenuCommandAction;Caption=Отправить пакет данных в ЕИРЦ;'
--                       || 'Owner=Self;ItemsAdd=PopupMenu1.miEIRC;Visible=1;Enabled=1;'
--                         AS cmd_lines
--                  FROM DUAL
--                 WHERE USERENV ('terminal') IN ('C-TARAKANOV')
                UNION ALL
                SELECT menu_id AS cmd_id
                      ,   'CreateObject;ClassName=TmenuItem;Name='
                       || menu_text
                       || ';CopyAction=MenuCommandAction;Owner=Self;ItemsAdd='
                       || owner
                       || DECODE (image_index, NULL, '', ';IMAGEINDEX=' || image_index)
                       || DECODE (menu_hint, NULL, '', ';Hint=' || menu_hint)
                       || DECODE (shortcut, NULL, '', ';SHORTCUT=' || shortcut)
                       || ';MenuIndex='
                       || NVL (menu_order, 0)
                       || ';Caption='
                       || NVL (menu_caption, '-')
                       || ';'
                         AS cmd_lines
                  FROM menus
                 WHERE (menu_id = 173 AND (kurs3_var.number_version >= 780) AND get_user_priv (63) > 0) OR menu_id IN (180)
                --                UNION ALL
                --                SELECT 199 AS cmd_id
                --                      ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSubleaseInfo;Caption=Мониторинг поднайма;CopyAction=MenuCommandAction;'
                --                        || 'ItemsAdd=N27;Enabled=1;Visible=1;' AS cmd_lines
                --                  FROM DUAL
                UNION ALL
                SELECT 200 AS cmd_id, 'Object;Name=miErasePlan;Visible=0;Enabled=0;' AS cmd_lines FROM DUAL)
      ORDER BY cmd_id;
  ELSIF form_event = 'SET_ID' THEN
    a   := UPPER (out_props);
    b   := 'TAFFAIR.READONLY_=';

    SELECT DECODE (SUBSTR (a, INSTR (a, b) + LENGTH (b), INSTR (SUBSTR (a, INSTR (a, b)), ';') - LENGTH (b) - 1), '0', '1', '0') INTO c FROM DUAL;

    IF kurs3_var.direction_id = 8 THEN -- 8-е направление учета
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id
                        ,   'Object;Name=miRedemp;Visible=0;Reset;'
                         || 'Object;Name=N13;Caption=Подбор жилплощади;Reset;'
                         || 'Object;Name=miRefDC;Visible=0;Enabled=0;Reset;'
                         || 'Object;Name=N10;Visible=0;Enabled=0;Reset;'
                         || 'Object;Name=miPublishCP;Visible=0;Enabled=0;Reset;'
                         || 'Object;Name=miSetPersonDocs;Visible=1;Enabled=1;Reset;'
                         || 'Object;Name=miKPU_COURT;Enabled='
                         || DECODE (r_o, 0, '1', '0')
                         || ';Reset;'
                         || 'Object;Name=N14;Enabled=1;Reset;'
                         || 'Object;Name=miCottage;Enabled=0;'
                           AS cmd_lines
                    FROM DUAL
                  UNION
                  SELECT 2 AS cmd_id
                        ,   'Object;Name=miRedemp;Visible=1;Reset;'
                         || 'Object;Name=miRefDC;Visible=1;Enabled='
                         || DECODE (r_o, 0, '1', '0')
                         || ';Reset;'
                         || 'Object;Name=miPublishCP;Visible=1;Enabled='
                         || DECODE (r_o, 0, DECODE (dc_num, NULL, '0', '1'), '0')
                         || ';'
                           AS cmd_lines
                    FROM affair
                   WHERE affair_id = a_id AND affair_stage = a_st AND reason = 8 AND delo_category = 26
                  UNION
                  SELECT 3 AS cmd_id, 'Object;Name=miRepMosJilReg;Caption=Ответ из МЖР;' AS cmd_lines FROM DUAL
                  UNION
                  SELECT 3 AS cmd_id, 'Object;Name=N13;Caption=Купля-продажа;' AS cmd_lines
                    FROM affair
                   WHERE affair_id = a_id AND affair_stage = a_st AND reason = 8 AND type2 IN (7, 8) AND department_id = 961 AND factory_id = 4
                  UNION
                  --21.09.21012 Ilonis  в связи с новой формой
                    SELECT 4 AS cmd_id, 'Object;Name=miToMgr2;Enabled=1;Visible='||DECODE(get_user_priv(100),1,1,DECODE(get_user_priv(101),1,1,DECODE(get_user_priv(105),1,1, 0)))||';' AS cmd_lines FROM DUAL
                    UNION                                                                                                                                    
                    SELECT 4.1 AS cmd_id, 'Object;Name=miToMgr;Enabled=1;Visible='||DECODE(get_user_priv(100),1,1,0)||';' AS cmd_lines FROM DUAL
                  UNION
                  SELECT 4.2 AS cmd_id, 'Object;Name=miUFRSInfo;Enabled=1;Visible='||DECODE(get_user_priv(101),1,1,0)||';' AS cmd_lines FROM DUAL
                  UNION
                  SELECT 5 AS cmd_id
                        ,'Object;Name=miPO;Visible=' || DECODE (type2, 5, '1', '0') || ';' || 'Enabled=' || DECODE (affair_stage, 1, '1', '0') || ';'
                           AS cmd_lines
                    FROM affair
                   WHERE affair_id = a_id AND affair_stage = a_st
                  UNION
                  SELECT 6 AS cmd_id, 'Object;Name=miPermitOn;Enabled=0;Visible=0;' AS cmd_line FROM DUAL
                  UNION ALL
                  SELECT 7 AS cmd_id, 'Object;Name=' || menu_text || ';Visible=' || c1 || ';Enabled=' || c1 || ';' AS cmd_line
                    FROM menus
                        ,(SELECT SIGN (COUNT (*)) c1
                            FROM kurs3.affair_ars_person
                           WHERE affair_id = a_id AND affair_stage = a_st) t2
                   WHERE menu_id = 173 AND (kurs3_var.number_version >= 780) AND get_user_priv (63) > 0
                  UNION ALL
                  SELECT 8 AS cmd_id
                        ,   'Object;Name=miReturnToRujp;Enabled='
                         || DECODE (NVL (k3_pkg_affair.get_affair_ext_data_n (aa.affair_id, 3), 0), 0, '0', DECODE (aa.status,  0, '1',  1, '1',  '0'))
                         || ';Visible='
                         || DECODE (NVL (k3_pkg_affair.get_affair_ext_data_n (aa.affair_id, 3), 0), 0, '0', DECODE (aa.status,  0, '1',  1, '1',  '0'))
                         || ';'
                           AS cmd_line
                    FROM affair aa
                   WHERE aa.affair_id = a_id AND aa.affair_stage = a_st
                  UNION ALL
                    SELECT 9 AS cmd_id, 'Object;Name=miDeclDate;Visible=1;Enabled='
                       ||case when kurs3_var.global_department is not null
                                 and kurs3_var.global_factory is not null
                                 and nvl(kurs3_var.global_municipality,0) = 0
                                 AND reason = 8 AND affair_stage = 1 AND status < 5 
                              then '1'
                              else '0'
                         end
                       ||';' AS cmd_lines
                      FROM affair
                     WHERE affair_id = a_id AND affair_stage = a_st          
                     
              --ilonis 17.06.2013  to Dikan                                                                                                                                                        
                  UNION ALL
                  SELECT 16 AS cmd_id, 'Object;Name=miDateDeregitration;Enabled='||DECODE (kurs3_var.direction_id, 97, DECODE (aa.status,  5, '1', '0') ,'0') ||';Reset;' AS cmd_lines  
                   FROM   affair aa   WHERE aa.affair_id = a_id AND aa.affair_stage = a_st
                   UNION ALL
                  SELECT 17 AS cmd_id, 'Object;Name=miDateExportFam;Enabled='||DECODE (kurs3_var.direction_id, 97, DECODE (aa.status,  5, '1', '0') ,'0')||';Reset;' AS cmd_lines   
                   FROM   affair aa   WHERE aa.affair_id = a_id AND aa.affair_stage = a_st
                     
                  UNION ALL
                  SELECT 99 AS cmd_id
                        ,   'Object;Name=N13;Enabled=0;Reset;'
                         || 'Object;Name=N14;Enabled=0;Reset;'
                         || 'Object;Name=N15;Enabled=0;Reset;'
                         || 'Object;Name=miPO;Enabled=0;Reset;'
                         || 'Object;Name=miPublishCP;Enabled=0;Reset;'
                         || 'Object;Name=miErasePlan;Enabled=0;Reset;'
                         || 'Object;Name=miCottage;Enabled=0;'
                           AS cmd_lines
                    FROM kurs3.global_parameters
                   WHERE parameter_name = '#AFFAIR_CRITICAL_CHANGE' AND num_value = 0)
        ORDER BY cmd_id;
    ELSIF kurs3_var.direction_id = 1 THEN -- 1-е направление учета
      SELECT decl_date
        INTO l_decl_date
        FROM kurs3.affair
       WHERE affair_id = a_id AND affair_stage = a_st;

      SELECT type2
        INTO t2
        FROM v_affair_format
       WHERE affair_id = a_id AND affair_stage = a_st;

      cottage_yes_no   := 0;

      FOR rec
        IN (SELECT 1
              FROM kurs3.person_relation_delo prd, kurs3.person_attribute pa
             WHERE     prd.affair_id = a_id
                   AND prd.affair_stage = a_st
                   AND pa.person_id = prd.person_id
                   AND pa.attribute_id IN (12, 13, 14)
                   AND pa.status = 1
                   AND pa.attribute_value IN ('94', '95', '79', '11', '92')) LOOP
        cottage_yes_no   := 1;
      END LOOP;

      IF t2 = 5 THEN
        OPEN qcommand FOR
            SELECT *
              FROM (SELECT 1 AS cmd_id
                          ,   'Object;Name=miRedemp;Visible=0;Reset;'
                           || 'Object;Name=N13;Caption=Подбор жилплощади;Enabled=0;Reset;'
                           || 'Object;Name=miPlan;Enabled='
                           || DECODE (r_o, 0, DECODE (l_decl_date, NULL, '0', '1'), '0')
                           || ';Reset;'
                           || 'Object;Name=N10;Visible=0;Enabled=0;Reset;'
                           || 'Object;Name=N14;Enabled=0;Reset;Object;Name=miRefDC;Visible=0;Enabled=0;Reset;'
                           || 'Object;Name=miSetPersonDocs;Visible=1;Enabled=1;Reset;'
                           || 'Object;Name=miCalcYear;Enabled='
                           || DECODE (r_o, 0, '1', '0')
                           || ';Reset;'
                           || 'Object;Name=miKPU_COURT;Enabled='
                           || DECODE (r_o, 0, '1', '0')
                           || ';Reset;'
                           || 'Object;Name=miPublishCP;Visible=0;Enabled=0;Reset;'
                           || 'Object;Name=miCottage;Enabled='
                           || DECODE (r_o, 0, DECODE (cottage_yes_no, 1, '1', '0'), '0')
                           || ';'
                             AS cmd_lines
                      FROM DUAL
                    UNION ALL
                    SELECT 2 AS cmd_id
                          ,   'Object;Name=miTo_01;Caption='
                           || DECODE (kurs3_var.global_municipality, 1, 'Перевод в Оч.Мун.', 'Перевод в Оч.Пр.')
                           || ';'
                             AS cmd_lines
                      FROM DUAL
                    UNION ALL
                    SELECT 3 AS cmd_id, 'Object;Name=miRepMosJilReg;Caption=Ответ из МЖР;' AS cmd_lines FROM DUAL
                    UNION ALL
                    SELECT 5 AS cmd_id
                          ,   'Object;Name=miPO;Visible='
                           || DECODE (reason, 1, DECODE (type2, 5, '1', '0'), '0')
                           || ';'
                           || DECODE (affair_stage, 1, '1', '0')
                           || ';'
                             AS cmd_lines
                      FROM affair
                     WHERE affair_id = a_id AND affair_stage = a_st
                    UNION ALL
                      --21.09.21012 Ilonis  в связи с новой формой
                     SELECT 6 AS cmd_id, 'Object;Name=miToMgr2;Enabled=1;Visible='||DECODE(get_user_priv(100),1,1,DECODE(get_user_priv(101),1,1,DECODE(get_user_priv(105),1,1, 0)))||';' AS cmd_lines FROM DUAL
                     UNION ALL 
                     SELECT 6.1 AS cmd_id, 'Object;Name=miToMgr;Enabled=1;Visible='||DECODE(get_user_priv(100),1,1,0)||';' AS cmd_lines FROM DUAL
                    UNION ALL     
                    SELECT 6.2 AS cmd_id, 'Object;Name=miUFRSInfo;Enabled=1;Visible='||DECODE(get_user_priv(101),1,1,0)||';' AS cmd_lines FROM DUAL
                    UNION ALL
                    SELECT 7 AS cmd_id, 'Object;Name=miPermitOn;' || 'Visible=0;Enabled=0;' AS cmd_lines
                      FROM affair
                     WHERE affair_id = a_id AND affair_stage = a_st
                    UNION ALL
                    SELECT 7.1 AS cmd_id, 'Object;Name=miSublease;Visible=1;Enabled=1;' AS cmd_lines
                      FROM affair
                     WHERE     affair_id = a_id
                           AND affair_stage = a_st
                           AND reason = 1
                           AND (status < 5
                                OR EXISTS
                                     (SELECT 1
                                        FROM kurs3.orders oo
                                       WHERE oo.affair_id = affair.affair_id AND order_stage = 1 AND cancel_date IS NULL))
                    UNION ALL
                    SELECT 7.1 AS cmd_id, 'Object;Name=miSublease;Visible=0;Enabled=0;' AS cmd_lines
                      FROM affair
                     WHERE     affair_id = a_id
                           AND affair_stage = a_st
                           AND NOT (reason = 1
                                    AND (status < 5
                                         OR EXISTS
                                              (SELECT 1
                                                 FROM kurs3.orders oo
                                                WHERE oo.affair_id = affair.affair_id AND order_stage = 1 AND cancel_date IS NULL)))
                    UNION ALL
                    SELECT 7.9 AS cmd_id, 'Object;Name=' || menu_text || ';Visible=' || c1 || ';Enabled=' || c1 || ';' AS cmd_line
                      FROM menus
                          ,(SELECT SIGN (COUNT (*)) c1
                              FROM kurs3.affair_ars_person
                             WHERE affair_id = a_id AND affair_stage = a_st) t2
                     WHERE menu_id = 173 AND (kurs3_var.number_version >= 780) AND get_user_priv (63) > 0
                    UNION ALL
                    SELECT 8 AS cmd_id, 'Object;Name=miDeclDate;Visible=1;Enabled=' || DECODE (r_o, 0, '1', '0') || ';' AS cmd_lines
                      FROM affair
                     WHERE affair_id = a_id AND affair_stage = a_st AND reason = 1
                           AND (stand_year > 2005
                                OR (stand_year = 2005 AND NVL (decl_date, TO_DATE ('01.01.1900', 'dd.mm.yyyy')) >= TO_DATE ('01.03.2005', 'dd.mm.yyyy')))
                    UNION ALL
                    SELECT 9 AS cmd_id, 'Object;Name=miDeclDate;Visible=1;Enabled=0;' AS cmd_lines
                      FROM affair
                     WHERE affair_id = a_id AND affair_stage = a_st AND reason = 1 AND status > 4
                    UNION ALL
                    SELECT 10 AS cmd_id
                          ,'Object;Name=miDeclDate;Visible=1;Enabled=1;' || DECODE (r_o, 198 /* Дело заблокировано */
                                                                                            , 'Reset;Object;Name=N15;Visible=1;Enabled=1;', '') /* N15 - "Снятие с учета" */
                                                                                                                                               AS cmd_lines
                      FROM kurs3.global_parameters gl
                     WHERE USERENV ('TERMINAL') = UPPER (gl.VALUE) AND gl.parameter_name = 'AFFAIR_DECL_DATE' AND gl.num_value = 1
                    UNION ALL
                    SELECT 11 AS cmd_id
                          ,'Object;Name=miReturnToRujp;Enabled='
                           || DECODE (NVL (k3_pkg_affair.get_affair_ext_data_n (aa.affair_id, 3), 0)
                                     ,0, '0'
                                     ,DECODE (aa.status,  0, '1',  1, '1',  '0')
                                     )
                           || ';Visible='
                           || DECODE (NVL (k3_pkg_affair.get_affair_ext_data_n (aa.affair_id, 3), 0)
                                     ,0, '0'
                                     ,DECODE (aa.status,  0, '1',  1, '1',  '0')
                                     )
                           || ';'
                             AS cmd_line
                      FROM affair aa
                     WHERE aa.affair_id = a_id AND aa.affair_stage = a_st
                    UNION ALL
                    SELECT 12 AS cmd_id, 'Object;Name=Copy_ID;Enabled=1;' AS cmd_lines
                      FROM DUAL
                     WHERE get_user_priv (90) = 1
                    ------ 20.03.2012 AVB малоимущность
                    UNION ALL
                    SELECT 13 AS cmd_id, 'Object;Name=miDocPoor;Visible=1;Enabled='
                           ||case when reason = 1 AND status < 5 AND affair_stage = 1 
                                   AND nvl(DECL_DATE,DELO_DATE) >= to_date('01.03.2005','dd.mm.yyyy')
                              then '1'
                              else '0'
                             end
                           ||';' AS cmd_lines
                      FROM affair
                     WHERE affair_id = a_id AND affair_stage = a_st    
                    ----------  
                  --ilonis 17.06.2013  to Dikan                                                                                                                                                        
                   UNION ALL
                  SELECT 16 AS cmd_id, 'Object;Name=miDateDeregitration;Enabled='||DECODE (kurs3_var.direction_id, 97, DECODE (aa.status,  5, '1', '0') ,'0') ||';Reset;' AS cmd_lines  
                   FROM   affair aa   WHERE aa.affair_id = a_id AND aa.affair_stage = a_st
                   UNION ALL
                  SELECT 17 AS cmd_id, 'Object;Name=miDateExportFam;Enabled='||DECODE (kurs3_var.direction_id, 97, DECODE (aa.status,  5, '1', '0') ,'0')||';Reset;' AS cmd_lines   
                   FROM   affair aa   WHERE aa.affair_id = a_id AND aa.affair_stage = a_st

                    UNION ALL
                    SELECT 99 AS cmd_id
                          ,   'Object;Name=N13;Enabled=0;Reset;'
                           || 'Object;Name=N14;Enabled=0;Reset;'
                           || 'Object;Name=N15;Enabled=0;Reset;'
                           || 'Object;Name=miPO;Enabled=0;Reset;'
                           || 'Object;Name=miPublishCP;Enabled=0;Reset;'
                           || 'Object;Name=miErasePlan;Enabled=0;Reset;'
                           || 'Object;Name=miCottage;Enabled=0;'
                             AS cmd_lines
                      FROM kurs3.global_parameters
                     WHERE parameter_name = '#AFFAIR_CRITICAL_CHANGE' AND num_value = 0)
          ORDER BY cmd_id;
      ELSE
        OPEN qcommand FOR
            SELECT *
              FROM (SELECT 1 AS cmd_id
                          ,   'Object;Name=miRedemp;Visible=0;Reset;'
                           || 'Object;Name=N13;Caption=Подбор жилплощади;Enabled='
                           || DECODE (r_o, 0, DECODE (l_decl_date, NULL, '0', '1'), '0')
                           || ';Reset;'
                           || 'Object;Name=miPlan;Enabled='
                           || DECODE (r_o, 0, DECODE (l_decl_date, NULL, '0', '1'), '0')
                           || ';Reset;'
                           || 'Object;Name=N10;Visible=0;Enabled=0;Reset;'
                           || 'Object;Name=miRefDC;Visible=0;Enabled=0;Reset;'
                           || 'Object;Name=miPublishCP;Visible=0;Enabled=0;Reset;'
                           || 'Object;Name=miSetPersonDocs;Visible=1;Enabled=1;Reset;'
                           || 'Object;Name=miCalcYear;Enabled='
                           || DECODE (r_o, 0, '1', '0')
                           || ';Reset;'
                           || 'Object;Name=miKPU_COURT;Enabled='
                           || DECODE (r_o, 0, '1', '0')
                           || ';Reset;'
                           || 'Object;Name=N14;Enabled=0;Reset;'
                           || 'Object;Name=miCottage;Enabled='
                           || DECODE (r_o, 0, DECODE (cottage_yes_no, 1, '1', '0'), '0')
                           || ';'
                             AS cmd_lines
                      FROM DUAL
                    UNION ALL
                    SELECT 2 AS cmd_id
                          ,   'Object;Name=miTo_01;Caption='
                           || DECODE (kurs3_var.global_municipality, 1, 'Перевод в Оч.Мун.', 'Перевод в Оч.Пр.')
                           || ';'
                             AS cmd_lines
                      FROM DUAL
                    UNION ALL
                    SELECT 3 AS cmd_id, 'Object;Name=miRepMosJilReg;Caption=Ответ из МЖР;' AS cmd_lines FROM DUAL
                    UNION ALL
                    SELECT 5 AS cmd_id
                          ,   'Object;Name=miPO;Visible='
                           || DECODE (reason, 1, DECODE (type2, 5, '1', '0'), '0')
                           || ';'
                           || DECODE (affair_stage, 1, '1', '0')
                           || ';'
                             AS cmd_lines
                      FROM affair
                     WHERE affair_id = a_id AND affair_stage = a_st
                    UNION ALL
                      --21.09.21012 Ilonis  в связи с новой формой
                    SELECT 6 AS cmd_id, 'Object;Name=miToMgr2;Enabled=1;Visible='||DECODE(get_user_priv(100),1,1,DECODE(get_user_priv(101),1,1,DECODE(get_user_priv(105),1,1, 0)))||';' AS cmd_lines FROM DUAL
                    union all
                    SELECT 6.1 AS cmd_id, 'Object;Name=miToMgr;Enabled=1;Visible='||DECODE(get_user_priv(100),1,1,0)||';' AS cmd_lines FROM DUAL
                    UNION ALL         
                    SELECT 6.2 AS cmd_id, 'Object;Name=miUFRSInfo;Enabled=1;Visible='||DECODE(get_user_priv(101),1,1,0)||';' AS cmd_lines FROM DUAL
                    UNION ALL
                    SELECT 7 AS cmd_id, 'Object;Name=miPermitOn;' || 'Visible=0;' || 'Enabled=0;' || 'Reset;'
                      FROM affair
                     WHERE affair_id = a_id AND affair_stage = a_st
                    UNION ALL
                    SELECT 7.1 AS cmd_id, 'Object;Name=miSublease;Visible=1;Enabled=1;' AS cmd_lines
                      FROM affair
                     WHERE     affair_id = a_id
                           AND affair_stage = a_st
                           AND reason = 1
                           AND (status < 5
                                OR EXISTS
                                     (SELECT 1
                                        FROM kurs3.orders oo
                                       WHERE oo.affair_id = affair.affair_id AND order_stage = 1 AND cancel_date IS NULL))
                    UNION ALL
                    SELECT 7.1 AS cmd_id, 'Object;Name=miSublease;Visible=0;Enabled=0;' AS cmd_lines
                      FROM affair
                     WHERE     affair_id = a_id
                           AND affair_stage = a_st
                           AND NOT (reason = 1
                                    AND (status < 5
                                         OR EXISTS
                                              (SELECT 1
                                                 FROM kurs3.orders oo
                                                WHERE oo.affair_id = affair.affair_id AND order_stage = 1 AND cancel_date IS NULL)))
                    UNION ALL
                    SELECT 7.9 AS cmd_id, 'Object;Name=' || menu_text || ';Visible=' || c1 || ';Enabled=' || c1 || ';' AS cmd_line
                      FROM menus
                          ,(SELECT SIGN (COUNT (*)) c1
                              FROM kurs3.affair_ars_person
                             WHERE affair_id = a_id AND affair_stage = a_st) t2
                     WHERE menu_id = 173 AND (kurs3_var.number_version >= 780) AND get_user_priv (63) > 0
                    UNION ALL
                    SELECT 8 AS cmd_id, 'Object;Name=miDeclDate;Visible=1;Enabled=' || DECODE (r_o, 0, '1', '0') || ';' AS cmd_lines
                      FROM affair
                     WHERE affair_id = a_id AND affair_stage = a_st AND reason = 1
                           AND (stand_year > 2005
                                OR (stand_year = 2005 AND NVL (decl_date, TO_DATE ('01.01.1900', 'dd.mm.yyyy')) >= TO_DATE ('01.03.2005', 'dd.mm.yyyy')))
                    UNION ALL
                    SELECT 9 AS cmd_id, 'Object;Name=miDeclDate;Visible=1;Enabled=0;' AS cmd_lines
                      FROM affair
                     WHERE affair_id = a_id AND affair_stage = a_st AND reason = 1 AND status > 4
                    UNION ALL
                    SELECT 10 AS cmd_id
                          ,'Object;Name=miDeclDate;Visible=1;Enabled=1;' || DECODE (r_o, 198 /* Дело заблокировано */
                                                                                            , 'Reset;Object;Name=N15;Visible=1;Enabled=1;', '') /* N15 - "Снятие с учета" */
                                                                                                                                               AS cmd_lines
                      FROM kurs3.global_parameters gl
                     WHERE USERENV ('TERMINAL') = UPPER (gl.VALUE) AND gl.parameter_name = 'AFFAIR_DECL_DATE' AND gl.num_value = 1
                    UNION ALL
                    SELECT 11 AS cmd_id
                          ,'Object;Name=miReturnToRujp;Enabled='
                           || DECODE (NVL (k3_pkg_affair.get_affair_ext_data_n (aa.affair_id, 3), 0)
                                     ,0, '0'
                                     ,DECODE (aa.status,  0, '1',  1, '1',  '0')
                                     )
                           || ';Visible='
                           || DECODE (NVL (k3_pkg_affair.get_affair_ext_data_n (aa.affair_id, 3), 0)
                                     ,0, '0'
                                     ,DECODE (aa.status,  0, '1',  1, '1',  '0')
                                     )
                           || ';'
                             AS cmd_line
                      FROM affair aa
                     WHERE aa.affair_id = a_id AND aa.affair_stage = a_st
                    UNION ALL
                    SELECT 12 AS cmd_id, 'Object;Name=Copy_ID;Enabled=1;' AS cmd_lines
                      FROM DUAL
                     WHERE get_user_priv (90) = 1
                    ------ 20.03.2012 AVB малоимущность
                    UNION ALL
                    SELECT 13 AS cmd_id, 'Object;Name=miDocPoor;Visible=1;Enabled='
                           ||case when reason = 1 AND status < 5 AND affair_stage = 1 
                                   AND nvl(DECL_DATE,DELO_DATE) >= to_date('01.03.2005','dd.mm.yyyy')
                              then '1'
                              else '0'
                             end
                           ||';' AS cmd_lines
                      FROM affair
                     WHERE affair_id = a_id AND affair_stage = a_st   
                     
                   --ilonis 17.06.2013  to Dikan                                                                                                                                                        
                  UNION ALL
                  SELECT 16 AS cmd_id, 'Object;Name=miDateDeregitration;Enabled='||DECODE (kurs3_var.direction_id, 97, DECODE (aa.status,  5, '1', '0') ,'0') ||';Reset;' AS cmd_lines  
                   FROM   affair aa   WHERE aa.affair_id = a_id AND aa.affair_stage = a_st
                   UNION ALL
                  SELECT 17 AS cmd_id, 'Object;Name=miDateExportFam;Enabled='||DECODE (kurs3_var.direction_id, 97, DECODE (aa.status,  5, '1', '0') ,'0')||';Reset;' AS cmd_lines   
                   FROM   affair aa   WHERE aa.affair_id = a_id AND aa.affair_stage = a_st

                    ----------------
                    UNION ALL
                    SELECT 99 AS cmd_id
                          ,   'Object;Name=N13;Enabled=0;Reset;'
                           || 'Object;Name=N14;Enabled=0;Reset;'
                           || 'Object;Name=N15;Enabled=0;Reset;'
                           || 'Object;Name=miPO;Enabled=0;Reset;'
                           || 'Object;Name=miPublishCP;Enabled=0;Reset;'
                           || 'Object;Name=miErasePlan;Enabled=0;Reset;'
                           || 'Object;Name=miCottage;Enabled=0;'
                             AS cmd_lines
                      FROM kurs3.global_parameters
                     WHERE parameter_name = '#AFFAIR_CRITICAL_CHANGE' AND num_value = 0)
          ORDER BY cmd_id;
      END IF;
    ELSE
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id
                        ,   'Object;Name=miRedemp;Visible=0;Reset;'
                         || 'Object;Name=miRefDC;Visible=0;Enabled=0;Reset;'
                         || 'Object;Name=miPublishCP;Visible=0;Enabled=0;Reset;'
                         || 'Object;Name=N10;Visible=0;Enabled=0;Reset;'
                         || 'Object;Name=miErasePlan;Visible=0;Enabled=0;Reset;'
                         || 'Object;Name=miCottage;Enabled=0;Reset;'
                         ------------------------- 1.09.2008 Anissimova - проверка 21 направления учета - пункт меню Данные агентства ------------
                         --                            || 'Object;Name=miSetPersonDocs;Visible=1;Enabled=1;Reset;'
                         || 'Object;Name=miSetPersonDocs;Visible=1;Enabled='
                         || DECODE (kurs3_var.direction_id, 21, '0', '1')
                         || ';Reset;'
                         ---------------------------------------------------------------------------------------------
                         ------------------------- 10.09.2008 Anissimova - изменение вида обеспечения для 21 н/у
                         || 'Object;Name=N6;Visible='
                         || DECODE (kurs3_var.direction_id, 21, '0', '1')
                         || ';Enabled='
                         || DECODE (kurs3_var.direction_id, 21, '0', '1')
                         || ';Reset;'
                         ---------------------------------------------------------------------------------------------
                         || 'Object;Name=miKPU_COURT;Enabled='
                         || DECODE (r_o, 0, '1', '0')
                         || ';Reset;'
                         || 'Object;Name=N1;Visible=1;Enabled='
                         || c
                         || ';Reset;'
                         || 'Object;Name=N14;Enabled='
                         ------------------------- 1.09.2008 Anissimova - проверка 21 направления учета - пункт меню Закрепление -------------
                         --                          || c
                         || DECODE (kurs3_var.direction_id, 21, '0', c)
                         --------------------------------------------------------------------------------------------
                         || ';'
                           AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 2 AS cmd_id
                        ,   'Object;Name=miTo_01;Caption='
                         || DECODE (kurs3_var.global_municipality, 1, 'Перевод в Оч.Мун.', 'Перевод в Оч.Пр.')
                         || ';'
                           AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 3 AS cmd_id, 'Object;Name=miRepMosJilReg;Caption=Ответ из МЖР;' AS cmd_lines FROM DUAL
                  UNION ALL
                   --21.09.21012 Ilonis  в связи с новой формой
                  SELECT 4 AS cmd_id, 'Object;Name=miToMgr2;Enabled=1;Visible='||DECODE(get_user_priv(100),1,1,DECODE(get_user_priv(101),1,1,DECODE(get_user_priv(105),1,1, 0)))||';' AS cmd_lines FROM DUAL
                  union all
                  SELECT 4.1 AS cmd_id, 'Object;Name=miToMgr;Enabled=1;Visible='||DECODE(get_user_priv(100),1,1,0)||';' AS cmd_lines FROM DUAL
                  UNION ALL
                  SELECT 4.2 AS cmd_id, 'Object;Name=miUFRSInfo;Enabled=1;Visible='||DECODE(get_user_priv(101),1,1,0)||';' AS cmd_lines FROM DUAL
                  UNION ALL
                  SELECT 5 AS cmd_id
                        ,   'Object;Name=miPermitOn;Visible='
                         || DECODE (get_user_unique_id (kurs3_var.get_user_id_f), 11, '1', '0')
                         || ';Enabled='
                         || DECODE (get_user_unique_id (kurs3_var.get_user_id_f), 11, '1', '0')
                         || ';'
                           AS cmd_lines
                    FROM affair
                   WHERE affair_id = a_id AND affair_stage = a_st AND reason = 1
                  UNION ALL
                  SELECT 6 AS cmd_id, 'Object;Name=miPermit1983On;Visible=1' --              || DECODE(get_user_unique_id(kurs3_var.get_user_id_f), 11, '1', '0')
                                                                            || ';Enabled=1' --              || DECODE(get_user_unique_id(kurs3_var.get_user_id_f), 11, '1', '0')
                                                                                           || ';' AS cmd_lines
                    FROM affair
                   WHERE affair_id = a_id AND affair_stage = a_st AND reason = 1
                  UNION ALL
                  SELECT 7 AS cmd_id, 'Object;Name=' || menu_text || ';Enabled=' || c1 || ';' AS cmd_line
                    FROM menus
                        ,(SELECT COUNT (*) c1
                            FROM kurs3.affair_ars_person
                           WHERE affair_id = a_id AND affair_stage = a_st) t2
                   WHERE menu_id = 173 AND (kurs3_var.number_version >= 780) AND get_user_priv (63) > 0
                  UNION ALL
                  SELECT 9 AS cmd_id, 'Object;Name=miDeclDate;Visible=1;Enabled=1;' AS cmd_lines
                    FROM kurs3.global_parameters gl
                   WHERE USERENV ('TERMINAL') = UPPER (gl.VALUE) AND gl.parameter_name = 'AFFAIR_DECL_DATE' AND gl.num_value = 1
                  UNION ALL
                  ---------------- 10.02.2009 Anissimova - Ввод номера и даты протокола ГЖК для 21 н/у   
                  --12.12.2012 Ilonis добавил привилегию 110
                  SELECT 11 AS cmd_id, 'Object;Name=miGGhK;Visible=1;'
                   --||'Enabled=' || DECODE (dc_date, NULL, 1, 0) || ';Reset;' AS cmd_lines
                   ||'Enabled=' || case when ((get_user_priv(110)=1) and (kurs3_var.direction_id = 21) ) then 1 else 0 end||';Reset;' AS cmd_lines
                    FROM affair
                   WHERE affair_id = a_id AND affair_stage = a_st AND reason = 21
                  UNION ALL
                  --------------------------------------------------------------------------------------
                  ---------------- 10.09.2008 Anissimova - Изменение вида обеспечения для 21 н/у
                  SELECT 12 AS cmd_id, 'Object;Name=miType2;Visible=1;Enabled=1; Reset;' || 'Object;Name=miDeclDate;Visible=1;Enabled=1;' AS cmd_lines
                    FROM affair
                   WHERE affair_id = a_id AND affair_stage = a_st AND reason = 21
                  UNION ALL
                  --------------------------------------------------------------------------------------
                  SELECT 13.1 AS cmd_id, 'Object;Name=miSetFraud;Visible=1;Enabled=1;' AS cmd_lines
                    FROM affair
                   WHERE affair_id = a_id AND affair_stage = a_st AND delo_category = 13 AND reason = 7 AND type2 = 17
                  UNION ALL
                  SELECT 13.1 AS cmd_id, 'Object;Name=miSetFraud;Visible=0;Enabled=0;' AS cmd_lines
                    FROM affair
                   WHERE affair_id = a_id AND affair_stage = a_st AND NOT (delo_category = 13 AND reason = 7 AND type2 = 17)
                  UNION ALL
                  SELECT 14 AS cmd_id
                        ,   'Object;Name=miReturnToRujp;Enabled='
                         || DECODE (NVL (k3_pkg_affair.get_affair_ext_data_n (aa.affair_id, 3), 0), 0, '0', DECODE (aa.status,  0, '1',  1, '1',  '0'))
                         || ';Visible='
                         || DECODE (NVL (k3_pkg_affair.get_affair_ext_data_n (aa.affair_id, 3), 0), 0, '0', DECODE (aa.status,  0, '1',  1, '1',  '0'))
                         || ';'
                           AS cmd_line
                    FROM affair aa
                   WHERE aa.affair_id = a_id AND aa.affair_stage = a_st
                  UNION ALL
                  SELECT 15 AS cmd_id, 'Object;Name=Copy_ID;Enabled=1;' AS cmd_lines   FROM DUAL   WHERE get_user_priv (90) = 1          
                  
                  --ilonis 17.06.2013  to Dikan                                                                                                                                                        
                  UNION ALL
                  SELECT 16 AS cmd_id, 'Object;Name=miDateDeregitration;Enabled='||DECODE (kurs3_var.direction_id, 97, DECODE (aa.status,  5, '1', '0') ,'0') ||';Reset;' AS cmd_lines  
                   FROM   affair aa   WHERE aa.affair_id = a_id AND aa.affair_stage = a_st
                   UNION ALL
                  SELECT 17 AS cmd_id, 'Object;Name=miDateExportFam;Enabled='||DECODE (kurs3_var.direction_id, 97, DECODE (aa.status,  5, '1', '0') ,'0')||';Reset;' AS cmd_lines   
                   FROM   affair aa   WHERE aa.affair_id = a_id AND aa.affair_stage = a_st
                  
                  UNION ALL
                  SELECT 99 AS cmd_id
                        ,   'Object;Name=N13;Enabled=0;Reset;'
                         || 'Object;Name=N14;Enabled=0;Reset;'
                         || 'Object;Name=N15;Enabled=0;Reset;'
                         || 'Object;Name=miPO;Enabled=0;Reset;'
                         || 'Object;Name=miPublishCP;Enabled=0;Reset;'
                         || 'Object;Name=miErasePlan;Enabled=0;Reset;'
                         || 'Object;Name=miCottage;Enabled=0;'
                           AS cmd_lines
                    FROM kurs3.global_parameters
                   WHERE parameter_name = '#AFFAIR_CRITICAL_CHANGE' AND num_value = 0)
        ORDER BY cmd_id;
    END IF;
  --------------------------------------------------------------------------
  ELSIF form_event = 'MenuCommandAction' THEN
    SELECT UPPER (active_menus.menu_text)
      INTO c1
      FROM active_menus, all_kurs_objects ako
     WHERE     active_menus.session_id = USERENV ('SESSIONID')
           AND active_menus.menu_handle = do_for_taffair.form_handle
           AND active_menus.parent_id = p_f_h
           AND ako.window_handle = active_menus.parent_id
           AND ako.session_id = active_menus.session_id
           AND ako.screen_type = 106 /* TAffair */
           AND ROWNUM = 1;

    IF c1 = 'MIPERMITON' THEN
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id
                        ,   'CreateObject;ClassName=TfrmChildNormal;Name=frmPermit;Caption=Согласование;'
                         || 'Width=200;Height='
                         || TO_CHAR ( (COUNT (*) - 1) * 20 + 120)
                         || ';Owner=Self;Tag='
                         || p_f_h
                         || ';RetProp=Tag;'
                           AS cmd_lines
                    FROM classifier
                   WHERE classifier_num = 72 AND deleted = 0 AND row_status = 1
                  UNION ALL
                  SELECT 2 + ROWNUM AS cmd_lines
                        ,'Object;Name=frmPermit.cb' || row_num || ';Checked=' || get_affair_permit (a_id, a_st, row_num) || ';' AS cmd_line
                    FROM classifier
                   WHERE classifier_num = 72 AND deleted = 0 AND row_status = 1
                  UNION ALL
                  SELECT 98 AS cmd_id, 'Object;Name=frmPermit;ShowModal=1;Free=;' AS cmd_lines FROM DUAL
                  UNION ALL
                  SELECT 99 AS cmd_id, 'DoCommand;PostMessage;Handle=' || p_f_h || ';Message=1029;WParam=0;LParam=0;' AS cmd_lines FROM DUAL)
        ORDER BY cmd_id;
    ELSIF c1 = 'MIDECLDATE' THEN
      do_for_tdeclaration (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
    ---- 10.09.2008 Anissimova - обработка "Вид обеспечения" для 21 н/у
    ELSIF c1 = 'MITYPE2' THEN
      do_for_ttype2 (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
    ---- 10.09.2008 Anissimova - обработка "Номер и дата решения ГЖК" для 21 н/у
    ELSIF c1 = 'MIGGHK' THEN
      do_for_frmggk21 (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
    ------------------------------------------------------------------------
    ELSIF c1 = 'MISUBLEASE' THEN
      do_for_af_sublease (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
    ------------------------------------------------------------------------
    ELSIF c1 = 'MISETFRAUD' THEN
      do_for_af_fraud (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
    ------------------------------------------------------------------------
    ELSIF c1 = 'MICALCYEAR' THEN
      SELECT NVL (calc_year, stand_year), NVL (calc_reason, 0)
        INTO c_year, c_reason
        FROM kurs3.affair
       WHERE affair_id = a_id AND affair_stage = a_st;

      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id
                        ,   'CreateObject;ClassName=TfrmChildNormal;Name=frmCalcYear;Caption=Учетно-плановый год;'
                         || 'Width=300;Height=130;Owner=Self;Tag='
                         || a_id
                         || ';RetProp=Tag;'
                           AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 2 AS cmd_id
                        ,'CreateObject;ClassName=TLabel;Owner=frmCalcYear;Parent=frmCalcYear;Name=lbyear;Left=5;Top=15;Width=30;Caption=Год:;Font.Style=[];Reset;'
                         || 'CreateObject;ClassName=TEdit;Owner=frmCalcYear;Parent=frmCalcYear;Name=edyear;MaxLength=4;Width=40;Left=40;Top=10;Text='
                         || c_year
                         || ';RetProp=Text;Reset;'
                         || 'CreateObject;ClassName=TLabel;Owner=frmCalcYear;Parent=frmCalcYear;Name=lbreason;Left=90;Top=15;Width=30;Caption=Причина:;Font.Style=[];'
                           AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 3 AS cmd_id, 'CreateObject;ClassName=TOraQuery;Owner=frmCalcYear;Parent=frmCalcYear;Name=qResNames;SQL=;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 4 AS cmd_id, 'SELECT row_num ID, NAME FROM KURS3.CLASSIFIER_KURS3 where classifier_num = 114 order by row_num' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 5 AS cmd_id, 'EndSQL;Active=1;' AS cmd_lines FROM DUAL
                  UNION ALL
                  SELECT 6 AS cmd_id
                        ,   'CreateObject;ClassName=TDataSource;Owner=frmCalcYear;Parent=frmCalcYear;Name=dsResNames;DataSet=qResNames;Reset;'
                         || 'CreateObject;ClassName=TRxDBLookupCombo;Owner=frmCalcYear;Parent=frmCalcYear;Name=Combo_reason;Left=160;Top=10;Width=130;'
                         || 'LookupSource=dsResNames;LookupField=ID;LookupDisplay=NAME;'
                         || 'KeyValue='
                         || c_reason
                         || ';RetProp=KeyValue;'
                         || 'Enabled=1;Font.Style=[];Event=OnChange;'
                           AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 7 AS cmd_id
                        ,   'CreateObject;ClassName=TBitBtn;Owner=frmCalcYear;Name=btnOk;Parent=frmCalcYear;Kind=4;Caption=Сохранить;'
                         || 'Top=60;Left=20;Width=95;Event=OnClick;Reset;'
                         || 'CreateObject;ClassName=TBitBtn;Owner=frmCalcYear;Name=btnCancel;Parent=frmCalcYear;Kind=2;Caption=Отмена;'
                         || 'Top=60;Left=190;Width=80;'
                           AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 90 AS cmd_id, 'Object;Name=frmCalcYear;ShowModal=1;Free=;' AS cmd_lines FROM DUAL
                  UNION ALL
                  SELECT 99 AS cmd_id
                        ,'DoCommand;PostMessage;Handle=' || get_id_param ('PARENTFORMHANDLE', out_props) || ';Message=1029;WParam=0;LParam=0;'
                           AS cmd_lines
                    FROM DUAL)
        ORDER BY cmd_id;
    ELSIF UPPER (c1) = 'MIKPU_COURT' THEN
      SELECT NVL (MIN (gp.num_value), 0)
        INTO can_del -- 0 - нет / 1 - да
        FROM kurs3.global_parameters gp
       WHERE gp.parameter_name = 'DELETE_KPU_COURT' AND gp.VALUE = USERENV ('TERMINAL');

      SELECT COUNT (*)
        INTO nn
        FROM kurs3.affair_court af_c
       WHERE af_c.affair_id = a_id AND af_c.affair_stage = a_st;

      IF nn = 1 THEN
        SELECT af_c.decree_num, af_c.decree_date
          INTO num_, date_
          FROM kurs3.affair_court af_c
         WHERE af_c.affair_id = a_id AND af_c.affair_stage = a_st;
      ELSIF nn > 1 THEN
        -- SENDMESSAGE('ERROR!! По одному КПУ несколько решений суда!!')
        SELECT af_c.decree_num, af_c.decree_date
          INTO num_, date_
          FROM kurs3.affair_court af_c
         WHERE af_c.affair_id = a_id AND af_c.affair_stage = a_st AND ROWNUM = 1;
      END IF;

      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id
                        ,'CreateObject;ClassName=TfrmChildNormal;Owner=Self;Name=frmKPU_COURT;Caption=Ввод номера и даты решения суда;'
                         || 'Width=385;Height=120;Tag='
                         || a_id
                         || ';RetProp=Tag;'
                           AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 2 AS cmd_id
                        ,   'CreateObject;ClassName=TLabel;Owner=frmKPU_COURT;Parent=frmKPU_COURT;Name=Label1;Left=10;Top=10;Caption=Номер;'
                         || 'Reset;CreateObject;ClassName=TEdit;Owner=frmKPU_COURT;Parent=frmKPU_COURT;Name=edNum2;Text='
                         || DECODE (NVL (num_, 0), 0, '', num_)
                         || ';RetProp=Text;MaxLength=10;Left=60;Top=10;'
                         || 'Reset;CreateObject;ClassName=TLabel;Owner=frmKPU_COURT;Parent=frmKPU_COURT;Name=Label2;Left=200;Top=10;Caption=Дата;'
                         || 'Reset;CreateObject;ClassName=TDateEdit;Owner=frmKPU_COURT;Parent=frmKPU_COURT;Name=date2;Text='
                         || DECODE (NVL (TO_NUMBER (TO_CHAR (date_, 'yyyy')), 1900), 1900, '', TO_CHAR (date_, 'dd.mm.yyyy'))
                         || ';RetProp=Text;Left=240;Top=10;Width=110;'
                         || 'Reset;CreateObject;ClassName=TBitBtn;Owner=frmKPU_COURT;Name=btnDelete;Parent=frmKPU_COURT;Kind=2;Caption=Удалить;Cancel=0;'
                         || 'Top=50;Left=10;Width=110;Event=OnClick;Visible='
                         || DECODE (can_del, 1, '1', '0')
                         || ';'
                         || 'Reset;CreateObject;ClassName=TBitBtn;Owner=frmKPU_COURT;Name=btnSave;Parent=frmKPU_COURT;Kind=1;Caption=Сохранить;'
                         || 'Top=50;Left=140;Width=110;Event=OnClick;'
                         || 'Reset;CreateObject;ClassName=TBitBtn;Owner=frmKPU_COURT;Name=btnCancel;Parent=frmKPU_COURT;Kind=6;Caption=Выход;Cancel=1;'
                         || 'Top=50;Left=270;Width=100;' --ModalResult=?;'+
                           AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 3 AS cmd_id, 'Object;Name=frmKPU_COURT;ShowModal=1;Free=;' AS cmd_lines FROM DUAL
                  UNION ALL
                  SELECT 99 AS cmd_id
                        ,'DoCommand;PostMessage;Handle=' || get_id_param ('PARENTFORMHANDLE', out_props) || ';Message=1029;WParam=0;LParam=0;'
                           AS cmd_lines
                    FROM DUAL)
        ORDER BY cmd_id;
    ELSIF c1 = 'MISETPERSONDOCS' THEN
      do_for_tfrmchildnormal (form_class_name
                             ,form_name => 'frmSetPersonDocs'
                             ,form_handle => form_handle
                             ,form_event => 'ToCreate'
                             ,out_props => out_props
                             ,qcommand => qcommand
                             );
    ELSIF c1 = 'MIDOPPASP' THEN
      do_for_frm_doppasp (form_class_name
                         ,form_name => 'frmdoppasp'
                         ,form_handle => form_handle
                         ,form_event => 'ToCreate'
                         ,out_props => out_props
                         ,qcommand => qcommand
                         );
    ELSIF c1 = 'MICOTTAGE' THEN
      do_for_frm_cottage (form_class_name
                         ,form_name => 'frmcottage'
                         ,form_handle => form_handle
                         ,form_event => 'ToCreate'
                         ,out_props => out_props
                         ,qcommand => qcommand
                         );
    ELSIF c1 = 'MIPERMIT1983ON' THEN
      a   := UPPER (out_props);
      b   := 'TAFFAIR.AFFAIR_ID=';

      SELECT SUBSTR (a, INSTR (a, b) + LENGTH (b), INSTR (SUBSTR (a, INSTR (a, b)), ';') - LENGTH (b) - 1) INTO c FROM DUAL;

      IF c IS NOT NULL THEN
        upd_permition_1 (TO_NUMBER (c));

        OPEN qcommand FOR
          SELECT *
            FROM (SELECT 30 AS cmd_id
                        ,'DoCommand;PostMessage;Handle=' || get_id_param ('PARENTFORMHANDLE', out_props) || ';Message=1029;WParam=0;LParam=0;'
                           AS cmd_lines
                    FROM DUAL --       WHERE
                              --           form_class_name='TAffair'
                              --        SELECT 1 AS cmd_id, 'Object;Name=Taffair;TAffair.Affair_id='||c||';' AS cmd_lines
                              --          FROM DUAL
                 );
      ELSE
        exec_do_prc ('kursiv.do_for_default', form_class_name, form_name, form_handle, form_event, out_props, qcommand);
      END IF;
    ------------------------------------------------------------------------
    ELSIF c1 = 'MIRETURNTORUJP' THEN
      FOR rec IN (SELECT affair_id, data_n AS rup_id
                    FROM kurs3.affair_ext_data aed
                   WHERE     aed.data_type_id = 3
                         AND aed.affair_id = do_for_taffair.a_id
                         AND NOT EXISTS
                               (SELECT 1
                                  FROM kurs3.affair aa
                                 WHERE aa.affair_id = aed.affair_id AND aa.affair_stage = 1 AND aa.status = 6)) LOOP
        DELETE FROM kurs3.affair_plan
              WHERE affair_id = rec.affair_id;

        DELETE FROM kurs3.affair
              WHERE affair_id = rec.affair_id;

        rup2_kurs4_exchange.k4_rup_callback (rec.rup_id);
        COMMIT;
      END LOOP;

      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 99 AS cmd_id, 'DoCommand;PostMessage;Handle=' || p_f_h || ';Message=16;' AS cmd_lines FROM DUAL)
        ORDER BY cmd_id;
    ------------------------------------------------------------------------
/*    ELSIF c1 = 'MISENDTOEIRC' THEN
      k3_pkg_eirc.c#silent_work   := 0;
      k3_pkg_eirc.send_affair2eirc (affair_id => a_id, affair_stage => a_st);

      OPEN qcommand FOR
        SELECT 1 AS cmd_id
              ,'CreateObject;ClassName=TFrmChildNormal;Owner=Self;Name=FrmMsg;'
               || 'Caption=Сообщение;BorderIcons=[biSystemMenu];BorderStyle=3;Width=315;Height=120;'
                 AS cmd_lines
          FROM DUAL
        UNION ALL
        SELECT 2 AS cmd_id
              ,   'CreateObject;ClassName=TLabel;Owner=FrmMsg;Parent=FrmMsg;Name=lblMsg;'
               || 'Font.Style=[fsBold];Alignment=2;WordWrap=1;Top=15;Left=10;Width=310;Height=33;'
               || 'Caption='
               || 'Ваш запрос успешно отправлен в АИС "ЕИРЦ".'
               || ';'
                 AS cmd_lines
          FROM DUAL
        UNION ALL
        SELECT 3 AS cmd_id
              ,'CreateObject;ClassName=TBitBtn;Owner=FrmMsg;Parent=FrmMsg;Name=btnCancel;'
               || 'Kind=2;Left=103;Top=50;Width=107;Height=25;Cancel=1;Caption=Закрыть;'
                 AS cmd_lines
          FROM DUAL
        UNION ALL
        SELECT 4 AS cmd_id, 'Window;Name=FrmMsg;ShowModal=1;Free=;' AS cmd_lines FROM DUAL;
*/
    --------- 20.03.2012 AVB малоимущность --------------
    ELSIF c1 = 'MIDOCPOOR' THEN
      do_for_frmDocPoor (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
    ------------------------------------------------------------------------
    ELSE
      exec_do_prc ('kursiv.do_for_default', form_class_name, form_name, form_handle, form_event, out_props, qcommand);
    END IF;
  -----------------------------------------------------------------------
  ELSE
    exec_do_prc ('kursiv.do_for_default', form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  END IF;
END;
/
