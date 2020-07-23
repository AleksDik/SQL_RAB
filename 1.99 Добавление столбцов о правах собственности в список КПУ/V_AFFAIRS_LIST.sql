CREATE OR REPLACE VIEW V_AFFAIRS_LIST
(okrug_id, affair_id, a_id, a_st, decision_num, name, affair_num, reg_person_cnt, occupy_num, sqi, sqo, plan_year, last_change, stand_year, affair_num_1, sq_type, inspector, reason, type2, room_count, total_space, sqo_p, sqi_p, sstatus, storey_b, storey, birthday, decision_date, user_id, list_cod, list_num, address, last_name, note, category, condition, registration_date, read_only, reason2_name, remark, factory, status_bti, family_cnt, street_name, building_num, building_idx, house_num, house_idx, construction_num, construction_idx, apartment_num, creation_date, plan_errors, pgo, p8, deliver46, factory_status, reason2_date, min_year_categ, min_year_categ_1, min_categ, reason2_num, address_short, apart_num, mater, year_in_city, year_in_place, pers_in_kpu, put_date, get_date, affair_permitions, fio_lgonta, decl_date, order_num, order_ser, order_date, order_status, ars_famuly_count, ars_vid_obes, ars_nkp_sys, ars_all_cnt_person, ars_all_pzm, ars_all_zm, ars_all_notkpu, lg_family, lg_name, lg_fathername, lg_bdate, dszn_lg_cnt, dszn_lg_sovp, ob_fb, ob_dt, unom, calc_year, year_realiz, calc_reason, calc_change, type2_date, sublease_stay, sublease_cnt, fraud_invaddr, fraud_invname, fraud_ownaddr, bld_type, num_ggk_21, d_ggk_21, cottage_n, cottage_d, cottage_sq, cottage, no_adult_cnt, affair_notes, last_name_m, patronymic_m, pat_m, sub_num, sub_size_pc, sub_size_m, sub_rs, sub_z, sub_ra, sub_reas, sublease_addr, sublease_date, sublease_months, plan_type, invalid_carr, other_affair_open, other_affair_close, b_year, bti_b_gdpostr, queue_01_num, young_fam, order_res_num, order_res_date, lp_doc, lp_num, lp_date, agreedate, egd_last_request, egd_last_response, cottage_type, ufrs_rqst, ufrs_answ_last, ufrs_rqst_date, ufrs_answ_last_date, ufrs_rqst_count, ufrs_answ_count, ufrs_have_estate, sql, sqb, liv_sq, mancomp, dc_type_name, scan_check_info, tpg, opd, status, family_structure, count_reg_person, dereg_pvs_date, export_fam_date, uhud_zil_usl, reason_uhud_zil_usl, date_uhud_zil_usl, prim_uhud_zil_usl, problem_peres, prim_problem_peres, type_solution, date_solution,
ownership_rsgs, ownership_rsgs_date,  ownership_rsgs_date_to, ownership_egrp_num, ownership_egrp_date, ownership_egrp_date_to, requirements)
AS
SELECT affair.okrug_id,
          affair.affair_id,
          affair.affair_id,
          affair.affair_stage,
          affair.decision_num,
          area.short_name3,                                                  --
                                    --  29.07.1999              Добавлены поля
                       --  04.08.1999              Исправлен тип даты рождения
                --  11.08.1999              Исправлен тип поля РЕШЕНИЕ и ЭТАЖИ
         --  16.08.1999              Добавлены проверки против деления на ноль
               --  19.08.1999              Добавлено поле даты перерегистрации
                          --  10.02.2000              Добавлена причина снятия
                              --  17.02.2000              Добавлено примечание
                             --  03.05.2000              Добавлен полный номер
                             --  03.05.2000              Добавлена организация
                        --  03.05.2000              Добавлено состояние по БТИ
           --  03.05.2000              Добавлено количество элементарных семей
                           --  11.07.2000              Добавлена дата создания
                            --  17.11.2000              Добавлены ошибки в КПУ
                      --  31.07.2001              Добавлен список архивных дел
                             --  11.10.2001              Добавлена колонка ПГО
                              --  09.11.2001              Добавлена колонка P8
                    --  22.03.2002              Добавил поле DELIVER46 (PVTar)
               --  11.04.2002              Добавил поле FACTORY_STATUS (PVTar)
                 --  24.01.2003              Переделал поле affair_num (PVTar)
 --  11.07.2003              Добавлены поля MIN_YEAR_CATEG, MIN_YEAR_CATEG_1 и MIN_CATEG
                     --  2004.08.09              Добавлено поле Дата заявления
              --  2004.08.31              Добавлены поля Order_Num, Order_Date
             --  2004.09.30              Добавлены поля фамилия имя и отчество
                  --  10.12.2004  utk         Добавлено поле кол-во льгот ДСЗН
                                 --  01.10.2007  BlackHawk   Добавил поле UNOM
 --  04.02.2008  BlackHawk   Поставил на некоторые поля ограничения в виде substr (MIN_CATEG,MATER,AFFAIR_PERMITIONS,FIO_LGONTA,
 --                          ORDER_NUM,ARS_VID_OBES,ARS_NKP_SYS,ARS_ALL_CNT_PERSON,ARS_ALL_PZM,ARS_ALL_ZM,ARS_ALL_NOTKPU)
 --  23.04.2008  Lvova       Добавлено поле "год реализации площади" при передачи ее в МГЦАЖ
 --  19.05.2008  Lvova       Добавлены поля "Причина измененич уч-пл года" и "Дата послед. изм. уч-пл года" (CALC_REASON, CALC_CHANGE)
 --  16.09.2008  Anissimova  Добавлено поле type2_date - дата установки вида обеспечения для 21 направления учета
 --  12.11.2008  BlackHawk   Добавил поле sublease_stay - признак нахождение КПУ в программе "компенсации за поднайм"
 --                          Добавил поле sublease_cnt - кол-во нахождений КПУ в программе "компенсации за поднайм"
            --  01.12.2008  BlackHawk   Добавил поля по "обманутым вкладчикам"
                         --  13.02.2009  AVL         Добавил поле Тип строения
         --  10.02.2009  Anissimova  Добавлены поля "№_ГЖК_21" и "Дата_ГЖК_21"
 --  17.02.2009  Jarikov     Добавлены поля "Согл/Отказ" и "Дата Согл/Отказа" в коттедже
            --  03.03.2009  AVL         Добавил поле Коттедж для гор. программ
                       --  13.07.2009  BlackHawk   Добавлено поле no_adult_cnt
                       --  20.07.2009  BlackHawk   Добавлено поле affair_notes
 --  11.12.2009  AVL         Поменял вывод поля "коттедж" по письму УИТ-1179/2009
 --  12.01.2010  Lvova       Изменила получение поля order_num, исп. ф-цию get_order_num_2(orders.order_id,'NS'),
 --                          где order_id = get_number_order (affair.affair_id, affair.affair_stage)
 --  03.02.2010  Anissimova  Добавлены поля last_name_m, pat_m, patronymic_m (фамилия, имя, отчество заявителя)
 --  05.07.2010  BlackHawk   Добавил поле sublease_addr, sublease_date, sublease_months
                               --  16.02.2011  BlackHawk   Добавил поле b_year
                         --  01.07.2011  BlackHawk   Добавил поле order_status
                         --  06.07.2011  BlackHawk   Добавил поле queue_01_num
                          --  08.07.2011  BlackHawk   Убрал поле cottage_n_num
            --                          Добавил поле cottage_sq (УИТ-620/2010)
 --                          Переделал поля cottage_n и cottage (УИТ-620/2010)
       --  14.02.2012  BlackHawk   Добавил поля order_res_num и order_res_date
 --  03.05.2012  AVB         Добавил поле "Дата учета подписанного договора" agreedate
 --                          egd_last_request, egd_last_response - даты последнего запроса и ответа на получение ЕЖД
 --  30.05.2012 Ikonnikov    Изменён расчет общей и жилой площади с учетом проживающих на данной площадь граждан
 --  03.07.2012 AVB          Добавил информацию о количестве и датах запросов в УФРС и ответов на них ufrs_...
         --  20.10.2012  Gladkov     Добавлены поля: sql, sqb, liv_sq, mancomp
--12.12.2012 Ilonis добавил dc_type --тип документа ГЖК
--24.01.2013 / -- #D24.01.2013 / (Дикан) добавлено поле scan_check_info - Наличие электронного архива по заданному affair
-- 07.02.2013  ONovikova  Добавила поля: ТПГ (Текущий плановый год) TPG, № в списке обеспечения OPD, Состояние плана STATUS
-- #D25.03.2013 / (Дикан) Изменил способ формирования поля  plan_type (Вид плана) - новая функция - GET_PLAN_TYPE_QUEUE
-- #D14.06.2013 / (Дикан) Добавлены поля  «Состав семьи» (FAMILY_STRUCTURE) и Кол-во строк зарегистрировано на данной площади (COUNT_REG_PERSON)
-- #D20.06.2013 / (Дикан) Добавлены поля :
-- #D09.07.2013 / (Дикан) Добавлены поля инф. о правах собственности в списках КПУ 

          SUBSTR (get_affair_num_fmt (affair.affair_id, affair.affair_stage),
                  1,
                  40),
          affair.reg_person_cnt,
          affair.occupy_num,
          DECODE (affair.sqi, 0, ' ', TO_CHAR (affair.sqi, '99999.9')) /*,DECODE (affair.sqo * affair.sqi
                                                                               ,0, ' '
                                                                               ,TO_CHAR (DECODE (get_apart_liv (affair.apart_id), 0, 0, affair.sqo * affair.sqi / get_apart_liv (affair.apart_id)), '99999.9')
                                                                               )*/
                                                                      ,
          TRIM (TO_CHAR (affair.sqz, '99999.9')),
          DECODE (TO_CHAR (affair.plan_year),
                  '0', ' ',
                  TO_CHAR (affair.plan_year)),
          affair.last_change,
          affair.stand_year,
          affair.delo_num / 10,
          SUBSTR (
             get_space_type_affair_sh (affair.affair_id, affair.affair_stage),
             1,
             3),
          SUBSTR (get_inspector (affair.inspector), 1, 60),
          SUBSTR (get_reason_sh3 (affair.reason), 1, 60),
          SUBSTR (get_type2_sh3 (affair.type2), 1, 60),
          TO_CHAR (get_apart_room_cnt (affair.apart_id)),
          TO_CHAR (get_apart_tot (affair.apart_id), '99999.9'),
          DECODE (
               NVL (affair.person_in_family, 0)
             * NVL (affair.sqo, 0)
             * NVL (affair.sqi, 0),
             0, ' ',
             TO_CHAR (
                DECODE (
                   NVL (get_apart_liv (affair.apart_id), 0)
                   * NVL (
                        get_person_reg_cnt_all (affair.affair_id,
                                                affair.affair_stage),
                        0),
                   0, 0,
                   NVL (affair.sqo, 0) * NVL (affair.sqi, 0)
                   / (NVL (get_apart_liv (affair.apart_id), 0)
                      * NVL (
                           get_person_reg_cnt_all (affair.affair_id,
                                                   affair.affair_stage),
                           0))),
                '99999.9'))
             AS sqo_p,
          DECODE (
             NVL (affair.person_in_family, 0) * NVL (affair.sqi, 0),
             0, ' ',
             TO_CHAR (
                DECODE (
                   NVL (
                      get_person_reg_cnt_all (affair.affair_id,
                                              affair.affair_stage),
                      0),
                   0, 0,
                   NVL (affair.sqi, 0)
                   / NVL (
                        get_person_reg_cnt_all (affair.affair_id,
                                                affair.affair_stage),
                        0)),
                '99999.9'))
             AS sqi_p,
          SUBSTR (get_affair_sstatus (affair.sstatus), 1, 20), --SUBSTR(to_char(GET_STOREY_BUILD(affair.BUILD_ID)),1,4),
          --SUBSTR(to_char(GET_STOREY_APART(affair.APART_ID)),1,4),
          get_storey_build (affair.build_id),
          get_storey_apart (affair.apart_id),                        --SUBSTR(
          get_person1_birthday (affair.affair_id),                    --1,20),
          TO_DATE (TO_CHAR (affair.delo_date, 'DD.MM.YYYY'), 'DD.MM.YYYY'),
          affairs_list.user_id,
          affairs_list.list_cod,
          affairs_list.list_num,
          SUBSTR (addr_apartment (affair.build_id, affair.apart_id), 1, 200),
          SUBSTR (get_person1 (affair.affair_id), 1, 200) AS last_name,
          affairs_list.note,
          SUBSTR (get_kateg_all (affair.delo_category, affair.reason),
                  1,
                  200),
          SUBSTR (get_classifier_h2 (70, affair.status), 1, 200),
          affair.registration_date,
          get_read_only (1, affair.affair_id),
          SUBSTR (get_reason2 (affair.reason2), 1, 200),
          affair.remark,
          SUBSTR (
             get_factory_name_sh (affair.department_id, affair.factory_id),
             1,
             40),
          SUBSTR (get_status_bti_sh_1 (apartment.status_bti), 1, 70),
          get_affair_family_cnt (affair.affair_id),
          street.full_name,
          building.building_num,
          building.building_idx,
          building.house_num,
          building.house_idx,
          building.construction_num,
          building.construction_idx,
          apartment_num,
          DECODE (affair.creation_date,
                  NULL, affair.delo_date,
                  affair.creation_date),
          REPLACE (
             REPLACE (SUBSTR (plan_errors, 2, LENGTH (plan_errors) - 2), '('),
             ')'),
          get_affair_pgo (affair.affair_id, affair.affair_stage) pgo,
          get_factory_p8 (affair.department_id, affair.factory_id) p8,
          DECODE (
             get_affair_46deliver (affair.affair_id, affair.affair_stage),
             1, '46 cт.',
             2, 'Высв.',
             NULL)
             deliver46,
          get_factory_status (affair.department_id, affair.factory_id)
             factory_status,
          TRUNC (affair.reason2_date, 'dd') reason2_date,
          get_affair_categ_min_year_all (affair.affair_id,
                                         affair.affair_stage)
             min_year_categ,
          get_affair_categ_min_year_not (affair.affair_id,
                                         affair.affair_stage)
             min_year_categ_1,
          SUBSTR (get_min_categ (affair.affair_id, affair.affair_stage),
                  1,
                  25)
             min_categ,
          affair.reason2_num,
          SUBSTR (addr_apartment (affair.build_id, affair.apart_id, 1),
                  1,
                  200)
             address_short,
          SUBSTR (get_apart_num (apartment.apart_id), 1, 10) apart_num,
          SUBSTR (get_classifier_h (3, building.material), 1, 25) mater,
          affair.year_in_city,
          affair.year_in_place,
          affair.person_in_family pers_in_kpu,
          '' put_date,
          '' get_date,
          SUBSTR (
             get_affair_permit_chr (affair.affair_id, affair.affair_stage),
             1,
             100)
             affair_permitions,
          SUBSTR (get_person_lgota (affair.affair_id, delo_category), 1, 42)
             AS fio_lgonta,
          decl_date,
          SUBSTR (
             DECODE (
                affair.ordered,
                1, get_order_num_2 (
                      get_number_order (affair.affair_id,
                                        affair.affair_stage),
                      'NS')),
             1,
             50)
             AS order_num,
          SUBSTR (
             DECODE (
                affair.ordered,
                1, get_order_num_2 (
                      get_number_order (affair.affair_id,
                                        affair.affair_stage),
                      'SS')),
             1,
             10)
             AS order_ser,
          DECODE (
             affair.ordered,
             1, get_number_order_date (affair.affair_id, affair.affair_stage))
             AS order_date,
          SUBSTR (
             DECODE (
                affair.ordered,
                1, get_order_status (
                      get_number_order (affair.affair_id,
                                        affair.affair_stage))),
             1,
             15)
             AS order_status,
          DECODE (
             ars_data.get_msa_count (affair.affair_id, affair.affair_stage),
             0, NULL,
             ars_data.get_msa_count (affair.affair_id, affair.affair_stage))
             AS ars_famuly_count,
          SUBSTR (
             ars_data.get_all_vid_obes (affair.affair_id,
                                        affair.affair_stage),
             1,
             50)
             AS ars_vid_obes,
          SUBSTR (
             ars_data.get_all_nkp_sys (affair.affair_id, affair.affair_stage),
             1,
             50)
             AS ars_nkp_sys,
          SUBSTR (
             ars_data.get_all_person_count (affair.affair_id,
                                            affair.affair_stage),
             1,
             50)
             AS ars_all_cnt_person,
          SUBSTR (
             ars_data.get_all_date_pzm (affair.affair_id,
                                        affair.affair_stage),
             1,
             50)
             AS ars_all_pzm,
          SUBSTR (
             ars_data.get_all_date_zm (affair.affair_id, affair.affair_stage),
             1,
             50)
             AS ars_all_zm,
          SUBSTR (
             ars_data.get_all_not_kpu (affair.affair_id, affair.affair_stage),
             1,
             50)
             AS ars_all_notkpu,
          SUBSTR (get_person_lg_fam (affair.affair_id, delo_category), 1, 35)
             AS lg_family,
          SUBSTR (get_person_lg_name (affair.affair_id, delo_category),
                  1,
                  25)
             AS lg_name,
          SUBSTR (get_person_lg_fathername (affair.affair_id, delo_category),
                  1,
                  25)
             AS lg_fathername,
          get_person_lg_bdate (affair.affair_id, delo_category) AS lg_bdate,
          dszn.get_dszn_lg_count (affair.affair_id) AS dszn_lg_cnt,
          DECODE (dszn.get_dszn_lg_sovp (affair.affair_id),
                  -2, 0,
                  -1, 0,
                  dszn.get_dszn_lg_sovp (affair.affair_id))
             AS dszn_lg_sovp,
          DECODE (
             affair.reason,
             1, (SELECT ob_fb
                   FROM category
                  WHERE categ_id = delo_category
                        AND (TO_DATE (stand_year, 'yyyy') <
                                NVL (TRUNC (ob_dt, 'yyyy'),
                                     TO_DATE (1000, 'yyyy'))
                             OR (ob_fb IS NOT NULL AND ob_dt IS NULL))),
             ' ')
             AS ob_fb,
          DECODE (
             affair.reason,
             1, (SELECT ob_dt
                   FROM category
                  WHERE categ_id = delo_category
                        AND (TO_DATE (stand_year, 'yyyy') <
                                NVL (TRUNC (ob_dt, 'yyyy'),
                                     TO_DATE (1000, 'yyyy'))
                             OR (ob_fb IS NOT NULL AND ob_dt IS NULL))),
             NULL)
             AS ob_dt,
          get_bti_by_apart_unom (affair.apart_id) unom,
          affair.calc_year,
          get_order_year_realiz (
             get_order_freespace (
                get_number_order (affair.affair_id, affair.affair_stage)),
             get_number_order (affair.affair_id, affair.affair_stage))
             AS year_realiz,
          SUBSTR (get_classifier_kurs3 (114, affair.calc_reason, 'NAME'),
                  1,
                  60)
             AS calc_reason,
          affair.calc_change,
          affair.type2_date -- дата установки вида обеспечения 16.09.2008 Anissimova
                           ,
          DECODE (
             pkg_affair_sublease.get_affair_sublease_stay (affair.affair_id),
             1, 'Да',
             'Нет')
             AS sublease_stay,
          pkg_affair_sublease.get_affair_sublease_count (affair.affair_id)
             AS sublease_cnt,
          SUBSTR (get_affair_fraud (affair.affair_id, 'INVADDR#'), 1, 100)
             AS fraud_invaddr,
          SUBSTR (get_affair_fraud (affair.affair_id, 'INVNAME#'), 1, 100)
             AS fraud_invname,
          SUBSTR (get_affair_fraud (affair.affair_id, 'OWNADDR#'), 1, 100)
             AS fraud_ownaddr,
          SUBSTR (get_classifier_h2 (50, building_type), 1, 15) AS bld_type,
          DECODE (affair.reason, 21, affair.dc_num, NULL) AS num_ggk_21,
          DECODE (affair.reason, 21, affair.dc_date, NULL) AS d_ggk_21,
          SUBSTR (
             DECODE (pkg_affair.get_affair_ext_data_n (affair.affair_id, 1),
                     1, 'Коттедж/согласие',
                     2, 'Коттедж/отказ',
                     3, 'Колясочн./согласие',
                     4, 'Колясочн./отказ',
                     'Не выбрано'),
             1,
             20)
             AS cottage_n,
          pkg_affair.get_affair_ext_data_d (affair.affair_id, 2) AS cottage_d,
          pkg_affair.get_affair_ext_data_n (affair.affair_id, 4)
          || DECODE (pkg_affair.get_affair_ext_data_n (affair.affair_id, 4),
                     NULL, '',
                     ' о/к')
             AS cottage_sq,
          SUBSTR (
             DECODE (
                NVL (building.cottage, 0),
                1, DECODE (
                      test_affair_inv_carr (affair.affair_id,
                                            affair.affair_stage),
                      1, 'Нет',
                      'Да'),
                'Нет'),
             1,
             3)
             AS cottage,
          get_affair_person_cnt (affair.affair_id, affair.affair_stage, 4)
             no_adult_cnt,
          affair.notes AS affair_notes,
          get_person1_l (affair.affair_id) AS last_name_m,
          get_person1_p (affair.affair_id) AS patronymic_m,
          get_person1_f (affair.affair_id) AS pat_m,
          TRIM (subsid.get_sub_params (affair.affair_id, 0)) sub_num,
          TRIM (subsid.get_sub_params (affair.affair_id, 1)) sub_size_pc,
          TRIM (subsid.get_sub_params (affair.affair_id, 2)) sub_size_m,
          TRIM (subsid.get_sub_params (affair.affair_id, 3)) sub_rs,
          TRIM (subsid.get_sub_params (affair.affair_id, 4)) sub_z,
          TRIM (subsid.get_sub_params (affair.affair_id, 5)) sub_ra,
          TRIM (subsid.get_sub_params (affair.affair_id, 6)) sub_reas,
          pkg_affair_sublease.get_affair_sublease_text (affair.affair_id, 4)
             AS sublease_addr,
          TO_DATE (
             pkg_affair_sublease.get_affair_sublease_text (affair.affair_id,
                                                           5),
             'dd.mm.yyyy')
             AS sublease_date,
          pkg_affair_sublease.get_affair_sublease_text (affair.affair_id, 6)
             AS sublease_months,
          -- #D25.03.2013
          --    get_plan_4_poisk (affair.affair_id) AS plan_type,
          GET_PLAN_TYPE_QUEUE (affair.affair_id) AS plan_type,
          -- /#D25.03.2013
          DECODE (apartment.invalid_carr, 1, 'да', 'нет')
             AS invalid_carr,
          addr_all_kpu_info (affair.affair_id, affair.affair_stage, 1)
             AS other_affair_open,
          addr_all_kpu_info (affair.affair_id, affair.affair_stage, 2)
             AS other_affair_close,
          building.building_year AS b_year,
          bti.get_building_data (get_bti_by_apart_unom (affair.apart_id),
                                 'GDPOSTR')
             AS bti_b_gdpostr,
          affair_queue_01.queue_num AS queue_01_num,
          DECODE (affair.young_family,
                  1, 'Только МС',
                  2, 'В составе',
                  'Нет')
             AS young_fam,
          get_order_resolution_num (
             get_number_order (affair.affair_id, affair.affair_stage))
             AS order_res_num,
          TO_CHAR (
             get_order_resolution_date (
                get_number_order (affair.affair_id, affair.affair_stage)),
             'dd.mm.yyyy')
             AS order_res_date,
          SUBSTR (get_low_prop_doc (affair.affair_id, 2), 1, 25) lp_doc -- тип документа о малоимущности
                                                                       ,
          SUBSTR (get_low_prop_doc (affair.affair_id, 0), 1, 25) lp_num -- № документа о малоимущности
                                                                       ,
          SUBSTR (get_low_prop_doc (affair.affair_id, 1), 1, 25) lp_date -- тип документа о малоимущности
                                                                        ,
          get_order_agreementdate4affair (
             get_number_order (affair.affair_id, affair.affair_stage))
             AS agreedate,
          get_egd_info (affair.affair_id, 'REQUEST_DATE') AS egd_last_request,
          get_egd_info (affair.affair_id, 'RESPONSE_DATE')
             AS egd_last_response,
          SUBSTR (get_classifier_h2 (58, building.cottage), 1, 14)
             AS cottage_type,
          CASE
             WHEN get_ufrs_request_info_cnt (affair.affair_id, 'RQST_COUNT') >
                     0
             THEN
                'Да'
             ELSE
                ''
          END
             AS ufrs_rqst,
          CASE
             WHEN get_ufrs_request_info_cnt (affair.affair_id, 'ANSW_LAST') >
                     0
             THEN
                'Да'
             ELSE
                ''
          END
             AS ufrs_answ_last,
          TO_CHAR (
             get_ufrs_request_info_date (affair.affair_id, 'RQST_DATE'),
             'dd.mm.yyyy')
             AS ufrs_rqst_date,
          TO_CHAR (
             get_ufrs_request_info_date (affair.affair_id, 'ANSW_DATE'),
             'dd.mm.yyyy')
             AS ufrs_answ_last_date,
          TO_CHAR (
             get_ufrs_request_info_cnt (affair.affair_id, 'RQST_COUNT'),
             'B999')
             AS ufrs_rqst_count,
          TO_CHAR (
             get_ufrs_request_info_cnt (affair.affair_id, 'ANSW_COUNT'),
             'B999')
             AS ufrs_answ_count,
          DECODE (
             get_ufrs_request_info_cnt (affair.affair_id, 'HAVE_ESTATE'),
             0, 'Нет',
             -1, '',
             'Есть')
             AS ufrs_have_estate,
          TRIM (TO_CHAR (affair.sqL, '99999.9')) sqL,
          TO_CHAR (affair.sqb, '99999.9') sqb,
          TO_CHAR (apartment.living_space, '99999.9') AS liv_sq --,get_management_company_name(nvl(building.management_company,0)) as mancomp
          ,  mc.name AS mancomp
          , (select name from KURS3.V_DOC_GGK where ID=AFFAIR.DC_TYPE)  as  dc_type_name,
         -- #D24.01.2013
         (SELECT cl.short_name1 FROM classifier_kurs3 cl WHERE CL.CLASSIFIER_NUM = 138 AND cl.row_num = get_scan_error_for_affair(affair.affair_id,0))
          as scan_check_info
          --/ #D24.01.2013
          ,GET_PLAN_YEARS(affair.affair_id) AS TPG
          ,GET_OPD_QUEUE(affair.affair_id) AS OPD
          ,GET_AFFAIR_PLAN_LIST_STATUS(affair.affair_id) AS STATUS,
-- #D14.06.2013
          (SELECT cl.short_name1 FROM classifier_kurs3 cl WHERE CL.CLASSIFIER_NUM = 143 AND cl.row_num =Get_family_structure(affair.affair_id,affair.affair_stage))
          as FAMILY_STRUCTURE,
          (select count(*) from PERSON_RELATION_DELO prd where prd.affair_id=affair.affair_id and prd.affair_stage = affair.affair_stage and prd.reg_person =1)
          as COUNT_REG_PERSON,
-- /#D14.06.2013
-- #D20.06.2013
         DEREG_PVS.data_d  as DEREG_PVS_DATE,
         EXPORT_FAM.data_d as EXPORT_FAM_DATE,
         NVL2(UHUD_ZIL.AFFAIR_ID,
              NVL2(UHUD_ZIL.DATA_D,
                   (case when months_between(trunc(Sysdate,'dd'),trunc(UHUD_ZIL.DATA_D,'dd')) <= 60 then 'Да,< 5лет' else 'Да,> 5лет' end),
                   'Да'),
              NULL)         as UHUD_ZIL_USL,
         UHUD_ZIL.name      as REASON_UHUD_ZIL_USL,
         UHUD_ZIL.DATA_D    as DATE_UHUD_ZIL_USL,
         UHUD_ZIL.DATA_S    as PRIM_UHUD_ZIL_USL,
         PROBLEM_.NAME      as PROBLEM_PERES,
         PROBLEM_.DATA_S    as PRIM_PROBLEM_PERES,
         SOLUTION.NAME      as TYPE_SOLUTION,
         SOLUTION.DATA_D    as DATE_SOLUTION,
-- /#D20.06.2013
-- #D09.07.2013 
         SUBSTR (get_apartment_rgs_1 (affair.apart_id,'APR_STATUS'),1,10) as ownership_rsgs, 
         TO_DATE(get_apartment_rgs_1(affair.apart_id,'DATE_FROM'),'dd.mm.yyyy') as ownership_rsgs_date,  
         TO_DATE(get_apartment_rgs_1(affair.apart_id,'DATE_TO'),'dd.mm.yyyy')  as ownership_rsgs_date_to, 
         SUBSTR (get_apartment_rgs_1 (affair.apart_id,'STATE_NUMB'),1,30) as ownership_egrp_num, 
         TO_DATE(get_apartment_rgs_1(affair.apart_id,'STATE_FROM'),'dd.mm.yyyy') as ownership_egrp_date, 
         TO_DATE(get_apartment_rgs_1(affair.apart_id,'STATE_TO'),'dd.mm.yyyy') as ownership_egrp_date_to, 
         GET_AFFAIR_requirements(affair.affair_id) as requirements
-- /#D09.07.2013
      FROM affair,
          area,
          affairs_list,
          building,
          street,
          apartment,
          direction_target,
          affair_queue_01,
          management_companies mc,
-- #D20.06.2013
          (SELECT ae.affair_id,ae.data_d FROM AFFAIR_EXT_DATA ae
          where ae.data_type_id= pkg_affair.get_dereg_pvs_type_id
          and ae.data_version=0 and ae.data_d is not NULL)
          DEREG_PVS,
          (SELECT ae.affair_id,ae.data_d FROM AFFAIR_EXT_DATA ae
          where ae.data_type_id= pkg_affair.get_export_fam_type_id
          and ae.data_version=0 and ae.data_d is not NULL)
          EXPORT_FAM,
          (SELECT ae.affair_id,ae.data_n, cl.name, ae.data_s, ae.data_d FROM AFFAIR_EXT_DATA ae
          left join CLASSIFIER_KURS3 cl on cl.row_num = ae.data_n and cl.classifier_num = pkg_affair.get_classifier_uhud_num
          where ae.data_type_id= pkg_affair.get_uhud_type_id
          and ae.data_version=0)
          UHUD_ZIL,
          (SELECT ae.affair_id,ae.data_n, cl.name, ae.data_s, ae.data_d FROM AFFAIR_EXT_DATA ae
          left join CLASSIFIER_KURS3 cl on cl.row_num = ae.data_n and cl.classifier_num = pkg_affair.get_classifier_problem_num
          where ae.data_type_id= pkg_affair.get_problem_type_id
          and ae.data_version=0)
          PROBLEM_,
          (SELECT ae.affair_id,ae.data_n, cl.name, ae.data_s, ae.data_d FROM AFFAIR_EXT_DATA ae
          left join CLASSIFIER_KURS3 cl on cl.row_num = ae.data_n and cl.classifier_num = pkg_affair.get_classifier_solutions_num
          where ae.data_type_id= pkg_affair.get_solution_type_id
          and ae.data_version=0)
          SOLUTION
-- /#D20.06.2013
    WHERE affair.okrug_id = area.okrug_id
          AND ( (affairs_list.affair_id > 10000000000
                 AND TRUNC ( (affairs_list.affair_id - 10000000000) / 10) =
                        affair.affair_id
                 AND MOD (affairs_list.affair_id - 10000000000, 10) =
                        affair.affair_stage)
               OR (    affairs_list.affair_id < 10000000000
                   AND affairs_list.affair_id = affair.affair_id
                   AND affair.affair_stage = 1))
          AND building.street = street.street_id
          AND affair.build_id = building.building_id
          AND affair.apart_id = apartment.apart_id
          AND affair.reason = direction_target.direction  -- Terekh 14.09.2005
          AND affair.delo_category = direction_target.target
          AND affair.affair_id = affair_queue_01.affair_id(+)
          AND building.management_company = mc.mancomp_id(+)
-- #D20.06.2013
          AND affair.affair_id = DEREG_PVS.affair_id(+)
          AND affair.affair_id = EXPORT_FAM.affair_id(+)
          AND affair.affair_id = UHUD_ZIL.affair_id(+)
          AND affair.affair_id = PROBLEM_.affair_id(+)
          AND affair.affair_id = SOLUTION.affair_id(+);
