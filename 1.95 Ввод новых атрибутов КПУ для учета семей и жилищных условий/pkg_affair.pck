CREATE OR REPLACE PACKAGE pkg_affair AS
/******************************************************************************
   NAME:       PKG_affair
   PURPOSE:    ������ � ���

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10.02.2009  BlackHawk        1. ��������
              20.03.2012  AVB       ������� ��������� ���������� ���� ���. ���������� � ���
              17.06.2013 Dik       ��������� ��� ������ � ���. ����������� �� ����������� : (���� �� CLASSIFIER_KURS3=120 �� 6-10)
******************************************************************************/

--
--  ��������� ���������� �������� ���. ���������� � ���
--  affair_id - ��� ��� �� affair
--  data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120)
--  data_value - �������� ���. ���������� (�����)
--
  PROCEDURE affair_ext_data_add (affair_id IN NUMBER, data_type_id IN NUMBER, data_value IN NUMBER);

--
--  ��������� ���������� "�������" ���. ���������� � ���
--  affair_id - ��� ��� �� affair
--  data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120)
--  data_value - �������� ���. ���������� (����)
--
  PROCEDURE affair_ext_data_add (affair_id IN NUMBER, data_type_id IN NUMBER, data_value IN DATE);

--
--  ��������� ���������� ��������� ���. ���������� � ���
--  affair_id - ��� ��� �� affair
--  data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120)
--  data_value - �������� ���. ���������� (������)
--
  PROCEDURE affair_ext_data_add (affair_id IN NUMBER, data_type_id IN NUMBER, data_value IN VARCHAR2);

--
--  ��������� ���������� ���� ���. ���������� � ���
--  affair_id - ��� ��� �� affair
--  data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120)
--  data_value_s - �������� ���. ���������� (������)
--  data_value_n - �������� ���. ���������� (�����)
--  data_value_d - �������� ���. ���������� (����)
--
  PROCEDURE affair_ext_data_add (affair_id IN NUMBER, data_type_id IN NUMBER, 
                                 data_value_s IN VARCHAR2, data_value_n IN NUMBER, data_value_d IN DATE);
--
--  ��������� ��������� �������� ���. ���������� � ���
--  affair_id - ��� ��� �� affair
--  data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120)
--  data_value - �������� ���. ���������� (�����)
--  data_version - ����� �� ������� ���. ����������
--
  PROCEDURE affair_ext_data_modify (affair_id IN NUMBER, data_type_id IN NUMBER, data_value IN NUMBER, data_version IN NUMBER := 0);

--
--  ��������� ��������� "�������" ���. ���������� � ���
--  affair_id - ��� ��� �� affair
--  data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120)
--  data_value - �������� ���. ���������� (����)
--  data_version - ����� �� ������� ���. ����������
--
  PROCEDURE affair_ext_data_modify (affair_id IN NUMBER, data_type_id IN NUMBER, data_value IN DATE, data_version IN NUMBER := 0);

--
--  ��������� ��������� ��������� ���. ���������� � ���
--  affair_id - ��� ��� �� affair
--  data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120)
--  data_value - �������� ���. ���������� (������)
--  data_version - ����� �� ������� ���. ����������
--
  PROCEDURE affair_ext_data_modify (affair_id IN NUMBER, data_type_id IN NUMBER, data_value IN VARCHAR2, data_version IN NUMBER := 0);

--
--  ��������� �������� ���. ���������� � ���
--  affair_id - ��� ��� �� affair
--  data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120)
--  data_version - ����� �� ������� ���. ����������
--
  PROCEDURE affair_ext_data_del (affair_id IN NUMBER, data_type_id IN NUMBER, data_version IN NUMBER := 0);

--
--  ��������� ��������� �������� ���. ���������� � ���
--  affair_id - ��� ��� �� affair
--  data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120)
--  data_version - ����� �� ������� ���. ����������
--
--  return - �����
--
  FUNCTION get_affair_ext_data_n (affair_id IN NUMBER, data_type_id IN NUMBER, data_version IN NUMBER := 0)
    RETURN NUMBER;

--
--  ��������� ��������� "�������" ���. ���������� � ���
--  affair_id - ��� ��� �� affair
--  data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120)
--  data_version - ����� �� ������� ���. ����������
--
--  return - ����
--
  FUNCTION get_affair_ext_data_d (affair_id IN NUMBER, data_type_id IN NUMBER, data_version IN NUMBER := 0)
    RETURN DATE;

--
--  ��������� ��������� ��������� ���. ���������� � ���
--  affair_id - ��� ��� �� affair
--  data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120)
--  data_version - ����� �� ������� ���. ����������
--
--  return - ������
--
  FUNCTION get_affair_ext_data_s (affair_id IN NUMBER, data_type_id IN NUMBER, data_version IN NUMBER := 0)
    RETURN VARCHAR2;

--
--  ��������� ��������� ���������� ������ �� ���. ���������� � ���
--  affair_id - ��� ��� �� affair
--  data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120)
--
--  return - ����� ������
--
  FUNCTION get_affair_ext_data_ver (affair_id IN NUMBER, data_type_id IN NUMBER)
    RETURN NUMBER;
    
-- ======================== 17.06.2013 Dik ==================
 TYPE cursor_type IS REF CURSOR;   -- ��� ������ �� ������ ��� �������� ������� � DELPHI
-- ��������� ����� ���. ���������� �� �����������   
c_uhud_data_type_id constant number := 6; --���� ��������� �������� �������
c_probl_data_type_id constant number := 7; --�������� (�����������) 
c_solution_data_type_id constant number := 8; --������� ��������
c_date_pvs_data_type_id constant number := 9; --���� ������ � ���. ����� � ���
c_date_vivoz_data_type_id constant number := 10;  --���� ������ �����
�_classifier_uhud_num constant number := 140;-- ��� ����������� -������� ��������� �������� ������� (�����������)
�_classifier_problem_num constant number := 141;-- ��� ����������� - ��������
c_classifier_solutions_num constant number := 142;-- ��� ����������� - ������ ������� ��������

--  ������� �������� ��������� c_date_pvs_data_type_id ��� View
function get_dereg_pvs_type_id RETURN NUMBER;
--  ������� �������� ��������� c_date_vivoz_data_type_id ��� View
function get_export_fam_type_id RETURN NUMBER;
--  ������� �������� ��������� c_uhud_data_type_id ��� View
function get_uhud_type_id RETURN NUMBER;
--  ������� �������� ��������� c_probl_data_type_id ��� View
function get_problem_type_id RETURN NUMBER;
--  ������� �������� ��������� c_solution_data_type_id ��� View
function get_solution_type_id RETURN NUMBER;
--  ������� �������� ��������� �_classifier_uhud_num ��� View
function get_classifier_uhud_num RETURN NUMBER;
--  ������� �������� ��������� �_classifier_problem_num ��� View
function get_classifier_problem_num RETURN NUMBER;
--  ������� �������� ��������� c_classifier_solutions_num ��� View
function get_classifier_solutions_num RETURN NUMBER;

--  ������� �������� ��� ������ �� ������� ��������� ���. ������� �� 5 ���
function get_affair_ext_data_uhud5year(p_affair_id IN NUMBER) RETURN NUMBER;

--  ��������� ��������� ���� ������ � ���. ����������� � ���
--  affair_id - ��� ��� �� affair
--  data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120)
--  ���������� ������ p_cur
procedure get_affair_ext_data_all (p_affair_id IN NUMBER, p_data_type_id IN NUMBER, p_cur in out  cursor_type);     
--  ��������� ��������� ���� ������ � ���. ����������� � ��� � ����� ��������� �������� �������
--  affair_id - ��� ��� �� affair
--  c_uhud_data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120) = 6
--  ���������� ������ p_cur
procedure get_affair_ext_data_uhud (p_affair_id IN NUMBER,  p_cur in out  cursor_type);
--  ��������� ��������� ���� ������ � ���. ����������� � ��� �  �������� (�����������)
--  affair_id - ��� ��� �� affair
--  c_probl_data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120) = 7
--  ���������� ������ p_cur
-- data_n  - ��� �������� (�����������)(���������� 141; classifier_num =141 ) ; ��� ������� ���������� 142 
-- data_s  - ������ ����������
-- data_d   - ���� 
procedure get_affair_ext_data_problem (p_affair_id IN NUMBER,  p_cur in out  cursor_type) ;

--  ��������� ��������� ���� ������ � ���. ����������� � ��� � P������ �������� (�����������) 
--  affair_id - ��� ��� �� affair
--  c_resh_probl_data_type_id -������� �������� = 8
--  ���������� ������ p_cur
-- data_n  -  ��� ������� �������� ���������� 142 
-- data_s  - ������ ����������
-- data_d   - ���� 
procedure get_affair_ext_data_solution (p_affair_id IN NUMBER,  p_cur in out  cursor_type) ;
--  ������� ��������� ���� ������ � ���. ����������� � ��� ���� ������ � ���. ����� � ���
procedure get_affair_ext_data_date_pvs (p_affair_id IN NUMBER,p_cur in out  cursor_type);
--  ������� ��������� ���� ������ � ���. ����������� � ��� --���� ������ �����
procedure get_affair_ext_data_date_vivoz (p_affair_id IN NUMBER, p_cur in out  cursor_type);

--  ��������� ����������,�����������������  ���. ���������� � ���
--  affair_id - ��� ��� �� affair
--  data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120)
PROCEDURE InsUpdDel_affair_ext_data (p_mode in number, --0-delete else insert or update 
  p_affair_id IN affair_ext_data.affair_id%type, 
  p_data_type_id IN affair_ext_data.data_type_id%type, 
  p_data_value_s IN affair_ext_data.data_s%type, 
  p_data_value_n IN affair_ext_data.data_n%type, 
  p_data_value_d IN affair_ext_data.data_d%type) ;
   
--  ��������� ��������� ������������ � ���. ����������� � ���
-- p_classifier_num  = select rowid from CLASSIFIER_KURS3 where classifier_num = 91
procedure get_sprav_lists ( p_list_param in number, p_cur in out  cursor_type);
-- ======================== / 17.06.2013 Dik ==================


END pkg_affair;
 
/
CREATE OR REPLACE PACKAGE BODY pkg_affair AS
--
--  24.03.2009  BlackHawk  ������� exception ����� � ������� get_...
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
  -- ������������:
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
  -- ������������:
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
   -- ������������:
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
   -- ������������:
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

    -- ������������:
    kurs3.LOG (kurs3_var.access_log_type
              ,628
              ,get_user_unique_id (kurs3_var.global_user_id)
              ,kurs3_var.global_okrug_id
              , 'AFFAIR_EXT_DATA_ID=' || TRIM (TO_CHAR (ret_id))
              );
  EXCEPTION
    WHEN NO_DATA_FOUND THEN   -- ������ ������ ��� update-� ����
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

    -- ������������:
    kurs3.LOG (kurs3_var.access_log_type
              ,628
              ,get_user_unique_id (kurs3_var.global_user_id)
              ,kurs3_var.global_okrug_id
              , 'AFFAIR_EXT_DATA_ID=' || TRIM (TO_CHAR (ret_id))
              );
  EXCEPTION
    WHEN NO_DATA_FOUND THEN   -- ������ ������ ��� update-� ����
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

    -- ������������:
    kurs3.LOG (kurs3_var.access_log_type
              ,628
              ,get_user_unique_id (kurs3_var.global_user_id)
              ,kurs3_var.global_okrug_id
              , 'AFFAIR_EXT_DATA_ID=' || TRIM (TO_CHAR (ret_id))
              );
  EXCEPTION
    WHEN NO_DATA_FOUND THEN   -- ������ ������ ��� update-� ����
      NULL;
  END affair_ext_data_modify;

  PROCEDURE affair_ext_data_del (affair_id IN NUMBER, data_type_id IN NUMBER, data_version IN NUMBER := 0) AS
    max_ver affair_ext_data.data_version%TYPE;
    rn      affair_ext_data.data_version%TYPE;
  BEGIN
    IF affair_ext_data_del.data_version = -1 THEN
      /* ������� ���. ���������� �� ���� � �������� */
      DELETE FROM affair_ext_data aed
            WHERE aed.affair_id = affair_ext_data_del.affair_id AND aed.data_type_id = affair_ext_data_del.data_type_id;
    ELSE
      /* ������� ���. ���������� � ���������� ������� ������ */
      DELETE FROM affair_ext_data aed
            WHERE aed.affair_id = affair_ext_data_del.affair_id
              AND aed.data_type_id = affair_ext_data_del.data_type_id
              AND aed.data_version = affair_ext_data_del.data_version;

      IF SQL%ROWCOUNT > 0 THEN
        IF affair_ext_data_del.data_version = 0 THEN
          /*������� ���. ���������� �� "�����" ������� - ���� ����� "����" */
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
          /* ������� ���. ���������� �� �� "�����" ������� */
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

    -- ������������:
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
--  ������� �������� ��������� c_date_pvs_data_type_id ��� View
function get_dereg_pvs_type_id RETURN NUMBER
AS
begin   
 return (c_date_pvs_data_type_id);
end get_dereg_pvs_type_id; 
--  ������� �������� ��������� c_date_vivoz_data_type_id ��� View
function get_export_fam_type_id RETURN NUMBER
AS
begin   
 return (c_date_vivoz_data_type_id);
end get_export_fam_type_id;
--  ������� �������� ��������� c_uhud_data_type_id ��� View
function get_uhud_type_id RETURN NUMBER
AS
begin   
 return (c_uhud_data_type_id);
end get_uhud_type_id;
--  ������� �������� ��������� c_probl_data_type_id ��� View
function get_problem_type_id RETURN NUMBER
AS
begin   
 return (c_probl_data_type_id);
end get_problem_type_id;
--  ������� �������� ��������� c_solution_data_type_id ��� View
function get_solution_type_id RETURN NUMBER
AS
begin   
 return (c_solution_data_type_id);
end get_solution_type_id;
--  ������� �������� ��������� �_classifier_uhud_num ��� View
function get_classifier_uhud_num RETURN NUMBER
AS
begin   
 return (�_classifier_uhud_num);
end get_classifier_uhud_num;
--  ������� �������� ��������� �_classifier_problem_num ��� View
function get_classifier_problem_num RETURN NUMBER
AS
begin   
 return (�_classifier_problem_num);
end get_classifier_problem_num;
--  ������� �������� ��������� c_classifier_solutions_num ��� View
function get_classifier_solutions_num RETURN NUMBER
AS
begin   
 return (c_classifier_solutions_num);
end get_classifier_solutions_num;

--  ������� �������� ��� ������ �� ������� ��������� ���. ������� �� 5 ���
function get_affair_ext_data_uhud5year(p_affair_id IN NUMBER) RETURN NUMBER
AS
 c_months_between constant number := 60; -- �� ��������� 5 ���
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


--  ��������� ��������� ���� ������ � ���. ����������� � ���
--  affair_id - ��� ��� �� affair
--  data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120)
--  ���������� ������ p_cur
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

--  ��������� ��������� ���� ������ � ���. ����������� � ��� � ����� ��������� �������� �������
--  affair_id - ��� ��� �� affair
--  c_uhud_data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120) = 6
--  ���������� ������ p_cur
-- data_n  - ��� ������� ������� ��������� �������� ������� (���������� 140; classifier_num =140 )
-- data_s  - ������ ����������
-- data_d   - ���� ��������� �������� �������
procedure get_affair_ext_data_uhud (p_affair_id IN NUMBER,  p_cur in out  cursor_type) 
as
begin
   get_affair_ext_data_all(p_affair_id,c_uhud_data_type_id,p_cur);
END get_affair_ext_data_uhud;

--  ��������� ��������� ���� ������ � ���. ����������� � ��� �  �������� (�����������)
--  affair_id - ��� ��� �� affair
--  c_probl_data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120) = 7
--  ���������� ������ p_cur
-- data_n  - ��� �������� (�����������)(���������� 141; classifier_num =141 ) ; ��� ������� ���������� 142 
-- data_s  - ������ ����������
-- data_d   - ���� 
procedure get_affair_ext_data_problem (p_affair_id IN NUMBER,  p_cur in out  cursor_type) 
as
begin
  get_affair_ext_data_all(p_affair_id,c_probl_data_type_id,p_cur);
END get_affair_ext_data_problem;


--  ��������� ��������� ���� ������ � ���. ����������� � ��� � P������ �������� (�����������) 
--  affair_id - ��� ��� �� affair
--  c_resh_probl_data_type_id -������� �������� = 8
--  ���������� ������ p_cur
-- data_n  -  ��� ������� �������� ���������� 142 
-- data_s  - ������ ����������
-- data_d   - ���� 
procedure get_affair_ext_data_solution (p_affair_id IN NUMBER,  p_cur in out  cursor_type) 
as
begin
  get_affair_ext_data_all(p_affair_id,c_solution_data_type_id,p_cur);
END get_affair_ext_data_solution;

--  ��������� ��������� ���� ������ � ���. ����������� � ��� ���� ������ � ���. ����� � ���
--  data_d   - ���� 
procedure get_affair_ext_data_date_pvs (p_affair_id IN NUMBER,p_cur in out  cursor_type)
AS
begin
   get_affair_ext_data_all(p_affair_id,c_date_pvs_data_type_id,p_cur);
END get_affair_ext_data_date_pvs;
--  ��������� ��������� ���� ������ � ���. ����������� � ��� --���� ������ �����
--  data_d   - ���� 
procedure get_affair_ext_data_date_vivoz (p_affair_id IN NUMBER, p_cur in out  cursor_type) 
AS
begin
   get_affair_ext_data_all(p_affair_id,c_date_vivoz_data_type_id,p_cur);
END get_affair_ext_data_date_vivoz;


--  ��������� ����������,�����������������  ���. ���������� � ���
--  affair_id - ��� ��� �� affair
--  data_type_id - ��� ���. ���������� (CLASSIFIER_KURS3, 120)

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
    if p_data_type_id = c_probl_data_type_id --������� ��������
    then 
         DELETE FROM affair_ext_data 
         WHERE affair_id = p_affair_id
         AND data_type_id in (p_data_type_id,c_solution_data_type_id); --������� � �������
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
       when 0 THEN --��� ����� ���. ���. - ���������
       INSERT INTO affair_ext_data (affair_id, data_type_id, data_s, data_n, data_d,data_version)
            VALUES (p_affair_id,p_data_type_id, p_data_value_s,p_data_value_n,p_data_value_d,0)
         RETURNING data_id INTO ret_id;
     when  1 THEN  --���� ���. ���. � ����- ������
      update affair_ext_data
        SET  data_s=p_data_value_s,
             data_n=p_data_value_n,
             data_d=p_data_value_d
         WHERE affair_id = p_affair_id
         AND data_type_id = p_data_type_id;
     else  --���� ���. ���. � �����-  ��� ������� � ��������� ����
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

--  ��������� ��������� ������������ � ���. ����������� � ���
-- p_classifier_num  = select rowid from CLASSIFIER_KURS3 where classifier_num = 91
procedure get_sprav_lists ( p_list_param in number, p_cur in out  cursor_type)
  as 
  p_classifier_num CLASSIFIER_KURS3.CLASSIFIER_NUM%type:=0;
begin
  case NVL(p_list_param,-1)
       when 0 then p_classifier_num := �_classifier_uhud_num;--�������� ���������� -������� ��������� �������� ������� (�����������)
       when 1 then p_classifier_num := �_classifier_problem_num;--�������� ���������� - ��������
       when 2 then p_classifier_num := c_classifier_solutions_num;--�������� ���������� - ������ ������� ��������
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
