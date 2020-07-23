CREATE OR REPLACE procedure KURSIV.DO_FOR_TECHPASPORTACTPRINT (form_class_name IN     VARCHAR2
                                                  ,form_name       IN     VARCHAR2
                                                  ,form_handle     IN     NUMBER
                                                  ,form_event      IN     VARCHAR2
                                                  ,out_props       IN     VARCHAR2
                                                  ,qcommand        IN OUT pckg_tree.curstype
                                                  ) 
IS
    l_t_doc_id      NUMBER; 
    l_doc_type_id NUMBER;  
    l_rep_type     number;    
    l_wp_link_id NUMBER; 
BEGIN 
    IF form_event = 'PRINT' THEN    
       l_t_doc_id   := get_id_param_char ('TFRM_TECHPASPORTACTPRINT.TRAFFICDOC_ID', out_props);  
       l_doc_type_id  := get_id_param_char ('TFRM_TECHPASPORTACTPRINT.DOCTYPE_ID', out_props);   
       l_wp_link_id  := get_id_param_char ('TFRM_TECHPASPORTACTPRINT.WORKPLACELINK_ID', out_props);        
       --тип документа (ид в таблице  LIST_RTF)
       select decode( l_doc_type_id, 1,340,2,341,-1 )   into  l_rep_type  from dual;     
                              
        OPEN qcommand FOR 
            SELECT * FROM (
                               SELECT 1 AS cmd_id, 'LoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL 
                              union  
                                SELECT 2 AS cmd_id,
                                            'CreateObject;ClassName=TfmRepRTF;Owner=Application;Name=frmPrintActTP;'
                                            || 'Caption=Печать документа ;TypeReport='||to_char(l_rep_type)||';Value_ID=' || TO_CHAR ( l_t_doc_id) 
                                            || ';'AS cmd_lines  FROM DUAL
                 UNION
                  SELECT 3 AS cmd_id, 'CreateObject;ClassName=TOraQuery;Owner=frmPrintActTP;Name=qHeader;SQL=;' AS cmd_lines FROM DUAL
                  UNION
                  SELECT 4 AS cmd_id, 'select doc_num as A1,doc_date as A2 from V_PASPORT_SIGNER where   TRAFFIC_DOC_ID= ' || TO_CHAR ( l_t_doc_id) AS cmd_lines FROM DUAL
                  UNION
                  SELECT 5 AS cmd_id, 'EndSQL;Active=1;' AS cmd_lines FROM DUAL
                  UNION
                  SELECT 6 AS cmd_id, 'CreateObject;ClassName=TOraQuery;Owner=frmPrintActTP;Name=qBody;SQL=;' AS cmd_lines FROM DUAL
                  UNION
                  SELECT 7 AS cmd_id, 'select  ROWNUM A1,  A2,  A3,  A4,  A5 from  V_PASPORT_BODY  where  TRAFFIC_DOC_ID=  ' || TO_CHAR ( l_t_doc_id)||
                                                    ' and  WORK_PLACE_LINK_ID='||TO_CHAR ( l_wp_link_id)  AS cmd_lines FROM DUAL
                  UNION
                  SELECT 8 AS cmd_id, 'EndSQL;Active=1;' AS cmd_lines FROM DUAL
                  UNION
                  SELECT 9 AS cmd_id, 'CreateObject;ClassName=TOraQuery;Owner=frmPrintActTP;Name=qFooter;SQL=;' AS cmd_lines FROM DUAL
                  UNION
                  SELECT 10 AS cmd_id, 'select DOLGNOST A1, OPERATOR A2, FIO A3, DOLGNOST_TO A4, P_SERIA A5,  P_NOMER A6,   P_DATA A7,P_VIDAN  A8,'||
                                                            ' D_NOMER A9,  D_VIDAN A10,  D_DATA A11    from V_PASPORT_SIGNER where   TRAFFIC_DOC_ID= ' ||
                                                              TO_CHAR (l_t_doc_id) AS cmd_lines FROM DUAL
                  UNION
                  SELECT 11 AS cmd_id, 'EndSQL;Active=1;' AS cmd_lines FROM DUAL
                  UNION  
                  SELECT 12 AS cmd_id ,'Window;Name=frmPrintActTP;AddHeader=qHeader;AddBody=qBody;AddFooter=qFooter;StartReport=1;Free=;' AS cmd_lines
                    FROM DUAL                        
                    UNION         
                     SELECT 13 AS cmd_id, 'UnLoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL
                              )                          
             ORDER BY cmd_id;            
    ELSE
        exec_do_prc ('kursiv.do_for_default', form_class_name, form_name, form_handle, form_event, out_props, qcommand);
    END IF;
                  
END;
/