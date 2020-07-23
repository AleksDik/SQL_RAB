create or replace package pkg_affair_gv is

  -- Author  : DIKAN
  -- Created : 13.03.2019 11:56:27
  -- Purpose : ��������� ������� , �������� ����� KURS3 � ����� genix_view

  -- Public type declarations
 -- type <TypeName> is <Datatype>;

  -- Public constant declarations
 -- <ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
 -- <VariableName> <Datatype>;

  -- Public function and procedure declarations
procedure GET_AFF_AP_SPACE (p_affair in NUMBER, p_affair_stage in NUMBER, CUR_AFF_AP_SPACE out SYS_REFCURSOR ) ;



 /*
  � ���������� �������
*/
PROCEDURE get_room_delo (p_affair_id NUMBER, p_stage NUMBER, a_rooms IN OUT  dbo.TRecordSet);


----------------------------------------------------------------------------------------------------------
-- �����  : ilonis
-- �������� :    �������� ������ ���� ��� �� �������� 
-- ���������:                                                                                                  
--      �������:            
--      ��������:              
procedure  get_affair_data(  p_affair_id number, p_affair_stage number, p_data in out SYS_REFCURSOR  ) ;

----------------------------------------------------------------------------------------------------------
-- �����  : ilonis
-- �������� :    ���� �� �������� 
-- ���������:                                                                                                  
--      �������:       GET_PERSONS_APART     
--      ��������:        
procedure  get_persons_apart(   p_affair_id number, p_affair_stage number,  p_data in out SYS_REFCURSOR );  


--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- �������� : ������ �� ������� ��������� �� ��������
    -- ���������:  GET_RDN_REESTR                                                                                              
  -- �������:            
  -- ��������:              
procedure get_rdn_reestr(   p_affair_id number, p_affair_stage number,  p_data in out SYS_REFCURSOR ) ;


--------------------------------------------------------------------------------------------------------
--    --ilonis 
--    ����� �� ��������
--    ������� ���������:
--    �������� ���������:
procedure   get_rights(    p_affair_id number, p_affair_stage number,  p_data in out SYS_REFCURSOR   ) ; 


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- �������� :   ������ ������ � ��������
    -- ���������:                                                                                                  
  -- �������:            
  -- ��������:              
procedure  get_room_bti(  p_affair_id number, p_affair_stage number ,  p_data in out SYS_REFCURSOR   );

---------------------------------------------------------------------------------------------------------
 --ilonis 
-- �������� :   ���������� ������ ����� � ���
--    ������� ���������:
--    �������� ���������:
procedure  get_person_data( p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ) ;


---------------------------------------------------------------------------------------------------------
-- ilonis
-- �������� :    �����������
--    ������� ���������:
--    �������� ���������:
procedure  get_free_space(   p_affair_id number, p_affair_stage number ,  p_data in out SYS_REFCURSOR    );



---------------------------------------------------------------------------------------------------------
 --ilonis 
-- �������� :   ������
--    ������� ���������:
--    �������� ���������:
procedure  get_category( p_affair_id number, p_affair_stage number ,  p_data in out SYS_REFCURSOR   );

----------------------------------------------------------------------------------------------------------
--ilonis
--    ��������
--    ������� ���������:
--    �������� ���������:
procedure  get_subsid(    p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ) ;

---------------------------------------------------------------------------------------------------------
--ilonis
-- �������� :   ����������� � ����������� ���.�������
--    ������� ���������:
--    �������� ���������:
procedure  get_notific_data( p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ) ;

--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- �������� : ������� �� ���
  -- �������:             GET_ORDER  
  -- ��������:              
  --�������� ������ �� ��������������� �������              
procedure  get_order( p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ) ;

-- �����  : Dik
-- �������� : ������ � �������� � ���
procedure  get_person_affair(p_affair_id number, p_person_id number, p_affair_stage number,  cur_person_affair in out SYS_REFCURSOR);
 
 
--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- �������� : ��������� �� ���. ���������
    -- ���������:                                                                                               
  -- �������:            
  -- ��������:              
procedure  get_declaration_data( p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ); 

-- �����  : Dik
--  ��������� ��������� ���������� �������� ������������ �� ����������
procedure get_user_privs_forSubv(p_user_id in number, p_cur in out  SYS_REFCURSOR );
-- �����  : Dik
--  ��������� ��������� ��������� �� ��� ��� ����������
procedure get_subvention(p_affair_id IN number, p_cur in out SYS_REFCURSOR);
--  �������� ����� � ��� � ���. ���. �� ��������� �� ��� ��� ����������
procedure get_subvention_persons(p_affair_id IN number, p_cur in out  SYS_REFCURSOR);
--  �������� ������ ����� � ��� � ���. ���. ��� ���������� ���������
procedure get_subvention_persons_atr(p_person_id IN number, p_cur in out SYS_REFCURSOR);
--  �������� ������ � ��� ��� ���������� ���������
procedure get_subvention_orders(p_affair_id IN number,p_subv_id in number, p_cur in out  SYS_REFCURSOR);
-- ������� ���������� �� ���������
procedure get_subventionAllRef(p_subv_id in number,p_cur in out SYS_REFCURSOR);




end pkg_affair_gv;
/
create or replace package body pkg_affair_gv is


procedure GET_AFF_AP_SPACE ( p_affair in NUMBER, p_affair_stage in NUMBER, CUR_AFF_AP_SPACE out SYS_REFCURSOR ) 
AS
  p_sqo  number := 0;   --  ����� ��������  Apartment.total_space
  p_liv_sq  number := 0; --  ����� �������� Apartment.Living_space  
  p_kh   number := 0;   --  ����� ��������   Apartment.KITCHEN_SPACE
  p_sqb  number := 0;  --  ����� ��� ������ ��������  Apartment.TOTAL_SPACE_WO  (get_BTI_TOTAL_SPACE(:ap_id))
  p_sqz  number := 0;  --  ����� ����������
  p_sqL  number := 0;  --  ����� ��� ������ ����������
  p_sqi  number := 0; --  ����� ����������
  p_str  varchar2(150) := '';   -- ��������� �� c_ErrStr
  p_apart_id  NUMBER := 0;
  err_num integer  := 0;   
begin
 
 begin  
  select a.apart_id into p_apart_id  
  from KURS3.AFFAIR a
  where a.AFFAIR_ID = p_affair
       and a.AFFAIR_STAGE = p_affair_stage;
 exception
  WHEN OTHERS THEN
      return;      
 end;      
err_num := KURS3.GET_AFF_SPACE (p_apart_id, p_affair,  p_affair_stage,
                                   p_sqo ,
                                   p_liv_sq , 
                                   p_kh ,
                                   p_sqb ,
                                   p_sqz ,
                                   p_sqL ,
                                   p_sqi ,
                                   p_str );
    
OPEN CUR_AFF_AP_SPACE FOR 
/*
select 
p_kh as KITCHEN_SQ,
p_liv_sq as LIV_SQ,
p_sqi as SQI,
p_sqL as SQL,
p_sqo as SQO,
p_sqz as SQZ,
p_str as ERR_STR
From dual;
*/   

select     
  AFFAIR_ID,
  AFFAIR_NUM,
  AFFAIR_STAGE,
  APART_ID,
  BUILD_ID,
  CALC_TYPE,
  CATEGORY,
  COMFORTABLE,
  COMFORTABLE_ID,
  CONDITION,
  COTTAGE,
  CR_DATE,
  FLOOR,
  GOOD,
  GOOD_ID,
  DECODE(NVL(KITCHEN_SQ,0),0,p_kh,KITCHEN_SQ)  as KITCHEN_SQ,--  ����� ��������   Apartment.KITCHEN_SPACE
  LAST_CHANGE,
  DECODE(NVL(LIV_SQ,0),0,p_liv_sq,LIV_SQ) as LIV_SQ, --  ����� �������� Apartment.Living_spac
  MAINT,
  MORE_FAMILY,
  OCCUPY_NUM,
  OKRUG_ID,
  REASON,
  ROOM_COUNT,
  DECODE(NVL(SQB,0),0,p_sqb,SQB) as SQB, --  ����� ��� ������ �������� 
  p_sqi as SQI,
  p_sqL as SQL, --?
  DECODE(NVL(SQO,0),0,p_sqo,SQO) as SQO,--  ����� ��������  Apartment.total_space
  p_sqz as SQZ,--  ����� ����������
  SQ_TYPE,
  SQ_TYPE_N,
  SSTATUS,
  (select t.name from KURS3.CLASSIFIER t where t.classifier_num = 34 and t.row_num = SSTATUS) as SSTATUS_S,
  STATUS_BTI,
  S_GROUP,
  TOILET,
  TOILET_ID,
  TYPE3,
  YEAR_IN_CITY,
  YEAR_IN_PLACE,
  p_str as ERR_STR       
FROM KURS3.V_AFFAIR_ANNOUN
WHERE
 AFFAIR_ID = p_affair
 and
 APART_ID = Decode(p_apart_id,0,APART_ID,p_apart_id)
 and
 AFFAIR_STAGE = p_affair_stage;
  
end GET_AFF_AP_SPACE;


 /*
 � ���������� �������
*/
 PROCEDURE get_room_delo (p_affair_id NUMBER, p_stage NUMBER, a_rooms IN OUT  dbo.TRecordSet)
 AS
BEGIN
 
        PKG_K3.get_room_delo (p_affair_id, p_stage, a_rooms);
     
END get_room_delo;


----------------------------------------------------------------------------------------------------------
-- �����  : ilonis
-- �������� :    �������� ������ ���� ��� �� �������� 
-- ���������:                                                                                                  
--      �������:            
--      ��������:              
procedure  get_affair_data(  p_affair_id number, p_affair_stage number, p_data in out SYS_REFCURSOR  ) 
as
begin

    p_data:=  KURS3.PKG_AFFAIR.get_affair_data(  p_affair_id, p_affair_stage   ); 
 
end get_affair_data;


----------------------------------------------------------------------------------------------------------
-- �����  : ilonis
-- �������� :    ���� �� �������� 
-- ���������:                                                                                                  
--      �������:       GET_PERSONS_APART     
--      ��������:        
procedure  get_persons_apart(   p_affair_id number, p_affair_stage number,  p_data in out SYS_REFCURSOR   )
as 
begin

    p_data:= KURS3.PKG_AFFAIR.get_persons_apart(   p_affair_id , p_affair_stage    ) ;
    
end get_persons_apart;


--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- �������� : ������ �� ������� ��������� �� ��������
    -- ���������:  GET_RDN_REESTR                                                                                              
  -- �������:            
  -- ��������:              
procedure get_rdn_reestr(   p_affair_id number, p_affair_stage number,  p_data in out SYS_REFCURSOR ) 
as
begin
    p_data:= KURS3.PKG_AFFAIR.get_rdn_reestr(   p_affair_id , p_affair_stage    ) ;
end;


--------------------------------------------------------------------------------------------------------
--    --ilonis 02.04.2018
--    ����� �� ��������
--    ������� ���������:
--    �������� ���������:
procedure   get_rights(    p_affair_id number, p_affair_stage number,  p_data in out SYS_REFCURSOR   )  
as
begin

 p_data:= KURS3.PKG_AFFAIR.get_rights(   p_affair_id , p_affair_stage    ) ;

end get_rights;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- �������� :   ������ ������ � ��������
    -- ���������:                                                                                                  
  -- �������:            
  -- ��������:              
procedure  get_room_bti(  p_affair_id number, p_affair_stage number ,  p_data in out SYS_REFCURSOR   )
as
begin

    p_data:= KURS3.PKG_AFFAIR.get_room_bti(   p_affair_id , p_affair_stage    ) ;

end get_room_bti;



---------------------------------------------------------------------------------------------------------
 --ilonis 
-- �������� :   ���������� ������ ����� � ���
--    ������� ���������:
--    �������� ���������:
procedure  get_person_data( p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ) 
as
begin

    p_data:= KURS3.PKG_AFFAIR.get_person_data(   p_affair_id , p_affair_stage    ) ;

end get_person_data ;


---------------------------------------------------------------------------------------------------------
-- ilonis
-- �������� :    �����������
--    ������� ���������:
--    �������� ���������:
procedure  get_free_space(   p_affair_id number, p_affair_stage number ,  p_data in out SYS_REFCURSOR    ) 
as
begin

  p_data:= KURS3.PKG_AFFAIR.get_free_space(   p_affair_id , p_affair_stage    ) ;
  
end;


---------------------------------------------------------------------------------------------------------
 --ilonis 
-- �������� :   ������
--    ������� ���������:
--    �������� ���������:
procedure  get_category( p_affair_id number, p_affair_stage number ,  p_data in out SYS_REFCURSOR   ) 
as
begin

  p_data:= KURS3.PKG_AFFAIR.get_category(   p_affair_id , p_affair_stage    ) ;

end;

----------------------------------------------------------------------------------------------------------
--ilonis
--    ��������
--    ������� ���������:
--    �������� ���������:
procedure  get_subsid(    p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ) 
as
begin

  p_data:= KURS3.PKG_AFFAIR.get_subsid(   p_affair_id , p_affair_stage    ) ;
  
end get_subsid ;


 
---------------------------------------------------------------------------------------------------------
--ilonis
-- �������� :   ����������� � ����������� ���.�������
--    ������� ���������:
--    �������� ���������:
procedure  get_notific_data( p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ) 
as
begin

  p_data:= KURS3.PKG_AFFAIR.get_notific_data(   p_affair_id , p_affair_stage    ) ;
  
end get_notific_data ;


--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- �������� : ������� �� ���
    -- ���������:  GET_ORDER                                                                                              
  -- �������:            
  -- ��������:              
  --�������� ������ �� ��������������� �������              
procedure  get_order( p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ) 
as
begin

  p_data:= KURS3.PKG_AFFAIR.get_order(   p_affair_id , p_affair_stage    ) ;
  
end get_order ;

-- �����  : Dik
-- �������� : ������ � �������� � ���
procedure  get_person_affair(p_affair_id number, p_person_id number, p_affair_stage number,  cur_person_affair in out SYS_REFCURSOR) 
as
begin

 open cur_person_affair for 
  select v.*
  ,(SELECT LOWER(NAME) FROM KURS3.V_PASSPORT where ID = v.doc_type ) as DOC_TYPE_STR
  ,( select vp.name from KURS3.v_person_reg vp where vp.ID= v.REG_PERSON) as REG_PERSON_STR
 , ( select vp.name from KURS3.v_person_owner vp where vp.ID= v.OWNERS) as OWNERS_STR      
       
  from KURS3.V_PERSON_AFFAIR_3 v 
  where 
      v.AFFAIR_ID = p_affair_id
  and v.AFFAIR_STAGE = p_affair_stage       
  and v.person_id = p_person_id ;
  
    
end get_person_affair ;


--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- �����  : ilonis
  -- �������� : ��������� �� ���. ���������
    -- ���������:                                                                                               
  -- �������:            
  -- ��������:              
procedure  get_declaration_data( p_affair_id number, p_affair_stage number  ,  p_data in out SYS_REFCURSOR  ) 
as
begin

  p_data:= KURS3.PKG_AFFAIR.get_declaration_data(   p_affair_id , p_affair_stage    ) ;
  
end get_declaration_data ;

-- �����  : Dik
--  ��������� ��������� ���������� �������� ������������ �� ����������
procedure get_user_privs_forSubv(p_user_id in number, p_cur in out  SYS_REFCURSOR )
as
 l_user_id number;
 s varchar2(500) := NULL;
begin
 l_user_id := p_user_id;  
 s:= pkg_rsm2.Set_Global_Var( l_user_id );
 kurs3.pkg_subvention.get_user_privs_forSubv(p_cur);
end get_user_privs_forSubv;

-- �����  : Dik
--  ��������� ��������� ��������� �� ��� ��� ����������
procedure get_subvention(p_affair_id IN number, p_cur in out SYS_REFCURSOR)
 as
 begin
   kurs3.pkg_subvention.get_subvention(p_affair_id, p_cur);
 end get_subvention;
 
--  �������� ����� � ��� � ���. ���. �� ��������� �� ��� ��� ����������
procedure get_subvention_persons(p_affair_id IN number, p_cur in out  SYS_REFCURSOR)  
 as
 begin
   kurs3.pkg_subvention.get_subvention_persons(p_affair_id, p_cur);
 end get_subvention_persons;
 
 --  �������� ������ ����� � ��� � ���. ���. ��� ����������
procedure get_subvention_persons_atr(p_person_id IN number, p_cur in out SYS_REFCURSOR)
 as
 begin
   kurs3.pkg_subvention.get_subvention_persons_atr(p_person_id, p_cur);
 end get_subvention_persons_atr;  
 
--  �������� ������ � ��� ��� ���������� ���������
procedure get_subvention_orders(p_affair_id IN number,p_subv_id in number, p_cur in out  SYS_REFCURSOR)
 as
 begin
   kurs3.pkg_subvention.get_subvention_orders(p_affair_id, p_subv_id, p_cur);
 end get_subvention_orders;  
 
 -- ������� ���������� �� ���������
procedure get_subventionAllRef(p_subv_id in number,p_cur in out SYS_REFCURSOR)
 as
 begin
   kurs3.pkg_subvention.get_subventionAllRef( p_subv_id, p_cur);
 end get_subventionAllRef;  
 
 
end pkg_affair_gv;
/
