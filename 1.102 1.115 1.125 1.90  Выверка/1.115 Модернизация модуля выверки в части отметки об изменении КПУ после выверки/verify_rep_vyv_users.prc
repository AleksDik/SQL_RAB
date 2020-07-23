CREATE OR REPLACE PROCEDURE verify_rep_vyv_users (begin_date_ VARCHAR2, end_date_ VARCHAR2, cur_ IN OUT kurs3.curstype, type_ NUMBER := 1) AS
--
--  Отчет по пользователям выверки, type_: 1 - таблица с количеством
--
--  28.11.2011  BlackHawk  Создание
--  #24.06.2013 Dikan Отчет только по пользователям МГУ
--  #28.11.2013 Dikan  type_: 2  - Отчет "по операторам выверки с учетом изменений ДЖП"  (Задача 1.115)
BEGIN
  CASE
    WHEN type_ = 1 THEN
      OPEN cur_ FOR
          SELECT DECODE (
                   user_id
                  ,999, 'ИТОГО'
                  ,DECODE (SUBSTR (get_user_name_fmt (user_id), 1, 36)
                          ,'Department Account Research Technics', 'Сопровождение'
                          ,get_user_name_fmt (user_id)
                          )
                 )
                   user_name
                ,user_id
                ,DECODE (user_id, 999, SUM (all_count) OVER (PARTITION BY 1), all_count) all_count
                ,DECODE (user_id, 999, SUM (vyvereno) OVER (PARTITION BY 1), vyvereno) vyvereno
                ,DECODE (user_id, 999, SUM (vozvrat) OVER (PARTITION BY 1), vozvrat) vozvrat
                ,DECODE (user_id, 999, NULL, get_user_work_time (user_id, TO_DATE (begin_date_, 'dd.mm.yyyy'), TO_DATE (end_date_, 'dd.mm.yyyy')))
                   begin_work
            FROM (  SELECT user_id
                          ,COUNT (1) all_count
                          ,SUM (CASE WHEN status = 2 THEN 1 ELSE 0 END) vyvereno
                          ,SUM (CASE WHEN status = 4 THEN 1 ELSE 0 END) vozvrat
                      FROM (SELECT num, user_id, datetime, status
                              FROM (SELECT ROW_NUMBER () OVER (PARTITION BY l.obj_id, l.new_value ORDER BY l.record_dt) num
                                          ,l.record_dt AS datetime
                                          ,l.user_id
                                          ,d.status
                                          ,l.new_value
                                      FROM scan.ea_delo d, verify_filer l, 
                                           users u --  #24.06.2013
                                     WHERE 
--  #24.06.2013                                        
                                           l.user_id=u.user_id and
                                           u.workplace_id = 18  and
-- / #24.06.2013                                            
                                               l.op_type = 1
                                           AND l.obj_type_id = 9 -- EA_DELO.STATUS
                                           AND (CASE
                                                  WHEN d.status = 2 AND l.new_value = '2' THEN 1 --2 - выверено, 4 - возвращено
                                                  WHEN d.status = 4 AND l.new_value = '4' THEN 1
                                                  ELSE 0
                                                END) = 1
                                           AND d.delo_id = l.obj_id)
                             WHERE num = 1
                                   AND datetime BETWEEN TO_DATE (begin_date_, 'dd.mm.yyyy')
                                                    AND TO_DATE (end_date_, 'dd.mm.yyyy') + 1 - 1 / (24 * 60 * 60))
                  GROUP BY user_id
                  UNION
                  SELECT 999, 0, 0, 0 FROM DUAL)
        ORDER BY DECODE (user_name, 'ИТОГО', NULL, user_name);
--  #28.11.2013 Dikan        
  WHEN type_ = 2 THEN
      OPEN cur_ FOR
          SELECT DECODE (
                   user_id
                  ,999, 'ИТОГО'
                  ,DECODE (SUBSTR (get_user_name_fmt (user_id), 1, 36)
                          ,'Department Account Research Technics', 'Сопровождение'
                          ,get_user_name_fmt (user_id)
                          )
                 )
                   user_name
                ,user_id
                ,DECODE (user_id, 999, SUM (all_count) OVER (PARTITION BY 1), all_count) all_count
                ,DECODE (user_id, 999, SUM (vyvereno) OVER (PARTITION BY 1), vyvereno) vyvereno
                ,DECODE (user_id, 999, SUM (vozvrat) OVER (PARTITION BY 1), vozvrat) vozvrat
                ,DECODE (user_id, 999, NULL, get_user_work_time (user_id, TO_DATE (begin_date_, 'dd.mm.yyyy'), TO_DATE (end_date_, 'dd.mm.yyyy')))
                   begin_work
            FROM (  SELECT user_id
                          ,COUNT (1) all_count
                          ,SUM (CASE WHEN status = 2 THEN 1 ELSE 0 END) vyvereno
                          ,SUM (CASE WHEN status = 4 THEN 1 ELSE 0 END) vozvrat
                      FROM (SELECT num, user_id, datetime, status, affair_change, viverka_date
                              FROM (SELECT ROW_NUMBER () OVER (PARTITION BY l.obj_id, l.new_value ORDER BY l.record_dt) num
                                          ,l.record_dt AS datetime
                                          ,l.user_id
                                          ,d.status
                                          ,l.new_value
                                          ,d.affair_change
                                          ,vvd.viverka_date
                                      FROM scan.ea_delo d, users u, verify_filer l
                                           left join V_KURS3_SCAN_VIVERKA_DATE vvd on l.obj_id = vvd.delo_id --последняя дата установки статуса выверено
                                     WHERE l.user_id=u.user_id 
                                           and u.workplace_id = 18  
                                           and l.op_type = 1
                                           AND l.obj_type_id = 9 -- EA_DELO.STATUS
                                           AND (CASE
                                                  WHEN d.status = 2 AND l.new_value = '2' THEN 1 --2 текущий статус (выверено) и перевод состояния - в статус выверено
                                                  WHEN d.status = 4 AND l.new_value = '4' THEN 1 --4 текущий статус (возвращено) и перевод состояния - в статус возвращено
                                                  ELSE 0
                                                END) = 1
                                           AND d.delo_id = l.obj_id)
                             WHERE ( (num = 1) -- первая запись в истории перевода состояния пакета
                                     or 
                                    ((num > 1) -- НЕ первая запись 
                                      and (status=2) -- пакет выверен
                                      and (affair_change is not NULL) -- были изменения ДЖП после выверки 
                                      and (NVL(affair_change, cast('01.01.1800' as date))< datetime) -- дата изменений ДЖП меньше даты записи в истории перевода состояния пакета
                                      and (datetime=NVL(viverka_date, cast('01.01.1800' as date))) --  даты записи в истории перевода состояния пакета = последней дате установки статуса выверено 
                                     )
                                  )
                                   AND datetime BETWEEN TO_DATE (begin_date_, 'dd.mm.yyyy')
                                                    AND TO_DATE (end_date_, 'dd.mm.yyyy') + 1 - 1 / (24 * 60 * 60))
                  GROUP BY user_id
                  UNION
                  SELECT 999 as user_id, 0 as all_count, 0 as vyvereno, 0 as vozvrat FROM DUAL)
        ORDER BY DECODE (user_name, 'ИТОГО', NULL, user_name); 
-- /  #28.11.2013 Dikan             
  END CASE;
END verify_rep_vyv_users;
 
/
