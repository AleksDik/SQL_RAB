CREATE OR REPLACE PROCEDURE verify_rep_vyv_result (okrug_v_           NUMBER
                                                        ,begin_date_        VARCHAR2
                                                        ,end_date_          VARCHAR2
                                                        ,cur_        IN OUT kurs3.curstype
                                                        ,type_              NUMBER := 1
                                                        ) AS
--
--  Отчет по результатам выверки, type_: 1 - таблица с количеством, 2 - листинг
--
--  28.11.2011  BlackHawk  Создание
--  07.02.2012  BlackHawk  Добавлен столбец Возвращено
--  20.02.2012  BlackHawk  Добавлен столбец Нечитаемый исходник (bad_source)
--  #28.11.2013 Dikan  добавлены отчеты: type_ 3 = type_ 1 с учетом изменений ДЖП ;  type_ 4 = type_ 2 с учетом изменений ДЖП; (Задача 1.115)
BEGIN
  CASE
    WHEN type_ = 1 THEN
      OPEN cur_ FOR
          SELECT DECODE (okrug_id,  999, 'ИТОГО',  900, '--',  get_okrug_name (okrug_id)) okrug_name
                ,okrug_id
                ,DECODE (okrug_id, 999, SUM (all_count) OVER (PARTITION BY 1), all_count) all_count
                ,DECODE (okrug_id, 999, SUM (with_label) OVER (PARTITION BY 1), with_label) with_label
                ,DECODE (okrug_id, 999, SUM (no_label) OVER (PARTITION BY 1), no_label) no_label
                ,DECODE (okrug_id, 999, SUM (bad_scan) OVER (PARTITION BY 1), bad_scan) bad_scan
                ,DECODE (okrug_id, 999, SUM (vozvrat) OVER (PARTITION BY 1), vozvrat) vozvrat
                ,DECODE (okrug_id, 999, SUM (bad_source) OVER (PARTITION BY 1), bad_source) bad_source
            FROM (  SELECT okrug_id
                          ,COUNT (1) all_count
                          ,SUM (DECODE (status, 2, DECODE (label_type_id, NULL, 0, 1), 0)) with_label
                          ,SUM (DECODE (status, 2, DECODE (label_type_id, NULL, 1, 0), 0)) no_label
                          ,SUM (DECODE (status, 2, to_rescan, 0)) bad_scan
                          ,SUM (CASE WHEN status = 4 THEN 1 ELSE 0 END) vozvrat
                          ,SUM (DECODE (status, 2, to_trash, 0)) bad_source
                      FROM (SELECT num
                                  ,okrug_id
                                  ,label_type_id
                                  ,datetime
                                  ,delo_id
                                  ,status
                                  ,scan.test_bad_docs_in_delo (delo_id, 2) to_rescan
                                  ,scan.test_bad_docs_in_delo (delo_id, 4) to_trash
                              FROM (SELECT ROW_NUMBER () OVER (PARTITION BY l.obj_id ORDER BY l.record_dt) num
                                          ,aff.okrug_id AS okrug_id
                                          ,lb.label_type_id
                                          ,l.record_dt AS datetime
                                          ,ed.delo_id
                                          ,ed.status
                                      FROM scan.ea_delo ed, affair aff, scan.ea_delo_attr eda, verify_filer l, scan.ea_delo_label lb
                                     WHERE     ed.delo_id = eda.delo_id
                                           AND ed.object_type_id = 6
                                           AND eda.object_type_id = 1
                                           AND eda.object_rel_id = aff.affair_id
                                           AND ed.delo_id = l.obj_id
                                           AND l.op_type = 1
                                           AND l.obj_type_id = 9 -- EA_DELO.STATUS
                                           AND ( (ed.status = 2 AND l.new_value = '2') OR (ed.status = 4 AND l.new_value = '4'))
                                           AND lb.delo_id(+) = ed.delo_id)
                             WHERE okrug_id = DECODE (okrug_v_, 0, okrug_id, okrug_v_) AND num = 1
                                   AND datetime BETWEEN TO_DATE (begin_date_, 'dd.mm.yyyy')
                                                    AND TO_DATE (end_date_, 'dd.mm.yyyy') + 1 - 1 / (24 * 60 * 60))
                  GROUP BY okrug_id
                  UNION
                  SELECT 999, 0, 0, 0, 0, 0, 0
                    FROM DUAL
                   WHERE okrug_v_ = 0)
        ORDER BY okrug_id;
    WHEN type_ = 2 THEN
      OPEN cur_ FOR
          SELECT okrug_id
                ,DECODE (okrug_id, 900, 'Не определен', get_okrug_sha (okrug_id)) apart_okrug_name
                ,DECODE (okrug_id, 900, '', get_building_mokrug (building_id, 'SH')) apart_mun_name
                ,delo_addr address_name
                ,scan_date_v delo_date_name
                , (CASE WHEN label_type_id IS NOT NULL THEN 'да' ELSE 'нет' END) exist_label
                ,scan.get_delo_labels_list (delo_id) label_list
            FROM (SELECT v.*
                    FROM (SELECT ROW_NUMBER () OVER (PARTITION BY l.obj_id ORDER BY l.record_dt) num
                                ,aff.okrug_id
                                ,aff.build_id AS building_id
                                ,lb.label_type_id
                                ,l.record_dt AS datetime
                                ,ed.delo_addr
                                ,TO_CHAR (ed.scan_date, 'dd.mm.yyyy') scan_date_v
                                ,ed.delo_id
                            FROM scan.ea_delo ed, affair aff, scan.ea_delo_attr eda, verify_filer l, scan.ea_delo_label lb
                           WHERE     ed.delo_id = eda.delo_id
                                 AND ed.object_type_id = 6
                                 AND eda.object_type_id = 1
                                 AND eda.object_rel_id = aff.affair_id
                                 AND ed.delo_id = l.obj_id
                                 AND l.op_type = 1
                                 AND l.obj_type_id = 9 -- EA_DELO.STATUS
                                 AND l.new_value = '2'
                                 AND ed.status = 2
                                 AND lb.delo_id(+) = ed.delo_id) v
                   WHERE     okrug_id = DECODE (okrug_v_, 0, okrug_id, okrug_v_)
                         AND num = 1
                         AND datetime BETWEEN TO_DATE (begin_date_, 'dd.mm.yyyy') AND TO_DATE (end_date_, 'dd.mm.yyyy') + 1 - 1 / (24 * 60 * 60))
        ORDER BY okrug_id, 3, delo_addr;
--  #28.11.2013 Dikan         
WHEN type_ = 3 THEN
      OPEN cur_ FOR
          SELECT DECODE (okrug_id,  999, 'ИТОГО',  900, '--',  get_okrug_name (okrug_id)) okrug_name
                ,okrug_id
                ,DECODE (okrug_id, 999, SUM (all_count) OVER (PARTITION BY 1), all_count) all_count
                ,DECODE (okrug_id, 999, SUM (with_label) OVER (PARTITION BY 1), with_label) with_label
                ,DECODE (okrug_id, 999, SUM (no_label) OVER (PARTITION BY 1), no_label) no_label
                ,DECODE (okrug_id, 999, SUM (bad_scan) OVER (PARTITION BY 1), bad_scan) bad_scan
                ,DECODE (okrug_id, 999, SUM (vozvrat) OVER (PARTITION BY 1), vozvrat) vozvrat
                ,DECODE (okrug_id, 999, SUM (bad_source) OVER (PARTITION BY 1), bad_source) bad_source
                ,DECODE (okrug_id, 999, SUM (is_affair_change) OVER (PARTITION BY 1), is_affair_change) is_change
            FROM (  SELECT okrug_id
                          ,COUNT (1) all_count
                          ,SUM (DECODE (status, 2, DECODE (label_type_id, NULL, 0, 1), 0)) with_label
                          ,SUM (DECODE (status, 2, DECODE (label_type_id, NULL, 1, 0), 0)) no_label
                          ,SUM (DECODE (status, 2, to_rescan, 0)) bad_scan
                          ,SUM (CASE WHEN status = 4 THEN 1 ELSE 0 END) vozvrat
                          ,SUM (DECODE (status, 2, to_trash, 0)) bad_source
                          ,SUM (is_affair_change) as is_affair_change
                      FROM (SELECT num
                                  ,okrug_id
                                  ,label_type_id
                                  ,datetime
                                  ,delo_id
                                  ,status
                                  ,scan.test_bad_docs_in_delo (delo_id, 2) to_rescan
                                  ,scan.test_bad_docs_in_delo (delo_id, 4) to_trash
                                  ,case when (affair_change > viverka_date) and (status = 2) then 1 else 0 end  as is_affair_change
                              FROM (SELECT ROW_NUMBER () OVER (PARTITION BY l.obj_id ORDER BY l.record_dt) num
                                          ,aff.okrug_id AS okrug_id
                                          ,lb.label_type_id
                                          ,l.record_dt AS datetime
                                          ,ed.delo_id
                                          ,ed.status
                                          ,NVL(ed.affair_change, cast('01.01.1800' as date)) as affair_change
                                          ,NVL(vvd.viverka_date, cast('01.01.1800' as date)) as viverka_date
                                      FROM scan.ea_delo ed, affair aff, scan.ea_delo_attr eda, verify_filer l, scan.ea_delo_label lb,
                                           V_KURS3_SCAN_VIVERKA_DATE vvd --последняя дата установки статуса выверено
                                     WHERE     ed.delo_id = eda.delo_id
                                           AND ed.object_type_id = 6
                                           AND eda.object_type_id = 1
                                           AND eda.object_rel_id = aff.affair_id
                                           AND ed.delo_id = l.obj_id
                                           and l.obj_id = vvd.delo_id(+)
                                           AND l.op_type = 1
                                           AND l.obj_type_id = 9 -- EA_DELO.STATUS
                                           AND ( (ed.status = 2 AND l.new_value = '2') OR (ed.status = 4 AND l.new_value = '4'))
                                           AND lb.delo_id(+) = ed.delo_id)
                             WHERE okrug_id = DECODE (okrug_v_, 0, okrug_id, okrug_v_) AND num = 1
                                   AND datetime BETWEEN TO_DATE (begin_date_, 'dd.mm.yyyy')
                                                    AND TO_DATE (end_date_, 'dd.mm.yyyy') + 1 - 1 / (24 * 60 * 60))
                  GROUP BY okrug_id
                  UNION
                  SELECT 999, 0, 0, 0, 0, 0, 0, 0
                    FROM DUAL
                   WHERE okrug_v_ = 0)
        ORDER BY okrug_id; 
 WHEN type_ = 4 THEN
      OPEN cur_ FOR
      select okrug_id, apart_okrug_name, apart_mun_name, address_name, delo_date_name, exist_label, label_list, d_affair_change, d_affair_change_sort
      FROM
         ( SELECT okrug_id
                ,DECODE (okrug_id, 900, 'Не определен', get_okrug_sha (okrug_id)) apart_okrug_name
                ,DECODE (okrug_id, 900, '', get_building_mokrug (building_id, 'SH')) apart_mun_name
                ,delo_addr address_name
                ,scan_date_v delo_date_name
                , (CASE WHEN label_type_id IS NOT NULL THEN 'да' ELSE 'нет' END) exist_label
                ,scan.get_delo_labels_list (delo_id) label_list
                ,case when (affair_change > viverka_date) then TO_CHAR (affair_change, 'dd.mm.yyyy')  else '' end  as d_affair_change
                ,case when (affair_change > viverka_date) then 1  else 0 end  as d_affair_change_sort
            FROM (SELECT v.*
                    FROM (SELECT ROW_NUMBER () OVER (PARTITION BY l.obj_id ORDER BY l.record_dt) num
                                ,aff.okrug_id
                                ,aff.build_id AS building_id
                                ,lb.label_type_id
                                ,l.record_dt AS datetime
                                ,ed.delo_addr
                                ,TO_CHAR (ed.scan_date, 'dd.mm.yyyy') scan_date_v
                                ,ed.delo_id
                                ,NVL(ed.affair_change, cast('01.01.1800' as date)) as affair_change
                                ,NVL(vvd.viverka_date, cast('01.01.1800' as date)) as viverka_date
                            FROM scan.ea_delo ed, affair aff, scan.ea_delo_attr eda, verify_filer l, scan.ea_delo_label lb,
                             V_KURS3_SCAN_VIVERKA_DATE vvd --последняя дата установки статуса выверено
                           WHERE     ed.delo_id = eda.delo_id
                                 AND ed.object_type_id = 6
                                 AND eda.object_type_id = 1
                                 AND eda.object_rel_id = aff.affair_id
                                 AND ed.delo_id = l.obj_id
                                 and l.obj_id = vvd.delo_id(+)
                                 AND l.op_type = 1
                                 AND l.obj_type_id = 9 -- EA_DELO.STATUS
                                 AND l.new_value = '2'
                                 AND ed.status = 2
                                 AND lb.delo_id(+) = ed.delo_id) v
                   WHERE     okrug_id = DECODE (okrug_v_, 0, okrug_id, okrug_v_)
                         AND num = 1
                         AND datetime BETWEEN TO_DATE (begin_date_, 'dd.mm.yyyy') AND TO_DATE (end_date_, 'dd.mm.yyyy') + 1 - 1 / (24 * 60 * 60))
                         )
        ORDER BY d_affair_change_sort, okrug_id, 3, address_name;              
  END CASE;
-- / #28.11.2013 Dikan   
END verify_rep_vyv_result;
 
/
