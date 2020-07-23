CREATE OR REPLACE PACKAGE pkg_affair AS
/******************************************************************************
   NAME:       PKG_affair
   PURPOSE:    Работа с КПУ

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10.02.2009  BlackHawk        1. Создание
              20.03.2012  AVB       Добавил процедуру добавления всей доп. информации к КПУ
              17.06.2013 Dik       Процедуры для работы с доп. информацией по переселению : (коды по CLASSIFIER_KURS3=120 от 6-10)
******************************************************************************/

--
--  Процедура добавления числовой доп. информации к КПУ
--  affair_id - код КПУ из affair
--  data_type_id - код доп. информации (CLASSIFIER_KURS3, 120)
--  data_value - значение доп. информации (число)
--
  PROCEDURE affair_ext_data_add (affair_id IN NUMBER, data_type_id IN NUMBER, data_value IN NUMBER);

--
--  Процедура добавления "датовой" доп. информации к КПУ
--  affair_id - код КПУ из affair
--  data_type_id - код доп. информации (CLASSIFIER_KURS3, 120)
--  data_value - значение доп. информации (дата)
--
  PROCEDURE affair_ext_data_add (affair_id IN NUMBER, data_type_id IN NUMBER, data_value IN DATE);

--
--  Процедура добавления строковой доп. информации к КПУ
--  affair_id - код КПУ из affair
--  data_type_id - код доп. информации (CLASSIFIER_KURS3, 120)
--  data_value - значение доп. информации (строка)
--
  PROCEDURE affair_ext_data_add (affair_id IN NUMBER, data_type_id IN NUMBER, data_value IN VARCHAR2);

--
--  Процедура добавления всей доп. информации к КПУ
--  affair_id - код КПУ из affair
--  data_type_id - код доп. информации (CLASSIFIER_KURS3, 120)
--  data_value_s - значение доп. информации (строка)
--  data_value_n - значение доп. информации (число)
--  data_value_d - значение доп. информации (дата)
--
  PROCEDURE affair_ext_data_add (affair_id IN NUMBER, data_type_id IN NUMBER, 
                                 data_value_s IN VARCHAR2, data_value_n IN NUMBER, data_value_d IN DATE);
--
--  Процедура изменения числовой доп. информации к КПУ
--  affair_id - код КПУ из affair
--  data_type_id - код доп. информации (CLASSIFIER_KURS3, 120)
--  data_value - значение доп. информации (число)
--  data_version - номер из истории доп. информации
--
  PROCEDURE affair_ext_data_modify (affair_id IN NUMBER, data_type_id IN NUMBER, data_value IN NUMBER, data_version IN NUMBER := 0);

--
--  Процедура изменения "датовой" доп. информации к КПУ
--  affair_id - код КПУ из affair
--  data_type_id - код доп. информации (CLASSIFIER_KURS3, 120)
--  data_value - значение доп. информации (дата)
--  data_version - номер из истории доп. информации
--
  PROCEDURE affair_ext_data_modify (affair_id IN NUMBER, data_type_id IN NUMBER, data_value IN DATE, data_version IN NUMBER := 0);

--
--  Процедура изменения строковой доп. информации к КПУ
--  affair_id - код КПУ из affair
--  data_type_id - код доп. информации (CLASSIFIER_KURS3, 120)
--  data_value - значение доп. информации (строка)
--  data_version - номер из истории доп. информации
--
  PROCEDURE affair_ext_data_modify (affair_id IN NUMBER, data_type_id IN NUMBER, data_value IN VARCHAR2, data_version IN NUMBER := 0);

--
--  Процедура удаления доп. информации к КПУ
--  affair_id - код КПУ из affair
--  data_type_id - код доп. информации (CLASSIFIER_KURS3, 120)
--  data_version - номер из истории доп. информации
--
  PROCEDURE affair_ext_data_del (affair_id IN NUMBER, data_type_id IN NUMBER, data_version IN NUMBER := 0);

--
--  Процедура получения числовой доп. информации к КПУ
--  affair_id - код КПУ из affair
--  data_type_id - код доп. информации (CLASSIFIER_KURS3, 120)
--  data_version - номер из истории доп. информации
--
--  return - число
--
  FUNCTION get_affair_ext_data_n (affair_id IN NUMBER, data_type_id IN NUMBER, data_version IN NUMBER := 0)
    RETURN NUMBER;

--
--  Процедура получения "датовой" доп. информации к КПУ
--  affair_id - код КПУ из affair
--  data_type_id - код доп. информации (CLASSIFIER_KURS3, 120)
--  data_version - номер из истории доп. информации
--
--  return - дата
--
  FUNCTION get_affair_ext_data_d (affair_id IN NUMBER, data_type_id IN NUMBER, data_version IN NUMBER := 0)
    RETURN DATE;

--
--  Процедура получения строковой доп. информации к КПУ
--  affair_id - код КПУ из affair
--  data_type_id - код доп. информации (CLASSIFIER_KURS3, 120)
--  data_version - номер из истории доп. информации
--
--  return - строка
--
  FUNCTION get_affair_ext_data_s (affair_id IN NUMBER, data_type_id IN NUMBER, data_version IN NUMBER := 0)
    RETURN VARCHAR2;

--
--  Процедура получения количества версий по доп. информации к КПУ
--  affair_id - код КПУ из affair
--  data_type_id - код доп. информации (CLASSIFIER_KURS3, 120)
--
--  return - число версий
--
  FUNCTION get_affair_ext_data_ver (affair_id IN NUMBER, data_type_id IN NUMBER)
    RETURN NUMBER;
    
-- ======================== 17.06.2013 Dik ==================
 TYPE cursor_type IS REF CURSOR;   -- тип ссылка на курсор для возврата курсора в DELPHI
-- константы типов доп. информации по переселению   
c_uhud_data_type_id constant number := 6; --Факт ухудшения жилищных условий
c_probl_data_type_id constant number := 7; --Проблема (переселение) 
c_solution_data_type_id constant number := 8; --решение проблемы
c_date_pvs_data_type_id constant number := 9; --Дата снятия с рег. учета в ПВС
c_date_vivoz_data_type_id constant number := 10;  --Дата вывоза семьи
с_classifier_uhud_num constant number := 140;-- Код справочника -Причины ухудшения жилищных условий (переселение)
с_classifier_problem_num constant number := 141;-- Код справочника - Проблема
c_classifier_solutions_num constant number := 142;-- Код справочника - Способ решения проблемы

--  вернуть значение константы c_date_pvs_data_type_id для View
function get_dereg_pvs_type_id RETURN NUMBER;
--  вернуть значение константы c_date_vivoz_data_type_id для View
function get_export_fam_type_id RETURN NUMBER;
--  вернуть значение константы c_uhud_data_type_id для View
function get_uhud_type_id RETURN NUMBER;
--  вернуть значение константы c_probl_data_type_id для View
function get_problem_type_id RETURN NUMBER;
--  вернуть значение константы c_solution_data_type_id для View
function get_solution_type_id RETURN NUMBER;
--  вернуть значение константы с_classifier_uhud_num для View
function get_classifier_uhud_num RETURN NUMBER;
--  вернуть значение константы с_classifier_problem_num для View
function get_classifier_problem_num RETURN NUMBER;
--  вернуть значение константы c_classifier_solutions_num для View
function get_classifier_solutions_num RETURN NUMBER;

--  вернуть значение для отбора по условию Ухудшение жил. условий за 5 лет
function get_affair_ext_data_uhud5year(p_affair_id IN NUMBER) RETURN NUMBER;

--  Процедура получения всей записи с доп. информацией к КПУ
--  affair_id - код КПУ из affair
--  data_type_id - код доп. информации (CLASSIFIER_KURS3, 120)
--  возвращает курсор p_cur
procedure get_affair_ext_data_all (p_affair_id IN NUMBER, p_data_type_id IN NUMBER, p_cur in out  cursor_type);     
--  Процедура получения всей записи с доп. информацией к КПУ о Факте ухудшения жилищных условий
--  affair_id - код КПУ из affair
--  c_uhud_data_type_id - код доп. информации (CLASSIFIER_KURS3, 120) = 6
--  возвращает курсор p_cur
procedure get_affair_ext_data_uhud (p_affair_id IN NUMBER,  p_cur in out  cursor_type);
--  Процедура получения всей записи с доп. информацией к КПУ о  Проблеме (переселение)
--  affair_id - код КПУ из affair
--  c_probl_data_type_id - код доп. информации (CLASSIFIER_KURS3, 120) = 7
--  возвращает курсор p_cur
-- data_n  - код Проблема (переселение)(справочник 141; classifier_num =141 ) ; код решения справочник 142 
-- data_s  - строка примечание
-- data_d   - дата 
procedure get_affair_ext_data_problem (p_affair_id IN NUMBER,  p_cur in out  cursor_type) ;

--  Процедура получения всей записи с доп. информацией к КПУ о Pешении Проблемы (переселение) 
--  affair_id - код КПУ из affair
--  c_resh_probl_data_type_id -решение проблемы = 8
--  возвращает курсор p_cur
-- data_n  -  код решения Проблемы справочник 142 
-- data_s  - строка примечание
-- data_d   - дата 
procedure get_affair_ext_data_solution (p_affair_id IN NUMBER,  p_cur in out  cursor_type) ;
--  функция получения всей записи с доп. информацией к КПУ Дате снятия с рег. учета в ПВС
procedure get_affair_ext_data_date_pvs (p_affair_id IN NUMBER,p_cur in out  cursor_type);
--  функция получения всей записи с доп. информацией к КПУ --Дата вывоза семьи
procedure get_affair_ext_data_date_vivoz (p_affair_id IN NUMBER, p_cur in out  cursor_type);

--  Процедура Добавления,ИзмененияУдаления  доп. информации к КПУ
--  affair_id - код КПУ из affair
--  data_type_id - код доп. информации (CLASSIFIER_KURS3, 120)
PROCEDURE InsUpdDel_affair_ext_data (p_mode in number, --0-delete else insert or update 
  p_affair_id IN affair_ext_data.affair_id%type, 
  p_data_type_id IN affair_ext_data.data_type_id%type, 
  p_data_value_s IN affair_ext_data.data_s%type, 
  p_data_value_n IN affair_ext_data.data_n%type, 
  p_data_value_d IN affair_ext_data.data_d%type) ;
   
--  Процедура получения справочников с доп. информацией к КПУ
-- p_classifier_num  = select rowid from CLASSIFIER_KURS3 where classifier_num = 91
procedure get_sprav_lists ( p_list_param in number, p_cur in out  cursor_type);
-- ======================== / 17.06.2013 Dik ==================


END pkg_affair;
 
/
CREATE OR REPLACE PACKAGE BODY pkg_affair AS
--
--  24.03.2009  BlackHawk  Добавил exception блоки в функции get_...
--
  PROCEDURE affair_ext_data_add (affair_id IN NUMBER, data_type_id IN NUMBER, data_value IN NUMBER) AS
    ret_id affair_ext_data.data_id%TYPE;
  BEGIN
    INSERT INTO affair_ext_data
                (affair_id, data_type_id, data_n
                )
         VALUES (affair_ext_data_add.affair_id, affair_ext_data_add.data_type_id, affair_ext_data_add.data_value
                )
      RETURNING data_id
           INTO ret_id;
  -- журнализация:
  /*kurs3.LOG (kurs3_var.access_log_type
            ,627
            ,get_user_unique_id (kurs3_var.global_user_id)
            ,kurs3_var.global_okrug_id
            , 'AFFAIR_EXT_DATA_ID=' || TRIM (TO_CHAR (ret_id))
            );*/
  END affair_ext_data_add;

  PROCEDURE affair_ext_data_add (affair_id IN NUMBER, data_type_id IN NUMBER, data_value IN DATE) AS
    ret_id affair_ext_data.data_id%TYPE;
  BEGIN
    INSERT INTO affair_ext_data
                (affair_id, data_type_id, data_d
                )
         VALUES (affair_ext_data_add.affair_id, affair_ext_data_add.data_type_id, affair_ext_data_add.data_value
                )
      RETURNING data_id
           INTO ret_id;
  -- журнализация:
  /*kurs3.LOG (kurs3_var.access_log_type
            ,627
            ,get_user_unique_id (kurs3_var.global_user_id)
            ,kurs3_var.global_okrug_id
            , 'AFFAIR_EXT_DATA_ID=' || TRIM (TO_CHAR (ret_id))
            );*/
  END affair_ext_data_add;

  PROCEDURE affair_ext_data_add (affair_id IN NUMBER, data_type_id IN NUMBER, data_value IN VARCHAR2) AS
    ret_id affair_ext_data.data_id%TYPE;
  BEGIN
    INSERT INTO affair_ext_data
                (affair_id, data_type_id, data_s
                )
         VALUES (affair_ext_data_add.affair_id, affair_ext_data_add.data_type_id, affair_ext_data_add.data_value
                )
      RETURNING data_id
           INTO ret_id;
   -- журнализация:
  /* kurs3.LOG (kurs3_var.access_log_type
             ,627
             ,get_user_unique_id (kurs3_var.global_user_id)
             ,kurs3_var.global_okrug_id
             , 'AFFAIR_EXT_DATA_ID=' || TRIM (TO_CHAR (ret_id))
             );*/
  END affair_ext_data_add;

  PROCEDURE affair_ext_data_add (affair_id IN NUMBER, data_type_id IN NUMBER, 
                                 data_value_s IN VARCHAR2, data_value_n IN NUMBER, data_value_d IN DATE) AS
    ret_id affair_ext_data.data_id%TYPE;
    nr NUMBER;
  BEGIN
    SELECT count(*) INTO nr
      FROM affair_ext_data
     WHERE affair_id = affair_ext_data_add.affair_id
       AND data_type_id = affair_ext_data_add.data_type_id
       AND data_s = affair_ext_data_add.data_value_s
       AND data_n = affair_ext_data_add.data_value_n
       AND data_d = affair_ext_data_add.data_value_d;
       
    IF nr <= 0 THEN
       INSERT INTO affair_ext_data
                   (affair_id, data_type_id, data_s, data_n, data_d
                   )
            VALUES (affair_ext_data_add.affair_id, affair_ext_data_add.data_type_id, affair_ext_data_add.data_value_s,
                      affair_ext_data_add.data_value_n, affair_ext_data_add.data_value_d
                   )
         RETURNING data_id
              INTO ret_id;
    END IF;
   -- журнализация:
  /* kurs3.LOG (kurs3_var.access_log_type
             ,627
             ,get_user_unique_id (kurs3_var.global_user_id)
             ,kurs3_var.global_okrug_id
             , 'AFFAIR_EXT_DATA_ID=' || TRIM (TO_CHAR (ret_id))
             );*/
  END affair_ext_data_add;

  PROCEDURE affair_ext_data_modify (affair_id IN NUMBER, data_type_id IN NUMBER, data_value IN NUMBER, data_version IN NUMBER := 0) AS
    ret_id affair_ext_data.data_id%TYPE;
  BEGIN
    SELECT aed.data_id
      INTO ret_id
      FROM affair_ext_data aed
     WHERE aed.affair_id = affair_ext_data_modify.affair_id
       AND aed.data_type_id = affair_ext_data_modify.data_type_id
       AND aed.data_version = affair_ext_data_modify.data_version;

    UPDATE affair_ext_data aed
       SET aed.data_n = data_value
     WHERE aed.affair_id = affair_ext_data_modify.affair_id
       AND aed.data_type_id = affair_ext_data_modify.data_type_id
       AND aed.data_version = affair_ext_data_modify.data_version;

    -- журнализация:
    kurs3.LOG (kurs3_var.access_log_type
              ,628
              ,get_user_unique_id (kurs3_var.global_user_id)
              ,kurs3_var.global_okrug_id
              , 'AFFAIR_EXT_DATA_ID=' || TRIM (TO_CHAR (ret_id))
              );
  EXCEPTION
    WHEN NO_DATA_FOUND THEN   -- значит строки для update-а нету
      NULL;
  END affair_ext_data_modify;

  PROCEDURE affair_ext_data_modify (affair_id IN NUMBER, data_type_id IN NUMBER, data_value IN DATE, data_version IN NUMBER := 0) AS
    ret_id affair_ext_data.data_id%TYPE;
  BEGIN
    SELECT aed.data_id
      INTO ret_id
      FROM affair_ext_data aed
     WHERE aed.affair_id = affair_ext_data_modify.affair_id
       AND aed.data_type_id = affair_ext_data_modify.data_type_id
       AND aed.data_version = affair_ext_data_modify.data_version;

    UPDATE affair_ext_data aed
       SET aed.data_d = data_value
     WHERE aed.affair_id = affair_ext_data_modify.affair_id
       AND aed.data_type_id = affair_ext_data_modify.data_type_id
       AND aed.data_version = affair_ext_data_modify.data_version;

    -- журнализация:
    kurs3.LOG (kurs3_var.access_log_type
              ,628
              ,get_user_unique_id (kurs3_var.global_user_id)
              ,kurs3_var.global_okrug_id
              , 'AFFAIR_EXT_DATA_ID=' || TRIM (TO_CHAR (ret_id))
              );
  EXCEPTION
    WHEN NO_DATA_FOUND THEN   -- значит строки для update-а нету
      NULL;
  END affair_ext_data_modify;

  PROCEDURE affair_ext_data_modify (affair_id IN NUMBER, data_type_id IN NUMBER, data_value IN VARCHAR2, data_version IN NUMBER := 0) AS
    ret_id affair_ext_data.data_id%TYPE;
  BEGIN
    SELECT aed.data_id
      INTO ret_id
      FROM affair_ext_data aed
     WHERE aed.affair_id = affair_ext_data_modify.affair_id
       AND aed.data_type_id = affair_ext_data_modify.data_type_id
       AND aed.data_version = affair_ext_data_modify.data_version;

    UPDATE affair_ext_data aed
       SET aed.data_s = data_value
     WHERE aed.affair_id = affair_ext_data_modify.affair_id
       AND aed.data_type_id = affair_ext_data_modify.data_type_id
       AND aed.data_version = affair_ext_data_modify.data_version;

    -- журнализация:
    kurs3.LOG (kurs3_var.access_log_type
              ,628
              ,get_user_unique_id (kurs3_var.global_user_id)
              ,kurs3_var.global_okrug_id
              , 'AFFAIR_EXT_DATA_ID=' || TRIM (TO_CHAR (ret_id))
              );
  EXCEPTION
    WHEN NO_DATA_FOUND THEN   -- значит строки для update-а нету
      NULL;
  END affair_ext_data_modify;

  PROCEDURE affair_ext_data_del (affair_id IN NUMBER, data_type_id IN NUMBER, data_version IN NUMBER := 0) AS
    max_ver affair_ext_data.data_version%TYPE;
    rn      affair_ext_data.data_version%TYPE;
  BEGIN
    IF affair_ext_data_del.data_version = -1 THEN
      /* удаляем доп. информацию со всей её историей */
      DELETE FROM affair_ext_data aed
            WHERE aed.affair_id = affair_ext_data_del.affair_id AND aed.data_type_id = affair_ext_data_del.data_type_id;
    ELSE
      /* удаляем доп. информацию с конкретным номером версии */
      DELETE FROM affair_ext_data aed
            WHERE aed.affair_id = affair_ext_data_del.affair_id
              AND aed.data_type_id = affair_ext_data_del.data_type_id
              AND aed.data_version = affair_ext_data_del.data_version;

      IF SQL%ROWCOUNT > 0 THEN
        IF affair_ext_data_del.data_version = 0 THEN
          /*удалили доп. информацию из "верха" истории - ищем новый "верх" */
          SELECT MAX (aed.data_version)
            INTO max_ver
            FROM affair_ext_data aed
           WHERE aed.affair_id = affair_ext_data_del.affair_id AND aed.data_type_id = affair_ext_data_del.data_type_id;

          IF max_ver IS NOT NULL THEN
            UPDATE affair_ext_data aed
               SET aed.data_version = 0
             WHERE aed.affair_id = affair_ext_data_del.affair_id AND aed.data_type_id = affair_ext_data_del.data_type_id
                   AND aed.data_version = max_ver;
          END IF;
        ELSE
          /* удалили доп. информацию НЕ из "верха" истории */
          rn := 0;

          FOR rec IN (SELECT   *
                          FROM affair_ext_data aed
                         WHERE aed.affair_id = affair_ext_data_del.affair_id AND aed.data_type_id = affair_ext_data_del.data_type_id
                      ORDER BY aed.data_version) LOOP
            IF rn != rec.data_version THEN
              UPDATE affair_ext_data aed
                 SET aed.data_version = rn
               WHERE aed.affair_id = affair_ext_data_del.affair_id
                 AND aed.data_type_id = affair_ext_data_del.data_type_id
                 AND aed.data_version = rec.data_version;
            END IF;

            rn := rn + 1;
          END LOOP;
        END IF;
      END IF;
    END IF;

    -- журнализация:
    kurs3.LOG (kurs3_var.access_log_type
              ,629
              ,get_user_unique_id (kurs3_var.global_user_id)
              ,kurs3_var.global_okrug_id
              , 'AFFAIR_id=' || TRIM (TO_CHAR (affair_ext_data_del.affair_id)) || ':DATA_TYPE_ID' || TRIM (TO_CHAR (affair_ext_data_del.data_type_id))
              );
  END affair_ext_data_del;

  FUNCTION get_affair_ext_data_n (affair_id IN NUMBER, data_type_id IN NUMBER, data_version IN NUMBER := 0)
    RETURN NUMBER AS
    RESULT NUMBER := NULL;
  BEGIN
    SELECT aed.data_n
      INTO RESULT
      FROM affair_ext_data aed
     WHERE aed.affair_id = get_affair_ext_data_n.affair_id
       AND aed.data_type_id = get_affair_ext_data_n.data_type_id
       AND aed.data_version = get_affair_ext_data_n.data_version;

    RETURN RESULT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END get_affair_ext_data_n;

  FUNCTION get_affair_ext_data_d (affair_id IN NUMBER, data_type_id IN NUMBER, data_version IN NUMBER := 0)
    RETURN DATE AS
    RESULT DATE := NULL;
  BEGIN
    SELECT aed.data_d
      INTO RESULT
      FROM affair_ext_data aed
     WHERE aed.affair_id = get_affair_ext_data_d.affair_id
       AND aed.data_type_id = get_affair_ext_data_d.data_type_id
       AND aed.data_version = get_affair_ext_data_d.data_version;

    RETURN RESULT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END get_affair_ext_data_d;

  FUNCTION get_affair_ext_data_s (affair_id IN NUMBER, data_type_id IN NUMBER, data_version IN NUMBER := 0)
    RETURN VARCHAR2 AS
    RESULT affair_ext_data.data_s%TYPE   := NULL;
  BEGIN
    SELECT aed.data_s
      INTO RESULT
      FROM affair_ext_data aed
     WHERE aed.affair_id = get_affair_ext_data_s.affair_id
       AND aed.data_type_id = get_affair_ext_data_s.data_type_id
       AND aed.data_version = get_affair_ext_data_s.data_version;

    RETURN RESULT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END get_affair_ext_data_s;

  FUNCTION get_affair_ext_data_ver (affair_id IN NUMBER, data_type_id IN NUMBER)
    RETURN NUMBER AS
    RESULT NUMBER;
  BEGIN
    SELECT COUNT (*)
      INTO RESULT
      FROM affair_ext_data aed
     WHERE aed.affair_id = get_affair_ext_data_ver.affair_id AND aed.data_type_id = get_affair_ext_data_ver.data_type_id;

    RETURN RESULT;
  END get_affair_ext_data_ver;
  
  
  -- ======================== 17.06.2013 Dik ==================
--  вернуть значение константы c_date_pvs_data_type_id для View
function get_dereg_pvs_type_id RETURN NUMBER
AS
begin   
 return (c_date_pvs_data_type_id);
end get_dereg_pvs_type_id; 
--  вернуть значение константы c_date_vivoz_data_type_id для View
function get_export_fam_type_id RETURN NUMBER
AS
begin   
 return (c_date_vivoz_data_type_id);
end get_export_fam_type_id;
--  вернуть значение константы c_uhud_data_type_id для View
function get_uhud_type_id RETURN NUMBER
AS
begin   
 return (c_uhud_data_type_id);
end get_uhud_type_id;
--  вернуть значение константы c_probl_data_type_id для View
function get_problem_type_id RETURN NUMBER
AS
begin   
 return (c_probl_data_type_id);
end get_problem_type_id;
--  вернуть значение константы c_solution_data_type_id для View
function get_solution_type_id RETURN NUMBER
AS
begin   
 return (c_solution_data_type_id);
end get_solution_type_id;
--  вернуть значение константы с_classifier_uhud_num для View
function get_classifier_uhud_num RETURN NUMBER
AS
begin   
 return (с_classifier_uhud_num);
end get_classifier_uhud_num;
--  вернуть значение константы с_classifier_problem_num для View
function get_classifier_problem_num RETURN NUMBER
AS
begin   
 return (с_classifier_problem_num);
end get_classifier_problem_num;
--  вернуть значение константы c_classifier_solutions_num для View
function get_classifier_solutions_num RETURN NUMBER
AS
begin   
 return (c_classifier_solutions_num);
end get_classifier_solutions_num;

--  вернуть значение для отбора по условию Ухудшение жил. условий за 5 лет
function get_affair_ext_data_uhud5year(p_affair_id IN NUMBER) RETURN NUMBER
AS
 c_months_between constant number := 60; -- за последние 5 лет
 res number :=0;
 d date := NULL;
begin   
 
  SELECT count(*) into res
  FROM AFFAIR_EXT_DATA ae
  where ae.data_type_id = c_uhud_data_type_id
  and ae.affair_id=p_affair_id
  and ae.data_version=0
  and ae.data_d is not NULL; 
 
 if res > 0 then
  SELECT  
  case when
        months_between(trunc(Sysdate,'dd'),trunc(ae.data_d,'dd')) <= c_months_between
       then 2
       else 3
  end case into res
  FROM AFFAIR_EXT_DATA ae
  where ae.data_type_id = c_uhud_data_type_id
  and ae.affair_id=p_affair_id
  and ae.data_version=0;

 else 
   res := 1;
 end if;   
 
 return (res);
end get_affair_ext_data_uhud5year;


--  Процедура получения всей записи с доп. информацией к КПУ
--  affair_id - код КПУ из affair
--  data_type_id - код доп. информации (CLASSIFIER_KURS3, 120)
--  возвращает курсор p_cur
procedure get_affair_ext_data_all (p_affair_id IN NUMBER, p_data_type_id IN NUMBER, p_cur in out  cursor_type) 
as
 idx_delete_in_sprav number := 1;
 c number :=0;
begin
  case p_data_type_id
       when c_uhud_data_type_id then idx_delete_in_sprav:=1;
        when c_probl_data_type_id then idx_delete_in_sprav:=1;
         when c_solution_data_type_id then idx_delete_in_sprav:=1;
         else idx_delete_in_sprav:=0;
  end case; 
  SELECT count(*) into c
  FROM AFFAIR_EXT_DATA ae
  where ae.data_type_id=p_data_type_id
  and ae.affair_id=p_affair_id;      
  if c>0 then
   OPEN p_cur FOR 
             SELECT ae.data_id, ae.data_type_id, ae.data_n,ae.data_s,ae.data_d,idx_delete_in_sprav as idx_delete_in_sprav
             FROM AFFAIR_EXT_DATA ae
             where ae.data_type_id=p_data_type_id
             and ae.affair_id=p_affair_id
             and ae.data_version=0;
   else
      OPEN p_cur FOR  
      SELECT NULL as data_id, p_data_type_id as data_type_id, NULL as data_n,NULL as data_s, NULL as data_d ,idx_delete_in_sprav as idx_delete_in_sprav
      FROM DUAL;
  end if;     
       
END get_affair_ext_data_all;

--  Процедура получения всей записи с доп. информацией к КПУ о Факте ухудшения жилищных условий
--  affair_id - код КПУ из affair
--  c_uhud_data_type_id - код доп. информации (CLASSIFIER_KURS3, 120) = 6
--  возвращает курсор p_cur
-- data_n  - код причины Причины ухудшения жилищных условий (справочник 140; classifier_num =140 )
-- data_s  - строка примечание
-- data_d   - дата ухудшения жилищных условий
procedure get_affair_ext_data_uhud (p_affair_id IN NUMBER,  p_cur in out  cursor_type) 
as
begin
   get_affair_ext_data_all(p_affair_id,c_uhud_data_type_id,p_cur);
END get_affair_ext_data_uhud;

--  Процедура получения всей записи с доп. информацией к КПУ о  Проблеме (переселение)
--  affair_id - код КПУ из affair
--  c_probl_data_type_id - код доп. информации (CLASSIFIER_KURS3, 120) = 7
--  возвращает курсор p_cur
-- data_n  - код Проблема (переселение)(справочник 141; classifier_num =141 ) ; код решения справочник 142 
-- data_s  - строка примечание
-- data_d   - дата 
procedure get_affair_ext_data_problem (p_affair_id IN NUMBER,  p_cur in out  cursor_type) 
as
begin
  get_affair_ext_data_all(p_affair_id,c_probl_data_type_id,p_cur);
END get_affair_ext_data_problem;


--  Процедура получения всей записи с доп. информацией к КПУ о Pешении Проблемы (переселение) 
--  affair_id - код КПУ из affair
--  c_resh_probl_data_type_id -решение проблемы = 8
--  возвращает курсор p_cur
-- data_n  -  код решения Проблемы справочник 142 
-- data_s  - строка примечание
-- data_d   - дата 
procedure get_affair_ext_data_solution (p_affair_id IN NUMBER,  p_cur in out  cursor_type) 
as
begin
  get_affair_ext_data_all(p_affair_id,c_solution_data_type_id,p_cur);
END get_affair_ext_data_solution;

--  Процедура получения всей записи с доп. информацией к КПУ Дате снятия с рег. учета в ПВС
--  data_d   - дата 
procedure get_affair_ext_data_date_pvs (p_affair_id IN NUMBER,p_cur in out  cursor_type)
AS
begin
   get_affair_ext_data_all(p_affair_id,c_date_pvs_data_type_id,p_cur);
END get_affair_ext_data_date_pvs;
--  Процедура получения всей записи с доп. информацией к КПУ --Дата вывоза семьи
--  data_d   - дата 
procedure get_affair_ext_data_date_vivoz (p_affair_id IN NUMBER, p_cur in out  cursor_type) 
AS
begin
   get_affair_ext_data_all(p_affair_id,c_date_vivoz_data_type_id,p_cur);
END get_affair_ext_data_date_vivoz;


--  Процедура Добавления,ИзмененияУдаления  доп. информации к КПУ
--  affair_id - код КПУ из affair
--  data_type_id - код доп. информации (CLASSIFIER_KURS3, 120)

PROCEDURE InsUpdDel_affair_ext_data (p_mode in number, --0-delete else insert or update 
  p_affair_id IN affair_ext_data.affair_id%type, 
  p_data_type_id IN affair_ext_data.data_type_id%type, 
  p_data_value_s IN affair_ext_data.data_s%type, 
  p_data_value_n IN affair_ext_data.data_n%type, 
  p_data_value_d IN affair_ext_data.data_d%type) 
AS
    ret_id affair_ext_data.data_id%TYPE;
    nr NUMBER := 0;
BEGIN
  
IF p_mode=0 then  --delete
    if p_data_type_id = c_probl_data_type_id --удалить проблему
    then 
         DELETE FROM affair_ext_data 
         WHERE affair_id = p_affair_id
         AND data_type_id in (p_data_type_id,c_solution_data_type_id); --удаляем и решение
    else     
       DELETE FROM affair_ext_data 
       WHERE affair_id = p_affair_id
       AND data_type_id = p_data_type_id;
    end if;   
ELSE -- insert or update 
    SELECT count(*) INTO nr
      FROM affair_ext_data ae
     WHERE ae.affair_id = p_affair_id
       AND ae.data_type_id = p_data_type_id;
      
    case nr 
       when 0 THEN --нет такой доп. инф. - вставляем
       INSERT INTO affair_ext_data (affair_id, data_type_id, data_s, data_n, data_d,data_version)
            VALUES (p_affair_id,p_data_type_id, p_data_value_s,p_data_value_n,p_data_value_d,0)
         RETURNING data_id INTO ret_id;
     when  1 THEN  --есть доп. инф. и одна- правим
      update affair_ext_data
        SET  data_s=p_data_value_s,
             data_n=p_data_value_n,
             data_d=p_data_value_d
         WHERE affair_id = p_affair_id
         AND data_type_id = p_data_type_id;
     else  --есть доп. инф. и много-  все удаляем и вставляем одну
         DELETE FROM affair_ext_data 
         WHERE affair_id = p_affair_id
         AND data_type_id = p_data_type_id; 
         INSERT INTO affair_ext_data (affair_id, data_type_id, data_s, data_n, data_d,data_version)
            VALUES (p_affair_id,p_data_type_id, p_data_value_s,p_data_value_n,p_data_value_d,0)
         RETURNING data_id INTO ret_id;
     end case; 
END IF;
  commit;
  EXCEPTION
   WHEN OTHERS THEN begin rollback;  raise; end;    
    
end InsUpdDel_affair_ext_data;

--  Процедура получения справочников с доп. информацией к КПУ
-- p_classifier_num  = select rowid from CLASSIFIER_KURS3 where classifier_num = 91
procedure get_sprav_lists ( p_list_param in number, p_cur in out  cursor_type)
  as 
  p_classifier_num CLASSIFIER_KURS3.CLASSIFIER_NUM%type:=0;
begin
  case NVL(p_list_param,-1)
       when 0 then p_classifier_num := с_classifier_uhud_num;--Получить справочник -Причины ухудшения жилищных условий (переселение)
       when 1 then p_classifier_num := с_classifier_problem_num;--Получить справочник - Проблема
       when 2 then p_classifier_num := c_classifier_solutions_num;--Получить справочник - Способ решения проблемы
     else          
       OPEN p_cur FOR 
             SELECT NULL as ID, NULL as TITLE  from dual;  
     return;           
  end case;
          
 OPEN p_cur FOR 
  select t.ROW_NUM as ID ,t.NAME as TITLE from CLASSIFIER_KURS3 t
  where t.classifier_num = p_classifier_num
  order by t.rowid ;
   
end  get_sprav_lists; 
-- ======================== / 17.06.2013 Dik ==================

  
END pkg_affair;
/
