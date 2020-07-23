CREATE OR REPLACE PACKAGE pkg_Iport_Export_RSGS
IS
TYPE curstype IS REF CURSOR; -- тип ссылка на курсор 
c_not_equal constant number := 0;
c_new       constant number :=-1;  
c_allNull            constant number :=0;
c_notNullEqual       constant number :=1;
c_notNullnotEqual    constant number :=2;
c_notNull_Null       constant number :=3;
c_Null_notNull       constant number :=4; 
   -- Автор  : Dik
  -- Дата создания :12.12.2019
  -- Описание : Получить значение послед. (О - emp_id, Q - Id  для Q - таблиц)
Function get_sequences_qo(p_seq_type char) return number ;

   -- Автор  : Dik
  -- Дата создания :12.12.2019
  -- Описание : Получить значения служебных полей для вставки в Q - таблицу)
  -- если is_set_o = true завести запись в связанную о - таблицу 
procedure get_q_servce_values(p_id_q    out number, 
                              p_emp_id  out number, 
                              p_actual  out number, 
                              p_status  out number, 
                              p_s_      in out date,  
                              p_po_     out date);
                              
procedure upd_u_building_q_rel (p_ub_emp_id number, p_emp_id number, p_rel_source number);
procedure upd_u_premise_rel_q  (p_up_emp_id number, p_emp_id number, p_rel_source number);                          

--вставить запись в таблицу U_PREMISE_Q (помещений) из EP_PREMISE_Q помещения импортированные из РСЖС
function InsInUPfromEP_premise(p_premise_emp_id number)  return number;
                                 
procedure truncU_rsgs_type_gf ; 

function IsEqualKadastr (p_kadastr U_PREMISE_Q.Kadastr_Num%type, p_kadastr_n U_PREMISE_Q.Kadastr_Num%type) return integer ;
function IsEqualS (p_s varchar2, p_s_n varchar2) return integer ;
function IsEqualN (p_n number,p_n_n number) return integer ;                       
function IsEqualPremise (p_up_emp_id number,p_emp_id_new number) return number   ;
function GetPrior (p1 number, p2 number) return integer ;
procedure set_premise_rel_ext (p_up_emp_id number,p_emp_id number,p_reestr_id number);  
          
END pkg_Iport_Export_RSGS;
/
CREATE OR REPLACE PACKAGE BODY pkg_Iport_Export_RSGS
IS 


procedure truncU_rsgs_type_gf       
as

begin
 execute immediate 'TRUNCATE TABLE u_rsgs_type_gf';
end truncU_rsgs_type_gf;  

   -- Автор  : Dik
  -- Дата создания :12.12.2019
  -- Описание : Получить значение послед. (О - emp_id, Q - Id  для Q - таблиц)
Function get_sequences_qo(p_seq_type char) return number  
as
  v_result  number := NULL;  
  c_sequences_o  constant char(1) := 'O';  --
  c_sequences_q  constant char(1) := 'Q'; 

begin
  case when upper(p_seq_type)= c_sequences_o
       then select reg_object_seq.nextval into v_result from dual ;
       when upper(p_seq_type)= c_sequences_q
       then  select  reg_quant_seq.nextval into v_result from dual ;
       else v_result := NULL;  
   end case; 
  return ( v_result );
end get_sequences_qo;

   -- Автор  : Dik
  -- Дата создания :12.12.2019
  -- Описание : Получить значения служебных полей для вставки в Q - таблицу)
  -- если is_set_o = true завести запись в связанную о - таблицу  
             
procedure get_q_servce_values(p_id_q    out number, 
                              p_emp_id  out number, 
                              p_actual  out number, 
                              p_status  out number, 
                              p_s_      in out date,  
                              p_po_     out date)
as
begin
  p_actual := 1;
  p_status := 0; 
  if p_s_ is null then
   p_s_     := sysdate;
  end if; 
  p_po_    := to_date('31.12.9999','DD.MM.YYYY');
  p_emp_id := get_sequences_qo('O');
  p_id_q   := get_sequences_qo('Q');
  
end get_q_servce_values;                              


procedure upd_u_building_q_rel (p_ub_emp_id number, p_emp_id number, p_rel_source number)
as
rel_row u_building_rel_q%rowtype;
v_id     number;
v_s       date; 
v_po      date; --окончание пред. записи
begin

 select sysdate, sysdate + interval '1' second into  v_po, v_s from dual;
 
 select * into rel_row from u_building_rel_q ur where ur.actual=1 and ur.u_building_emp_id = p_ub_emp_id;
 
 case when  p_rel_source = 1 then --связка  EP_BUILDING_Q - U_BUILDING_Q
            if rel_row.ep_building_q_emp_id is not null 
              then return;
            end if;
            rel_row.ep_building_q_emp_id := p_emp_id;
  else return; 
 end case;  
 
 select reg_quant_seq.nextval into v_id from dual ;
            
insert into u_building_rel_q (id, 
                              emp_id, 
                              actual, 
                              status, 
                              s_, po_, 
                              u_building_emp_id, 
                              kadastr_num, 
                              unom, 
                              u_land_id, 
                              ehd_building_parcel_id,
                              bti_fsks_id, 
                              building_q_emp_id, 
                              egrp_object_q_emp_id, 
                              building_manual_id, 
                              ep_building_q_emp_id, 
                              flag_ext,
                              unvestment_contract_id,
                              changes_user_id, 
                              changes_date,
                              ehd_reestr_prav_id, 
                              alt_building_q_emp_id, 
                              log_extract_right
                              )
                        values
                              (v_id, --id
                              rel_row.emp_id, 
                              1, --actual!,
                              0, --status, 
                              v_s , --s_ 
                              to_date('31.12.9999','DD.MM.YYYY'), ---po_,   
                              rel_row.u_building_emp_id,
                              rel_row.kadastr_num,
                              rel_row.unom,
                              rel_row.u_land_id,
                              rel_row.ehd_building_parcel_id,
                              rel_row.bti_fsks_id,
                              rel_row.building_q_emp_id,
                              rel_row.egrp_object_q_emp_id,
                              rel_row.building_manual_id,
                              rel_row.ep_building_q_emp_id,
                              rel_row.flag_ext,
                              rel_row.unvestment_contract_id
                              ,0   --changes_user_id
                              ,v_s --CHANGES_DATE
                              ,rel_row.ehd_reestr_prav_id
                              ,rel_row.alt_building_q_emp_id
                              ,rel_row.log_extract_right
                           );  
              
 update u_building_rel_q ur
 set ur.actual = 0, 
     ur.po_ = v_po
 where ur.id = rel_row.id ;
 
 update u_building_rel_o o
 set o.enddatechange  = v_s
 where o.id = rel_row.emp_id;
 
commit;

     EXCEPTION  WHEN OTHERS
                THEN  rollback;
   
end upd_u_building_q_rel;

procedure upd_u_premise_rel_q (p_up_emp_id number, p_emp_id number, p_rel_source number)
as
rel_row u_premise_rel_q%rowtype;
upq_row u_premise_q%rowtype;
v_UB_emp_id number;
v_s       date; 
v_po      date; --окончание пред. записи
Is_new    integer := 0; -- 0- привязка к имеющейся в u_premise_rel_q записи ; 1 новый объект в u_premise_q новая запись в u_premise_rel_q; 
begin

 select sysdate, sysdate + interval '1' second into  v_po, v_s from dual;

 begin 
   
       select * into rel_row from u_premise_rel_q ur where ur.actual=1 and ur.u_premise_emp_id = p_up_emp_id;
 EXCEPTION  WHEN OTHERS
            THEN
                   begin
                      Is_new := 1;
                      select * into upq_row from u_premise_q up where up.actual=1 and up.emp_id = p_up_emp_id;
                      select ub.emp_id into v_UB_emp_id from u_building_q ub where ub.actual=1 and ub.unom = upq_row.unom; 
                      
                      rel_row.id     := get_sequences_qo('Q');
                      rel_row.emp_id := get_sequences_qo('O');
                    /*  rel_row.actual := 1;
                      rel_row.status := 0;
                      rel_row.s_ := v_s ; 
                      rel_row.po_:= to_date('31.12.9999','DD.MM.YYYY'); */
                      rel_row.u_premise_emp_id := p_up_emp_id;
                      rel_row.kadastr_num :=  upq_row.kadastr_num;
                      rel_row.unom := upq_row.unom;
                      rel_row.u_building_id := v_UB_emp_id; 
                      rel_row.ehd_building_parcel_id :=NULL; 
                      rel_row.bti_fkva_id := NULL; 
                      rel_row.premise_emp_id := NULL;  
                      rel_row.egrp_object_q_emp_id:= NULL;  
                      rel_row.premase_manual_id   := NULL;  
                      rel_row.ep_premise_q_emp_id := NULL;
                      rel_row.flag_ext  := NULL; 
                   --   rel_row.changes_user_id:=0; 
                   --   rel_row.changes_date := v_s;
                      rel_row.ehd_reestr_prav_id:= NULL;
                      rel_row.building_manual_id:= NULL; 
                      rel_row.alt_building_q_emp_id:= NULL;  
                      rel_row.log_extract_right:= NULL;  
                      rel_row.premise_manual_id:= NULL; 
                      rel_row.ep_premise_emp_id:= NULL;
                      
                   EXCEPTION  WHEN OTHERS 
                              then  dbms_output.put_line('Ошибка создания rel_row при получении upq_row или u_building_q.emp_id'|| ' '||to_char(p_up_emp_id)) ;
                                    rollback; 
                  end;
 end;       
           
 case when  p_rel_source = 1 then --связка  EP_premise_Q - U_premise_Q
            if rel_row.ep_premise_q_emp_id is not null 
              then return;
            end if;
            rel_row.ep_premise_q_emp_id := p_emp_id;
      when  p_rel_source = 2 then -- безусловная связка  EP_premise_Q - U_premise_Q   
            rel_row.ep_premise_q_emp_id := p_emp_id;
  else return; 
 end case;  
 
rel_row.actual := 1;
rel_row.status := 0;
rel_row.s_ := v_s ; 
rel_row.po_:= to_date('31.12.9999','DD.MM.YYYY');
rel_row.changes_user_id:=0; 
rel_row.changes_date := v_s;

 if Is_new = 0 then
     update u_premise_rel_q ur  --старую запись
     set ur.actual = 0, 
         ur.po_ = v_po
     where ur.id = rel_row.id ;
     
     update u_premise_rel_o o
       set o.enddatechange  = v_s
     where o.id = rel_row.emp_id; 
     
     rel_row.id := get_sequences_qo('Q');
 else
     insert into u_premise_rel_o
    (id, info, deleted, "UID", enddatechange)
  values
    (rel_row.emp_id, null, 0, 'ADMIN', v_s); 
 end if;
 
 insert into u_premise_rel_q(
      id, 
      emp_id, 
      actual,
      status,
      s_, po_, 
      u_premise_emp_id, 
      kadastr_num, 
      unom, 
      u_building_id, 
      ehd_building_parcel_id, 
      bti_fkva_id, 
      premise_emp_id, 
      egrp_object_q_emp_id, 
      premase_manual_id, 
      ep_premise_q_emp_id, 
      flag_ext, 
      changes_user_id, 
      changes_date, 
      ehd_reestr_prav_id,  
      building_manual_id, 
      alt_building_q_emp_id, 
      log_extract_right, 
      premise_manual_id, 
      ep_premise_emp_id
      )
 values
       (
        rel_row.id, 
        rel_row.emp_id,
        rel_row.actual,
        rel_row.status, 
        rel_row.s_, 
        rel_row.po_, 
        rel_row.u_premise_emp_id, 
        rel_row.kadastr_num, 
        rel_row.unom, rel_row.u_building_id, 
        rel_row.ehd_building_parcel_id, 
        rel_row.bti_fkva_id,
        rel_row.premise_emp_id, 
        rel_row.egrp_object_q_emp_id,
        rel_row.premase_manual_id,
        rel_row.ep_premise_q_emp_id, 
        rel_row.flag_ext, 
        rel_row.changes_user_id, 
        rel_row.changes_date,
        rel_row.ehd_reestr_prav_id,
        rel_row.building_manual_id,
        rel_row.alt_building_q_emp_id, 
        rel_row.log_extract_right, 
        rel_row.premise_manual_id, 
        rel_row.ep_premise_emp_id
         );
 commit;

     EXCEPTION  WHEN OTHERS
                THEN  rollback;
   
end upd_u_premise_rel_q;

-- записать задвойку в u_premise_rel_q 
procedure set_premise_rel_ext (p_up_emp_id number,p_emp_id number,p_reestr_id number)  
 as
  v_prel_emp_id u_premise_rel_q.emp_id%type;
  v_ext_emp_id  u_premise_rel_ext_q.emp_id%type;
  v_id          u_premise_rel_ext_q.id%type;
  v_s         date := NULL; 
  v_po        date; --окончание пред. записи
  v_actual    number;
  v_status    number;
  c integer :=0;
begin
  select count(*) into c from  u_premise_rel_ext_q t where t.row_id= p_emp_id and t.reestr_id=p_reestr_id and t.actual=1;
  if c>0 then 
    dbms_output.put_line('Уже есть запись о задвойки row_id - '||p_emp_id||'; reestr_id - '||p_reestr_id );
    return;
  end if;
    
   select ur.emp_id into v_prel_emp_id  from u_premise_rel_q ur where ur.actual=1 and ur.u_premise_emp_id = p_up_emp_id;
   
   get_q_servce_values(v_id ,v_ext_emp_id, v_actual, v_status, v_s, v_po);

  insert into u_premise_rel_ext_o
    (id, info, deleted,"uid", enddatechange)
  values
    (v_ext_emp_id, null, 0, 'ADMIN', v_s); 

insert into u_premise_rel_ext_q
  (id, emp_id, s_, po_, actual, status, u_premise_rel_emp_id, row_id, reestr_id, changes_user_id, changes_date)
values
  (v_id, 
   v_ext_emp_id, 
   v_s,
   v_po,
   v_actual,
   v_status,
   v_prel_emp_id,
   p_emp_id,
   p_reestr_id, --EP_PREMISE_Q  -- reestr_id
   0,  --changes_user_id
   v_s --changes_date
  );

  EXCEPTION  WHEN OTHERS
                THEN  rollback; 
end set_premise_rel_ext;

--вставить запись в таблицу u_building_q (зданий) из ep_building_q здания импортированные из РСЖС
function InsInUBfromEP_building(p_building_emp_id number)  return number 
as
v_emp_id number;
v_ub_emp_id number;
v_id_q     number;
v_d        Date;
v_actual   number; 
v_status   number;
v_s_       date; 
v_po_      date;
v_kadastr u_building_rel_q.kadastr_num%type;
v_unom    u_building_rel_q.unom%type;
v_ep_building_q_emp_id  u_building_rel_q.ep_building_q_emp_id%type;
begin
  
for rw in (
select eb.*,
        get_norm_cadnum(eb.kadastr) as norm_cn,
        ea.street_name,
        ea.house_number,
        ea.korpus_number, 
        ea.structure_number,
        ea.bld_unad,
        ea.country,
        ea.country_code,
        ea.full_addres
from  ep_building_q eb, ep_building_address_q ea
where eb.actual = 1
 and  eb.source_id = 20030007
 and  ea.actual = 1
 and  ea.ep_building_id = eb.emp_id 
 and  not exists (select * from u_building_rel_q ur where ur.ep_building_q_emp_id=eb.emp_id and ur.actual=1)
)
loop
  v_emp_id   := NULL;
  v_d        := NULL;
  v_ub_emp_id := NULL; 
 if  rw.kadastr  is not null
 then
   begin
      select distinct ub.emp_id into v_ub_emp_id from U_BUILDING_Q ub 
      where  ub.norm_cn = rw.norm_cn
       and   ub.actual = 1
        ;
     EXCEPTION  WHEN OTHERS
                THEN  v_ub_emp_id := NULL;
   end;   
 end if;
 if (v_ub_emp_id  is null) and (rw.unom  is not null) then
   begin
    select distinct ub.emp_id into v_ub_emp_id from U_BUILDING_Q ub 
    where ub.unom=rw.unom
    and   ub.actual = 1;
   EXCEPTION  WHEN OTHERS
             THEN  v_ub_emp_id := NULL;
   end; 
 end if;
 
if (v_ub_emp_id  is null) 
then
  i:=i+1;
  pkg_Iport_Export_RSGS.get_q_servce_values(v_id_q, v_ub_emp_id,v_actual ,v_status, v_d ,v_po_);
  insert into u_building_o
    (id, info, deleted, "UID", enddatechange)
  values
    (v_ub_emp_id, null, 0, 'ADMIN', v_d);
  
  insert into u_building_q
    (id, emp_id, actual, status, s_, po_, 
      kadastr_num, 
      area, 
      type_object_code, 
      type_object, 
      country_code, 
      country, 
      unom, 
      purpose_code, 
      purpose, 
      floors, 
      full_address, 
      source_address, 
      source_address_code, 
      street, 
      house, 
      corpus, 
      structure, 
      rsm_number,
      total_area_residential_prem,
      kwq, 
      note,
      year_build,
      norm_cn
)
  values
    (v_id_q,
     v_ub_emp_id,
     v_actual,
     v_status
     ,v_d
     ,v_po_
     ,rw.kadastr
     ,rw.overall_area
     ,rw.object_type_id
     ,rw.object_type
     ,rw.country_code
     ,rw.country
     ,rw.unom
     ,rw.purpose_code
     ,rw.purpose
     ,rw.floors
     ,rw.full_addres
     ,rw.source
     ,rw.source_id
     ,rw.street_name
     ,rw.house_number
     ,rw.korpus_number
     ,rw.structure_number
     ,rw.rsm_number
     ,rw.total_area_residential_prem
     ,rw.kwq
     ,rw.comments
     ,rw.building_year
     ,rw.norm_cn
     );
     
  pkg_Iport_Export_RSGS.get_q_servce_values(v_id_q, v_emp_id,v_actual ,v_status, v_d ,v_po_);
 
  insert into u_building_rel_o
    (id, info, deleted, "UID", enddatechange)
  values
    (v_emp_id, null, 0, 'ADMIN', v_d);


insert into u_building_rel_q (id, emp_id, 
                              actual, status, 
                               s_, po_, 
                               u_building_emp_id, 
                               kadastr_num, 
                               unom, 
                               ep_building_q_emp_id, 
                               changes_user_id, 
                               changes_date)
values
    (v_id_q, --id
     v_emp_id, 
     v_actual, --actual,
     v_status, --status, 
     v_d, --s_, 
     v_po_
      ,v_ub_emp_id
      ,rw.kadastr
      ,rw.unom
      ,rw.emp_id
      ,5   --changes_user_id
      ,v_d --CHANGES_DATE
   );
   
end InsInUBfromEP_building;  


--вставить запись в таблицу U_PREMISE_Q (помещений) из EP_PREMISE_Q помещения импортированные из РСЖС
function InsInUPfromEP_premise(p_premise_emp_id number)  return number  
as
v_up_emp_id number := NULL;
v_id_q     number;
v_actual   number; 
v_status   number;
v_d        Date := NULL;
v_po_      Date;
v_u_building_emp_id u_premise_q.u_building_emp_id%type;
rw         EP_PREMISE_Q%rowtype;

begin
  
  select ep.* into rw                 --, get_norm_cadnum(ep.kadastr) as norm_cn
  from  EP_PREMISE_Q ep --,  U_PREMISE_Q up
  where ep.actual = 1
  and   ep.emp_id = p_premise_emp_id;
  
  get_q_servce_values(v_id_q, v_up_emp_id,v_actual ,v_status, v_d ,v_po_);
  
if rw.unom is null
  then  v_u_building_emp_id := 0;
  else
    begin
    select ub.emp_id into v_u_building_emp_id 
    from  U_BUILDING_Q  ub
    where ub.unom = rw.unom;
    EXCEPTION  WHEN OTHERS
               THEN  v_u_building_emp_id := 0;
  end;
end if;
  
  insert into U_PREMISE_O
    (id, info, deleted, "UID", enddatechange)
  values
    (v_up_emp_id, null, 0, 'ADMIN', v_d);
  
  insert into u_premise_q
    (id, 
    emp_id, 
    actual,  
    status,
    s_, 
    po_, 
    kvnom, 
    unom, 
    unkv, 
    rsm_number, 
    kadastr_num, 
    name, 
    type_object_code, 
    type_object,   
    kmq,      
    gpl,  
    opl, 
    ppl,     
    note,
    type_pom_code, 
    type_pom,  
    et,
    purpose_code, 
    purpose, 
    changes_date, 
    changes_user_id,
    u_building_emp_id
)
  values (
     v_id_q, --id
     v_up_emp_id, 
     v_actual ,
     v_status,
     v_d ,
     v_po_
     ,lower(Trim(rw.kvnom)||Trim(rw.apr_ind)) --kvnom
     ,rw.unom
     ,rw.unkv
     ,rw.rsm_number
     ,rw.kadastr
     ,rw.name
     ,rw.type_object_code
     ,rw.type_object
     ,rw.kmq
     ,rw.gpl
     ,rw.total_area --opl
     ,rw.ppl
     ,rw.comments --note
     ,rw.type_pom_code
     ,rw.type_pom
     ,rw.et
     ,rw.purpose_code
     ,rw.purpose
     ,v_d --CHANGES_DATE
     ,0   -- changes_user_id
     ,v_u_building_emp_id
    ) ;
    
return (v_up_emp_id);
EXCEPTION  WHEN OTHERS
               THEN  v_up_emp_id := null;
                     return (v_up_emp_id);
               
end InsInUPfromEP_premise;

function IsEqualKadastr (p_kadastr U_PREMISE_Q.Kadastr_Num%type, p_kadastr_n U_PREMISE_Q.Kadastr_Num%type) return integer 
 as 
 -- 1--совпадают , 2 --не null оба и не совпадают; 3 - первый не null ,  второй null; 4 -- первый  null ,  второй не null
v_kadastr        U_PREMISE_Q.Kadastr_Num%type;
v_kadastr_n      U_PREMISE_Q.Kadastr_Num%type;
begin
 v_kadastr   :=  get_norm_cadnum(p_kadastr);
 v_kadastr_n :=  get_norm_cadnum(p_kadastr_n);
 
 if (v_kadastr is null) or  (v_kadastr_n is null)
   then
     if (v_kadastr is not null) then return(3); -- первый не null ,  второй null
     end if;
     if (v_kadastr_n is not null) then return(4); -- первый  null ,  второй не null
     end if; 
     return(0); --оба null
   else
     if v_kadastr = v_kadastr_n 
      then return(1); --совпадают
      else return(2); --не null оба и не совпадают
     end if;   
 end if;  

end IsEqualKadastr;

function IsEqualS (p_s varchar2, p_s_n varchar2) return integer 
 as 
-- 0-оба null; -- 1--совпадают , 2 --не null оба и не совпадают; 3 - первый не null ,  второй null; 4 -- первый  null ,  второй не null
v_p_s    varchar2(255);
v_p_s_n  varchar2(255);
begin
 v_p_s   := lower(trim(p_s));
 v_p_s_n := lower(trim(p_s_n));
 
 if (v_p_s is null) or  (v_p_s_n is null)
   then
     if (v_p_s is not null) then return(3); -- первый не null ,  второй null
     end if;
     if (v_p_s_n is not null) then return(4); -- первый  null ,  второй не null
     end if; 
     return(0); --оба null
   else
     if v_p_s = v_p_s_n 
      then return(1); --совпадают
      else return(2); --не null оба и не совпадают
     end if;   
 end if;  

end IsEqualS;

function IsEqualN (p_n number,p_n_n number) return integer 
 as 
v_result         number :=0; -- 1--совпадают , 2 --не null оба и не совпадают; 3 - первый не null ,  второй null; 4 -- первый  null ,  второй не null
begin

 if (p_n is null) or (p_n_n is null)
   then
     if (p_n is not null) then return(c_notNull_Null); -- первый не null ,  второй null
     end if;
     if (p_n_n is not null) then return(c_Null_notNull); -- первый  null ,  второй не null
     end if; 
     return(c_allNull); --оба null
   else
     if p_n = p_n_n 
      then return(c_notNullEqual); --совпадают
      else return(c_notNullnotEqual); --не null оба и не совпадают
      end if;   
 end if;  

end IsEqualN;

function GetPrior (p1 number, p2 number) return integer 
as 
v_result         number :=0; --совпадают , лучший 1 или 2
begin

 if (p1=p2) then return(0); end if;
 
 case when p1 = c_notNullEqual then    v_result :=1;
      when p1 = c_allNull              then v_result :=1;
      when p1 = c_notNullnotEqual      then v_result :=2;
      when p1 = c_notNull_Null         then  if p2=c_notNullEqual then  v_result :=2; else v_result :=1; end if;
      when p1 = c_Null_notNull         then  if p2=c_allNull then  v_result :=2; else v_result :=1; end if;
   else v_result:=0;   
 end case;
 return( v_result);
  
end GetPrior;


function IsEqualPremise (p_up_emp_id number,p_emp_id_new number) return number   
as
v_emp_id_old number;
v_premise_old     EP_PREMISE_Q%rowtype;
v_premise_new     EP_PREMISE_Q%rowtype;
v_premise_u       U_PREMISE_Q%rowtype;
v_premise_r       U_PREMISE_REL_Q%rowtype;
is_kadastr  number;
is_unom   number;         
is_unkv   number;
is_kvnom  number;
is_et     number;
is_pl     number;

is_kadastr_n  number;
is_unom_n   number;         
is_unkv_n   number;
is_kvnom_n  number;
is_et_n     number;
is_pl_n     number;
v_prior     number :=0 ; --приоритет
v_prior1    number :=0 ; --приоритет
v_IsPrior   number :=0 ; --приоритет
v_result    number :=0; -- нет связей в поле U_PREMISE_REL_Q.ep_premise_q_emp_id : 0 - не совпадают, не ставить связь ; -1 - связь с p_emp_id_new
                     ---усть связи в поле U_PREMISE_REL_Q.ep_premise_q_emp_id : 0 -оставить старую связь ; -1 - связь с p_emp_id_new ; -2 -задвойка
 
begin
  select * into v_premise_r  from u_premise_rel_q ur where (ur.actual=1 and ur.u_premise_emp_id = p_up_emp_id);
  select * into v_premise_u  from u_premise_q u where (u.actual=1 and u.emp_id = p_up_emp_id);
  select * into v_premise_new  from EP_PREMISE_Q ep where (ep.actual=1 and ep.emp_id = p_emp_id_new);

 if v_premise_r.ep_premise_q_emp_id is null  -- 1 нет связей в U_PREMISE_REL_Q с EP_PREMISE_Q
 then
  is_kadastr := IsEqualKadastr(v_premise_r.kadastr_num,v_premise_new.kadastr);
  if (is_kadastr = c_notNullnotEqual) then 
 --   dbms_output.put_line('is_kadastr-'||to_char(is_kadastr)||' is_unom-'|| to_char(is_unom)|| ' is_unkv-'||to_char(is_unkv)|| ' is_kvnom-'||to_char(is_kvnom));
    return (c_not_equal); end if;
  is_unom    := IsEqualN(v_premise_r.unom, v_premise_new.unom);
  if (is_unom = c_notNullnotEqual) then 
 --  dbms_output.put_line('is_kadastr-'||to_char(is_kadastr)||' is_unom-'|| to_char(is_unom)|| ' is_unkv-'||to_char(is_unkv)|| ' is_kvnom-'||to_char(is_kvnom));
   return (c_not_equal) ; end if;
  if (is_kadastr<>1) and  (is_unom<>1) then 
 --   dbms_output.put_line('is_kadastr-'||to_char(is_kadastr)||' is_unom-'|| to_char(is_unom)|| ' is_unkv-'||to_char(is_unkv)|| ' is_kvnom-'||to_char(is_kvnom));
    return (c_not_equal); end if;

  is_unkv    := IsEqualN(v_premise_u.unkv, v_premise_new.unkv);
  is_kvnom   := IsEqualS(v_premise_u.kvnom, lower(Trim(v_premise_new.kvnom)||Trim(v_premise_new.apr_ind)) );
  
  if (is_unkv = c_notNullnotEqual)  then 
  --   dbms_output.put_line('is_kadastr-'||to_char(is_kadastr)||' is_unom-'|| to_char(is_unom)|| ' is_unkv-'||to_char(is_unkv)|| ' is_kvnom-'||to_char(is_kvnom));
    return (c_not_equal); end if;
  if (is_unkv = 1) and (is_kvnom in (1,0,3,4)) then 
 -- dbms_output.put_line('is_kadastr-'||to_char(is_kadastr)||' is_unom-'|| to_char(is_unom)|| ' is_unkv-'||to_char(is_unkv)|| ' is_kvnom-'||to_char(is_kvnom));
  return (c_new);  end if;
  
  if (is_unkv in(0,3,4)) and (is_kvnom in (1)) 
   then 
  --  dbms_output.put_line('is_kadastr-'||to_char(is_kadastr)||' is_unom-'|| to_char(is_unom)|| ' is_unkv-'||to_char(is_unkv)|| ' is_kvnom-'||to_char(is_kvnom));
     return (c_new);  
  end if;
  if (is_kvnom = c_notNullnotEqual)
  then
   if (is_unkv= c_notNullEqual )and (is_unom = c_notNullEqual) and (is_kadastr in (c_allNull,c_notNullEqual))
   then  
       is_et :=  IsEqualS(to_char(v_premise_u.et), trim(v_premise_new.et));
       is_pl :=  IsEqualN(to_char(v_premise_u.ppl), trim(v_premise_new.ppl));
       if (is_et= c_notNullEqual )and (is_pl = c_notNullEqual) and (is_kadastr in (c_allNull,c_notNullEqual))
       then    return (c_new); end if;   
   else 
   --   dbms_output.put_line('is_kadastr-'||to_char(is_kadastr)||' is_unom-'|| to_char(is_unom)|| ' is_unkv-'||to_char(is_unkv)|| ' is_kvnom-'||to_char(is_kvnom));
      return (c_not_equal);
   end if;
     return (c_not_equal);
   end if;
   return (c_not_equal);
 end if;   --1 
 
 if p_emp_id_new = v_premise_r.ep_premise_q_emp_id then return(0) ; end if; --пропускаем связано

 select * into v_premise_old  
 from EP_PREMISE_Q ep 
 where (ep.actual=1 and ep.emp_id =  v_premise_r.ep_premise_q_emp_id);  
 
 is_unkv    := IsEqualN(v_premise_u.unkv, v_premise_old.unkv);
 is_unkv_n    := IsEqualN(v_premise_u.unkv, v_premise_new.unkv);
 is_kvnom   := IsEqualS(v_premise_u.kvnom, lower(Trim(v_premise_old.kvnom)||Trim(v_premise_old.apr_ind)) );
 is_kvnom_n  := IsEqualS(v_premise_u.kvnom, lower(Trim(v_premise_new.kvnom)||Trim(v_premise_new.apr_ind)) );
 
  is_et :=  IsEqualS(to_char(v_premise_u.et), trim(v_premise_old.et));
  is_pl :=  IsEqualN(to_char(v_premise_u.ppl), trim(v_premise_old.ppl)); 
  is_et_n :=  IsEqualS(to_char(v_premise_u.et), trim(v_premise_new.et));
  is_pl_n :=  IsEqualN(to_char(v_premise_u.ppl), trim(v_premise_new.ppl)); 
  
/*   dbms_output.put_line(
   ' is_unkv - '||to_char(is_unkv)||chr(13)||
     ' is_unkv_n - '||to_char(is_unkv_n)||chr(13)||
       ' is_kvnom - '||to_char(is_kvnom)||chr(13)||
         ' is_kvnom_n - '||to_char(is_kvnom_n)||chr(13)||
           ' is_et - '||to_char(is_et)||chr(13)||
             ' is_et_n - '||to_char(is_et_n)||chr(13)||
               ' is_pl - '||to_char(is_pl)||chr(13)||
                 ' is_pl_n - '||to_char(is_pl_n)||chr(13)
   );
    */
 /*if (is_unkv = is_unkv_n) and (is_kvnom = is_kvnom_n) -- 
 then
       if (is_et=is_et_n) and (is_pl = is_pl_n) 
         then return(-2); --задвойка
       end if; 
       if (is_et=is_et_n) -- связь этажей равна , не равны площади 
         then 
           v_prior := GetPrior(is_pl,is_pl_n); -- какая связь лучше
         else
           v_prior := GetPrior(is_et,is_et_n);
        end if;    
 else*/

    v_prior  := GetPrior(is_unkv,is_unkv_n);
    v_prior1 := GetPrior(is_kvnom,is_kvnom_n);
--      dbms_output.put_line(
  -- ' v_prior - '||to_char(v_prior)||chr(13)||
 --    ' v_prior1 - '||to_char(v_prior1)||chr(13)
  -- );
   
    if (v_prior = 0) and (v_prior1 = 0) 
      then --разборки с приоритетами дальше
       v_IsPrior :=1;
      else
        if (v_prior = 0) then v_prior := v_prior1; 
         else 
           if v_prior <> v_prior1 then --разборки с приоритетами дальше иначе однозначно по v_prior
             v_IsPrior :=1;
          end if;
        end if;
    end if;
   --  dbms_output.put_line(
  --    ' v_prior - '||to_char(v_prior)||chr(13)||
   --  ' v_IsPrior - '||to_char(v_IsPrior)||chr(13)
  -- );  
   
      if v_IsPrior = 1  then  --разборки с приоритетами
        v_prior := GetPrior(is_et,is_et_n);
        if v_prior = 0   -- связь этажей равна
        then 
          v_prior := GetPrior(is_pl,is_pl_n); -- результат по связи площади 
        else 
           select decode(v_prior,1,v_result-1,2,v_result+1,v_result) into v_result from dual;  -- связь этажей не равна, запомнить приоритетный вариант в v_result
           v_prior := GetPrior(is_pl,is_pl_n); --  связь площади 
           select decode(v_prior,1,v_result-1,2,v_result+1,v_result) into v_result from dual;  -- добавить приоритетный вариант в v_result
           if v_result<>0 then
             if v_result < 0 then v_prior:=1; else v_prior:=2; end if;
            else v_prior := 0;  -- все связи равны по приоритету задвойка
           end if; 
        end if; 
      end if;
        
 /*     dbms_output.put_line(
      ' v_prior - '||to_char(v_prior)||chr(13)||
     ' v_result - '||to_char(v_result)||chr(13)
   ); */
 
 case when  v_prior = 0 then  v_result := -2; --задвойка
      when  v_prior = 1 then v_result  := 0;  --оставить старую связь
      when  v_prior = 2 then v_result  := -1; -- связь с p_emp_id_new ;
  else  v_result  := 0;
end case;
 return( v_result);
    
end IsEqualPremise;
/*procedure test_u_premise_rel_q
as
begin
  


end;*/

END  pkg_Iport_Export_RSGS;
/
