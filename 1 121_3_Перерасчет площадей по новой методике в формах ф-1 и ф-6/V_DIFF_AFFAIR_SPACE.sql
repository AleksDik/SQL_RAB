create or replace view V_DIFF_AFFAIR_SPACE as
-- -- 10.12.2014  Dikan (������ 1.121.3) 
-- ����������� ����������� �������� � ��� (affair) �� ������� ������� TMP_AFFAIR_SPACE_UP (��������������� ������� �/��� ������ ��� �����������)
-- ������������ � ���. � �������� � affair
--  ������ ������� �� ����� VIEW
/*  select * from  V_DIFF_AFFAIR_SPACE vd
  --  where
   ((NVL(vd.sqz,-1)<=0) or (NVL(vd.sql,-1)<=0)) --� affair ���  sqz ��� sql
  -- and vd.is_err = 0  --��� ���������� ��� 'O�'
  -- and vd.is_err <> 0 --��� ���������� c ��������
  -- and vd.is_err in (1,2,3,4,5,6,7,8,9,10) --��� ���������� ������� ������ �� �����
  -- and  NVL(vd.calc_type,0) = 0 --  �������: 0 - ������ �������. ��� 1 - ����. 
  -- and vd.affair_stage in (1,0) 
  -- and vd.calc_type=0 -- 0 -- ������ ������� (1-����) 
  -- and .....      -- ��� �������  ������� �� ����� 
  --and ((NVL(vd.sqz,-1)<>NVL(vd.r_sqz,0)) or (NVL(vd.sql,-1)<>NVL(vd.r_sql,0)));
---------------
  ((NVL(vd.sqz,-1)<>NVL(vd.r_sqz,0)) or (NVL(vd.sql,-1)<>NVL(vd.r_sql,0))or (NVL(vd.sqb,-1)<>NVL(vd.r_sqb,0)))
  and vd.is_err in (0,11) 
  and vd.calc_type<>1  
*/  
select 
-- � affair
       SUBSTR (addr_apartment (a.build_id, a.apart_id), 1, 200) as  address,
       a.affair_id,
       a.okrug_id, 
       a.apart_id, 
       a.affair_stage,
       decode (ap.space_type,a.sq_type,to_char(a.sq_type),to_char(ap.space_type)||' � apartment; '||to_char(a.sq_type)||' � affair') as sq_Type,     
       ap.living_space as LIV_SQ, -- ����� ��������  �� apartment    
       a.sqo,  -- ����� ��������
       a.sqb,  -- ����� �������� ��� ������      
       a.sqi,  -- ����� ����������
       a.sqz,  -- ����� ����������
       a.sql,  -- ����� ���������� ��� ������ 
       a.calc_type, -- 0 -- ������ ������� (1-����) 
-- � ������������� �������       
     --  t.affair_id as r_affair_id,
     --  t.okrug_id as r_okrug_id, 
     --  t.apart_id as r_apart_id, 
    --   t.affair_stage as r_affair_stage,     
       t.sqo as r_sqo,  -- ����� ��������
       t.sqb as r_sqb,  -- ����� �������� ��� ������      
       t.sqi as r_sqi,  -- ����� ����������
       t.sqz as r_sqz,  -- ����� ����������
       t.sql as r_sql,  -- ����� ���������� ��� ������ 
       t.is_err, -- ��� ������ 0-��� ��
       t.comments,     -- �������� ������
      -- NVL(get_Is_BTI_hostel_kurs3_not(a.apart_id,a.affair_id,a.affair_stage,1),2) as Not_Eq_bti,
       t.blc,        --  ������� �������� �������� �� ������ ���
       t.blcInDelo,  --  ������� ��������  � ���������� �������� �� ������ ���
       t.vshk,       --  ������� ����. ������ �� ������ ���
       t.vshkInDelo  --  ������� ����. ������ � ���������� �������� �� ������ ���
from   affair a INNER JOIN TMP_AFFAIR_SPACE_UP t
on a.affair_id = t.affair_id
   and a.okrug_id  = t.okrug_id
   and a.apart_id   = t.apart_id 
   and a.affair_stage = t.affair_stage
,apartment ap
where a.apart_id = ap.apart_id ;
