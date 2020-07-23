CREATE OR REPLACE PROCEDURE KURSIV.do_for_tkurslists (
  form_class_name IN     VARCHAR2
 ,form_name       IN     VARCHAR2
 ,form_handle     IN     NUMBER
 ,form_event      IN     VARCHAR2
 ,out_props       IN     VARCHAR2
 ,qcommand        IN OUT pckg_tree.curstype
) IS
  l_c       NUMBER;
  l_n       NUMBER;
  nn        NUMBER;
  i1        NUMBER;
  st1       NUMBER;
  st2       NUMBER;
  temp1     NUMBER;
  temp2     NUMBER;
  nbc       NUMBER;
  cp_num1   NUMBER;
  u_l_n     VARCHAR2 (200);
  menu_name VARCHAR2 (200);
  obj_name  VARCHAR2 (100);
  m_n       VARCHAR2 (200);
  a         VARCHAR2 (2000);
  b         VARCHAR2 (2000);
  c         VARCHAR2 (2000);
  l_name	VARCHAR2(200);
  l_name1	VARCHAR2(200);
--
--  15.12.2002  PVTar      Добавил пункт меню для снятия ОПД
--  28.04.2006  BlackHawk  Добавлен пункт меню "Гор. программа" для списка ж/п
--  19.07.2006  avl        Изменил анализ поля keyValue для гор. программм - убрал обработку, если присылается "0", а не только null
--  23.01.2007  BlackHawk  Добавил отработку глобального параметра CAN_CREATE_INSTRUCTION
--  01.12.2008  AVL        Добавил блокировку переноса в состояние Курс-3 для изданных не в тек. месяце
--  17.08.2009  Frolov 	   Добавил установку Caption у форм при вызове с form_event = SET_ID, сделано потому, что реализована загрузка списков у временных пользователей
--						   только при вызове, а установка caption формы прописана в клиентской программе (uLists, Tools). Для списков которые обрабатываются по умолчанию не реализовано.
-- 						   т.к. требует прояснения у паши =)
--  23.04.2010  AVL        По письму УИТ-61/2010 доработал вывод 64 списка    
-- 12.11.2012   ilonis    причина незаселения
-- 24.12.2012   ilonis    технический паспорт
--
BEGIN

  	 if (UPPER(kurs3_var.product_name) = 'ARMREESTR') then
   	 	do_for_rdn_lists(form_class_name, form_name, form_handle, form_event, out_props, qcommand);
	  	return;
     end if;

  l_n := get_id_param ('LIST_NUM', out_props);
  b := 'USER_LST_NAME=';

  SELECT SUBSTR (SUBSTR (a, INSTR (a, b) + LENGTH (b), INSTR (SUBSTR (a, INSTR (a, b)), ';') - LENGTH (b) - 1), 1, 200)
    INTO u_l_n
    FROM DUAL;

  l_c := get_id_param ('LIST_CODE', out_props);
  obj_name := get_id_param_char ('ObjName', out_props);

  --------- Команды для списков центра -----------------------------------------------------------------
  IF     (   form_event IN ('Center_')
          OR form_class_name IN ('TListsCenterGroupBuild')
          OR (form_class_name = 'TListsExplic' AND form_event <> 'FormCreate')
         )
     AND (obj_name NOT IN ('MIBUF2CONST', 'MIDELEXPL')) THEN
    do_for_default (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
--------------------------------------------------------------------------
  ELSIF form_event = 'SET_ID' THEN
--   DELETE FROM TEST;
-- INSERT INTO TEST VALUES(form_class_name,l_c);
-- COMMIT;
    UPDATE all_kurs_objects
       SET inf_id = l_c
          ,inf_type = l_n
     WHERE session_id = USERENV ('SESSIONID') AND window_handle = form_handle;

    COMMIT;
	
    BEGIN
  	  SELECT
	    lt.LIST_NAME, lnames.list_name
	   INTO
	     l_name, l_name1 
	   FROM
	     kurs3.LIST_TYPES lt, kurs3.lists_names lnames
	  WHERE lt.LIST_COD = l_c
	    AND lt.list_cod = lnames.list_cod
		AND lnames.list_num = l_n
		AND lnames.user_id = kurs3_var.get_user_id_f;
	exception
	  when no_data_found THEN 
	    l_name := 'Список';
	    l_name1 := 'Основной список';
	END;	

    IF l_c = 3 THEN
      OPEN qcommand FOR
        SELECT   *
            FROM (SELECT 1 AS cmd_id
                        ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miToDecree;Action=aTempToSRecDo;'
                          || 'Caption=Передача распоряжением;ItemsAdd=PopupMenu1;Visible=1;Enabled=1;MenuIndex=0;' AS cmd_lines
                    FROM active_menus, active_sessions
                   WHERE active_menus.session_id(+) = active_sessions.session_id
                     AND active_sessions.session_id = USERENV ('SESSIONID')
                     AND 0 =
                           (SELECT COUNT (active_menus.menu_handle)
                              FROM active_menus
                             WHERE active_menus.session_id = USERENV ('SESSIONID')
                               AND active_menus.parent_id = do_for_tkurslists.form_handle
                               AND active_menus.menu_text = 'miToDecree')
                     AND kurs3_var.plan_priv = 1
                     AND get_global_param_num_value ('CAN_CREATE_INSTRUCTION') = 1
                     AND ROWNUM = 1
                  UNION ALL
                  SELECT 2 AS cmd_id
                        ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSetInspector;Action=aSetInspector;'
                          || 'Caption=Закрепить за инспектором;ItemsAdd=PopupMenu1;Visible=1;Enabled=1;MenuIndex=1;' AS cmd_lines
                    FROM active_menus, active_sessions
                   WHERE active_menus.session_id(+) = active_sessions.session_id
                     AND active_sessions.session_id = USERENV ('SESSIONID')
                     AND 0 =
                           (SELECT COUNT (active_menus.menu_handle)
                              FROM active_menus
                             WHERE active_menus.session_id = USERENV ('SESSIONID')
                               AND active_menus.parent_id = do_for_tkurslists.form_handle
                               AND active_menus.menu_text = 'miSetInspector')
                     AND kurs3_var.plan_priv = 1
                     AND ROWNUM = 1
                  UNION ALL
                  SELECT 3 AS cmd_id
                        ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miChangeApart;Action=aChangeApart;'
                          || 'ItemsAdd=PopupMenu1;' AS cmd_lines
                    FROM active_menus, active_sessions
                   WHERE active_menus.session_id(+) = active_sessions.session_id
                     AND active_sessions.session_id = USERENV ('SESSIONID')
                     AND 0 =
                           (SELECT COUNT (active_menus.menu_handle)
                              FROM active_menus
                             WHERE active_menus.session_id = USERENV ('SESSIONID')
                               AND active_menus.parent_id = do_for_tkurslists.form_handle
                               AND active_menus.menu_text = 'miChangeApart')
                     AND NVL (kurs3_var.plan_priv, 0) <> 1
                     AND ROWNUM = 1
                  UNION ALL
                  SELECT 4 AS cmd_id
                        ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSetCityProg;CopyAction=aTempToSRecDo;'
                          || 'Caption=Закрепить за гор/прог.;ItemsAdd=PopupMenu1;Visible=1;Enabled=1;' AS cmd_lines
                    FROM active_menus, active_sessions
                   WHERE active_menus.session_id(+) = active_sessions.session_id
                     AND active_sessions.session_id = USERENV ('SESSIONID')
                     AND 0 =
                           (SELECT COUNT (active_menus.menu_handle)
                              FROM active_menus
                             WHERE active_menus.session_id = USERENV ('SESSIONID')
                               AND active_menus.parent_id = do_for_tkurslists.form_handle
                               AND active_menus.menu_text = 'miSetCityProg')
                     AND kurs3_var.plan_priv = 1
                     AND NOT EXISTS (SELECT 1
                                       FROM kurs3.global_parameters
                                      WHERE parameter_name = '#SET_FREESPACE_CITY_PROG' AND num_value = 0)
                     AND ROWNUM = 1
                  UNION ALL
                  SELECT 5 AS cmd_id
                        ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miCreateAdvice;CopyAction=aTempToSRecDo;'
                          || 'Caption=Уведомление о закреплении;ItemsAdd=PopupMenu1;Visible=1;Enabled=1;' AS cmd_lines
                    FROM DUAL
                   WHERE 0 =
                           (SELECT COUNT (active_menus.menu_handle)
                              FROM active_menus
                             WHERE active_menus.session_id = USERENV ('SESSIONID')
                               AND active_menus.parent_id = do_for_tkurslists.form_handle
                               AND active_menus.menu_text = 'miCreateAdvice')
                     AND get_user_unique_id (kurs3_var.get_user_id_f) = 782   -- MGCAG
                  UNION ALL
                  SELECT 6 AS cmd_id
                        ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSelfTrapping;CopyAction=aTempToSRecDo;'
                          || 'Caption=Самозахват;ItemsAdd=PopupMenu1;Visible='||DECODE(get_user_priv(106),1,1,0)||';;Enabled=1;' AS cmd_lines
                    FROM active_menus, active_sessions
                   WHERE active_menus.session_id(+) = active_sessions.session_id
                     AND active_sessions.session_id = USERENV ('SESSIONID')
                     AND 0 =
                           (SELECT COUNT (active_menus.menu_handle)
                              FROM active_menus
                             WHERE active_menus.session_id = USERENV ('SESSIONID')
                               AND active_menus.parent_id = do_for_tkurslists.form_handle
                               AND active_menus.menu_text = 'miSelfTrapping')
                     AND kurs3_var.plan_priv = 1
                     AND ROWNUM = 1   
             --ilonis  12.11.2012     причина незаселения 
              UNION ALL
                  SELECT 8 AS cmd_id
                        ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miReasonUnpopulated;Action=aReasonUnpopulated;'
                          || 'Caption=Причина незаселения;ItemsAdd=PopupMenu1;Visible='||DECODE(get_user_priv(109),1,1,0)||';Enabled=1;' AS cmd_lines
                    FROM active_menus, active_sessions
                   WHERE active_menus.session_id(+) = active_sessions.session_id
                     AND active_sessions.session_id = USERENV ('SESSIONID')
                     AND 0 =
                           (SELECT COUNT (active_menus.menu_handle)
                              FROM active_menus
                             WHERE active_menus.session_id = USERENV ('SESSIONID')
                               AND active_menus.parent_id = do_for_tkurslists.form_handle
                               AND active_menus.menu_text = 'miReasonUnpopulated')  
                              AND kurs3_var.plan_priv = 1   
                   -- AND ( ( select get_user_priv(109) from dual )>0) --привилегия
                     AND ROWNUM = 1    
             --ilonis  24.12.2012     передача технического паспорта 
              UNION ALL
                  SELECT 9 AS cmd_id
                        ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miPasportTrafficAdd;Action=aPasportTrafficAdd;'
                          || 'Caption=Технический паспорт;ItemsAdd=PopupMenu1;Visible='||DECODE(get_user_priv(113),1,1,0)||';Enabled=1;' AS cmd_lines
                    FROM active_menus, active_sessions
                   WHERE active_menus.session_id(+) = active_sessions.session_id
                     AND active_sessions.session_id = USERENV ('SESSIONID')
                     AND 0 =
                           (SELECT COUNT (active_menus.menu_handle)
                              FROM active_menus
                             WHERE active_menus.session_id = USERENV ('SESSIONID')
                               AND active_menus.parent_id = do_for_tkurslists.form_handle
                               AND active_menus.menu_text = 'miPasportTrafficAdd')  
                              AND kurs3_var.plan_priv = 1   
                     AND ROWNUM = 1
               UNION ALL
                  SELECT 7 AS cmd_id, 'Window;Handle=' || form_handle || ';SearchListDisp=1;' AS cmd_lines
                    FROM DUAL
                   WHERE l_c = 3 AND l_n = 1 AND kurs3_var.product_name = 'ARMRealiz'
				  union all 
				  SELECT 7 AS cmd_id, 'Window;Handle=' || form_handle || ';Caption=' || l_name || ': ' || l_name1 || ';' AS cmd_lines
				    from dual) -- Frolov 17.08.2009
        ORDER BY cmd_id;
    ELSIF (form_class_name = 'TListsAffaire_K3') THEN
      OPEN qcommand FOR
        SELECT 1 AS cmd_id
              ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSetInspector;Action=aSetInspector;'
                || 'Caption=Закрепить за инспектором;ItemsAdd=PopupMenu1;Visible=1;Enabled=1;MenuIndex=0;' AS cmd_lines
          FROM active_menus, active_sessions
         WHERE active_menus.session_id(+) = active_sessions.session_id
           AND active_sessions.session_id = USERENV ('SESSIONID')
           AND 0 =
                 (SELECT COUNT (active_menus.menu_handle)
                    FROM active_menus
                   WHERE active_menus.session_id = USERENV ('SESSIONID')
                     AND active_menus.parent_id = do_for_tkurslists.form_handle
                     AND active_menus.menu_text = 'miSetInspector')
           AND kurs3_var.plan_priv = 1
           AND ROWNUM = 1
        UNION
        SELECT 2 AS cmd_id
              ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miMoveToFactory;Action=aMoveToFactory;'
                || 'Caption=Передать;ItemsAdd=PopupMenu1;Visible=1;Enabled=1;MenuIndex=1;' AS cmd_lines
          FROM active_menus, active_sessions
         WHERE active_menus.session_id(+) = active_sessions.session_id
           AND active_sessions.session_id = USERENV ('SESSIONID')
           AND 0 =
                 (SELECT COUNT (active_menus.menu_handle)
                    FROM active_menus
                   WHERE active_menus.session_id = USERENV ('SESSIONID')
                     AND active_menus.parent_id = do_for_tkurslists.form_handle
                     AND active_menus.menu_text = 'miMoveToFactory')
           AND kurs3_var.plan_priv = 1
           AND ROWNUM = 1
        UNION
        SELECT 3 AS cmd_id
              ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miClearReg;Action=aClearReg;'
                || 'Caption=Снять с учета;ItemsAdd=PopupMenu1;Visible=1;Enabled=1;MenuIndex=2;' AS cmd_lines
          FROM active_menus, active_sessions
         WHERE active_menus.session_id(+) = active_sessions.session_id
           AND active_sessions.session_id = USERENV ('SESSIONID')
           AND 0 =
                 (SELECT COUNT (active_menus.menu_handle)
                    FROM active_menus
                   WHERE active_menus.session_id = USERENV ('SESSIONID')
                     AND active_menus.parent_id = do_for_tkurslists.form_handle
                     AND active_menus.menu_text = 'miClearReg')
           AND ROWNUM = 1
 	    union  
	    SELECT 4 AS cmd_id, 'Window;Handle=' || form_handle || ';Caption=' || l_name || ': ' || l_name1 || ';' AS cmd_lines
		  from dual -- Frolov 17.08.2009
		   ;
    ELSIF (form_class_name = 'TListsFind') AND (l_n > 0) THEN
      OPEN qcommand FOR
        SELECT 1 AS cmd_id
              ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miCopyAffair;Action=aCopyAffair;'
                || 'Caption=Копировать;ItemsAdd=PopupMenu1;Visible=1;Enabled=1;MenuIndex=0;' AS cmd_lines
          FROM active_menus, active_sessions
         WHERE active_menus.session_id(+) = active_sessions.session_id
           AND active_sessions.session_id = USERENV ('SESSIONID')
           AND 0 =
                 (SELECT COUNT (active_menus.menu_handle)
                    FROM active_menus
                   WHERE active_menus.session_id = USERENV ('SESSIONID')
                     AND active_menus.parent_id = do_for_tkurslists.form_handle
                     AND active_menus.menu_text = 'miCopyAffair')
           AND ROWNUM = 1
 	    union  
	    SELECT 2 AS cmd_id, 'Window;Handle=' || form_handle || ';Caption=' || l_name || ': ' || l_name1 || ';' AS cmd_lines
		  from dual -- Frolov 17.08.2009
		   ;
    ELSIF (form_class_name = 'TListsPlanKPU') THEN
      OPEN qcommand FOR
        SELECT   1 AS cmd_id
                ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSetPlan_OPD;CopyAction=aTempToSRecDo;'
                  || 'Caption=Установить ОПД;ItemsAdd=PopupMenu1;Visible=0;Enabled=0;MenuIndex=4;' AS cmd_lines
            FROM active_menus, active_sessions
           WHERE active_menus.session_id(+) = active_sessions.session_id
             AND active_sessions.session_id = USERENV ('SESSIONID')
             AND 0 =
                   (SELECT COUNT (active_menus.menu_handle)
                      FROM active_menus
                     WHERE active_menus.session_id = USERENV ('SESSIONID')
                       AND active_menus.parent_id = do_for_tkurslists.form_handle
                       AND active_menus.menu_text = 'miSetPlan_OPD')
             AND ROWNUM = 1
        UNION ALL
        SELECT   2 AS cmd_id
                ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miClearPlan_OPD;CopyAction=aTempToSRecDo;'
                  || 'Caption=Снять ОПД;ItemsAdd=PopupMenu1;Visible=0;Enabled=0;MenuIndex=5;' AS cmd_lines
            FROM active_menus, active_sessions
           WHERE active_menus.session_id(+) = active_sessions.session_id
             AND active_sessions.session_id = USERENV ('SESSIONID')
             AND 0 =
                   (SELECT COUNT (active_menus.menu_handle)
                      FROM active_menus
                     WHERE active_menus.session_id = USERENV ('SESSIONID')
                       AND active_menus.parent_id = do_for_tkurslists.form_handle
                       AND active_menus.menu_text = 'miClearPlan_OPD')
             AND ROWNUM = 1
 	    union all  
	    SELECT 3 AS cmd_id, 'Window;Handle=' || form_handle || ';Caption=' || l_name || ': ' || l_name1 || ';' AS cmd_lines
		  from dual -- Frolov 17.08.2009
        ORDER BY cmd_id;
/*
    ELSIF(form_class_name = 'TListsAdjustInstr') THEN
      OPEN qcommand FOR SELECT * FROM (
         SELECT 1 AS cmd_id,
    'Window;Handle='||form_handle||';SearchListDisp=1;' AS cmd_lines
   FROM DUAL
   WHERE l_c=5 AND l_n=1 AND kurs3_var.product_name='ARMRealiz'
   UNION
   SELECT 1000 AS cmd_id, NULL AS cmd_lines FROM DUAL
   )ORDER BY cmd_id;
   */
    ELSE
      do_for_default (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
    END IF;
--------------------------------------------------------------------------
  ELSIF form_event = 'aTempToSRecDo' THEN
    a := UPPER (out_props);
    b := 'LIST_CODE=';

    SELECT SUBSTR (a, INSTR (a, b) + LENGTH (b), INSTR (SUBSTR (a, INSTR (a, b)), ';') - LENGTH (b) - 1)
      INTO c
      FROM DUAL;

    l_c := TO_NUMBER (c);
    b := 'LIST_NUM=';

    SELECT SUBSTR (a, INSTR (a, b) + LENGTH (b), INSTR (SUBSTR (a, INSTR (a, b)), ';') - LENGTH (b) - 1)
      INTO c
      FROM DUAL;

    SELECT menu_text
      INTO menu_name
      FROM active_menus
     WHERE session_id = USERENV ('SESSIONID') AND menu_handle = form_handle AND ROWNUM = 1;

    IF menu_name = 'miToDecree' THEN
      OPEN qcommand FOR
        SELECT 1 AS cmd_id, 'DoCommand;PostMessage;Handle=0;Message=1026;WParam=' || c || ';LParam=-1;' AS cmd_lines
          FROM DUAL;
--------------------------------------------------------------------------
    ELSIF menu_name = 'miCreateAdvice' THEN
      do_for_frm_advice (form_class_name
                        ,form_name => form_name
                        ,form_handle => form_handle
                        ,form_event => 'Create_from_list_FS'
                        ,out_props => out_props
                        ,qcommand => qcommand
                        );
--------------------------------------------------------------------------
    ELSIF menu_name = 'miSetCityProg' THEN
      tesp_pac.lookup1 := l_c;
      tesp_pac.lookup2 := l_n;

      OPEN qcommand FOR
        SELECT   *
            FROM (SELECT 1 AS cmd_id
                        ,'CreateObject;ClassName=TChAny;Owner=Application;Name=oChCityProg;Caption=Городские программы;'
                                                                                                                     AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 2 AS cmd_id
                        ,    'CreateObject;ClassName=TRxDBLookupList;Owner=oChCityProg;Parent=oChCityProg;'
                          || 'Name=dbllCityProg;'
                          || 'Left=0;Top=0;Width=290;Height=303;LookupSource=DataSource1;LookupField=ID;LookupDisplay=NAME;'   --ListSource=DataSource1;ListField=name;KeyField=id;'
                          || 'RetProp=KeyValue;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 3 AS cmd_id, 'Window;Name=oChCityProg;SetObject=Query1;SQL=>>>;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 4 AS cmd_id
--                        ,'select row_num as id, Short_name1 as name from KURS3.classifier_kurs3 where classifier_num=108'
                         ,    'select row_num as id, '
                           || get_current_cp_year
-- AVL 18.10.2007                           || ' ||'' ''||Short_name1 as name from KURS3.classifier_kurs3, kurs3.fs_cp_years where classifier_num=108'
                           || ' ||'' ''||Short_name1||decode(nvl(row_num,0),17,'' !ЗАПРЕТ ДЛЯ З/В!'','''') as name from KURS3.classifier_kurs3, kurs3.fs_cp_years where classifier_num=108'
                           || ' and cp_num=row_num and set_year=get_current_cp_year'
                    FROM DUAL
                  UNION ALL
                  SELECT 5 AS cmd_id, 'EndSQL;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 6 AS cmd_id, 'Window;Name=oChCityProg;SetObject=ListBox;Visible=0;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 7 AS cmd_id, 'Window;Name=oChCityProg;SetObject=Query1;Active=1;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 8 AS cmd_id, 'Window;Name=oChCityProg;SetObject=btnOK;Event=OnClick;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 9 AS cmd_id, 'Window;Name=oChCityProg;ShowModal=1;Free=1;' AS cmd_lines
                    FROM DUAL)
        ORDER BY cmd_id;
    ELSIF menu_name = 'miSelfTrapping' THEN
      tesp_pac.lookup1 := l_c;
      tesp_pac.lookup2 := l_n;

      OPEN qcommand FOR
        SELECT   *
            FROM (SELECT 1 AS cmd_id
                        ,'CreateObject;ClassName=TChAny;Owner=Application;Name=oChTrap;Caption=Самозахват;'
                                                                                                                     AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 2 AS cmd_id
                        ,    'CreateObject;ClassName=TRxDBLookupList;Owner=oChTrap;Parent=oChTrap;'
                          || 'Name=dbllTrap;'
                          || 'Left=0;Top=0;Width=290;Height=303;LookupSource=DataSource1;LookupField=ID;LookupDisplay=NAME;'   --ListSource=DataSource1;ListField=name;KeyField=id;'
                          || 'RetProp=KeyValue;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 3 AS cmd_id, 'Window;Name=oChTrap;SetObject=Query1;SQL=>>>;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 4 AS cmd_id
                          ,'select id, name from v_selftrapping'
                    FROM DUAL
                  UNION ALL
                  SELECT 5 AS cmd_id, 'EndSQL;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 6 AS cmd_id, 'Window;Name=oChTrap;SetObject=ListBox;Visible=0;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 7 AS cmd_id, 'Window;Name=oChTrap;SetObject=Query1;Active=1;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 8 AS cmd_id, 'Window;Name=oChTrap;SetObject=btnOK;Event=OnClick;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 9 AS cmd_id, 'Window;Name=oChTrap;ShowModal=1;Free=1;' AS cmd_lines
                    FROM DUAL)
        ORDER BY cmd_id;
    ELSIF menu_name = 'miSetPlan_OPD' THEN
      kurs3.set_affair_plan_opd_list (TO_NUMBER (c));

      OPEN qcommand FOR
        SELECT   *
            FROM (   -- закомментарил, т.к. raise в процедуре вызывал закрытие окна со списком
                     -- (поправлено в TOOLS версии 1.0.0.12)
                     --
                     --SELECT 1 AS cmd_id,
                     --       'CreateObject;ClassName=TOraStoredProc;Owner=' || form_name || ';Name=spSetOpd;'
                     --       || 'StoredProcName=KURS3.SET_AFFAIR_PLAN_OPD_LIST;Params=;'
                     --       || 'Param1=;FT=3;PN=LIST_NUM;PT=1;Val=' || c || ';EXECPROC=;Free=;' AS cmd_lines
                     --  FROM DUAL
                     --UNION ALL
                  SELECT 10 AS cmd_id
                        , 'DoCommand;PostMessage;Handle=0;Message=1029;WParam=' || TO_CHAR (l_c) || ';LParam=1;' AS cmd_lines
                    FROM DUAL)
        ORDER BY cmd_id;
    ELSIF menu_name = 'miClearPlan_OPD' THEN
      kurs3.set_affair_plan_opd_list (TO_NUMBER (c), 1);

      OPEN qcommand FOR
        SELECT   *
            FROM (SELECT 10 AS cmd_id
                        , 'DoCommand;PostMessage;Handle=0;Message=1029;WParam=' || TO_CHAR (l_c) || ';LParam=1;' AS cmd_lines
                    FROM DUAL)
        ORDER BY cmd_id;
    ELSE
      OPEN qcommand FOR
        SELECT 1 AS cmd_id, '' AS cmd_lines
          FROM DUAL;
    END IF;
--------------------------------------------------------------------------
  ELSIF form_event = 'FormClose' THEN
    if (form_name='frm_LinksList') then
      ins_del_links64(1);
    end if;       
    DELETE FROM all_kurs_objects
          WHERE session_id = USERENV ('SESSIONID') AND window_handle = form_handle;

    DELETE FROM active_menus
          WHERE session_id = USERENV ('SESSIONID') AND parent_id = form_handle;

    COMMIT;

    OPEN qcommand FOR
      SELECT 1 AS cmd_id, '' AS cmd_lines
        FROM DUAL;
--------------------------------------------------------------------------
  ELSIF form_event = 'Center_lc_Decree' THEN
    OPEN qcommand FOR
      SELECT   1 AS cmd_id
              ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miLine1350;'
                || 'Caption=-;ItemsAdd=PURecNos;Visible=1;MenuIndex=9;Enabled=1;Reset;'
                || 'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSpecialSearch;Action=aSpecialSearch;'
                || 'Caption=Быстрый поиск;ItemsAdd=PURecNos;Visible=1;MenuIndex=10;Enabled=1;Reset;' AS cmd_lines
          FROM active_menus, active_sessions
         WHERE active_menus.session_id(+) = active_sessions.session_id
           AND active_sessions.session_id = USERENV ('SESSIONID')
           AND 0 =
                 (SELECT COUNT (active_menus.menu_handle)
                    FROM active_menus
                   WHERE active_menus.session_id = USERENV ('SESSIONID')
                     AND active_menus.parent_id = do_for_tkurslists.form_handle
                     AND active_menus.menu_text IN ('miLine1350', 'miSpecialSearch'))
           AND ROWNUM = 1
      ORDER BY cmd_id;
--------------------------------------------------------------------------
  ELSIF form_event = 'FormCreate' THEN
    OPEN qcommand FOR
      SELECT   *
          FROM (SELECT 1 AS cmd_id
                      ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTestBGList;CopyAction=MenuCommandAction;'
                        || 'Caption=Выгрузка списка;ItemsAdd=PULists;Visible=1;Enabled=1;MenuIndex=4;' AS cmd_lines
                  FROM active_menus, active_sessions
                 WHERE active_menus.session_id(+) = active_sessions.session_id
                   AND active_sessions.session_id = USERENV ('SESSIONID')
                   AND form_class_name <> 'TListsBGReports_K3'
                   AND 0 =
                         (SELECT COUNT (active_menus.menu_handle)
                            FROM active_menus
                           WHERE active_menus.session_id = USERENV ('SESSIONID')
                             AND active_menus.parent_id = do_for_tkurslists.form_handle
                             AND active_menus.menu_text = 'miTestBGList')
                   AND ROWNUM = 1
                   AND kurs3_var.number_version >= 773
                UNION
                SELECT 4 AS cmd_id
                      ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miToDecree;CopyAction=MenuCommandAction;'
                        || 'Caption=Передача распоряжением;ItemsAdd=PopupMenu1;Visible=1;MenuIndex=0;Enabled=1;Reset;'
                        || 'Object;Name=miChangeApart;visible=0;' AS cmd_lines
                  FROM active_menus, active_sessions
                 WHERE active_menus.session_id(+) = active_sessions.session_id
                   AND active_sessions.session_id = USERENV ('SESSIONID')
                   AND form_class_name = 'TListsCenterFreeFloor1'
                   AND 0 =
                         (SELECT COUNT (active_menus.menu_handle)
                            FROM active_menus
                           WHERE active_menus.session_id = USERENV ('SESSIONID')
                             AND active_menus.parent_id = do_for_tkurslists.form_handle
                             AND active_menus.menu_text = 'miCreateDecree')
                   AND ROWNUM = 1
-------------------------- Для списка распоряжений в АРМ-ЦЕНТР
                UNION ALL
                SELECT 4 AS cmd_id
                      ,    'CreateObject;ClassName=TAction;Owner=self;Name=a_tb315;Hint=Быстрый поиск;ShowHint=1;ImageIndex=14;Reset;'
                        || 'Object;Name=dmCenter;CopyAction='
                        || form_class_name
                        || '.'
                        || form_name
                        || '.a_tb315;' AS cmd_lines
                  FROM active_sessions
                 WHERE active_sessions.session_id = USERENV ('SESSIONID') AND form_class_name = 'TListsCenterDecree'
                       AND ROWNUM = 1
-------------------------- Для меню
                UNION ALL
                SELECT     LEVEL * 1000 + NVL (menu_order, 0) AS cmd_id
                          ,    'CreateObject;ClassName=TMenuItem;Owner=Self'
                            || DECODE (v_menus_center.taction
                                      ,NULL, ''
                                      ,DECODE (INSTR (LOWER (v_menus_center.taction), 'copyaction')
                                              ,0, ';Action=' || v_menus_center.taction
                                              ,';CopyAction=MenuCommandAction'
                                              )
                                      )
                            || ';Name='
                            || menu_text
                            || ';MenuIndex='
                            || NVL (menu_order, 0)
                            || DECODE (v_menus_center.menu_hint, NULL, '', ';Hint=' || v_menus_center.menu_hint)
                            || DECODE (v_menus_center.shortcut, NULL, '', ';SHORTCUT=' || v_menus_center.shortcut)
                            || DECODE (v_menus_center.enabled, NULL, '', ';ENABLED=' || v_menus_center.enabled)
                            || DECODE (v_menus_center.visible, NULL, '', ';VISIBLE=' || v_menus_center.visible)
                            || DECODE (v_menus_center.image_index, NULL, '', ';IMAGEINDEX=' || v_menus_center.image_index)
                            || ';Caption='
                            || NVL (v_menus_center.menu_caption, '-')
                            || ';ItemsAdd='
                            || DECODE (owner, NULL, get_menu_name (parent_id), owner)
                            || ';' AS cmd_lines
                      FROM v_menus_center
                     WHERE EXISTS (SELECT 1
                                     FROM screen_types
                                    WHERE screen_type = v_menus_center.screen_types AND screen_types.NAME = form_class_name)
                       AND LOWER (proc_name) = LOWER (kurs3_var.product_name)
                       AND NOT ((owner IS NULL) AND (NVL (parent_id, 0) = 0))
                       AND (   NVL (v_menus_center.menu_caption, '-') = '-'
                            OR EXISTS (
                                 SELECT 1
                                   FROM v_menus_center_2
                                  WHERE v_menus_center.menu_id = v_menus_center_2.menu_id
                                     OR v_menus_center.menu_id = v_menus_center_2.parent_id)
                           )
                START WITH v_menus_center.menu_id =
                                   DECODE (NVL (v_menus_center.parent_id, 0)
                                          ,0, v_menus_center.menu_id
                                          ,v_menus_center.parent_id
                                          )
                CONNECT BY PRIOR v_menus_center.menu_id = v_menus_center.parent_id
                union all
                SELECT 100 AS cmd_id,
                  'Object;Name=Del;Enabled=0;Reset;'||
                  'Object;Name=Add;Enabled=0;Reset;'||
                  'Object;Name=Refresh;Enabled=0;Reset;'||
                  'Object;Name=N16;Enabled=0;Reset;'|| 
                  'Object;Name=N2;Enabled=0;Reset;'||
                  'Object;Name=N3;Enabled=0;Reset;'||
                  'Object;Name=N16;Enabled=0;Reset;'||
                  'Object;Name=N4;Enabled=0;Reset;'||
                  'Object;Name=miGoLastPosition;Enabled=0;Reset;'||
                  'Object;Name=N5;Enabled=0;Reset;'||
                  'Object;Name=N6;Enabled=0;Reset;'||
                  'Object;Name=N7;Enabled=0;Reset;'||
                  'Object;Name=N9;Enabled=0;Reset;'||
                  'Object;Name=N10;Enabled=0;Reset;'||
                  'Object;Name=N11;Enabled=0;Reset;'||
                  'Object;Name=N12;Enabled=0;Reset;'          
                as cmd_lines from dual
                where form_name='frm_LinksList'                
                )
      ORDER BY cmd_id;
    if (form_name='frm_LinksList') then
      ins_del_links64(0);
    end if;            
-----------------------------------BEGIN  --  MenuCommandAction----------------------------------------------------
  ELSIF form_event = 'MenuCommandAction' THEN
    c := get_id_param_char ('ObjName', out_props);

    IF UPPER (c) = 'A_TB315' THEN
      a := get_id_param_char ('ListCod', out_props);

      OPEN qcommand FOR
        SELECT   *
            FROM (SELECT 1 AS cmd_id
                        ,    'CreateObject;ClassName=T_fm_quick;Owner=Application;Reset;'
                          || 'Object;Name=_fm_quick;'
                          || 'List_Code='
                          || a
                          || ';' AS cmd_lines
                    FROM DUAL
                   WHERE form_class_name IN ('TListsCenterBuildAparts', 'TListsCenterDecree'))
        ORDER BY cmd_id;
-------------------------- 31.05.2005 avl В архив / из архива из формы списка корпусов!!!
    ELSIF form_class_name = 'TListsCenterBuildAparts' AND UPPER (c) IN ('MI2_TO_ARCH', 'MI2_FROM_ARCH') THEN
      do_for_tfrmbuildaparts (form_class_name
                             ,form_name
                             ,form_handle
                             ,form_event
                             ,REPLACE (out_props, '.AFFAIR_ID=', '.BUILD_ID=')
                             ,qcommand
                             );
-------------------------- Изменение учетного года
    ELSIF UPPER (c) = 'MI_CHANGE_UYEAR' THEN
      nn := get_id_param ('AFFAIR_ID', out_props);

      IF nn = 0 THEN
        OPEN qcommand FOR
          SELECT 1 AS cmd_id, 'Object;Name=dmCenter;sendMessage=' || get_messagebox_text (46) AS cmd_lines
            FROM DUAL;

        RETURN;
      ELSE
        do_for_default (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
      END IF;
--------------------------
    ELSE
      SELECT menu_text
        INTO menu_name
        FROM active_menus
       WHERE session_id = USERENV ('SESSIONID') AND menu_handle = form_handle AND ROWNUM = 1;

      SELECT DECODE (UPPER (RTRIM (menu_text)), 'MITESTBGLIST', 1, 0)
        INTO nn
        FROM active_menus
       WHERE session_id = USERENV ('SESSIONID') AND menu_handle = form_handle;

      IF nn = 1 THEN
        OPEN qcommand FOR
          SELECT   *
              FROM (SELECT 1 AS cmd_id
                          ,    'CreateObject;ClassName=TfrmParamsRep;Owner=Application;Name=tmp_frmParamsRep;'
                            || 'LengthInParam=6;ValueInParams=BG_REP_TYPE;ValueInParams=5;'
                            || 'ValueInParams=LIST_COD;ValueInParams='
                            || l_c
                            || ';ValueInParams=LIST_NUM;ValueInParams='
                            || l_n
                            || ';StartControlParams=1;Free=;' AS cmd_lines
                      FROM DUAL)
          ORDER BY cmd_id;
-- Для АРМ-ЦЕНТР - запуск action, который соответствует меню.
      ELSIF menu_name IN ('miToDecree') THEN
        OPEN qcommand FOR
          SELECT   *
              FROM (SELECT 1 AS cmd_id, 'Object;Name=dmCenter;ExecAction=' || action_name || ';Reset;' AS cmd_lines
                      FROM action_menus
                     WHERE action_menus.menu_name = m_n)
          ORDER BY cmd_id;
-- Издание распоряжений списком   , Перенос распоряжений в КУРС3
      ELSIF menu_name IN ('mi_Izdat_Instr', 'mi_TO_KURS3') THEN
        SELECT COUNT (*)
          INTO nn
          FROM documents_list
         WHERE list_cod = l_c AND list_num = l_n AND note > 0 AND user_id = kurs3_var.get_user_id_f;

        IF menu_name = 'mi_Izdat_Instr' THEN
          st1 := 2;
        ELSIF menu_name = 'mi_TO_KURS3' THEN
          st1 := 3;
        END IF;

        IF nn = 0 THEN
          OPEN qcommand FOR
            SELECT 1 AS cmd_id, 'Object;Name=dmCenter;sendMessage=' || get_messagebox_text (20) AS cmd_lines
              FROM DUAL;
        ELSE
          SELECT COUNT (*)
            INTO i1
            FROM documents_list
           WHERE user_id = kurs3_var.get_user_id_f
             AND list_cod = l_c
             AND list_num = l_n
             AND note > 0
             AND EXISTS (SELECT 1
                           FROM instruction
                          WHERE NVL (status, 0) = st1 AND document_type = 1 AND NVL (nulling, 0) = 0
                                AND instruction_num = affair_id);

          IF st1 = 3 AND i1 = nn THEN
            -- AVL 2008.12.01 нач
            temp1 := 0;
            select count(*)
              into temp1
              from documents_list dl1, kursiv.instruction in1
             where dl1.list_cod=l_c 
               and dl1.list_num=l_n
               and dl1.note > 0 
               and dl1.user_id = kurs3_var.get_user_id_f
               and in1.instruction_num=dl1.affair_id
               and to_char(in1.instruction_date,'mm')<>to_char(sysdate,'mm')
               and get_factory_p8(in1.department_to, in1.num_in_department_to)=30;
            if temp1>0 then
              OPEN qcommand FOR            
              SELECT 1 AS cmd_id, 'Object;Name=dmCenter;sendMessage=Перевод в Курс-3 не возможен из-за месяца даты издания не равного текущему в одном из распоряжений;' AS cmd_lines
              FROM DUAL;
              return;            
            end if;               
            -- AVL 2008.12.01 кон          
            FOR v_temp IN (SELECT *
                             FROM documents_list
                            WHERE list_cod = l_c AND list_num = l_n AND note > 0 AND user_id = kurs3_var.get_user_id_f) LOOP
              kursiv_exchange.instruction_exchange (v_temp.affair_id);
              update_instr_status (v_temp.affair_id, st1 + 1);
--     SET_APARTMENT_STATUS(v_Temp.affair_id,st1+1);
              -- avl 08.02.2006 нач
              temp1 := 0;

              SELECT COUNT (*)
                INTO temp1
                FROM instruction_apart
               WHERE instruction_num = v_temp.affair_id;

              IF temp1 > 0 THEN
                SELECT get_factory_p8 (in1.department_who, in1.num_in_department_who)
                      ,get_factory_p8 (in1.department_to, in1.num_in_department_to)
                  INTO temp1
                      ,temp2
                  FROM instruction in1
                 WHERE in1.instruction_num = v_temp.affair_id;

                IF NOT ((temp1 = 11) AND (temp2 = 11)) THEN
                  DELETE FROM kursiv.needy_apart
                        WHERE apart_id IN (SELECT apart_id
                                             FROM instruction_apart
                                            WHERE instruction_num = v_temp.affair_id);
                END IF;
              END IF;
            -- avl 08.02.2006 кон
            END LOOP;

            COMMIT;

-- avl 23.01.2007 нач
            FOR v_temp IN (SELECT *
                             FROM documents_list
                            WHERE list_cod = l_c AND list_num = l_n AND note > 0 AND user_id = kurs3_var.get_user_id_f) LOOP
              SELECT get_factory_p8 (in1.department_who, in1.num_in_department_who)
                    ,get_factory_p8 (in1.department_to, in1.num_in_department_to), NVL (new_building_code, 0)
                INTO temp1
                    ,temp2, nbc
                FROM instruction in1
               WHERE in1.instruction_num = v_temp.affair_id;

              IF ((temp1 = 11) AND (temp2 = 30) AND (nbc > 0)) THEN
                IF ((test_instruction_crpi (v_temp.affair_id) <> 0) OR (test_instruction_crpi (v_temp.affair_id) < 10000)) THEN
                  cp_num1 := city_prog_managment (v_temp.affair_id, 1);
                  COMMIT;
                END IF;
              END IF;
            END LOOP;
-- avl 23.01.2007 кон
          END IF;

          OPEN qcommand FOR
            SELECT 1 AS cmd_id, 'Object;Name=dmCenter;sendMessage=' || get_messagebox_text (19) AS cmd_lines
              FROM DUAL
             WHERE i1 <> nn
            UNION
            SELECT 1 AS cmd_id
                  ,    'CreateObject;ClassName=T_fm_rpt_Param;Owner=Self;Name=_fm_Instr_Date;Num_Doc='
                    || l_n
                    || ';NUM_TYPE=5;'
                    || 'Caption=Дата распоряжения;Width=220;height=132;ShowModal=1;Free=1;' AS cmd_lines
              FROM DUAL
             WHERE i1 = nn AND st1 = 2   --  Издать
            UNION
            SELECT 1 AS cmd_id, 'Object;Name=dmCenter;sendMessage=' || nn || ' распоряжений перенесено в КУРС3;' AS cmd_lines
              FROM DUAL
             WHERE i1 = nn AND st1 = 3   --  в курс 3
            UNION
            SELECT 1 AS cmd_id, 'Window;Handle=' || window_handle || ';Instruction_NUM=' || inf_id || ';' AS cmd_lines
              FROM all_kurs_objects
             WHERE window_name = '_fm_Decree' AND user_id = kurs3_var.get_user_id_f AND i1 = nn AND st1 = 3   --  в курс 3
            UNION
            SELECT 2 AS cmd_id, 'DoCommand;PostMessage;Handle=0;Message=1029;WParam=' || inf_id || ';LParam=1;' AS cmd_lines
              FROM all_kurs_objects
             WHERE user_id = kurs3_var.get_user_id_f AND LOWER (window_name) LIKE ('kurslists%') AND i1 = nn
                   AND st1 = 3   --  в курс 3
            UNION
            SELECT 1000 AS cmd_id, NULL AS cmd_lines
              FROM DUAL;
        END IF;

        RETURN;
-- Перенос экспликации из буфера
      ELSIF menu_name IN ('miBuf2Const', 'miDelExpl') THEN
        UPDATE all_kurs_objects
           SET inf_id = form_handle
         WHERE session_id = USERENV ('SESSIONID') AND window_name = 'dmCenter';

        COMMIT;

        OPEN qcommand FOR
          SELECT   *
              FROM (SELECT 1 AS cmd_id, 'Object;Name=dmCenter;GetAffair_List=' || l_c || '#' || l_n || '#AFFAIR_ID;' AS cmd_lines
                      FROM DUAL)
          ORDER BY cmd_id;
------------------------------------
      ELSE
        do_for_default (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
      END IF;
    END IF;
-----------------------------------END  --  MenuCommandAction----------------------------------------------------
  ELSIF form_class_name = 'TLists_onFormCommand' AND form_event = 'OpenDocument' THEN
    UPDATE all_kurs_objects
       SET screen_id = get_id_param ('DOC_NUM', out_props)
     WHERE session_id = USERENV ('SESSIONID') AND screen_type = 111 AND inf_id = l_c;

    COMMIT;
    do_for_tlists_onformcommand (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
-----------------------------------END  --  MenuCommandAction----------------------------------------------------
  ELSIF form_class_name = 'TChAny' AND form_name = 'oChTrap' AND form_event = 'OnClick:btnOK' THEN
    IF get_id_param ('dbllTrap.KeyValue', out_props) IS NOT NULL THEN
         
         kurs3.update_list_selftrapping (get_id_param ('dbllTrap.KeyValue', out_props)
                        ,tesp_pac.lookup1   -- l_c
                        ,tesp_pac.lookup2   -- l_n
                        );
         
      COMMIT;

      OPEN qcommand FOR
        SELECT 1 AS cmd_id
              , 'DoCommand;PostMessage;Handle=0;Message=1029;WParam=' || tesp_pac.lookup1 || ';LParam=1;' AS cmd_lines
          FROM DUAL;
    ELSE
      OPEN qcommand FOR
        SELECT 1 AS cmd_id, '' AS cmd_lines
          FROM DUAL;
    END IF;

  ELSIF form_class_name = 'TChAny' AND form_name = 'oChCityProg' AND form_event = 'OnClick:btnOK' THEN
    IF get_id_param ('dbllCityProg.KeyValue', out_props) IS NOT NULL THEN
         
--      IF get_id_param ('dbllCityProg.KeyValue', out_props) = 0 THEN
--        INSERT INTO kurs3.TEST
--                    (aa, bb
--                    )
--             VALUES (TO_CHAR (SYSDATE, 'dd.mm.yyyy hh24:mi') || '=' || USERENV ('TERMINAL'), 'CITY=0'
--                    );

--        INSERT INTO kurs3.TEST
--                    (aa, bb)
--          SELECT prop_name || '=' || prop_value, 'CITY=0'
--            FROM active_props
--           WHERE session_id = 17446 AND (prop_name = 'ARMKURS.BPL' OR LOWER (prop_name) = 'dbllcityprog.keyvalue');
--      END IF;

      kurs3_set_list_cp (list_cod => tesp_pac.lookup1   -- l_c
                        ,list_num => tesp_pac.lookup2   -- l_n
                        ,user_id => kurs3_var.global_user_id
                        ,cp_num => get_id_param ('dbllCityProg.KeyValue', out_props)
                        );
      COMMIT;

      OPEN qcommand FOR
        SELECT 1 AS cmd_id
              , 'DoCommand;PostMessage;Handle=0;Message=1029;WParam=' || tesp_pac.lookup1 || ';LParam=1;' AS cmd_lines
          FROM DUAL;
    ELSE
      OPEN qcommand FOR
        SELECT 1 AS cmd_id, '' AS cmd_lines
          FROM DUAL;
    END IF;
--------------------------------------------------------------------------
  ELSE
    do_for_default (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  END IF;
END;
/