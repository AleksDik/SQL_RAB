CREATE OR REPLACE PACKAGE pkg_scan AS
--  21.11.2013 Dik#   Добавлены новые процедуры для использоания в интерфейсе (Задача 1.115)
--  11.04.2014 Dik#   Доработана процедура setstatus для установки статуса 5 (Удалено) (Задача 1.125)

  PROCEDURE document_update (p_delo_id_      NUMBER
                            ,p_document_id_  NUMBER
                            ,p_doc_number_   VARCHAR2
                            ,p_doc_type_     NUMBER
                            ,p_doc_date_     DATE
                            ,p_bad_scan_     NUMBER
                            );

  --
  --  Статус выверки дела (1 - отсканировано, 2 - выверено, 3 - приостановлено, 4 - возвращено)
  --
  PROCEDURE setstatus (p_delo_id_ NUMBER, p_status_ NUMBER, p_comment_ VARCHAR2, p_msg_ IN OUT VARCHAR2);

  --
  --  Установить связь двух объектов
  --
  PROCEDURE set_objects_link (p_obj_1_type  IN NUMBER
                             ,p_obj_1_id    IN NUMBER
                             ,p_obj_2_type  IN NUMBER
                             ,p_obj_2_id    IN NUMBER
                             ,finish_commit IN NUMBER := 0
                             );

  --
  --  Убрать связь двух объектов
  --
  PROCEDURE unset_objects_link (p_obj_1_type  IN NUMBER
                               ,p_obj_1_id    IN NUMBER
                               ,p_obj_2_type  IN NUMBER
                               ,p_obj_2_id    IN NUMBER
                               ,finish_commit IN NUMBER := 0
                               );

  --
  --  Процедура обновления данных в КПУ после выверки
  --
  PROCEDURE upd_verify_affair (p_delo_id      IN NUMBER
                              ,p_affair_id    IN NUMBER
                              ,p_affair_stage IN NUMBER
                              ,p_decl_date    IN DATE
                              ,p_decision_num IN VARCHAR2
                              ,p_delo_date    IN DATE
                              );

  --
  --  Процедура обновления данных о пометках в Деле по выверке
  --
  PROCEDURE upd_verify_delo_labels (p_delo_id IN NUMBER, p_label_type_id IN NUMBER, p_checked IN NUMBER);

  --
  --  Процедура обновления данных о людях в Деле по выверке
  --
  PROCEDURE upd_verify_persons (p_delo_id IN NUMBER, p_person_id IN NUMBER, p_field_name IN VARCHAR2, p_field_value IN VARCHAR2);

  --
  --  Процедура обновления данных по документам о льготах в Деле по выверке
  --
  PROCEDURE upd_verify_priv_docs (p_delo_id     IN NUMBER
                                 ,p_person_id   IN NUMBER
                                 ,p_doc_rn      IN NUMBER
                                 ,p_field_name  IN VARCHAR2
                                 ,p_field_value IN VARCHAR2
                                 );

  --
  --  Процедура смены адреса в Деле по выверке
  --
  PROCEDURE change_address_in_delo (p_delo_id IN NUMBER, p_affair_id IN NUMBER, p_building_id IN NUMBER, p_apart_id NUMBER);

  --
  --  Процедура со списком комнат по КПУ
  --
  PROCEDURE get_room_delo (a_id IN NUMBER, stage IN NUMBER, all_room IN OUT kurs3.curstype);

  --
  --  Процедура для слежения за изменениями по Выверке данных
  --
  PROCEDURE filer_log (obj_type_id IN NUMBER
                      ,obj_id      IN NUMBER
                      ,op_type     IN NUMBER
                      ,old_value   IN VARCHAR2 := NULL
                      ,new_value   IN VARCHAR2 := NULL
                      ,ext_obj_id  IN NUMBER := NULL
                      );

  --
  --  Процедура возвращает курсор с данными о документах на льготы по всем людям из КПУ
  --
  PROCEDURE priv_docs_list (a_id IN NUMBER, a_st IN NUMBER, delo_id IN NUMBER, priv_docs_cursor IN OUT kurs3.curstype);

  --
  --  Процедура поиска "подходящих" Пакетов по UNOM+UNKV (из Пакета=delo_id) или по строке адреса (delo_addr)
  --
  PROCEDURE verify_delo_search (delo_id NUMBER := NULL, delo_addr VARCHAR2 := NULL, result_cur IN OUT kurs3.curstype);

  --
  --  Процедура переноса документов из одного Пакета в другой
  --
  PROCEDURE verify_delo_docs_move (p_from_delo_id         NUMBER
                                  ,p_to_delo_id           NUMBER
                                  ,p_new_delo_addr        VARCHAR2 := NULL
                                  ,p_docs                 number_table_type
                                  ,p_confirm              NUMBER --0 - проверка; 1 - проверка и перемещение
                                  ,msg_id          IN OUT NUMBER --1 - проверки успешны, 2 - перемещены, 3 - перемещены, пакет можно удалять, -1 - проверки неуспешны
                                  ,msg             IN OUT VARCHAR2
                                  ,p_new_delo_id   IN OUT NUMBER
                                  );

  --
  --  Процедура удаляет несвязанный Пакет
  --
  PROCEDURE del_verify_delo (delo_id NUMBER, msg_id IN OUT NUMBER, msg IN OUT VARCHAR2);

  --
  --  Процедура изменения адреса в Пакете
  --
  PROCEDURE upd_verify_delo_addr (delo_id NUMBER, delo_addr VARCHAR2, msg_id IN OUT NUMBER, msg IN OUT VARCHAR2);

  --
  --  Процедура для выдачи курсора со списком пакетов по КПУ
  --
  PROCEDURE get_affair_delo_list (affair_id IN NUMBER, records IN OUT kurs3.curstype);

  --
  --  Функция высчитывания номера группы для типа документа
  --
  FUNCTION get_doc_grp_type (p_type_id IN NUMBER)
    RETURN NUMBER;

  --
  --  Процедура для выдачи курсора со списком "групп" типов документов в пакете
  --
  PROCEDURE get_delo_doc_types (delo_id IN NUMBER, records IN OUT kurs3.curstype);

  --
  --  Процедура для выдачи курсора со списком документов в пакете ("группе" типов)
  --
  PROCEDURE get_delo_doc_list (delo_id IN NUMBER, records IN OUT kurs3.curstype);
--GRANT EXECUTE ON kurs3.pkg_scan TO OKRUG;
--CREATE SYNONYM o51.pkg_scan FOR kurs3.pkg_scan;
--CREATE SYNONYM o52.pkg_scan FOR kurs3.pkg_scan;
--CREATE SYNONYM o53.pkg_scan FOR kurs3.pkg_scan;
--CREATE SYNONYM o54.pkg_scan FOR kurs3.pkg_scan;
--CREATE SYNONYM o55.pkg_scan FOR kurs3.pkg_scan;
--CREATE SYNONYM o56.pkg_scan FOR kurs3.pkg_scan;
--CREATE SYNONYM o57.pkg_scan FOR kurs3.pkg_scan;
--CREATE SYNONYM o58.pkg_scan FOR kurs3.pkg_scan;
--CREATE SYNONYM o59.pkg_scan FOR kurs3.pkg_scan;
--CREATE SYNONYM o60.pkg_scan FOR kurs3.pkg_scan;
--CREATE SYNONYM o61.pkg_scan FOR kurs3.pkg_scan;


  -- Установка значения source_quality - качество исходного документа
  FUNCTION ChangeBadScanType (v_document_id IN NUMBER, v_source_quality IN NUMBER, v_CommitIt NUMBER) RETURN NUMBER;

--  21.11.2013 Dik#   
  -- Получить количество связанных документов КПУ в деле
  FUNCTION get_LnkDocOfAffair_delo_count (p_delo_id IN NUMBER) RETURN NUMBER;
  -- Проверить привязки КПУ к пакетам сканирования
  FUNCTION get_affair_delo_link (p_affair_id IN NUMBER, p_delo_id IN NUMBER := 0, p_mess OUT varchar2 )  RETURN NUMBER;
  -- Распарсить адрес дела для поиска КПУ
  PROCEDURE parse_delo_adr (p_delo_id IN NUMBER, p_cur IN OUT kurs3.curstype);
-- Поиск по адресу
PROCEDURE search_affair_for_addr(
   p_ul in STREET.Full_Name%Type ,
   p_dom in BUILDING.House_Num%type,
   p_korp in BUILDING.BUILDING_NUM%type, 
   p_stroen in BUILDING.CONSTRUCTION_NUM%type,
   p_apart in APARTMENT.APARTMENT_NUM%type,
   p_unom NUMBER :=NULL	,
   p_unkv NUMBER :=NULL ,
   msg IN OUT VARCHAR2 ,
	 msg_id IN OUT NUMBER);
-- Получить принак изменения КПУ после выверки пакета
FUNCTION get_is_affair_change_after (p_delo_id IN NUMBER) RETURN NUMBER;
--/  21.11.2013 Dik#
END pkg_scan;

 
/
CREATE OR REPLACE PACKAGE BODY pkg_scan AS
  FUNCTION valeq (value1_ VARCHAR2, value2_ VARCHAR2)
    RETURN BOOLEAN IS
  BEGIN
    IF (value1_ IS NULL AND value2_ IS NULL) THEN
      RETURN TRUE;
    ELSIF (value1_ IS NULL OR value2_ IS NULL) THEN
      RETURN FALSE;
    ELSIF (value1_ = value2_) THEN
      RETURN TRUE;
    END IF;

    RETURN FALSE;
  END;

  PROCEDURE document_update (p_delo_id_      NUMBER
                            ,p_document_id_  NUMBER
                            ,p_doc_number_   VARCHAR2
                            ,p_doc_type_     NUMBER
                            ,p_doc_date_     DATE
                            ,p_bad_scan_     NUMBER
                            ) AS
  --
  --  20.02.2012  BlackHawk  Добавил установку bad_scan только для случаев 0 и 1 (данные от юзера)
  --
  BEGIN
    FOR i IN (SELECT ROWID AS rowid_, doc_num, full_name, doc_date, bad_scan, doc_type_id
                FROM scan.ea_document
               WHERE document_id = p_document_id_) LOOP
      UPDATE scan.ea_document
         SET doc_num       = TRIM (p_doc_number_) --, full_name = TRIM (p_doc_name_)
            ,doc_date      = TRUNC (p_doc_date_)
            ,bad_scan      = DECODE (p_bad_scan_,  0, p_bad_scan_,  1, p_bad_scan_,  bad_scan)
            ,doc_type_id   = p_doc_type_
            ,user_id       = get_user_unique_id (kurs3_var.get_user_id_f)
       WHERE ROWID = i.rowid_;

      IF NOT (valeq (i.doc_num, TRIM (p_doc_number_))) THEN
        filer_log (obj_type_id => 2, obj_id => p_document_id_, op_type => 1, old_value => i.doc_num, new_value => TRIM (p_doc_number_));
      END IF;

      IF NOT (valeq (i.doc_type_id, p_doc_type_)) THEN
        filer_log (obj_type_id => 4, obj_id => p_document_id_, op_type => 1, old_value => i.doc_type_id, new_value => p_doc_type_);
      END IF;

      IF NOT (valeq (TO_CHAR (p_doc_date_, 'dd.mm.yyyy'), TO_CHAR (i.doc_date, 'dd.mm.yyyy'))) THEN
        filer_log (obj_type_id => 3
                  ,obj_id => p_document_id_
                  ,op_type => 1
                  ,old_value => TO_CHAR (i.doc_date, 'dd.mm.yyyy')
                  ,new_value => TO_CHAR (p_doc_date_, 'dd.mm.yyyy')
                  );
      END IF;

      IF NOT (valeq (i.bad_scan, p_bad_scan_)) AND p_bad_scan_ IN (0, 1) THEN
        filer_log (obj_type_id => 5, obj_id => p_document_id_, op_type => 1, old_value => i.bad_scan, new_value => p_bad_scan_);
      END IF;
    END LOOP;
  END document_update;

  PROCEDURE setstatus (p_delo_id_ NUMBER, p_status_ NUMBER, p_comment_ VARCHAR2, p_msg_ IN OUT VARCHAR2) AS
    tmp_ VARCHAR2 (200);
  BEGIN
    IF NOT (NVL (p_status_, 0) IN (1, 2, 3, 4, 5)) THEN --  11.04.2014 Dik# 
      p_msg_   := 'Неверный статус';
      RETURN;
    END IF;

    FOR i IN (SELECT ROWID rowid_, status, delo_comment
                FROM scan.ea_delo d
               WHERE delo_id = p_delo_id_) LOOP
      UPDATE scan.ea_delo d
         SET d.delo_comment = TRIM (p_comment_), status = p_status_, user_id = get_user_unique_id (kurs3_var.get_user_id_f)
       WHERE ROWID = i.rowid_;

      IF NOT (valeq (i.status, p_status_)) THEN
        --        IF (i.status <> 2 AND p_status_ = 2) OR (i.status = 2 AND p_status_ <> 2) THEN
        --          FOR j IN (SELECT d.object_rel_id AS reestr_n
        --                      FROM scan.ea_delo_attr d
        --                     WHERE d.delo_id = p_delo_id_ AND d.delo_version = 0 AND d.object_type_id = 1) LOOP
        --                        rdn_fill_history ( (CASE WHEN i.status <> 2 AND p_status_ = 2 THEN 59 --выверка завершена
        --                                                                                             WHEN i.status = 2 AND p_status_ <> 2 THEN 60 --выверка возобновлена
        --                                                                                                                                         END), j.reestr_n);
        --          END LOOP;
        --        END IF;

        filer_log (obj_type_id => 9, obj_id => p_delo_id_, op_type => 1, old_value => i.status, new_value => p_status_);
      END IF;

      IF NOT (valeq (i.delo_comment, TRIM (p_comment_))) THEN
        filer_log (obj_type_id => 10, obj_id => p_delo_id_, op_type => 1, old_value => i.delo_comment, new_value => TRIM (p_comment_));
      END IF;
    END LOOP;
--  11.04.2014 Dik#     
IF NVL (p_status_, 0) = 5 then
    DELETE FROM scan.ea_delo_label vv WHERE vv.delo_id = p_delo_id_;
--/ 11.04.2014 Dik#     
end if;

 COMMIT;
END setstatus;

  PROCEDURE set_objects_link (p_obj_1_type  IN NUMBER
                             ,p_obj_1_id    IN NUMBER
                             ,p_obj_2_type  IN NUMBER
                             ,p_obj_2_id    IN NUMBER
                             ,finish_commit IN NUMBER := 0
                             ) AS
    o1_type NUMBER;
    o2_type NUMBER;
    o1_id   NUMBER;
    o2_id   NUMBER;
    is_set  NUMBER (1); -- флаг что уже усё связано
    rid     ROWID;
  BEGIN
    o1_type   := p_obj_1_type;
    o1_id     := p_obj_1_id;
    o2_type   := p_obj_2_type;
    o2_id     := p_obj_2_id;

    --> переставим коды объектов как нам дальше удобно (если нужно)
    IF p_obj_2_type = 13 THEN
      o1_type   := p_obj_2_type;
      o1_id     := p_obj_2_id;
      o2_type   := p_obj_1_type;
      o2_id     := p_obj_1_id;
    END IF;

    IF p_obj_2_type = 14 THEN
      o1_type   := p_obj_2_type;
      o1_id     := p_obj_2_id;
      o2_type   := p_obj_1_type;
      o2_id     := p_obj_1_id;
    END IF;

    --< переставим коды объектов как нам дальше удобно (если нужно)

    is_set    := 0;

    CASE o1_type
      WHEN 13 THEN
        -- привязывается SCAN.EA_DELO
        FOR rec IN (SELECT attr.ROWID AS rid
                      FROM scan.ea_delo_attr attr
                     WHERE attr.delo_id = o1_id AND attr.object_type_id = o2_type AND attr.delo_version = 0) LOOP
          is_set   := 1;
          rid      := rec.rid;
        END LOOP;

        IF is_set = 1 THEN
          -- старую связь откладываем в архив:
          UPDATE scan.ea_delo_attr attr
             SET delo_version      =
                   (SELECT NVL (MAX (vv.delo_version), 0) + 1
                      FROM scan.ea_delo_attr vv
                     WHERE vv.delo_id = attr.delo_id AND vv.object_type_id = attr.object_type_id)
                ,row_status   = 0
           WHERE ROWID = rid;
        END IF;

        -- делаем новую связь:
        INSERT INTO scan.ea_delo_attr (delo_id, delo_version, object_type_id, object_rel_id, last_change, row_status)
             VALUES (o1_id, 0, o2_type, o2_id, SYSDATE, 1);

        filer_log (obj_type_id => 6, obj_id => o1_id, op_type => 2, ext_obj_id => o2_id);
      WHEN 14 THEN
        -- привязывается SCAN.EA_DOCUMENT
        FOR rec IN (SELECT attr.ROWID AS rid
                      FROM scan.ea_document_attr attr
                     WHERE attr.document_id = o1_id AND attr.object_type_id = o2_type AND attr.document_version = 0) LOOP
          is_set   := 1;
          rid      := rec.rid;
        END LOOP;

        IF is_set = 1 THEN
          -- старую связь откладываем в архив:
          UPDATE scan.ea_document_attr attr
             SET document_version      =
                   (SELECT NVL (MAX (vv.document_version), 0) + 1
                      FROM scan.ea_document_attr vv
                     WHERE vv.document_id = attr.document_id AND vv.object_type_id = attr.object_type_id)
                ,row_status   = 0
           WHERE ROWID = rid;
        END IF;
-- старую связь ДЛЯ ПАСПАРТОВ откладываем в архив --  12.02.2014 Dik#       
        if o2_type=7 then
          Update scan.ea_document_attr att
          set att.row_status = 0,
              att.document_version =NVL((SELECT MAX (vv.document_version) FROM scan.ea_document_attr vv
                                         WHERE vv.document_id = att.document_id AND vv.object_type_id = o2_type and vv.object_rel_id = o2_id ),0)+1
          
        WHERE  att.object_type_id = o2_type 
          AND att.object_rel_id = o2_id  
          and att.row_status=1
          and att.document_version=0;
        end if;
        -- делаем новую связь:
        INSERT INTO scan.ea_document_attr (document_id, document_version, object_type_id, object_rel_id, last_change, row_status,user_id)
             VALUES (o1_id, 0, o2_type, o2_id, SYSDATE, 1,get_user_unique_id (kurs3_var.get_user_id_f));

        filer_log (obj_type_id => 8, obj_id => o1_id, op_type => 2, ext_obj_id => o2_id);
      ELSE
        NULL;
    END CASE;

    IF finish_commit = 1 THEN
      COMMIT;
    END IF;
  END set_objects_link;

  PROCEDURE unset_objects_link (p_obj_1_type  IN NUMBER
                               ,p_obj_1_id    IN NUMBER
                               ,p_obj_2_type  IN NUMBER
                               ,p_obj_2_id    IN NUMBER
                               ,finish_commit IN NUMBER := 0
                               ) AS
    --
    --  17.01.2012  BlackHawk  В лог добавил сохранение old_value
    --
    o1_type NUMBER;
    o2_type NUMBER;
    o1_id   NUMBER;
    o2_id   NUMBER;
    is_set  NUMBER (1); -- флаг что уже усё связано
    rid     ROWID;
    r_st    scan.ea_delo_attr.row_status%TYPE;
  BEGIN
    o1_type   := p_obj_1_type;
    o1_id     := p_obj_1_id;
    o2_type   := p_obj_2_type;
    o2_id     := p_obj_2_id;

    --> переставим коды объектов как нам дальше удобно (если нужно)
    IF p_obj_2_type = 13 THEN
      o1_type   := p_obj_2_type;
      o1_id     := p_obj_2_id;
      o2_type   := p_obj_1_type;
      o2_id     := p_obj_1_id;
    END IF;

    IF p_obj_2_type = 14 THEN
      o1_type   := p_obj_2_type;
      o1_id     := p_obj_2_id;
      o2_type   := p_obj_1_type;
      o2_id     := p_obj_1_id;
    END IF;

    --< переставим коды объектов как нам дальше удобно (если нужно)

    is_set    := 0;

    CASE o1_type
      WHEN 13 THEN
        -- отвязывается SCAN.EA_DELO
        FOR rec IN (SELECT attr.ROWID AS rid, attr.row_status
                      FROM scan.ea_delo_attr attr
                     WHERE attr.delo_id = o1_id AND attr.object_type_id = o2_type AND attr.delo_version = 0) LOOP
          is_set   := 1;
          rid      := rec.rid;
          r_st     := rec.row_status;
        END LOOP;

        IF is_set = 1 THEN
          -- старую связь откладываем в архив:
          UPDATE scan.ea_delo_attr attr
             SET row_status   = 0
           WHERE ROWID = rid;

          filer_log (obj_type_id => 6, obj_id => o1_id, op_type => 3, ext_obj_id => o2_id, old_value => r_st);
        END IF;
      WHEN 14 THEN
        -- отвязывается SCAN.EA_DOCUMENT
        FOR rec IN (SELECT attr.ROWID AS rid, attr.row_status
                      FROM scan.ea_document_attr attr
                     WHERE attr.document_id = o1_id AND attr.object_type_id = o2_type AND attr.document_version = 0) LOOP
          is_set   := 1;
          rid      := rec.rid;
          r_st     := rec.row_status;
        END LOOP;

        IF is_set = 1 THEN
          -- старую связь откладываем в архив:
          UPDATE scan.ea_document_attr attr
             SET row_status   = 0
           WHERE ROWID = rid;

          filer_log (obj_type_id => 8, obj_id => o1_id, op_type => 3, ext_obj_id => o2_id, old_value => r_st);
        END IF;
      ELSE
        NULL;
    END CASE;

    IF finish_commit = 1 THEN
      COMMIT;
    END IF;
  END unset_objects_link;

  PROCEDURE upd_verify_affair (p_delo_id      IN NUMBER
                              ,p_affair_id    IN NUMBER
                              ,p_affair_stage IN NUMBER
                              ,p_decl_date    IN DATE
                              ,p_decision_num IN VARCHAR2
                              ,p_delo_date    IN DATE
                                ) AS
 -- 29.10.2013 Dik добавил  изменение last_change в  scan.ea_delo                             
  BEGIN
    UPDATE affair aff
       SET aff.decl_date = p_decl_date, aff.decision_num = p_decision_num, aff.delo_date = p_delo_date
     WHERE aff.affair_id = p_affair_id AND aff.affair_stage = p_affair_stage;

    UPDATE scan.ea_delo 
      SET last_change   = SYSDATE,
          user_id       = get_user_unique_id (kurs3_var.get_user_id_f)
     WHERE delo_id = p_delo_id;
 
  END upd_verify_affair;

  PROCEDURE upd_verify_delo_labels (p_delo_id IN NUMBER, p_label_type_id IN NUMBER, p_checked IN NUMBER) AS
    nn NUMBER (1) := 0;
  BEGIN
    IF p_checked = 0 THEN
      DELETE FROM scan.ea_delo_label vv
            WHERE vv.delo_id = p_delo_id AND vv.label_type_id = p_label_type_id;

      IF SQL%ROWCOUNT > 0 THEN
        filer_log (obj_type_id => 7, obj_id => p_delo_id, op_type => 3, ext_obj_id => p_label_type_id);
      END IF;
    ELSE
      FOR rec IN (SELECT 1
                    FROM scan.ea_delo_label vv
                   WHERE vv.delo_id = p_delo_id AND vv.label_type_id = p_label_type_id) LOOP
        nn   := 1;
      END LOOP;

      IF nn = 0 THEN
        INSERT INTO scan.ea_delo_label (delo_id, label_type_id, last_change)
             VALUES (p_delo_id, p_label_type_id, SYSDATE);

        filer_log (obj_type_id => 7, obj_id => p_delo_id, op_type => 2, ext_obj_id => p_label_type_id);
      END IF;
    END IF;
  END upd_verify_delo_labels;

  PROCEDURE upd_verify_persons (p_delo_id IN NUMBER, p_person_id IN NUMBER, p_field_name IN VARCHAR2, p_field_value IN VARCHAR2) AS
-- 29.10.2013 Dik добавил  изменение last_change в  scan.ea_delo 
    otid          NUMBER (2) := 0;
    v_field_value VARCHAR2 (2000) := '';
    nn            NUMBER (1);
  BEGIN
    IF p_field_name IN ('PERSEX', 'BIRTHDAY', 'PATRONYMIC', 'PAT', 'LAST_NAME') THEN
      FOR rec IN (SELECT pp.ROWID AS rid, pp.*
                    FROM person pp
                   WHERE pp.person_id = p_person_id) LOOP
        CASE p_field_name
          WHEN 'PERSEX' THEN
            IF NVL (rec.persex, 0) <> NVL (p_field_value, '0') THEN
              UPDATE person pp
                 SET persex   = NVL (p_field_value, '0')
               WHERE pp.ROWID = rec.rid;

              v_field_value   := rec.persex;
              otid            := 11;
            END IF;
          WHEN 'BIRTHDAY' THEN
            IF NVL (rec.birthday, TRUNC (SYSDATE)) <> NVL (TO_DATE (TRIM (REPLACE (p_field_value, '.', '')), 'ddmmyyyy'), TRUNC (SYSDATE)) THEN
              UPDATE person pp
                 SET birthday   = TO_DATE (TRIM (REPLACE (p_field_value, '.', '')), 'dd.mm.yyyy')
               WHERE pp.ROWID = rec.rid;

              v_field_value   := TO_CHAR (rec.birthday, 'dd.mm.yyyy');
              otid            := 12;
            END IF;
          WHEN 'PATRONYMIC' THEN
            IF NVL (rec.patronymic, ' ') <> NVL (p_field_value, ' ') THEN
              UPDATE person pp
                 SET patronymic   = p_field_value
               WHERE pp.ROWID = rec.rid;

              v_field_value   := rec.patronymic;
              otid            := 13;
            END IF;
          WHEN 'PAT' THEN
            IF NVL (rec.pat, ' ') <> NVL (p_field_value, ' ') THEN
              UPDATE person pp
                 SET pat   = p_field_value
               WHERE pp.ROWID = rec.rid;

              v_field_value   := rec.pat;
              otid            := 14;
            END IF;
          WHEN 'LAST_NAME' THEN
            IF NVL (rec.last_name, ' ') <> NVL (p_field_value, ' ') THEN
              UPDATE person pp
                 SET last_name   = p_field_value
               WHERE pp.ROWID = rec.rid;

              v_field_value   := rec.last_name;
              otid            := 15;
            END IF;
        END CASE;
      END LOOP;
    ELSIF p_field_name IN ('HOW_GIVING', 'DATE_ENTER', 'DOC_NUM', 'DOC_SERIES', 'DOC_TYPE') THEN
      nn   := 0;

      FOR rec IN (SELECT pp.ROWID AS rid, pp.*
                    FROM pasport_data pp
                   WHERE pp.person_id = p_person_id AND NVL (pp.status, 0) = 0) LOOP
        nn   := 1;
      END LOOP;

      IF nn = 0 THEN
        -- паспорта у человека вообще нету в системе. делаем новый:
        INSERT INTO pasport_data (person_id, document_type, status)
             VALUES (p_person_id, 0, NULL);
     
      END IF;

      FOR rec IN (SELECT pp.ROWID AS rid, pp.*
                    FROM pasport_data pp
                   WHERE pp.person_id = p_person_id AND NVL (pp.status, 0) = 0) LOOP
        CASE p_field_name
          WHEN 'HOW_GIVING' THEN
            IF NVL (rec.how_giving, ' ') <> NVL (p_field_value, ' ') THEN
              UPDATE pasport_data pp
                 SET how_giving   = p_field_value
               WHERE pp.ROWID = rec.rid;

              v_field_value   := rec.how_giving;
              otid            := 16;
            END IF;
          WHEN 'DATE_ENTER' THEN
            IF NVL (rec.date_enter, TRUNC (SYSDATE)) <> NVL (TO_DATE (TRIM (REPLACE (p_field_value, '.', '')), 'dd.mm.yyyy'), TRUNC (SYSDATE)) THEN
              UPDATE pasport_data pp
                 SET date_enter   = TO_DATE (TRIM (REPLACE (p_field_value, '.', '')), 'dd.mm.yyyy')
               WHERE pp.ROWID = rec.rid;

              v_field_value   := TO_CHAR (rec.date_enter, 'dd.mm.yyyy');
              otid            := 17;
            END IF;
          WHEN 'DOC_TYPE' THEN
            IF NVL (rec.document_type, 0) <> NVL (p_field_value, '0') THEN
              UPDATE pasport_data pp
                 SET document_type   = NVL (p_field_value, '0')
               WHERE pp.ROWID = rec.rid;

              v_field_value   := rec.document_type;
              otid            := 18;
            END IF;
          WHEN 'DOC_SERIES' THEN
            IF NVL (rec.document_series, ' ') <> NVL (p_field_value, ' ') THEN
              UPDATE pasport_data pp
                 SET document_series   = p_field_value
               WHERE pp.ROWID = rec.rid;

              v_field_value   := rec.document_series;
              otid            := 19;
            END IF;
          WHEN 'DOC_NUM' THEN
            IF NVL (rec.document_num, ' ') <> NVL (p_field_value, ' ') THEN
              UPDATE pasport_data pp
                 SET document_num   = p_field_value
               WHERE pp.ROWID = rec.rid;

              v_field_value   := rec.document_num;
              otid            := 20;
            END IF;
        END CASE;
      END LOOP;
    END IF;

 UPDATE scan.ea_delo 
   SET last_change   = SYSDATE,
       user_id       = get_user_unique_id (kurs3_var.get_user_id_f)
 WHERE delo_id = p_delo_id;
 
    IF otid <> 0 THEN
      filer_log (obj_type_id => otid, obj_id => p_person_id, op_type => 1, old_value => v_field_value, new_value => p_field_value);
    END IF;
  END upd_verify_persons;

  PROCEDURE upd_verify_priv_docs (p_delo_id     IN NUMBER
                                 ,p_person_id   IN NUMBER
                                 ,p_doc_rn      IN NUMBER
                                 ,p_field_name  IN VARCHAR2
                                 ,p_field_value IN VARCHAR2
                                 ) AS
  -- 29.10.2013 Dik добавил  изменение last_change в  scan.ea_delo                                 
    att_id        NUMBER;
    nn            NUMBER;
    fins          NUMBER (1);
    v_field_value VARCHAR2 (300) := p_field_value;
    v_doc_rn      NUMBER := p_doc_rn;
    otid          NUMBER (2) := 0;

  BEGIN
    CASE p_field_name
      WHEN 'SNILS' THEN
        att_id          := 15;

        IF v_doc_rn > 1 THEN
          v_doc_rn   := 1; -- СНИЛС заполяется только у =1
        END IF;

        v_field_value   := TRIM (REPLACE (REPLACE (v_field_value, ' ', ''), '-', ''));
        otid            := 21;
      WHEN 'DOC_NAME' THEN
        att_id   := 16;
        otid     := 22;
      WHEN 'FORM_VAL' THEN
        att_id   := 22;
        otid     := 23;
      WHEN 'DOC_SER' THEN
        att_id   := 17;
        otid     := 24;
      WHEN 'DOC_NUM' THEN
        att_id   := 18;
        otid     := 25;
      WHEN 'DOC_DATE' THEN
        att_id   := 19;

        IF TRIM (REPLACE (v_field_value, '.', ' ')) IS NULL THEN
          v_field_value   := '';
        END IF;

        otid     := 26;
      WHEN 'DOC_PERIOD' THEN
        att_id   := 26;
        otid     := 27;
      WHEN 'DOC_WHO' THEN
        att_id   := 20;
        otid     := 28;
      ELSE
        NULL;
    END CASE;

    fins   := 1;
    nn     := 0;

    FOR rec
      IN (SELECT ROWID AS rid, pa.*
            FROM person_attribute pa
           WHERE     pa.person_id = upd_verify_priv_docs.p_person_id
                 AND pa.attribute_id = upd_verify_priv_docs.att_id
                 AND pa.status = upd_verify_priv_docs.v_doc_rn) LOOP
      fins   := 0;

      UPDATE person_attribute pa
         SET pa.attribute_value = upd_verify_priv_docs.v_field_value, pa.status = upd_verify_priv_docs.v_doc_rn
       WHERE pa.ROWID = rec.rid;

      nn     := 1;

      IF otid <> 0 THEN
        filer_log (obj_type_id => otid
                  ,obj_id => p_person_id
                  ,op_type => 1
                  ,old_value => rec.attribute_value
                  ,new_value => v_field_value
                  ,ext_obj_id => v_doc_rn
                  );
      END IF;
    END LOOP;

    IF fins = 1 AND TRIM (v_field_value) IS NOT NULL THEN
      INSERT INTO person_attribute (person_id, attribute_id, attribute_value, status)
           VALUES (
                    upd_verify_priv_docs.p_person_id
                   ,upd_verify_priv_docs.att_id
                   ,TRIM (upd_verify_priv_docs.v_field_value)
                   ,upd_verify_priv_docs.v_doc_rn
                  );

      nn   := 1;

      IF otid <> 0 THEN
        filer_log (obj_type_id => otid, obj_id => p_person_id, op_type => 2, old_value => '', new_value => v_field_value, ext_obj_id => v_doc_rn);
      END IF;
    END IF;

 UPDATE scan.ea_delo 
   SET last_change   = SYSDATE,
       user_id       = get_user_unique_id (kurs3_var.get_user_id_f)
 WHERE delo_id = p_delo_id;
 
    
  END upd_verify_priv_docs;

  PROCEDURE change_address_in_delo (p_delo_id IN NUMBER, p_affair_id IN NUMBER, p_building_id IN NUMBER, p_apart_id NUMBER) AS
  BEGIN
    kurs3.change_address_in_affair (p_affair_id, p_building_id, p_apart_id);
  END change_address_in_delo;

  PROCEDURE get_room_delo (a_id IN NUMBER, stage IN NUMBER, all_room IN OUT kurs3.curstype) AS
  BEGIN
    OPEN all_room FOR
      SELECT room.building_id, room.apart_id, room.room_num, room.characteristic, room.room_space,
        room.npp_bti, --  21.11.2013 Dik#   
        affair.affair_id, affair.affair_stage, 1 indelo
        FROM affair, room, room_delo
       WHERE     affair.affair_stage = room_delo.affair_stage
             AND affair.affair_id = a_id
             AND affair.affair_id = room_delo.affair_id
             AND affair.okrug_id = room_delo.okrug_id
             --AND affair.okrug_id = NVL (kurs3_var.global_okrug_id, affair.okrug_id)
             AND room.room_num = room_delo.room_num
             AND affair.affair_stage = stage
             AND room.apart_id = affair.apart_id
      UNION
      SELECT room.building_id, room.apart_id, room.room_num, room.characteristic, room.room_space, 
        room.npp_bti, --  21.11.2013 Dik#   
        affair.affair_id, affair.affair_stage, 0 indelo
        FROM affair, room
       WHERE affair.affair_stage = stage AND affair.affair_id = a_id --AND affair.okrug_id = NVL (kurs3_var.global_okrug_id, affair.okrug_id)
                                                                    AND room.apart_id = affair.apart_id
             AND NOT EXISTS
                       (SELECT *
                          FROM room_delo
                         WHERE     affair.affair_stage = room_delo.affair_stage
                               AND affair.affair_id = a_id
                               AND affair.affair_id = room_delo.affair_id
                               AND affair.okrug_id = room_delo.okrug_id
                               AND room.room_num = room_delo.room_num);
  END get_room_delo;

  PROCEDURE filer_log (obj_type_id IN NUMBER
                      ,obj_id      IN NUMBER
                      ,op_type     IN NUMBER
                      ,old_value   IN VARCHAR2 := NULL
                      ,new_value   IN VARCHAR2 := NULL
                      ,ext_obj_id  IN NUMBER := NULL
                      ) AS
  BEGIN
    INSERT INTO verify_filer (obj_id, obj_ext_id, op_type, obj_type_id, old_value, new_value, user_id)
         VALUES (
                  filer_log.obj_id
                 ,filer_log.ext_obj_id
                 ,filer_log.op_type
                 ,filer_log.obj_type_id
                 ,filer_log.old_value
                 ,filer_log.new_value
                 ,get_user_unique_id (kurs3_var.get_user_id_f)
                );
  END filer_log;

  PROCEDURE priv_docs_list (a_id IN NUMBER, a_st IN NUMBER, delo_id IN NUMBER, priv_docs_cursor IN OUT kurs3.curstype) AS
  --
  --  04.10.2011  BlackHawk  Создание
  --  18.11.2011  BlackHawk  СНИЛС берётся теперь только от категории со STATUS=1
  --  07.02.2012  BlackHawk  Переделал соединение с табличками scan.ea_document_attr и scan.ea_document
  --
  BEGIN
    IF priv_docs_cursor%ISOPEN THEN
      CLOSE priv_docs_cursor;
    END IF;

    OPEN priv_docs_cursor FOR
      SELECT ROWNUM AS row_num, aa.*
        FROM (  SELECT pp.person_id
                      ,pp.last_name
                      ,pp.pat || ' ' || pp.patronymic AS first_name
                      ,pp.birthday
                      ,dd rn
                      ,   SUBSTR (LPAD (REPLACE (pa_15.attribute_value, ' ', ''), 11, '0'), -11, 3)
                       || '-'
                       || SUBSTR (LPAD (REPLACE (pa_15.attribute_value, ' ', ''), 11, '0'), -8, 3)
                       || '-'
                       || SUBSTR (LPAD (REPLACE (pa_15.attribute_value, ' ', ''), 11, '0'), -5, 3)
                       || ' '
                       || SUBSTR (LPAD (REPLACE (pa_15.attribute_value, ' ', ''), 11, '0'), -2, 2)
                         snils
                      ,pa_16.attribute_value doc_name
                      ,pa_17.attribute_value doc_ser
                      ,pa_18.attribute_value doc_num
                      ,pa_19.attribute_value doc_date
                      ,pa_20.attribute_value doc_who
                      ,pa_21.attribute_value doc_group
                      ,pp.relation_text
                      ,pp.categ_text
                      ,pp.ob_fb
                      ,pa_26.attribute_value doc_period -- подтв. документ:
                      ,pa_22.attribute_value ex_doc_fnum
                      ,pa_23.attribute_value ex_doc_num
                      ,pa_24.attribute_value ex_doc_date
                      ,pa_27.attribute_value ex_doc_period
                      ,pp.categ_id
                      ,pp.y18
                      ,pp.grp_i_val
                      ,pp.form_val
                      ,e_docs.document_id AS scan_doc_id
                  FROM (SELECT prd.family_num
                              ,p.*
                              ,dual100.dummy dd
                              ,TRIM (rlt.name) relation_text
                              ,ctg.short_name categ_text
                              ,TRIM (ctg.ob_fb) ob_fb
                              ,attribute_value categ_id
                              ,DECODE (SIGN (ADD_MONTHS (SYSDATE, -12 * 18) - p.birthday + 1), 1, 0, 1) y18
                              ,DECODE (attribute_value
                                      ,4, 1
                                      ,8, 1
                                      ,61, 1
                                      ,63, 1
                                      ,90, 1
                                      ,92, 1
                                      ,96, 1
                                      ,5, 2
                                      ,14, 2
                                      ,27, 2
                                      ,91, 2
                                      ,93, 2
                                      ,NULL
                                      )
                                 grp_i_val
                              ,DECODE (attribute_value,  103, 1,  69, 2,  16, 3,  70, 3,  98, 4,  NULL) form_val
                          FROM kurs3.person_relation_delo prd
                              ,kurs3.person p
                              ,dual100
                              ,kurs3.relations rlt
                              ,kurs3.person_attribute pa
                              ,kurs3.category ctg
                         WHERE     dual100.dummy <= 3
                               AND prd.affair_id = priv_docs_list.a_id
                               AND prd.affair_stage = priv_docs_list.a_st
                               AND prd.person_id = p.person_id
                               AND rlt.row_num(+) = prd.relation
                               AND pa.person_id = p.person_id
                               AND pa.attribute_id IN (12, 13, 14)
                               AND pa.status = 1
                               --AND pa.attribute_value <> 39
                               AND dual100.dummy + 11 = pa.attribute_id
                               AND ctg.categ_id = pa.attribute_value) pp
                      ,kurs3.person_attribute pa_15
                      ,kurs3.person_attribute pa_16
                      ,kurs3.person_attribute pa_17
                      ,kurs3.person_attribute pa_18
                      ,kurs3.person_attribute pa_19
                      ,kurs3.person_attribute pa_20
                      ,kurs3.person_attribute pa_21
                      ,kurs3.person_attribute pa_26
                      -- подтв. документ:
                      ,kurs3.person_attribute pa_22
                      ,kurs3.person_attribute pa_23
                      ,kurs3.person_attribute pa_24
                      ,kurs3.person_attribute pa_27
                      ,(SELECT eda.object_rel_id, eda.document_id
                          FROM scan.ea_document_attr eda, scan.ea_document ed
                         WHERE     ed.document_id = eda.document_id
                               AND ed.delo_id = priv_docs_list.delo_id
                               AND 12 = eda.object_type_id
                               AND 1 = eda.row_status) e_docs
                 WHERE     (pp.categ_id <> 39 OR pa_16.attribute_value IS NOT NULL OR pa_18.attribute_value IS NOT NULL)
                       AND pa_15.person_id(+) = pp.person_id
                       AND pa_15.attribute_id(+) = 15
                       AND pa_15.status(+) = 1 --BETWEEN 1 AND 3
                       AND pa_16.person_id(+) = pp.person_id
                       AND pa_16.attribute_id(+) = 16
                       AND pp.dd = pa_16.status(+)
                       AND pa_17.person_id(+) = pp.person_id
                       AND pa_17.attribute_id(+) = 17
                       AND pp.dd = pa_17.status(+)
                       AND pa_18.person_id(+) = pp.person_id
                       AND pa_18.attribute_id(+) = 18
                       AND pp.dd = pa_18.status(+)
                       AND pa_19.person_id(+) = pp.person_id
                       AND pa_19.attribute_id(+) = 19
                       AND pp.dd = pa_19.status(+)
                       AND pa_20.person_id(+) = pp.person_id
                       AND pa_20.attribute_id(+) = 20
                       AND pp.dd = pa_20.status(+)
                       AND pa_21.person_id(+) = pp.person_id
                       AND pa_21.attribute_id(+) = 21
                       AND pp.dd = pa_21.status(+)
                       AND pa_26.person_id(+) = pp.person_id
                       AND pa_26.attribute_id(+) = 26
                       AND pp.dd = pa_26.status(+)
                       --
                       AND pa_22.person_id(+) = pp.person_id
                       AND pa_22.attribute_id(+) = 22
                       AND pp.dd = pa_22.status(+)
                       AND pa_23.person_id(+) = pp.person_id
                       AND pa_23.attribute_id(+) = 23
                       AND pp.dd = pa_23.status(+)
                       AND pa_24.person_id(+) = pp.person_id
                       AND pa_24.attribute_id(+) = 24
                       AND pp.dd = pa_24.status(+)
                       AND pa_27.person_id(+) = pp.person_id
                       AND pa_27.attribute_id(+) = 27
                       AND pp.dd = pa_27.status(+)
                       --
                       AND pp.person_id + (pp.dd / 10) = e_docs.object_rel_id(+)
              ORDER BY pp.person_id, dd, pa_16.status, pa_17.status, pa_18.status, pa_19.status, pa_20.status, pa_21.status, pa_26.status) aa;
  END priv_docs_list;

  PROCEDURE verify_delo_search (delo_id NUMBER := NULL, delo_addr VARCHAR2 := NULL, result_cur IN OUT kurs3.curstype) AS
    ul_  VARCHAR2 (200);
    dom_ VARCHAR2 (200);
    kv_  VARCHAR2 (200);
  BEGIN
    IF TRIM (delo_addr) IS NOT NULL THEN
      ul_   := TRIM (SUBSTR (TRIM (delo_addr) || ' ', 1, INSTR (TRIM (delo_addr) || ' ', ' ', 1, 1)));

      IF INSTR (TRIM (delo_addr), ' ', 1, 1) > 0 THEN
        dom_      :=
          TRIM (
            SUBSTR (TRIM (delo_addr) || ' '
                   ,INSTR (TRIM (delo_addr) || ' ', ' ', 1, 1)
                   ,INSTR (TRIM (delo_addr) || ' ', ' ', 1, 2) - INSTR (TRIM (delo_addr) || ' ', ' ', 1, 1)
                   )
          );
      END IF;

      IF INSTR (TRIM (delo_addr), ' ', 1, 2) > 0 THEN
        kv_   := TRIM (SUBSTR (TRIM (delo_addr), INSTR (TRIM (delo_addr), ' ', 1, 2)));
      END IF;

      --      OPEN result_cur FOR SELECT UPPER (ul_) AS ul, UPPER (dom_) AS dom, '%КВ.' || UPPER (kv_) AS kv FROM DUAL;
      --      RETURN;

      OPEN result_cur FOR
          SELECT d.delo_id, d.delo_addr, get_affair_num_fmt (da.object_rel_id, 1) AS affair_num, get_person1b (da.object_rel_id) AS affair_master
            FROM scan.ea_delo d, scan.ea_delo_attr da
           WHERE d.object_type_id = 6 AND d.delo_id = da.delo_id(+) AND da.delo_version(+) = 0 AND da.object_type_id(+) = 1
                 AND d.delo_id IN
                       (SELECT dd.delo_id
                          FROM scan.ea_delo dd
                         WHERE     UPPER (dd.delo_addr) LIKE '%' || UPPER (ul_) || '%'
                               AND UPPER (dd.delo_addr) LIKE '%' || UPPER (dom_) || '%'
                               AND UPPER (REPLACE (dd.delo_addr, ' ', '')) LIKE '%КВ.' || UPPER (kv_) || '%')
        ORDER BY d.delo_addr;

      RETURN;
    END IF;

    OPEN result_cur FOR
        SELECT d.delo_id, d.delo_addr, get_affair_num_fmt (da.object_rel_id, 1) AS affair_num, get_person1b (da.object_rel_id) AS affair_master
          FROM scan.ea_delo d, scan.ea_delo_attr da
         WHERE d.object_type_id = 6 AND d.delo_id = da.delo_id(+) AND da.delo_version(+) = 0 AND da.object_type_id(+) = 1
               AND d.delo_id IN
                     (SELECT d2.delo_id
                        FROM scan.ea_delo d1, scan.ea_delo d2
                       WHERE d1.delo_id = verify_delo_search.delo_id AND d1.delo_id <> d2.delo_id AND d1.unom = d2.unom AND d1.unkv = d2.unkv)
      ORDER BY d.delo_addr;
  END verify_delo_search;

  PROCEDURE verify_delo_docs_move (p_from_delo_id         NUMBER
                                  ,p_to_delo_id           NUMBER
                                  ,p_new_delo_addr        VARCHAR2 := NULL
                                  ,p_docs                 number_table_type
                                  ,p_confirm              NUMBER --0 - проверка; 1 - проверка и перемещение
                                  ,msg_id          IN OUT NUMBER --1 - проверки успешны, 2 - перемещены, 3 - перемещены, пакет можно удалять, -1 - проверки неуспешны
                                  ,msg             IN OUT VARCHAR2
                                  ,p_new_delo_id   IN OUT NUMBER
                                  ) AS
    delete_from NUMBER;
  BEGIN
    p_new_delo_id   := p_to_delo_id;

    IF (p_docs IS NULL OR p_docs.COUNT = 0) THEN
      msg      := 'Не выбраны документы для перемещения';
      msg_id   := -1;
      RETURN;
    END IF;

    --Пакет не занят и статус подходящий
    IF get_read_only (typ => 51, a_id => p_from_delo_id) NOT IN (7, 5, 2) THEN
      msg      := 'Пакет сканирования недоступен для перемещения документов';
      msg_id   := -1;
      RETURN;
    END IF;

    IF (NVL (p_from_delo_id, 0) = 0 OR NVL (p_to_delo_id, 0) = 0) THEN
      msg      := 'Не задан пакет для перемещения';
      msg_id   := -1;
      RETURN;
    END IF;

    IF (p_from_delo_id = p_to_delo_id) THEN
      msg      := 'Пакет выбран некорректно';
      msg_id   := -1;
      RETURN;
    END IF;

    IF (p_to_delo_id = -1 AND TRIM (p_new_delo_addr) IS NULL) THEN
      msg      := 'Не задан адрес нового пакета';
      msg_id   := -1;
      RETURN;
    END IF;

    IF (p_to_delo_id > 0 AND get_read_only (typ => 51, a_id => p_to_delo_id) NOT IN (7, 5, 2)) THEN
      msg      := 'Пакет-адресат недоступен для перемещения в него документов';
      msg_id   := -1;
      RETURN;
    END IF;

    ------------------------------------
    --Проверки прошли И подтверждение есть
    ------------------------------------
    IF (p_confirm = 1) THEN
      --Создание нового пакета (если этот вариант)
      IF (p_to_delo_id = -1) THEN
        INSERT INTO scan.ea_delo (delo_id, object_type_id, status, delo_addr, user_id, last_change)
             VALUES (NULL, 6, 1, TRIM (verify_delo_docs_move.p_new_delo_addr), get_user_unique_id (kurs3_var.get_user_id_f), SYSDATE)
          RETURNING delo_id
               INTO verify_delo_docs_move.p_new_delo_id;

        filer_log (obj_type_id => 29, obj_id => p_new_delo_id, op_type => 2);
      END IF;

      --перепривязка документов
      FOR rec
        IN (SELECT d.ROWID AS rid, d.document_id, d.delo_id, da.object_type_id, da.object_rel_id
              FROM scan.ea_document d, scan.ea_document_attr da
             WHERE     d.delo_id = verify_delo_docs_move.p_from_delo_id
                   AND d.document_id IN (SELECT COLUMN_VALUE FROM TABLE (verify_delo_docs_move.p_docs))
                   AND d.document_id = da.document_id(+)) LOOP
        --отвяжем документы от объектов
        IF rec.object_type_id IS NOT NULL THEN
          unset_objects_link (p_obj_1_type => 14
                             ,p_obj_1_id => rec.document_id
                             ,p_obj_2_type => rec.object_type_id
                             ,p_obj_2_id => rec.object_rel_id
                             ,finish_commit => 0
                             );
        END IF;

        -- привяжем к новому делу
        UPDATE scan.ea_document dd
           SET dd.delo_id   = verify_delo_docs_move.p_new_delo_id
         WHERE dd.ROWID = rec.rid;

        filer_log (obj_type_id => 31, obj_id => rec.document_id, op_type => 1, old_value => rec.delo_id, new_value => p_new_delo_id);
      END LOOP;

      COMMIT;

      SELECT COUNT (1)
        INTO delete_from
        FROM (SELECT 1
                FROM scan.ea_document
               WHERE delo_id = p_from_delo_id
              UNION
              SELECT 1
                FROM scan.ea_delo_attr
               WHERE delo_id = p_from_delo_id);

      IF (delete_from = 0) THEN
        msg_id   := 3;
      ELSE
        msg_id   := 2;
      END IF;

      msg   := 'Документы успешно перенесены';
      RETURN;
    ELSE
      msg_id   := 1;

      IF (p_to_delo_id = -1) THEN
        msg   := 'Создать новый пакет и Перенести отмеченные документы?';
      ELSE
        msg   := 'Перенести отмеченные документы в выбранный пакет?';
      END IF;
    END IF;
  END verify_delo_docs_move;

  PROCEDURE del_verify_delo (delo_id NUMBER, msg_id IN OUT NUMBER, msg IN OUT VARCHAR2) AS
    can_delete NUMBER;
  BEGIN
    SELECT COUNT (1)
      INTO can_delete
      FROM (SELECT 1
              FROM scan.ea_delo_attr da
             WHERE da.delo_id = del_verify_delo.delo_id);

    IF (can_delete > 0) THEN
      msg_id   := -1;
      msg      := 'Дело имеет связку с КПУ. Вначале удалите эту связку';
      RETURN;
    ELSE
      FOR rec IN (SELECT dd.ROWID AS rid, dd.delo_id, dd.status
                    FROM scan.ea_delo dd
                   WHERE dd.delo_id = del_verify_delo.delo_id) LOOP
        UPDATE scan.ea_delo dd
           SET dd.status = 5, dd.user_id = get_user_unique_id (kurs3_var.get_user_id_f), dd.last_change = SYSDATE
         WHERE dd.ROWID = rec.rid;

        filer_log (obj_type_id => 9, obj_id => rec.delo_id, op_type => 1, old_value => rec.status);
      END LOOP;

      COMMIT;
      msg_id   := 1;
    END IF;
  END del_verify_delo;


  PROCEDURE upd_verify_delo_addr (delo_id NUMBER, delo_addr VARCHAR2, msg_id IN OUT NUMBER, msg IN OUT VARCHAR2) AS
  BEGIN
    IF get_read_only (typ => 51, a_id => delo_id) NOT IN (7, 5, 2) THEN
      msg      := 'Пакет сканирования недоступен для смены адреса';
      msg_id   := -1;
      RETURN;
    END IF;

    IF TRIM (delo_addr) IS NULL THEN
      msg      := 'Новый адрес пакета не задан';
      msg_id   := -1;
      RETURN;
    END IF;

    FOR rec IN (SELECT dd.ROWID AS rid, dd.delo_id, dd.delo_addr
                  FROM scan.ea_delo dd
                 WHERE dd.delo_id = upd_verify_delo_addr.delo_id) LOOP
      UPDATE scan.ea_delo dd
         SET dd.delo_addr   = TRIM (upd_verify_delo_addr.delo_addr)
            ,user_id        = get_user_unique_id (kurs3_var.get_user_id_f)
            ,last_change    = SYSDATE
            ,unom           = NULL
            ,unkv           = NULL
       WHERE dd.ROWID = rec.rid;

      filer_log (obj_type_id => 30, obj_id => rec.delo_id, op_type => 1, old_value => rec.delo_addr, new_value => TRIM (upd_verify_delo_addr.delo_addr));
    END LOOP;

    COMMIT;

    msg_id   := 1;
  END upd_verify_delo_addr;

  FUNCTION get_doc_grp_type (p_type_id IN NUMBER)
    RETURN NUMBER AS
    result NUMBER (2);
  BEGIN
    result      :=
      CASE
        WHEN p_type_id IN (7, 8, 26, 27, 82, 100, 102, 155, 156, 157, 161, 162, 163, 164, 166, 167, 177, 182, 187, 188, 193, 201, 207) THEN
          1
        WHEN p_type_id IN (11, 12, 14, 16, 17, 35, 57, 59, 65, 66, 67, 72, 76, 77, 99, 101, 106, 107, 110, 192, 205, 206, 216, 220) THEN
          2
        WHEN p_type_id IN (10, 25, 37, 41, 42, 43, 146, 147, 148, 151, 154, 159, 165, 173, 174, 179, 189, 209) THEN
          3
        WHEN p_type_id IN (230, 20, 21, 22, 84, 118, 122, 124, 125, 127, 128, 129, 130, 131, 132, 133, 134, 135, 140, 141, 142, 143, 144) THEN
          4
        WHEN p_type_id IN
               (234
               ,226
               ,233
               ,9
               ,15
               ,18
               ,38
               ,39
               ,58
               ,60
               ,61
               ,62
               ,63
               ,64
               ,68
               ,69
               ,73
               ,74
               ,85
               ,89
               ,93
               ,98
               ,115
               ,117
               ,137
               ,139
               ,149
               ,152
               ,169
               ,180
               ,185
               ,196
               ,214) THEN
          5
        WHEN p_type_id IN (2, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 116, 126, 200) THEN
          6
        WHEN p_type_id IN
               (225, 227, 228, 23, 36, 40, 83, 86, 87, 88, 90, 94, 95, 96, 97, 103, 105, 108, 111, 119, 123, 136, 138, 168, 172, 175, 203, 208, 213) THEN
          7
        WHEN p_type_id IN (223, 3, 4, 5) THEN
          8
        WHEN p_type_id IN (224, 13, 24, 44, 78, 79, 80, 81, 158, 178, 184, 190, 194, 210, 211, 212) THEN
          9
        WHEN p_type_id IN (229, 56, 92, 109, 112, 145, 202) THEN
          10
        WHEN p_type_id IN (221, 222, 1, 28, 29, 30, 31, 32, 34, 171) THEN
          11
        WHEN p_type_id IN (231, 232, 6, 19, 33, 70, 71, 91, 104, 114, 120, 121, 170, 176, 183, 186, 195, 199, 215, 217, 218, 219) THEN
          12
      END;
    RETURN result;
  END get_doc_grp_type;

  PROCEDURE get_affair_delo_list (affair_id IN NUMBER, records IN OUT kurs3.curstype) AS
  BEGIN
    IF records%ISOPEN THEN
      CLOSE records;
    END IF;

    OPEN records FOR
      SELECT ed.delo_id AS id
            ,   'Пакет #'
             || ed.delo_id
             || ' отсканирован '
             || TO_CHAR (ed.scan_date, 'dd.mm.yyyy')
             || ' выверен '
             || TO_CHAR (ed.last_change, 'dd.mm.yyyy')
               AS name
            ,1 AS has_childs
            ,0 AS is_file
        FROM affair aff, scan.ea_delo ed, scan.ea_delo_attr eda
       WHERE     aff.affair_id = get_affair_delo_list.affair_id
             AND aff.affair_stage = 1
             AND ed.object_type_id = 6
             AND ed.delo_id = eda.delo_id
             AND eda.object_type_id = 1
             AND eda.row_status = 1
             AND eda.object_rel_id = aff.affair_id
             AND ed.status = 2 -- ВЫВЕРЕНО
                              ;
  END get_affair_delo_list;

 /* PROCEDURE get_delo_doc_types (delo_id IN NUMBER, records IN OUT kurs3.curstype) AS
  --
  --  01.03.2012  BlackHawk  Переделал decode для is_bad
  --
  BEGIN
    IF records%ISOPEN THEN
      CLOSE records;
    END IF;

    OPEN records FOR
      SELECT delo_id * 100 + grp_num AS id
            , (CASE grp_num
                 WHEN 1 THEN 'личные документы граждан'
                 WHEN 2 THEN 'жилищные документы'
                 WHEN 3 THEN 'документы о наличии или отсутствии собственности'
                 WHEN 4 THEN 'РП (РД) и решения органов исполнительной власти'
                 WHEN 5 THEN 'внутренние документы Управления ДЖП и ЖФ'
                 WHEN 6 THEN 'заявления, извещения'
                 WHEN 7 THEN 'переписка'
                 WHEN 8 THEN 'архивные документы'
                 WHEN 9 THEN 'документы о льготах'
                 WHEN 10 THEN 'судебные решения'
                 WHEN 11 THEN 'договора'
                 WHEN 12 THEN 'разное'
                 WHEN 13 THEN 'отправлено на пересканирование'
               END)
               AS name
            ,1 AS has_childs
            ,0 AS is_file
        FROM (  SELECT DECODE (vv.is_bad, 1, 13, vv.grp_num) AS grp_num, vv.delo_id
                  FROM (SELECT pkg_scan.get_doc_grp_type (dd.doc_type_id) grp_num, dd.delo_id, DECODE (dd.scan_quality, 2, 1, dd.bad_scan) AS is_bad
                          FROM scan.ea_document dd
                         WHERE dd.delo_id = get_delo_doc_types.delo_id) vv
              GROUP BY vv.delo_id, DECODE (vv.is_bad, 1, 13, vv.grp_num)
              ORDER BY 1);
  END get_delo_doc_types;

  PROCEDURE get_delo_doc_list (delo_id IN NUMBER, records IN OUT kurs3.curstype) AS
    v_delo_id NUMBER := TRUNC (delo_id / 100);
    v_doc_grp NUMBER := MOD (delo_id, 100);
  --
  --  01.03.2012  BlackHawk  Переделал decode для is_file
  --                         Переделал условие для 13 группы
  --
  BEGIN
    IF records%ISOPEN THEN
      CLOSE records;
    END IF;

    OPEN records FOR
        SELECT doc_arch_id AS id
              ,NVL (doc_num, '---') || ' / ' || TO_CHAR (doc_date, 'dd.mm.yyyy') || ' (' || doc_type_name || ')' AS name
              ,0 AS has_childs
              ,DECODE (dd.scan_quality, 2, 0, DECODE (dd.bad_scan, 1, 0, 1)) AS is_file
          FROM scan.ea_document dd, scan.ea_doc_type edt
         WHERE     dd.delo_id = v_delo_id
               AND (pkg_scan.get_doc_grp_type (dd.doc_type_id) = v_doc_grp OR (v_doc_grp = 13 AND DECODE (dd.scan_quality, 2, 1, dd.bad_scan) = 1))
               AND dd.doc_type_id = edt.doc_type_id(+)
      ORDER BY dd.doc_date DESC;
  END get_delo_doc_list;
  */
  
    PROCEDURE get_delo_doc_types (delo_id IN NUMBER, records IN OUT kurs3.curstype) AS
  --
  --  01.03.2012 BlackHawk  Переделал decode для is_bad
  --  21.02.2012 Иконников. Добавил 14-и режим
  BEGIN
    IF records%ISOPEN THEN
      CLOSE records;
    END IF;

    OPEN records FOR
        SELECT delo_id * 100 + grp_num AS id
            , (CASE grp_num
                 WHEN 1 THEN 'личные документы граждан'
                 WHEN 2 THEN 'жилищные документы'
                 WHEN 3 THEN 'документы о наличии или отсутствии собственности'
                 WHEN 4 THEN 'РП (РД) и решения органов исполнительной власти'
                 WHEN 5 THEN 'внутренние документы Управления ДЖП и ЖФ'
                 WHEN 6 THEN 'заявления, извещения'
                 WHEN 7 THEN 'переписка'
                 WHEN 8 THEN 'архивные документы'
                 WHEN 9 THEN 'документы о льготах'
                 WHEN 10 THEN 'судебные решения'
                 WHEN 11 THEN 'договора'
                 WHEN 12 THEN 'разное'
                 WHEN 13 THEN 'отправлено на пересканирование'
                 WHEN 14 THEN 'пересканированию не подлежит'
               END)
               AS name
            ,1 AS has_childs
            ,0 AS is_file
        FROM (SELECT 
                   DECODE (vv.is_bad, 0, vv.grp_num, 1,13,2,14) AS grp_num, 
                   vv.delo_id
              FROM (SELECT pkg_scan.get_doc_grp_type (dd.doc_type_id) grp_num, 
                          dd.delo_id, 
                          CASE 
                              WHEN dd.source_quality = 2 THEN 2
                              WHEN (dd.scan_quality = 2) OR (dd.bad_scan =1) THEN 1  
                              ELSE 0
                          END is_bad      
                    FROM scan.ea_document dd
                    WHERE dd.delo_id = get_delo_doc_types.delo_id) vv
              GROUP BY vv.delo_id , DECODE (vv.is_bad, 0, vv.grp_num, 1,13,2,14)
        ORDER BY 1);
  END get_delo_doc_types;

  PROCEDURE get_delo_doc_list (delo_id IN NUMBER, records IN OUT kurs3.curstype) AS
                                      -- delo_id = 11603704
    v_delo_id NUMBER := TRUNC (delo_id / 100);  -- 116037
    v_doc_grp NUMBER := MOD (delo_id, 100); -- 04
  --
  --  01.03.2012  BlackHawk  Переделал decode для is_file
  --                         Переделал условие для 13 группы
  --  21.02.2012 Иконников. Добавил 14-и режим
  BEGIN
    IF records%ISOPEN THEN
      CLOSE records;
    END IF;

    OPEN records FOR
      SELECT doc_arch_id AS id,
             NVL (doc_num, '---') || ' / ' || TO_CHAR (doc_date, 'dd.mm.yyyy') || ' (' || doc_type_name || ')' AS name,
             0 AS has_childs,

--             DECODE (dd.source_quality, 2, 0, DECODE (dd.scan_quality, 2, 0, DECODE (dd.bad_scan, 1, 0, 1))) AS is_file
             CASE 
               WHEN dd.source_quality = 2 OR dd.scan_quality = 2 OR dd.bad_scan = 1  THEN 0
               ELSE 1
             END is_file      


      FROM scan.ea_document dd, scan.ea_doc_type edt
      WHERE dd.delo_id = v_delo_id
        AND dd.doc_type_id = edt.doc_type_id(+)
        AND ((pkg_scan.get_doc_grp_type (dd.doc_type_id) = v_doc_grp)
         OR (v_doc_grp =13 AND DECODE (dd.scan_quality, 2, 1, dd.bad_scan) = 1)
         OR (v_doc_grp =14 AND DECODE (dd.source_quality, 2, 1, 0) = 1))
       AND ( 
               (CASE 
                 WHEN v_doc_grp NOT IN (13,14)  AND (dd.source_quality = 2 OR dd.scan_quality = 2 OR dd.bad_scan = 1)  THEN 0
                 ELSE 1
               END) =1      
           )  

     ORDER BY dd.doc_date DESC;
  END get_delo_doc_list;
  
  -- Установка значения source_quality - качество исходного документа
  FUNCTION ChangeBadScanType (v_document_id IN NUMBER, v_source_quality IN NUMBER, v_CommitIt NUMBER) RETURN NUMBER
  AS
  BEGIN
    UPDATE scan.ea_document
       SET source_quality = v_source_quality
     WHERE document_id = v_document_id;
    IF v_CommitIt = 1 THEN 
      COMMIT;
    END IF;
    
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN
 --      Dbms_Output.Put_Line(Sqlerrm||' Err_Message'||pErr_Message);
       RETURN 0;
       
  END;
  
--  21.11.2013 Dik#  новые процедуры для использоания в интерфейсе 

   -- Получить количество связанных документов КПУ в деле
  FUNCTION get_LnkDocOfAffair_delo_count (p_delo_id IN NUMBER) RETURN NUMBER
  As
   Res Number := 0;  
  begin
   SELECT Count (*) into Res
   FROM scan.ea_document_attr eda, scan.ea_document ed
   WHERE ed.document_id = eda.document_id --документы
        and ed.delo_id  = p_delo_id       -- из заданного дела
        and eda.object_type_id in (1,7,12) -- (AFFAIR(документ о приеме на учет),PERSON,PRIV_DOC)
        and eda.document_version = 0 -- последний документ
        and eda.row_status = 1       --актуальная записсь
        and NVL(eda.object_rel_id,0) > 0; -- связан с документом КПУ            
   RETURN Res;  
       
   EXCEPTION
   WHEN OTHERS THEN  RETURN  -1;
  end get_LnkDocOfAffair_delo_count;   

-- Проверить привязки КПУ к пакетам сканирования
FUNCTION get_affair_delo_link (p_affair_id IN NUMBER, p_delo_id IN NUMBER := 0, p_mess OUT varchar2 )  RETURN NUMBER
As
  cursor delo_id_cur is
    SELECT TO_CHAR(ed.delo_id) as id 
        FROM scan.ea_delo ed, scan.ea_delo_attr eda
       WHERE ed.object_type_id = 6
             AND ed.delo_id = eda.delo_id
             AND eda.object_type_id = 1
             AND eda.row_status = 1
             AND NVL(eda.object_rel_id,-1) = p_affair_id;
  v_delo_id delo_id_cur%rowtype;
  res Number := 0; 
  v_mess  varchar2(1000) := ' ';
  C_CRLF  constant char(2)  := CHR(10)||CHR(13);
  c_Priv_MORE_DELO constant number := 122;  -- привилегия «Привязка нескольких пакетов к одному КПУ» 
begin
 p_mess := ''; 
 if p_delo_id > 0 then -- привязано ли дело к КПУ?
   SELECT count(*) into res
        FROM scan.ea_delo ed, scan.ea_delo_attr eda
       WHERE ed.object_type_id = 6
             AND ed.delo_id = eda.delo_id
             AND eda.object_type_id = 1
             AND eda.row_status = 1
             AND NVL(eda.object_rel_id,-1) > 0 -- p_affair_id
             and ed.delo_id = p_delo_id;
   if res > 0 then
    res := 1;
    p_mess := 'Пакет № '|| TO_CHAR(p_delo_id)|| ' уже привязано к КПУ'; 
    return res; --уходим
   end if;             
 end if;
 
 open delo_id_cur;
 loop 
   fetch delo_id_cur into  v_delo_id;
   EXIT WHEN delo_id_cur%NOTFOUND;
   if v_mess = ' ' 
      then  v_mess := v_delo_id.id;
      else v_mess :=v_mess||', '|| v_delo_id.id;
   end if;
 end loop;
  res := delo_id_cur%rowcount;
 close delo_id_cur;

 if res > 0 then
   if get_user_priv_1(kurs3_var.global_user_id,c_Priv_MORE_DELO)>0
    then  res := 3;
    else  res := 2;
   end if; 
    p_mess := 'КПУ привязано к пакету № '|| v_mess; 
 end if;
    
 return res; 
 
end get_affair_delo_link;


-- Распарсить адрес дела для поиска КПУ
 PROCEDURE parse_delo_adr (p_delo_id IN NUMBER, p_cur IN OUT kurs3.curstype)
 as
  cursor delo_adr_cur is
         SELECT delo_addr, unom, unkv  FROM SCAN.ea_delo WHERE delo_id=p_delo_id;
  i  delo_adr_cur%rowtype;      
  l_unom_ NUMBER := 0; 
  l_unkv_ NUMBER := 0;
  l_next_work_num_ NUMBER;
  l_ul_ VARCHAR2(200); 
  l_dmt_ VARCHAR2(200); 
  l_krt_ VARCHAR2(200); 
  l_strt_ VARCHAR2(200); 
  l_apart_ VARCHAR2(200);
  N NUMBER:=0;
  s varchar2(1):='/';
 begin   
  IF p_cur%ISOPEN THEN
      CLOSE p_cur;
  END IF;
	open delo_adr_cur;
  fetch delo_adr_cur into i;
  if delo_adr_cur%NOTFOUND then
    l_ul_ :='';
		l_dmt_:='';
		l_krt_:='';
		l_strt_:='';
		l_apart_:='';
  else
    l_unom_:=i.unom; l_unkv_:=i.unkv;
    
    l_ul_:=REGEXP_REPLACE(LOWER(i.delo_addr), '(\,|улица|ул\.|\.)', '');
    l_ul_:=REGEXP_REPLACE(l_ul_,'\d+\-я',''); 
    l_ul_:=REGEXP_REPLACE(l_ul_,'\d+\-й','');
    l_ul_:=REGEXP_REPLACE(l_ul_,'\d+\я',''); 
    l_ul_:=REGEXP_REPLACE(l_ul_,'\d+\й','');
    l_ul_:=trim(l_ul_);
    IF(INSTR(l_ul_,' ')>1) THEN 
      l_ul_:=SUBSTR(l_ul_, 1, INSTR(l_ul_,' '));
      l_ul_:=trim(l_ul_);
    END IF;			
			
    l_apart_:=REGEXP_REPLACE(LOWER(i.delo_addr),'(\,|\.|\ )','');
    l_apart_:=REGEXP_SUBSTR(l_apart_, 'кв\d+');
    l_apart_:=REPLACE(LOWER(l_apart_),'кв','');
			
    l_dmt_:=REPLACE(LOWER(i.delo_addr),'д.','дом');
    l_dmt_:=REGEXP_REPLACE(l_dmt_,'(\.|\ )','');
    l_dmt_:=REGEXP_SUBSTR(l_dmt_, 'дом(\d|\/)+');
    l_dmt_:=REPLACE(l_dmt_,'дом','');
		N:=instr(l_dmt_,s);
    if N>0 then
      l_dmt_:=substr(l_dmt_,1,N-1);
    end if;
    	
    l_krt_:=REGEXP_REPLACE(LOWER(i.delo_addr), '(к\.|кор\.|корп\.)','корпус');
    l_krt_:=REPLACE(l_krt_,' ','');
    l_krt_:=REGEXP_SUBSTR(l_krt_, 'корпус(\d|\/)+');
    l_krt_:=REPLACE(l_krt_,'корпус','');
    
			
    l_strt_:=REGEXP_REPLACE(LOWER(i.delo_addr), '(с\.|стр\.)','строение');
    l_strt_:=REPLACE(l_strt_,' ','');
    l_strt_:=REGEXP_SUBSTR(l_strt_, 'строение(\d|\/)+');
    l_strt_:=REPLACE(l_strt_,'строение','');
  end if;
 close delo_adr_cur;
  OPEN p_cur FOR
      SELECT l_unom_ as unom,l_unkv_ as unkv, l_ul_ as ul,l_dmt_ as dom,l_krt_ as korp,l_strt_ as stroen,l_apart_ as apart from dual;

 end parse_delo_adr; 
 
 	--Поиск по адресу
	PROCEDURE search_affair_for_addr(
   p_ul in STREET.Full_Name%Type ,
   p_dom in BUILDING.House_Num%type,
   p_korp in BUILDING.BUILDING_NUM%type, 
   p_stroen in BUILDING.CONSTRUCTION_NUM%type,
   p_apart in APARTMENT.APARTMENT_NUM%type,
   p_unom NUMBER :=NULL	,
   p_unkv NUMBER :=NULL ,
   msg IN OUT VARCHAR2 ,
	 msg_id IN OUT NUMBER
	)AS
	count_ NUMBER := 0;
	osn_exist_ NUMBER;
	c_list_num constant NUMBER := 0;
  c_list_cod constant NUMBER := 1;
	BEGIN
		
		IF(p_ul IS NULL OR LENGTH(p_ul)< 4)THEN
			msg:='Часть наименования Улицы должна быть не менее 3-символов';
			msg_id:=-1;
			RETURN;
		END IF;
		
		IF(p_dom IS NULL AND p_korp IS NULL AND p_stroen IS NULL)THEN
			msg:='Должно быть заполнено одно из полей: дом, корпус, строение';
			msg_id:=-1;
			RETURN;
		END IF;

		
		DELETE FROM AFFAIRS_LIST al
		WHERE al.list_cod=c_list_cod AND list_num=c_list_num AND user_id=kurs3_var.get_user_id_f;
		
		SELECT COUNT(*) INTO osn_exist_ FROM kurs3.lists_names
		WHERE list_cod=c_list_cod AND list_num=c_list_num AND user_id=kurs3_var.get_user_id_f;
		
		IF(osn_exist_=0)THEN
			INSERT INTO kurs3.lists_names (user_id, list_num, list_name, list_cod)
           VALUES (kurs3_var.get_user_id_f, c_list_num, 'Основной список', c_list_cod);
			COMMIT;
		END IF;
   
   INSERT INTO AFFAIRS_LIST(user_id, list_cod, list_num, affair_id, datetime, note)
    (select kurs3_var.get_user_id_f as user_id, c_list_cod, c_list_num, ag.affair_id, SYSDATE as datetime ,1 as note 
     from ( 
      select af.affair_id   from 
      AFFAIR af ,
      BUILDING b, STREET s,
      APARTMENT ap
      where 
          af.apart_id = ap.apart_id
      and af.build_id = b.building_id 
      and b.street = s.street_id
      and (UPPER(s.full_name) LIKE '%'||REPLACE(UPPER(trim(REPLACE(p_ul,'''',''))),'Ё','Е')||'%') 
      and ((b.house_num = p_dom) or (p_dom is NULL))
      and ((b.BUILDING_NUM = p_korp) or (p_korp is NULL))
      and ( (b.CONSTRUCTION_NUM = p_stroen ) or (p_stroen is NULL))
      and ( (ap.apartment_num = p_apart ) or (p_apart is NULL))
      UNION ALL
      select af.affair_id  from  AFFAIR af , APARTMENT ap
      where 
          af.apart_id = ap.apart_id
      and (ap.unom_bti = p_unom)
      and (ap.unkv_bti = p_unkv)
      ) ag
    group by ag.affair_id
    );
		count_ := sql%rowcount;	
  COMMIT;

	IF(count_=0)THEN
			msg:='КПУ по заданному адресу не найдены';
			msg_id:=-1;
	 else
 		msg_id:=1;
		msg:='';    	
	END IF;
		
END search_affair_for_addr;
 
-- Получить принак изменения КПУ после выверки пакета
FUNCTION get_is_affair_change_after (p_delo_id IN NUMBER) RETURN NUMBER
as
  v_Result NUMBER :=0; 
  v_affair_change scan.ea_delo.affair_change%type := NULL;
begin
   select ed.affair_change into v_affair_change from scan.ea_delo ed 
   where ed.status = 2 and ed.delo_id = p_delo_id;
   
   if v_affair_change is null
    then return v_Result; -- -1;как вариант
   end if;

 select count(vd.delo_id) into v_Result from kurs3.V_KURS3_SCAN_VIVERKA_DATE vd
  where vd.delo_id=p_delo_id
    and NVL(vd.viverka_date, cast('01.01.1800' as date)) <  v_affair_change;

  if v_Result > 0
    then v_Result := 1;
  end if;    

  return v_Result;
  EXCEPTION
   WHEN OTHERS THEN  RETURN 0; 
end get_is_affair_change_after;
--/  21.11.2013 Dik#   
END pkg_scan;
/
