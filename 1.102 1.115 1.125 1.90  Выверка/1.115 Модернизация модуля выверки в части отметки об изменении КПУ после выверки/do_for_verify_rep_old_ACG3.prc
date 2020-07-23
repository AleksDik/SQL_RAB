CREATE OR REPLACE PROCEDURE kursiv.do_for_verify_rep (form_class_name IN     VARCHAR2
                                                     ,form_name       IN     VARCHAR2
                                                     ,form_handle     IN     NUMBER
                                                     ,form_event      IN     VARCHAR2
                                                     ,out_props       IN     VARCHAR2
                                                     ,qcommand        IN OUT pckg_tree.curstype
                                                     ) IS
  --
  --  Отчеты по Выверке
  --
  --  08.12.2011  BlackHawk  Подправил шапку в отчетах
  --
  p_date_test  DATE;
  p_date_begin VARCHAR2 (10);
  p_date_end   VARCHAR2 (10);
BEGIN
  IF UPPER (form_event) = 'DO:MIVYVREPRESULT' THEN
    OPEN qcommand FOR
        SELECT *
          FROM (SELECT 1 AS cmd_id
                      ,   'CreateObject;ClassName=TfrmChildNormal;Owner=Self;Name=frmVyvRepResult;'
                       || 'Caption=Отчет по результатам выверки;'
                       || 'Width=450;Height=250;BorderIcons=[biSystemMenu];BorderStyle=3;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 4 AS cmd_id
                      ,   'Reset;CreateObject;ClassName=TLabel;Name=lbl_total;'
                       || 'Owner=frmVyvRepResult;Parent=frmVyvRepResult;'
                       || 'Caption=Отчет по результатам выверки;Visible=0;'
                       || 'Left=10;Top=5;Font.Style=[fsBold];'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 5 AS cmd_id
                      ,   'CreateObject;ClassName=TLabel;Name=lbOkrug;'
                       || 'Caption=Округ:;'
                       || 'Left=10;Top=33;'
                       || 'Owner=frmVyvRepResult;Parent=frmVyvRepResult;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 6.1 AS cmd_id, 'CreateObject;ClassName=TOraQuery;Owner=frmVyvRepResult;Name=q_Okrug;SQL=;' FROM DUAL
                UNION ALL
                SELECT 6.2 AS cmd_id
                      ,'select 0 as id, ''Все округа'' as name from dual union all SELECT OKRUG_ID ID, NAME FROM KURS3.AREA WHERE OKRUG_ID BETWEEN 51 AND 60'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 6.3 AS cmd_id, 'EndSQL;Active=1;' AS cmd_lines FROM DUAL
                UNION ALL
                SELECT 6.4 AS cmd_id
                      ,'CreateObject;ClassName=TDataSource;Owner=frmVyvRepResult;Name=ds_Okrug;DataSet=q_Okrug;Reset;'
                       || 'CreateObject;ClassName=TRxDBLookupCombo;Owner=frmVyvRepResult;Name=cmbOkrug;Parent=frmVyvRepResult;Height=21;Left=65;Top=30;Width=150;'
                       || 'LookupSource=ds_Okrug;LookupField=ID;LookupDisplay=NAME;EmptyValue=;EscapeClear=0;'
                       || 'KeyValue=0;Enabled=1;RetProp=KeyValue;RetProp=Text;'
                         AS cmd_lines
                  FROM DUAL
                --Блок диапазона дат
                UNION ALL
                SELECT 6.52 AS cmd_id
                      ,'Reset;CreateObject;ClassName=TLabel;Name=lbl_begin_date;Owner=frmVyvRepResult;Parent=frmVyvRepResult;Caption=в период с;'
                       || 'Left=10;Top=70;Font.Style=[fsBold];'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 6.54 AS cmd_id
                      ,   'Reset;CreateObject;ClassName=TDateEdit;Owner=frmVyvRepResult;Name=tde_begin_date;Parent=frmVyvRepResult;'
                       || 'Enabled=1;Left=95;Top=67;Width=100;YearDigits=1;'
                       || 'Text='
                       || TO_CHAR (TRUNC (SYSDATE) - 1, 'dd.mm.yyyy')
                       || ';'
                       || 'RetProp=Text;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 6.56 AS cmd_id
                      ,'Reset;CreateObject;ClassName=TLabel;Name=lbl_end_date;Owner=frmVyvRepResult;Parent=frmVyvRepResult;Caption=по;'
                       || 'Left=210;Top=70;Font.Style=[fsBold];'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 6.58 AS cmd_id
                      ,   'Reset;CreateObject;ClassName=TDateEdit;Owner=frmVyvRepResult;Name=tde_end_date;Parent=frmVyvRepResult;'
                       || 'Enabled=1;Left=240;Top=67;Width=100;YearDigits=1;'
                       || 'Text='
                       || TO_CHAR (TRUNC (SYSDATE) - 1, 'dd.mm.yyyy')
                       || ';'
                       || 'RetProp=Text;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 7 AS cmd_id
                      ,   'CreateObject;ClassName=TCheckBox;Name=chbList;'
                       || 'Caption=Сформировать список адресов;'
                       || 'Left=10;Top=110;Width=350;'
                       || 'Owner=frmVyvRepResult;Parent=frmVyvRepResult;'
                       || 'Enabled=1;' -- || decode(nvl(kurs3_var.get_okrug_id, 61), 61,0, 1) || ';'
                       || 'RetProp=Checked;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 8 AS cmd_id
                      ,   'Reset;CreateObject;ClassName=TBitBtn;'
                       || 'Owner=frmVyvRepResult;Parent=frmVyvRepResult;Name=btnOk;Kind=1;Caption=ОК;'
                       || 'Left=125;Top=150;Width=90;Height=24;Event=OnClick;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 9 AS cmd_id
                      ,   'Reset;CreateObject;ClassName=TBitBtn;'
                       || 'Owner=frmVyvRepResult;Parent=frmVyvRepResult;Name=btnCancel;Kind=2;Caption=Отмена;'
                       || 'Left=235;Top=150;Width=90;Height=24;Cancel=1;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 99 AS cmd_id, 'Object;Name=frmVyvRepResult;ShowModal=1;Free=;' || 'RetProp=Tag;' AS cmd_lines FROM DUAL)
      ORDER BY cmd_id;
  ELSIF UPPER (form_event) = 'DO:MIVYVREPUSERS' THEN
    OPEN qcommand FOR
        SELECT *
          FROM (SELECT 1 AS cmd_id
                      ,   'CreateObject;ClassName=TfrmChildNormal;Owner=Self;Name=frmVyvRepUsers;'
                       || 'Caption=Отчет по операторам выверки;'
                       || 'Width=450;Height=170;BorderIcons=[biSystemMenu];BorderStyle=3;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 4 AS cmd_id
                      ,   'Reset;CreateObject;ClassName=TLabel;Name=lbl_total;'
                       || 'Owner=frmVyvRepUsers;Parent=frmVyvRepUsers;'
                       || 'Caption=Отчет по операторам выверки;Visible=0;'
                       || 'Left=10;Top=5;Font.Style=[fsBold];'
                         AS cmd_lines
                  FROM DUAL
                --Блок диапазона дат
                UNION ALL
                SELECT 6.52 AS cmd_id
                      ,'Reset;CreateObject;ClassName=TLabel;Name=lbl_begin_date;Owner=frmVyvRepUsers;Parent=frmVyvRepUsers;Caption=в период с;'
                       || 'Left=10;Top=30;Font.Style=[fsBold];'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 6.54 AS cmd_id
                      ,   'Reset;CreateObject;ClassName=TDateEdit;Owner=frmVyvRepUsers;Name=tde_begin_date;Parent=frmVyvRepUsers;'
                       || 'Enabled=1;Left=95;Top=27;Width=100;YearDigits=1;'
                       || 'Text='
                       || TO_CHAR (TRUNC (SYSDATE) - 1, 'dd.mm.yyyy')
                       || ';'
                       || 'RetProp=Text;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 6.56 AS cmd_id
                      ,'Reset;CreateObject;ClassName=TLabel;Name=lbl_end_date;Owner=frmVyvRepUsers;Parent=frmVyvRepUsers;Caption=по;'
                       || 'Left=210;Top=30;Font.Style=[fsBold];'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 6.58 AS cmd_id
                      ,   'Reset;CreateObject;ClassName=TDateEdit;Owner=frmVyvRepUsers;Name=tde_end_date;Parent=frmVyvRepUsers;'
                       || 'Enabled=1;Left=240;Top=27;Width=100;YearDigits=1;'
                       || 'Text='
                       || TO_CHAR (TRUNC (SYSDATE) - 1, 'dd.mm.yyyy')
                       || ';'
                       || 'RetProp=Text;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 8 AS cmd_id
                      ,   'Reset;CreateObject;ClassName=TBitBtn;'
                       || 'Owner=frmVyvRepUsers;Parent=frmVyvRepUsers;Name=btnOk;Kind=1;Caption=ОК;'
                       || 'Left=125;Top=80;Width=90;Height=24;Event=OnClick;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 9 AS cmd_id
                      ,   'Reset;CreateObject;ClassName=TBitBtn;'
                       || 'Owner=frmVyvRepUsers;Parent=frmVyvRepUsers;Name=btnCancel;Kind=2;Caption=Отмена;'
                       || 'Left=235;Top=80;Width=90;Height=24;Cancel=1;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 99 AS cmd_id, 'Object;Name=frmVyvRepUsers;ShowModal=1;Free=;' || 'RetProp=Tag;' AS cmd_lines FROM DUAL)
      ORDER BY cmd_id;
  ELSIF ( (UPPER (form_name) = 'FRMVYVREPRESULT') AND (UPPER (form_event) = 'ONCLICK:BTNOK')) THEN
    -- подстраховка от криво введенных дат
    BEGIN
      p_date_test    := TO_DATE (get_id_param_char ('tde_begin_date.Text', out_props), 'dd.mm.yyyy');
      p_date_begin   := TO_CHAR (p_date_test, 'dd.mm.yyyy');
    EXCEPTION
      WHEN OTHERS THEN
        p_date_begin   := TO_CHAR (SYSDATE, 'dd.mm.yyyy');
    END;

    BEGIN
      p_date_test   := TO_DATE (get_id_param_char ('tde_end_date.Text', out_props), 'dd.mm.yyyy');
      p_date_end    := TO_CHAR (p_date_test, 'dd.mm.yyyy');
    EXCEPTION
      WHEN OTHERS THEN
        p_date_end   := TO_CHAR (SYSDATE, 'dd.mm.yyyy');
    END;

    OPEN qcommand FOR
        SELECT *
          FROM (SELECT 1 AS cmd_id, 'LoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL
                UNION ALL
                SELECT 2 AS cmd_id
                      ,'CreateObject;ClassName=TfmXLRepG2;Owner=Application;Name=repVyvRepResult;'
                       || 'Caption=Отчет по результатам выверки;TypeReport=320;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 3 AS cmd_id
                      ,   'CreateObject;ClassName=TOraStoredProc;Owner=repVyvRepResult;Name=sq;StoredProcName=k3_verify_rep_vyv_result;Params=;'
                       || 'Param1=;PN=OKRUG_V_;Val='
                       || get_id_param ('cmbOkrug.KeyValue', out_props)
                       || ';Param2=;PN=BEGIN_DATE_;Val='
                       || p_date_begin
                       || ';Param3=;PN=END_DATE_;Val='
                       || p_date_end
                       || ';Param4=;PN=TYPE_;Val=1;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 5.1 AS cmd_id, 'CreateObject;ClassName=TOraQuery;Owner=repVyvRepResult;Name=sq_period;SQL=;' AS cmd_lines FROM DUAL
                UNION ALL
                SELECT 5.2 AS cmd_id
                      ,   'select ''Отчет по результатам выверки. ИС "КУРС".'
                       --||chr(13)||chr(10)|| 'Данные количеству выверенных пакетов документов. '
                       || CHR (13)
                       || CHR (10)
                       || 'Округ адреса: '
                       || get_id_param_char ('cmbOkrug.Text', out_props)
                       || '.  Период расчета: с '
                       || p_date_begin
                       || ' по '
                       || p_date_end
                       || ''' as periodstr '
                       || ' from dual '
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 5.3 AS cmd_id, 'EndSQL;' AS cmd_lines FROM DUAL
                UNION ALL
                SELECT 6 AS cmd_id
                      ,   'CreateObject;ClassName=TOraStoredProc;Owner=repVyvRepResult;Name=vr;StoredProcName=k3_verify_rep_vyv_result;Params=;'
                       || 'Param1=;PN=OKRUG_V_;Val='
                       ||get_id_param ('cmbOkrug.KeyValue', out_props)
                       || ';Param2=;PN=BEGIN_DATE_;Val='
                       || DECODE (get_id_param_char ('chbList.Checked', out_props), '1', p_date_begin, '') --передадим null дату, если без галочки "Список"
                       || ';Param3=;PN=END_DATE_;Val='
                       || p_date_end
                       || ';Param4=;PN=TYPE_;Val=2;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 7 AS cmd_id
                      ,   'Window;Name=repVyvRepResult;'
                       || 'AddBodyQuery=sq;TempG2DS=0;TempG2DataSource.Range=OrdersRange;'
                       || 'AddBodyQuery=vr;TempG2DS=1;TempG2DataSource.Range=VypRange;'
                       || 'AddMasterQuery=sq_period;'
                       || 'StartReport=1;'
                       --|| 'AddBodyQuery=vr;TempG2DS=1;TempG2DataSource.Range=VypRange;'
                       --||'startreport=1;'
                       || 'Free=;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 8 AS cmd_id, 'UnLoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL)
      ORDER BY cmd_id;
  ELSIF ( (UPPER (form_name) = 'FRMVYVREPUSERS') AND (UPPER (form_event) = 'ONCLICK:BTNOK')) THEN
    -- подстраховка от криво введенных дат
    BEGIN
      p_date_test    := TO_DATE (get_id_param_char ('tde_begin_date.Text', out_props), 'dd.mm.yyyy');
      p_date_begin   := TO_CHAR (p_date_test, 'dd.mm.yyyy');
    EXCEPTION
      WHEN OTHERS THEN
        p_date_begin   := TO_CHAR (SYSDATE, 'dd.mm.yyyy');
    END;

    BEGIN
      p_date_test   := TO_DATE (get_id_param_char ('tde_end_date.Text', out_props), 'dd.mm.yyyy');
      p_date_end    := TO_CHAR (p_date_test, 'dd.mm.yyyy');
    EXCEPTION
      WHEN OTHERS THEN
        p_date_end   := TO_CHAR (SYSDATE, 'dd.mm.yyyy');
    END;

    OPEN qcommand FOR
        SELECT *
          FROM (SELECT 1 AS cmd_id, 'Reset;LoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL
                UNION ALL
                SELECT 2 AS cmd_id
                      ,'CreateObject;ClassName=TfmXLRepG2;Owner=Application;Name=repVyvRepUsers;'
                       || 'Caption=Отчет по операторам выверки;TypeReport=321;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 3 AS cmd_id
                      ,   'CreateObject;ClassName=TOraStoredProc;Owner=repVyvRepUsers;Name=sq;StoredProcName=k3_verify_rep_vyv_users;Params=;'
                       || 'Param1=;PN=BEGIN_DATE_;Val='
                       || p_date_begin
                       || ';Param2=;PN=END_DATE_;Val='
                       || p_date_end
                       || ';Param3=;PN=TYPE_;Val=1;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 5.1 AS cmd_id, 'CreateObject;ClassName=TOraQuery;Owner=repVyvRepUsers;Name=sq_period;SQL=;' AS cmd_lines FROM DUAL
                UNION ALL
                SELECT 5.2 AS cmd_id
                      ,   'select ''Отчет по операторам выверки. ИС "КУРС".'
                       || CHR (13)
                       || CHR (10)
                       || 'Период расчета: с '
                       || p_date_begin
                       || ' по '
                       || p_date_end
                       || ''' as periodstr '
                       || ' from dual '
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 5.3 AS cmd_id, 'EndSQL;' AS cmd_lines FROM DUAL
                UNION ALL
                SELECT 7 AS cmd_id
                      ,   'Window;Name=repVyvRepUsers;'
                       || 'AddBodyQuery=sq;TempG2DS=0;TempG2DataSource.Range=OrdersRange;'
                       || 'AddMasterQuery=sq_period;'
                       || 'StartReport=1;'
                       || 'Free=;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 8 AS cmd_id, 'UnLoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL)
      ORDER BY cmd_id;
  --------------------------------------------------------------------------
  ELSE
    do_for_default (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  END IF;
END;
 
/
