CREATE OR REPLACE PACKAGE pkg_apartment AS
  /******************************************************************************
     NAME:       PKG_APARTMENT
     PURPOSE:    Работа с квартирами в КУРС-3

     REVISIONS:
     Ver        Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     1.0        13.11.2010  BlackHawk        1. Создание
     --         26.07.2012  Gladkov          Добавлены ф-ии update_param_rooms 
                                             и ins_param_rooms с расширенным набором параметров
               26.08.2013 Dik                Процедуры формы, пакетные процедуры для работы с информацией о причинах не заключения договоров                                            
  ******************************************************************************/

  --
  --  процедура создания записи по квартире в КУРС-3 (при вводе Ф-12 и заявления о постановке на учет)
  --
  PROCEDURE create_apartment (build_id           NUMBER
                             ,apart_num          NUMBER
                             ,apart_idx          CHAR
                             ,apart_id       OUT NUMBER
                             ,code           OUT NUMBER
                             ,user_id            NUMBER
                             ,new_build_code     NUMBER := NULL
                             );

  --
  --  процедура создания записи по квартире в КУРС-3 (при вводе Ф-12 и заявления о постановке на учет) по данным БТИ
  --
  PROCEDURE create_apartment_from_bti (p_unom NUMBER, p_unkv NUMBER, p_build_id OUT NUMBER, p_apart_id OUT NUMBER);

  --
  --  Процедура изменения данных по квартире (при вводе Ф-12 и заявления о постановке на учет)
  --
  PROCEDURE update_param_apartment (building_id        NUMBER
                                   ,apart_id           NUMBER
                                   ,space_type         NUMBER
                                   ,room_count         NUMBER
                                   ,living_space       NUMBER
                                   ,total_space        NUMBER
                                   ,room_storey_num    NUMBER
                                   ,kitchen_space      NUMBER
                                   ,lavatory           NUMBER
                                   ,balcony            NUMBER
                                   ,new_building_code  NUMBER
                                   ,good_for_living    NUMBER
                                   ,phone_presence     NUMBER
                                   ,document_date      DATE
                                   ,condition          NUMBER
                                   ,last_change        DATE
                                   ,status_bti         NUMBER
                                   ,apartment_num      NUMBER := NULL
                                   ,apartment_idx      CHAR := NULL
                                   );

  --
  --  Процедура изменения данных по комнатам (при вводе Ф-12 и заявления о постановке на учет)
  --
  PROCEDURE update_param_rooms (apart_id        NUMBER
                               ,building_id     NUMBER
                               ,room_num        NUMBER
                               ,characteristic  NUMBER
                               ,room_space      NUMBER
                               ,balcony         NUMBER
                               ,private         NUMBER
                               );
                               
  PROCEDURE update_param_rooms (apart_id        NUMBER
                               ,building_id     NUMBER
                               ,room_num        NUMBER
                               ,characteristic  NUMBER
                               ,room_space      NUMBER
                               ,balcony         NUMBER
                               ,private         NUMBER
                               ,npp_bti         NUMBER
                               ,km_bti          NUMBER
                               ,kmi_bti         CHAR := NULL
                               );
  --
  --  Процедура добавления комнат (при вводе Ф-12 и заявления о постановке на учет)
  --
  PROCEDURE ins_param_rooms (apart_id        NUMBER
                            ,building_id     NUMBER
                            ,room_num        NUMBER
                            ,characteristic  NUMBER
                            ,room_space      NUMBER
                            ,balcony         NUMBER
                            ,private         NUMBER
                            );
                            
  PROCEDURE ins_param_rooms (
    apart_id        NUMBER
   ,building_id     NUMBER
   ,room_num        NUMBER
   ,characteristic  NUMBER
   ,room_space      NUMBER
   ,balcony         NUMBER
   ,private         NUMBER
   ,npp_bti         NUMBER
   ,km_bti          NUMBER
   ,kmi_bti         CHAR := NULL
  );  
  --
  --  Процедура удаления комнат (при вводе Ф-12 и заявления о постановке на учет)
  --
  PROCEDURE del_param_rooms (apart_id NUMBER, building_id NUMBER, room_num NUMBER);

  --
  --  Завершение обработки квартиры (при вводе Ф-12 и заявления о постановке на учет)
  --
  PROCEDURE post_apartment (apart_id NUMBER);

  --
  --  Функция производит исправление данных о квартирах по данным БТИ
  --    параметр - код квартиры
  --    возвращает код квартиры, если данные совпадают, то код квартиры
  --    остается старым и исправляется STATUS_BTI,
  --    если данные не совпадают, то проверяется версия,
  --    если она равна 0 и у квартиры нет документов,то она исправляется,
  --    если документы есть - добавляется новая,
  --    если версия не равна 0, то добавляется новая квартира.
  --
  FUNCTION change_apart_from_bti (ap_id IN NUMBER)
    RETURN NUMBER;      
    
--20.03.2013 ilonis
  PROCEDURE create_apartment_kais (build_id           NUMBER
                             ,apart_num          NUMBER
                             ,apart_idx          CHAR
                             ,apart_id       OUT NUMBER
                             ,code           OUT NUMBER
                             ,user_id            NUMBER
                             ,new_build_code     NUMBER := NULL 
                             ,iscommit Number:=0
                             ) ;
                                          
                                                                       
  --20.03.2013 ilonis
   FUNCTION change_apart_from_bti_kais (ap_id IN NUMBER, isCommit Number:=0) RETURN NUMBER;
  
                                
  --11.12.2012 ilonis процедура обновляет поля unom_bti   и unkv_bti в таблице  Apartment по данным БТИ 
  PROCEDURE Set_Apartment_Unom_Unkv( apart_id_ number, unom_ out number, unkv_ out number, isCommit number:=0 ); 

/**********************************************  
#26.08.2013 Dik                
Процедуры формы, пакетные процедуры для работы с информацией о причинах не заключения договоров                                            
******************************************************************************/  
 TYPE cursor_type IS REF CURSOR;   -- тип ссылка на курсор для возврата курсора в DELPHI 
 с_classifier_ReasonsNSAgr constant number := 146;-- Код справочника - Причины не заключения договоров                        
 с_DelCode constant number := 1000;-- Код операции удаления  информации о причинах не заключения договоров   

--Вернуть константу - Код справочника  Причины не заключения договоров   (146) 
function get_R_NSAgr RETURN NUMBER;
--  Процедура получения справочника причины не заключения договоров  
procedure get_sprav_lists ( p_list_param in number, p_cur in out  cursor_type);
--  Процедура получения данных о причине не заключения договоров  
--  возвращает курсор p_cur
procedure get_ReasonNSAgr (p_apart_id IN NUMBER, p_cur in out  cursor_type) ;
--  Процедура изменения (удаления) данных о причине не заключения договоров при одном apart_id
procedure UpdDel_ReasonNSAgr (p_apart_id IN NUMBER, p_cause_nd in NUMBER, p_comment_causeof_nd in varchar2) ;
/*  Процедура тестирует возможность проведения групповой операции
  изменения (удаления) данных о причине не заключения договоров 
 Резултат: code = -1 - Одно или несколько из выбранных жилых помещений находятся в состоянии отличном от "Заселено"!
           code = 0  - список с одинаковыми данными => 
                     pReasonsNSAgrId=код причины; pReasonsNSAgrTxt= комментарии
           code = 1 Выбранные жилые помещения имеют различающуюся информацию о причинах не заключения договоров
*/              
procedure ReasonsNSAgrListTest(list_code IN NUMBER,plist_num IN NUMBER, 
                                pReasonsNSAgrId IN OUT NUMBER, pReasonsNSAgrTxt IN OUT varchar2, 
                                code IN OUT NUMBER);
/*  Процедура групповой операции изменения (удаления) данных о причине не заключения договоров 
 Резултат: code = -1 - Err
           code = 0  - Ok
*/              
procedure update_list_ReasonsNSAgr(list_code IN NUMBER,plist_num IN NUMBER, 
                                   pReasonsNSAgrId IN apartment.cause_nd%type, pReasonsNSAgrTxt IN apartment.comment_causeof_nd%type, 
                                   code IN OUT NUMBER);   
                                                                
-- / #26.08.2013 Dik
  
END pkg_apartment;
/
CREATE OR REPLACE PACKAGE BODY pkg_apartment AS
  --
  --

  --
  --  Функция проверки наличия права пользователя создавать Ф-12 по "своим" данным
  --
  FUNCTION check_create_f12_not_bti
    RETURN NUMBER IS
    nn NUMBER := 0;
  BEGIN
    FOR rec IN (SELECT 1
                  FROM global_parameters gp
                 WHERE gp.parameter_name = 'CREATE_F12_NOT_BTI' AND num_value = 1 AND USERENV ('TERMINAL') LIKE VALUE AND ROWNUM < 2) LOOP
      nn   := 1;
    END LOOP;

    RETURN nn;
  END check_create_f12_not_bti;

  --
  --  Функция проверки здания на "коттедж"
  --
  FUNCTION get_building_cottage (b_id IN NUMBER)
    RETURN building.cottage%TYPE IS
    nn building.cottage%TYPE := 0;
  BEGIN
    FOR rec IN (SELECT bb.cottage
                  FROM building bb
                 WHERE bb.building_id = get_building_cottage.b_id) LOOP
      nn   := rec.cottage;
    END LOOP;

    RETURN nn;
  END get_building_cottage;

  PROCEDURE create_apartment (build_id           NUMBER
                             ,apart_num          NUMBER
                             ,apart_idx          CHAR
                             ,apart_id       OUT NUMBER
                             ,code           OUT NUMBER
                             ,user_id            NUMBER
                             ,new_build_code     NUMBER := NULL
                             ) IS
    --
    --  10.08.1999             Исправлено копирование квартиры
    --  13.08.1999             Вставлено изменение версии на -1 в любом случае
    --  15.09.2000             Вставлена проверка типа документа
    --  02.10.2000             Добавлена регистрация
    --  02.07.2001             Добавлена проверка на повторяющиеся номера квартир
    --  10.07.2001             Добавлен запуск из KURSIV
    --  06.10.2006  avl        При создании кв. по справке ф.12 добавил сброс полей "ШН" и "Проекта" - признаков новостройки;
    --                         цель- устранить ошибку при создании кв. по образцу последней версии кв., кот. м.б. новостройкой
    --  14.11.2010  BlackHawk  Перенес процедуру в пакет pkg_apartment   
    -- 26.02.2013 ilonis добавил обработку для техпаспортов 
    --
    a1_id NUMBER;
    a_id  NUMBER;
    a3_id NUMBER;
    a_idx CHAR (1);
    nn    NUMBER;   
  BEGIN
    kurs3_var.global_action     := 'BEGIN CREATE APARTMENT';
    registration_1;
    deb_ug (1,'Create_Apartment ' ,'Apart_Num =' || TO_CHAR (apart_num) || apart_idx || ' Build_id=' || TO_CHAR (build_id) || 'SN=' || TO_CHAR (new_build_code),1 ,user_id  );

    IF kurs3_var.product_name = 'ARMRealiz' THEN
      kursiv_create_apartment_1 (build_id, apart_num, apart_idx, apart_id, code, user_id, new_build_code);
      RETURN;
    END IF;

    IF kurs3_var.tmp_doc_type IN (1, 4) THEN -- Заявление, смена адреса, восстановление КПУ
      NULL;
    ELSIF kurs3_var.tmp_doc_type = 2 THEN -- Справка Ф12
        -------------------------------------------------------------------------------------
        --        проверка есть ли квартиры по данному адресу
        --
        a_idx   := TRIM (create_apartment.apart_idx);

        SELECT MAX (apart_id)  INTO a1_id  FROM apartment
        WHERE     apartment.building_id = create_apartment.build_id
                        AND apartment.apartment_num = create_apartment.apart_num
                        AND NVL (apartment.apartment_idx, ' ') = NVL (create_apartment.a_idx, ' '); 
                        
        IF a1_id IS NULL THEN -- Нет
            deb_ug (1,'Create_Apartment ' ,'New apartment Apart_Num =' || TO_CHAR (apart_num) || a_idx || ' Build_id=' || TO_CHAR (build_id) ,1  ,user_id  );
            SELECT seq_apartment.NEXTVAL INTO a_id FROM DUAL;
            INSERT INTO apartment (apart_id, building_id, apartment_num, apartment_idx, room_count, version, last_change )  VALUES (a_id, build_id, apart_num, a_idx, 0, -1, SYSDATE);
            create_apartment.apart_id   := a_id;
            create_apartment.code       := 4;
            create_apartment.apart_id   := change_apart_from_bti (a_id);

            -- Исправление параметров квартиры по БТИ
            UPDATE apartment   SET last_change   = SYSDATE  WHERE apartment.apart_id = create_apartment.apart_id;

            deb_ug (1, 'Create_Apartment ', 'Apart_Id =' || TO_CHAR (apart_id) || 'SN1=' || TO_CHAR (new_build_code), 1, user_id);
            kurs3_var.global_action     := 'END CREATE APARTMENT ' || apart_id;
            registration_1;
            RETURN;
        ELSE -- Есть
        
            --        проверка есть ли квартиры со свободной площадью
            SELECT MAX (apartment.apart_id)    INTO a3_id   FROM apartment, free_space 
                                                                                     WHERE     apartment.building_id = create_apartment.build_id
                                                                                                     AND apartment.apartment_num = create_apartment.apart_num
                                                                                                     AND NVL (TRIM (apartment.apartment_idx), ' ') = NVL (create_apartment.a_idx, ' ')
                                                                                                     AND apartment.apart_id = free_space.apart_id
                                                                                                     AND free_space.status IN (1, 2, 5, 7)
                                                                                                     AND free_space.LAST = 1;
            IF a3_id IS NULL THEN -- Нет
                --        проверка есть ли квартиры с заселенной площадью
                SELECT MAX (apartment.apart_id)   INTO a_id     FROM apartment, free_space
                                                                                        WHERE     apartment.building_id = create_apartment.build_id
                                                                                                        AND apartment.apartment_num = create_apartment.apart_num
                                                                                                        AND NVL (apartment.apartment_idx, ' ') = NVL (create_apartment.a_idx, ' ')
                                                                                                        AND apartment.apart_id = free_space.apart_id
                                                                                                        AND free_space.status = 4
                                                                                                        AND free_space.LAST = 1;

                IF a_id IS NULL THEN -- Нет
                        deb_ug (1 ,'Create_Apartment ' ,'Old apartment NO free_space Apart_Num =' || TO_CHAR (apart_num) || a_idx || ' Build_id=' || TO_CHAR (build_id) ,1 ,user_id );
                        nn                          := copy_apartment (a1_id);
                        a1_id                       := nn;
                        create_apartment.apart_id   := a1_id;
                        create_apartment.code       := 1;
                        create_apartment.apart_id   := change_apart_from_bti (a1_id);
                        -- Исправление параметров квартиры по БТИ
                        --  Исправление номера версии
                        UPDATE apartment    SET version = -1, new_building_code = 0, -- avl 06.10.2006
                                                       project = NULL -- avl 06.10.2006
                        WHERE apartment.apart_id = a1_id;
                        
                        --ilonis 26.02.2013 Для техпаспорта
                        pkg_techpasport.update_tp_relation_apart( create_apartment.apart_id,  build_id  ,apart_num ,apart_idx,0  );                                                                                  
       
                        deb_ug (1, 'Create_Apartment ', 'Apart_Id =' || TO_CHAR (apart_id) || 'SN2=' || TO_CHAR (new_build_code), 1, user_id);
                         kurs3_var.global_action     := 'END CREATE APARTMENT ' || apart_id;
                        registration_1;
                        RETURN;
                ELSE
                    --  создание копии     
                        deb_ug ( 1 ,'Create_Apartment ',   'Old apartment NO FREE free_space Apart_Num ='  || TO_CHAR (apart_num)  || a_idx || ' Build_id=' || TO_CHAR (build_id) || ' a_id='
                                                                                                                                                                                                                                    || TO_CHAR (a_id) ,1 ,user_id);
                        nn                          := copy_apartment (a_id);
                        a_id                        := nn;
                        create_apartment.apart_id   := a_id;
                        create_apartment.code       := 1;
                        create_apartment.apart_id   := change_apart_from_bti (a_id);
                        -- Исправление параметров квартиры по БТИ
                        --    Исправление номера версии
                        UPDATE apartment    SET version = -1, new_building_code = 0, -- avl 06.10.2006
                                                       project = NULL -- avl 06.10.2006
                        WHERE apartment.apart_id = a_id;  
                        
                       --ilonis 26.02.2013 Для техпаспорта       
                        pkg_techpasport.update_tp_relation_apart( create_apartment.apart_id,  build_id  ,apart_num ,apart_idx,0  );

                        deb_ug (1, 'Create_Apartment ', 'Apart_Id =' || TO_CHAR (apart_id) || 'SN3=' || TO_CHAR (new_build_code), 1, user_id);
                        kurs3_var.global_action     := 'END CREATE APARTMENT ' || apart_id;
                        registration_1;
                        RETURN;
                END IF;
            ELSE -- Есть со свободной площадью
                deb_ug (1 ,'Create_Apartment ' ,'Old apartment FREE free_space Apart_Num =' || TO_CHAR (apart_num) || a_idx || ' Build_id=' || TO_CHAR (build_id) ,1 ,user_id  );
                create_apartment.apart_id   := a3_id;
                create_apartment.code       := 1;
                kurs3_var.global_action     := 'END CREATE APARTMENT ' || apart_id;
                registration_1;
                RETURN;
            END IF;
        END IF;
    ELSIF kurs3_var.tmp_doc_type IS NULL THEN
      NULL;
    ELSE
      raise_application_error (-20158, 'Неверный тип документа');
    END IF;

    -----------------------------*------------------------
    a_idx                       := create_apartment.apart_idx;

    SELECT apart_id  INTO a_id  FROM apartment  WHERE     apartment.building_id = create_apartment.build_id
                                                                                        AND apartment.apartment_num = create_apartment.apart_num
                                                                                        AND NVL (apartment.apartment_idx, ' ') = NVL (create_apartment.a_idx, ' ')
                                                                                        AND version = 0
                                                                                        AND ROWNUM = 1;  

    nn                          := copy_apartment (a_id);
    a_id                        := nn;
    create_apartment.apart_id   := a_id;
    create_apartment.code       := 1;
    create_apartment.apart_id   := change_apart_from_bti (a_id);
    
    -- Исправление параметров квартиры по БТИ
    UPDATE apartment    SET version   = -1  WHERE apartment.apart_id = a_id;
    
   --ilonis 26.02.2013 Для техпаспорта       
   pkg_techpasport.update_tp_relation_apart( create_apartment.apart_id,  build_id  ,apart_num ,apart_idx,0  );
    
    deb_ug (1, 'Create_Apartment ', 'Apart_Id =' || TO_CHAR (apart_id) || 'SN4=' || TO_CHAR (new_build_code) || ' USER=' || USER, 1, user_id);
    kurs3_var.global_action     := 'END CREATE APARTMENT ' || apart_id;
    registration_1;
    RETURN;
    
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
     BEGIN
            SELECT apart_id  INTO a_id    FROM apartment WHERE     apartment.building_id = create_apartment.build_id
                                                                                            AND apartment.apartment_num = create_apartment.apart_num
                                                                                            AND NVL (apartment.apartment_idx, ' ') = NVL (create_apartment.a_idx, ' ')
                                                                                            AND ROWNUM = 1;
                                                                     
            nn                          := copy_apartment (a_id);
            a_id                        := nn;
            create_apartment.apart_id   := a_id;
            create_apartment.code       := 1;
            create_apartment.apart_id   := change_apart_from_bti (a_id);
            -- Исправление параметров квартиры по БТИ
            --                      Исправление номера версии
            UPDATE apartment   SET version   = -1  WHERE apartment.apart_id = a_id;
                     
            --ilonis 26.02.2013 Для техпаспорта       
            pkg_techpasport.update_tp_relation_apart( create_apartment.apart_id,  build_id  ,apart_num ,apart_idx,0  );
               
            deb_ug (1, 'Create_Apartment ', 'Apart_Id =' || TO_CHAR (apart_id) || 'SN5=' || TO_CHAR (new_build_code), 1, user_id);
            kurs3_var.global_action     := 'END CREATE APARTMENT ' || apart_id;
            registration_1;
            RETURN;
       EXCEPTION
       WHEN NO_DATA_FOUND THEN
            SELECT seq_apartment.NEXTVAL INTO a_id FROM DUAL;
               
            INSERT INTO apartment (apart_id, building_id, apartment_num, apartment_idx, room_count, version, last_change )
                                    VALUES (a_id, build_id, apart_num, a_idx, 0, -1, SYSDATE);

            create_apartment.apart_id   := a_id;
            create_apartment.code       := 4;
            create_apartment.apart_id   := change_apart_from_bti (a_id);
            -- Исправление параметров квартиры по БТИ
             UPDATE apartment   SET last_change   = SYSDATE -- Для простановки параметров по БТИ
            WHERE apartment.apart_id = create_apartment.apart_id;
            
            --ilonis 26.02.2013 Для техпаспорта       
            pkg_techpasport.update_tp_relation_apart( create_apartment.apart_id,  build_id  ,apart_num ,apart_idx,0  );
            
            deb_ug (1, 'Create_Apartment ', 'Apart_Id =' || TO_CHAR (apart_id) || 'SN6=' || TO_CHAR (new_build_code), 1, user_id);
            kurs3_var.global_action     := 'END CREATE APARTMENT ' || apart_id;
            registration_1;
            RETURN;
         END;
  END create_apartment;

  PROCEDURE create_apartment_from_bti (p_unom NUMBER, p_unkv NUMBER, p_build_id OUT NUMBER, p_apart_id OUT NUMBER) AS
    --
    --  11.03.2011  BlackHawk  Добавил установку лоджий(балконов) для комнат при переносе "по чистому"
    --                         Добавил установку лоджий(балконов) для квартиры
    --
    code_ NUMBER;
  BEGIN
    --> определяем building_id
    BEGIN
      SELECT bb.building_id
        INTO p_build_id
        FROM bti.building_bti bb
       WHERE bb.unom = create_apartment_from_bti.p_unom;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        raise_application_error (-20550, '#Не найден корпус в БТИ !#');
    END;

    IF NVL (p_build_id, 0) = 0 THEN
      raise_application_error (-20550
                              ,'#Нет сопоставления корпуса по БТИ (unom=' || create_apartment_from_bti.p_unom || ') !#'
                              );
    END IF;

    --< определяем building_id

    --> делаем новую квартиру
    FOR rec IN (SELECT *
                  FROM bti.appart_st_cards aps
                 WHERE aps.unom = create_apartment_from_bti.p_unom AND aps.kl = 1 AND aps.unkv = create_apartment_from_bti.p_unkv) LOOP
      pkg_apartment.create_apartment (p_build_id, rec.kv, rec.kvi, p_apart_id, code_, get_user_unique_id (kurs3_var.global_user_id), NULL);

      UPDATE apartment ap
         SET ap.balcony   = bti.get_balcony_room (create_apartment_from_bti.p_unom, create_apartment_from_bti.p_unkv)
       WHERE ap.apart_id = create_apartment_from_bti.p_apart_id;
    END LOOP;

    IF NVL (p_apart_id, 0) = 0 THEN
      raise_application_error (-20550, '#Нет возможности формирования квартиры в КУРС-е !#');
    END IF;

    --< делаем новую квартиру

    --> переносим комнаты из БТИ "по чистому"
    DELETE FROM room
     WHERE room.apart_id = p_apart_id;

    FOR rec
      IN (SELECT ROWNUM AS km, kmi, snz, opl, unom, unkv
            FROM (SELECT *
                    FROM bti.rooms rms
                   WHERE     rms.unom = create_apartment_from_bti.p_unom
                         AND rms.unkv = create_apartment_from_bti.p_unkv
                         AND rms.nz IN (1, 2, 3, 11, 12, 84, 85)
                  ORDER BY rms.km, rms.kmi)) LOOP
      INSERT INTO room (apart_id, building_id, room_num, room_space, last_change, room_char, characteristic, balcony
                       )
      VALUES (p_apart_id, p_build_id, rec.km, rec.opl, SYSDATE, DECODE (TRIM (rec.kmi), NULL, NULL, 1)
             ,DECODE (rec.snz,  1, 1,  2, 4,  3, 3,  4, 2,  rec.snz), get_balcony_room_1 (rec.unom, rec.unkv, rec.km)
             );
    END LOOP;
  --< переносим комнаты из БТИ
  END create_apartment_from_bti;

  PROCEDURE update_param_apartment (building_id        NUMBER
                                   ,apart_id           NUMBER
                                   ,space_type         NUMBER
                                   ,room_count         NUMBER
                                   ,living_space       NUMBER
                                   ,total_space        NUMBER
                                   ,room_storey_num    NUMBER
                                   ,kitchen_space      NUMBER
                                   ,lavatory           NUMBER
                                   ,balcony            NUMBER
                                   ,new_building_code  NUMBER
                                   ,good_for_living    NUMBER
                                   ,phone_presence     NUMBER
                                   ,document_date      DATE
                                   ,condition          NUMBER
                                   ,last_change        DATE
                                   ,status_bti         NUMBER
                                   ,apartment_num      NUMBER := NULL
                                   ,apartment_idx      CHAR := NULL
                                   ) AS
    --
    --  15.02.2000             Исправление ввода справок Ф12
    --  20.03.2000             Запрет исправления жилой площади квартиры
    --  21.03.2000             Запрет изменения этажа квартиры со свободной площадью
    --  21.03.2000             Проверка допустимости этажа
    --  07.04.2000             Изменен оператор UPDATE APARTMENT
    --  19.06.2000             Удалено исправление версии
    --  21.05.2001             Добавлен номер и индекс квартиры для експликаций
    --  14.11.2010  BlackHawk  Перенес процедуру в пакет pkg_apartment;
    --                         добавлена НЕвозможность сделать Ф-12 без соответствия данным БТИ (УИТ-540/2010)
    --  29.03.2011  BlackHawk  Добавил установку space_type при вводе Ф-12 для людей с "не полными полномочиями"
    --
    sq_type      NUMBER;
    r_count      NUMBER;
    t_space      NUMBER;
    l_space      NUMBER;
    storey       NUMBER;
    max_storey   NUMBER;
    nn           NUMBER;
    v_status_bti apartment.status_bti%TYPE := 0;
  BEGIN
    BEGIN
      SELECT building.storeys
        INTO max_storey
        FROM building
       WHERE building.building_id = update_param_apartment.building_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        max_storey   := 1000;
    END;

    IF kurs3_var.tmp_doc_type = 2 THEN -- Справка за выбытием
      BEGIN
        SELECT apartment.space_type, apartment.room_count, apartment.total_space, apartment.living_space, apartment.room_storey_num, status_bti
          INTO sq_type, r_count, t_space, l_space, storey, v_status_bti
          FROM apartment
         WHERE apartment.apart_id = update_param_apartment.apart_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          NULL;
      END;

      SELECT COUNT (*)
        INTO nn
        FROM free_space
       WHERE free_space.apart_id = update_param_apartment.apart_id AND free_space.status IN (1, 2, 5) AND free_space.LAST = 1;

      IF nn > 0 THEN
        IF update_param_apartment.room_count < r_count THEN
          raise_application_error (
            -20159
           ,'Нельзя уменьшать количество комнат в квартире, где есть свободная жилплощадь');
        END IF;

        IF update_param_apartment.room_count <> r_count THEN
          raise_application_error (
            -20170
           ,'Нельзя изменять количество комнат в квартире, где есть свободная жилплощадь');
        END IF;

        IF update_param_apartment.space_type <> sq_type THEN
          raise_application_error (-20160
                                  ,'Нельзя изменять тип квартиры, где есть свободная жилплощадь'
                                  );
        END IF;

        IF update_param_apartment.total_space <> t_space THEN
          raise_application_error (
            -20161
           ,'Нельзя изменять общую площадь в квартире, где есть свободная жилплощадь');
        END IF;

        IF update_param_apartment.living_space <> l_space THEN
          raise_application_error (
            -20167
           ,'Нельзя изменять жилую площадь в квартире, где есть свободная жилплощадь');
        END IF;

        IF update_param_apartment.room_storey_num <> storey THEN
          raise_application_error (-20168
                                  ,'Нельзя изменять этаж квартиры, где есть свободная жилплощадь'
                                  );
        END IF;
      END IF;
    END IF;

    IF update_param_apartment.room_storey_num > max_storey THEN
      raise_application_error (-20169, 'Неправильный этаж квартиры');
    END IF;


    IF kurs3_var.tmp_doc_type = 2 AND check_create_f12_not_bti = 0 THEN /* у пользователя нет прав записывать "отсебятину" */
      -- обязательны правильные данные по БТИ, а не то, что прислал пользователь:
      IF v_status_bti <> 1 THEN
        raise_application_error (
          -20461
         ,'#В данных БТИ отсутствует информация о квартире. Обратитесь в службу техподдержки!#');
      END IF;

      IF get_building_cottage (update_param_apartment.building_id) <> 3 /* Тип здания "коттедж" ? */
                                                                       THEN
        -- записываем данные, которых нет в БТИ:
        UPDATE apartment
           SET new_building_code = update_param_apartment.new_building_code, good_for_living = update_param_apartment.good_for_living
              ,phone_presence = update_param_apartment.phone_presence, condition = update_param_apartment.condition
              ,last_change = SYSDATE, space_type = update_param_apartment.space_type
         WHERE apartment.apart_id = update_param_apartment.apart_id;
      ELSE
        raise_application_error (-20865, '#На дом установлен запрет. Обратитесь в УИТ Департамента!#');
      END IF;
    ELSE
      -- можно записать все данные от пользователя:
      IF apartment_num IS NOT NULL THEN
        UPDATE apartment
           SET apartment_num = update_param_apartment.apartment_num, apartment_idx = update_param_apartment.apartment_idx
              ,space_type = update_param_apartment.space_type, room_count = update_param_apartment.room_count
              ,living_space = update_param_apartment.living_space, total_space = update_param_apartment.total_space
              ,room_storey_num = update_param_apartment.room_storey_num, kitchen_space = update_param_apartment.kitchen_space
              ,lavatory = update_param_apartment.lavatory, balcony = update_param_apartment.balcony
              ,new_building_code = update_param_apartment.new_building_code, good_for_living = update_param_apartment.good_for_living
              ,phone_presence = update_param_apartment.phone_presence, --    DOCUMENT_DATE=update_param_apartment.DOCUMENT_DATE,
                                                                      condition = update_param_apartment.condition
              ,last_change = SYSDATE, --    version=0,
                                      --    LAST_CHANGE=update_param_apartment.LAST_CHANGE,
                status_bti = update_param_apartment.status_bti
         WHERE apartment.apart_id = update_param_apartment.apart_id;
      ELSE
        UPDATE apartment
           SET --    BUILDING_ID=update_param_apartment.BUILDING_ID,
               --    APART_ID,
               --    APARTMENT_NUM,
               --    APARTMENT_IDX,
               space_type = update_param_apartment.space_type, room_count = update_param_apartment.room_count
              ,living_space = update_param_apartment.living_space, total_space = update_param_apartment.total_space
              ,room_storey_num = update_param_apartment.room_storey_num, kitchen_space = update_param_apartment.kitchen_space
              ,lavatory = update_param_apartment.lavatory, balcony = update_param_apartment.balcony
              ,new_building_code = update_param_apartment.new_building_code, good_for_living = update_param_apartment.good_for_living
              ,phone_presence = update_param_apartment.phone_presence, --    DOCUMENT_DATE=update_param_apartment.DOCUMENT_DATE,
                                                                      condition = update_param_apartment.condition
              ,last_change = SYSDATE, --    version=0,
                                      --    LAST_CHANGE=update_param_apartment.LAST_CHANGE,
                status_bti = update_param_apartment.status_bti
         WHERE apartment.apart_id = update_param_apartment.apart_id;
      END IF;
    END IF;
  END update_param_apartment;


  PROCEDURE update_param_rooms (apart_id        NUMBER
                               ,building_id     NUMBER
                               ,room_num        NUMBER
                               ,characteristic  NUMBER
                               ,room_space      NUMBER
                               ,balcony         NUMBER
                               ,private         NUMBER
                               ) AS
    r_space NUMBER;
    r_char  NUMBER;
    nn      NUMBER;
  --
  --  14.11.2010  BlackHawk  Перенес процедуру в пакет pkg_apartment;
  --                         Добавлена НЕвозможность сделать Ф-12 без соответствия данным БТИ (УИТ-540/2010)
  --
  BEGIN
    IF kurs3_var.tmp_doc_type = 2 THEN -- Справка за выбытием
      BEGIN
        SELECT room.free_space_id, room.room_space, room.characteristic
          INTO nn, r_space, r_char
          FROM room
         WHERE room.room_num = update_param_rooms.room_num AND room.apart_id = update_param_rooms.apart_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          NULL;
      END;

      IF nn > 0 THEN
        IF update_param_rooms.room_space <> r_space THEN
          raise_application_error (-20162, 'Нельзя редактировать свободную комнату');
        END IF;

        IF update_param_rooms.characteristic <> r_char THEN
          raise_application_error (-20162, 'Нельзя редактировать свободную комнату');
        END IF;
      END IF;
    END IF;

    IF NOT (kurs3_var.tmp_doc_type = 2 AND check_create_f12_not_bti = 0) THEN
      UPDATE room
         SET characteristic = update_param_rooms.characteristic, room_space = update_param_rooms.room_space, balcony = update_param_rooms.balcony
            ,private = update_param_rooms.private
       WHERE room.apart_id = update_param_rooms.apart_id AND update_param_rooms.room_num = room.room_num;
    END IF;
  END update_param_rooms;
  
  PROCEDURE update_param_rooms (apart_id        NUMBER
                               ,building_id     NUMBER
                               ,room_num        NUMBER
                               ,characteristic  NUMBER
                               ,room_space      NUMBER
                               ,balcony         NUMBER
                               ,private         NUMBER
                               ,npp_bti         NUMBER
                               ,km_bti          NUMBER
                               ,kmi_bti         CHAR := NULL
                               ) AS
    r_space NUMBER;
    r_char  NUMBER;
    nn      NUMBER;
  --
  --  14.11.2010  BlackHawk  Перенес процедуру в пакет pkg_apartment;
  --                         Добавлена НЕвозможность сделать Ф-12 без соответствия данным БТИ (УИТ-540/2010)
  --
  BEGIN
    IF kurs3_var.tmp_doc_type = 2 THEN -- Справка за выбытием
      BEGIN
        SELECT room.free_space_id, room.room_space, room.characteristic
          INTO nn, r_space, r_char
          FROM room
         WHERE room.room_num = update_param_rooms.room_num AND room.apart_id = update_param_rooms.apart_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          NULL;
      END;

      IF nn > 0 THEN
        IF update_param_rooms.room_space <> r_space THEN
          raise_application_error (-20162, 'Нельзя редактировать свободную комнату');
        END IF;

        IF update_param_rooms.characteristic <> r_char THEN
          raise_application_error (-20162, 'Нельзя редактировать свободную комнату');
        END IF;
      END IF;
    END IF;

    IF NOT (kurs3_var.tmp_doc_type = 2 AND check_create_f12_not_bti = 0) THEN
      UPDATE room
         SET characteristic = update_param_rooms.characteristic, room_space = update_param_rooms.room_space, balcony = update_param_rooms.balcony
            ,private = update_param_rooms.private, npp_bti = update_param_rooms.npp_bti, km_bti = update_param_rooms.km_bti, kmi_bti = update_param_rooms.kmi_bti
       WHERE room.apart_id = update_param_rooms.apart_id AND update_param_rooms.room_num = room.room_num;
    END IF;
  END update_param_rooms;

  PROCEDURE ins_param_rooms (apart_id        NUMBER
                            ,building_id     NUMBER
                            ,room_num        NUMBER
                            ,characteristic  NUMBER
                            ,room_space      NUMBER
                            ,balcony         NUMBER
                            ,private         NUMBER
                            ) AS
  --
  --  19.08.1999             Создание
  --  24.08.2001             Изменено FREE_CPACE
  --  14.11.2010  BlackHawk  Перенес процедуру в пакет pkg_apartment
  --
  BEGIN
    IF NOT (kurs3_var.tmp_doc_type = 2 AND check_create_f12_not_bti = 0) THEN
      INSERT INTO room (apart_id, building_id, room_num, characteristic, room_space, balcony, private, free_space_id, last_change
                       )
      VALUES (ins_param_rooms.apart_id, ins_param_rooms.building_id, ins_param_rooms.room_num, ins_param_rooms.characteristic, ins_param_rooms.room_space
             ,ins_param_rooms.balcony, ins_param_rooms.private, 0, SYSDATE
             );
    END IF;
  END ins_param_rooms;
  
  PROCEDURE ins_param_rooms (apart_id        NUMBER
                            ,building_id     NUMBER
                            ,room_num        NUMBER
                            ,characteristic  NUMBER
                            ,room_space      NUMBER
                            ,balcony         NUMBER
                            ,private         NUMBER
                            ,npp_bti         NUMBER
                            ,km_bti          NUMBER
                            ,kmi_bti         CHAR := NULL
                            ) AS
  --
  --  19.08.1999             Создание
  --  24.08.2001             Изменено FREE_CPACE
  --  14.11.2010  BlackHawk  Перенес процедуру в пакет pkg_apartment
  --
  BEGIN
    IF NOT (kurs3_var.tmp_doc_type = 2 AND check_create_f12_not_bti = 0) THEN
      INSERT INTO room (apart_id, building_id, room_num, characteristic, room_space, balcony, private, free_space_id, last_change,
                       npp_bti, km_bti, kmi_bti
                       )
      VALUES (ins_param_rooms.apart_id, ins_param_rooms.building_id, ins_param_rooms.room_num, ins_param_rooms.characteristic, ins_param_rooms.room_space
             ,ins_param_rooms.balcony, ins_param_rooms.private, 0, SYSDATE,
             ins_param_rooms.npp_bti, ins_param_rooms.km_bti, ins_param_rooms.kmi_bti
             );
    END IF;
  END ins_param_rooms;

  PROCEDURE del_param_rooms (apart_id NUMBER, building_id NUMBER, room_num NUMBER) AS
    --
    --  15.02.2000             Создание
    --  14.11.2010  BlackHawk  Перенес процедуру в пакет pkg_apartment
    --
    nn NUMBER;
  BEGIN
    IF kurs3_var.tmp_doc_type = 2 THEN -- Справка за выбытием
      SELECT COUNT (*)
        INTO nn
        FROM free_space
       WHERE free_space.apart_id = del_param_rooms.apart_id AND free_space.status IN (1, 2, 5) AND free_space.LAST = 1;

      IF nn > 0 THEN
        raise_application_error (
          -20159
         ,'Нельзя уменьшать количество комнат в квартире, где есть свободная жилплощадь');
      END IF;
    END IF;

    IF NOT (kurs3_var.tmp_doc_type = 2 AND check_create_f12_not_bti = 0) THEN
      DELETE FROM room
       WHERE room.apart_id = del_param_rooms.apart_id AND del_param_rooms.room_num = room.room_num;
    END IF;
  END del_param_rooms;

  PROCEDURE post_apartment (apart_id NUMBER) AS
    --
    --  04.08.1999  Завершение обработки квартиры
    --  01.11.1999  Добавлено запоминание кода здания
    --  15.02.2000  Добавлено запоминание кода квартиры
    --  15.02.2000  Добавлено запоминание номера квартиры
    --  15.02.2000  Добавлено запоминание индекса квартиры
    --
    b_id  NUMBER;
    a_num NUMBER;
    a_idx VARCHAR2 (5);
  BEGIN
    UPDATE apartment
       SET last_change = SYSDATE, version = -4
     WHERE apartment.apart_id = post_apartment.apart_id
    RETURNING building_id, apartment_num, apartment_idx
      INTO b_id, a_num, a_idx;

    kurs3_var.tmp_building_id     := b_id;
    kurs3_var.tmp_apart_id        := apart_id;
    kurs3_var.tmp_apartment_num   := a_num;
    kurs3_var.tmp_apartment_idx   := a_idx;
  END post_apartment;

  FUNCTION change_apart_from_bti (ap_id IN NUMBER)
    RETURN NUMBER AS
    --
    --  26.07.1999             Исправлена нумерация комнат
    --  02.08.1999             Добавлена проверка на отсутствие комнаты в БТИ
    --  29.02.2000             Исправлено соединение с квартирами
    --  06.09.2000             Исправлено заполнение общей площади
    --  24.08.2001             Исправлен FREE_CPACE
    --  14.11.2010  BlackHawk  Добавил order_by при инсерте комнат из БТИ;
    --                         вставка комнат из БТИ при любых случаях переноса данных из БТИ;
    --                         перенес функцию в пакет pkg_apartment
    --

    nn       NUMBER;
    u_nom    NUMBER;
    u_nkv    NUMBER;
    a_kmn    NUMBER;
    a_sqi    NUMBER;
    a_sqo    NUMBER;
    a_sqk    NUMBER;
    a_et     NUMBER;
    a_balc   NUMBER;
    a_lav    NUMBER;
    b_kmn    NUMBER;
    b_sqi    NUMBER;
    b_sqo    NUMBER;
    b_sqk    NUMBER;
    b_lav    NUMBER;
    b_et     NUMBER;
    ap1_id   NUMBER;
    b_id     NUMBER;
    n1       NUMBER;
    sun_unom NUMBER;

    CURSOR cur_rooms IS
      SELECT *
        FROM bti.rooms
       WHERE rooms.unom = u_nom AND rooms.unkv = u_nkv;
  BEGIN
    SELECT COUNT (*)
      INTO nn
      FROM apartment, bti.appart_bti
     WHERE     apartment.building_id = appart_bti.building_id
           AND apartment.apart_id = ap_id
           AND apartment.apartment_num = appart_bti.kv
           AND NVL (apartment.apartment_idx, ' ') = NVL (appart_bti.kvi, ' ');

    deb_ug (1, 'Change_BTI ', 'Apart_Id =' || TO_CHAR (ap_id), 1, nn);

    IF nn = 0 THEN -- Не найдена квартира в БТИ
      BEGIN
        SELECT bti_unom
          INTO sun_unom
          FROM building, apartment
         WHERE building.building_id = apartment.building_id AND apartment.apart_id = ap_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RETURN ap_id;
      END;

      SELECT COUNT (*)
        INTO n1
        FROM apartment, bti.appart_bti, bti.building_bti
       WHERE     apartment.apart_id = ap_id
             AND apartment.apartment_num = appart_bti.kv
             AND NVL (apartment.apartment_idx, ' ') = NVL (appart_bti.kvi, ' ')
             AND appart_bti.unom = building_bti.unom
             AND building_bti.sun = sun_unom;

      IF n1 = 1 THEN -- Одна квартира
        SELECT appart_bti.unom, appart_bti.unkv, apartment.building_id
          INTO u_nom, u_nkv, b_id
          FROM apartment, bti.appart_bti, bti.building_bti
         WHERE     building_bti.unom = appart_bti.unom
               AND apartment.apart_id = ap_id
               AND apartment.apartment_num = appart_bti.kv
               AND NVL (apartment.apartment_idx, ' ') = NVL (appart_bti.kvi, ' ')
               AND building_bti.sun = sun_unom;
      ELSIF n1 > 1 THEN -- Несколько одинаковых квартир в БТИ
        RETURN ap_id;
      ELSE
        -- Не найдена квартира в БТИ
        RETURN ap_id;
      END IF;
    ELSIF nn > 1 THEN -- Несколько одинаковых квартир в БТИ
      RETURN ap_id;
    ELSE -- Квартира найдена в БТИ
      SELECT unom, unkv, apartment.building_id
        INTO u_nom, u_nkv, b_id
        FROM apartment, bti.appart_bti
       WHERE     apartment.building_id = appart_bti.building_id
             AND apartment.apart_id = ap_id
             AND apartment.apartment_num = appart_bti.kv
             AND NVL (apartment.apartment_idx, ' ') = NVL (appart_bti.kvi, ' ');
    END IF;

    BEGIN
      SELECT room_count, living_space, --total_space,
                                      p_space, kitchen_space, storey, balcony
        INTO a_kmn, a_sqi, a_sqo, a_sqk, a_et, a_balc
        FROM bti.v_apart_bti_1
       WHERE unom = u_nom AND unkv = u_nkv;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN -- Не найдена квартира в БТИ
        RETURN ap_id;
    END;

    SELECT room_count, living_space, total_space, kitchen_space, room_storey_num, lavatory
      INTO b_kmn, b_sqi, b_sqo, b_sqk, b_et, b_lav
      FROM apartment
     WHERE apart_id = ap_id;

    a_lav   := get_lavatory_room (u_nom, u_nkv);

    --
    --       Вставить проверку комнат
    --
    SELECT COUNT (*)
      INTO nn
      FROM apartment, room, bti.building_bti, bti.rooms
     WHERE     apartment.apart_id = ap_id
           AND apartment.apart_id = room.apart_id
           AND apartment.building_id = building_bti.building_id
           AND rooms.unom = building_bti.unom
           AND rooms.unkv = get_bti_by_apart (apartment.apart_id)
           AND rooms.km = room.room_num
           AND rooms.opl = room.room_space
           AND rooms.nz IN (1, 2, 3, 11, 12, 84, 85); -- только жилые комнаты

    deb_ug (1, 'Change_BTI ', 'Rooms Apart_Id =' || TO_CHAR (ap_id), 1, nn);

    IF a_kmn = b_kmn AND a_sqi = b_sqi AND a_sqo = b_sqo AND a_sqk = b_sqk AND a_et = b_et AND nn = a_kmn THEN -- комнаты одинаковы
      UPDATE apartment
         SET status_bti   = 1
       WHERE apart_id = ap_id;

      deb_ug (1, 'Change_BTI OK', 'Update Apart_Id =' || TO_CHAR (ap_id), 1, nn);
      RETURN ap_id;
    ELSE
      IF get_apart_documents (ap_id) = 0 THEN -- документов по квартире нет
        UPDATE apartment
           SET room_count = a_kmn, living_space = a_sqi, total_space = a_sqo, kitchen_space = a_sqk, room_storey_num = a_et, balcony = a_balc
              ,lavatory = a_lav, status_bti = 1
         WHERE apart_id = ap_id;

        deb_ug (1, 'Change_BTI ', 'Update_NO_DOC Apart_Id =' || TO_CHAR (ap_id), 1, nn);

        -- комнаты переносим из БТИ
        DELETE FROM room
         WHERE apart_id = ap_id;

        INSERT INTO room (apart_id, building_id, room_num, characteristic, room_space, balcony, private, last_change, free_space_id
                         )
          SELECT ap_id, b_id, ROWNUM AS km, room_char_bti_to_kurs (nz), opl, get_balcony_room_1 (unom, unkv, km), NULL, SYSDATE, 0
            FROM bti.rooms rooms
           WHERE unom = u_nom AND unkv = u_nkv AND rooms.nz IN (1, 2, 3, 11, 12, 84, 85) -- только жилые комнаты
          ORDER BY rooms.km, rooms.kmi;

        COMMIT; -- фиксация
        RETURN ap_id;
      ELSE -- документы по квартире есть
        SELECT seq_apartment.NEXTVAL INTO ap1_id FROM DUAL;

        deb_ug (1, 'Change_BTI ', 'UPDATE_DOCS Apart_Id =' || TO_CHAR (ap1_id), 1, nn);

        INSERT INTO apartment (building_id, apart_id, apartment_num, apartment_idx, space_type, room_count, living_space, total_space
                     ,room_storey_num, kitchen_space, lavatory, balcony, new_building_code, good_for_living, phone_presence, document_date
                     ,condition, last_change, status_bti, version, vs_id, private
                              )
          SELECT apa.building_id, ap1_id, apa.apartment_num, apa.apartment_idx, apa.space_type, a_kmn, a_sqi, a_sqo, a_et
                ,a_sqk, a_lav, a_balc, apa.new_building_code, apa.good_for_living, apa.phone_presence, apa.document_date, apa.condition, SYSDATE
                ,1 AS status_bti, -1 /* временная версия */
                                    AS version, apa.vs_id, apa.private
            FROM apartment apa
           WHERE apart_id = ap_id;

        UPDATE apartment
           SET version   = -2
         WHERE apart_id = ap_id;

        -- комнаты переносим из БТИ
        INSERT INTO room (apart_id, building_id, room_num, characteristic, room_space, balcony, private, last_change, free_space_id
                         )
          SELECT ap1_id, b_id, ROWNUM AS km, room_char_bti_to_kurs (nz), opl, get_balcony_room_1 (unom, unkv, km) balc, NULL, SYSDATE, 0
            FROM bti.rooms rooms
           WHERE unom = u_nom AND unkv = u_nkv AND rooms.nz IN (1, 2, 3, 11, 12, 84, 85) -- только жилые комнаты
          ORDER BY rooms.km, rooms.kmi;

        COMMIT; -- фиксация
        RETURN ap1_id;
      END IF;
    END IF;
  END change_apart_from_bti;          
  
  
 
 --20.03.2013 ilonis 
    PROCEDURE create_apartment_kais (build_id           NUMBER
                             ,apart_num          NUMBER
                             ,apart_idx          CHAR
                             ,apart_id       OUT NUMBER
                             ,code           OUT NUMBER
                             ,user_id            NUMBER
                             ,new_build_code     NUMBER := NULL 
                             ,iscommit Number:=0
                             ) IS
    --
    --  10.08.1999             Исправлено копирование квартиры
    --  13.08.1999             Вставлено изменение версии на -1 в любом случае
    --  15.09.2000             Вставлена проверка типа документа
    --  02.10.2000             Добавлена регистрация
    --  02.07.2001             Добавлена проверка на повторяющиеся номера квартир
    --  10.07.2001             Добавлен запуск из KURSIV
    --  06.10.2006  avl        При создании кв. по справке ф.12 добавил сброс полей "ШН" и "Проекта" - признаков новостройки;
    --                         цель- устранить ошибку при создании кв. по образцу последней версии кв., кот. м.б. новостройкой
    --  14.11.2010  BlackHawk  Перенес процедуру в пакет pkg_apartment
    --
    a1_id NUMBER;
    a_id  NUMBER;
    a3_id NUMBER;
    a_idx CHAR (1);
    nn    NUMBER;
  BEGIN
    kurs3_var.global_action     := 'BEGIN CREATE APARTMENT';
    registration_1;
    deb_ug (1
           ,'Create_Apartment '
           ,'Apart_Num =' || TO_CHAR (apart_num) || apart_idx || ' Build_id=' || TO_CHAR (build_id) || 'SN=' || TO_CHAR (new_build_code)
           ,1
           ,user_id
           );

    IF kurs3_var.product_name = 'ARMRealiz' THEN
      kursiv_create_apartment_1 (build_id, apart_num, apart_idx, apart_id, code, user_id, new_build_code);
      RETURN;
    END IF;

    IF kurs3_var.tmp_doc_type IN (1, 4) THEN -- Заявление, смена адреса, восстановление КПУ
      NULL;
    ELSIF kurs3_var.tmp_doc_type = 2 THEN -- Справка Ф12
      -------------------------------------------------------------------------------------
      --        проверка есть ли квартиры по данному адресу
      --
      a_idx   := TRIM (create_apartment_kais.apart_idx);

      SELECT MAX (apart_id)
        INTO a1_id
        FROM apartment
       WHERE     apartment.building_id = create_apartment_kais.build_id
             AND apartment.apartment_num = create_apartment_kais.apart_num
             AND NVL (apartment.apartment_idx, ' ') = NVL (create_apartment_kais.a_idx, ' ');

      IF a1_id IS NULL THEN -- Нет
        deb_ug (1
               ,'Create_Apartment_kais '
               ,'New apartment Apart_Num =' || TO_CHAR (apart_num) || a_idx || ' Build_id=' || TO_CHAR (build_id)
               ,1
               ,user_id
               );

        SELECT seq_apartment.NEXTVAL INTO a_id FROM DUAL;

        INSERT INTO apartment (apart_id, building_id, apartment_num, apartment_idx, room_count, version, last_change
                              )
        VALUES (a_id, build_id, apart_num, a_idx, 0, -1, SYSDATE);

        create_apartment_kais.apart_id   := a_id;
        create_apartment_kais.code       := 4;
        create_apartment_kais.apart_id   := change_apart_from_bti_kais (a_id, iscommit);

        -- Исправление параметров квартиры по БТИ

        UPDATE apartment
           SET last_change   = SYSDATE
         WHERE apartment.apart_id = create_apartment_kais.apart_id;

        deb_ug (1, 'Create_Apartment_kais ', 'Apart_Id =' || TO_CHAR (apart_id) || 'SN1=' || TO_CHAR (new_build_code), 1, user_id);
        kurs3_var.global_action     := 'END CREATE APARTMENT ' || apart_id;
        registration_1;
        RETURN;
      ELSE -- Есть
        --
        --        проверка есть ли квартиры со свободной площадью
        --
        SELECT MAX (apartment.apart_id)
          INTO a3_id
          FROM apartment, free_space
         WHERE     apartment.building_id = create_apartment_kais.build_id
               AND apartment.apartment_num = create_apartment_kais.apart_num
               AND NVL (TRIM (apartment.apartment_idx), ' ') = NVL (create_apartment_kais.a_idx, ' ')
               AND apartment.apart_id = free_space.apart_id
               AND free_space.status IN (1, 2, 5, 7)
               AND free_space.LAST = 1;

        IF a3_id IS NULL THEN -- Нет
          --
          --        проверка есть ли квартиры с заселенной площадью
          --
          SELECT MAX (apartment.apart_id)
            INTO a_id
            FROM apartment, free_space
           WHERE     apartment.building_id = create_apartment_kais.build_id
                 AND apartment.apartment_num = create_apartment_kais.apart_num
                 AND NVL (apartment.apartment_idx, ' ') = NVL (create_apartment_kais.a_idx, ' ')
                 AND apartment.apart_id = free_space.apart_id
                 AND free_space.status = 4
                 AND free_space.LAST = 1;

          IF a_id IS NULL THEN -- Нет
            deb_ug (1
                   ,'Create_Apartment_kais '
                   ,'Old apartment NO free_space Apart_Num =' || TO_CHAR (apart_num) || a_idx || ' Build_id=' || TO_CHAR (build_id)
                   ,1
                   ,user_id
                   );
            nn                          := copy_apartment (a1_id);
            a1_id                       := nn;
            create_apartment_kais.apart_id   := a1_id;
            create_apartment_kais.code       := 1;
            create_apartment_kais.apart_id   := change_apart_from_bti_kais (a1_id, iscommit);

            -- Исправление параметров квартиры по БТИ

            --                        Исправление номера версии
            UPDATE apartment
               SET version = -1, new_building_code = 0, -- avl 06.10.2006
                                                       project = NULL -- avl 06.10.2006
             WHERE apartment.apart_id = a1_id;

            deb_ug (1, 'Create_Apartment_kais ', 'Apart_Id =' || TO_CHAR (apart_id) || 'SN2=' || TO_CHAR (new_build_code), 1, user_id);
            kurs3_var.global_action     := 'END CREATE APARTMENT ' || apart_id;
            registration_1;
            RETURN;
          ELSE
            --
            --              создание копии
            --
            deb_ug (
              1
             ,'Create_Apartment '
             ,   'Old apartment NO FREE free_space Apart_Num ='
              || TO_CHAR (apart_num)
              || a_idx
              || ' Build_id='
              || TO_CHAR (build_id)
              || ' a_id='
              || TO_CHAR (a_id)
             ,1
             ,user_id);
            nn                          := copy_apartment (a_id);
            a_id                        := nn;
            create_apartment_kais.apart_id   := a_id;
            create_apartment_kais.code       := 1;
            create_apartment_kais.apart_id   := change_apart_from_bti_kais (a_id, iscommit);

            -- Исправление параметров квартиры по БТИ

            --                      Исправление номера версии
            UPDATE apartment
               SET version = -1, new_building_code = 0, -- avl 06.10.2006
                                                       project = NULL -- avl 06.10.2006
             WHERE apartment.apart_id = a_id;

            deb_ug (1, 'Create_Apartment_kais ', 'Apart_Id =' || TO_CHAR (apart_id) || 'SN3=' || TO_CHAR (new_build_code), 1, user_id);
            kurs3_var.global_action     := 'END CREATE APARTMENT ' || apart_id;
            registration_1;
            RETURN;
          END IF;
        ELSE -- Есть со свободной площадью
          deb_ug (1
                 ,'Create_Apartment '
                 ,'Old apartment FREE free_space Apart_Num =' || TO_CHAR (apart_num) || a_idx || ' Build_id=' || TO_CHAR (build_id)
                 ,1
                 ,user_id
                 );
          create_apartment_kais.apart_id   := a3_id;
          create_apartment_kais.code       := 1;
          kurs3_var.global_action     := 'END CREATE APARTMENT ' || apart_id;
          registration_1;
          RETURN;
        END IF;
      END IF;
    ELSIF kurs3_var.tmp_doc_type IS NULL THEN
      NULL;
    ELSE
      raise_application_error (-20158, 'Неверный тип документа');
    END IF;

    -----------------------------*------------------------
    a_idx                       := create_apartment_kais.apart_idx;

    SELECT apart_id
      INTO a_id
      FROM apartment
     WHERE     apartment.building_id = create_apartment_kais.build_id
           AND apartment.apartment_num = create_apartment_kais.apart_num
           AND NVL (apartment.apartment_idx, ' ') = NVL (create_apartment_kais.a_idx, ' ')
           AND version = 0
           AND ROWNUM = 1;

    nn                          := copy_apartment (a_id);
    a_id                        := nn;
    create_apartment_kais.apart_id   := a_id;
    create_apartment_kais.code       := 1;
    create_apartment_kais.apart_id   := change_apart_from_bti_kais (a_id, iscommit);

    -- Исправление параметров квартиры по БТИ

    UPDATE apartment
       SET version   = -1
     WHERE apartment.apart_id = a_id;

    deb_ug (1, 'Create_Apartment ', 'Apart_Id =' || TO_CHAR (apart_id) || 'SN4=' || TO_CHAR (new_build_code) || ' USER=' || USER, 1, user_id);
    kurs3_var.global_action     := 'END CREATE APARTMENT ' || apart_id;
    registration_1;
    RETURN;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        SELECT apart_id
          INTO a_id
          FROM apartment
         WHERE     apartment.building_id = create_apartment_kais.build_id
               AND apartment.apartment_num = create_apartment_kais.apart_num
               AND NVL (apartment.apartment_idx, ' ') = NVL (create_apartment_kais.a_idx, ' ')
               AND ROWNUM = 1;

        nn                          := copy_apartment (a_id);
        a_id                        := nn;
        create_apartment_kais.apart_id   := a_id;
        create_apartment_kais.code       := 1;
        create_apartment_kais.apart_id   := change_apart_from_bti_kais (a_id, iscommit);

        -- Исправление параметров квартиры по БТИ

        --                      Исправление номера версии
        UPDATE apartment
           SET version   = -1
         WHERE apartment.apart_id = a_id;

        deb_ug (1, 'Create_Apartment_kais ', 'Apart_Id =' || TO_CHAR (apart_id) || 'SN5=' || TO_CHAR (new_build_code), 1, user_id);
        kurs3_var.global_action     := 'END CREATE APARTMENT ' || apart_id;
        registration_1;
        RETURN;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          SELECT seq_apartment.NEXTVAL INTO a_id FROM DUAL;

          INSERT INTO apartment (apart_id, building_id, apartment_num, apartment_idx, room_count, version, last_change
                                )
          VALUES (a_id, build_id, apart_num, a_idx, 0, -1, SYSDATE);

          create_apartment_kais.apart_id   := a_id;
          create_apartment_kais.code       := 4;
          create_apartment_kais.apart_id   := change_apart_from_bti_kais (a_id, iscommit);

          -- Исправление параметров квартиры по БТИ

          UPDATE apartment
             SET last_change   = SYSDATE -- Для простановки параметров по БТИ
           WHERE apartment.apart_id = create_apartment_kais.apart_id;

          deb_ug (1, 'Create_Apartment_kais', 'Apart_Id =' || TO_CHAR (apart_id) || 'SN6=' || TO_CHAR (new_build_code), 1, user_id);
          kurs3_var.global_action     := 'END CREATE APARTMENT ' || apart_id;
          registration_1;
          RETURN;
      END;
  END create_apartment_kais;
                           
  
  
--20.03.2013 ilonis
  FUNCTION change_apart_from_bti_kais (ap_id IN NUMBER, isCommit Number:=0)
    RETURN NUMBER AS
    --
    --  26.07.1999             Исправлена нумерация комнат
    --  02.08.1999             Добавлена проверка на отсутствие комнаты в БТИ
    --  29.02.2000             Исправлено соединение с квартирами
    --  06.09.2000             Исправлено заполнение общей площади
    --  24.08.2001             Исправлен FREE_CPACE
    --  14.11.2010  BlackHawk  Добавил order_by при инсерте комнат из БТИ;
    --                         вставка комнат из БТИ при любых случаях переноса данных из БТИ;
    --                         перенес функцию в пакет pkg_apartment
    --

    nn       NUMBER;
    u_nom    NUMBER;
    u_nkv    NUMBER;
    a_kmn    NUMBER;
    a_sqi    NUMBER;
    a_sqo    NUMBER;
    a_sqk    NUMBER;
    a_et     NUMBER;
    a_balc   NUMBER;
    a_lav    NUMBER;
    b_kmn    NUMBER;
    b_sqi    NUMBER;
    b_sqo    NUMBER;
    b_sqk    NUMBER;
    b_lav    NUMBER;
    b_et     NUMBER;
    ap1_id   NUMBER;
    b_id     NUMBER;
    n1       NUMBER;
    sun_unom NUMBER;

    CURSOR cur_rooms IS
      SELECT *
        FROM bti.rooms
       WHERE rooms.unom = u_nom AND rooms.unkv = u_nkv;
  BEGIN
    SELECT COUNT (*)
      INTO nn
      FROM apartment, bti.appart_bti
     WHERE     apartment.building_id = appart_bti.building_id
           AND apartment.apart_id = ap_id
           AND apartment.apartment_num = appart_bti.kv
           AND NVL (apartment.apartment_idx, ' ') = NVL (appart_bti.kvi, ' ');

    deb_ug (1, 'Change_BTI ', 'Apart_Id =' || TO_CHAR (ap_id), 1, nn);

    IF nn = 0 THEN -- Не найдена квартира в БТИ
      BEGIN
        SELECT bti_unom
          INTO sun_unom
          FROM building, apartment
         WHERE building.building_id = apartment.building_id AND apartment.apart_id = ap_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RETURN ap_id;
      END;

      SELECT COUNT (*)
        INTO n1
        FROM apartment, bti.appart_bti, bti.building_bti
       WHERE     apartment.apart_id = ap_id
             AND apartment.apartment_num = appart_bti.kv
             AND NVL (apartment.apartment_idx, ' ') = NVL (appart_bti.kvi, ' ')
             AND appart_bti.unom = building_bti.unom
             AND building_bti.sun = sun_unom;

      IF n1 = 1 THEN -- Одна квартира
        SELECT appart_bti.unom, appart_bti.unkv, apartment.building_id
          INTO u_nom, u_nkv, b_id
          FROM apartment, bti.appart_bti, bti.building_bti
         WHERE     building_bti.unom = appart_bti.unom
               AND apartment.apart_id = ap_id
               AND apartment.apartment_num = appart_bti.kv
               AND NVL (apartment.apartment_idx, ' ') = NVL (appart_bti.kvi, ' ')
               AND building_bti.sun = sun_unom;
      ELSIF n1 > 1 THEN -- Несколько одинаковых квартир в БТИ
        RETURN ap_id;
      ELSE
        -- Не найдена квартира в БТИ
        RETURN ap_id;
      END IF;
    ELSIF nn > 1 THEN -- Несколько одинаковых квартир в БТИ
      RETURN ap_id;
    ELSE -- Квартира найдена в БТИ
      SELECT unom, unkv, apartment.building_id
        INTO u_nom, u_nkv, b_id
        FROM apartment, bti.appart_bti
       WHERE     apartment.building_id = appart_bti.building_id
             AND apartment.apart_id = ap_id
             AND apartment.apartment_num = appart_bti.kv
             AND NVL (apartment.apartment_idx, ' ') = NVL (appart_bti.kvi, ' ');
    END IF;

    BEGIN
      SELECT room_count, living_space, --total_space,
                                      p_space, kitchen_space, storey, balcony
        INTO a_kmn, a_sqi, a_sqo, a_sqk, a_et, a_balc
        FROM bti.v_apart_bti_1
       WHERE unom = u_nom AND unkv = u_nkv;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN -- Не найдена квартира в БТИ
        RETURN ap_id;
    END;

    SELECT room_count, living_space, total_space, kitchen_space, room_storey_num, lavatory
      INTO b_kmn, b_sqi, b_sqo, b_sqk, b_et, b_lav
      FROM apartment
     WHERE apart_id = ap_id;

    a_lav   := get_lavatory_room (u_nom, u_nkv);

    --
    --       Вставить проверку комнат
    --
    SELECT COUNT (*)
      INTO nn
      FROM apartment, room, bti.building_bti, bti.rooms
     WHERE     apartment.apart_id = ap_id
           AND apartment.apart_id = room.apart_id
           AND apartment.building_id = building_bti.building_id
           AND rooms.unom = building_bti.unom
           AND rooms.unkv = get_bti_by_apart (apartment.apart_id)
           AND rooms.km = room.room_num
           AND rooms.opl = room.room_space
           AND rooms.nz IN (1, 2, 3, 11, 12, 84, 85); -- только жилые комнаты

    deb_ug (1, 'Change_BTI ', 'Rooms Apart_Id =' || TO_CHAR (ap_id), 1, nn);

    IF a_kmn = b_kmn AND a_sqi = b_sqi AND a_sqo = b_sqo AND a_sqk = b_sqk AND a_et = b_et AND nn = a_kmn THEN -- комнаты одинаковы
      UPDATE apartment
         SET status_bti   = 1
       WHERE apart_id = ap_id;

      deb_ug (1, 'Change_BTI OK', 'Update Apart_Id =' || TO_CHAR (ap_id), 1, nn);
      RETURN ap_id;
    ELSE
      IF get_apart_documents (ap_id) = 0 THEN -- документов по квартире нет
        UPDATE apartment
           SET room_count = a_kmn, living_space = a_sqi, total_space = a_sqo, kitchen_space = a_sqk, room_storey_num = a_et, balcony = a_balc
              ,lavatory = a_lav, status_bti = 1
         WHERE apart_id = ap_id;

        deb_ug (1, 'Change_BTI ', 'Update_NO_DOC Apart_Id =' || TO_CHAR (ap_id), 1, nn);

        -- комнаты переносим из БТИ
        DELETE FROM room
         WHERE apart_id = ap_id;

        INSERT INTO room (apart_id, building_id, room_num, characteristic, room_space, balcony, private, last_change, free_space_id
                         )
          SELECT ap_id, b_id, ROWNUM AS km, room_char_bti_to_kurs (nz), opl, get_balcony_room_1 (unom, unkv, km), NULL, SYSDATE, 0
            FROM bti.rooms rooms
           WHERE unom = u_nom AND unkv = u_nkv AND rooms.nz IN (1, 2, 3, 11, 12, 84, 85) -- только жилые комнаты
          ORDER BY rooms.km, rooms.kmi;
                
        if (isCommit>0) then --20.03.2013 ilonis  
        COMMIT; -- фиксация
        end if;
        
        RETURN ap_id;
      ELSE -- документы по квартире есть
        SELECT seq_apartment.NEXTVAL INTO ap1_id FROM DUAL;

        deb_ug (1, 'Change_BTI ', 'UPDATE_DOCS Apart_Id =' || TO_CHAR (ap1_id), 1, nn);

        INSERT INTO apartment (building_id, apart_id, apartment_num, apartment_idx, space_type, room_count, living_space, total_space
                     ,room_storey_num, kitchen_space, lavatory, balcony, new_building_code, good_for_living, phone_presence, document_date
                     ,condition, last_change, status_bti, version, vs_id, private
                              )
          SELECT apa.building_id, ap1_id, apa.apartment_num, apa.apartment_idx, apa.space_type, a_kmn, a_sqi, a_sqo, a_et
                ,a_sqk, a_lav, a_balc, apa.new_building_code, apa.good_for_living, apa.phone_presence, apa.document_date, apa.condition, SYSDATE
                ,1 AS status_bti, -1 /* временная версия */
                                    AS version, apa.vs_id, apa.private
            FROM apartment apa
           WHERE apart_id = ap_id;

        UPDATE apartment
           SET version   = -2
         WHERE apart_id = ap_id;

        -- комнаты переносим из БТИ
        INSERT INTO room (apart_id, building_id, room_num, characteristic, room_space, balcony, private, last_change, free_space_id
                         )
          SELECT ap1_id, b_id, ROWNUM AS km, room_char_bti_to_kurs (nz), opl, get_balcony_room_1 (unom, unkv, km) balc, NULL, SYSDATE, 0
            FROM bti.rooms rooms
           WHERE unom = u_nom AND unkv = u_nkv AND rooms.nz IN (1, 2, 3, 11, 12, 84, 85) -- только жилые комнаты
          ORDER BY rooms.km, rooms.kmi;
        --20.03.2013 ilonis  
        if (isCommit>0) then
            COMMIT; -- фиксация
         end if;
        
        RETURN ap1_id;
      END IF;
    END IF;
  END change_apart_from_bti_kais;    
  
  
   --11.12.2012 ilonis процедура обновляет поля unom_bti   и unkv_bti в таблице  Apartment по данным БТИ 
PROCEDURE Set_Apartment_Unom_Unkv( apart_id_ number, unom_ out number, unkv_ out number, isCommit number:=0 )
AS 
BEGIN
     unkv_ := get_BTI_by_apart_1( apart_id_ ,  unom_);  
    IF (NVL(unom_,0)=0) or (NVL(unkv_,0)=0)  THEN  
        unom_ := 0;
        unkv_  := 0;
   else
        update apartment set unom_bti = unom_, unkv_bti = unkv_ where apart_id = apart_id_ ;
        if (isCommit>0) then
            COMMIT;
        end if;  
   END IF;      
     
END Set_Apartment_Unom_Unkv; 


/**********************************************  
#26.08.2013 Dik                
Процедуры формы, пакетные процедуры для работы с информацией о причинах не заключения договоров                                            
******************************************************************************/ 
 
--  Процедура получения справочника причины не заключения договоров  
procedure get_sprav_lists ( p_list_param in number, p_cur in out  cursor_type)
  as 
  p_classifier_num CLASSIFIER_KURS3.CLASSIFIER_NUM%type:=0;
begin
  case NVL(p_list_param,-1)
       when 0 then p_classifier_num := с_classifier_ReasonsNSAgr;
     else          
       OPEN p_cur FOR 
             SELECT NULL as ID, NULL as TITLE , с_DelCode as DelCode from dual;  
     return;           
  end case;
          
 OPEN p_cur FOR 
  select t.ROW_NUM as ID ,t.NAME as TITLE, с_DelCode as DelCode 
  from CLASSIFIER_KURS3 t
  where t.classifier_num = p_classifier_num
  order by t.ROW_NUM  ;
   
end  get_sprav_lists; 

--  Процедура получения данных о причине не заключения договоров  
--  возвращает курсор p_cur
procedure get_ReasonNSAgr (p_apart_id IN NUMBER, p_cur in out  cursor_type) 
as
 c number :=0;
begin
  SELECT count(*) into c
  FROM apartment a
  where a.apart_id=p_apart_id;
  if c>0 then
   OPEN p_cur FOR 
             SELECT a.cause_nd, a.comment_causeof_nd
             FROM apartment a
             where a.apart_id=p_apart_id;
   else
      OPEN p_cur FOR  
      SELECT NULL as cause_nd, NULL as comment_causeof_nd
      FROM DUAL;
  end if;     
       
END get_ReasonNSAgr;
--  Процедура изменения (удаления) данных о причине не заключения договоров при одном apart_id
procedure UpdDel_ReasonNSAgr (p_apart_id IN NUMBER, p_cause_nd in NUMBER, p_comment_causeof_nd in varchar2) 
as  
begin   
if p_cause_nd = с_DelCode --удаление
then
  update apartment a 
  set a.cause_nd=NULL,
      a.comment_causeof_nd = NULL,
      a.date_causeof_nd = Null
  where a.apart_id =  p_apart_id;   
else
    update apartment a 
  set a.cause_nd=p_cause_nd,
      a.comment_causeof_nd = p_comment_causeof_nd,
      a.date_causeof_nd = Trunc(sysdate)
  where a.apart_id =  p_apart_id; 
end if; 
 commit; 
END UpdDel_ReasonNSAgr;

/*  Процедура тестирует возможность проведения групповой операции
  изменения (удаления) данных о причине не заключения договоров 
 Резултат: code = -1 - Одно или несколько из выбранных жилых помещений находятся в состоянии отличном от "Заселено"!
           code = 0  - список с одинаковыми данными => 
                     pReasonsNSAgrId=код причины; pReasonsNSAgrTxt= комментарии
           code = 1 Выбранные жилые помещения имеют различающуюся информацию о причинах не заключения договоров
*/              
procedure ReasonsNSAgrListTest(list_code IN NUMBER,plist_num IN NUMBER, pReasonsNSAgrId IN OUT NUMBER, pReasonsNSAgrTxt IN OUT varchar2, code IN OUT NUMBER)
as
 coun_all_sel number :=0;
 tmp_count    number :=0;
 S classifier_kurs3.name%type := NULL;
 u number :=-1;
begin
  u := kurs3_var.get_user_id_f ; 
  code := -1;  
  pReasonsNSAgrId := -1;
  pReasonsNSAgrTxt:= NULL;

  select count(*)  into coun_all_sel 
  from   V_HOUSING_LIST vh
  where 
        vh.list_cod = list_code
    and vh.list_num=plist_num
    and vh.user_id=u
    and vh.note=1;   
   
if coun_all_sel < 1 then
  return ;
end if;  
  select count(*) into tmp_count 
  from   V_HOUSING_LIST vh, cl_s
  where 
        vh.list_cod = list_code
    and vh.list_num=plist_num
    and vh.user_id=u
    and vh.note=1
    and cl_s.row_num = 4 --заселена   
    and upper(trim(NVL(vh.condition,' '))) = upper(trim(cl_s.name));
if (coun_all_sel<>tmp_count) then
  return ;
end if; 

  select NVL(v.cause_nd,' '), NVL(v.comment_causeof_nd,' '), v.c  into S, pReasonsNSAgrTxt , tmp_count
  from (
  select NVL(vh.cause_nd,' ') as cause_nd, NVL(vh.comment_causeof_nd,' ') as comment_causeof_nd, count(*) as c
  from   V_HOUSING_LIST vh
  where vh.list_cod = list_code
    and vh.list_num = plist_num
    and vh.user_id  = u
    and vh.note=1
  group by NVL(vh.cause_nd,' '), NVL(vh.comment_causeof_nd,' ')  
    ) v
  where rownum = 1;
if tmp_count= coun_all_sel then
  begin
  code := 0;
  if pReasonsNSAgrTxt = ' ' then pReasonsNSAgrTxt:=NULL; end if;
  if S <> ' ' then 
    begin   
        select cl.row_num into pReasonsNSAgrId  
        from classifier_kurs3 cl
        where cl.name=S 
        and   cl.classifier_num = с_classifier_ReasonsNSAgr
        and   rownum = 1 ;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN  pReasonsNSAgrId := -1;
       pReasonsNSAgrId := NVL(pReasonsNSAgrId,-1);  
    end;
   end if;
   end;
else
  code := 1;
end if;
     
end ReasonsNSAgrListTest;
/*  Процедура групповой операции изменения (удаления) данных о причине не заключения договоров 
 Резултат: code = -1 - Err
           code = 0  - Ok
*/              
procedure update_list_ReasonsNSAgr(list_code IN NUMBER,plist_num IN NUMBER, 
                                   pReasonsNSAgrId IN apartment.cause_nd%type, pReasonsNSAgrTxt IN apartment.comment_causeof_nd%type, 
                                   code IN OUT NUMBER)
as
 u number :=-1;
begin
 code := -1; 
 u := kurs3_var.get_user_id_f ; 
 if pReasonsNSAgrId = с_DelCode --удаление
then
  update apartment a 
  set a.cause_nd=NULL,
      a.comment_causeof_nd = NULL,
      a.date_causeof_nd = Null
  where a.apart_id in 
  ( select vh.apart_id 
  from   V_HOUSING_LIST vh
  where 
        vh.list_cod = list_code
    and vh.list_num=plist_num
    and vh.user_id=u
    and vh.note=1   
  )  ; 
else
  update apartment a 
  set a.cause_nd=pReasonsNSAgrId,
      a.comment_causeof_nd = pReasonsNSAgrTxt,
      a.date_causeof_nd = Trunc(sysdate)
  where a.apart_id in 
  ( select vh.apart_id 
  from   V_HOUSING_LIST vh
  where 
        vh.list_cod = list_code
    and vh.list_num=plist_num
    and vh.user_id=u
    and vh.note=1   
  );   
end if; 
 commit;
 code := 0; 
 EXCEPTION
         WHEN OTHERS THEN begin rollback; code := -1; end;
           
end update_list_ReasonsNSAgr;

--Вернуть константу - Код справочника  Причины не заключения договоров   (146) 
function get_R_NSAgr RETURN NUMBER
AS
begin   
 return (с_classifier_ReasonsNSAgr);
end get_R_NSAgr;

-- / #26.08.2013 Dik  
  
END pkg_apartment;
/
