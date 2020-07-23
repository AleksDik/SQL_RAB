CREATE OR REPLACE PROCEDURE link_kurs_with_scan AS
  --
  --  Процедура связки данных в КУРС-3 (КПУ,люди,справки о льготах) с электронным архивом
  --
  --  18.11.2011  BlackHawk  Создание
  --  06.03.2012  BlackHawk  Добавил проверку на наличие связки документа (document_id) в таблице scan.ea_document_attr
  --  21.11.2013 Dik#        Более одного КПУ по одному адресу привязку не осуществлять; КПУ было привязано к пакету, привязку не осуществлять. (задача 1.115)
  nn             NUMBER := 0;
  kk             NUMBER (1);
  k3_affair_id   NUMBER;
  k3_building_id NUMBER;
  pers_cnt       NUMBER := 0;
  pers_founded   NUMBER := 0;
  affair_cnt     NUMBER;
  cnt            NUMBER :=0;
  v_mess        varchar2(500) := '';  --  21.11.2013 Dik# 
BEGIN
  FOR rec IN (SELECT *
                FROM scan.ea_delo ed
               WHERE ed.object_type_id = 6
                     AND NOT EXISTS
                           (SELECT 1
                              FROM scan.ea_delo_attr eda
                             WHERE eda.delo_id = ed.delo_id AND eda.object_type_id = 1)) LOOP
    nn               := nn + 1;
    k3_affair_id     := NULL;
    k3_building_id   := NULL;
    affair_cnt       := 0;

    -- пробуем поискать по UNOM+UNKV
    IF rec.unom IS NOT NULL AND rec.unkv IS NOT NULL THEN
      FOR rr IN (SELECT ast.unom, ast.unkv, ast.kv, ast.kvi
                   FROM bti.appart_st_cards ast
                  WHERE ast.unom = rec.unom AND ast.unkv = rec.unkv
                 UNION ALL
                 SELECT rec.unom AS unom, rec.unkv AS unkv, 0 AS kv, '' AS kvi
                   FROM DUAL
                  WHERE rec.unkv = 0) LOOP
        -- квартира в нашем БТИ нашлась.
        -- ищем в К3 корпус:
        FOR vv IN (SELECT bb.building_id
                     FROM bti.building_bti bb
                    WHERE bb.unom = rr.unom AND bb.building_id IS NOT NULL
                   UNION ALL
                   SELECT building.building_id
                     FROM bti.building_bti bb, building
                    WHERE bb.unom = rr.unom AND bb.building_id IS NULL AND building.bti_unom = bb.unom) LOOP
          k3_building_id   := vv.building_id;

          -- ищем в доме квартиру с КПУ:
          FOR aff_rec
            IN (  SELECT aff.*
                    FROM apartment ap, affair aff
                   WHERE     ap.building_id = vv.building_id
                         AND ap.apartment_num = rr.kv
                         AND NVL (ap.apartment_idx, ' ') = NVL (rr.kvi, ' ')
                         AND aff.apart_id = ap.apart_id
                         AND aff.reason IN (1, 97, 21)
                         AND aff.affair_stage = 1
                ORDER BY aff.status) LOOP
            IF k3_affair_id IS NULL THEN
              affair_cnt   := 1;

              -- попробуем номер КПУ+дата решения?
              IF aff_rec.delo_date = rec.delo_date AND INSTR (rec.delo_num, TRIM (TO_CHAR (TRUNC (aff_rec.delo_num / 10)))) > 0 THEN
                k3_affair_id   := aff_rec.affair_id;
              END IF;

              IF k3_affair_id IS NULL THEN
                -- Проверим по фамилиям
                pers_founded   := 0;
                pers_cnt       := 0;

                FOR pers
                  IN (SELECT REPLACE (LOWER (pp.last_name) || LOWER (pp.pat) || LOWER (pp.patronymic), ' ', '') AS fio
                            ,NVL (pp.birthday, SYSDATE + 1) AS birthday
                            ,NVL (TRUNC (pp.birthday, 'yyyy'), SYSDATE + 1) AS birthday_year
                            ,REPLACE (LOWER (pp.last_name), ' ', '') AS last_name
                        FROM person pp, person_relation_delo prd
                       WHERE prd.affair_id = aff_rec.affair_id AND prd.affair_stage = 1 AND pp.person_id = prd.person_id) LOOP
                  pers_cnt   := pers_cnt + 1;

                  FOR s_pers
                    IN (SELECT REPLACE (LOWER (person_fio), ' ', '') AS fio
                              ,NVL (birth_date, SYSDATE) AS birth_date
                              ,NVL (TRUNC (birth_date, 'yyyy'), SYSDATE) AS birth_date_year
                          FROM scan.ea_delo_person pp
                         WHERE pp.delo_id = rec.delo_id) LOOP
                    IF pers.fio = s_pers.fio AND (pers.birthday = s_pers.birth_date OR pers.birthday_year = s_pers.birth_date_year) THEN
                      pers_founded   := pers_founded + 1;
                    ELSIF INSTR (s_pers.fio, pers.last_name) > 0
                          AND (pers.birthday = s_pers.birth_date OR pers.birthday_year = s_pers.birth_date_year) THEN
                      pers_founded   := pers_founded + 1;
                    END IF;
                  END LOOP;
                END LOOP;

                IF pers_cnt > 0 THEN
                  IF pers_founded * 100 / pers_cnt < 50 THEN
                    -- надо проверять ещё :-(
                    INSERT INTO rdn_dog_log (dt_stamp, order_id, sql_err_code, sql_err_txt)
                         VALUES (
                                  SYSDATE
                                 ,rec.delo_id
                                 ,1
                                 ,aff_rec.affair_id || ' %%=' || (pers_founded * 100 / pers_cnt) || ' (' || pers_founded || '/' || pers_cnt || ')'
                                );
                  ELSE
                    k3_affair_id   := aff_rec.affair_id;
                  END IF;
                ELSE
                  -- надо проверять ещё :-(
                  INSERT INTO rdn_dog_log (dt_stamp, order_id, sql_err_code, sql_err_txt)
                       VALUES (SYSDATE, rec.delo_id, 2, aff_rec.affair_id);
                END IF;
              END IF;
            ELSE
              --k3_affair_id   := -ABS (k3_affair_id);
              affair_cnt   := affair_cnt + 1;
            END IF;
          END LOOP;

          IF k3_affair_id IS NULL THEN
            -- Попробуем по UNOM+ФИО+Д/Р
            FOR aff_rec
              IN (  SELECT DISTINCT aff.affair_id, aff.status
                      FROM affair aff, scan.ea_delo_person edp, person pp, person_relation_delo prd
                     WHERE     aff.build_id = vv.building_id
                           AND aff.reason IN (1, 97, 21)
                           AND aff.affair_stage = 1
                           AND edp.delo_id = rec.delo_id
                           AND prd.affair_id = aff.affair_id
                           AND prd.affair_stage = aff.affair_stage
                           AND pp.person_id = prd.person_id
                           AND REPLACE (LOWER (pp.last_name) || LOWER (pp.pat) || LOWER (pp.patronymic), ' ', '') =
                                 REPLACE (LOWER (edp.person_fio), ' ', '')
                           AND (NVL (pp.birthday, SYSDATE + 1) = NVL (edp.birth_date, SYSDATE)
                                OR NVL (TRUNC (pp.birthday, 'yyyy'), SYSDATE + 1) = NVL (TRUNC (edp.birth_date, 'yyyy'), SYSDATE))
                  ORDER BY aff.status) LOOP
              IF k3_affair_id IS NULL THEN
                affair_cnt     := 1;
                k3_affair_id   := aff_rec.affair_id;
              ELSE
                affair_cnt   := affair_cnt + 1;
              END IF;
            END LOOP;
          END IF;
        END LOOP;
      END LOOP;
    END IF;

--  21.11.2013 Dik#
   /*IF NVL (k3_affair_id, 0) > 0 THEN
            INSERT INTO scan.ea_delo_attr (delo_id, delo_version, object_type_id, object_rel_id, user_name, last_change, row_status)
           VALUES (rec.delo_id, 0, 1, k3_affair_id, NULL, SYSDATE, 1);
  */         
    IF (NVL (k3_affair_id, 0) > 0) and (affair_cnt=1) THEN -- Только одно КПУ по одному адресу
        -- Проверить привязки КПУ к пакетам сканирования
        if pkg_scan.get_affair_delo_link (k3_affair_id, 0, v_mess) > 0 --КПУ было привязано к пакету
          then 
           INSERT INTO rdn_dog_log (dt_stamp, order_id, sql_err_code, sql_err_txt)
             VALUES (SYSDATE, rec.delo_id, 5, k3_affair_id || ' ' || v_mess);
         else 
           INSERT INTO scan.ea_delo_attr (delo_id, delo_version, object_type_id, object_rel_id, user_name, last_change, row_status)
           VALUES (rec.delo_id, 0, 1, k3_affair_id, NULL, SYSDATE, 1);
        end if;  
--/  21.11.2013 Dik#    
    ELSIF (k3_affair_id IS NULL) 
--  21.11.2013 Dik# 
          or (affair_cnt <> 1)
--/  21.11.2013 Dik#           
    THEN
      IF affair_cnt > 1 THEN
        -- найдено несколько КПУ по адресу. надо проверять ещё :-(
        INSERT INTO rdn_dog_log (dt_stamp, order_id, sql_err_code, sql_err_txt)
             VALUES (SYSDATE, rec.delo_id, 4, k3_affair_id || ' cnt=' || affair_cnt);
      ELSE
        -- КПУ не найдена. надо проверять ещё :-(
        INSERT INTO rdn_dog_log (dt_stamp, order_id, sql_err_code, sql_err_txt)
             VALUES (SYSDATE, rec.delo_id, 3, k3_affair_id || ' cnt=' || affair_cnt);
      END IF;

      k3_affair_id   := NULL;
    END IF;

    IF MOD (nn, 10) = 0 THEN
      COMMIT;
    END IF;
  END LOOP;

  COMMIT;

  FOR rec IN (SELECT ed.*
                FROM scan.ea_document ed, scan.ea_doc_type edt
               WHERE     ed.doc_type_id = edt.doc_type_id
                     AND edt.doc_type_name = 'Паспорт'
                     AND ed.doc_num IS NOT NULL
                     AND NOT EXISTS
                           (SELECT 1
                              FROM scan.ea_document_attr edoa
                             WHERE edoa.document_id = ed.document_id AND edoa.object_type_id = 7)) LOOP
    nn   := nn + 1;

    kk   := 0;

    FOR recp
      IN (SELECT rec.document_id, 0 AS document_version, 7 AS object_type_id, prd.person_id AS object_rel_id, SYSDATE AS last_change, 1 AS row_status
            FROM scan.ea_delo_attr eda, kurs3.person_relation_delo prd, pasport_data pd
           WHERE     eda.delo_id = rec.delo_id
                 AND eda.object_type_id = 1
                 AND prd.affair_id = eda.object_rel_id
                 AND prd.affair_stage = 1
                 AND prd.person_id = pd.person_id
                 AND pd.document_type = 0
                 AND NVL (pd.status, 0) = 0
                 AND REPLACE (TRANSLATE (pd.document_series || pd.document_num, '-.', ' '), ' ', '') =
                       REPLACE (TRANSLATE (rec.doc_num, '-.№', ' '), ' ', '')
                 AND NOT EXISTS
                       (SELECT 1
                          FROM scan.ea_document_attr att
                         WHERE (att.object_type_id = 7 AND att.object_rel_id = prd.person_id) OR (att.document_id = rec.document_id))) LOOP
      IF kk = 0 THEN
        SELECT Count(*)
        INTO cnt 
        FROM scan.ea_document_attr a
        WHERE a.document_id = recp.document_id;
-- Ikonnikov:
--  Не позволяет создавать версии документов        --
--        INSERT INTO scan.ea_document_attr (document_id, document_version, object_type_id, object_rel_id, last_change, row_status)
--             VALUES (recp.document_id, recp.document_version, recp.object_type_id, recp.object_rel_id, recp.last_change, recp.row_status);

        INSERT INTO scan.ea_document_attr (document_id, document_version, object_type_id, object_rel_id, last_change, row_status)
             VALUES (recp.document_id, cnt, recp.object_type_id, recp.object_rel_id, recp.last_change, recp.row_status);
      END IF;

      kk   := 1;
    END LOOP;


    IF MOD (nn, 10) = 0 THEN
      COMMIT;
    END IF;
  END LOOP;

  COMMIT;

  FOR rec IN (SELECT ed.*
                FROM scan.ea_document ed, scan.ea_doc_type edt
               WHERE     ed.doc_type_id = edt.doc_type_id
                     AND edt.doc_type_name = 'Свидетельство о рождении'
                     AND ed.doc_num IS NOT NULL
                     AND NOT EXISTS
                           (SELECT 1
                              FROM scan.ea_document_attr edoa
                             WHERE edoa.document_id = ed.document_id AND edoa.object_type_id = 7)) LOOP
    nn   := nn + 1;

    kk   := 0;

    FOR recp
      IN (SELECT rec.document_id, 0 AS document_version, 7 AS object_type_id, prd.person_id AS object_rel_id, SYSDATE AS last_change, 1 AS row_status
            FROM scan.ea_delo_attr eda, kurs3.person_relation_delo prd, pasport_data pd
           WHERE     eda.delo_id = rec.delo_id
                 AND eda.object_type_id = 1
                 AND prd.affair_id = eda.object_rel_id
                 AND prd.affair_stage = 1
                 AND prd.person_id = pd.person_id
                 AND pd.document_type = 2
                 AND NVL (pd.status, 0) = 0
                 AND REPLACE (TRANSLATE (pd.document_series || pd.document_num, '-.', ' '), ' ', '') =
                       REPLACE (TRANSLATE (rec.doc_num, '-.№', ' '), ' ', '')
                 AND NOT EXISTS
                       (SELECT 1
                          FROM scan.ea_document_attr att
                         WHERE att.object_type_id = 7 AND att.object_rel_id = prd.person_id)) LOOP
      IF kk = 0 THEN
        SELECT Count(*)
        INTO cnt 
        FROM scan.ea_document_attr a
        WHERE a.document_id = recp.document_id;
-- Ikonnikov:
--  Не позволяет создавать версии документов        --
--        INSERT INTO scan.ea_document_attr (document_id, document_version, object_type_id, object_rel_id, last_change, row_status)
--             VALUES (recp.document_id, recp.document_version, recp.object_type_id, recp.object_rel_id, recp.last_change, recp.row_status);

        INSERT INTO scan.ea_document_attr (document_id, document_version, object_type_id, object_rel_id, last_change, row_status)
             VALUES (recp.document_id, cnt, recp.object_type_id, recp.object_rel_id, recp.last_change, recp.row_status);

      END IF;

      kk   := 1;
    END LOOP;


    IF MOD (nn, 10) = 0 THEN
      COMMIT;
    END IF;
  END LOOP;

  COMMIT;

  -- удаляем дубли связок (если они случайно сделались):
  DELETE FROM scan.ea_document_attr
        WHERE     object_type_id = 7
              AND object_rel_id IN (  SELECT edoa.object_rel_id --, max(document_id) m_id
                                        FROM scan.ea_document_attr edoa
                                       WHERE edoa.object_type_id = 7
                                    GROUP BY edoa.object_rel_id
                                      HAVING COUNT (*) > 1)
              AND document_id < (SELECT MAX (document_id) m_id
                                   FROM scan.ea_document_attr edoa
                                  WHERE edoa.object_type_id = 7 AND edoa.object_rel_id = ea_document_attr.object_rel_id);

  COMMIT;
END;

 
/
