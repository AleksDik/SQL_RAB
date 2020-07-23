CREATE OR REPLACE PROCEDURE kursiv.do_for_tfreefloor (
  form_class_name IN     VARCHAR2
 ,form_name       IN     VARCHAR2
 ,form_handle     IN     NUMBER
 ,form_event      IN     VARCHAR2
 ,out_props       IN     VARCHAR2
 ,qcommand        IN OUT pckg_tree.curstype
) IS
  a        VARCHAR2 (2000);
  b        VARCHAR2 (20);
  c        VARCHAR2 (20);
  c1       VARCHAR2 (20);
  menuname VARCHAR2 (100);
  n        NUMBER;
  n1       NUMBER;
BEGIN

-- 19.12.2012 ilonis  активность пункта меню технический паспорт
-- #23.08.2013 Dik     меню Причины не заключения договоров
  c := get_id_param ('APART_ID', out_props);
  c1 := get_id_param ('AFFAIR_ID', out_props);

--------------------------------------------------------------------------
  IF form_event = 'PRINT_CERTIF_FLAT' THEN
    OPEN qcommand FOR
      SELECT   *
          FROM (SELECT 1 AS cmd_id, 'LoadPackage;PackageName=Rep.bpl;' AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 2 AS cmd_id
                      ,    'CreateObject;ClassName=TfmRepRTF;Owner=Application;Name=frmPrintCertFlat;TypeReport=104;'
                        || 'Caption=Печать Справки по квартире;' AS cmd_lines
                  FROM DUAL
                UNION ALL
--                SELECT 22 AS cmd_id
--                      ,    'CreateObject;ClassName=TMenuItem;Name=miMCAG;Caption=Справка о приходе жилой площади;'
--                        || 'Owner=Self;CopyAction=MenuCommandAction;'
--                        || 'ItemsAdd=PopupMenu1;Visible=1;Enabled=1;MenuIndex=12;' AS cmd_lines
--                  FROM users
--                 WHERE kurs3_var.get_user_id_f = users.user_id
--                   AND users.last_name = 'MGCAG'
--                   AND NOT EXISTS (
--                         SELECT 1
--                           FROM active_menus
--                          WHERE active_menus.session_id = USERENV ('SESSIONID')
--                            AND active_menus.menu_text = 'miMCAG'
--                            AND active_menus.parent_id = form_handle)
--                UNION
                SELECT 3 AS cmd_id, 'CreateObject;ClassName=TOraQuery;Owner=frmPrintCertFlat;Name=qHeader;SQL=;' AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 4 AS cmd_id, 'SELECT * FROM V_ROOM_INFO WHERE APART_ID = ' || c || ' AND FREESPACE_ID = ' || c1 AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 5 AS cmd_id, 'EndSQL;Active=1;' AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 6 AS cmd_id, 'CreateObject;ClassName=TOraQuery;Owner=frmPrintCertFlat;Name=qBody;SQL=;' AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 7 AS cmd_id, 'SELECT * FROM V_ROOM_DOC WHERE APART_ID = ' || c AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 8 AS cmd_id, 'EndSQL;Active=1;' AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 9 AS cmd_id
                      ,'Window;Name=frmPrintCertFlat;AddHeader=qHeader;AddBody=qBody;AddFooter=qHeader;StartReport=1;Free=;' AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 99999999 AS cmd_id, 'UnLoadPackage;PackageName=Rep.bpl;' AS cmd_lines
                  FROM DUAL)
      ORDER BY cmd_id;
--------------------------------------------------------------------------
  ELSIF form_event = 'MenuCommandAction' THEN
    SELECT UPPER (active_menus.menu_text)
      INTO menuname
      FROM active_menus
     WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_handle = do_for_tfreefloor.form_handle AND ROWNUM = 1;

    IF menuname = 'MIMCAG' THEN
--  ELSIF form_event = 'PRINT_MCAG_FLAT' THEN
      OPEN qcommand FOR
        SELECT   *
            FROM (SELECT 1 AS cmd_id, 'LoadPackage;PackageName=Rep.bpl;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 2 AS cmd_id
                        ,    'CreateObject;ClassName=TfmRepRTF;Owner=Application;Name=frmPrintMCAGFlat;TypeReport=205;'
                          || 'Caption=Печать Справки по квартире для МЦАЖ;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 3 AS cmd_id, 'CreateObject;ClassName=TOraQuery;Owner=frmPrintMCAGFlat;Name=qHeaderMCAG;SQL=;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 4 AS cmd_id
--                      ,'SELECT * FROM KURS3.V_FREE_GP_MGCAG WHERE APART_ID = ' || c || ' AND FREESPACE_ID = ' || c1 AS cmd_lines
                         , 'SELECT * FROM KURS3.V_FREE_GP_MGCAG WHERE FREESPACE_ID = ' || c1 AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 5 AS cmd_id, 'EndSQL;Active=1;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 9 AS cmd_id, 'Window;Name=frmPrintMCAGFlat;AddHeader=qHeaderMCAG;StartReport=1;Free=;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 99999999 AS cmd_id, 'UnLoadPackage;PackageName=Rep.bpl;' AS cmd_lines
                    FROM DUAL)
        ORDER BY cmd_id;
    ELSIF menuname = UPPER ('miCreateAdvice') THEN
      do_for_frm_advice (form_class_name
                        ,form_name => form_name
                        ,form_handle => form_handle
                        ,form_event => 'Create_from_FS'
                        ,out_props => out_props
                        ,qcommand => qcommand
                        );
    END IF;
--------------------------------------------------------------------------
  ELSIF form_event = 'SET_ID' THEN
    UPDATE all_kurs_objects
       SET inf_id = c
     WHERE session_id = USERENV ('SESSIONID') AND window_handle = form_handle;

    COMMIT;
--#23.08.2013 Dik    
   select count(*)  into n from free_space fs
   where fs.apart_id=c 
   and fs.status=4 --Заселена
   AND fs.LAST in (1,2);
   IF ((get_user_priv(109) = 1) and (n > 0)) then 
     b := '0' ; -- Убрал видимость пункта меню "Причины не заключения договоров" в форме свободной площади из-за изменений в постановке задачи.
   else 
     b:='0';
   end if;
-- / #23.08.2013 Dik
    OPEN qcommand FOR
     SELECT   *
          FROM (
                    SELECT 1 AS cmd_id, 'Object;Name=miCreateAdvice;Visible=1;Enabled=1;' AS cmd_lines
                    FROM DUAL
                    WHERE get_user_priv (71) = 1    -- может ли делать пользователь "Уведомление о закреплении" -- get_user_unique_id (kurs3_var.get_user_id_f) = 782)
                    UNION ALL --19.12.2012 ilonis
                    SELECT 2 AS cmd_id, 'Object;Name=miTP;Visible=1;Enabled='|| case when( /*get_user_priv (111) = 1 or get_user_priv (112) = 1 or*/  get_user_priv (113) = 1) then '1' else '0' end   ||';' AS cmd_lines
                    FROM DUAL
--#23.08.2013 Dik   Reasons not to sign the agreement                 
                    UNION ALL 
                    SELECT 3 AS cmd_id, 'Object;Name=miReasonsNSAgr;Visible='||b||';Enabled='||b||';' AS cmd_lines
                    FROM DUAL
-- / #23.08.2013 Dik
                 )   
      ORDER BY cmd_id;
--------------------------------------------------------------------------
  ELSIF form_event = 'FormCreate' THEN
    OPEN qcommand FOR
      SELECT   *
          FROM (SELECT 1 AS cmd_id
                      ,    'CreateObject;ClassName=TMenuItem;Name=miCreateAdvice;Caption=Создать уведомление о закреплении;'
                        || 'Owner=Self;CopyAction=MenuCommandAction;'
                        || 'ItemsAdd=PopupMenu1;Visible=0;Enabled=0;MenuIndex=12;' AS cmd_lines
                  FROM DUAL
                 WHERE get_user_priv (71) = 1   -- может ли делать пользователь "Уведомление о закреплении"
                                                --get_user_unique_id (kurs3_var.get_user_id_f) = 782
                UNION ALL
                SELECT 1 AS cmd_id, '' AS cmd_lines
                  FROM DUAL)
      ORDER BY cmd_id;
--------------------------------------------------------------------------
  ELSIF form_event IN ('miDisableFreeFloor_DISABLE', 'miDisableFreeFloor_ENABLE') THEN
    n := get_id_param ('FreeSpace_id', out_props);

    UPDATE all_kurs_objects
       SET inf_type = n
     WHERE session_id = USERENV ('SESSIONID') AND window_handle = form_handle;

    COMMIT;

    OPEN qcommand FOR
      SELECT   *
          FROM (SELECT 1 AS cmd_id
                      ,    'Object;Name=dmCenter;SendMessage='
                        || n
                        || DECODE (form_event
                                  ,'miDisableFreeFloor_DISABLE', get_messagebox_text (35)
                                  ,'miDisableFreeFloor_ENABLE', get_messagebox_text (34)
                                  ,NULL
                                  ) AS cmd_lines
                  FROM DUAL)
      ORDER BY cmd_id;
  ELSE
    do_for_default (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  END IF;
END;
/
