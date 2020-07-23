CREATE OR REPLACE VIEW V_ORDER_LIST
(affair_id, order_num, order_date, affair_num, person_cnt, sqi, sqo, affair_sqi, affair_sqo, year, plan, user_id, list_cod, list_num, last_name, note, new_id, reason, address, address_sh, type2, regnum, sq_type, room_count, apartment_count, sqo_p, zero_date, zero_reason, b_okrug_id, okrug, address_kpu, address_kpu_sh, kpu_apart_num, read_only, building_num, remark, order_type, resolution_num, resolution_date, affair_sstatus, o_dop, o_priv, o_free, prioritet, p8, f4_dir, f4_fund, f4_deliv, f4_nn, f4_date, f4_who, plan_year, plan_ny, prioritet_year, factory_order, sq_type_kpu, creation_date, young_fam, mokrug, affair_factory_cod, affair_factory, order_ser, kpu_reason, out_person_cnt, fam, pat, patronymic, cost3, agr_num_spec, agreement_date, remaind_year, s_calculation, pr_fakt, calculation_date, order_stage, nbc, bp, zpv, opd_kpi, in_lk, rdn_check, affair_tot, invalid_carr, r_reg_num, r_reg_date, r_st_dog, plan_type, pl_prioritet, year_realiz, stage, dog_period, r1_num, r1_date, d_pf, otkl_pf, bld_type, cottage, b_mokrug, b_zdz, plan_pgo, r_dog_date, r_reject_cause, apart_ids, otkaz_date, permit_97_num, permit_97_date, stand_year, prefect_num, prefect_date, zdz_rp, nd_zdz_rp_creation_date, nd_zdz_rp_last_change, sgs, sgs_date, sgs_date_to, order_apart_num, egrp_num, egrp_date, egrp_date_to, registration_date, resolution_type, no_adult_cnt, aff_decl_date, lastorder_mark, order_young, agreedate, state_reg_date, state_reg_required, kpu_room_cnt, other_affair_open, other_affair_close, egrp_arch, egrp_date_arch, sbs_fl, rsgs_fond, rsgs_fond_date_from, rsgs_fond_date_to, rsgs_is_spec_fond, rsgs_fond_out, sbs_total, cottage_type, sql, sqb, liv_sq, mancomp, runpopulated_date, runpopulated_txt, runpopulated_id, runpopulated_name, akt_date, enter_akt_date, need_reg_in_rd_6,
cause_nd, comment_causeof_nd, date_causeof_nd)
AS
SELECT                                                                   --
          --  30.07.1999              Добавлены новые поля
          --  03.08.1999              Добавлен округ жилплощади
          --  06.12.1999              Изменен округ ордера
          --  28.03.2000              Добавлен тип 12
          --  03.05.2000              Полный номер дела
          --  03.05.2000              Адрес КПУ
          --  17.11.2000              Примечание из КПУ
          --  07.12.2000              Добавлен тип 13
          --  15.12.2000              Добавлен тип ордера
          --  26.12.2000              Исправлена связка с номером корпуса
          --  02.03.2001              Добавлены номер и дата распоряжения
          --  11.10.2001              Добавлены колонки с площадью из учетного дела и видом заселения
          --  09.11.2001              Добавлены колонки с признаками дополн площади, льготы и освобождения площади
          --  19.11.2001              Добавлены новые колонки
          --  20.12.2001              Добавил букву выписки для "ВЫКУПа" (PVTar)
          --  15.02.2002              Добавил тип квартиры из КПУ (PVTar)
          --  25.04.2002              Добавил YOUNG_FAM (PVTar)
          --  16.05.2002              Исправлено формирование колонки PLAN
          --  17.05.2002              ДОБАВЛЕН муниципальный округ
          --  05.07.2002              ДОБАВЛЕН affair_factory_cod (PVTar)
          --  17.09.2002              Добавлен тип документа 17 (PVTar)
          --  15.11.2002              Добавлены типы документов 18 и 19 (PVTar)
          --  21.11.2002              Добавлены колонки по данным МЖР (PVTar)
          --  26.11.2002              Исправлена связка с FREE_SPACE (PVTar)
          --  05.12.2002              Добавлена информация по КНм (PVTar)
          --  17.12.2002              Исправлено получение вида обеспечения из КПУ (PVTar)
          --  04.02.2003              Исправил получение данных из free_space получаем данные только для min freespace_id
          --  17.04.2005              добавлено Дата учета (ATer)
          --  20.04.2005              Изменен номер для изданного проекта
          --  20.05.2005              Изменен номер для изданного проекта (И)
          --  21.09.2005              Добавлен тип документа 27
          --  20.09.2006              Добавлен тип документа 28
          --  06.12.2006  stargeorge  Добавлено поле rdn_check (признак наличия по выписке договора в ИС "Реестр договоров")
          --  16.01.2007  BlackHawk   Добавлено поле AFFAIR_TOT
          --  21.06.2007  maltseva    Добавлен тип документа 29
          --  10.12.2007  Alois       Добавлены поля (номер договора, дата, статус) для Реестра договоров
          --  01.02.2008  BlackHawk   Поправил длины полей: in_lk, rdn_check, r_reg_num, r_reg_date, r_st_dog
          --  23.04.2008  Lvova       Добавлено поле "год реализации площади" при передачи ее в МГЦАЖ
          --  19.05.2008  BlackHawk   Переделал получение поля RDN_CHECK
          --  23.05.2008  BlackHawk   Подправил получение данных для полей affair_factory_cod и affair_factory, для случаев отсутствия строки в AFFAIR
          --  10.06.2008  BlackHawk   Подправил вывод серии Выписки для БПс
          --  17.06.2008  maltseva    Добавлено поле STAGE
          --  15.09.2008  BlackHawk   Добавил обрезку некоторых полей
          --  25.09.2008  BlackHawk   Добавил поле dog_period - срок действия договора
          --  01.10.2008  BlackHawk   Добавил обработку Нкр (30 тип документа)
          --  21.11.2008  AVL         Добавил расчёт Даты связки ПФ и Отклонения фактической площади от проектной
          --  01.12.2008  BlackHawk   Добавил обработку ОВ (31 тип документа)
          --  13.02.2009  AVL         Добавил поле Тип строения по кл-ру 50
          --  03.03.2009  AVL         Добавил поле Коттедж для гор. программ и Муниципал. округ (район адреса)
          --  14.05.2009  BlackHawk   Добавил обработку КНб и КНмб
          --  09.07.2009  BlackHawk   Добавил поле B_ZDZ
          --  30.10.2009  Lvova       Поправила получение PLAN_TYPE вида плана ПЛАНа-КПУ из выписки
          --  30.10.2009  Lvova       Поправила получение PRIORITET приоритет ПЛАНа-КПУ извыписки
          --  07.12.2009  Lvova       Добавил поле ПГО ПЛАНа-КПУ из выписки
          --  11.12.2009  AVL         Поменял вывод поля "коттедж" по письму УИТ-1179/2009
          --  25.12.2009  Lvova       Изменила получение поля order_num, исп. ф-цию get_order_num_2(orders.order_id,'NS')
          --  20.05.2010  BlackHawk   Добавил поле r_reject_cause
          --  25.06.2010  BlackHawk   Добавил otkaz_date
          --  06.07.2010  BlackHawk   Добавил permit_97_num и permit_97_date
          --  19.07.2010  BlackHawk   Добавил stand_year
          --  17.08.2010  BlackHawk   Исправил поле o_free (УИТ-445/2010)
          --  29.11.2010  AVL         По УИТ-621/2010, УИТ-637/2010 добавил 5 полей:
          --                          prefect_num, prefect_date, zdz_rp, nd_zdz_rp_creation_date,nd_zdz_rp_last_change
          --  18.03.2011  Anissimova  Добавлено поле "№ кв. в оредере"
          --  18.05.2011  BlackHawk   Убрал поля mgr_text, mgr_num, registration_date, registration_num
          --                          Добавил поля egrp_num, egrp_date, egrp_date_to
          --  27.05.2011  BlackHawk   Добавил тип распоряжения (resolution_type)
          --  01.07.2011  BlackHawk   Добавил поле no_adult_cnt
          --  22.12.2011  BlackHawk   Добавил поле aff_decl_date
          --  18.01.2012  AVB         Добавил поле lastorder_mark
          --  30.01.2012  AVB         Добавил поле order_young (признак наличия молодой семьи)
          --  20.03.2012  AVB         Добавил поля agreedate, state_reg_date и state_reg_required
          --  04.04.2012  Anissimova  Добавила поля egrp_arch и egrp_date_arch
          --  10.04.2012  AVB         Добавил поля RSGS_FOND, RSGS_FOND_DATE_FROM, RSGS_FOND_DATE_TO, RSGS_IS_SPEC_FOND
          --  15.06.2012  Ikonnikov   Добавил поле cottage_type
          --  24.07.2012  AVB         Изменил вывод информации о фондах (поля RSGS_...)
          --  20.10.2012  Gladkov     Добавлены поля: cottage_type, sql, sqb, liv_sq, mancomp
          --  12.11.2012 ilonis Добавил поля    runpopulated_date,    runpopulated_txt,  runpopulated_id,  runpopulated_name   (причина незаселения)
          --  18.12.2012 Ikonnikov   Добавил поля akt_date, enter_akt_date - по акту приёмо-передачи получаемых из РД
          --  17.12.2012 ilonis смешанная собственность
          --  21.01.2013 ONovikova    Добавила поле need_reg_in_rd_6
          --  22.01.2013 ONovikova    Изменила поле r_st_dog
          --  06.02.2013 ilonis mgr_exchange.tmp_sbs_fl добавил поле  sbs_fl (признак 0-физ. лицо 1-юр.лицо) и изменил алгоритм формиорования Сбс_свод
          --  #Dik21022013   Заполнение атрибктов  'КПР', 'КПРм', 'МРк', 'МРкм' ,'КПИ', 'МРи' полей state_reg_date, agreedate
           --ilonis 12.04.2013 КПл,КПрн  этап stage
           --#28.08.2013 Dik  добавление полей (CAUSE_ND,COMMENT_CAUSEOF_ND, DATE_CAUSEOF_ND) по Причине не заключения договора (зад. 1.104)
          --
          --affair.affair_id as a,
          orders.order_id,
          SUBSTR (get_order_num_2 (orders.order_id, 'NS'), 1, 20)
             AS order_num,
          orders.order_date,
          SUBSTR (get_affair_num_4 (affair.affair_id), 1, 200),
          orders.person_cnt,
          TO_CHAR (orders.living_space, '99999.9'),
          TO_CHAR (orders.total_space, '99999.9'),
          TO_CHAR (affair.sqi, '99999.9'),
          TO_CHAR (affair.sqz, '99999.9'),                       -- AFFAIR_SQO
          DECODE (TO_CHAR (orders.year), '0', ' ', TO_CHAR (orders.year)),
          NVL (
             TO_CHAR (orders.plan_year),
             DECODE (
                TO_CHAR (orders.plan),
                '1', DECODE (TO_CHAR (affair.plan_year),
                             '0', ' ',
                             TO_CHAR (affair.plan_year)),
                ' ')),
          documents_list.user_id,
          documents_list.list_cod,
          documents_list.list_num, --substr(Addr_Apartment(Affair.build_Id,Affair.Apart_id),1,200),
          SUBSTR (get_person2 (orders.order_id), 1, 200),
          documents_list.note,
          DECODE (TO_CHAR (orders.new_building_sign), '1', 'Да', ' '), --Orders.Reason,
          --substr(Get_order_reason(orders.direction),1,200),
          SUBSTR (
                TRIM (TO_CHAR (orders.direction, '000'))
             || TRIM (TO_CHAR (orders.target, '000'))
             || ' '
             || get_target (orders.direction, orders.target, 'SH'),
             1,
             30),
          SUBSTR (addr_apartmento_1 (orders.order_id), 1, 200),
          SUBSTR (addr_apartmento_1 (orders.order_id, 1), 1, 200),
          SUBSTR (
             get_type2_sh3 (
                get_type2 (affair.okrug_id,
                           affair.affair_id,
                           orders.affair_plan_id)),
             1,
             200),
          orders.order_num_u,
          SUBSTR (get_space_type2 (orders.sq_type, NULL), 1, 5),
          get_order_room_cnt (orders.order_id),
          get_order_apart_cnt (orders.order_id),
          TO_CHAR (
             DECODE (orders.person_cnt,
                     0, 0,
                     orders.total_space / orders.person_cnt),
             '99999.9'),
          TO_CHAR (orders.cancel_date, 'DD.MM.YYYY'),
          SUBSTR (get_classifier_h2 (38, orders.reason), 1, 15),
          SUBSTR (
             get_okrug_sh (
                get_order_okrug_1 (orders.order_id, orders.document_type)),
             1,
             5),
          SUBSTR (get_okrug_sh (orders.okrug_id), 1, 5),
          SUBSTR (addr_apartment (affair.build_id, affair.apart_id), 1, 200),
          SUBSTR (addr_apartment (affair.build_id, affair.apart_id, 1),
                  1,
                  200),
          SUBSTR (get_apart_num (affair.apart_id), 1, 10) kpu_apart_num,
          get_read_only (6, orders.order_id),
          get_order_building_num (orders.order_id, orders.document_type),
          affair.remark,
          SUBSTR (get_order_type_name_sh (orders.order_type), 1, 200),
          resolution_num,
          resolution_date,
          SUBSTR (get_affair_sstatus (affair.sstatus), 1, 200),
          DECODE (orders.add_space, 1, 'Д', '') o_dop,
          DECODE (orders.no_priv, 1, '', 'Л') o_priv,
          DECODE (orders.order_type,
                  8, 'Н',
                  9, 'Н',
                  10, 'Н',
                  11, 'Н',
                  12, 'Н',
                  13, 'Н',
                  14, 'Н',
                  15, 'Н',
                  16, 'Н',
                  17, 'Н',
                  21, 'Н',
                  22, 'Н',
                  24, 'Н',
                  32, 'Н',
                  33, 'Н',
                  'Д')
             o_free,
          SUBSTR (get_order_prioritet (orders.order_id), 1, 200) prioritet,
          DECODE (
             affair.affair_id,
             NULL, TO_NUMBER (get_order_factory_info (orders.order_id, 'P8')),
             get_affair_factory_p8 (orders.affair_id, orders.affair_stage))
             p8,
          SUBSTR (get_order_instruction_dir (orders.order_id), 1, 200)
             instruction_dir,
          SUBSTR (get_order_freespace_fond_sh3 (orders.order_id), 1, 200)
             AS f4_fund,
          SUBSTR (get_order_instruction_deliv (orders.order_id), 1, 200)
             AS f4_deliv,
          SUBSTR (get_order_instruction_num (orders.order_id), 1, 20)
             AS f4_nn,
          get_order_instruction_date (orders.order_id) f4_date,
          SUBSTR (get_order_instr_factory_who (orders.order_id), 1, 200)
             AS instruction_who,
          get_order_plan_year (orders.order_id) plan_year,
          DECODE (get_order_plan_ny (orders.order_id), 1, 'Да', 'Нет')
             AS plan_ny,
          get_order_prioritet_year (orders.order_id) prioritet_year,
          SUBSTR (get_factory (orders.rent_department, orders.rent_factory),
                  1,
                  60),
          SUBSTR (get_space_type2 (affair.sq_type, NULL), 1, 5),
          TRUNC (orders.creation_date),
          DECODE (orders.young_family,
                  1, 'Есть',
                  2, 'В сост.',
                  'Нет')
             AS young_fam,
          SUBSTR (get_building_mokrug (affair.build_id), 1, 200) mokrug,
          SUBSTR (
             DECODE (
                affair.affair_id,
                NULL, get_order_factory_info (orders.order_id, 'COD'),
                TRIM (
                   TO_CHAR (affair.department_id * 1000 + affair.factory_id,
                            '000000'))),
             1,
             6)
             AS affair_factory_cod,
          SUBSTR (
             DECODE (
                affair.affair_id,
                NULL, get_order_factory_info (orders.order_id, 'SNAME'),
                get_factory_name_sh (affair.department_id, affair.factory_id)),
             1,
             25)
             AS affair_factory,
          orders.ser order_ser,
          affair.reason kpu_reason,
          affair.person_in_family - orders.person_cnt AS out_person_cnt,
          SUBSTR (get_person_fio (orders.order_id, 1), 1, 200),
          SUBSTR (get_person_fio (orders.order_id, 2), 1, 200),
          SUBSTR (get_person_fio (orders.order_id, 3), 1, 200),
          DECODE (orders.type3,
                  9, orders.cost1,
                  10, orders.cost1,
                  12, orders.cost1,
                  orders.cost3)
             AS cost3,
          DECODE (orders.type3,
                  3, orders.agreement_num,
                  agreement.agr_num_spec)
             AS agreement_num,
          DECODE (orders.type3,
                  3, orders.order_date,
                  agreement.agreement_date)
             AS agreement_date,
          get_order_freespace_ryear (orders.order_id) remaind_year,
          SUBSTR (get_s_calculation (orders.s_calculation, 1), 1, 200)
             AS s_calculation,
          DECODE (
             get_apart_proekt_fakt (orders.order_id, orders.order_stage),
             2, 'П+Ф',
             1, 'П',
             0, 'Ф',
             '')
             AS pr_fakt,
          TO_CHAR (orders.calculation_date, 'DD.MM.YYYY'),
          DECODE (orders.order_stage,
                  0, 'Сохраненный проект выписки',
                  1, 'Изданный проект выписки',
                  2, 'Выписка')
             AS order_stage,
          SUBSTR (
             get_nbc_bp_for_orders (orders.order_id, orders.order_stage, 0),
             1,
             30)
             AS nbc,
          SUBSTR (
             get_nbc_bp_for_orders (orders.order_id, orders.order_stage, 1),
             1,
             30)
             AS bp,
          SUBSTR (
             get_nbc_bp_for_orders (orders.order_id, orders.order_stage, 2),
             1,
             30)
             AS zpv,
          get_opd_kpi (orders.order_id, 6) AS opd_kpi,
          SUBSTR (get_doc_lk (orders.order_id), 1, 5) AS in_lk,      /*'нет'*/
          SUBSTR (
             get_classifier (
                8,
                DECODE (
                   visa.rdn_rep.
                    get_dog_param_by_order (orders.order_id, 'STATUS_N'),
                   NULL, 2,
                   1)),
             1,
             30)
             AS rdn_check,
          --get_affair_tot (orders.affair_id, orders.affair_stage) affair_tot,
          TO_CHAR (get_apart_tot (affair.apart_id), '99999.9') AS affair_tot,
          DECODE (
             get_document_apart_invalid_cnt (orders.order_id,
                                             orders.document_type),
             0, 'нет',
             'да')
             AS invalid_carr,
          SUBSTR (
             visa.rdn_rep.get_dog_param_by_order (orders.order_id, 'REG_NUM'),
             1,
             30)
             AS r_reg_num,
          SUBSTR (
             visa.rdn_rep.
              get_dog_param_by_order (orders.order_id, 'REG_DATE'),
             1,
             10)
             AS r_reg_date,

         NVL (
                   SUBSTR (
                      visa.rdn_rep.
                       get_dog_param_by_order (orders.order_id, 'STATUS'),
                      1,
                      40),
                      CASE fn_get_need_reg_in_rd (orders.order_id)
                        WHEN 3 THEN  'В РД регистрации не будет'
                        WHEN 2 THEN ''
                      END )
                 AS r_st_dog,

          --        ,SUBSTR (get_affair_plan_type (affair_plan.plan_type), 1, 15) plan_type       --  30.10.2009  Lvova
          SUBSTR (
             get_affair_plan_type (
                get_order_affair_plan_type (orders.order_id,
                                            orders.affair_id,
                                            orders.affair_plan_id)),
             1,
             15)
             AS plan_type,                               --  30.10.2009  Lvova
          -- SUBSTR (get_affair_plan_prioritet (affair_plan.prioritet), 1, 30) pl_prioritet     --  30.10.2009  Lvova
          SUBSTR (
             get_affair_plan_prioritet (
                get_order_affair_plan_prior (orders.order_id,
                                             orders.affair_id,
                                             orders.affair_plan_id)),
             1,
             30)
             AS pl_prioritet,                            --  30.10.2009  Lvova
          get_order_year_realiz (get_order_freespace (orders.order_id),
                                 orders.order_id)
             AS year_realiz,
          SUBSTR (  DECODE (   get_order_stage (orders.order_id),
                                            0, '',
                                            -1, '',
                                            -2, '',
                                            -3, visa.rdn_rep. get_dog_param_by_order (orders.order_id, 'ORDER_ETAP'),          --ilonis 12.04.2013
                                            get_classifier_kurs3 (115,  get_order_stage (orders.order_id),  'SN1')),
             1,    60)   AS stage,
          DECODE (
             orders.period,
             NULL, '',
                TRUNC (orders.period / 12)
             || ' год '
             || MOD (orders.period, 12)
             || ' мес')
             AS dog_period,
          DECODE (
             NVL (get_order_r1_p8_30 (orders.order_id, orders.document_type),
                  0),
             0, NULL,
             -1, NULL,
             get_order_r1_p8_30 (orders.order_id, orders.document_type))
             AS r1_num,
          DECODE (
             NVL (
                get_order_r1d_p8_30 (orders.order_id, orders.document_type),
                TO_DATE ('01.01.1970', 'dd.mm.yyyy')),
             TO_DATE ('01.01.1970', 'dd.mm.yyyy'), NULL,
             get_order_r1d_p8_30 (orders.order_id, orders.document_type))
             AS r1_date,
          SUBSTR (
             get_dc_xns3 (
                NVL (get_order_nbc (orders.order_id, orders.document_type),
                     0)),
             1,
             10)
             AS d_pf,
          DECODE (
             NVL (get_order_nbc (orders.order_id, orders.document_type), 0),
             0, TO_NUMBER (NULL),
             get_otkl_doc (orders.order_id, orders.document_type))
             AS otkl_pf,
          SUBSTR (
             get_classifier_h2 (
                50,
                get_building_type (
                   get_order_building_id (orders.order_id,
                                          orders.document_type))),
             1,
             15)
             AS bld_type,
          SUBSTR (
             DECODE (
                get_cottage (
                   get_order_building_id (orders.order_id,
                                          orders.document_type)),
                1, 'Да',
                'Нет'),
             1,
             3)
             AS cottage,
          SUBSTR (
             get_building_mokrug (
                get_order_building_id (orders.order_id, orders.document_type)),
             1,
             200)
             AS b_mokrug,
          get_order_affair_plan_pgo (orders.order_id,
                                     orders.affair_id,
                                     orders.affair_plan_id)
             AS plan_pgo,                                --  07.12.2009  Lvova
          get_order_apart_zdz (orders.order_id, orders.document_type)
             AS b_zdz,
          SUBSTR (
             visa.rdn_rep.
              get_dog_param_by_order (orders.order_id, 'DOG_DATE'),
             1,
             10)
             AS r_dog_date,
          SUBSTR (
             visa.rdn_rep.
              get_dog_param_by_order (orders.order_id, 'REJECT_CAUSE'),
             1,
             100)
             AS r_reject_cause,
          SUBSTR (
             get_order_apart_ids (orders.order_id, orders.document_type),
             1,
             400)
             AS apart_ids,
          TO_CHAR (pkg_orders.get_orders_ext_data_d (orders.order_id, 79),
                   'dd.mm.yyyy')
             AS otkaz_date,
          SUBSTR (pkg_orders.get_orders_ext_data_s (orders.order_id, 86),
                  1,
                  10)
             AS permit_97_num,
          TO_CHAR (pkg_orders.get_orders_ext_data_d (orders.order_id, 86),
                   'dd.mm.yyyy')
             AS permit_97_date,
          affair.stand_year,
          SUBSTR (get_pref_num_ord (orders.order_id, orders.document_type),
                  1,
                  20)
             AS prefect_num,
          get_pref_date_ord (orders.order_id, orders.document_type)
             AS prefect_date,
          get_zdz_rp_ord (orders.order_id, orders.document_type) AS zdz_rp,
          get_nd_zdz_rp_cr_date_ord (orders.order_id, orders.document_type)
             AS nd_zdz_rp_creation_date,
          get_nd_zdz_rp_lc_ord (orders.order_id, orders.document_type)
             AS nd_zdz_rp_last_change,
          SUBSTR (
             CASE
                WHEN orders.SQ_TYPE = 2 -- коммуналки          AVB  02.07.2012
                THEN
                   NVL (
                      get_apartment_owner_rgs_doc (orders.order_id,
                                                   orders.document_type),
                      get_apartment_rgs_1 (
                         get_order_apart_id (orders.order_id,
                                             orders.document_type),
                         'APR_STATUS'))
                ELSE
                   get_apartment_rgs_1 (
                      get_order_apart_id (orders.order_id,
                                          orders.document_type),
                      'APR_STATUS')
             END,
             1,
             10)
             AS sgs,
          TO_DATE (
             CASE
                WHEN orders.SQ_TYPE = 2 -- коммуналки          AVB  03.07.2012
                THEN
                   NVL (
                      get_apartment_owner_rgs_doc (orders.order_id,
                                                   orders.document_type,
                                                   'DATE_FROM'),
                      get_apartment_rgs_1 (
                         get_order_apart_id (orders.order_id,
                                             orders.document_type),
                         'DATE_FROM'))
                ELSE
                   get_apartment_rgs_1 (
                      get_order_apart_id (orders.order_id,
                                          orders.document_type),
                      'DATE_FROM')
             END,
             'dd.mm.yyyy')
             AS sgs_date,
          TO_DATE (
             CASE
                WHEN orders.SQ_TYPE = 2 -- коммуналки          AVB  03.07.2012
                THEN
                   NVL (
                      get_apartment_owner_rgs_doc (orders.order_id,
                                                   orders.document_type,
                                                   'DATE_TO'),
                      get_apartment_rgs_1 (
                         get_order_apart_id (orders.order_id,
                                             orders.document_type),
                         'DATE_TO'))
                ELSE
                   get_apartment_rgs_1 (
                      get_order_apart_id (orders.order_id,
                                          orders.document_type),
                      'DATE_TO')
             END,
             'dd.mm.yyyy')
             AS sgs_date_to,
          SUBSTR (addr_apartmento_fmt (orders.order_id, 'KV'), 1, 10)
             AS order_apart_num,
          SUBSTR (
             get_apartment_rgs_1 (
                get_order_apart_id (orders.order_id, orders.document_type),
                'STATE_NUMB'),
             1,
             30)
             AS egrp_num,
          TO_DATE (
             get_apartment_rgs_1 (
                get_order_apart_id (orders.order_id, orders.document_type),
                'STATE_FROM'),
             'dd.mm.yyyy')
             AS egrp_date,
          TO_DATE (
             get_apartment_rgs_1 (
                get_order_apart_id (orders.order_id, orders.document_type),
                'STATE_TO'),
             'dd.mm.yyyy')
             AS egrp_date_to,
          agreement.registration_date,
          get_resolution_type_fmt (orders.order_id,
                                   orders.resolution_type,
                                   'SNAME')
             AS resolution_type,
          get_order_person_cnt (orders.order_id, 1) AS no_adult_cnt,
          TO_CHAR (AFFAIR.DECL_DATE, 'dd.mm.yyyy') AS aff_decl_date,
          DECODE (
             is_last_order (orders.order_id,
                            orders.document_type,
                            orders.order_date),
             1, 'Да',
             'Нет')
             AS lastorder_mark,
          DECODE (orders.order_young, 1, 'Есть', 'Нет') AS order_young,
          -- #Dik21022013
          /* --OLD---
                    CASE
                       WHEN TRIM (orders.SER) = 'М'
                       THEN
                          TO_DATE (
                             visa.rdn_rep.
                              get_dog_param_by_order (orders.order_id, 'REG_DATE'),
                             'dd.mm.yyyy')
                       WHEN TRIM (orders.SER) IN ('КПР', 'КПРм')
                       THEN
                          DECODE (
                             get_order_agree_info (orders.order_id, 2),
                             NULL, TO_DATE (
                                      visa.rdn_rep.
                                       get_dog_param_by_order (orders.order_id,
                                                               'REG_DATE'),
                                      'dd.mm.yyyy'),
                             get_order_agree_info (orders.order_id, 2))
                       WHEN TRIM (orders.SER) = 'КПИ'
                       THEN
                          TO_DATE (get_order_agree_info (orders.order_id, 2),
                                   'dd.mm.yyyy')
                       ELSE
                          orders.agreement_date
                    END
                       AS agreedate,
                    DECODE (
                       TRIM (orders.SER),
                       'КПИ', get_order_agree_info (orders.order_id, 4),
                       'КПР', get_order_agree_info (orders.order_id, 4),
                       'КПРм', get_order_agree_info (orders.order_id, 4),
                       'М', TO_DATE (
                                get_apartment_rgs_1 (
                                   get_order_apart_id (orders.order_id,
                                                       orders.document_type),
                                   'DATE_TO'),
                                'dd.mm.yyyy'),
                       orders.state_reg_date)
                       AS state_reg_date,
   =======NEW =======*/
          CASE
             WHEN TRIM (orders.SER) = 'М' THEN
                TO_DATE (visa.rdn_rep.get_dog_param_by_order (orders.order_id, 'REG_DATE'), 'dd.mm.yyyy')
             WHEN TRIM (orders.SER) IN ('КПР', 'КПРм', 'МРк', 'МРкм') THEN
                 CASE (SELECT COUNT (*) AS a FROM agreement ag WHERE ag.order_id = orders.order_id and ag.agreement_date is not NULL)
                   WHEN 0 THEN
                      TO_DATE ( visa.rdn_rep.get_dog_param_by_order (orders.order_id,'REG_DATE'),'dd.mm.yyyy')
                   ELSE
                      (SELECT ag.agreement_date FROM agreement ag WHERE ag.order_id = orders.order_id AND ROWNUM = 1)
                END
             WHEN TRIM (orders.SER) IN ('КПИ', 'МРи') THEN
                  ( SELECT oed.data_d --Дата ответа банка на КФК2
                  FROM orders_ext_data oed, orders_ext_data oed1
                  WHERE    oed.order_id = orders.order_id
                        AND oed.order_id=oed1.order_id
                        and oed.data_version = 0
                        and oed1.data_version = oed.data_version
                        and oed1.data_type_id =28 --Признак - Ответ банка на КФК2
                        AND NVL(oed1.DATA_N,-1) = 0 --Ответ банка на КФК2='СОГЛАСИЕ'
                        and oed.data_type_id =60  --Признак -Дата ответа банка на КФК2
                        and rownum=1 )
             ELSE
                orders.agreement_date
          END
             AS agreedate,
          CASE
             WHEN TRIM (orders.SER) = 'М' THEN
                TO_DATE ( get_apartment_rgs_1(get_order_apart_id (orders.order_id, orders.document_type),'DATE_TO'),'dd.mm.yyyy')
             WHEN TRIM (orders.SER) IN ('КПР', 'КПРм', 'МРк', 'МРкм') THEN
                (SELECT ag.registration_date FROM agreement ag WHERE ag.order_id = orders.order_id AND ROWNUM = 1)
             WHEN TRIM (orders.SER) IN ('КПИ', 'МРи') THEN
                TO_DATE (get_apartment_rgs_1 ( get_order_apart_id (orders.order_id, orders.document_type), 'DATE_TO'), 'dd.mm.yyyy')
             ELSE
                orders.state_reg_date
          END
             AS state_reg_date,
          -- / #Dik21022013
          CASE
             WHEN TRIM (orders.SER) IN ('М', 'КПР', 'КПРм', 'КПИ')
             THEN
                'Да'
             ELSE
                'Нет'
          END
             AS state_reg_required,
          TO_CHAR (affair.OCCUPY_NUM) AS kpu_room_cnt,
          addr_all_kpu_info (affair.affair_id, affair.affair_stage, 1)
             AS other_affair_open,
          addr_all_kpu_info (affair.affair_id, affair.affair_stage, 2)
             AS other_affair_close,
          DECODE (
             get_apartment_mgr_1 (get_order_freespace (orders.order_id)),
             1, 'Мск.',
             2, 'Сбс.',
             NULL)
             AS egrp_arch,
          TRUNC (get_apartment_mgr_2 (get_order_freespace (orders.order_id)))
             AS egrp_date_arch,
          DECODE (
             get_sbs_fl (
                Get_ORDER_APART_ID (orders.order_id, orders.document_type)),
             0, 'ФЛ',
             1, 'ЮЛ',
             NULL)
             AS sbs_fl,                           -- собственность третьих лиц
          /*        , get_rsgs_fond(Get_bti_from_apartment(Get_ORDER_APART_ID(orders.order_id, orders.document_type),'UNOM'),
                                  Get_bti_from_apartment(Get_ORDER_APART_ID(orders.order_id, orders.document_type),'UNKV'), 'NAME')
                  , get_rsgs_fond(Get_bti_from_apartment(Get_ORDER_APART_ID(orders.order_id, orders.document_type),'UNOM'),
                                  Get_bti_from_apartment(Get_ORDER_APART_ID(orders.order_id, orders.document_type),'UNKV'), 'DATE_FROM')
                  , get_rsgs_fond(Get_bti_from_apartment(Get_ORDER_APART_ID(orders.order_id, orders.document_type),'UNOM'),
                                  Get_bti_from_apartment(Get_ORDER_APART_ID(orders.order_id, orders.document_type),'UNKV'), 'DATE_TO')
                  , get_rsgs_fond(Get_bti_from_apartment(Get_ORDER_APART_ID(orders.order_id, orders.document_type),'UNOM'),
                                  Get_bti_from_apartment(Get_ORDER_APART_ID(orders.order_id, orders.document_type),'UNKV'), 'IS_SPEC_FOND')
                  , get_rsgs_fond(Get_bti_from_apartment(Get_ORDER_APART_ID(orders.order_id, orders.document_type),'UNOM'),
                                  Get_bti_from_apartment(Get_ORDER_APART_ID(orders.order_id, orders.document_type),'UNKV'), 'NAME_OUT') */

          get_rsgs_fond (
             get_bti_by_apart_unom (
                Get_ORDER_APART_ID (orders.order_id, orders.document_type)),
             get_bti_by_apart_unkv (
                Get_ORDER_APART_ID (orders.order_id, orders.document_type)),
             'NAME'),
          get_rsgs_fond (
             get_bti_by_apart_unom (
                Get_ORDER_APART_ID (orders.order_id, orders.document_type)),
             get_bti_by_apart_unkv (
                Get_ORDER_APART_ID (orders.order_id, orders.document_type)),
             'DATE_FROM'),
          get_rsgs_fond (
             get_bti_by_apart_unom (
                Get_ORDER_APART_ID (orders.order_id, orders.document_type)),
             get_bti_by_apart_unkv (
                Get_ORDER_APART_ID (orders.order_id, orders.document_type)),
             'DATE_TO'),
          get_rsgs_fond (
             get_bti_by_apart_unom (
                Get_ORDER_APART_ID (orders.order_id, orders.document_type)),
             get_bti_by_apart_unkv (
                Get_ORDER_APART_ID (orders.order_id, orders.document_type)),
             'IS_SPEC_FOND'),
          get_rsgs_fond (
             get_bti_by_apart_unom (
                Get_ORDER_APART_ID (orders.order_id, orders.document_type)),
             get_bti_by_apart_unkv (
                Get_ORDER_APART_ID (orders.order_id, orders.document_type)),
             'NAME_OUT'),
          --, CASE get_sbs_total(Get_ORDER_APART_ID(orders.order_id, orders.document_type), get_order_freespace(orders.order_id))
          CASE get_sbs_total_order (orders.order_id,
                                    orders.document_type,
                                    get_order_freespace (orders.order_id))
             WHEN 1
             THEN
                'Мск.'
             WHEN 2
             THEN
                'Сбс.'
             WHEN 3
             THEN
                'Кмн.'
             WHEN 6
             THEN
                'Сбс/Мск'                            --17.12.2012 ilonis
             WHEN 7
             THEN
                'ФЛ'                                     --06.02.2013 ilonis
             WHEN 8
             THEN
                'ЮЛ'                                     --06.02.2013 ilonis
             ELSE
                ''
          END
             AS sbs_total,
          SUBSTR (get_classifier_h2 (58, building.cottage), 1, 14)
             AS cottage_type,
          TO_CHAR (affair.sqL, '99999.9') AS sqL,
          TO_CHAR (affair.sqb, '99999.9') AS sqb,
          TO_CHAR ( (SELECT living_space
                       FROM apartment
                      WHERE apart_id = affair.apart_id), '99999.9')
             AS liv_sq,
          --,get_management_company_name(nvl(building.management_company,0)) as mancomp
          mc.name AS mancomp,
          (SELECT apartment.RUnpopulated_date
             FROM apartment
            WHERE apartment.apart_id = document.apart_id)
             AS RUnpopulated_date,
          (SELECT apartment.RUnpopulated_txt
             FROM apartment
            WHERE apartment.apart_id = document.apart_id)
             AS RUnpopulated_txt,
          (SELECT apartment.RUnpopulated_Id
             FROM apartment
            WHERE apartment.apart_id = document.apart_id)
             AS RUnpopulated_Id,
          (SELECT NAME
             FROM classifier_kurs3 cl
            WHERE CL.CLASSIFIER_NUM = 131
                  AND cl.row_num =
                         (SELECT apartment.RUnpopulated_Id
                            FROM apartment
                           WHERE apartment.apart_id = document.apart_id))
             AS RUnpopulated_name,
          VISA.RDN_REP.GET_DOG_PARAM_BY_ORDER (orders.order_id, 'AKT_DATE')
             AS AKT_DATE,
          VISA.RDN_REP.
           GET_DOG_PARAM_BY_ORDER (orders.order_id, 'ENTER_AKT_DATE')
             AS ENTER_AKT_DATE,
          (SELECT NAME
             FROM classifier_kurs3 cl
            WHERE CL.CLASSIFIER_NUM = 137
                  AND cl.row_num = FN_GET_NEED_REG_IN_RD (orders.order_id))
             AS NEED_REG_IN_RD_6,
--#28.08.2013 Dik
a.cause_name as CAUSE_ND,
a.comment_causeof_nd as COMMENT_CAUSEOF_ND,
Trunc (a.date_causeof_nd) as DATE_CAUSEOF_ND
-- / #28.08.2013 Dik             
     FROM orders,
          affair,
          documents_list,
          agreement,
          affair_plan,                   --, kursiv.apartment   --, free_space
          document,
          building,
          management_companies mc,
--#28.08.2013 Dik   - выбор из  apartment тока с причинами незакл. договора           
          (select ap.apart_id,ap.building_id, cl.name as cause_name, ap.comment_causeof_nd, ap.date_causeof_nd 
           from apartment ap, classifier_kurs3 cl 
           where ap.cause_nd=cl.row_num
                 and cl.classifier_num = K3_PKG_APARTMENT.get_R_NSAgr
           ) a 
-- / #28.08.2013 Dik             
    WHERE     orders.affair_id = affair.affair_id(+)
          AND orders.affair_stage = affair.affair_stage(+)
          -- AND orders.order_id = kursiv.apartment.order_id(+)
          AND orders.order_id = documents_list.affair_id
          AND orders.order_id = agreement.order_id(+)
          AND orders.affair_plan_id = affair_plan.affair_plan_id(+)
          --     AND free_space.doc2_num(+) = orders.order_id
          --     AND free_space.doc2_type(+) = orders.document_type
          --affair.AFFAIR_STAGE=1 and
          AND orders.ORDER_ID = document.DOCUMENT_NUM
          AND orders.DOCUMENT_TYPE = document.DOCUMENT_TYPE
          AND document.BUILDING_ID = building.BUILDING_ID
          AND building.management_company = mc.mancomp_id(+)
--#28.08.2013 Dik
          AND document.apart_id = a.apart_id(+) 
          AND document.BUILDING_ID =a.building_id(+);          
-- / #28.08.2013 Dik          
