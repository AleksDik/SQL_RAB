CREATE OR REPLACE VIEW scan.V_KURS3_SCAN_LIST AS
SELECT --
         --  11.10.2011  BlackHawk  Создание
         --  16.11.2011  BlackHawk  Добавил last_user и last_change
         --  08.12.2011  BlackHawk  Добавил условие на row_status
         --  19.11.2013  DIK Добавление полей   affair_change  viverka_date  is_affair_change_after
         --
         dl.user_id
        ,dl.list_cod
        ,dl.list_num
        ,k3_get_read_only (dl.list_cod, ed.delo_id) read_only
        ,dl.note
        ,ed.delo_id AS affair_id
        ,ed.delo_id
        ,ed.object_id
        ,ed.object_type_id
        ,ed.delo_comment
        ,ed.delo_addr AS adr
        ,ed.unom
        ,ed.unkv
        ,ed.scan_date AS scan_date
        ,get_classifier_kurs3 (127, ed.status) AS status
        ,DECODE (eda.object_rel_id, NULL, 'Нет', 'Да') AS relation
        ,ed.npp_first AS npp
        ,ed.delo_num AS scan_delo_num
        ,ed.delo_date AS scan_delo_date
        ,DECODE (eda.object_rel_id, NULL, '', k3_get_affair_num_fmt (eda.object_rel_id, 1)) AS k3_delo_num
        ,DECODE (eda.object_rel_id, NULL, '', get_classifier_kurs3 (70, k3_get_affair_status (eda.object_rel_id, 1))) AS k3_delo_status
        ,k3_get_user_name_fmt (ed.user_id) AS last_user
        ,ed.last_change
-- 19.11.2013  DIK        
        ,ed.affair_change as affair_change
        ,vd.viverka_date,
        case when ed.status=2 then 
             case when ( NVL(ed.affair_change, cast('01.01.1800' as date)) > NVL(vd.viverka_date, cast('01.01.1800' as date)))
                       and (vd.viverka_date is not null) 
                  then 'Да' else NULL end
             else NULL end as is_affair_change_after
--/ 19.11.2013  DIK        
    FROM scan.ea_delo ed, kurs3.documents_list dl, scan.ea_delo_attr eda ,
         kurs3.V_KURS3_SCAN_VIVERKA_DATE vd -- 19.11.2013  DIK 
    WHERE    dl.list_cod = 51
         AND ed.delo_id = dl.affair_id
         AND ed.object_type_id = 6
         AND ed.delo_id = eda.delo_id(+)
         AND 1 = eda.object_type_id(+)
         AND 1 = eda.row_status(+)
         and ed.delo_id = vd.delo_id(+) -- 19.11.2013  DIK  
         
--GRANT SELECT ON scan.v_kurs3_scan_list TO OKRUG;
--CREATE SYNONYM o51.v_kurs3_scan_list FOR scan.v_kurs3_scan_list;
--CREATE SYNONYM o52.v_kurs3_scan_list FOR scan.v_kurs3_scan_list;
--CREATE SYNONYM o53.v_kurs3_scan_list FOR scan.v_kurs3_scan_list;
--CREATE SYNONYM o54.v_kurs3_scan_list FOR scan.v_kurs3_scan_list;
--CREATE SYNONYM o55.v_kurs3_scan_list FOR scan.v_kurs3_scan_list;
--CREATE SYNONYM o56.v_kurs3_scan_list FOR scan.v_kurs3_scan_list;
--CREATE SYNONYM o57.v_kurs3_scan_list FOR scan.v_kurs3_scan_list;
--CREATE SYNONYM o58.v_kurs3_scan_list FOR scan.v_kurs3_scan_list;
--CREATE SYNONYM o59.v_kurs3_scan_list FOR scan.v_kurs3_scan_list;
--CREATE SYNONYM o60.v_kurs3_scan_list FOR scan.v_kurs3_scan_list;
--CREATE SYNONYM o61.v_kurs3_scan_list FOR scan.v_kurs3_scan_list;;
