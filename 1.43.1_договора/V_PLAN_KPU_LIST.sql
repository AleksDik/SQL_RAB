CREATE OR REPLACE VIEW V_PLAN_KPU_LIST
(okrug_id, affair_id, name, affair_num, reg_person_cnt, id, occupy_num, sqi, sqo, plan_year, last_change, stand_year, affair_num_1, sq_type, inspector, reason, family_type, room_count, total_space, sqo_p, sqi_p, sstatus, storey_b, storey, birthday, decision_date, user_id, list_cod, list_num, address, last_name, last_name_1, family_num, family_num_1, sq_type_1, status, note, category, condition, registration_date, read_only, reason2_name, remark, factory, status_bti, family_cnt, street_name, building_num, building_idx, house_num, house_idx, construction_num, construction_idx, apartment_num, creation_date, person_cnt, change_date, prioritet, prioritet_year, plan_type, plan_year_1, plan_first_year, creation_date_1, plan_errors, last_year_plan, direct_date, direct_num, provide, exclusion, pgo, affair_stage, family_status, opd, exclusion_num, exclusion_date, deliver46, young_fam, young_anketa_str, young_anketa_date, order_num, order_date, fio_lgonta, name_2, name_3, e_reason, pr_fakt, ord_date, affair_permitions, f_budget, calculation_date, num_order, ser_order, year_realiz, decl_date, order_addr, order_km_cnt, order_tot_space, order_cancel_date, sub_rs, reason2_num, reason2_date, decl_cp_date, order_res_num, order_res_date, order_reason, agreedate, queue_num, notes)
AS
SELECT affair.okrug_id
        ,affair_plan.affair_plan_id
        ,area.short_name3
        , --
          --  29.07.1999             Добавлены поля
          --  04.08.1999             Исправлен тип даты рождения
          --  11.08.1999             Исправлен тип поля РЕШЕНИЕ и ЭТАЖИ
          --  16.08.1999             Добавлены проверки против деления на ноль
          --  19.08.1999             Добавлено поле даты перерегистрации
          --  10.02.2000             Добавлена причина снятия
          --  17.02.2000             Добавлено примечание
          --  03.05.2000             Добавлен полный номер
          --  03.05.2000             Добавлена организация
          --  03.05.2000             Добавлено состояние по БТИ
          --  03.05.2000             Добавлено количество элементарных семей
          --  11.07.2000             Добавлена дата создания
          --  17.11.2000             Добавлены ошибки в КПУ
          --  04.12.2000             Добавлена проверка на состояние плана
          --  04.12.2000             Добавлен признак из плана прошлого года
          --  22.12.2000             Добавлена колонка FAMILY_NUM_1
          --  26.02.2001             Добавлены колонки дата и номер распоряжения
          --  05.04.2001             Обеспечение
          --  09.04.2001             Изменен вывод вида плана при AFFAIR_STAGE<>1
          --  12.04.2001             Добавлено исключение
          --  10.05.2001             Исправлена стадия дела при требовании
          --  16.08.2001  PVTar      Добавил Affair_Stage
          --  06.09.2001             Исправлена ошибка в ограничениях по AFFAIR_STAGE
          --  21.11.2001             Добавлена колонка по состоянию семьи
          --  07.12.2001             Добавлена колонка обеспечено по проектным документам
          --  29.01.2002  PVTar      Добавлены колонки - EXCLUSION_NUM, EXCLUSION_DATE
          --  22.03.2002  PVTar      Добавил поле DELIVER46
          --  11.04.2002  PVTar      Добавил поле 'молодая семья'
          --  25.11.2002  PVTar      Добавил поле 'варианты ответов из анкеты по молодой семье'
          --  05.12.2002  PVTar      переделал под новое поле FAMILY_type
          --  19.12.2002  PVTar      Переделан под новый вызов функции get_space_type_affair_sh
          --  04.01.2003  PVTar      переделал вывод JGL
          --  16.07.2003  frolov     Добавил поле "дата заполнения анкеты для молодой семьи"
          --  13.05.2004             Добавлены поля Т выписки и дата выписки
          --  2008.02.04  BlackHawk  Поставил на некоторые поля ограничения в виде substr (YOUNG_ANKETA_STR,FIO_LGONTA,AFFAIR_PERMITIONS,F_BUDGET)
          --  2008.02.14  BlackHawk  Поменял неправильно вызываемую функцию to_date вместо to_char lkz полей ord_date и calculation_date
          --                         Отформатировал вывод полей change_date,creation_date,creation_date_1
          --  23.04.2008  Lvova      Добавлено поле "год реализации площади" при передачи ее в МГЦАЖ
          --  14.10.2009  BlackHawk  Добавил поле DECL_DATE
          --  07.07.2010  BlackHawk  Добавил order_addr, order_km_cnt, order_tot_space, order_cancel_date
          --  16.12.2010  BlackHawk  Добавил поля sub_rs, reason2_num, reason2_date
          --  27.06.2011  BlackHawk  Добавил поле decl_cp_date
          --  14.02.2012  BlackHawk  Добавил поля order_res_num и order_res_date
          --  11.03.2012  Anissimova Добавила поле "причина аннулирования выписки" order_reason
          --  25.04.2012  AVB        Добавил поле "Дата учета подписанного договора" agreedate
          --  07.02.2013  ONovikova  Добавила поля: Номер очереди Queue_NUM, Заметки Notes
          -- #06.03.2013Dik Изменил логику подавления "0"  в affair_plan.opd (OPD) для отображения affair_plan.opd как NUMBER
          --
          --to_char(Affair.stand_year,'0000')||'-'||to_char(Delo_Num,'00000'),
          --substr(get_affair_num_1(Affair.STAND_YEAR,Affair.Delo_Num),1,200),
          
         SUBSTR (get_affair_num_4 (affair.affair_id), 1, 50)
        ,affair.reg_person_cnt
        ,affair.affair_id
        ,affair.occupy_num
        ,DECODE (affair.sqi, 0, ' ', TO_CHAR (affair.sqi, '99999.9'))
        ,DECODE (affair.sqo * affair.sqi
                ,0, ' '
                ,TO_CHAR (DECODE (get_apart_liv (affair.apart_id), 0, 0, affair.sqo * affair.sqi / get_apart_liv (affair.apart_id)), '99999.9')
                )
        ,DECODE (TO_CHAR (affair.plan_year), '0', ' ', TO_CHAR (affair.plan_year))
        ,affair.last_change
        ,affair.stand_year
        ,affair.delo_num / 10
        ,SUBSTR (get_space_type_affair_sh (affair.affair_id, affair.affair_stage), 1, 3)
        ,SUBSTR (get_inspector (affair.inspector), 1, 60)
        ,SUBSTR (get_reason_sh3 (affair.reason), 1, 60)
        ,SUBSTR (get_type2_sh3 (affair_plan.family_type), 1, 60)
        ,TO_CHAR (get_apart_room_cnt (affair.apart_id))
        ,TO_CHAR (get_apart_tot (affair.apart_id), '99999.9')
        ,DECODE (
           affair.person_in_family * affair.sqo * affair.sqi
          ,0, ' '
          ,TO_CHAR (
             DECODE (get_apart_liv (affair.apart_id), 0, 0, affair.sqo * affair.sqi / (get_apart_liv (affair.apart_id) * affair.person_in_family))
            ,'99999.9'
           )
         )
        ,DECODE (affair.person_in_family * affair.sqi, 0, ' ', TO_CHAR (affair.sqi / affair.person_in_family, '99999.9'))
        ,SUBSTR (get_affair_sstatus (affair.sstatus), 1, 20)
        , --SUBSTR(to_char(GET_STOREY_BUILD(affair.BUILD_ID)),1,4),
          --SUBSTR(to_char(GET_STOREY_APART(affair.APART_ID)),1,4),
         get_storey_build (affair.build_id)
        ,get_storey_apart (affair.apart_id)
        , --SUBSTR(
         get_person1_birthday (affair.affair_id)
        , --1,20),
         TO_DATE (TO_CHAR (affair.delo_date, 'DD.MM.YYYY'), 'DD.MM.YYYY') AS decision_date
        ,plan_kpu_list.user_id
        ,plan_kpu_list.list_cod
        ,plan_kpu_list.list_num
        ,SUBSTR (addr_apartment (affair.build_id, affair.apart_id), 1, 200)
        ,SUBSTR (get_person (affair_plan.person_id), 1, 200)
        ,SUBSTR (get_person1 (affair.affair_id), 1, 200)
        ,affair_plan.family_num
        ,affair_plan.family_num
        ,SUBSTR (get_family_type_2 (affair_plan.affair_id, affair_plan.family_num, affair_plan.affair_stage), 1, 200)
        , --substr(Get_classifier(36,affair_plan.TYPE),1,200),
         SUBSTR (get_affair_plan_status (affair_plan.status), 1, 200)
        ,plan_kpu_list.note
        ,SUBSTR (get_kateg_all_sh (affair.delo_category, affair.reason), 1, 200)
        ,SUBSTR (get_classifier_h2 (70, affair.status), 1, 200)
        ,affair.registration_date
        ,get_read_only (1, affair.affair_id)
        ,SUBSTR (get_reason2 (affair.reason2), 1, 200)
        ,affair.remark
        ,SUBSTR (get_factory_name_sh (affair.department_id, affair.factory_id), 1, 40)
        ,SUBSTR (get_status_bti_sh_1 (apartment.status_bti), 1, 70)
        ,get_affair_family_cnt (affair.affair_id, affair.affair_stage)
        ,street.full_name
        ,building.building_num
        ,building.building_idx
        ,building.house_num
        ,building.house_idx
        ,building.construction_num
        ,building.construction_idx
        ,apartment_num
        ,TO_CHAR (DECODE (affair.creation_date, NULL, affair.delo_date, affair.creation_date), 'dd.mm.yyyy') creation_date
        ,affair_plan.person_cnt
        ,TO_CHAR (affair_plan.change_date, 'dd.mm.yyyy') change_date
        ,SUBSTR (get_affair_plan_prioritet_sh (affair_plan.prioritet), 1, 200)
        ,affair_plan.prioritet_year
        ,SUBSTR (get_plan_kpu_type_1 (affair_plan.affair_id, affair_plan.family_num, affair_plan.affair_stage), 1, 200)
        ,affair_plan.plan_year
        ,affair_plan.plan_first_year
        ,TO_CHAR (affair_plan.creation_date, 'dd.mm.yyyy') creation_date_1
        ,REPLACE (REPLACE (SUBSTR (plan_errors, 2, LENGTH (plan_errors) - 2), '('), ')')
        ,DECODE (affair_plan.last_year_plan, 1, 'Да', 'Нет')
        ,affair_plan.direct_date
        ,affair_plan.direct_num
        ,SUBSTR (get_affair_plan_type2 (affair_plan.type2), 1, 200)
        ,DECODE (affair_plan.exclusion, 1, 'Да', 'Нет')
        ,affair_plan.pgo
        ,affair.affair_stage
        ,SUBSTR (get_affair_plan_order_type (affair_plan.affair_plan_id), 1, 20) family_status,
        -- #06032013Dik
        --  ,DECODE (affair_plan.opd,  0, NULL,  NULL, NULL,  affair_plan.opd) opd -- OLD
          CASE WHEN affair_plan.opd = 0 THEN NULL ELSE affair_plan.opd END AS opd                                           
        -- /#06032013Dik
        ,affair_plan.exclusion_num
        ,affair_plan.exclusion_date
        ,DECODE (NVL (affair_plan.deliver_affair_plan_id, 0), 0, NULL, DECODE (affair.delo_category, 31, 'Высв.', '46 cт.')) deliver46
        ,DECODE (test_affair_young_fam (affair_plan.affair_id, affair_plan.affair_stage, affair_plan.family_num)
                ,1, 'Есть'
                ,2, 'В сост.'
                ,'Нет'
                )
           young_fam
        ,SUBSTR (get_affair_plan_attr_str (affair_plan.affair_plan_id), 1, 50) young_anketa_str
        ,get_affair_plan_attr_date (affair_plan.affair_plan_id) young_anketa_date
        ,orders.order_num || ' ' || orders.ser order_num
        ,TO_CHAR (orders.order_date, 'dd.mm.yyyy') order_date
        ,SUBSTR (get_person_lgota (affair.affair_id, delo_category), 1, 42) AS fio_lgonta
        ,SUBSTR (get_person1_f (affair.affair_id), 1, 200) AS name_2
        ,SUBSTR (get_person1_p (affair.affair_id), 1, 200) AS name_3
        ,SUBSTR (get_reason_excl_text (affair_plan.change_reason), 1, 400) AS e_reason
        ,DECODE (get_apart_proekt_fakt (orders.order_id, orders.order_stage),  2, 'П+Ф',  1, 'П',  0, 'Ф',  '') AS pr_fakt
        ,TO_CHAR (NVL (NVL (orders.order_date, orders.resolution_date), orders.creation_date), 'dd.mm.yyyy') AS ord_date
        ,SUBSTR (get_affair_permit_chr (affair.affair_id, affair.affair_stage), 1, 100) affair_permitions
        ,SUBSTR (get_affair_categ_fb (affair.affair_id, affair.affair_stage, affair.stand_year, affair.delo_category), 1, 5) f_budget
        ,TO_CHAR (orders.calculation_date, 'dd.mm.yyyy') calculation_date
        ,orders.order_num AS num_order
        ,orders.ser AS ser_order
        ,get_order_year_realiz (get_order_freespace (orders.order_id), orders.order_id) AS year_realiz
        ,TO_CHAR (affair.decl_date, 'dd.mm.yyyy') decl_date
        ,SUBSTR (addr_apartmento_fmt (orders.order_id), 1, 200) AS order_addr
        ,get_order_room_cnt (orders.order_id) AS order_km_cnt
        ,TO_CHAR (orders.total_space, '99999.9') AS order_tot_space
        ,orders.cancel_date AS order_cancel_date
        ,TRIM (subsid.get_sub_params (affair.affair_id, 3)) AS sub_rs
        ,affair.reason2_num
        ,TRUNC (affair.reason2_date, 'dd') AS reason2_date
        ,get_affair_plan_decl_cp_date (affair_plan.affair_plan_id) AS decl_cp_date
        ,orders.resolution_num AS order_res_num
        ,TO_CHAR (orders.resolution_date, 'dd.mm.yyyy') AS order_res_date
        ,SUBSTR (get_classifier_h2 (38, orders.reason), 1, 15) as order_reason
        ,get_order_agreement_date(orders.order_id, orders.SER, orders.agreement_date) AS agreedate
        ,Get_Affair_Queue_01_num(affair.affair_id) AS Queue_NUM
        ,affair.notes AS Notes
    FROM affair, area, plan_kpu_list, building, street, apartment, affair_plan, orders
   WHERE     affair.okrug_id = area.okrug_id
         AND affair_plan.affair_plan_id = plan_kpu_list.affair_id
         AND affair_plan.affair_id = affair.affair_id
         AND affair.affair_stage >= 1
         AND affair.affair_stage = affair_plan.affair_stage
         AND building.street = street.street_id
         AND affair.build_id = building.building_id
         AND affair.apart_id = apartment.apart_id
         AND affair_plan.status IS NOT NULL
         AND affair_plan.affair_plan_id = orders.affair_plan_id(+)
         AND orders.affair_stage(+) = get_order_max_affair_stage (affair_plan.affair_plan_id)
--     AND affair_plan.affair_stage = orders.affair_stage(+)
--person_relation_delo.AFFAIR_ID=affair.AFFAIR_ID and
--person_relation_delo.AFFAIR_STAGE=1
--and person_relation_delo.FAMILY_NUM=affair_plan.FAMILY_NUM
-- grant select on v_plan_kpu_list to okrug;;;
