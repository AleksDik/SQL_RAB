CREATE OR REPLACE VIEW V_ORDER_LIST
(affair_id, order_num, order_date, affair_num, person_cnt, sqi, sqo, affair_sqi, affair_sqo, year, plan, user_id, list_cod, list_num, last_name, note, new_id, reason, address, address_sh, type2, regnum, sq_type, room_count, apartment_count, sqo_p, zero_date, zero_reason, b_okrug_id, okrug, address_kpu, address_kpu_sh, kpu_apart_num, read_only, building_num, remark, order_type, resolution_num, resolution_date, affair_sstatus, o_dop, o_priv, o_free, prioritet, p8, f4_dir, f4_fund, f4_deliv, f4_nn, f4_date, f4_who, plan_year, plan_ny, prioritet_year, factory_order, sq_type_kpu, creation_date, young_fam, mokrug, affair_factory_cod, affair_factory, order_ser, kpu_reason, out_person_cnt, fam, pat, patronymic, cost3, agr_num_spec, agreement_date, remaind_year, s_calculation, pr_fakt, calculation_date, order_stage, nbc, bp, zpv, opd_kpi, in_lk, rdn_check, affair_tot, invalid_carr, r_reg_num, r_reg_date, r_st_dog, plan_type, pl_prioritet, year_realiz, stage, dog_period, r1_num, r1_date, d_pf, otkl_pf, bld_type, cottage, b_mokrug, b_zdz, plan_pgo, r_dog_date, r_reject_cause, apart_ids, otkaz_date, permit_97_num, permit_97_date, stand_year, prefect_num, prefect_date, zdz_rp, nd_zdz_rp_creation_date, nd_zdz_rp_last_change, sgs, sgs_date, sgs_date_to, order_apart_num, egrp_num, egrp_date, egrp_date_to, registration_date, resolution_type, no_adult_cnt, aff_decl_date, lastorder_mark, order_young, agreedate, state_reg_date, state_reg_required, kpu_room_cnt, other_affair_open, other_affair_close, egrp_arch, egrp_date_arch, sbs_fl, rsgs_fond, rsgs_fond_date_from, rsgs_fond_date_to, rsgs_is_spec_fond, rsgs_fond_out, sbs_total, cottage_type, sql, sqb, liv_sq, mancomp, runpopulated_date, runpopulated_txt, runpopulated_id, runpopulated_name, akt_date, enter_akt_date, need_reg_in_rd_6,
cause_nd, comment_causeof_nd, date_causeof_nd)
AS
SELECT                                                                   --
          --  30.07.1999              ��������� ����� ����
          --  03.08.1999              �������� ����� ����������
          --  06.12.1999              ������� ����� ������
          --  28.03.2000              �������� ��� 12
          --  03.05.2000              ������ ����� ����
          --  03.05.2000              ����� ���
          --  17.11.2000              ���������� �� ���
          --  07.12.2000              �������� ��� 13
          --  15.12.2000              �������� ��� ������
          --  26.12.2000              ���������� ������ � ������� �������
          --  02.03.2001              ��������� ����� � ���� ������������
          --  11.10.2001              ��������� ������� � �������� �� �������� ���� � ����� ���������
          --  09.11.2001              ��������� ������� � ���������� ������ �������, ������ � ������������ �������
          --  19.11.2001              ��������� ����� �������
          --  20.12.2001              ������� ����� ������� ��� "������" (PVTar)
          --  15.02.2002              ������� ��� �������� �� ��� (PVTar)
          --  25.04.2002              ������� YOUNG_FAM (PVTar)
          --  16.05.2002              ���������� ������������ ������� PLAN
          --  17.05.2002              �������� ������������� �����
          --  05.07.2002              �������� affair_factory_cod (PVTar)
          --  17.09.2002              �������� ��� ��������� 17 (PVTar)
          --  15.11.2002              ��������� ���� ���������� 18 � 19 (PVTar)
          --  21.11.2002              ��������� ������� �� ������ ��� (PVTar)
          --  26.11.2002              ���������� ������ � FREE_SPACE (PVTar)
          --  05.12.2002              ��������� ���������� �� ��� (PVTar)
          --  17.12.2002              ���������� ��������� ���� ����������� �� ��� (PVTar)
          --  04.02.2003              �������� ��������� ������ �� free_space �������� ������ ������ ��� min freespace_id
          --  17.04.2005              ��������� ���� ����� (ATer)
          --  20.04.2005              ������� ����� ��� ��������� �������
          --  20.05.2005              ������� ����� ��� ��������� ������� (�)
          --  21.09.2005              �������� ��� ��������� 27
          --  20.09.2006              �������� ��� ��������� 28
          --  06.12.2006  stargeorge  ��������� ���� rdn_check (������� ������� �� ������� �������� � �� "������ ���������")
          --  16.01.2007  BlackHawk   ��������� ���� AFFAIR_TOT
          --  21.06.2007  maltseva    �������� ��� ��������� 29
          --  10.12.2007  Alois       ��������� ���� (����� ��������, ����, ������) ��� ������� ���������
          --  01.02.2008  BlackHawk   �������� ����� �����: in_lk, rdn_check, r_reg_num, r_reg_date, r_st_dog
          --  23.04.2008  Lvova       ��������� ���� "��� ���������� �������" ��� �������� �� � �����
          --  19.05.2008  BlackHawk   ��������� ��������� ���� RDN_CHECK
          --  23.05.2008  BlackHawk   ��������� ��������� ������ ��� ����� affair_factory_cod � affair_factory, ��� ������� ���������� ������ � AFFAIR
          --  10.06.2008  BlackHawk   ��������� ����� ����� ������� ��� ���
          --  17.06.2008  maltseva    ��������� ���� STAGE
          --  15.09.2008  BlackHawk   ������� ������� ��������� �����
          --  25.09.2008  BlackHawk   ������� ���� dog_period - ���� �������� ��������
          --  01.10.2008  BlackHawk   ������� ��������� ��� (30 ��� ���������)
          --  21.11.2008  AVL         ������� ������ ���� ������ �� � ���������� ����������� ������� �� ���������
          --  01.12.2008  BlackHawk   ������� ��������� �� (31 ��� ���������)
          --  13.02.2009  AVL         ������� ���� ��� �������� �� ��-�� 50
          --  03.03.2009  AVL         ������� ���� ������� ��� ���. �������� � ���������. ����� (����� ������)
          --  14.05.2009  BlackHawk   ������� ��������� ��� � ����
          --  09.07.2009  BlackHawk   ������� ���� B_ZDZ
          --  30.10.2009  Lvova       ��������� ��������� PLAN_TYPE ���� ����� �����-��� �� �������
          --  30.10.2009  Lvova       ��������� ��������� PRIORITET ��������� �����-��� ���������
          --  07.12.2009  Lvova       ������� ���� ��� �����-��� �� �������
          --  11.12.2009  AVL         ������� ����� ���� "�������" �� ������ ���-1179/2009
          --  25.12.2009  Lvova       �������� ��������� ���� order_num, ���. �-��� get_order_num_2(orders.order_id,'NS')
          --  20.05.2010  BlackHawk   ������� ���� r_reject_cause
          --  25.06.2010  BlackHawk   ������� otkaz_date
          --  06.07.2010  BlackHawk   ������� permit_97_num � permit_97_date
          --  19.07.2010  BlackHawk   ������� stand_year
          --  17.08.2010  BlackHawk   �������� ���� o_free (���-445/2010)
          --  29.11.2010  AVL         �� ���-621/2010, ���-637/2010 ������� 5 �����:
          --                          prefect_num, prefect_date, zdz_rp, nd_zdz_rp_creation_date,nd_zdz_rp_last_change
          --  18.03.2011  Anissimova  ��������� ���� "� ��. � �������"
          --  18.05.2011  BlackHawk   ����� ���� mgr_text, mgr_num, registration_date, registration_num
          --                          ������� ���� egrp_num, egrp_date, egrp_date_to
          --  27.05.2011  BlackHawk   ������� ��� ������������ (resolution_type)
          --  01.07.2011  BlackHawk   ������� ���� no_adult_cnt
          --  22.12.2011  BlackHawk   ������� ���� aff_decl_date
          --  18.01.2012  AVB         ������� ���� lastorder_mark
          --  30.01.2012  AVB         ������� ���� order_young (������� ������� ������� �����)
          --  20.03.2012  AVB         ������� ���� agreedate, state_reg_date � state_reg_required
          --  04.04.2012  Anissimova  �������� ���� egrp_arch � egrp_date_arch
          --  10.04.2012  AVB         ������� ���� RSGS_FOND, RSGS_FOND_DATE_FROM, RSGS_FOND_DATE_TO, RSGS_IS_SPEC_FOND
          --  15.06.2012  Ikonnikov   ������� ���� cottage_type
          --  24.07.2012  AVB         ������� ����� ���������� � ������ (���� RSGS_...)
          --  20.10.2012  Gladkov     ��������� ����: cottage_type, sql, sqb, liv_sq, mancomp
          --  12.11.2012 ilonis ������� ����    runpopulated_date,    runpopulated_txt,  runpopulated_id,  runpopulated_name   (������� �����������)
          --  18.12.2012 Ikonnikov   ������� ���� akt_date, enter_akt_date - �� ���� �����-�������� ���������� �� ��
          --  17.12.2012 ilonis ��������� �������������
          --  21.01.2013 ONovikova    �������� ���� need_reg_in_rd_6
          --  22.01.2013 ONovikova    �������� ���� r_st_dog
          --  06.02.2013 ilonis mgr_exchange.tmp_sbs_fl ������� ����  sbs_fl (������� 0-���. ���� 1-��.����) � ������� �������� ������������� ���_����
          --  #Dik21022013   ���������� ���������  '���', '����', '���', '����' ,'���', '���' ����� state_reg_date, agreedate
           --ilonis 12.04.2013 ���,����  ���� stage
           --#28.08.2013 Dik  ���������� ����� (CAUSE_ND,COMMENT_CAUSEOF_ND, DATE_CAUSEOF_ND) �� ������� �� ���������� �������� (���. 1.104)
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
          DECODE (TO_CHAR (orders.new_building_sign), '1', '��', ' '), --Orders.Reason,
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
          DECODE (orders.add_space, 1, '�', '') o_dop,
          DECODE (orders.no_priv, 1, '', '�') o_priv,
          DECODE (orders.order_type,
                  8, '�',
                  9, '�',
                  10, '�',
                  11, '�',
                  12, '�',
                  13, '�',
                  14, '�',
                  15, '�',
                  16, '�',
                  17, '�',
                  21, '�',
                  22, '�',
                  24, '�',
                  32, '�',
                  33, '�',
                  '�')
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
          DECODE (get_order_plan_ny (orders.order_id), 1, '��', '���')
             AS plan_ny,
          get_order_prioritet_year (orders.order_id) prioritet_year,
          SUBSTR (get_factory (orders.rent_department, orders.rent_factory),
                  1,
                  60),
          SUBSTR (get_space_type2 (affair.sq_type, NULL), 1, 5),
          TRUNC (orders.creation_date),
          DECODE (orders.young_family,
                  1, '����',
                  2, '� ����.',
                  '���')
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
             2, '�+�',
             1, '�',
             0, '�',
             '')
             AS pr_fakt,
          TO_CHAR (orders.calculation_date, 'DD.MM.YYYY'),
          DECODE (orders.order_stage,
                  0, '����������� ������ �������',
                  1, '�������� ������ �������',
                  2, '�������')
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
          SUBSTR (get_doc_lk (orders.order_id), 1, 5) AS in_lk,      /*'���'*/
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
             0, '���',
             '��')
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
                        WHEN 3 THEN  '� �� ����������� �� �����'
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
             || ' ��� '
             || MOD (orders.period, 12)
             || ' ���')
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
                1, '��',
                '���'),
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
                WHEN orders.SQ_TYPE = 2 -- ����������          AVB  02.07.2012
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
                WHEN orders.SQ_TYPE = 2 -- ����������          AVB  03.07.2012
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
                WHEN orders.SQ_TYPE = 2 -- ����������          AVB  03.07.2012
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
             1, '��',
             '���')
             AS lastorder_mark,
          DECODE (orders.order_young, 1, '����', '���') AS order_young,
          -- #Dik21022013
          /* --OLD---
                    CASE
                       WHEN TRIM (orders.SER) = '�'
                       THEN
                          TO_DATE (
                             visa.rdn_rep.
                              get_dog_param_by_order (orders.order_id, 'REG_DATE'),
                             'dd.mm.yyyy')
                       WHEN TRIM (orders.SER) IN ('���', '����')
                       THEN
                          DECODE (
                             get_order_agree_info (orders.order_id, 2),
                             NULL, TO_DATE (
                                      visa.rdn_rep.
                                       get_dog_param_by_order (orders.order_id,
                                                               'REG_DATE'),
                                      'dd.mm.yyyy'),
                             get_order_agree_info (orders.order_id, 2))
                       WHEN TRIM (orders.SER) = '���'
                       THEN
                          TO_DATE (get_order_agree_info (orders.order_id, 2),
                                   'dd.mm.yyyy')
                       ELSE
                          orders.agreement_date
                    END
                       AS agreedate,
                    DECODE (
                       TRIM (orders.SER),
                       '���', get_order_agree_info (orders.order_id, 4),
                       '���', get_order_agree_info (orders.order_id, 4),
                       '����', get_order_agree_info (orders.order_id, 4),
                       '�', TO_DATE (
                                get_apartment_rgs_1 (
                                   get_order_apart_id (orders.order_id,
                                                       orders.document_type),
                                   'DATE_TO'),
                                'dd.mm.yyyy'),
                       orders.state_reg_date)
                       AS state_reg_date,
   =======NEW =======*/
          CASE
             WHEN TRIM (orders.SER) = '�' THEN
                TO_DATE (visa.rdn_rep.get_dog_param_by_order (orders.order_id, 'REG_DATE'), 'dd.mm.yyyy')
             WHEN TRIM (orders.SER) IN ('���', '����', '���', '����') THEN
                 CASE (SELECT COUNT (*) AS a FROM agreement ag WHERE ag.order_id = orders.order_id and ag.agreement_date is not NULL)
                   WHEN 0 THEN
                      TO_DATE ( visa.rdn_rep.get_dog_param_by_order (orders.order_id,'REG_DATE'),'dd.mm.yyyy')
                   ELSE
                      (SELECT ag.agreement_date FROM agreement ag WHERE ag.order_id = orders.order_id AND ROWNUM = 1)
                END
             WHEN TRIM (orders.SER) IN ('���', '���') THEN
                  ( SELECT oed.data_d --���� ������ ����� �� ���2
                  FROM orders_ext_data oed, orders_ext_data oed1
                  WHERE    oed.order_id = orders.order_id
                        AND oed.order_id=oed1.order_id
                        and oed.data_version = 0
                        and oed1.data_version = oed.data_version
                        and oed1.data_type_id =28 --������� - ����� ����� �� ���2
                        AND NVL(oed1.DATA_N,-1) = 0 --����� ����� �� ���2='��������'
                        and oed.data_type_id =60  --������� -���� ������ ����� �� ���2
                        and rownum=1 )
             ELSE
                orders.agreement_date
          END
             AS agreedate,
          CASE
             WHEN TRIM (orders.SER) = '�' THEN
                TO_DATE ( get_apartment_rgs_1(get_order_apart_id (orders.order_id, orders.document_type),'DATE_TO'),'dd.mm.yyyy')
             WHEN TRIM (orders.SER) IN ('���', '����', '���', '����') THEN
                (SELECT ag.registration_date FROM agreement ag WHERE ag.order_id = orders.order_id AND ROWNUM = 1)
             WHEN TRIM (orders.SER) IN ('���', '���') THEN
                TO_DATE (get_apartment_rgs_1 ( get_order_apart_id (orders.order_id, orders.document_type), 'DATE_TO'), 'dd.mm.yyyy')
             ELSE
                orders.state_reg_date
          END
             AS state_reg_date,
          -- / #Dik21022013
          CASE
             WHEN TRIM (orders.SER) IN ('�', '���', '����', '���')
             THEN
                '��'
             ELSE
                '���'
          END
             AS state_reg_required,
          TO_CHAR (affair.OCCUPY_NUM) AS kpu_room_cnt,
          addr_all_kpu_info (affair.affair_id, affair.affair_stage, 1)
             AS other_affair_open,
          addr_all_kpu_info (affair.affair_id, affair.affair_stage, 2)
             AS other_affair_close,
          DECODE (
             get_apartment_mgr_1 (get_order_freespace (orders.order_id)),
             1, '���.',
             2, '���.',
             NULL)
             AS egrp_arch,
          TRUNC (get_apartment_mgr_2 (get_order_freespace (orders.order_id)))
             AS egrp_date_arch,
          DECODE (
             get_sbs_fl (
                Get_ORDER_APART_ID (orders.order_id, orders.document_type)),
             0, '��',
             1, '��',
             NULL)
             AS sbs_fl,                           -- ������������� ������� ���
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
                '���.'
             WHEN 2
             THEN
                '���.'
             WHEN 3
             THEN
                '���.'
             WHEN 6
             THEN
                '���/���'                            --17.12.2012 ilonis
             WHEN 7
             THEN
                '��'                                     --06.02.2013 ilonis
             WHEN 8
             THEN
                '��'                                     --06.02.2013 ilonis
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
--#28.08.2013 Dik   - ����� ��  apartment ���� � ��������� ������. ��������           
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
