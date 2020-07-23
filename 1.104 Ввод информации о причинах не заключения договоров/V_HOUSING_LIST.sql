CREATE OR REPLACE VIEW V_HOUSING_LIST
(okrug_id, name, address, affair_id, inspector, type, sqi, sqo_a, apartment_num, condition, user_id, list_cod, list_num, note, apart_id, read_only, status_bti, rooms_number, res, instr_num, instr_date, certif_num, certif_date, newb, storey, last_change, storey_b, sqo, s_delivery, s_calculation, factory, factory_cod, fund, input_date, input_okrug, order_num, order_num2, order_ser, order_date, street_name, building_num, building_idx, house_num, house_idx, construction_num, construction_idx, p_space, instruction_dir, instruction_who, f12, f12_date, msk, msk_date, order_creation_date, p8, sgs, sgs_date, sgs_date_to, real_instr_num, real_instr_date, real_f4_who, real_instr_dir, real_target, instr_target, address_sh, real_instr_s_delivery, remaind_year, reason, order_direction, pr_fakt, otkl, instr_year, order_year, expl_ser, expl_etazh, expl_pl_common, exlp_pl_living, balance_factory, zdg1, total_space, living_space, bp1, f12_fund, f12_deliv, f12_pnz, exlp_kv_count, opd_kpi, cp_num, zdz, addr_s, invalid_carr, b_mokrug, r1_num, r1_date, order_calc_date, order_person_master, total_space_wo, order_prioritet, order_plan_type, year_realiz, d_pf, otkl_pf, bld_type, cottage, unom, fund_owner, ap_zak, order_res_num, order_res_date, rf_in_okrug, rf_in_dep, out_f_name, out_f_p8, out_i_num, out_i_date, mgsn_num, mgsn_date, order_stage, factory_okrug, factory_status, bti_ppl, bti_opl, bti_gpl, bti_sumpl, ap_id, prefect_num, prefect_date, zdz_rp, nd_zdz_rp_creation_date, nd_zdz_rp_last_change, last_z_order_num, last_z_order_ser, last_z_order_date, last_z_order_year, last_z_order_s_calc, f4last10_11n, f4last10_11d, f4first10_dep_n, f4first10_dep_d, f4first10_dep_r, f4first10_dep_dir, f4first10_dep_targ, egrp_num, egrp_date, egrp_date_to, egrp_arch, egrp_date_arch, rf_freespace, newb_num, newb_year, r_st_dog, r_dog_num, r_dog_date, r_reject_cause, r_reg_date, last_addr_rec, order_person_cnt, order_order_type, order_end_affair, order_new_addr, order_add_square, agree_num, agree_date, agree_reg_num, agree_reg_date, agreedate, state_reg_date, state_reg_required, sbs_fl, rsgs_fond, rsgs_fond_date_from, rsgs_fond_date_to, rsgs_is_spec_fond, rsgs_fond_out, sbs_total, no_adult_cnt, order_affair_addr, order_affair_kv, order_s_calculation, mancomp, basis, addenum, selftrapping, runpopulated_date, runpopulated_txt, runpopulated_id, runpopulated_name, akt_date, enter_akt_date, need_reg_in_rd_3, tp_exists, ur_territory, ur_rasporyadytel, ur_direction, ur_period_for_implement, prog_group, cause_nd, comment_causeof_nd, date_causeof_nd, tp_regdate, tp_to_wp, tp_doc_date, tp_doc_num, tp_status)
AS
SELECT                                                          /*- RULE */
          --
          --  30.07.1999             ��������� ����
          --  04.08.1999             ��������� ��� ���� � ����� ������
          --  08.09.1999             ��������� ����� ������� ����������� ��������� ������� �� ���
          --  03.12.1999             ��������� ���� ����� � ����
          --  06.12.1999             ��������� ���� ����� ����� � ����
          --  25.01.2000             ��������� �����
          --  20.03.2000             ���������� ������� �� ���� ��� ������� ����� ������� ��������
          --  03.05.2000             ��������� ���� ����
          --  03.05.2000             ��������� ���� �������������
          --  03.05.2000             �������� ��� �������������
          --  06.09.2000             ��������� ����� ������ � ���� ������
          --  23.07.2001             ������� ���� �����������
          --  10.10.2001             ��������� ���� ����������� �������������
          --  21.11.2001             ������� �������� ������ �12
          --  28.01.2002  PVTar      ��������� ������� ���
          --  21.03.2002  PVTar      ��������� ��������� ������� � ��� ������� ���� � ������; ��������� ���� ����� �������"
          --  27.05.2002  PVTar      ��������� ������� ��� � ����_���, ���� �������� ������
          --  13.06.2002  PVTar      ������� P8
          --  21.10.2002  PVTar      �������� ���������� ��� �������
          --  21.10.2002  PVTar      ������� 17 ��� ���������
          --  24.11.2003  frolov     ��������� ����
          --  02.02.2004  frolov     ��������� ���� f12_date
          --  09.08.2004  Bfink      ���������� ���� ����� ������� ��� ��
          --  20.05.2005  Bfink      �������� ������ ����
          --  24.05.2005  Bfink      ������� ������� �� MGR_LICENSE �� BUILDING_ID
          --  21.10.2005             �������� 27 ��� ���������
          --  12.12.2005  bfink      ��������� ��� ��
          --  13.02.2006  BlackHawk  ������� ���� ���-�� ������� � ���� - exlp_kv_count
          --  28.04.2006  Avl        ��������� ���� ��������� ���������"
          --  13.07.2006  BlackHawk  ��������� ������� mgr_l.cancel_date(+) IS NULL
          --  13.07.2006  BlackHawk  ����� ���������� � ��������� mgr_licences, �.�. ������ �� �� �� ��������, � ���������� �� �/� �� ������
          --  11.08.2006             ��������� ���� ���� ������ ��������� (Avl), ��� zdg1, bp1 �������� instruction.new_building_code �� free_space.new_building_code
          --  23.08.2006  Avl        ��������� ���� ����� ������������ �/�"
          --  21.09.2006             �������� 28 ��� ���������
          --  29.12.2006             ��������� ������� � ����������� ���. ��������� �������� ���� ���. �������� � ���. �-�� get_cp_year
          --  10.04.2007  BlackHawk  ������� ���� invalid_carr (��������-�����������)
          --  20.06.2007  maltseva   �������� ��� 29 (���)
          --  14.08.2007  BlackHawk  ������� b_mokrug - ���. ����� ��� ������
          --  14.03.2008  BlackHawk  ������� order_calc_date - ���� ����� �������
          --  19.03.2008  BlackHawk  ������� order_prioritet � order_plan_type
          --  23.04.2008  Lvova      ��������� ���� ��� ���������� ������� ��� �������� �� � ���
          --  07.05.2008  BlackHawk  ��������� ���� total_space_wo
          --  21.11.2008  AVL        ������� ������ ���� ������ �� � ���������� ����������� ������� �� ���������
          --  13.02.2009  AVL        ������� ���� ��� ��������
          --  03.03.2009  AVL        ������� ���� ������� ��� ���. ��������
          --  25.06.2009  BlackHawk  ��������� ������ ������ �����: zdg1, zdz, registration_date, f12_date
          --  11.12.2009  AVL        ������� ����� ���� "�������" �� ������ ���-1179/2009
          --  31.12.2009  Lvova      �������� ��������� ���� order_num, ���. �-��� get_order_num_2(free_space.doc2_num,'NN')
          --                         � order_ser, ���. �-��� get_order_num_2(free_space.doc2_num,'SS')  (free_space.doc2_num = order_id)
          --  19.01.2010  BlackHawk  ������ � ���� cottage ��������� �������� �� 58 ��������������
          --  17.03.2010  BlackHawk  ��������� �� ������� "������" ���������� "�� ������� ��"
          --  05.04.2010  BlackHawk  ������� ���� UNOM
          --  03.06.2010  BlackHawk  ������� ����: fund_owner � ap_zak
          --  08.06.2010  BlackHawk  ������� ����: order_res_num � order_res_date
          --                         ��������� ������� ��� order_calc_date
          --  10.06.2010  BlackHawk  ������� ����: out_f_name, out_f_p8, out_i_num, out_i_date
          --  05.08.2010  BlackHawk  ������� ����: mgsn_num � mgsn_date
          --  06.08.2010  BlackHawk  ������� ����: order_stage
          --  20.08.2010  BlackHawk  ������� ����: factory_okrug
          --  28.09.2010  BlackHawk  ������� ����: bti_ppl, bti_opl, bti_gpl, bti_sumpl
          --  23.11.2010  BlackHawk  ������� ����: ap_id (��� ������ �� ������ �����)
          --  29.11.2010  AVL        �� ���-621/2010, ���-637/2010 ������� 5 �����:
          --                         prefect_num, prefect_date, zdz_rp, nd_zdz_rp_creation_date,nd_zdz_rp_last_change
          --  17.03.2011  AVL        �� ���-143 ��������� ����� ����� ���� �� �������� � �� ����������
          --  21.03.2011  AVL        ���-56/2011  ������� F4LAST10_11N, F4LAST10_11D, F4FIRST10_DEP_N, F4FIRST10_DEP_D,
          --                         F4FIRST10_DEP_R, F4FIRST10_DEP_DIR, F4FIRST10_DEP_TARG
          --  25.03.2011  BlackHawk  ��������� ���� UNOM �������� �� ���� ������� BUILDING
          --  15.04.2011  BlackHawk  ������� substr-� � ��������� ������ ����� � ���������
          --  18.05.2011  BlackHawk  ����� ���� mgr_text � registration_date
          --                         ������� ���� egrp_num, egrp_date, egrp_date_to
          --  24.09.2011  BlackHawk  ������ �� ��������� ���� egrp_num � egrp_date
          --  28.09.2011  BlackHawk  ������� ���� egrp_arch � egrp_date_arch
          --  29.09.2011  BlackHawk  ������� ���� rf_freespace
          --  04.10.2011  BlackHawk  ������� ���� newb_num � newb_year
          --  18.11.2011  BlackHawk  ������� ���� r_st_dog, r_dog_num, r_dog_date, r_reject_cause, r_reg_date
          --  24.11.2011  BlackHawk  ������� ���� last_addr_rec
          --  08.12.2011  BlackHawk  ������� ���� order_person_cnt
          --  26.12.2011  BlackHawk  ������� ���� order_order_type, order_end_affair, order_new_addr � order_add_square
          --  19.01.2012  BlackHawk  ������� ���� agree_num, agree_date, agree_reg_num, agree_reg_date
          --  20.03.2012  AVB        ������� ���� agreedate, state_reg_date, state_reg_required
          --  06.04.2012  Anissimova �������� ���� SBS_FL  -- ������������� ������� ��� - ���_��
          --  10.04.2012  AVB        ������� ���� RSGS_FOND, RSGS_FOND_DATE_FROM, RSGS_FOND_DATE_TO, RSGS_IS_SPEC_FOND
          --  12.04.2012  Ikonnikov  ������� ���� sbs_total
          --  14.06.2012  Ikonnikov  ������� ����������� ��� ���� Cottage
          --  24.07.2012  AVB        ������� ����� ���������� � ������ (���� RSGS_...)
          --  26.08.2012  Ikonnikov  ��������� ���� order_s_calculation -- ������ ����� �� �������
          --  20.09.2012  Ikonnikov  ������� ���� "���. ��������" (basis) � "���. ��������" (addenum) �� INSTRUCTION (�� ������� ����������� ��)
          --  12.11.2012 ilonis      ������� ����    runpopulated_date,    runpopulated_txt,  runpopulated_id,  runpopulated_name   (������� �����������)
          --  18.12.2012 Ikonnikov   ������� ���� akt_date, enter_akt_date - �� ���� �����-�������� ���������� �� ��
          --  17.12.2012 ilonis ��������� �������������
          --  21.01.2013 ONovikova   �������� ���� need_reg_in_rd_3
          --  22.01.2013 ONovikova    �������� ���� r_st_dog
          --  06.02.2013 ilonis mgr_exchange.tmp_sbs_fl ������� ����  sbs_fl (������� 0-���. ���� 1-��.����) � ������� �������� ������������� ���_����
          --22.02.2013 ilonis ������� ������� �����������
          --
          --  #Dik21022013 ���������� ���������  '���', '����', '���', '����' ,'���', '���' ����� state_reg_date, agreedate
          --  #Dik_09.04.2013 ������� ���� ur_territory,ur_rasporyadytel,ur_direction,ur_period_for_implement             +
          --ilonis 12.04.2013 ���,����  ���� order_stage
          --16.07.2013 ilonis --������� prog_group ���������� �� ��������
          --18.07.2013 ilonis �� ������������ � ����������� ����� � bp1 ��������� ��������
          --#12.08.2013 Dik  ���������� ����� (CAUSE_ND,COMMENT_CAUSEOF_ND, DATE_CAUSEOF_ND) �� ������� �� ���������� �������� (���. 1.104)
          --#19.08.2013 onovikova  ���������� ����� (TP_REGDATE, TP_TO_WP, TP_DOC_DATE, TP_DOC_NUM, TP_STATUS) #������ 1.93

          building.area,
          SUBSTR (get_okrug_sh (building.area), 1, 200),
          SUBSTR (
             addr_apartment (free_space.building_id, free_space.apart_id),
             1,
             200),                                      --Free_space.Apart_Id,
          free_space.freespace_id,
          SUBSTR (get_inspector (free_space.inspector, free_space.okrug_id),
                  1,
                  50),               -- ����������� �� ������� �.�. 21.06.2011
          DECODE (TO_CHAR (free_space.space_type), '1', '�/�', '�/�'),
          DECODE (free_space.living_sq,
                  0, ' ',
                  TO_CHAR (free_space.living_sq, 'FM99990.0')),
          DECODE (apartment.total_space,
                  0, ' ',
                  TO_CHAR (apartment.total_space, 'FM99990.0')),
          apartment.apartment_num,
          SUBSTR (get_fstatus (free_space.status), 1, 200),
          housing_list.user_id,
          housing_list.list_cod,
          housing_list.list_num,
          housing_list.note,
          free_space.apart_id, --decode(Get_Read_Only(3,free_space.FREESPACE_ID),0,
          DECODE (free_space.status,
                  7, 131,
                  get_read_only (3, free_space.freespace_id)),
          SUBSTR (get_status_bti_sh (free_space.apart_id), 1, 60),
          free_space.rooms_number,
          DECODE (free_space.new_building_code,
                  0, '�/�',
                  NULL, '�/�',
                  '�/�')
             res, --DECODE(FREE_SPACE.DOC_TYPE,1,'����.� '||to_char(free_space.doc_num),' ') instr_num,
          DECODE (free_space.doc_type, 1, TO_CHAR (free_space.doc_num), ' ')
             instr_num,
          DECODE (free_space.doc_type,
                  1, TRUNC (free_space.document_date),
                  NULL)
             instr_date,
          DECODE (free_space.doc_type,
                  2, TO_CHAR (get_certif_num (free_space.doc_num)),
                  3, TO_CHAR (get_certif_num (free_space.doc_num)),
                  ' ')
             certif_num,
          DECODE (free_space.doc_type,
                  2, TRUNC (free_space.document_date),
                  3, TRUNC (free_space.document_date),
                  NULL)
             AS certif_date,
          SUBSTR (get_new_building_code_1 (free_space.new_building_code),
                  1,
                  49)
             AS newb, --DECODE(FREE_SPACE.NEW_BUILDING_CODE,0,' ',NULL,' ',building.BUILDING_YEAR||' - '||to_char(FREE_SPACE.NEW_BUILDING_CODE,'99999')) newb,
          apartment.room_storey_num AS storey, --to_char(free_space.LAST_CHANGE,'dd.mm.yyyy'),
          free_space.last_change,
          get_storey_build (free_space.building_id),
          TO_CHAR (
             DECODE (
                free_space.space_type,
                1, apartment.total_space,
                DECODE (
                   apartment.living_space,
                   0, 0,
                   (apartment.total_space * free_space.living_sq)
                   / apartment.living_space)),
             'FM99990.0'),
          SUBSTR (
             DECODE (free_space.doc_type,
                     1, get_s_delivery_instr (free_space.doc_num),
                     ' '),
             1,
             40),
          SUBSTR (
             DECODE (free_space.doc_type,
                     1, get_s_calculation_instr (free_space.doc_num),
                     ' '),
             1,
             40),
          SUBSTR (
             get_factory_name_sh (free_space.department,
                                  free_space.num_in_department),
             1,
             80)
             AS factory,
          TO_CHAR (
             free_space.department * 1000 + free_space.num_in_department,
             '000000')
             AS factory_cod,
          SUBSTR (
             DECODE (get_freespace_fond_sh3 (free_space.doc_num),
                     '', ' ',
                     get_freespace_fond_sh3 (free_space.doc_num)),
             1,
             50),
--------------------------------------------------------------------
           --16.07.2013 ilonis --���������� �� ��������
             trunc(get_freespace_certif_Enter_D(free_space.freespace_id)) as input_date ,
          --DECODE (free_space.doc_type,
            --      2, TRUNC (get_certif_indate (doc_num)),
              --    3, TRUNC (get_certif_indate (doc_num)),
               --   NULL)
            --- AS input_date,
            get_freespace_certif_okrug (free_space.freespace_id)  as input_okrug,
          --DECODE (free_space.doc_type,
            --      2, SUBSTR (get_okrug_sh (free_space.okrug_id), 1, 20),
            --      3, SUBSTR (get_okrug_sh (free_space.okrug_id), 1, 20),
            --      NULL)
            -- AS input_okrug,
-------------------------------------------------------------------
          SUBSTR (get_order_num_2 (free_space.doc2_num, 'NN'), 1, 10) ||' '||free_space.doc2_num
             AS order_num,
          free_space.doc2_num AS order_num2,
          SUBSTR (get_order_num_2 (free_space.doc2_num, 'SS'), 1, 10)
             AS order_ser,
          SUBSTR (
             DECODE (
                is_document_order (free_space.doc2_num, free_space.doc2_type),
                1, get_order_date (free_space.doc2_num),
                NULL),
             1,
             30)
             AS order_date,
          street.full_name,
          building.building_num,
          building.building_idx,
          building.house_num,
          building.house_idx,
          building.construction_num,
          building.construction_idx,
          get_bti_total_space_1 (apartment.apart_id),
          SUBSTR (
             get_instruction_dir_sh (
                DECODE (free_space.doc_type,
                        1, TO_CHAR (free_space.doc_num),
                        NULL)),
             1,
             200)
             AS instruction_dir,
          SUBSTR (
             get_instruction_factory_who (
                DECODE (free_space.doc_type,
                        1, TO_CHAR (free_space.doc_num),
                        NULL)),
             1,
             200)
             AS instruction_who,

          SUBSTR (get_freespace_certif_num (free_space.freespace_id), 1, 30)
             AS f12,
          TRUNC (get_freespace_certif_date (free_space.freespace_id))
             AS f12_date,
          DECODE (get_apartment_mgr_3 (apartment.building_id,
                                       apartment.apart_id,
                                       apartment.apartment_num,
                                       apartment.apartment_idx,
                                       1),
                  1, '���',
                  '')
             AS msk,
          get_apartment_mgr_4 (apartment.building_id,
                               apartment.apart_id,
                               apartment.apartment_num,
                               apartment.apartment_idx,
                               1)
             AS msk_date,
          DECODE (
             is_document_order (free_space.doc2_num, free_space.doc2_type),
             1, get_order_creation_date (free_space.doc2_num),
             NULL)
             AS order_creation_date, --substr(get_fund(free_space.fund),1,50) fund
          get_factory_p8 (free_space.department,
                          free_space.num_in_department)
             AS p8,
          --   , DECODE(mgr_l.registration_code, NULL, '-', '���.') SGS
          --   , mgr_l.registration_date sgs_date
          -- ,SUBSTR (get_apartment_rgs_1 (apartment.apart_id, 'APR_STATUS'), 1, 10) AS sgs
          SUBSTR (
             CASE
                WHEN apartment.SPACE_TYPE = 2
                THEN                    -- ����������          AVB  02.07.2012
                   NVL (
                      get_apartment_owner_rgs_doc (
                         NVL (free_space.doc2_num, free_space.doc_num),
                         NVL (free_space.doc2_type, free_space.doc_type)),
                      get_apartment_rgs_1 (apartment.apart_id, 'APR_STATUS'))
                ELSE
                   get_apartment_rgs_1 (apartment.apart_id, 'APR_STATUS')
             END,
             1,
             10)
             AS sgs,
          -- DECODE (INSTR (get_apartment_rgs_1 (apartment.apart_id, 'DATA'), '��'),  NULL, '-',  0, '���.',  '-') as sgs
          --,TO_DATE (get_apartment_rgs_1 (apartment.apart_id, 'DATE_FROM'), 'dd.mm.yyyy') AS sgs_date
          --,TO_DATE (get_apartment_rgs_1 (apartment.apart_id, 'DATE_TO'), 'dd.mm.yyyy') AS sgs_date_to
          TO_DATE (
             CASE
                WHEN apartment.SPACE_TYPE = 2
                THEN                    -- ����������          AVB  02.07.2012
                   NVL (
                      get_apartment_owner_rgs_doc (
                         NVL (free_space.doc2_num, free_space.doc_num),
                         NVL (free_space.doc2_type, free_space.doc_type),
                         'DATE_FROM'),
                      get_apartment_rgs_1 (apartment.apart_id, 'DATE_FROM'))
                ELSE
                   get_apartment_rgs_1 (apartment.apart_id, 'DATE_FROM')
             END,
             'dd.mm.yyyy')
             AS sgs_date,
          TO_DATE (
             CASE
                WHEN apartment.SPACE_TYPE = 2
                THEN                    -- ����������          AVB  02.07.2012
                   NVL (
                      get_apartment_owner_rgs_doc (
                         NVL (free_space.doc2_num, free_space.doc_num),
                         NVL (free_space.doc2_type, free_space.doc_type),
                         'DATE_TO'),
                      get_apartment_rgs_1 (apartment.apart_id, 'DATE_TO'))
                ELSE
                   get_apartment_rgs_1 (apartment.apart_id, 'DATE_TO')
             END,
             'dd.mm.yyyy')
             AS sgs_date_to,
          instruction.instruction_num AS real_instr_num,
          instruction.instruction_date AS real_instr_date,
          SUBSTR (
             get_factory_name_sh (instruction.department_who,
                                  instruction.num_in_department_who),
             1,
             25)
             AS real_f4_who,
          SUBSTR (get_direction_sh (instruction.direction), 1, 3)
             AS real_instr_dir,
          SUBSTR (
             get_target (instruction.direction, instruction.target, 'SH'),
             1,
             25)
             AS real_target,
          SUBSTR (
             DECODE (free_space.doc_type,
                     1, get_instruction_target (free_space.doc_num, 'SH'),
                     NULL),
             1,
             25)
             AS instr_target,
          SUBSTR (
             addr_apartment (free_space.building_id, free_space.apart_id, 1),
             1,
             200)
             AS address_sh,
          SUBSTR (get_s_delivery (instruction.s_delivery), 1, 60)
             AS real_instr_s_delivery,
          free_space.remaind_year AS remaind_year,
          --ka.balance_year
          SUBSTR (
             DECODE (
                is_document_order (free_space.doc2_num, free_space.doc2_type),
                1, get_order_reason3a (free_space.doc2_num),
                NULL),
             1,
             35)
             AS reason,
          SUBSTR (
             DECODE (
                is_document_order (free_space.doc2_num, free_space.doc2_type),
                1, get_order_direction (free_space.doc2_num),
                NULL),
             1,
             5)
             AS order_direction,
          DECODE (get_apart_proekt_fakt_2 (free_space.freespace_id),
                  2, '�+�',
                  1, '�',
                  0, '�',
                  '')
             AS pr_fakt,
          ka.otkl,
          instruction.year AS instr_year,
          get_order_year_2 (doc2_num, doc2_type) AS order_year,
          --,SUBSTR (get_classifier (29, xn.zser), 1, 80) AS expl_ser
          SUBSTR (
             get_classifier (
                29,
                DECODE (
                   NVL (1, 0),
                   0, TO_CHAR (NULL),
                   DECODE (
                      NVL (xn.project, 0),
                      0, xn.zser,
                      1, DECODE (
                            NVL (get_xns_zser (kursiv.get_link_zsn (xn.zsn)),
                                 0),
                            0, xn.zser,
                            get_xns_zser (kursiv.get_link_zsn (xn.zsn)))))),
             1,
             80)
             AS expl_ser,
          xn.zet AS expl_etazh,
          xn.zpk AS expl_pl_common,
          xn.zpi AS exlp_pl_living,
          SUBSTR (
             get_factory_name_sh (
                DECODE (free_space.new_building_code,
                        NULL, NULL,
                        ka.balance_department),
                DECODE (free_space.new_building_code,
                        NULL, NULL,
                        ka.balance_factory)),
             1,
             25)
             AS balance_factory,
          DECODE (NVL (free_space.new_building_code, 0),
                  0, TO_DATE (NULL),
                  DECODE (xn.zdg, NULL, TO_DATE (NULL), TRUNC (xn.zdg)))
             AS zdg1,
          TO_CHAR (kursiv.get_total_space_building (free_space.building_id),
                   'FM99999990.0')
             AS total_space,
          TO_CHAR (kursiv.get_living_space_building (free_space.building_id),
                   'FM99999990.0')
             AS living_space,
           --18.07.2013 ilonis �� ������������ � ����������� ����� � bp1 ��������� ��������
          SUBSTR (
             DECODE (
                NVL (free_space.new_building_code, 0),
                0,  '�/�',--'�.�.',
                DECODE (NVL (xn.prog_building, 0),
                        0,'�/�',-- '�� ���.',
                        get_classifier_h3 (23, xn.prog_building))),
             1,
             10)
             AS bp1,
          -- avl ���

          SUBSTR (
             DECODE (free_space.doc_type,
                     2, get_certif_info1 (free_space.doc_num, 0),
                     3, get_certif_info1 (free_space.doc_num, 0),
                     ' '),
             1,
             35)
             AS f12_fund,
          SUBSTR (
             DECODE (free_space.doc_type,
                     2, get_certif_info1 (free_space.doc_num, 1),
                     3, get_certif_info1 (free_space.doc_num, 1),
                     ' '),
             1,
             35)
             AS f12_deliv,
          SUBSTR (
             DECODE (free_space.doc_type,
                     2, get_certif_info1 (free_space.doc_num, 2),
                     3, get_certif_info1 (free_space.doc_num, 2),
                     ' '),
             1,
             35)
             AS f12_pnz                                             -- avl ���
                       ,
          xn.zkwq AS exlp_kv_count,
          get_opd_kpi (free_space.apart_id, 3) AS opd_kpi,
          --        ,SUBSTR (get_classifier_kurs3 (108, fcp1.cp_num, 'SN2'), 1, 100) AS cp_num
          --         ,SUBSTR (get_cp_year (fcp1.cp_num) || ' ' || get_classifier_kurs3 (108, fcp1.cp_num, 'SN2'), 1, 100) AS cp_num
          SUBSTR (
                fcp1.set_year
             || ' '
             || get_classifier_kurs3 (108, fcp1.cp_num, 'SN2'),
             1,
             100)
             AS cp_num,
          --DECODE (NVL (free_space.new_building_code, 0), 0, '�.�.', DECODE (xn.zdz, NULL, '�� ���.', TO_CHAR (xn.zdz, 'DD.MM.YYYY')))
          DECODE (
             NVL (free_space.new_building_code, 0),
             0, TO_DATE (NULL),
             TRUNC (
                DECODE (
                   DECODE (
                      NVL (xn.project, 0),
                      0, xn.zdz,
                      1, DECODE (
                            get_xns_zdz_2 (xn.zsn),
                            NULL, get_xns_zdz_2 (
                                     kursiv.get_link_zsn (xn.zsn)),
                            get_xns_zdz_2 (xn.zsn))),
                   NULL, TO_DATE (NULL),
                   DECODE (
                      NVL (xn.project, 0),
                      0, xn.zdz,
                      1, DECODE (
                            get_xns_zdz_2 (xn.zsn),
                            NULL, get_xns_zdz_2 (
                                     kursiv.get_link_zsn (xn.zsn)),
                            get_xns_zdz_2 (xn.zsn))))))
             AS zdz,
          SUBSTR (kursiv.get_xns_addr (xn.zsn, xn.addr_id_s), 1, 100)
             AS addr_s,
          DECODE (apartment.invalid_carr, 1, '��', '���')
             AS invalid_carr,
          SUBSTR (get_building_mokrug (free_space.building_id), 1, 25)
             AS b_mokrug,
          get_freespace_r1_p8_30 (free_space.freespace_id,
                                  free_space.apart_id,
                                  free_space.doc_num)
             AS r1_num,
          get_freespace_r1d_p8_30 (free_space.freespace_id,
                                   free_space.apart_id,
                                   free_space.doc_num)
             AS r1_date,
          TRUNC (
             get_order_c_date (free_space.doc2_num, free_space.doc2_type))
             AS order_calc_date,
          SUBSTR (
             DECODE (
                is_document_order (free_space.doc2_num, free_space.doc2_type),
                1, get_person2 (free_space.doc2_num),
                NULL),
             1,
             50)
             AS order_person_master,
          TO_CHAR (NVL (ka.total_space_wo_real, ka.total_space_wo),
                   'FM99990.0')
             AS total_space_wo,
          SUBSTR (
             DECODE (
                is_document_order (free_space.doc2_num, free_space.doc2_type),
                1, get_order_prioritet (free_space.doc2_num),
                NULL),
             1,
             25)
             AS order_prioritet,
          SUBSTR (
             DECODE (
                is_document_order (free_space.doc2_num, free_space.doc2_type),
                1, get_order_plan_type (free_space.doc2_num, 'SN2'),
                NULL),
             1,
             25)
             AS order_plan_type,
          get_order_year_realiz (free_space.freespace_id,
                                 free_space.doc2_num)
             AS year_realiz,
          SUBSTR (get_dc_xns3 (NVL (free_space.new_building_code, 0)), 1, 10)
             AS d_pf,
          DECODE (NVL (free_space.new_building_code, 0),
                  0, TO_NUMBER (NULL),
                  get_otkl_fs (free_space.freespace_id))
             AS otkl_pf,
          SUBSTR (get_classifier_h2 (50, building_type), 1, 15) AS bld_type,
          --        ,SUBSTR (get_classifier_h3 (58, building.cottage), 1, 4) AS cottage
          SUBSTR (get_classifier_h2 (58, building.cottage), 1, 14) AS cottage,
          DECODE (
             NVL (building.bti_unom, 0),
             0, TO_NUMBER (NULL),
             DECODE (
                SIGN (building.bti_unom - 90000),
                1, DECODE (SIGN (100000 - building.bti_unom),
                           1, TO_NUMBER (NULL),
                           building.bti_unom),
                building.bti_unom))
             AS unom,
          kiv_get_fund_owner_from_apart (apartment.apart_id) AS fund_owner,
          needy_apart.needy AS ap_zak,
          SUBSTR (
             get_order_resolution_num (free_space.doc2_num,
                                       free_space.doc2_type),
             1,
             15)
             AS order_res_num,
          get_order_resolution_date (free_space.doc2_num,
                                     free_space.doc2_type)
             AS order_res_date,
          get_fs_rf_days (free_space.freespace_id, 1) AS rf_in_okrug,
          get_fs_rf_days (free_space.freespace_id, 2) AS rf_in_dep,
          SUBSTR (
             DECODE (
                free_space.doc2_type,
                1, get_freespace_out_data (free_space.freespace_id,
                                           'FACTORY_NAME_SH'),
                ''),
             1,
             25)
             AS out_f_name,
          SUBSTR (
             DECODE (
                free_space.doc2_type,
                1, get_freespace_out_data (free_space.freespace_id,
                                           'FACTORY_P8'),
                ''),
             1,
             5)
             AS out_f_p8,
          SUBSTR (
             DECODE (
                free_space.doc2_type,
                1, get_freespace_out_data (free_space.freespace_id,
                                           'INSTRUCTION_NUM'),
                ''),
             1,
             25)
             AS out_i_num,
          TO_DATE (
             DECODE (
                free_space.doc2_type,
                1, get_freespace_out_data (free_space.freespace_id,
                                           'INSTRUCTION_DATE'),
                ''),
             'dd.mm.yyyy')
             AS out_i_date,
          mgsn_data.mgsn_num || mgsn_data.mgsn_ser AS mgsn_num,
          TO_CHAR (mgsn_data.mgsn_date, 'dd.mm.yyyy') AS mgsn_date,
          SUBSTR (
             DECODE ( is_document_order (free_space.doc2_num, free_space.doc2_type),    --ilonis 12.04.2013
                          1, DECODE (  get_order_stage (free_space.doc2_num), 0, '', -1, '',  -2, '',-3, visa.rdn_rep. get_dog_param_by_order (free_space.doc2_num, 'ORDER_ETAP') , get_classifier_kurs3 ( 115,  get_order_stage (free_space.doc2_num), 'SN1')),
                          NULL),
             1,  60)  AS order_stage,
          SUBSTR (
             get_okrug_sha (
                get_factory_registration_1 (free_space.department,
                                            free_space.num_in_department)),
             1,
             10)
             AS factory_okrug,
          SUBSTR (
             get_classifier_h3 (
                99,
                get_factory_status (free_space.department,
                                    free_space.num_in_department)),
             1,
             5)
             AS factory_status,
          TO_CHAR (
             DECODE (
                free_space.space_type,
                1, bti.
                    get_apart_pl (get_bti_by_apart_unom (apartment.apart_id),
                                  get_bti_by_apart_unkv (apartment.apart_id),
                                  1),
                bti.get_rooms_pl (get_bti_by_apart_unom (apartment.apart_id),
                                  get_bti_by_apart_unkv (apartment.apart_id),
                                  free_space.rooms,
                                  1,
                                  1)),
             'FM9990.9')
             AS bti_ppl,
          TO_CHAR (
             DECODE (
                free_space.space_type,
                1, bti.
                    get_apart_pl (get_bti_by_apart_unom (apartment.apart_id),
                                  get_bti_by_apart_unkv (apartment.apart_id),
                                  2),
                bti.get_rooms_pl (get_bti_by_apart_unom (apartment.apart_id),
                                  get_bti_by_apart_unkv (apartment.apart_id),
                                  free_space.rooms,
                                  1,
                                  2)),
             'FM9990.9')
             AS bti_opl,
          TO_CHAR (
             DECODE (
                free_space.space_type,
                1, bti.
                    get_apart_pl (get_bti_by_apart_unom (apartment.apart_id),
                                  get_bti_by_apart_unkv (apartment.apart_id),
                                  3),
                bti.get_rooms_pl (get_bti_by_apart_unom (apartment.apart_id),
                                  get_bti_by_apart_unkv (apartment.apart_id),
                                  free_space.rooms,
                                  1,
                                  3)),
             'FM9990.9')
             AS bti_gpl,
          TO_CHAR (
             DECODE (
                free_space.space_type,
                1, bti.
                    get_apart_pl (get_bti_by_apart_unom (apartment.apart_id),
                                  get_bti_by_apart_unkv (apartment.apart_id),
                                  4),
                bti.get_rooms_pl (get_bti_by_apart_unom (apartment.apart_id),
                                  get_bti_by_apart_unkv (apartment.apart_id),
                                  free_space.rooms,
                                  1,
                                  4)),
             'FM9990.9')
             AS bti_sumpl,
          free_space.apart_id AS ap_id,
          SUBSTR (
             DECODE (NVL (xn.project, 0),
                     0, TO_CHAR (xn.prefect_num),
                     1, get_pref_num (get_link_zsn (xn.zsn, 0))),
             1,
             15)
             AS prefect_num,
          DECODE (
             NVL (xn.project, 0),
             0, TO_CHAR (xn.prefect_date, 'DD.MM.YYYY'),
             1, TO_CHAR (get_pref_date (get_link_zsn (xn.zsn, 0)),
                         'DD.MM.YYYY'))
             AS prefect_date,
          DECODE (
             NVL (xn.project, 0),
             0, TO_CHAR (xn.zdz_rp, 'DD.MM.YYYY'),
             1, TO_CHAR (get_zdz_rp (get_link_zsn (xn.zsn, 0)), 'DD.MM.YYYY'))
             AS zdz_rp,
          DECODE (
             NVL (xn.project, 0),
             0, TO_CHAR (xn.nd_zdz_rp_creation_date, 'DD.MM.YYYY'),
             1, TO_CHAR (
                   get_nd_zdz_rp_creation_date (get_link_zsn (xn.zsn, 0)),
                   'DD.MM.YYYY'))
             AS nd_zdz_rp_creation_date,
          DECODE (
             NVL (xn.project, 0),
             0, TO_CHAR (xn.nd_zdz_rp_last_change, 'DD.MM.YYYY'),
             1, TO_CHAR (
                   get_nd_zdz_rp_last_change (get_link_zsn (xn.zsn, 0)),
                   'DD.MM.YYYY'))
             AS nd_zdz_rp_last_change,
          SUBSTR (
             DECODE (
                free_space.doc_type,
                1, get_freespace_last_z_order (free_space.freespace_id,
                                               'ORDER_NUM'),
                ''),
             1,
             15)
             AS last_z_order_num,
          SUBSTR (
             DECODE (
                free_space.doc_type,
                1, get_freespace_last_z_order (free_space.freespace_id,
                                               'ORDER_SER'),
                ''),
             1,
             15)
             AS last_z_order_ser,
          SUBSTR (
             DECODE (
                free_space.doc_type,
                1, get_freespace_last_z_order (free_space.freespace_id,
                                               'ORDER_DATE'),
                ''),
             1,
             15)
             AS last_z_order_date,
          SUBSTR (
             DECODE (
                free_space.doc_type,
                1, get_freespace_last_z_order (free_space.freespace_id,
                                               'ORDER_YEAR'),
                ''),
             1,
             15)
             AS last_z_order_year,
          SUBSTR (
             DECODE (
                free_space.doc_type,
                1, get_freespace_last_z_order (free_space.freespace_id,
                                               'ORDER_S_CALC'),
                ''),
             1,
             60)
             AS last_z_order_s_calc,
          SUBSTR (
             DECODE (get_freespace_r10to11 (free_space.freespace_id, 0),
                     '-1', NULL,
                     get_freespace_r10to11 (free_space.freespace_id, 0)),
             1,
             15)
             AS f4last10_11n,
          SUBSTR (
             DECODE (get_freespace_r10to11 (free_space.freespace_id, 1),
                     '-1', NULL,
                     get_freespace_r10to11 (free_space.freespace_id, 1)),
             1,
             15)
             AS f4last10_11d,
          SUBSTR (
             DECODE (get_freespace_r_p11todep (free_space.freespace_id, 0),
                     '-1', NULL,
                     get_freespace_r_p11todep (free_space.freespace_id, 0)),
             1,
             15)
             AS f4first10_dep_n,
          SUBSTR (
             DECODE (get_freespace_r_p11todep (free_space.freespace_id, 1),
                     '-1', NULL,
                     get_freespace_r_p11todep (free_space.freespace_id, 1)),
             1,
             15)
             AS f4first10_dep_d,
          SUBSTR (
             DECODE (get_freespace_r_p11todep (free_space.freespace_id, 2),
                     '-1', NULL,
                     get_freespace_r_p11todep (free_space.freespace_id, 2)),
             1,
             35)
             AS f4first10_dep_r,
          SUBSTR (
             DECODE (get_freespace_r_p11todep (free_space.freespace_id, 3),
                     '-1', NULL,
                     get_freespace_r_p11todep (free_space.freespace_id, 3)),
             1,
             35)
             AS f4first10_dep_dir,
          SUBSTR (
             DECODE (get_freespace_r_p11todep (free_space.freespace_id, 4),
                     '-1', NULL,
                     get_freespace_r_p11todep (free_space.freespace_id, 4)),
             1,
             35)
             AS f4first10_dep_targ,
          SUBSTR (get_apartment_rgs_1 (apartment.apart_id, 'STATE_NUMB'),
                  1,
                  30)
             AS egrp_num,
          TO_DATE (get_apartment_rgs_1 (apartment.apart_id, 'STATE_FROM'),
                   'dd.mm.yyyy')
             AS egrp_date,
          TO_DATE (get_apartment_rgs_1 (apartment.apart_id, 'STATE_TO'),
                   'dd.mm.yyyy')
             AS egrp_date_to,
          DECODE (get_apartment_mgr_1 (free_space.freespace_id),
                  1, '���.',
                  2, '���.',
                  NULL)
             AS egrp_arch,
          TRUNC (get_apartment_mgr_2 (free_space.freespace_id))
             AS egrp_date_arch,
          DECODE (test_fs_rf (free_space.freespace_id), 1, '��', '���')
             AS rf_freespace,
          free_space.new_building_code AS newb_num,
          xn.zpv AS newb_year,
          -- get_new_building_code_year (free_space.new_building_code)
          --CASE fn_get_need_reg_in_rd (free_space.doc2_num)
             --WHEN 3
             --THEN
                NVL (
                   SUBSTR (
                      DECODE (
                         is_document_order (free_space.doc2_num,
                                            free_space.doc2_type),
                         1, visa.rdn_rep.
                             get_dog_param_by_order (free_space.doc2_num,
                                                     'STATUS'),
                         NULL),
                      1,
                      40),
                      CASE fn_get_need_reg_in_rd (free_space.doc2_num)
                        WHEN 3 THEN  '� �� ����������� �� �����'
                        WHEN 2 THEN ''
                      END )
                 AS r_st_dog,
          SUBSTR (
             DECODE (
                is_document_order (free_space.doc2_num, free_space.doc2_type),
                1, visa.rdn_rep.
                    get_dog_param_by_order (free_space.doc2_num, 'DOG_NUM'),
                NULL),
             1,
             20)
             AS r_dog_num,
          TO_DATE (
             DECODE (
                is_document_order (free_space.doc2_num, free_space.doc2_type),
                1, visa.rdn_rep.
                    get_dog_param_by_order (free_space.doc2_num, 'DOG_DATE'),
                NULL),
             'dd.mm.yyyy')
             AS r_dog_date,
          SUBSTR (
             DECODE (
                is_document_order (free_space.doc2_num, free_space.doc2_type),
                1, visa.rdn_rep.
                    get_dog_param_by_order (free_space.doc2_num,
                                            'REJECT_CAUSE'),
                NULL),
             1,
             100)
             AS r_reject_cause,
          TO_DATE (
             DECODE (
                is_document_order (free_space.doc2_num, free_space.doc2_type),
                1, visa.rdn_rep.
                    get_dog_param_by_order (free_space.doc2_num, 'REG_DATE'),
                NULL),
             'dd.mm.yyyy')
             AS r_reg_date,
          DECODE (test_fs_last_rec (free_space.freespace_id),
                  1, '��',
                  0, '���',
                  '')
             AS last_addr_rec,
          DECODE (
             is_document_order (free_space.doc2_num, free_space.doc2_type),
             1, get_order_person_cnt (free_space.doc2_num, 0),
             TO_NUMBER (NULL))
             AS order_person_cnt,
          DECODE (
             is_document_order (free_space.doc2_num, free_space.doc2_type),
             1, get_order_type_flag_text (free_space.doc2_num, 0),
             '')
             AS order_order_type,
          DECODE (
             is_document_order (free_space.doc2_num, free_space.doc2_type),
             1, get_order_type_flag_text (free_space.doc2_num, 1),
             '')
             AS order_end_affair,
          DECODE (
             is_document_order (free_space.doc2_num, free_space.doc2_type),
             1, get_order_type_flag_text (free_space.doc2_num, 2),
             '')
             AS order_new_addr,
          DECODE (
             is_document_order (free_space.doc2_num, free_space.doc2_type),
             1, get_order_type_flag_text (free_space.doc2_num, 3),
             '')
             AS order_add_square,
          DECODE (
             is_document_order (free_space.doc2_num, free_space.doc2_type),
             1, get_order_agree_info (free_space.doc2_num, 1),
             '')
             AS agree_num,
          DECODE (
             is_document_order (free_space.doc2_num, free_space.doc2_type),
             1, get_order_agree_info (free_space.doc2_num, 2),
             '')
             AS agree_date,
          DECODE (
             is_document_order (free_space.doc2_num, free_space.doc2_type),
             1, get_order_agree_info (free_space.doc2_num, 3),
             '')
             AS agree_reg_num,
          DECODE (
             is_document_order (free_space.doc2_num, free_space.doc2_type),
             1, get_order_agree_info (free_space.doc2_num, 4),
             '')
             AS agree_reg_date,
          --        ,DECODE (is_document_order (free_space.doc2_num, free_space.doc2_type), 1, get_order_dates (free_space.doc2_num, 'AGREEMENT_DATE'), '')  AS agreedate
          /*        ,DECODE (is_document_order (free_space.doc2_num, free_space.doc2_type), 1,
                          DECODE( trim(get_order_num_2 (free_space.doc2_num, 'SS')),
                             '�', case when get_order_agree_info (free_space.doc2_num, 2) is not null
                                       then get_order_agree_info (free_space.doc2_num, 4)
                                       else null
                                  end,
                             '���', get_order_agree_info (free_space.doc2_num, 2),
                             '����', get_order_agree_info (free_space.doc2_num, 2),
                          get_order_dates (free_space.doc2_num, 'AGREEMENT_DATE')),
                    '')
                     AS agreedate */
          -- #Dik21022013
          /* --OLD---
                    DECODE (
                       is_document_order (free_space.doc2_num, free_space.doc2_type),
                       1, DECODE (
                             TRIM (get_order_num_2 (free_space.doc2_num, 'SS')),
                             '�', TO_DATE (
                                      DECODE (
                                         is_document_order (free_space.doc2_num,
                                                            free_space.doc2_type),
                                         1, visa.rdn_rep.
                                             get_dog_param_by_order (
                                               free_space.doc2_num,
                                               'REG_DATE'),
                                         NULL),
                                      'dd.mm.yyyy'),
                             '���', DECODE (
                                          get_order_agree_info (free_space.doc2_num, 2),
                                          NULL, TO_DATE (
                                                   DECODE (
                                                      is_document_order (
                                                         free_space.doc2_num,
                                                         free_space.doc2_type),
                                                      1, visa.rdn_rep.
                                                          get_dog_param_by_order (
                                                            free_space.doc2_num,
                                                            'REG_DATE'),
                                                      NULL),
                                                   'dd.mm.yyyy'),
                                          get_order_agree_info (free_space.doc2_num, 2)),
                             '����', DECODE (
                                            get_order_agree_info (free_space.doc2_num,
                                                                  2),
                                            NULL, TO_DATE (
                                                     DECODE (
                                                        is_document_order (
                                                           free_space.doc2_num,
                                                           free_space.doc2_type),
                                                        1, visa.rdn_rep.
                                                            get_dog_param_by_order (
                                                              free_space.doc2_num,
                                                              'REG_DATE'),
                                                        NULL),
                                                     'dd.mm.yyyy'),
                                            get_order_agree_info (free_space.doc2_num,
                                                                  2)),
                             '���', DECODE (
                                          is_document_order (free_space.doc2_num,
                                                             free_space.doc2_type),
                                          1, get_order_agree_info (free_space.doc2_num,
                                                                   2),
                                          ''),
                             get_order_dates (free_space.doc2_num, 'AGREEMENT_DATE')),
                       '')
                       AS agreedate --        ,DECODE (is_document_order (free_space.doc2_num, free_space.doc2_type), 1, get_order_dates (free_space.doc2_num, 'STATE_REG_DATE'), '') --           AS state_reg_date

                    ,
                    DECODE (
                       is_document_order (free_space.doc2_num, free_space.doc2_type),
                       1, DECODE (
                             TRIM (get_order_num_2 (free_space.doc2_num, 'SS')),
                             '�', get_apartment_rgs_1 (apartment.apart_id, 'DATE_TO'),
                             '���', get_order_agree_info (free_space.doc2_num, 4),
                             '���', get_order_agree_info (free_space.doc2_num, 4),
                             '����', get_order_agree_info (free_space.doc2_num, 4),
                             get_order_dates (free_space.doc2_num, 'STATE_REG_DATE')),
                       '')
                       AS state_reg_date,
          -------  NEW -- */
          TO_CHAR (                               --��� �������� �������������
             (CASE is_document_order (free_space.doc2_num,
                                      free_space.doc2_type)
                 WHEN 1 THEN
                    CASE (DECODE (
                             TRIM (
                                get_order_num_2 (free_space.doc2_num, 'SS')),
                             '�', '�',
                             '���', '���',
                             '����', '���',
                             '���', '���',
                             '����', '���',
                             '���', '���',
                             '���', '���',
                             'ELSE'))
                       WHEN '�'  THEN  TO_DATE ( visa.rdn_rep.get_dog_param_by_order (free_space.doc2_num, 'REG_DATE'),'dd.mm.yyyy') -- ������� ��������� ������ �� �������� �� ���� �������
                       WHEN '���' THEN
                         CASE (SELECT COUNT(*) AS a FROM agreement ag WHERE ag.order_id = free_space.doc2_num and ag.agreement_date is not NULL)
                         WHEN 0 THEN
                              TO_DATE (visa.rdn_rep.get_dog_param_by_order (free_space.doc2_num, 'REG_DATE'),'dd.mm.yyyy')
                         ELSE
                            (SELECT ag.agreement_date  FROM agreement ag WHERE ag.order_id = free_space.doc2_num and rownum=1)
                         END
                       WHEN '���' THEN
                          ( SELECT oed.data_d --���� ������ ����� �� ���2
                            FROM orders_ext_data oed, orders_ext_data oed1
                            WHERE    oed.order_id = free_space.doc2_num
                            AND oed.order_id=oed1.order_id
                            and oed.data_version = 0
                            and oed1.data_version = oed.data_version
                            and oed1.data_type_id =28 --������� - ����� ����� �� ���2
                            AND NVL(oed1.DATA_N,-1) = 0 --����� ����� �� ���2='��������'
                            and oed.data_type_id =60  --������� -���� ������ ����� �� ���2
                            and rownum=1
                            )
                       ELSE
                          (SELECT AGREEMENT_DATE
                             FROM orders
                            WHERE ORDER_ID = free_space.doc2_num)
                    END
                 ELSE  NULL
              END),'dd.mm.yyyy')
             AS agreedate,
          TO_CHAR (
             (CASE is_document_order (free_space.doc2_num,
                                      free_space.doc2_type)
                 WHEN 1
                 THEN
                    CASE (DECODE (
                             TRIM (
                                get_order_num_2 (free_space.doc2_num, 'SS')),
                             '�', '�',
                             '���', '���',
                             '����', '���',
                             '���', '���',
                             '����', '���',
                             '���', '���',
                             '���', '���',
                             'ELSE'))
                       WHEN '�'  THEN
                          TO_DATE ( get_apartment_rgs_1 (apartment.apart_id, 'DATE_TO'),'dd.mm.yyyy')
                       WHEN '���' THEN
                          (SELECT ag.registration_date FROM agreement ag WHERE ag.order_id = free_space.doc2_num AND ROWNUM = 1)
                       WHEN '���' THEN
                          TO_DATE (get_apartment_rgs_1 (apartment.apart_id, 'DATE_TO'),'dd.mm.yyyy')
                       ELSE
                          (SELECT STATE_REG_DATE
                             FROM orders
                            WHERE ORDER_ID = free_space.doc2_num)
                    END
                 ELSE
                   NULL
              END),
             'dd.mm.yyyy')
             AS state_reg_date,
          -- /#Dik21022013


          DECODE (
             is_document_order (free_space.doc2_num, free_space.doc2_type),
             1, DECODE (get_statereg_required_mark (free_space.doc2_num),
                        1, '��',
                        '���'),
             '')
             AS state_reg_required,
          DECODE (get_sbs_fl (apartment.apart_id),
                  0, '��',
                  1, '��',
                  NULL)
             AS SBS_FL,
          -- ������������� ������� ��� - ���_��
          /*        , get_rsgs_fond(apartment.unom_bti, apartment.unkv_bti, 'NAME')
          , get_rsgs_fond(apartment.unom_bti, apartment.unkv_bti, 'DATE_FROM')
          , get_rsgs_fond(apartment.unom_bti, apartment.unkv_bti, 'DATE_TO')
          , get_rsgs_fond(apartment.unom_bti, apartment.unkv_bti, 'IS_SPEC_FOND')
          , get_rsgs_fond(apartment.unom_bti, apartment.unkv_bti, 'NAME_OUT') */
          get_rsgs_fond (get_bti_by_apart_unom (apartment.apart_id),
                         get_bti_by_apart_unkv (apartment.apart_id),
                         'NAME'),
          get_rsgs_fond (get_bti_by_apart_unom (apartment.apart_id),
                         get_bti_by_apart_unkv (apartment.apart_id),
                         'DATE_FROM'),
          get_rsgs_fond (get_bti_by_apart_unom (apartment.apart_id),
                         get_bti_by_apart_unkv (apartment.apart_id),
                         'DATE_TO'),
          get_rsgs_fond (get_bti_by_apart_unom (apartment.apart_id),
                         get_bti_by_apart_unkv (apartment.apart_id),
                         'IS_SPEC_FOND'),
          get_rsgs_fond (get_bti_by_apart_unom (apartment.apart_id),
                         get_bti_by_apart_unkv (apartment.apart_id),
                         'NAME_OUT'),
          --, CASE get_sbs_total(apartment.apart_id, free_space.freespace_id)

          CASE get_sbs_total_order2 (
                  NVL (free_space.doc2_num, free_space.doc_num),
                  NVL (free_space.doc2_type, free_space.doc_type),
                  free_space.freespace_id,
                  apartment.apart_id)
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
          DECODE (
             is_document_order (free_space.doc2_num, free_space.doc2_type),
             1, get_order_person_cnt (free_space.doc2_num, 1),
             NULL)
             AS no_adult_cnt,
          DECODE (
             is_document_order (free_space.doc2_num, free_space.doc2_type),
             1, get_order_affair_addr_fmt (free_space.doc2_num, 'ADR'),
             NULL)
             AS ORDER_AFFAIR_ADDR,                    -- ����� ��� ��� �������
          DECODE (
             is_document_order (free_space.doc2_num, free_space.doc2_type),
             1, get_order_affair_addr_fmt (free_space.doc2_num, 'KV'),
             NULL)
             AS ORDER_AFFAIR_KV,                 -- � �������� ��� ��� �������
          SUBSTR (
             get_s_calculation (
                get_order_s_calculate (free_space.doc2_num,
                                       free_space.doc2_type),
                1),
             1,
             200)
             AS order_s_calculation,                           -- ������ �����
          --,get_management_company_name(nvl(building.management_company,0)) as mancomp
          mc.name AS mancomp,
          (SELECT t.basis
             FROM INSTRUCTION t
            WHERE t.instruction_num =
                     TO_NUMBER (
                        DECODE (
                           get_freespace_r10to11 (free_space.freespace_id, 0),
                           '-1', NULL,
                           get_freespace_r10to11 (free_space.freespace_id, 0)))
                  AND ROWNUM = 1)
             AS basis,
          (SELECT t.addenum
             FROM INSTRUCTION t
            WHERE t.instruction_num =
                     TO_NUMBER (
                        DECODE (
                           get_freespace_r10to11 (free_space.freespace_id, 0),
                           '-1', NULL,
                           get_freespace_r10to11 (free_space.freespace_id, 0)))
                  AND ROWNUM = 1)
             AS addenum,
          (SELECT NAME
             FROM V_SELFTRAPPING
            WHERE ID = free_space.selftrapping_id)
             AS selftrapping,
          apartment.RUnpopulated_date,
          apartment.RUnpopulated_txt,
          apartment.RUnpopulated_Id,
          (SELECT NAME
             FROM classifier_kurs3 cl
            WHERE CL.CLASSIFIER_NUM = 131
                  AND cl.row_num = apartment.RUnpopulated_Id)
             AS RUnpopulated_name,
          VISA.RDN_REP.
           GET_DOG_PARAM_BY_ORDER (free_space.doc2_num, 'AKT_DATE')
             AS AKT_DATE,
          VISA.RDN_REP.
           GET_DOG_PARAM_BY_ORDER (free_space.doc2_num, 'ENTER_AKT_DATE')
             AS ENTER_AKT_DATE,
          CASE
             WHEN free_space.status = 4
             THEN
                (SELECT NAME
                   FROM classifier_kurs3 cl
                  WHERE CL.CLASSIFIER_NUM = 137
                        AND cl.row_num =
                               FN_GET_NEED_REG_IN_RD (free_space.doc2_num))
             ELSE
                (SELECT NAME
                   FROM classifier_kurs3 cl
                  WHERE CL.CLASSIFIER_NUM = 137 AND cl.row_num = 1)
          END
             AS NEED_REG_IN_RD_3,
           --ilonis  22.02.2013
          (DECODE (
              pkg_techpasport.get_techpasport_exists (FREE_SPACE.APART_ID),
              1, '��',
              '���'))
             AS tp_exists,
--  #Dik_09.04.2013
           case
             when  free_space.status in (1,2,4,5)
             then  management_realization_data.Get_ur_territory_title(free_space.freespace_id)
             else  NULL
           end  as ur_territory,
           case
             when  free_space.status in (1,2,4,5)
             then  management_realization_data.Get_ur_rasporyadytel_title(free_space.freespace_id)
             else  NULL
           end  as ur_rasporyadytel,
           case
             when ( free_space.status in (1,2,4,5)) and (free_space.LAST = 1)
             then  management_realization_data.Get_ur_direction_title(free_space.freespace_id)
             else  NULL
           end as ur_direction,
           case
             when  free_space.status in (1,2,5)
             then  management_realization_data.Get_period_for_implement_title(free_space.freespace_id)
             else  NULL
           end as ur_period_for_implement,
-- / #Dik_09.04.2013
-------------------------------
           --16.07.2013 ilonis --���������� �� ��������
         Get_construction_group( xn.prog_building ) as prog_group,   --������ �������� �������������
-------------------------------
--#12.08.2013 Dik
cl3cause.cause_name as CAUSE_ND,
apartment.comment_causeof_nd as COMMENT_CAUSEOF_ND,
Trunc (apartment.date_causeof_nd) as DATE_CAUSEOF_ND,
-- / #12.08.2013 Dik
    --====================
    -- 19.08.2013 onovikova
    v_tp.regdate   TP_REGDATE,
    v_tp.to_wp     TP_TO_WP,
    v_tp.doc_date  TP_DOC_DATE,
    v_tp.doc_num   TP_DOC_NUM,
    v_tp.status_id TP_STATUS
    -- 19.08.2013 onovikova
    --=====================
     FROM apartment,
          free_space,
          building,
          housing_list,
          street,
          instruction,
          kursiv.apartment ka,
          kursiv.xns xn,
          fs_city_prog fcp1,
          kursiv.needy_apart,
          kursiv.mgsn_data,
          management_companies mc,
          V_TP_INFO_HOUSING v_tp,
--#12.08.2013 Dik
          (SELECT cl.name as cause_name, cl.row_num as cause_id FROM classifier_kurs3 cl WHERE CL.CLASSIFIER_NUM = K3_PKG_APARTMENT.get_R_NSAgr ) cl3cause --������� �� ���������� ���������
    --left join REGISTRATION_IN_RD r on r.document_type = free_space.doc_type
    --                              and free_space.status = 4
    --,REGISTRATION_IN_RD r
    WHERE     housing_list.affair_id = free_space.freespace_id
          AND apartment.apart_id = free_space.apart_id
          AND apartment.building_id = free_space.building_id
          AND building.building_id = free_space.building_id
          AND free_space.LAST IN (1, 2)
          AND building.street = street.street_id
          AND get_real_instr_num (free_space.apart_id, free_space.doc_num) =
                 instruction.instruction_num(+)
          AND NVL (free_space.doc_type, 0) = instruction.document_type(+)
          AND apartment.apart_id = ka.apart_id(+)
          AND apartment.building_id = ka.building_id(+)
          AND apartment.new_building_code = xn.zsn(+)
          AND free_space.freespace_id = fcp1.freespace_id(+)
          AND needy_apart.apart_id(+) = apartment.apart_id
          AND mgsn_data.building_id(+) = apartment.building_id
          AND building.management_company = mc.mancomp_id(+)
          AND NVL(apartment.cause_nd,0) = cl3cause.cause_id(+)
          AND apartment.apart_id = v_tp.apart_id(+);
