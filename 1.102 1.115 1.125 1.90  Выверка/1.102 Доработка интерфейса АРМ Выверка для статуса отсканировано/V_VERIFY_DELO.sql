CREATE OR REPLACE VIEW V_VERIFY_DELO AS
SELECT --
         --  13.10.2011  BlackHawk  Создание
         --  18.01.2012  BlackHawk  Переделал запрос, потому как оказались несколько Пакетов привязанных к одной КПУ
         --  25.06.2013 Dikan Однозначное возвращение Number в поле status для интерфейса АРМ Выверка 
         ed.delo_id
        ,aff.affair_id
        ,aff.affair_stage
        ,get_read_only (51, ed.delo_id)  as read_only
        ,addr_apartment_fmt (aff.apart_id) AS addr
        ,ed.delo_addr
        ,   get_affair_num_fmt (aff.affair_id, aff.affair_stage)
         || '    '
         || TRIM (TO_CHAR (DECODE (aff.sq_type, 1, aff.kk_num, get_room_cnt (aff.affair_id, aff.affair_stage))))
         || ' комн. в '
         || LOWER (kursiv.padeg.get_fio_fromstr (get_classifier_h (5, aff.sq_type), 'ж', 3))
           AS kpu_num
        ,aff.build_id AS building_id
        ,aff.apart_id AS apart_id
        ,aff.decl_date
        ,aff.decision_num
        ,aff.delo_date,
        NVL(ed.status, 0) as status --25.06.2013
        ,ed.delo_comment
        ,DECODE (NVL (ed.status, 0)
                ,2, 'ВЫВЕРЕНО'
                ,3, 'ПРИОСТАНОВЛЕНО'
                ,4, 'ВОЗВРАЩЕНО'
                ,1, 'ОТСКАНИРОВАНО'
                ,''
                )
           AS status_label
        ,edda.document_id AS scan_doc_id
        ,get_affair_person_cnt (aff.affair_id, aff.affair_stage) AS affair_person_cnt
    FROM affair aff
        ,scan.ea_delo ed
        ,scan.ea_delo_attr eda
        ,(SELECT edd.delo_id, vv.*
            FROM scan.ea_document edd, scan.ea_document_attr vv
           WHERE vv.document_id = edd.document_id) edda
   WHERE     ed.object_type_id = 6
         AND ed.delo_id = eda.delo_id(+)
         AND 1 = eda.object_type_id(+)
         AND 1 = eda.row_status(+)
         AND eda.object_rel_id = aff.affair_id(+)
         AND 1 = aff.affair_stage(+)
         --
         AND eda.delo_id = edda.delo_id(+)
         AND eda.object_rel_id = edda.object_rel_id(+)
         AND 1 = edda.object_type_id(+)
         AND 1 = edda.row_status(+)


--GRANT SELECT ON kurs3.v_verify_delo TO OKRUG;
--CREATE SYNONYM o51.v_verify_delo FOR kurs3.v_verify_delo;
--CREATE SYNONYM o52.v_verify_delo FOR kurs3.v_verify_delo;
--CREATE SYNONYM o53.v_verify_delo FOR kurs3.v_verify_delo;
--CREATE SYNONYM o54.v_verify_delo FOR kurs3.v_verify_delo;
--CREATE SYNONYM o55.v_verify_delo FOR kurs3.v_verify_delo;
--CREATE SYNONYM o56.v_verify_delo FOR kurs3.v_verify_delo;
--CREATE SYNONYM o57.v_verify_delo FOR kurs3.v_verify_delo;
--CREATE SYNONYM o58.v_verify_delo FOR kurs3.v_verify_delo;
--CREATE SYNONYM o59.v_verify_delo FOR kurs3.v_verify_delo;
--CREATE SYNONYM o60.v_verify_delo FOR kurs3.v_verify_delo;
--CREATE SYNONYM o61.v_verify_delo FOR kurs3.v_verify_delo;;
