create or replace procedure kursiv.DO_FOR_TECHPASPORTREPORTSPRINT (form_class_name IN     VARCHAR2
                                                  ,form_name       IN     VARCHAR2
                                                  ,form_handle     IN     NUMBER
                                                  ,form_event      IN     VARCHAR2
                                                  ,out_props       IN     VARCHAR2
                                                  ,qcommand        IN OUT pckg_tree.curstype
                                                  ) 
IS  
/* 
351 --ID Отчетa предоставление ж/п  --TPReportGP.rtf
352; --ID Отчетa выдача жителям ТП
353; --ID Отчетa количество ТП в округах
*/    
  TYPE TCommandStrings IS VARRAY(3) OF VARCHAR2(1000);
  TYPE TReportType IS VARRAY(3) OF NUMBER;
 
  Query_sql      TCommandStrings := TCommandStrings('','','');
  ReportStep     TCommandStrings := TCommandStrings('qHeader','qBody','qFooter');
  SostZas        TCommandStrings := TCommandStrings('Все квартиры в доме','Распределенные квартиры','');
  Rep1Where      TCommandStrings := TCommandStrings('free_space_status in (1,2,4,5)','(((factory_rights=30) and (free_space_status=4)) or ((factory_rights<>30) and (free_space_status=2)))','');
  l_rep_type VARCHAR2(3);  

  l_TPrptType Integer;
  l_PlanYear  VARCHAR2(5);
  
  l_SostZas Integer ;
  l_Okrug_id Integer ;
  l_Street_id Integer;
  l_Building_id Integer;

  v_CreateQuery_str VARCHAR2(200) := 
    'CreateObject;ClassName=TOraQuery;Owner=frmPrintTPReports;Name=#;SQL=;' ;
  v_Query_sql VARCHAR2(1000) := '';

  ReportType     constant TReportType := TReportType(351,352,353);
  c_end_sql      constant VARCHAR2(20) := 'EndSQL;Active=1;';
  c_str_for_repl constant VARCHAR2(1) := '#';
  

BEGIN 
    IF form_event <> 'PRINT' THEN    
         exec_do_prc ('kursiv.do_for_default', form_class_name, form_name, form_handle, form_event, out_props, qcommand);
         return;
    END IF;
     
       l_TPrptType   := get_id_param ('TTPREPORTDIALOG.TPRPTTYPE', out_props);  
       l_PlanYear    := get_id_param_char ('TTPREPORTDIALOG.PLANYEAR', out_props);
       l_SostZas     := get_id_param ('TTPREPORTDIALOG.SOSTZAS', out_props);
       l_Okrug_id    := get_id_param_char ('TTPREPORTDIALOG.OKRUG_ID', out_props);        
       l_Street_id   := get_id_param_char ('TTPREPORTDIALOG.STREET_ID', out_props);        
       l_Building_id := get_id_param_char ('TTPREPORTDIALOG.BUILDING_ID', out_props); 
                   
 --тип документа (ид в таблице  LIST_RTF)       
       l_rep_type := to_char(ReportType(l_TPrptType));
 
  
    case l_TPrptType   
       when 1 then    --Отчет предоставление ж/п , l_rep_type=351
         --Report Header
       Query_sql(1) := 'SELECT '''||l_PlanYear||' год'' as A1,okrug as A2,addr_s as A3, addr as A4,'''||SostZas(l_SostZas)||''' as A5'||
                        ' from KURS3.V_TP_REPORTS_GN_HEADER where  building_id ='||l_Building_id;
  
          --Report Body
         Query_sql(2) := 'select TO_CHAR(rownum) as A1, ANUM as A2, o_name as A3, TO_CHAR(resolution_num) as A4, TO_CHAR(resolution_date,''DD.MM.YYYY'') as A5,'||
                         ' cl_11_short_name2 as A6, tp_from as A7, tp_to as A8, department_who as A9 from KURS3.v_tp_reports_gn  where  building_id ='||l_Building_id||
                      --нет данных   
                      -- ' and INSTR(NVL(PLAN_YEARS,'' ''),'''||l_PlanYear||''')>0'|| 
                         ' and '||Rep1Where(l_SostZas); 
         --Report Footer
         Query_sql(3) :=  'select '' '' as A1 from DUAL ';
       when 2 then     --Отчет выдача жителям ТП
         --Report Header 
         Query_sql(1) := 'select '''||l_PlanYear||''' as A1 from DUAL ';
         --Report Body
         Query_sql(2) :=  'select ''B'' as A1 from DUAL ';
         --Report Footer
         Query_sql(3) :=  'select ''F'' as A1 from DUAL ';
       when 3 then NULL; --Отчет количество ТП в округах
         --Report Header 
         Query_sql(1) := 'select '''||l_PlanYear||''' as A1 from DUAL ';
         --Report Body
         Query_sql(2) :=  'select ''B'' as A1 from DUAL ';
         --Report Footer
         Query_sql(3) :=  'select '' '' as A1 from DUAL ';
   end case;    
                          
        OPEN qcommand FOR 
            SELECT * FROM (
                               SELECT 1 AS cmd_id, 'LoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL 
                              union  
                                SELECT 2 AS cmd_id,
                                            'CreateObject;ClassName=TfmRepRTF;Owner=Application;Name=frmPrintTPReports;'
                                            || 'Caption=Печать документа ;TypeReport='||l_rep_type||';Value_ID=1' 
                                            || ';'AS cmd_lines  FROM DUAL
                  UNION
                  SELECT 3 AS cmd_id,  replace( v_CreateQuery_str,c_str_for_repl,ReportStep(1)) AS cmd_lines FROM DUAL
                  UNION
                  SELECT 4 AS cmd_id, Query_sql(1) AS cmd_lines FROM DUAL
                  UNION
                  SELECT 5 AS cmd_id, c_end_sql AS cmd_lines FROM DUAL
                  UNION
                  SELECT 6 AS cmd_id, replace(v_CreateQuery_str,c_str_for_repl,ReportStep(2)) AS cmd_lines FROM DUAL
                  UNION
                  SELECT 7 AS cmd_id,  Query_sql(2) AS cmd_lines FROM DUAL
                  UNION
                  SELECT 8 AS cmd_id, c_end_sql AS cmd_lines FROM DUAL
                  UNION
                  SELECT 9 AS cmd_id,  replace( v_CreateQuery_str,c_str_for_repl,ReportStep(3)) AS cmd_lines FROM DUAL
                  UNION
                  SELECT 10 AS cmd_id,  Query_sql(3) AS cmd_lines FROM DUAL
                  UNION
                  SELECT 11 AS cmd_id, c_end_sql AS cmd_lines FROM DUAL
               UNION  
                  SELECT 12 AS cmd_id ,'Window;Name=frmPrintTPReports;AddHeader=qHeader;AddBody=qBody;AddFooter=qFooter;StartReport=1;Free=;' AS cmd_lines
                    FROM DUAL                        
                    UNION         
                     SELECT 13 AS cmd_id, 'UnLoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL
                              )                          
             ORDER BY cmd_id;            

                  
END;
/
