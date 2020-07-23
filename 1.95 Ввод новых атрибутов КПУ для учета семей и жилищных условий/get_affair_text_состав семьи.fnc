CREATE OR REPLACE FUNCTION get_affair_text (a_id IN NUMBER, a_st IN NUMBER, param_ IN NUMBER)
  RETURN VARCHAR2 IS
  --
  --  22.08.2001  PVTar       ��������
  --  02.07.2002  PVTar       ���������� ���-�� ���. �� ����� ��� �����
  --  12.09.2002  PVTar       �������� "��� �����"
  --  19.12.2002  PVTar       ��������� ��� ����� ����� ������� get_space_type_affair
  --  27.04.2004  frolov      ������� ���������� � ������������ � �������������
  --  28.05.2004              ������� ���������� � ���� ���������
  --  09.12.2004              ������� ���������� �� ����
  --  07.07.2005              ��������� ���������� � ����������
  --  16.01.2008  Lvova       ��������� ���������� � ������� ����
  --  19.05.2008  Lvova       ��������� ���������� �� ������-�������� ����
  --  08.09.2008  Anissimova  ���� ��������� ���� �����������
  --  13.11.2008  BlackHawk   ������� ��������� �� "�������" ��� � ��������� "����������� ��������" (��� ���������� ����)
  --  01.12.2008  BlackHawk   ������� ����� ���������� �� "��������� ����������"
  --  10.02.2009  Anissimova  � � ���� ��������� ��� ��� 21 �/�
  --  18.03.2009  BlackHawk   ��������� ������ ��� ������ ���������� ������ ��� ��������
  --  25.03.2009  BlackHawk   ��������� ����� ��� ��������
  --  20.07.2009  BlackHawk   ��������� ��������� ������ � �������� �� ������� �� ������ pkg_affair_sublease.
  --                          ������� ����� ������� � ����������� � "��������" � rtf ���� ��� (���-627/2009)
  --  11.01.2010  Lvova       �������� ��������� ������ � ����� ��������� ����� ������, ���. �-��� get_order_num_2(orders.order_id,'NS')
  --  13.07.2010  Lvova       �������� ������ ��������� � ������ � ���� �� �� ������������� ��������� ������ (�������)
  --  11.03.2011  Anissimova  ��� �������
  --  06.07.2011  BlackHawk   ������� ����� ���� "����� � ������� �� ������"
  --  08.07.2011  BlackHawk   ������� ��������� ����� �� ������ ��� ����
  --  13.12.2011  BlackHawk   ����� "������ ���"
  --                          ������� "������ ����"
  --  20.03.2012  AVB         ������� �������� � �������������
  --  03.05.2012  AVB         ������� ���������� � ��������, ����������� �� ����������� �������
  --  30.05.2012  Ikonnikov   ������ ������ ����� � ����� ������� � ������ ����������� �� ������ ������� ������� (��� ���: '���./' � '���. } ��.�/���.)')
  --  20.09.2012  Gladkov     ������� �������� ������� �������� "���. ��.�/���." (������ sqo ������������ ���� sqz)
  -- / #D11.02.2013 (�����)   ��������� ��������� ������������ ������ 
  --  #D14.06.2013  (�����)   ��������� ������ �����
  --  #D19.06.2013  (�����)   ���������  ��������� ���. ������� �� ��������� 5
  --
  result VARCHAR2 (32000);
  i1     NUMBER;
  i2     NUMBER;
  i3     NUMBER;
  i4     NUMBER;
  i5     NUMBER;

  CURSOR pers IS
      SELECT person_relation_delo.person_num
            ,RTRIM (get_person (person_relation_delo.person_id)) last_name
            ,DECODE (get_person_sex (person_relation_delo.person_id), 1, '�', '�') sex
            ,TO_CHAR (get_person_birthday (person_relation_delo.person_id), 'DD.MM.YYYY') birthday
            ,RTRIM (relations.name) rel_name
            ,RTRIM (family.name) frel_name
            ,RTRIM (SUBSTR (get_person_categs_1 (person_relation_delo.person_id), 1, 40)) categ
        FROM affair, person_relation_delo, relations, family
       WHERE     affair.affair_id = a_id
             AND person_relation_delo.affair_id = affair.affair_id
             AND affair.affair_stage = a_st
             AND person_relation_delo.affair_stage = affair.affair_stage
             AND person_relation_delo.relation = relations.row_num(+)
             AND person_relation_delo.frelation = family.row_num(+)
    ORDER BY person_num;
-- #D14.06.2013     
  c_family_structure_pref constant VARCHAR2 (140) := ' \par   {\b������ �����} - � ������������ �� ��. 20 ������ �. ������ �29 - {\b '; 
-- /#D14.06.2013   
BEGIN
  result   := '';

  IF param_ = 1 THEN
    SELECT    '{\b   '
           || DECODE (TO_CHAR (affair.sq_type), '1', '', TO_CHAR (get_room_cnt (affair.affair_id, affair.affair_stage)) || ' ����. � ')
           || TO_CHAR (affair.kk_num)
           || ' ����. '
           || RTRIM (get_space_type_affair (affair.affair_id, affair.affair_stage))
           || '  '
           || TO_CHAR (sqi, '99999.9')
           || '} ��.� '
           || '\par '
           || CHR (10)
           || DECODE (get_classifier (34, affair.sstatus)
                     ,NULL, ' '
                     ,' ', ' '
                     ,'  ��� ���������: {\b' || get_classifier (34, affair.sstatus) || '}\par '
                     )
           || DECODE (get_classifier (85, get_och_type_1 (affair.delo_num, affair.stand_year))
                     ,NULL, ' '
                     ,' ', ' '
                     ,'  ��� �������: {\b' || get_classifier (85, get_och_type_1 (affair.delo_num, affair.stand_year)) || '}\par '
                     )
           || '  � {\b '
           || affair.year_in_place
           || '}  ( � ������ c {\b '
           || affair.year_in_city
           || '} ���� )'
           || '\par '
           || CHR (10)
           || '  ����� � ����� {\b '
           || TO_CHAR (affair.person_in_family)
           || '} ���., �� ����� {\b '
           || reg_person_cnt
           || '} ���., ���������������� �� ��������� ������� {\b '
           || get_person_reg_cnt_all(affair.affair_id, affair.affair_stage)
           || '} ���.'
           || DECODE (affair.reason, 8, DECODE (affair.type2, 3, ' (��. � ������)', ''), '')
           || ' ({\b '
           || LTRIM (TO_CHAR (
                             DECODE (affair.person_in_family
                                    , 0, 0, 
                                    affair.sqi / get_person_reg_cnt_all(affair.affair_id, affair.affair_stage)
                                    )
                             , '99999.9'
                             )
                    )
           || ' ���./'
           || LTRIM (
                TO_CHAR (
                  DECODE (affair.person_in_family
                         ,0, 0
                         ,DECODE (get_Is_BTI_hostel_kurs3_not(apartment.apart_id,affair.affair_id,affair.affair_stage)
                                 ,0,
                                 DECODE (apartment.living_space
                                        ,0,0                 
                                        ,(affair.sqi * affair.sqo) / (get_person_reg_cnt_all(affair.affair_id, affair.affair_stage) * get_apart_liv (affair.apart_id))
                                        )
                                 ,affair.sqz / get_person_reg_cnt_all(affair.affair_id, affair.affair_stage)
                                 )   
                         )
                         ,'99999.9'
                         )
                     )
           || ' ���. } ��.�/���.) '
-- #D14.06.2013             
           || (SELECT case when NVL(cl.short_name1, ' ')=' ' then ' ' else c_family_structure_pref||cl.short_name1||'}' end case FROM classifier_kurs3 cl WHERE CL.CLASSIFIER_NUM = 139 AND cl.row_num =Get_family_structure(a_id,a_st))
-- / #D14.06.2013 
--  #D19.06.2013 
           ||get_uhud_usl_strinfo(affair_id)           
-- / #D19.06.2013 
           || DECODE (affair.decl_date, NULL, ' ', ' \par   ���� ���������: {\b ' || TO_CHAR (affair.decl_date, 'DD.MM.YYYY') || '}')
           || DECODE (
                affair.decision_num
               ,NULL, ' '
               ,   ' \par   ����� ������� {\b '
                || RTRIM (affair.decision_num)
                || '} �� {\b '
                || TO_CHAR (affair.delo_date, 'DD.MM.YYYY')
                || '}'
              )
           || get_subsid_message (affair.affair_id)
           || DECODE (get_prohibitionaf (affair.affair_id), 0, ' ', '\par {\b ���� ���������� }')
           || DECODE (
                get_kpu_decree_num (affair.affair_id, affair.affair_stage)
               ,NULL, ' '
               ,   ' \par   ���� ������� �� ������� ����:  ����� {\b '
                || RTRIM (TO_CHAR (get_kpu_decree_num (affair.affair_id, affair.affair_stage)))
                || '} �� {\b '
                || NVL (TO_CHAR (get_kpu_decree_date (affair.affair_id, affair.affair_stage), 'DD.MM.YYYY'), ' ')
                || '}'
              )
           || DECODE (get_affair_queue_01_num (affair_id)
                     ,NULL, ''
                     ,'\par   ����� � ������� �� ������: {\b ' || get_affair_queue_01_num (affair_id) || '}'
                     )
           || ( SELECT '\par   �������� � �������������: {\b '
                     || (SELECT NAME FROM CLASSIFIER_KURS3
                          WHERE CLASSIFIER_NUM = 130 AND ROW_STATUS = 1 AND DELETED = 0 AND ROW_NUM = ae.DATA_N)
                     || ' � '|| DATA_S ||' �� '|| to_char(DATA_D,'dd.mm.yyyy')
                     || '}'
                 FROM AFFAIR_EXT_DATA ae
                WHERE AFFAIR_ID = affair.affair_id AND DATA_TYPE_ID = 5 AND DATA_VERSION = 0 )
      INTO result
      FROM affair, apartment
     WHERE affair_id = a_id AND affair_stage = a_st AND apartment.building_id = affair.build_id AND apartment.apart_id = affair.apart_id;
  ELSIF param_ = 2 THEN
    SELECT    get_affair_permit_chr (affair.affair_id, affair.affair_stage, 'rtf')
           --          DECODE(get_affair_permit(affair.affair_id, affair.affair_stage, 1), 1, ' {\b ���� ����������� �� 26 ������ } \par ', '')
           --       ||DECODE(get_affair_permit(affair.affair_id, affair.affair_stage, 2), 1, ' {\b ���� ����������� �� 25 ������ } \par ', '')
           --       ||DECODE(get_affair_permit(affair.affair_id, affair.affair_stage, 4), 1, ' {\b ���� ����������� �� 29 ������ } \par ', '')
           || '  ����� ���������� :  {\b '
           || SUBSTR (get_okrug (affair.okrug_id), 1, 200)
           || '} \par '
           || CHR (10)
           || '  ��� ���������� : {\b '
           || TO_CHAR (affair.stand_year)
           || '} \par '
           || CHR (10)
           || '  �������� ��������� :{\b '
           || get_kateg_all (affair.delo_category, affair.reason)
           || ' '
           || get_obfb_obdt (affair.affair_id)
           || '} '
           || DECODE (
                affair.reason || '#' || affair.delo_category
               ,'8#26', DECODE (get_affair_num_om (affair.affair_id)
                               ,NULL, ''
                               ,' ���������� � �/�: {\b ' || get_affair_num_4 (get_affair_num_om (affair.affair_id)) || '}'
                               )
               ,''
              )
           || '\par '
           || DECODE (affair.delo_category_old
                     ,0, ''
                     ,NULL, ''
                     ,'  ������ ��������� :{\b ' || get_kateg_all (affair.delo_category_old, affair.reason) || '} \par '
                     )
           || '  ������������ ������ :{\b '
           || get_sgroup (affair.s_group)
           || '} \par '
           || CHR (10)
           || '  ��� �������.���.����. :{\b '
           || get_classifier (11, type2)
           || '}'
           || DECODE (datatime, NULL, ' ', ' \par   ������� � :{\b ' || TO_CHAR (datatime, 'dd.mm.yyyy') || '}')
           || ' '
           || get_affair_plan_message_2 (affair.affair_id, affair.affair_stage)
           || ' \par '
           || '  ��������� ���������� :{\b '
           || get_status (affair.status)
           || DECODE (
                affair.status
               ,1, DECODE (affair.plan_year,  NULL, ' ',  0, ' ',  CHR (10) || '{\b   ' || TO_CHAR (affair.plan_year) || '} �')
               ,3, DECODE (affair.plan_year,  NULL, ' ',  0, ' ',  CHR (10) || '}, ���� {\b   ' || TO_CHAR (affair.plan_year) || '} �{')
               ,4, DECODE (affair.plan_year,  NULL, ' ',  0, ' ',  CHR (10) || '}, ���� {\b   ' || TO_CHAR (affair.plan_year) || '} �{')
               ,5, '}, \par       ������� ������ - { \b ' || get_reason2 (affair.reason2) || ' } '
                   || DECODE (affair.reason2_date
                             ,NULL, ' '
                             ,' \par   ���� ������ � ����� - { \b ' || TO_CHAR (affair.reason2_date, 'dd.mm.yyyy') || '} '
                             )
                   || DECODE (affair.reason2_num, NULL, ' ', '  ������������ � { \b ' || affair.reason2_num || '} ')
                   || '{'
               ,' '
              )
           || '} '
           || DECODE (
                affair.ordered
               ,1, ' '
                   || DECODE (
                        get_number_order (affair.affair_id, affair.affair_stage)
                       ,0, ' '
                       ,   '\par {\b   ��������� �����} � '
                        /*                                 || get_order_num_1 (get_number_order (affair.affair_id, affair.affair_stage))
                                                           || ' '
                                                           || TRIM (get_order_ser (get_number_order (affair.affair_id, affair.affair_stage)))
                        */
                        || get_order_num_2 (get_number_order (affair.affair_id, affair.affair_stage), 'NS')
                        || ' �� '
                        || get_order_date (get_number_order (affair.affair_id, affair.affair_stage))
                        || DECODE (affair.status
                                  ,5, ''
                                  ,' �� ������ ' || addr_apartmento_fmt (get_number_order (affair.affair_id, affair.affair_stage))
                                  )
                        --                                   || DECODE (get_order_deleted (get_number_order (affair.affair_id, affair.affair_stage)), 1, ' (�����������)', '')
                        || DECODE (
                             get_order_deleted (get_number_order (affair.affair_id, affair.affair_stage))
                            ,1,    ' (����������� �� �� ����� '
                                || NVL (pkg_orders.get_orders_ext_data_s (get_number_order (affair.affair_id, affair.affair_stage), 87, 0), ' ')
                                || ' �� '
                                || NVL (
                                     TO_CHAR (pkg_orders.get_orders_ext_data_d (get_number_order (affair.affair_id, affair.affair_stage), 88, 0)
                                             ,'DD.MM.YYYY'
                                             )
                                    ,' '
                                   )
                                || ')'
                            ,''
                           )
                      )
               --                      || DECODE(get_affair_order(affair.affair_id, affair.affair_stage)
               --                                ,NULL, ' '
               --                                ,0, ' '
               --                                , '\par {\b   ��������� �����} � '
               --                                  || get_order_num(get_affair_order(affair.affair_id, affair.affair_stage))
               --                                  || get_order_ser(get_affair_order(affair.affair_id, affair.affair_stage))
               --                                  || ' �� '
               --                                  || get_order_date(get_affair_order(affair.affair_id, affair.affair_stage))
               --           || DECODE(affair.status
               --              , 5, ''
               --             , DECODE(affair_blocked(affair.affair_id)
               --               , 1, ' �� ������ ' || addr_apartmento_fmt(get_affair_order(affair.affair_id, affair.affair_stage))
               --              , ''))
               --                                  || DECODE(get_order_deleted(get_affair_order(affair.affair_id, affair.affair_stage))
               --                                           ,1, ' (�����������)'
               --                                           ,''))
               ,' '
              )
           || '\par '
           || CHR (10)       --  03.05.2012  AVB   ���_179_2012   -->>
            || DECODE (
                  affair.ordered,
                  1, ''
                     || DECODE (
                           NVL(get_number_order (affair.affair_id, affair.affair_stage),0),
                           0, '',
                           (Select NVL2(DECODE(o.type3, 3, o.agreement_num, ag.agr_num_spec),
                                     '{\b   �������} � {\b '||DECODE(o.type3, 3, o.agreement_num, ag.agr_num_spec)
                                     ||' } ��  {\b '||TO_CHAR(DECODE (o.type3, 3, o.order_date, ag.agreement_date),'dd.mm.yyyy')
                                     ||' }\par ','')
                                FROM orders o, agreement ag
                               Where o.order_id = ag.order_id(+)
                                 and o.order_id = get_number_order (affair.affair_id, affair.affair_stage) )
                        ),
                  '')
            || DECODE (
                  affair.ordered,
                  1, ''
                     || DECODE (
                           NVL(get_number_order (affair.affair_id, affair.affair_stage),0),
                           0, '',
                           NVL2(get_order_agreementdate4affair (get_number_order (affair.affair_id, affair.affair_stage)),
                            '  ���� ����� ������������ �������� : {\b '
                            ||TO_CHAR(get_order_agreementdate4affair (get_number_order (affair.affair_id, affair.affair_stage)),'dd.mm.yyyy')
                            ||' }\par ','')
                        ),
                  '')              -- <<--
           || DECODE (affair.registration_date
                     ,NULL, ''
                     ,'  ���� ��������������� :{\b ' || TO_CHAR (affair.registration_date, 'dd.mm.yyyy') || ' }\par '
                     )
           || DECODE (affair.creation_date
                     ,NULL, '  ���� �������� ���:{\b ' || TO_CHAR (affair.delo_date, 'dd.mm.yyyy') || '} \par '
                     ,'  ���� �������� ���:{\b ' || TO_CHAR (affair.creation_date, 'dd.mm.yyyy') || '} \par '
                     )
           || DECODE (affair.decl_date
                     ,NULL, ''
                     ,'  ���� ������ ��������:{\b ' || TO_CHAR (affair.decl_date, 'dd.mm.yyyy') || '} \par'
                     )
           ---------------- 08.09.2008 Anissimova -- ���� ��������� ���� �����������
           || DECODE (affair.type2_date
                     ,NULL, ''
                     ,'   ���� ��������� ���� �����������:{\b ' || TO_CHAR (affair.type2_date, 'dd.mm.yyyy') || '} \par'
                     )
           -------------------------------------------------------------------------
           ---------------- 10.02.2009 Anissimova -- ����� � ���� ��������� ���
           || DECODE (
                affair.dc_date
               ,NULL, ''
               ,'   �������� ��� � {\b ' || affair.dc_num || '}' || ' �� {\b ' || TO_CHAR (affair.dc_date, 'dd.mm.yyyy') || '} \par'
              )
           -------------------------------------------------------------------------
           || DECODE (
                affair.calc_year
               ,NULL, ''
               ,'   ������-�������� ���: {\b ' || TO_CHAR (affair.calc_year) || '}'
                || DECODE (
                     affair.calc_change
                    ,NULL, ''
                    ,   ' ������� {\b '
                     || TO_CHAR (affair.calc_change, 'dd.mm.yyyy')
                     || '} , {\b '
                     || get_classifier_kurs3 (114, affair.calc_reason, 'NAME')
                     || '}'
                   )
                || ' \par '
              )
           || get_affair_fraud (affair.affair_id, NULL, 'rtf')
           || test_kpu_1 (affair.affair_id)
           --|| '  ������ ���: {\b ' --��������� �������� ����������� ������ (Frolov)
           --|| NVL (get_mgr_apart_info (affair.apart_id), ' ��� ')
           --|| '}'
           --|| ' \par   '
          --25.09.2012 Ilonis
           || '  ������ � �������������: '      
           --|| '  ������ ����: '
           || pkg_ufrs_req.get_affair_request_info (affair_id, affair_stage)
           || dszn.get_dszn_affair_info (affair.affair_id)
           || DECODE (get_affair_46deliver (affair_id, affair_stage)
                     ,1, '\par   {\b ������������� �� 46 ������}'
                     ,2, '\par   {\b ������������� �� 46 ������}'
                     ,''
                     )
           || SUBSTR (get_affair_excl_list (affair_id, affair_stage), 1, 2000)
           || SUBSTR (pkg_affair_sublease.get_affair_sublease_text (get_affair_text.a_id, 2), 1, 2000)
-- #D11.02.2013           
           || get_scan_check_strinfo(affair_id,0,0) 
-- / #D11.02.2013            
      INTO result
      FROM affair, apartment
     WHERE affair_id = a_id AND affair_stage = a_st AND apartment.building_id = affair.build_id AND apartment.apart_id = affair.apart_id;
  --  i1:=0;
  --  i2:=0;

  ------  ���������� �� ARS
  /*
  FOR v1 IN (SELECT '\par {\b\cf2 ' || NAME || ' }' a1
               FROM classifier_kurs3
              WHERE classifier_num = 102 AND INSTR (ars_data.format_message (a_id, a_st), row_num) > 0) LOOP
    RESULT := RESULT || v1.a1;
  END LOOP;
  */
  ------
   /*for v_Temp in (
  SELECT
  ars_DATA.GET_FAMILY_NUM(a_ID,a_St,person_id)as ARS_F_NUM
     ,SIGN(NVL(ars_DATA.GET_FAMILY_ARS_MASTER(A_ID,a_ST,person_id),0)) as ARS_MASTER
     ,FAMILY_NUM
     ,NVL(FAMILY_MASTER,0)as FAMILY_MASTER
 FROM V_FAMILY_PERSON
 WHERE AFFAIR_ID= a_id AND AFFAIR_STAGE=a_st) loop

i1:=i1+v_Temp.ARS_F_NUM;

IF v_Temp.ARS_F_NUM<>v_Temp.FAMILY_NUM or v_Temp.ARS_MASTER<>v_Temp.FAMILY_MASTER THEN
   i2:=1;
END IF;

IF i1<>0 and i2<>0 THEN
   exit;
end if;
END LOOP;

IF i1<>0 THEN
 IF i2<>0 THEN
   Result:=Result||'\par   {\b\cf2 ��������� ����� ��. ���������� �������� �� �� ��� � ��������� � ����_��� - ������ }';
ELSE
   select Count(*)
   INTO i2
   from affair_plan
      where AFFAIR_ID= a_id AND AFFAIR_STAGE=a_st
        and PLAN_TYPE<>3;

   IF i2=0 THEN
      Result:=Result||'\par   {\b\cf2 �� ������ ��������������� � ��������� }';
   ELSE
      Result:=Result||'\par   {\b\cf2 ��������� ����� ��, ��������� � ������ }';
   END IF;
END IF;

select NVL(sum(PERSON_CNT),0)
INTO i2
from affair_ars_data
WHERE AFFAIR_ID= a_id
      AND AFFAIR_STAGE=a_st;

IF i2>0 THEN
   Result:=Result||'\par   {\b\cf2 ���� ����� ��, ������� �� ������� � ��� }';
END IF;
END IF;*/
  ---------------------
  ELSIF param_ = 3 THEN
    i1   := 0;
    i2   := 0;
    i3   := 0;
    i4   := 0;
    i5   := 0;

    FOR rec IN pers LOOP
      result      :=
           result
        || rtf.get_first_row
        || TO_CHAR (rec.person_num)
        || rtf.get_between_cels
        || rec.last_name
        || rtf.get_between_cels
        || rec.sex
        || rtf.get_between_cels
        || rec.birthday
        || rtf.get_between_cels
        || rec.rel_name
        || rtf.get_between_cels
        || rec.frel_name
        || rtf.get_between_cels
        || rec.categ
        || rtf.get_between_cels
        || rtf.get_last_row;

      IF i1 < LENGTH (TO_CHAR (rec.person_num)) THEN
        i1   := LENGTH (TO_CHAR (rec.person_num));
      END IF;

      IF i2 < LENGTH (rec.last_name) THEN
        i2   := LENGTH (rec.last_name);
      END IF;

      IF i3 < LENGTH (rec.rel_name) THEN
        i3   := LENGTH (rec.rel_name);
      END IF;

      IF i4 < LENGTH (rec.frel_name) THEN
        i4   := LENGTH (rec.frel_name);
      END IF;

      IF i5 < LENGTH (rec.categ) THEN
        i5   := LENGTH (rec.categ);
      END IF;
    END LOOP;

    i2   := i2 + 2;
    i3   := i3 + 1;
    i4   := i4 + 2;
    i5   := i5 + 2;
    result      :=
         rtf.get_tab_header
      || rtf.get_cels
      || TO_CHAR (i1 * 200)
      || CHR (13)
      || CHR (10)
      || rtf.get_cels
      || TO_CHAR (i1 * 200 + i2 * 112)
      || CHR (13)
      || CHR (10)
      || rtf.get_cels
      || TO_CHAR (i1 * 200 + i2 * 112 + 400)
      || CHR (13)
      || CHR (10)
      || rtf.get_cels
      || TO_CHAR (i1 * 200 + i2 * 112 + 400 + 1300)
      || CHR (13)
      || CHR (10)
      || rtf.get_cels
      || TO_CHAR (i1 * 200 + i2 * 112 + 400 + 1300 + i3 * 112)
      || CHR (13)
      || CHR (10)
      || rtf.get_cels
      || TO_CHAR (i1 * 200 + i2 * 112 + 400 + 1300 + i3 * 112 + i4 * 112)
      || CHR (13)
      || CHR (10)
      || rtf.get_cels
      || TO_CHAR (i1 * 200 + i2 * 112 + 400 + 1300 + i3 * 112 + i4 * 112 + i5 * 112)
      || CHR (13)
      || CHR (10)
      || result;
  ELSIF param_ = 4 THEN
    IF kurs3_var.number_version <= 771 THEN
      result   := '}';
    END IF;
  ELSIF param_ = 5 THEN
    result   := pkg_affair_sublease.get_affair_sublease_text (get_affair_text.a_id, 1);
  END IF;

  RETURN result;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
  WHEN OTHERS THEN
    RETURN NULL;
END get_affair_text;
/
