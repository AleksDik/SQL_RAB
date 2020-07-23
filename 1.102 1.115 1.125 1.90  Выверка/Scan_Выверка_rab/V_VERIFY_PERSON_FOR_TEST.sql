CREATE OR REPLACE VIEW V_VERIFY_PERSON_FOR_TEST AS

SELECT --
         --  20.10.2011  BlackHawk  Создание
         --  17.01.2012  BlackHawk  Переделал запрос, потому как оказались несколько Пакетов привязанных к одной КПУ
         --
         vv.rnum
        ,vv.person_id
        ,vv.affair_id
        ,vv.affair_stage
        ,vv.last_name
        ,vv.first_name
        ,vv.birthday
        ,vv.persex
        ,vv.relation_cod
        ,vv.doc_type
        ,vv.doc_series
        ,vv.doc_num
        ,vv.date_enter
        ,vv.how_giving
        ,vv.family_num
        ,vv.master
        ,vv.sq_type
        ,vv.patronymic
        ,vv.pat
        ,vv.person_category
        ,vv.person_subsidy
        ,vv.person_category_1
        ,vv.person_category_2
        ,vv.category_date
        ,vv.category_year
        ,vv.category_1_date
        ,vv.category_1_year
        ,vv.category_2_date
        ,vv.category_2_year
        ,vv.year_in_city
        ,vv.year_in_place
        ,vv.reg_person
        ,vv.guvd_str
        ,vv.owners
        ,eda.document_id AS scan_doc_id
        ,TO_NUMBER (0) AS delo_id
    FROM v_person_affair_1 vv, scan.ea_document_attr eda
   WHERE     vv.person_id = eda.object_rel_id(+)
         AND 7 = eda.object_type_id(+)
         AND 1 = eda.row_status(+)
        -- AND kurs3_var.get_pkg_var ('NUMBER_VERSION') = 782
        -- AND TO_NUMBER (SUBSTR (kurs3_var.get_pkg_var ('GLOBAL_VERSION'), INSTR (kurs3_var.get_pkg_var ('GLOBAL_VERSION'), '.', 1, 3) + 1)) <= 10
 UNION ALL
  SELECT v_aff.rnum
        ,v_aff.person_id
        ,v_aff.affair_id
        ,v_aff.affair_stage
        ,v_aff.last_name
        ,v_aff.first_name
        ,v_aff.birthday
        ,v_aff.persex
        ,v_aff.relation_cod
        ,v_aff.doc_type
        ,v_aff.doc_series
        ,v_aff.doc_num
        ,v_aff.date_enter
        ,v_aff.how_giving
        ,v_aff.family_num
        ,v_aff.master
        ,v_aff.sq_type
        ,v_aff.patronymic
        ,v_aff.pat
        ,v_aff.person_category
        ,v_aff.person_subsidy
        ,v_aff.person_category_1
        ,v_aff.person_category_2
        ,v_aff.category_date
        ,v_aff.category_year
        ,v_aff.category_1_date
        ,v_aff.category_1_year
        ,v_aff.category_2_date
        ,v_aff.category_2_year
        ,v_aff.year_in_city
        ,v_aff.year_in_place
        ,v_aff.reg_person
        ,v_aff.guvd_str
        ,v_aff.owners
        ,v_eda.document_id AS scan_doc_id
        ,v_aff.delo_id AS delo_id
    FROM (SELECT edaa.delo_id, vv.*
            FROM v_person_affair_1 vv, scan.ea_delo_attr edaa
           WHERE edaa.object_type_id = 1 AND edaa.object_rel_id = vv.affair_id AND edaa.row_status = 1) v_aff
        ,(SELECT ed.delo_id, eda.*
            FROM scan.ea_document ed, scan.ea_document_attr eda
           WHERE eda.document_id = ed.document_id AND eda.row_status = 1 AND eda.object_type_id = 7) v_eda
   WHERE v_aff.delo_id = v_eda.delo_id(+) AND v_aff.person_id = v_eda.object_rel_id(+)
        -- AND ( (kurs3_var.get_pkg_var ('NUMBER_VERSION') = 782
          --      AND TO_NUMBER (SUBSTR (kurs3_var.get_pkg_var ('GLOBAL_VERSION'), INSTR (kurs3_var.get_pkg_var ('GLOBAL_VERSION'), '.', 1, 3) + 1)) >
          --            10)
          --    OR (kurs3_var.get_pkg_var ('NUMBER_VERSION') > 782))


--GRANT SELECT ON kurs3.v_verify_person TO OKRUG;
--CREATE SYNONYM o51.v_verify_person FOR kurs3.v_verify_person;
--CREATE SYNONYM o52.v_verify_person FOR kurs3.v_verify_person;
--CREATE SYNONYM o53.v_verify_person FOR kurs3.v_verify_person;
--CREATE SYNONYM o54.v_verify_person FOR kurs3.v_verify_person;
--CREATE SYNONYM o55.v_verify_person FOR kurs3.v_verify_person;
--CREATE SYNONYM o56.v_verify_person FOR kurs3.v_verify_person;
--CREATE SYNONYM o57.v_verify_person FOR kurs3.v_verify_person;
--CREATE SYNONYM o58.v_verify_person FOR kurs3.v_verify_person;
--CREATE SYNONYM o59.v_verify_person FOR kurs3.v_verify_person;
--CREATE SYNONYM o60.v_verify_person FOR kurs3.v_verify_person;
--CREATE SYNONYM o61.v_verify_person FOR kurs3.v_verify_person;;
