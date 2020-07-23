CREATE OR REPLACE PROCEDURE UPDATE_AFFAIR_SPACE
-- 10.12.2014  Dikan (������ 1.121.3) 
-- ������� ���������� �������� � ��� (affair) � ������ �-1 � �-6 
-- ������� � ��������� ������� ������� TMP_AFFAIR_SPACE_UP � ���������������� ��������� �/��� �������� ��� �����������
-- ������� ������ ��� ��� ����������� � ������� ������� cur_affair (���������� � ������ 1.121.3) 
-- �� ������ ������� ������� �������� ����� �������� ������� � affair
-- ������ ��� ���������� ��������  � affair  � ����� ��������� ��������������.
--
  AS
  type TErrStr is varray (11) of varchar2(150);
  c_ErrStr constant TErrStr := TErrStr('�� ��������� ���������� ���������� / ������������ ���� �� ��� ; ���������� ����������', --1
                                       '��� unom/unkv ; ���������� ����������', --2
                                       '����������� ������ ; ���������� ����������', --3
                                       '��� ������ � rooms ��� apart_id; ���������� ���������� ', --4
                                       'sum(room.room_space) = 0 (LIV_SQ - ����� ������� �������� = 0); ���������� ����������', --5
                                       '��� ������ � ���� (���), ���������� ������� = 0; ���������� ����������', --6 (count(*) in room_delo = 0)
                                       '���������� ����� affair.Sqi=0 ���������� ����� �������', --7
                                       '����� �������� (affair.Sqo) � ����� �������� ��� ������(affair.sqb) = 0; ���������� ����� �������', --8
                                       '����� �������� (affair.Sqo) = 0; ��� ������ ������� affair.sqz (���������� �����)',--9
                                       '����� �������� ��� ������ (affair.sqb) = 0; ��� ������ ������� affair.sqL (���������� ����� ��� ������)', --10
                                       '������ ������� ������� (KM_BTI/KMI_BTI - ���)' --11
                                       );
  err_idx integer  := 0; -- ������. ��� ������ ��������� - ������ � c_ErrStr 0 - ��� ������
 -- ������� din sql --
  c_CreateStr constant varchar2(500):='create table TMP_AFFAIR_SPACE_UP (affair_id  NUMBER(8) not null,'||
                                      ' okrug_id NUMBER(2)not null, affair_stage NUMBER(6) not null, apart_id NUMBER(8) not null,'||
                                      ' sqo NUMBER(6,1), sqb NUMBER(6,1), sqz  NUMBER(6,1), sql  NUMBER(6,1), sqi  NUMBER(6,1),'||
                                      ' is_err NUMBER(2) default 0, comments VARCHAR2(300),'||
                                      ' blc number(6,1),blcInDelo number(6,1), vshk number(6,1), vshkInDelo number(6,1),'||
                                      ' CONSTRAINT affair_tmp_pk PRIMARY KEY (OKRUG_ID, AFFAIR_ID, AFFAIR_STAGE))';
  c_InsStr constant  varchar2(450) := 'Insert into TMP_AFFAIR_SPACE_UP (affair_id, okrug_id, affair_stage,apart_id,sqo,sqb,sqz,sql,sqi,is_err,comments, blc,blcInDelo, vshk, vshkInDelo)'||
                                      ' values (:p_affair_id,:p_okrug_id,:p_stage,:p_apart_id,:p_sqo,:p_sqb,:p_sqz,:p_sql,:p_sqi,:p_is_err,:p_comm,:p_blc ,:p_blcInDelo, :p_vshk, :p_vshkInDelo)';
-- ������� ������ --
  c integer := 0;
  i integer := 0;
  v_str varchar2(150) := 'Ok';
  v_null number := null;
 -- ���������� �������� --
  v_liv_sq number(8,3) := 0; -- Apartment.Living_space
 -- v_sqo number(6,1) := 0;
  v_sqb number(8,3) := 0;
  v_sqz number(8,1) := 0;
  v_sqL number(8,1) := 0;
  v_sqi  number(8,3):= 0;
  v_blc  number(7,2):= 0;--  ������� �������� �������� �� ������ ���
  v_vshk number(7,2):= 0;--  ������� ����. ������ �� ������ ���
  v_blcInDelo  number(7,2):= 0;--  ������� ��������  � ���������� �������� �� ������ ���
  v_vshkInDelo number(7,2):= 0;--  ������� ����. ������ � ���������� �������� �� ������ ���

 -- -------------------
  CURSOR cur_affair is
  select
    a.affair_id,
    a.okrug_id,
    a.apart_id,
    a.affair_stage,
    a.build_id,
    a.calc_type,
    NVL(get_Is_BTI_hostel_kurs3_not(a.apart_id,a.affair_id,a.affair_stage,1),2) as Not_Eq_bti,
    a.sqo,
    a.sqb,
    -- ������ � ����  NVL(get_BTI_TOTAL_SPACE( a.apart_id),0) as sqb_r,
    --(select ap.total_space_wo from apartment ap where ap.apart_id=a.apart_id) as total_space_wo, --���� �������
    a.sqz,
    a.sql as r_sql,
    a.sqi,
    a.creation_date,
    a.sq_type
  from affair a
  where
    a.okrug_id>=51 and a.okrug_id<=60 -- ������� � ���������� ������
    and a.affair_stage in (1,0) --??
    and a.creation_date >= cast('01.09.2012' as date) -- ������� � ���������� ������
    and a.sq_type not in (1,4,6) -- ������������ ��������,  �������� ������������ ����, ���������� �������  ������� � ���������� ������
   -- ??
  --  and NVL(a.calc_type,0) = 0 -- ������ ������� (1-����)  ??
   -- ??  and NVL(get_Is_BTI_hostel_kurs3_not(a.apart_id,a.affair_id,a.affair_stage,1),2)=0 --in (1,2) -- =0 -- 0 - ��� ����������� � ���; 1-����������� � ���. ��� (������ �� ���), 2- ��� unom/unkv
   -- ��� ����������� � UPDATE affair �� TMP_AFFAIR_SPACE_UP 
   /*  ������ � ����
      and ((NVL(a.sqb,-1) > 0) or --���� ����� �������� ��� ������
         (NVL(get_BTI_TOTAL_SPACE( a.apart_id),0)>0) -- ?? ��� ����� �������� ��� ������ ����� ���������
        )
   
    and ((NVL(a.sqz,-1)<=0) or
         (NVL(a.sql,-1)<=0)
        ) */
  --  and a.affair_id= 587109 --TEST
  order by a.creation_date  ;

  rec_affair cur_affair%rowtype;

BEGIN

  begin ----��������/������ �������� ������� ��� ���� ���������� ��������� ----------
   select count(*) into c from all_tables atn where atn.TABLE_NAME='TMP_AFFAIR_SPACE_UP';
   if c=0 then
    EXECUTE IMMEDIATE c_CreateStr;
   else
    EXECUTE IMMEDIATE 'TRUNCATE table TMP_AFFAIR_SPACE_UP';
  end if;
  exception
  WHEN OTHERS THEN
       raise_application_error(-20000, '������ ��������/������� table TMP_AFFAIR_SPACE_UP');
       return;
  end;
  ----------------------------���� �� ���������� ���-----------------------
  OPEN cur_affair;
  LOOP
   <<CONTINUE>>
   FETCH cur_affair INTO rec_affair;
   EXIT WHEN cur_affair%NOTFOUND;
   err_idx  := 0;
   v_liv_sq := 0;
   v_sqi    := 0;
   v_sqb    := 0;
   v_blc    := 0;
   v_vshk   := 0;
   v_sqz    := 0;
   v_sqL    := 0;
   v_blcInDelo  := 0;
   v_vshkInDelo := 0;
   i := i+1;
   
   if (rec_affair.Not_Eq_bti = 2)    -- ��� unom/unkv - (������ 2)
      or
      ((rec_affair.Not_Eq_bti = 0)  --  �� ��� �� ��������� ���������� ���������� / ������������ ����
        and (rec_affair.sq_type<>2))  --  � � affair �� ������������ ��������    --(������ 1)
   then
          if rec_affair.Not_Eq_bti = 2 
           then err_idx:=rec_affair.Not_Eq_bti; 
           else err_idx:=1; 
          end if; 
          EXECUTE IMMEDIATE c_InsStr
          USING rec_affair.affair_id,rec_affair.okrug_id,rec_affair.affair_stage,rec_affair.apart_id,
                rec_affair.sqo,rec_affair.sqb,rec_affair.sqz,rec_affair.r_sql,rec_affair.sqi,
                err_idx, -- ������
                c_ErrStr(err_idx),v_null,v_null,v_null,v_null;
          commit;
          GOTO  CONTINUE; --��������� ���
    end if;
   -- �������� � ��������� Apartment.Living_space (LIV_SQ) - ����� ��������
  begin
   select sum(r.room_space) into v_liv_sq from room r
   where r.apart_id=rec_affair.apart_id
   group by r.apart_id;
   exception
    WHEN OTHERS THEN
      err_idx := 4;
   end;

   if NVL(v_liv_sq,0)=0 then --����, ����� ������� �������, ��� � ������� (����3) �������� --
      select a.living_space into v_liv_sq from apartment a where a.apart_id=rec_affair.apart_id;
   end if;

   if NVL(v_liv_sq,0)=0 then
      if  err_idx <> 4 then
          err_idx := 5;
          rec_affair.r_sql := 0;
          rec_affair.sqz   := 0;
      end if;
      EXECUTE IMMEDIATE c_InsStr
      USING rec_affair.affair_id,rec_affair.okrug_id,rec_affair.affair_stage,rec_affair.apart_id,
            rec_affair.sqo,rec_affair.sqb,rec_affair.sqz,rec_affair.r_sql,rec_affair.sqi,
            err_idx, -- ������
            c_ErrStr(err_idx),v_null,v_null,v_null,v_null;
      commit;
      GOTO  CONTINUE; --��������� ���
   end if;
  -- (LIV_SQ) - ����� �������� ��������, ������ ��������� ������� � ����
  begin
        select count(r.room_num) into c
              FROM    room r, room_delo rd
              WHERE    rd.affair_id =    rec_affair.affair_id
                   AND rd.apart_id  =    rec_affair.apart_id
                   AND rd.affair_stage = rec_affair.affair_stage
                   AND rd.okrug_id =     rec_affair.okrug_id
                   AND r.apart_id =    rd.apart_id
                   and r.building_id = rd.building_id
                   AND r.room_num =    rd.room_num
        group by rd.affair_id, rd.affair_stage , rd.building_id, rd.apart_id;
    exception
        WHEN no_data_found THEN  c := 0;
  end;
  if c = 0 then  -- ������ � ���� ���, ���������� �������  = 0
     err_idx := 6;
     rec_affair.r_sql := 0;
     rec_affair.sqz   := 0;
     rec_affair.sqi   := 0;
     EXECUTE IMMEDIATE c_InsStr
      USING rec_affair.affair_id,rec_affair.okrug_id,rec_affair.affair_stage,rec_affair.apart_id,
            rec_affair.sqo,rec_affair.sqb,rec_affair.sqz,rec_affair.r_sql,rec_affair.sqi,
            err_idx, -- ������
            c_ErrStr(err_idx),v_null,v_null,v_null,v_null;
      commit;
      GOTO  CONTINUE; --��������� ���
  end if;
 -- �������� Affair.Sqi : ����������  �����
  -- ��� �������� :
  --  if NVL(rec_affair.sqi,0)=0 then  �.�. Affair.Sqi=0 �������� �����������
  -- ��� ��� ���� � �������:
    select sum(r.room_space) into v_sqi
        FROM    room r, room_delo rd
        WHERE    rd.affair_id =    rec_affair.affair_id
             AND rd.apart_id  =    rec_affair.apart_id
             AND rd.affair_stage = rec_affair.affair_stage
             AND rd.okrug_id =     rec_affair.okrug_id
             AND r.apart_id =    rd.apart_id
             and r.building_id = rd.building_id
             AND r.room_num =    rd.room_num
  group by rd.affair_id, rd.affair_stage , rd.building_id, rd.apart_id;

  if NVL(rec_affair.sqi,0) <> NVL (v_sqi,0) then
   rec_affair.sqi := ROUND(NVL (v_sqi,0),1);
  end if;
  -- ��������� Affair.Sqi ---

  if NVL(rec_affair.sqi,0) = 0 then  -- Affair.Sqi=0 ������ ������ ����� �������
     err_idx := 7;
     rec_affair.r_sql := 0;
     rec_affair.sqz   := 0;
     rec_affair.sqi   := 0; -- ����� rec_affair.sqi=NULL
     EXECUTE IMMEDIATE c_InsStr
      USING rec_affair.affair_id,rec_affair.okrug_id,rec_affair.affair_stage,rec_affair.apart_id,
            rec_affair.sqo,rec_affair.sqb,rec_affair.sqz,rec_affair.r_sql,rec_affair.sqi,
            err_idx, -- ������
            c_ErrStr(err_idx),v_null,v_null,v_null,v_null;
      commit;
      GOTO  CONTINUE; --��������� ���
  end if ;

 --���� Affair.Sqb ����� (��� ������) ������� �������� = 0 - ��������  �� ������ ���
  if  NVL(rec_affair.sqb,0)=0 then
      v_sqb := Nvl(get_BTI_TOTAL_SPACE(rec_affair.apart_id),0);
      -- ��� �������� ....--
      if  NVL(rec_affair.sqb,0)<> v_sqb then rec_affair.sqb := ROUND(v_sqb,1); end if;
   -- ���  rec_affair.sqb := v_sqb;
   -- ��� ������ - ����. ��� ?
   /*  err_idx := ??;
     EXECUTE IMMEDIATE c_InsStr
      USING rec_affair.affair_id,rec_affair.okrug_id,rec_affair.affair_stage,rec_affair.apart_id,
            rec_affair.sqo,rec_affair.sqb,rec_affair.sqz,rec_affair.r_sql,rec_affair.sqi,
            err_idx, -- ������
            c_ErrStr(err_idx);
      commit;
      GOTO  CONTINUE; --��������� ���
     */
     -- .... ---
  end if;

  if (NVL(rec_affair.sqo,0)=0) -- ����� ��������
    and (NVL(rec_affair.sqb,0)= 0) -- ����� (��� ������) ��������
  then
     err_idx := 8;
     rec_affair.r_sql := 0;
     rec_affair.sqz   := 0;
     rec_affair.sqo   := 0;
     rec_affair.sqb   := 0;
     EXECUTE IMMEDIATE c_InsStr
      USING rec_affair.affair_id,rec_affair.okrug_id,rec_affair.affair_stage,rec_affair.apart_id,
            rec_affair.sqo,rec_affair.sqb,rec_affair.sqz,rec_affair.r_sql,rec_affair.sqi,
            err_idx, -- ������
            c_ErrStr(err_idx),v_null,v_null,v_null,v_null;
      commit;
      GOTO  CONTINUE; --��������� ���
   end if;

 --  �������� ������� ����. ������ �� ������ ���
    v_vshk := Nvl(get_BTI_VSHK(rec_affair.apart_id),0);
    c:=0;
       begin
           -- ������ (��� �=0) /����� (�>0) ������� �������
            select count(*) into c
            FROM    room r
            WHERE  r.apart_id   = rec_affair.apart_id 
                -- and r.building_id = (select distinct ap.building_id from apartment ap where ap.apart_id=rec_affair.apart_id )
                 and ((NVL(r.km_bti,-1) >-1)  or (NVL(r.kmi_bti,'-1') <>'-1')) ;
            if c = 0 then
             err_idx := 11;
            end if;  
       -- �������� ������� ������� �������� � ����. ������ � ���������� �������� �� ������ ���
       select NVL(sum (sr.BLC_INDELO),0),NVL(sum (sr.VSHK_INDELO),0) into v_blcInDelo ,  v_vshkInDelo
       from (select NVL(get_BTI_BLC_INDELO(r.apart_id, r.km_bti),0)  as BLC_INDELO,
                    NVL(get_BTI_VSHK_INDELO(r.apart_id, r.km_bti),0) as VSHK_INDELO
            FROM    room r, room_delo rd
            WHERE    rd.affair_id =    rec_affair.affair_id
                 AND rd.apart_id  =    rec_affair.apart_id
                 AND rd.affair_stage = rec_affair.affair_stage
                 AND rd.okrug_id =     rec_affair.okrug_id
                 AND r.apart_id   =  rd.apart_id
                 and r.building_id = rd.building_id
                 AND r.room_num =    rd.room_num
                 and NVL(r.km_bti,-1) >-1) sr;
       exception
        WHEN no_data_found THEN
           v_blcInDelo  := 0;
           v_vshkInDelo := 0;
     end;

  if NVL(rec_affair.sqo,0)>0 then  -- ����� ����� �������  (affair.sqz) ���������� ����� :
   -- �������� ������� �������� �������� �� ������ ���
    v_blc := Nvl(get_BTI_BLC(rec_affair.apart_id),0);      
--    if rec_affair.affair_id = 617015 then
 --       rec_affair.affair_id:=617015;
--      end  if  ;
    if c > 0 then

      v_sqz :=(
                ((rec_affair.sqo - v_vshk - v_blc) / v_liv_sq)* rec_affair.sqi
                ) + v_blcInDelo + v_vshkInDelo ;
     else
        v_sqz :=( rec_affair.sqo * rec_affair.sqi)/v_liv_sq;
     end if;           
    -- ��� �������� �������� --
    rec_affair.sqz :=v_sqz;
   -- rec_affair.sqz :=Round(v_sqz,1);
      --��������� �� ������� �� ��������, �� ������ �� ���������
   --     select DECODE(Round(v_sqz,1)- Trunc(v_sqz,0),1,Trunc(v_sqz,1),Round(v_sqz,1)) into rec_affair.sqz from dual;
  else
    rec_affair.sqz := 0;
    err_idx := 9;
  end if;

  if NVL(rec_affair.sqb,0)>0 then  -- ����� ����� �������  (affair.sqL) ���������� ����� ��� ������:
   if c > 0 then
    v_sqL := (
              ((rec_affair.sqb - v_vshk) / v_liv_sq)* rec_affair.sqi
              ) + v_vshkInDelo ;
      else
        v_sqL :=( rec_affair.sqb * rec_affair.sqi)/v_liv_sq;
     end if;              
    -- ��� �������� �������� --
       rec_affair.r_sql := v_sqL;
  -- rec_affair.r_sql := Round(v_sqL,1);
   --  select DECODE(Round(v_sqL,1)- Trunc(v_sqL,0),1,Trunc(v_sqL,1),Round(v_sqL,1)) into rec_affair.r_sql from dual;
  else
    rec_affair.r_sql := 0;
    err_idx := 10;
  end if;

  if err_idx > 0 then v_str :=  c_ErrStr(err_idx); else  v_str:='Ok';  end if;

      EXECUTE IMMEDIATE c_InsStr
      USING rec_affair.affair_id,rec_affair.okrug_id,rec_affair.affair_stage,rec_affair.apart_id,
            rec_affair.sqo,rec_affair.sqb,rec_affair.sqz,rec_affair.r_sql,rec_affair.sqi,
            err_idx,
            v_str,
            ROUND(v_blc,1) ,ROUND(v_blcInDelo,1), ROUND(v_vshk,1), ROUND(v_vshkInDelo,1);
      commit;
      
  END LOOP;
  CLOSE cur_affair;
  
/*
-- ����� ����� ������������ ������� �  affair, �� ����� ��������� select ��������, ���������� - ����� Update
-- Update (
select 
-- � affair
       a.affair_id,
       a.okrug_id, 
       a.apart_id, 
       a.affair_stage,     
       a.sqo,  -- ����� ��������
       a.sqb,  -- ����� �������� ��� ������      
       a.sqi,  -- ����� ����������
       a.sqz,  -- ����� ����������
       a.sql,  -- ����� ���������� ��� ������ 
       a.calc_type, -- 0 -- ������ ������� (1-����) 
-- � ������������� �������       
       t.affair_id as r_affair_id,
       t.okrug_id as r_okrug_id, 
       t.apart_id as r_apart_id, 
       t.affair_stage as r_affair_stage,     
       t.sqo as r_sqo,  -- ����� ��������
       t.sqb as r_sqb,  -- ����� �������� ��� ������      
       t.sqi as r_sqi,  -- ����� ����������
       t.sqz as r_sqz,  -- ����� ����������
       t.sql as r_sql,  -- ����� ���������� ��� ������ 
       t.is_err, -- ��� ������ 0-��� ��
       t.comments,     -- �������� ������
       t.blc,        --  ������� �������� �������� �� ������ ���
       t.blcInDelo,  --  ������� ��������  � ���������� �������� �� ������ ���
       t.vshk,       --  ������� ����. ������ �� ������ ���
       t.vshkInDelo  --  ������� ����. ������ � ���������� �������� �� ������ ���
from affair a INNER JOIN TMP_AFFAIR_SPACE_UP t
on a.affair_id = t.affair_id
   and a.okrug_id  = t.okrug_id
   and a.apart_id   = t.apart_id 
   and a.affair_stage = t.affair_stage
  -- and t.is_err = 0  --��� ���������� ��� 'O�'
  -- and t.is_err <> 0 --��� ���������� c ��������
  -- and t.is_err in (1,2,3,4,5,6,7,8,9,10) --��� ���������� ������� ������ �� �����
  -- and  NVL(a.calc_type,0) = 1 --  �������: 0 - ������ �������. ��� 1 - ����. 
--) u 
-- set 
-- ������� ��� ����������
   --  u.sqo = u.r_sqo,  -- ����� ��������
   --  u.sqb = u.r_sqb,  -- ����� �������� ��� ������      
   --  u.sqi = u.r_sqi,  -- ����� ����������
    -- u.sqz = u.r_sqz,  -- ����� ����������
    -- u.sql = u.r_sql,  -- ����� ���������� ��� ������
    -- ����� ��� : u.sqb = DECODE(NVL(u.sqb,0),0, u.r_sqb, u.sqb)  
where     
    u.is_err in (0) -- ��� ������ ��� ������� �� �����: (0,1,2,3,4,5,6,7,8,9,10)  
  -- and .....      -- ��� �������  ������� �� �����
  ;
-- commit;  
*/        

 exception
  WHEN OTHERS THEN
       dbms_output.put_line('���������� ������ �� ���� '||to_char(i)||' ' ||to_char(rec_affair.affair_id) );
       raise_application_error(-(20000+i), '���������� ������ �� ���� '||to_char(i));

END UPDATE_AFFAIR_SPACE;
/
