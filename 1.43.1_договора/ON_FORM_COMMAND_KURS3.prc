CREATE OR REPLACE PROCEDURE KURSIV.on_form_command_kurs3 (form_class_name IN     VARCHAR2
                                                         ,form_name       IN     VARCHAR2
                                                         ,form_handle     IN     NUMBER
                                                         ,form_event      IN     VARCHAR2
                                                         ,out_props       IN     VARCHAR2
                                                         ,qcommand        IN OUT pckg_tree.curstype
                                                         ) IS
  --
  --  Вызывается при создании формы в DELPHI
  --  form_class_name - имя класса формы (DELPHI)
  --  form_name - имя (DELPHI)
  --  form_handle - указатель на форму (DELPHI)
  --  form_event - действие в форме (DELPHI)
  --  qCommand - список необходимых действий
  --
  --  07.05.2007  BlackHawk   Добавил обработку окон типа TfrmChild
  --  10.09.2008  Anissimova  Обработка окна frmType2
  --  01.12.2008  BlackHawk   Добавил обработку окна af_fraud
  --  19.03.2009  BlackHawk   Добавил удаление "хвостов" от старых дельфовых объектов
  --  09.07.2010  Lvova       Добавила обработку ввода номера и даты РП об аннулировании выписки
  --  31.03.2011  BlackHawk   Добавил обработку frm_kpr
  --  27.06.2011  BlackHawk   Добавил обработку окна frm_decl_cp
  --  06.07.2011  BlackHawk   Добавил обработку окна frm_subsid
  --  16.08.2011  BlackHawk   Исправил обработку окна frm_subsid
  --  28.11.2011  BlackHawk   Добавил обработку окон frmVyvRepResult и frmVyvRepUsers
  --  17.12.2011  BlackHawk   Добавил обработку frm_lk_ur_rep
  --  20.03.2012  AVB         Добавил обработку do_for_frmDocPoor  
  --25.09.2012 Ilonis -добавил одработку  DO_FOR_TFRMUFRS      
  --21.02.2013 Ilonis -добавил одработку  DO_FOR_TECHPASPORTACTPRINT
  
  --
  s_t           NUMBER; -- SCREEN_TYPE
  formclassname VARCHAR2 (200);
  handle        NUMBER;
  m_t           VARCHAR2 (200);
  n             NUMBER;
  o_id          NUMBER;
  d_id          NUMBER;
  year          NUMBER;
  cnt_w         NUMBER;
  a             VARCHAR2 (6000);
  b             VARCHAR2 (6000);
  c             VARCHAR2 (6000);
  rep_type      NUMBER;
BEGIN
  formclassname   := on_form_command_kurs3.form_class_name;
  handle          := on_form_command_kurs3.form_handle;
  a               := out_props;
  b               := 'ParentFormHandle=';

  IF INSTR (a, b) > 0 THEN
    SELECT LTRIM (RTRIM (SUBSTR (a, INSTR (a, b) + LENGTH (b), INSTR (SUBSTR (a, INSTR (a, b)), ';') - LENGTH (b) - 1))) INTO c FROM DUAL;

    IF TO_NUMBER (NVL (c, '0')) > 0 THEN
      handle   := TO_NUMBER (NVL (c, '0'));

      BEGIN
        SELECT DISTINCT screen_types.name
          INTO formclassname
          FROM screen_types, all_kurs_objects
         WHERE     screen_types.screen_type = all_kurs_objects.screen_type
               AND all_kurs_objects.window_handle = handle
               AND all_kurs_objects.session_id = USERENV ('SESSIONID');
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          formclassname   := on_form_command_kurs3.form_class_name;
      END;
    END IF;
  END IF;

  -----------------------------------------------------------------------------------------
  IF form_event = 'FormCreate' THEN
    BEGIN
      SELECT screen_types.screen_type
        INTO s_t
        FROM screen_types
       WHERE screen_types.name = formclassname;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT seq_screen_types.NEXTVAL INTO s_t FROM DUAL;

        INSERT INTO screen_types (name, screen_type)
             VALUES (formclassname, s_t);

        COMMIT;
    END;

    INSERT INTO all_kurs_objects (user_id, screen_type, screen_id, inf_type, inf_id, session_id, window_handle, window_name)
      SELECT kurs3.get_user_id_f, s_t, seq_screen_id.NEXTVAL, 0, 0, USERENV ('SESSIONID'), form_handle, form_name FROM DUAL;

    COMMIT;
  ELSIF form_event = 'MenuCreate' THEN
    SELECT NVL (MAX (menu_id), 0) + 1
      INTO n
      FROM active_menus
     WHERE session_id = USERENV ('SESSIONID');

    /* удаляем "хвосты" от старых меню с таким же хендлом */
    DELETE FROM active_menus
          WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_handle = form_handle;

    INSERT INTO active_menus (menu_id, session_id, menu_text, menu_handle, parent_id)
         VALUES (n, USERENV ('SESSIONID'), form_name, form_handle, handle);

    COMMIT;
  ELSIF form_event = 'MenuFree' THEN
    DELETE FROM active_menus
          WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_handle = form_handle;

    COMMIT;
  END IF;

  IF RTRIM (form_event) NOT IN ('FormDestroy', 'FormClose', 'MenuCreate', 'MenuFree') THEN
    set_active_props (handle, on_form_command_kurs3.out_props);
  END IF;

  -----------------------------------------------------------------------------------------
  IF (form_event = 'FormDestroy' OR (form_event = 'FormClose' AND NOT UPPER (form_class_name) = 'TFRMHOUSE')) -- + --
                                                                                                              -- 2009.05.27 utk баг в Реестре Договоров v.1009, там в форме ввода/ред-я оснований надо будет отключить OFC
     AND NOT (form_event IN ('FormDestroy', 'FormClose') AND form_class_name = 'TNewFoundFrm' AND kurs3_var.product_name = 'ARMReestr') -- + --
                                                                                                                                       THEN
    DELETE FROM all_kurs_objects
          WHERE session_id = USERENV ('SESSIONID') AND window_handle = form_handle;

    DELETE FROM active_menus
          WHERE session_id = USERENV ('SESSIONID') AND parent_id = form_handle;

    DELETE FROM active_props
          WHERE session_id = USERENV ('SESSIONID') AND window_handle = form_handle;

    COMMIT;
  END IF;

  -----------------------------------------------------------------------------------------
  IF form_name = 'frmStatPlanKPU' AND form_event = 'FormCreate' THEN
    OPEN qcommand FOR
        SELECT *
          FROM (SELECT 1 AS cmd_id
                      ,   'Window;Handle='
                       || TO_CHAR (form_handle)
                       || ';'
                       || 'Constraints.MaxWidth=400;Constraints.MaxHeight=180;'
                       || 'Constraints.MinWidth=400;Constraints.MinHeight=180;AutoSize=0;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TPanel;Owner=Self;Name=plMain_StatPlanKPU;Parent=Self;Align=5;Caption=;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TButton;Owner=Self;Name=btnRep;Parent=plMain_StatPlanKPU;'
                       || 'Caption=Отчет;Left=280;Width=100;Top=10;Event=OnClick;TabOrder=4;'
                       || 'Enabled=1;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TLabel;Owner=Self;Name=tbSelRepType;Parent=plMain_StatPlanKPU;'
                       || 'Caption=Тип отчета;Visible=1;Left=10;Top=10;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TOraQuery;Owner=Self;Name=qTypeRep;SQL=;>>>'
                         AS cmd_lines
                  FROM DUAL
                UNION
                SELECT 2 AS cmd_id, 'select * from V_AFFAIR_PLAN_REP_1' AS cmd_lines FROM DUAL
                UNION
                SELECT 3 AS cmd_id
                      ,   'Active=1;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TDataSource;Owner=Self;Name=dsTypeRep;DataSet=qTypeRep;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TRxDBLookupCombo;Owner=Self;Name=dblcTypeRep;Parent=plMain_StatPlanKPU;'
                       || 'Left=90;Top=10;LookupSource=dsTypeRep;LookupField=REP_ID;LookupDisplay=TEXT;Width=180;'
                       || 'RetProp=KeyValue;Event=OnChange;TabOrder=0;KeyValue=1;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TLabel;Owner=Self;Name=tbSelOkrug;Parent=plMain_StatPlanKPU;'
                       || 'Caption=Округ;Visible=1;Left=10;Top=45;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TOraQuery;Owner=Self;Name=spOkrug;SQL=;>>>'
                         AS cmd_lines
                  FROM DUAL
                UNION
                SELECT 4 AS cmd_id, 'select * from KURS3.V_OKRUG_ALL' AS cmd_lines FROM DUAL
                UNION
                SELECT 5 AS cmd_id
                      ,   'Active=1;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TDataSource;Owner=Self;Name=dsOkrug;DataSet=spOkrug;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TRxDBLookupCombo;Owner=Self;Name=dblcOkrug;Parent=plMain_StatPlanKPU;'
                       || 'Left=90;Top=45;LookupSource=dsOkrug;LookupField=OKRUG_ID;LookupDisplay=NAME;Width=180;'
                       || 'Enabled=0;RetProp=KeyValue;Event=OnChange;TabOrder=1;KeyValue='
                       || TO_CHAR (NVL (kurs3_var.global_okrug_id, 51))
                       || ';'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TLabel;Owner=Self;Name=tbSelMokrug;Parent=plMain_StatPlanKPU;'
                       || 'Caption=Район;Visible=1;Left=10;Top=80;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TOraStoredProc;Owner=Self;Name=spMunicipal;'
                       || 'StoredProcName=GET_REP_MOKRUG;Params=;'
                       || 'Param1=;FT=22;PN=MOKRUG;PT=3;'
                       || 'Param1=;FT=3;PN=OKRUG_ID;PT=1;Val='
                       || TO_CHAR (NVL (kurs3_var.global_okrug_id, 51))
                       || ';'
                       || 'Active=1;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TDataSource;Owner=Self;Name=dsMunicipal;DataSet=spMunicipal;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TRxDBLookupCombo;Owner=Self;Name=dblcMunicipal;Parent=plMain_StatPlanKPU;'
                       || 'Left=90;Top=80;LookupSource=dsMunicipal;LookupField=FACTORY_ID;LookupDisplay=NAME;Width=180;'
                       || 'RetProp=KeyValue;Event=OnChange;TabOrder=2;'
                       || --KeyValue=1;'
                         'Reset;'
                       || 'CreateObject;ClassName=TLabel;Owner=Self;Name=lbTPGYear;Parent=plMain_StatPlanKPU;'
                       || 'Caption=ТПГ:;Visible=0;Left=10;Top=115;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TMaskEdit;Owner=Self;Name=meTPGYear;Parent=plMain_StatPlanKPU;'
                       || 'Visible=0;Left=90;Top=115;RetProp=Text;TabOrder=3;Text=;EditMask=;>>>'
                         AS cmd_lines
                  FROM DUAL
                UNION
                SELECT 6 AS cmd_id, '9999; ; ' AS cmd_lines FROM DUAL
                UNION
                SELECT 7 AS cmd_id
                      ,'CreateObject;ClassName=TBitBtn;Owner=Self;Name=btnExit;Parent=plMain_StatPlanKPU;'
                       || 'Kind=6;Caption=Выход;Left=280;Width=100;Top=40;'
                  FROM DUAL)
      ORDER BY cmd_id;
  ------------------------------------------------------------------------------------------------------------
  ELSIF form_name = 'frmStatPlanKPU' AND form_event = 'OnChange:dblcTypeRep' THEN
    a      := out_props;
    b      := 'dblcTypeRep.KeyValue=';

    SELECT SUBSTR (a, INSTR (a, b) + LENGTH (b), INSTR (SUBSTR (a, INSTR (a, b)), ';') - LENGTH (b) - 1) INTO c FROM DUAL;

    o_id   := TO_NUMBER ('0' || c);

    OPEN qcommand FOR
      SELECT 1 AS cmd_id
            ,   'Object;Name=lbTPGYear;Visible='
             || DECODE (o_id,  3, '1',  4, '1',  '0')
             || ';'
             || 'Reset;'
             || 'Object;Name=meTPGYear;Visible='
             || DECODE (o_id,  3, '1',  4, '1',  '0')
             || ';'
             || 'Reset;'
             || 'Object;Name=dblcOkrug;Enabled='
             || DECODE (o_id,  6, '1',  7, '1',  '0')
             || ';'
             || DECODE (o_id,  6, '',  7, '',  'KeyValue=51;')
               AS cmd_lines
        FROM DUAL;
  ------------------------------------------------------------------------------------------------------------
  ELSIF form_name = 'frmStatPlanKPU' AND form_event = 'OnClick:btnRep' THEN
    a          := out_props;
    b          := 'dblcTypeRep.KeyValue=';

    SELECT SUBSTR (a, INSTR (a, b) + LENGTH (b), INSTR (SUBSTR (a, INSTR (a, b)), ';') - LENGTH (b) - 1) INTO c FROM DUAL;

    rep_type   := TO_NUMBER ('0' || c);
    a          := out_props;
    b          := 'dblcOkrug.KeyValue=';

    SELECT SUBSTR (a, INSTR (a, b) + LENGTH (b), INSTR (SUBSTR (a, INSTR (a, b)), ';') - LENGTH (b) - 1) INTO c FROM DUAL;

    o_id       := TO_NUMBER ('0' || c);
    a          := out_props;
    b          := 'dblcMunicipal.KeyValue=';

    SELECT SUBSTR (a, INSTR (a, b) + LENGTH (b), INSTR (SUBSTR (a, INSTR (a, b)), ';') - LENGTH (b) - 1) INTO c FROM DUAL;

    d_id       := TO_NUMBER ('0' || c);
    a          := out_props;
    b          := 'meTPGYear.Text=';

    SELECT SUBSTR (a, INSTR (a, b) + LENGTH (b), INSTR (SUBSTR (a, INSTR (a, b)), ';') - LENGTH (b) - 1) INTO c FROM DUAL;

    year       := TO_NUMBER ('0' || c);
    execute_plan_kpu_report (rep_type, o_id, d_id, year, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TLISTSDISPATCHSERTIF' AND form_event = 'SET_ID' THEN
    OPEN qcommand FOR SELECT 1 AS cmd_id, 'Object;Name=Self;SearchListDisp=1;' AS cmd_lines FROM DUAL;
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TLISTSADJUSTINSTR' AND form_event = 'SET_ID' THEN
    OPEN qcommand FOR SELECT 1 AS cmd_id, 'Object;Name=Self;SearchListDisp=1;' AS cmd_lines FROM DUAL;
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_name) = 'FRMF116' THEN
    do_for_frmf116 (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF formclassname IN
          ('TListsFreeFloor_K3'
          ,'TKursLists'
          ,'TListsAffaire_K3'
          ,'TListsSertif'
          ,'TListsOrders_K3'
          ,'TListsRents'
          ,'TListsDecl'
          ,'TListsProject'
          ,'TListsPrjRent'
          ,'TListsDecree'
          ,'TListsFind'
          ,'TLists_onFormCommand'
          ,'TListsBGReports'
          ,'TListsPlanKPU'
          ,'TKursListsWithOps') THEN
    do_for_tkurslists (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF form_name = 'frmFLK' THEN
    do_for_frmflk (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF form_name = 'frmAOp' THEN
    do_for_frmaop (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF form_name = 'frm2AOp' THEN
    do_for_frm2aop (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF form_name = 'frm_lk_rep' THEN
    do_for_frm_lk_rep (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF form_name = 'frmMOSp' THEN
    do_for_frmmosp (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF form_name = 'TLists_ARS' THEN
    do_for_tkurslists_ars (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF form_name = 'Kurs_DatMod' THEN
    do_for_kurs_datmod (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF form_name = 'frmPlanKPUPrior' THEN
    do_for_frmplankpuprior (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF formclassname = 'TfmXLRepG2' THEN
    do_for_tfmxlrepg2 (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TAFFAIR' THEN
    do_for_taffair (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFMKPUFAM' THEN
    do_for_tfmkpufam (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFRMREFDC' AND UPPER (form_event) = 'PRINT_REDEMPTION_DC' THEN
    do_report (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TORDERS' AND UPPER (form_event) = 'PRINT_REDEMPTION_ORDER' THEN
    do_report (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TORDERS' AND UPPER (form_event) = 'PRINT_AGREE' THEN
    do_report (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TPROJECTDECL' THEN
    do_for_tprojectdecl (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TLISTCONDS' THEN
    do_for_tlistconds (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_name) = 'FRMTESTRIGTHGRID' THEN
    do_for_frmtestrigthgrid (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TDMREPORTER' THEN
    do_for_tdmreporter (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFREEFLOOR' THEN
    do_for_tfreefloor (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFRMORDCLR' THEN
    do_for_tfrmordclr (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_name) = 'FRMYOUNGFAM' THEN
    do_for_frmyoungfam (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF formclassname = 'TDecree' THEN
    do_for_tdecree (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_name) = 'FRMPERMIT' THEN
    do_for_frmpermit (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TDECLARATION' THEN
    do_for_tdeclaration (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_name) = 'FRMDECLDATE' THEN
    do_for_frmdecldate (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_name) = 'FRMTYPE2' THEN -- 10.09.2008 Anissimova
    do_for_frmtype2 (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_name) = 'FRMGGK' THEN -- 09.02.2009 Anissimova
    do_for_frmggk21 (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  ------------------------------------------------------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TORDERS' --AND UPPER (form_event) IN ('FORMCREATE', 'SET_ID', 'MENUCOMMANDACTION')
                                           THEN
    do_for_torders (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_name) = 'FRMSCALC' THEN
    do_for_frmscalc (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFRMCHILDNORMAL' AND UPPER (form_name) = 'FRMCALCYEAR' THEN
    do_for_frmcalcyear (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFRMCHILDNORMAL' AND UPPER (form_name) = 'FRMKPU_COURT' THEN
    do_for_frmkpu_court (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFRMCHILDNORMAL' AND UPPER (form_name) = 'FRMORDER_COURT' THEN
    do_for_frmorder_court (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFRMCHILDNORMAL' AND UPPER (SUBSTR (form_name, 1, 10)) = 'FRMIPOTEKA' THEN
    do_for_frmipoteka (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFRMCHILDNORMAL' AND UPPER (SUBSTR (form_name, 1, 9)) = 'FRMIP_DOG' THEN
    do_for_frmip_dog (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_name) = 'FRMRESN' THEN
    do_for_frmresn (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFRMCHILDNORMAL' AND UPPER (form_name) = '_FMXPORDER' THEN
    do_for_fmxporder (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFRMCHILDNORMAL' AND UPPER (form_name) = '_FMDELDOG' THEN
    do_for_tfrmdeldog (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFRMCHILDNORMAL' AND UPPER (form_name) = 'FRMPLANEXCL' THEN
    do_for_frmplanexcl (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFRMCHILDNORMAL' AND UPPER (form_name) = 'AF_SUBLEASE' THEN
    do_for_af_sublease (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFRMCHILDNORMAL' AND UPPER (form_name) = 'AF_FRAUD' THEN
    do_for_af_fraud (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (formclassname) = 'TFRMCHILDNORMAL' AND UPPER (form_name) = 'FRMRP_DEL_ORDER' THEN
    exec_do_prc ('kursiv.do_for_frmrp_del_order', formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFRMCHILDNORMAL' AND UPPER (form_name) = 'FRM_KPR' THEN
    do_for_frm_kpr (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFRMCHILDNORMAL' AND UPPER (form_name) = 'FRM_DECL_CP' THEN
    exec_do_prc ('kursiv.do_for_frm_decl_cp', formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_name) = 'FRM_SUBSID' THEN
    do_for_frm_subsid (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_name) IN ('FRMVYVREPRESULT', 'FRMVYVREPUSERS') AND (UPPER (kurs3_var.product_name) = 'KURS3') THEN
    do_for_verify_rep (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  ELSIF UPPER (form_name) = 'FRM_LK_UR_REP' THEN
    do_for_frm_lk_ur_rep (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFRMCHILDNORMAL' AND UPPER (form_name) = 'FRMDOCPOOR' THEN  
    do_for_frmDocPoor (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFRMCHILDNORMAL' THEN
    do_for_tfrmchildnormal (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TFRMCHILD' THEN
    do_for_tfrmchild (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TCHANY' AND UPPER (form_name) = 'OCHCITYPROG' THEN
    do_for_tkurslists (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TCHANY' AND UPPER (form_name) = 'OCHTRAP' THEN
    do_for_tkurslists (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_name) = 'FRMPARAMKPI' AND UPPER (form_event) = 'ONCLICK:BUTTON1' THEN -- простановка Параметров Выписки
    do_for_torders (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (kurs3_var.product_name) = 'ARMREESTR' THEN
    on_form_command_reestr (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------
  ELSIF UPPER (form_class_name) = 'TVERIFY' THEN
    do_for_TVerify (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------     
   ELSIF UPPER (form_class_name) = 'TFRMUFRS' THEN
   DO_FOR_TFRMUFRS (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  -----------------------------------------------------------------------------------------------------------       
ELSIF UPPER (form_class_name) = 'TFRM_TECHPASPORTACTPRINT' THEN    --печать техпаспорта
     DO_FOR_TECHPASPORTACTPRINT (formclassname, form_name, form_handle, form_event, out_props, qcommand);  
  ELSE
    --    insert into test_kurs3_dict(col1,col2) values(776,formclassname);
    --    commit;
    do_for_default (formclassname, form_name, form_handle, form_event, out_props, qcommand);
  END IF;
END on_form_command_kurs3;
/
