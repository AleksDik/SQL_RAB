CREATE OR REPLACE FUNCTION UPDATE_F12_SPACE (p_apart_id in NUMBER, p_certificate_num in NUMBER,
  p_sqb out number,  --  ����� ��� ������ ��������  Apartment.TOTAL_SPACE_WO  (get_BTI_TOTAL_SPACE(:ap_id))
  p_sqz out number,  --  ����� ����������
  p_sqL out number,  --  ����� ��� ������ ����������
  p_sqi out number,  --  ����� ����������
  p_str out varchar2   -- ��������� �� c_ErrStr
) return number 
-- 17.02.2016  Dikan (������ )  ������ ���������� �������� ��� �12
--  ������� ���������� ������� ������ ������� 
--  � out ���������� ���������� �������
  AS
  type TErrStr is varray (11) of varchar2(150);
  c_ErrStr constant TErrStr := TErrStr('��� apart_id ; ���������� ����������', --1
                                       '��� unom/unkv ; ���������� ����������', --2
                                       '����������� ������ ; ���������� ����������', --3
                                       '��� ������ � rooms ��� apart_id; ���������� ���������� ', --4
                                       'sum(room.room_space) = 0 (LIV_SQ - ����� ������� �������� = 0); ���������� ����������', --5
                                       '��� ������ � F12, ���������� ������� = 0; ���������� ����������', --6 (count(*) in ROOM_DOCUMENT = 0)
                                       '���������� ����� Sqi=0 ���������� ����� �������', --7
                                       '����� �������� (Sqo) � ����� �������� ��� ������(sqb) = 0; ���������� ����� �������', --8
                                       '����� �������� (Sqo) = 0; ��� ������ ������� sqz (���������� �����)',--9
                                       '����� �������� ��� ������ (sqb) = 0; ��� ������ ������� sqL (���������� ����� ��� ������)', --10
                                       '������ ������� ������� (KM_BTI/KMI_BTI - ���)' --11
                                       );
  err_idx integer  := 0; -- ������. ��� ������ ��������� - ������ � c_ErrStr 0 - ��� ������
/* TEST
  c_CreateStr constant varchar2(500):='create table TMP_F12_SPACE_UP (certificate_num  NUMBER(8) not null,'||
                                      ' apart_id NUMBER(8) not null, space_type NUMBER(1),room_count number(8), liv_sq NUMBER(8,3),'||
                                      ' sqo NUMBER(6,1), sqb NUMBER(8,3), sqz  NUMBER(8,1), sqL  NUMBER(8,1), sqi  NUMBER(8,1),'||
                                      ' is_err NUMBER default 0, comments VARCHAR2(300),'||
                                      ' blc number(6,1),blcInDelo number(6,1), vshk number(6,1), vshkInDelo number(6,1),'||
                                      ' last_change DATE default sysdate not null)';
  c_InsStr constant  varchar2(450) := 
  'Insert into TMP_F12_SPACE_UP (certificate_num, apart_id, space_type,room_count,liv_sq, sqo,sqb,sqz,sqL,sqi,is_err,comments, blc,blcInDelo, vshk, vshkInDelo)'||
  ' values (:p_certificate_num,:p_apart_id,:p_space_type,:room_count,:p_liv_sq,:p_sqo,:p_sqb,:p_sqz,:p_sql,:p_sqi,:p_is_err,:p_comm,:p_blc ,:p_blcInDelo, :p_vshk, :p_vshkInDelo)';
*/
 
-- ������� ������ --
  c integer := 0;
  i integer := 0;
 -- v_str varchar2(150) := 'Ok';
  -- v_null number := null;
  v_space_type number := null;
  v_building_id number := null;
  v_precision number := 1 ;
  
 -- ���������� �������� --
  v_liv_sq_tmp number(6,1) := 0;
  v_liv_sq number(8,3) := 0; --  ����� �������� Apartment.Living_space  
  v_kh  number(6,1) := 0;   --  ����� ��������   Apartment.KITCHEN_SPACE
  v_sqo number(6,1) := 0;   --  ����� ��������  Apartment.total_space
  v_sqb number(8,3) := 0;   --  ����� ��� ������ ��������   Apartment.TOTAL_SPACE_WO  (get_BTI_TOTAL_SPACE(:ap_id))
 
 -- v_sqz number(8,1) := 0;  --  ����� ����������
 -- v_sqL number(8,1) := 0;  --  ����� ��� ������ ����������
 -- v_sqi  number(8,3):= 0;  --  ����� ����������
  
  v_blc  number(7,2):= 0;--  ������� �������� �������� �� ������ ���
  v_vshk number(7,2):= 0;--  ������� ����. ������ �� ������ ���
  v_blcInDelo  number(7,2):= 0;--  ������� ��������  � ���������� �������� �� ������ ���
  v_vshkInDelo number(7,2):= 0;--  ������� ����. ������ � ���������� �������� �� ������ ���
  v_rc number(8) := 0 ; -- ���-�� ������
BEGIN
  p_sqb := 0;
  p_sqz := 0; 
  p_sqL := 0; 
  p_sqi := 0; 
  p_str := ''; 

 /* TEST
 begin ----��������/������ �������� ������� ��� ���� ���������� ��������� ----------
   select count(*) into c from all_tables atn where atn.TABLE_NAME='TMP_F12_SPACE_UP';
   if c=0 then
    EXECUTE IMMEDIATE c_CreateStr;
 -- else
  --  EXECUTE IMMEDIATE 'TRUNCATE table TMP_F12_SPACE_UP';
  end if;
  exception
  WHEN OTHERS THEN
      -- raise_application_error(-20000, '������ ��������/������� table TMP_F12_SPACE_UP');
       p_str := '������ ��������/������� table TMP_F12_SPACE_UP';
       return (3) ;
  end;
 */ 
  -- �������� ����������  ��  apartment   
 begin  
 select NVL(a.living_space,0), NVL(a.total_space,0),NVL(a.kitchen_space,0),NVL(a.total_space_wo,0), a.space_type, a.building_id
  into v_liv_sq_tmp ,v_sqo, v_kh, v_sqb, v_space_type, v_building_id
  from apartment a where a.apart_id=p_apart_id;
  exception
    WHEN NO_DATA_FOUND THEN
     err_idx := 1; 
     p_str := c_ErrStr(err_idx);
     return(err_idx);
    WHEN OTHERS THEN
      err_idx := 3;
      p_str := c_ErrStr(err_idx);
      return(err_idx);
   end;  
 
   -- �������� � ��������� Apartment.Living_space (LIV_SQ) - ����� ��������
  begin
   select sum(r.room_space) , count(r.room_num) into v_liv_sq, v_rc from room r
   where r.apart_id = p_apart_id
   group by r.apart_id;
   exception
    WHEN OTHERS THEN
      err_idx := 4;
   end;

   if NVL(v_liv_sq,0)=0 then --����, ����� ������� �������, ��� � ������� (����3) �������� --
       v_liv_sq := v_liv_sq_tmp;
       
   end if;

   if v_liv_sq = 0 then
      if  err_idx <> 4 then err_idx := 5; end if;
/* TEST      
      EXECUTE IMMEDIATE c_InsStr
      USING p_certificate_num,p_apart_id,v_space_type,v_rc,v_liv_sq,
            v_sqo,v_sqb,p_sqz,p_sqL,p_sqi, err_idx, -- ������
            c_ErrStr(err_idx),v_null,v_null,v_null,v_null;
       commit;
*/       
      p_str := c_ErrStr(err_idx);
      return(err_idx);        
   end if;
  
--����  apartment.total_space_wo ����� (��� ������) ������� �������� = 0 - ��������  �� ������ ���
  if  v_sqb = 0 then
      v_sqb := Nvl(get_BTI_TOTAL_SPACE(p_apart_id),0);
  end if; 
  if  v_sqb > 0 then
  -- p_sqb := 
   select DECODE(Round(v_sqb,v_precision)- Trunc(v_sqb,v_precision-1),1,Trunc(v_sqb,v_precision),Round(v_sqb,v_precision)) into p_sqb from dual; 
  end if;
  
 ---- �������� ���� �������� ---------------- 
  i := get_Is_SPETIAL_HOSTELS(p_apart_id);

  if  (v_space_type in (1,3))  -- ��������� ��������
  and (i in (0,1,2)) -- ��� ��� �������
  then -- ��������� ���������� ������� ���������  �������� �������� 
    p_sqz :=  v_sqo;     --  ����� ����������
    p_sqL :=  p_sqb ;    --   ����� ��� ������ ����������   
    --p_sqi := 
    select DECODE(Round(v_liv_sq,v_precision)- Trunc(v_liv_sq,v_precision-1),1,Trunc(v_liv_sq,v_precision),Round(v_liv_sq,v_precision)) into p_sqi from dual;  --  v_liv_sq - ����� ����������
    if err_idx > 0 then 
     p_str :=  c_ErrStr(err_idx); 
    else  
     p_str:='Ok';  
    end if; 
 
/* TEST  
     EXECUTE IMMEDIATE c_InsStr
      USING p_certificate_num,p_apart_id,v_space_type,v_rc,v_liv_sq,
            v_sqo,p_sqb,p_sqz,p_sqL,p_sqi, err_idx, -- ������
            p_str,v_null,v_null,v_null,v_null;
       commit; 
 */      
     return(err_idx);
  end if;
  
------------ ������������ �������� ( ��� ��������� �������� v_space_type ��� i in (3,4,5) )----------

 --  ��������� ������� � �������
  begin
        select count(r.room_num) into v_rc
              FROM    room r, ROOM_DOCUMENT rd, CERTIFICATE cr
              WHERE   
                   cr.certificate_num   = p_certificate_num
                   AND rd.document_num  = cr.certificate_num
                   AND rd.document_type = cr.type                                   
                   and rd.building_id   = v_building_id 
                   AND rd.apart_id      =  p_apart_id
                   AND r.apart_id =    rd.apart_id
                   and r.building_id = rd.building_id
                   AND r.room_num =    rd.room_num
        group by rd.DOCUMENT_NUM, rd.DOCUMENT_TYPE , rd.building_id, rd.apart_id ; 
    exception
        WHEN no_data_found THEN  v_rc := 0;
  end;
  if v_rc = 0 then  -- ������ � F12 ���, ���������� �������  = 0
     err_idx := 6;
/*     
      EXECUTE IMMEDIATE c_InsStr
      USING p_certificate_num,p_apart_id,v_space_type,v_rc,v_liv_sq,
            v_sqo,p_sqb,p_sqz,p_sqL,p_sqi, err_idx, -- ������
            c_ErrStr(err_idx),v_null,v_null,v_null,v_null;
       commit;
*/       
      p_str := c_ErrStr(err_idx);
      return(err_idx);  
  end if;
  
-- �������� v_Sqi : ����������  �����
    select sum(NVL(r.room_space,0)) into p_sqi
    FROM    room r, ROOM_DOCUMENT rd, CERTIFICATE cr
    WHERE   
         cr.certificate_num   = p_certificate_num
         AND rd.document_num  = cr.certificate_num
         AND rd.document_type = cr.type                                   
         and rd.building_id   = v_building_id 
         AND rd.apart_id      =  p_apart_id
         AND r.apart_id =    rd.apart_id
         and r.building_id = rd.building_id
         AND r.room_num =    rd.room_num
    group by rd.DOCUMENT_NUM, rd.DOCUMENT_TYPE , rd.building_id, rd.apart_id ;
-- p_sqi:=ROUND(NVL (p_sqi,0),1);
 select DECODE(Round(p_sqi,v_precision)- Trunc(p_sqi,v_precision-1),1,Trunc(p_sqi,v_precision),Round(p_sqi,v_precision)) into p_sqi from dual; 
-- ��������� Sqi  
  if p_sqi = 0 then  -- Sqi=0 ������ ������ ����� �������
     err_idx := 7;
/*     
  EXECUTE IMMEDIATE c_InsStr
      USING p_certificate_num,p_apart_id,v_space_type,v_rc,v_liv_sq,
            v_sqo,p_sqb,p_sqz,p_sqL,p_sqi, err_idx, -- ������
            c_ErrStr(err_idx),v_null,v_null,v_null,v_null;
       commit;
*/       
      p_str := c_ErrStr(err_idx);
      return(err_idx);     
  end if ;
  
  if (v_sqo = 0) -- ����� ��������
  and (p_sqb = 0) -- ����� (��� ������) ��������
  then
     err_idx := 8;  
  /*   EXECUTE IMMEDIATE c_InsStr
      USING p_certificate_num,p_apart_id,v_space_type,v_rc,v_liv_sq,
            v_sqo,p_sqb,p_sqz,p_sqL,p_sqi, err_idx, -- ������
            c_ErrStr(err_idx),v_null,v_null,v_null,v_null;
       commit;*/
      p_str := c_ErrStr(err_idx);
      return(err_idx);     
   end if;
   
   --  �������� ������� ����. ������ �� ������ ���
    v_vshk := Nvl(get_BTI_VSHK(p_apart_id),0);
    c:=0;
       begin
           -- ������ (��� �=0) /����� (�>0) ������� �������
            select count(*) into c
            FROM   room r
            WHERE  r.apart_id   = p_apart_id
                 and r.building_id = v_building_id
                 and ((NVL(r.km_bti,-1) >-1)  or (NVL(r.kmi_bti,'-1') <>'-1')) ;
            if c = 0 then
             err_idx := 11;
            end if;  
       -- �������� ������� ������� �������� � ����. ������ � ���������� �������� �� ������ ���
       select NVL(sum (sr.BLC_INDELO),0),NVL(sum (sr.VSHK_INDELO),0) into v_blcInDelo ,  v_vshkInDelo
       from (select NVL(get_BTI_BLC_INDELO(r.apart_id, r.km_bti),0)  as BLC_INDELO,
                    NVL(get_BTI_VSHK_INDELO(r.apart_id, r.km_bti),0) as VSHK_INDELO
       FROM    room r, ROOM_DOCUMENT rd, CERTIFICATE cr
       WHERE   
         cr.certificate_num   = p_certificate_num
         AND rd.document_num  = cr.certificate_num
         AND rd.document_type = cr.type                                   
         and rd.building_id   = v_building_id 
         AND rd.apart_id      = p_apart_id
--??                   and rd.ordinal_num
         AND r.apart_id =    rd.apart_id
         and r.building_id = rd.building_id
         AND r.room_num =    rd.room_num
         and NVL(r.km_bti,-1) >-1) sr;
       exception
        WHEN no_data_found THEN
           v_blcInDelo  := 0;
           v_vshkInDelo := 0;
     end; 
     
 if v_sqo > 0 then  -- ����� ����� �������  (sqz) ���������� ����� :
   -- �������� ������� �������� �������� �� ������ ���
    v_blc := Nvl(get_BTI_BLC(p_apart_id),0);      
    if c > 0 then
      p_sqz :=(
                ((v_sqo - v_vshk - v_blc) / v_liv_sq) *  p_sqi
                ) + v_blcInDelo + v_vshkInDelo ;
     else
       p_sqz :=( v_sqo * p_sqi)/v_liv_sq;
     end if;  
    -- p_sqz := 
   select  DECODE(Round(p_sqz,1)- Trunc(p_sqz,0),1,Trunc(p_sqz,1),Round(p_sqz,1)) into p_sqz from dual ;          --��������� �� ������� �� ��������, �� ������ �� ���������    
     --p_sqz := Round(v_sqz,1);
  else
    p_sqz   := 0;
    err_idx := 9;
  end if;

  if p_sqb > 0 then  -- ����� ����� �������  (sqL) ���������� ����� ��� ������:
   if c > 0 then
    p_sqL := (
              ((p_sqb - v_vshk) / v_liv_sq)* p_sqi
              ) + v_vshkInDelo ;
      else
        p_sqL :=( p_sqb * p_sqi)/v_liv_sq;
     end if;              
   -- p_sqL:=
   select  DECODE(Round(p_sqL,1)- Trunc(p_sqL,0),1,Trunc(p_sqL,1),Round(p_sqL,1)) into p_sqL from dual; 
    --Round(p_sqL,1);
  else
    p_sqL := 0;
    err_idx := 10;
  end if;     
 
  if err_idx > 0 then 
    p_str :=  c_ErrStr(err_idx); 
  else  
    p_str:='Ok';  
  end if;    
  
/* TEST 
   EXECUTE IMMEDIATE c_InsStr
      USING p_certificate_num,p_apart_id,v_space_type,v_rc,v_liv_sq,
            v_sqo,p_sqb,p_sqz,p_sqL,p_sqi, err_idx, -- ������
            p_str,v_null,v_null,v_null,v_null;
       commit;
*/             
 return(err_idx);
 
 exception
  WHEN OTHERS THEN
      err_idx := 3;
      p_str := c_ErrStr(err_idx);
      return(err_idx);
     

END UPDATE_F12_SPACE;
/
