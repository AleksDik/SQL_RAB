CREATE OR REPLACE package body KURS3.pkg_techpasport
is
--ilonis
--12.02.2013
-- пакет для работы с техническим паспортом на помещение
 

--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 12.02.2013
  -- Описание :  процедура для корректировки связи между ТП и помещением
  -- Параметры:                                                                                                  
  -- Входные:     
  -- Выходные:               
procedure update_tp_relation_apart( p_apart_id_  number,  p_build_id_  number  ,p_apart_num_  number  ,p_apart_idx_  char,  iscommit in number  )
as
    l_id_user number;
    l_count number;
    l_tp_id number;  
    l_apart_id number;
begin

    select ra.APART_ID, ra.TP_ID  into  l_apart_id, l_tp_id  from APARTMENT  ap   
            join  TP_RELATION_APART ra  on ra.APART_ID=ap.APART_ID and ra.ACTIVE=1
            where   ap.BUILDING_ID = p_build_id_ and ap.APARTMENT_NUM =p_apart_num_ and nvl (trim(ap.APARTMENT_IDX), 'x') = nvl (trim(p_apart_idx_), 'x'); 
    
    --нет такой квартиры  
    if  l_apart_id is null or p_apart_id_ is null  or (  l_apart_id = p_apart_id_ ) then
        return;
    end if;        

    update KURS3.TP_RELATION_APART set  ACTIVE=0 where APART_ID= l_apart_id and  ACTIVE=1;
             
     insert into KURS3.TP_RELATION_APART (RELATION_ID, TP_ID, APART_ID,ACTIVE)
                                                      values( SEQ_TP_RELATION_APART.nextval, l_tp_id, p_apart_id_, 1  );      

    if  (isCommit=1)  then 
                Commit;
    end if;
    
end update_tp_relation_apart;


--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 12.02.2013
  -- Описание :  процедура для создания или изменения данных по ТП
  -- Параметры:                                                                                                  
  -- Входные:     
  -- Выходные:  
procedure update_techpasport( p_tp_id_  in out  number,   p_apart_id_    number,  p_source_id_   number,
                                              p_regnum_  varchar2,  p_regdate_  date,  p_inventnum_  varchar2,   iscommit in number  )
as
l_id_user number;
begin
    
   l_id_user:=KURS3_VAR.global_user_id;
     IF  (  p_tp_id_ =0) then
        select    SEQ_TP_PASPORT.nextval into p_tp_id_ from dual;
        insert into KURS3.TP_PASPORT ( TP_ID, SOURCE_ID, REGNUM , REGDATE,  INVENT_NUM,  USER_ID )
                                             values( p_tp_id_ , p_source_id_, p_regnum_ , p_regdate_ ,p_inventnum_, l_id_user);
        --Для связи                                    
        insert into KURS3.TP_RELATION_APART (RELATION_ID, TP_ID, APART_ID,ACTIVE) 
                                                        values( SEQ_TP_RELATION_APART.nextval, p_tp_id_, p_apart_id_, 1  );      
    else                                                                            
        update  KURS3.TP_PASPORT set  SOURCE_ID= p_source_id_,  REGNUM =    p_regnum_,   REGDATE=    p_regdate_,
                                                         INVENT_NUM= p_inventnum_,    USER_ID =   l_id_user    
                                                  where  TP_ID=   p_tp_id_ ; 
    
    end if;                                            
                           
    if  (isCommit=1)  then 
                Commit;
    end if;
    
end update_techpasport;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 12.02.2013
  -- Описание :   записывает данные о движении тп 
  -- Параметры:                                                                                                  
  -- Входные:     
  -- Выходные:  
procedure update_techpasport_traffic( p_traffic_id_ in out number,
                                                        p_tp_id_   number,   
                                                        p_workplacelink_id_ number,
                                                        p_doc_num_      varchar2,
                                                        p_doc_date_      date, 
                                                        iscommit in number  )
as
l_id_user number;
l_sort_num number;
l_traffic_doc_id number;

BEGIN
    
    l_id_user:=KURS3_VAR.global_user_id;
    
    select nvl(max(nsort),0)+1 into l_sort_num from  KURS3.TP_TRAFFIC where TP_ID= p_tp_id_ ;  
     
     if  ( p_traffic_id_ =0) then   
       
        select    SEQ_TP_TRAFFIC_DOC.NEXTVAL into l_traffic_doc_id from dual;    
        
        insert into   KURS3.TP_TRAFFIC_DOC ( TRAFFIC_DOC_ID, DOC_NUM, DOC_DATE ) values( l_traffic_doc_id,  p_doc_num_,  p_doc_date_  );
     
        select    SEQ_TP_TRAFFIC.NEXTVAL into p_traffic_id_ from dual;    
        
        insert into KURS3.TP_TRAFFIC ( TP_TRAFFIC_ID, TP_ID, WORK_PLACE_LINK_ID, USER_ID, NSORT, TRAFFIC_DOC_ID )
                                           values(  p_traffic_id_ , p_tp_id_, p_workplacelink_id_,  l_id_user, l_sort_num, l_traffic_doc_id );
    --история
        insert into KURS3.TP_TRAFFIC_HISTORY ( TP_TRAFFIC_ID, TP_ID , USER_ID , LAST_CHANGE, WORK_PLACE_LINK_ID,
                                                                  ACTION, ACTION#USER_ID , ACTION#CHANGE,  NSORT, DOC_NUM, DOC_DATE ,TRAFFIC_DOC_ID )
                                                       select  TP_TRAFFIC_ID, TP_ID , USER_ID ,  LAST_CHANGE,  WORK_PLACE_LINK_ID, 
                                                                 'I', l_id_user,  sysdate , NSORT, p_doc_num_,  p_doc_date_  , TRAFFIC_DOC_ID
                                                       from  KURS3.TP_TRAFFIC  where KURS3.TP_TRAFFIC.TP_TRAFFIC_ID= p_traffic_id_;                                                 
                                             
   else                
      select  TRAFFIC_DOC_ID into l_traffic_doc_id  from   KURS3.TP_TRAFFIC  where  TP_TRAFFIC_ID= p_traffic_id_; 

      update   KURS3.TP_TRAFFIC_DOC set   DOC_NUM= p_doc_num_,
                                                                DOC_DATE=p_doc_date_   where TRAFFIC_DOC_ID=l_traffic_doc_id;
   
      update  KURS3.TP_TRAFFIC set  WORK_PLACE_LINK_ID= p_workplacelink_id_ where  TP_TRAFFIC_ID= p_traffic_id_;
        
     --история
     insert into KURS3.TP_TRAFFIC_HISTORY ( TP_TRAFFIC_ID, TP_ID , USER_ID , LAST_CHANGE, WORK_PLACE_LINK_ID,
                                                                  ACTION, ACTION#USER_ID , ACTION#CHANGE,  NSORT,  DOC_NUM, DOC_DATE, TRAFFIC_DOC_ID  )
                                                       select  TP_TRAFFIC_ID, TP_ID , USER_ID ,  LAST_CHANGE,  WORK_PLACE_LINK_ID, 
                                                                 'U',  l_id_user,  sysdate , NSORT, p_doc_num_,  p_doc_date_,  TRAFFIC_DOC_ID
                                                       from  KURS3.TP_TRAFFIC  where KURS3.TP_TRAFFIC.TP_TRAFFIC_ID= p_traffic_id_;                                                 
        
    end if;                                            
                           
    if  (isCommit=1)  then 
                Commit;
    end if;
    
end  update_techpasport_traffic;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 12.02.2013
  -- Описание :   проверка возможности выполнения групповой операции
  -- Параметры:                                                                                                  
  -- Входные:     
  -- Выходные:    
  -- code -код ошибки   
procedure check_traffic_group_operation(  p_list_code in number,
                                                             p_list_num in number,
                                                             p_code in out number,
                                                             p_m_code out varchar2
                                                              )
as
    l_id_user number;
    l_n1 NUMBER;
    l_n2 NUMBER;  
    l_sort_num number;    
    l_wpl_tp_id number;
    l_wpl_tp_id_new number; 
    l_wp_user number;
begin

    p_code:=0;     
    p_m_code:='';  
    l_wpl_tp_id :=0;
                            
    l_id_user:=KURS3_VAR.global_user_id; 
                                                                                           
    --рабочее место пользователя
    pkg_techpasport.get_workerplace(  l_wp_user );
        
    if ( p_list_code<>3) then
        p_code:=1;             
        p_m_code:='Неверный код списка!';
        return;
    end if;         
    
    --проверить на наличие выделнных строк в списке у которых есть паспорта                             
    select count(*)  into l_n1 from   V_HOUSING_LIST where 
                             list_cod= p_list_code  and list_num=p_list_num and user_id=l_id_user    
                            and note=1    --выделенные строки 
                            and  upper(trim(TP_EXISTS)) in ('ДА');
                                                                  
    --общее количество выделенных строк          
    select count(*)  into l_n2 from   V_HOUSING_LIST where 
                            list_cod= p_list_code  and list_num=p_list_num   and user_id=l_id_user    
                            and note=1;   
                          
    if (l_n1<>l_n2) then
            p_code:=2;                         
            p_m_code:='У нескольких квартир отсутствуют технические паспорта!' ;
            return;
    end if;        
    
    --все паспорта должный быть в одной организации     
    for rec in ( 
                    select TP_ID from  TP_RELATION_APART
                     where ACTIVE=1 and  APART_ID  in(   select APART_ID  from V_HOUSING_LIST
                                                                             where list_cod= p_list_code  and list_num=p_list_num
                                                                             and user_id=l_id_user  and note=1  )
                        )
    loop     
        -- послед. запись в движении
        select max(NSORT) into l_sort_num  from TP_TRAFFIC where  TP_ID=rec.TP_ID ;
        --последнее место нахождения                   
        select TO_WP into l_wpl_tp_id_new   from TP_WORK_PLACE_LINK where  WORK_PLACE_LINK_ID in (
                   select WORK_PLACE_LINK_ID  from TP_TRAFFIC where  TP_ID=rec.TP_ID  and  NSORT= l_sort_num  );               
            
        if (l_wpl_tp_id=0 ) then
                l_wpl_tp_id:=l_wpl_tp_id_new;  
        end if;       
                   
        if ( l_wpl_tp_id <> l_wpl_tp_id_new) then
                --место нахождения паспортов разные  
                p_code:=2;                         
                p_m_code:='Невозможно осуществить операцию. ТП находятся в разных организациях!' ;
                return;
        end if;  
                      
    end loop;
                               
    --может ли пользователь осуществить движение                           
     if (l_wpl_tp_id_new<> l_wp_user) then
         --есть ли другие разрешения
        --select * from V_PASPORT_TECH_OPTIONS where WORKPLACELINK_ID=:WORKPLACELINK_ID
        
            p_code:=3;                         
            p_m_code:='Вы не являетесь сотрудником организации в которой  находятся ТП!' ;
            return;
     end if;   
        
end check_traffic_group_operation;



-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 12.02.2013
  -- Описание :   выполнение групповой операции
  -- Параметры:                                                                                                  
  -- Входные:     
  -- Выходные:    
  -- code -код ошибки   
procedure update_traffic_group( p_workplacelink_id_ number,
                                                p_doc_num_      varchar2,
                                                p_doc_date_      date, 
                                                p_list_code in number,
                                                p_list_num in number,
                                                isCommit in number,
                                                p_code in out number  )
as
    l_id_user number;
    l_traffic_id number;   
    l_sort_num number;    
    l_traffic_doc_id number;
        
begin
      p_code:=0;       
     l_traffic_doc_id :=0;
          
     l_id_user:=KURS3_VAR.global_user_id;    
      --создать движение
     for rec in ( 
                        select TP_ID from  TP_RELATION_APART
                        where ACTIVE=1 and  APART_ID  in(   select APART_ID  from V_HOUSING_LIST
                                                                                where list_cod= p_list_code  and list_num=p_list_num
                                                                                and user_id=l_id_user  and note=1  )
                        )
     loop                    
               select nvl(max(nsort),0)+1 into l_sort_num from  KURS3.TP_TRAFFIC where TP_ID= rec.TP_ID ;  
               
               if (l_traffic_doc_id =0) then     
                    select    SEQ_TP_TRAFFIC_DOC.NEXTVAL into l_traffic_doc_id from dual; 
                   insert into   KURS3.TP_TRAFFIC_DOC ( TRAFFIC_DOC_ID, DOC_NUM, DOC_DATE ) values( l_traffic_doc_id,  p_doc_num_,  p_doc_date_  );
               end if; 
              
              select    SEQ_TP_TRAFFIC.NEXTVAL into l_traffic_id from dual;     
              
              insert into KURS3.TP_TRAFFIC ( TP_TRAFFIC_ID, TP_ID, WORK_PLACE_LINK_ID, USER_ID, NSORT, TRAFFIC_DOC_ID )
                                           values( l_traffic_id , rec.TP_ID, p_workplacelink_id_,  l_id_user, l_sort_num, l_traffic_doc_id );
              --история
              insert into KURS3.TP_TRAFFIC_HISTORY ( TP_TRAFFIC_ID, TP_ID , USER_ID , LAST_CHANGE, WORK_PLACE_LINK_ID,
                                                                  ACTION, ACTION#USER_ID , ACTION#CHANGE,  NSORT, DOC_NUM, DOC_DATE ,TRAFFIC_DOC_ID )
                                                       select  TP_TRAFFIC_ID, TP_ID , USER_ID ,  LAST_CHANGE,  WORK_PLACE_LINK_ID, 
                                                                 'I', l_id_user,  sysdate , NSORT, p_doc_num_,  p_doc_date_  , TRAFFIC_DOC_ID
                                                       from  KURS3.TP_TRAFFIC  where KURS3.TP_TRAFFIC.TP_TRAFFIC_ID= l_traffic_id;          
                        
     end loop;    
     
     if  (isCommit=1)  then 
           Commit;
     end if;

end update_traffic_group;



--------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 12.02.2013
  -- Описание :  обновление подписанта 
  -- Параметры:                                                                                                  
  -- Входные:     
  -- Выходные:  
procedure update_signer( p_t_doc_id_  number,   p_signt_id_    number,  p_operator_  varchar2,  p_dolgn_ varchar2,   iscommit in number  )
as
l_id_user number;
begin       
    update  KURS3.TP_TRAFFIC_DOC set   SIGN_ID= p_signt_id_ ,  OPERATOR=p_operator_ ,  DOLGNOST=  p_dolgn_,  PRINT_DATE=sysdate
     where  TRAFFIC_DOC_ID=  p_t_doc_id_ ;
                      
    if  (isCommit=1)  then                                  
                Commit;                                         
    end if;                                                       
                                                                      
end update_signer;



-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 12.02.2013
  -- Описание :   процедура для получения атрибутов движения ТехПаспорта
  -- Параметры: 
  --    p_sender_id отправитель 
  --    p_taker_id   получатель
  -- Входные:     
  -- Выходные:       
  --    po_cdata   данные о движении
procedure get_datatraffictp (p_sender_id_ number,p_taker_id_ number:=0, po_cdata_ in out kurs3.curstype)
as
   begin                                                                                                      
        if (p_taker_id_=0) then
            open po_cdata_  for            
                select  WL.FROM_WP SENDER_ID, WL.TO_WP TAKER_ID , WF.NAME as SENDER_NAME, WT.NAME as TAKER_NAME,
                 WL.DOC_TYPE_ID, DCL.NAME AS DOC_NAME,  WL.STATUS_ID, STCL.NAME AS STATUS, WL.WORK_PLACE_LINK_ID 
                 from KURS3.TP_WORK_PLACE_LINK wL     
                left  outer join KURS3.CLASSIFIER_KURS3 WF on WF.ROW_NUM=WL.FROM_WP and WF.CLASSIFIER_NUM=132 and WF.DELETED=0
                left  outer join KURS3.CLASSIFIER_KURS3 WT on WT.ROW_NUM=WL.TO_WP and WT.CLASSIFIER_NUM=132 and WT.DELETED=0     
                left outer join   KURS3.CLASSIFIER_KURS3 DCL on DCL.ROW_NUM = WL.DOC_TYPE_ID  and   DCL.CLASSIFIER_NUM=134 and DCL.DELETED=0
                left outer join   KURS3.CLASSIFIER_KURS3 STCL on STCL.ROW_NUM = WL.STATUS_ID  and   STCL.CLASSIFIER_NUM=135 and STCL.DELETED=0
                where WL.FROM_WP=p_sender_id_ ;     
        else 
            open po_cdata_  for
                select  WL.FROM_WP SENDER_ID, WL.TO_WP TAKER_ID , WF.NAME as SENDER_NAME, WT.NAME as TAKER_NAME,
                 WL.DOC_TYPE_ID, DCL.NAME AS DOC_NAME,  WL.STATUS_ID, STCL.NAME AS STATUS, WL.WORK_PLACE_LINK_ID  
                from KURS3.TP_WORK_PLACE_LINK wL     
                left  outer join KURS3.CLASSIFIER_KURS3 WF on WF.ROW_NUM=WL.FROM_WP and WF.CLASSIFIER_NUM=132 and WF.DELETED=0
                left  outer join KURS3.CLASSIFIER_KURS3 WT on WT.ROW_NUM=WL.TO_WP and WT.CLASSIFIER_NUM=132 and WT.DELETED=0     
                left outer join   KURS3.CLASSIFIER_KURS3 DCL on DCL.ROW_NUM = WL.DOC_TYPE_ID  and   DCL.CLASSIFIER_NUM=134 and DCL.DELETED=0
                left outer join   KURS3.CLASSIFIER_KURS3 STCL on STCL.ROW_NUM = WL.STATUS_ID  and   STCL.CLASSIFIER_NUM=135 and STCL.DELETED=0                                                             
                where WL.FROM_WP=p_sender_id_ and  WL.TO_WP=p_taker_id_;     
        end if;

end get_datatraffictp;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 12.02.2013
  -- Описание :    возвращвет id место работы кл 132  
  -- Параметры: 
    -- Входные:     
  -- Выходные:       
procedure get_workerplace(   p_wp_id_  in out number )
as
begin
    select workplace_id into p_wp_id_ from users where user_id=kurs3_var.global_user_id;                                                    
    exception
         when no_data_found then
            p_wp_id_:=0;
end get_workerplace;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 12.02.2013
  -- Описание :   удаление  данных о движении тп 
  -- Параметры: 
    -- Входные:     
  -- Выходные:       
procedure delete_techpasport_traffic( p_traffic_id_  number,  iscommit in number  )
as
l_id_user number;
BEGIN
    
    l_id_user:=KURS3_VAR.global_user_id;     
    
    --история    
       insert into KURS3.TP_TRAFFIC_HISTORY ( TP_TRAFFIC_ID,  TP_ID , USER_ID ,  LAST_CHANGE,  WORK_PLACE_LINK_ID, ACTION,
                                                                     ACTION#USER_ID , ACTION#CHANGE,  NSORT, TRAFFIC_DOC_ID, DOC_NUM, DOC_DATE )
                                                        select   TP_TRAFFIC_ID,  TP_ID ,  USER_ID ,  LAST_CHANGE,    WORK_PLACE_LINK_ID, 
                                                                    'D',  l_id_user,  sysdate ,  NSORT,TRAFFIC_DOC_ID,
                                                                    ( select  DOC_NUM from TP_TRAFFIC_DOC where  TRAFFIC_DOC_ID=TP_TRAFFIC.TRAFFIC_DOC_ID),
                                                                    ( select  DOC_DATE from TP_TRAFFIC_DOC where  TRAFFIC_DOC_ID=TP_TRAFFIC.TRAFFIC_DOC_ID)
                                                         from  KURS3.TP_TRAFFIC   where TP_TRAFFIC.TP_TRAFFIC_ID=  p_traffic_id_;
       
    delete from   TP_TRAFFIC where TP_TRAFFIC.TP_TRAFFIC_ID= p_traffic_id_   ;                    
                           
    if  (isCommit=1)  then 
                Commit;
    end if;
    
end delete_techpasport_traffic;



-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 12.02.2013
  -- Описание :   Функция предназначена для получения адреса квартиры по коду здания и коду квартиры 
  -- Параметры:  
    -- Входные:
    --      p_build_id_  код здания,   
    --       p_a_id_    код квартиры 
  -- Выходные:         
  -- адрес строкой  
function apartment_techpasport ( p_build_id_ number := 0, p_a_id_ number, p_with_num_ number := 0) return varchar2 
 as
    l_a varchar2(200);
    l_bild number;
begin

    l_bild:= p_build_id_;
    if (  p_build_id_=0) then
         select  building_id  into l_bild   from KURS3.apartment  where  apartment.apart_id=p_a_id_  and rownum=1;
     end if;

   select ADDR_BUILDING(building_id)|| decode(p_with_num_, 1, '', '-' ||to_char(apartment_num)||apartment_idx)  into l_a
   from KURS3.apartment where   apartment.building_id=l_bild  and apartment.apart_id= p_a_id_  and rownum=1;

    return (l_a);
end apartment_techpasport;

-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 22.02.2013
  -- Описание :   Функция предназначена для получения адреса квартиры по коду здания (без номера квартиры) 
  -- Параметры:  
    -- Входные:
      --       p_a_id_    код квартиры 
  -- Выходные:         
  -- адрес строкой  
function get_building_adress ( p_a_id_ number) return varchar2
 as
    l_a varchar2(1000);
    l_bild number;
begin
     select  building_id  into l_bild   from KURS3.apartment  where  apartment.apart_id=p_a_id_  and rownum=1;
     select ADDR_BUILDING( l_bild )  into l_a  from dual where rownum=1;
    return (l_a);
end get_building_adress;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 22.02.2013
  -- Описание :   Функция предназначена для получения ид текущего пользователя
  -- Параметры:  
    -- Входные:
  -- Выходные:         
   -- количество
function get_user_id  return number
as
begin
     return (  KURS3_VAR.global_user_id  );
end get_user_id ;

-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 22.02.2013
  -- Описание :   Функция предназначена для получения количество техпаспортов  по зданию
  -- Параметры:  
    -- Входные:
      --       p_a_id_    код квартиры   
      --      p_traffic_doc_id ид акта передачи
  -- Выходные:         
   -- количество
function get_aprt_count ( p_a_id_ number, p_traffic_doc_id number, p_work_place_link_id number ) return number
as
    l_count  number;  
    l_bild  number; 
begin
     select  building_id  into l_bild   from KURS3.apartment  where  apartment.apart_id=p_a_id_  and rownum=1;
     select count(*) into l_count from (    
                                                        select distinct  RA.APART_ID  from  TP_TRAFFIC TPT     
                                                        join TP_PASPORT TP ON TP.TP_ID=TPT.TP_ID   
                                                        join TP_RELATION_APART RA ON TP.TP_ID=RA.TP_ID and  RA.active=1
                                                        join   apartment ap on  AP.APART_ID=RA.APART_ID and  ap.building_id= l_bild
                                                        where  TPT.TRAFFIC_DOC_ID= p_traffic_doc_id and TPT.WORK_PLACE_LINK_ID=p_work_place_link_id
                                                    );                
    return (l_count);
end get_aprt_count ;

-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 22.02.2013
  -- Описание :   Функция предназначена для получения номеров квартир по зданию у которых есть техпаспорта
  -- Параметры:  
  -- Входные:
  --       p_a_id_    код квартиры  
  --      p_traffic_doc_id ид акта передачи      
  -- Выходные:         
  -- строка(список квартир разделенных ',')  
function get_aprt_number ( p_a_id_ number, p_traffic_doc_id number, p_work_place_link_id number ) return varchar2
as
    l_a varchar2(1000);
    l_count  number;  
    l_bild  number; 
begin
    select  building_id  into l_bild   from KURS3.apartment  where  apartment.apart_id=p_a_id_  and rownum=1;
    for rec in (  select distinct  ap.apartment_num, ap.apartment_idx  from  TP_TRAFFIC TPT     
                                join TP_PASPORT TP ON TP.TP_ID=TPT.TP_ID   
                                join TP_RELATION_APART RA ON TP.TP_ID=RA.TP_ID and  RA.active=1
                                join   apartment ap on  AP.APART_ID=RA.APART_ID and  ap.building_id= l_bild
                                where  TPT.TRAFFIC_DOC_ID= p_traffic_doc_id and TPT.WORK_PLACE_LINK_ID=p_work_place_link_id )
    loop
      l_a   :=  l_a || OWA_UTIL.ite ( l_a IS NULL, '', ',') ||to_char(rec.apartment_num)||rec.apartment_idx;       
    end loop;    
                                                              
    return ( l_a);
end get_aprt_number ;




-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 12.02.2013
  -- Описание :   процедура для получения право на редактирование техпаспорта в зависимости от типа жилья
  -- Параметры:  
    -- Входные:
  -- Выходные:         
procedure get_eanable_edit_tp (p_freespace_id_ number, p_isedit  out number, p_istrafficedit out number)
as
begin
    select  case when ( (nvl(new_building_code,0) =0) and (get_user_priv (112) = 1) ) or  --з/в
                              ( (nvl(new_building_code,0) <>0) and (get_user_priv (111) = 1) )  then 1 else 0 end,
              case when  (get_user_priv (113) = 1) then 1 else 0 end
     into p_isEdit,   p_isTrafficEdit       
     from   free_space where   freespace_id = p_freeSpace_id_;  
      --DECODE (free_space.new_building_code,    0, 'З/В',    NULL, 'З/В', 'Н/С') housing_list
end get_eanable_edit_tp;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 12.02.2013
  -- Описание :   Функция предназначена для получения дополнительных разрешений для направления движения
  -- Параметры:  
    -- Входные:
  -- Выходные:         
function get_techpasport_options ( p_wpid_ number) return varchar2 as

    l_so varchar2(1000);
cursor l_cso is  
    select * from KURS3.TP_WORK_PLACE_LINK_OPTIONS wo
    left join KURS3.CLASSIFIER_KURS3 WF on wo.WORKPLACE_ID= WF.ROW_NUM and WF.CLASSIFIER_NUM=132 and WF.DELETED=0 
    where wo.WORK_PLACE_LINK_ID= p_wpid_  ;
    
begin
    l_so:='';
    for rcso in l_cso loop
            l_so :=  l_so || trim(rcso.name) || ', ';
   end loop;   
  
    return ( substr(l_so, 1, length(l_so)-2) );
end  get_techpasport_options;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 12.02.2013
  -- Описание :   Функция предназначена для получения номера акта передачи паспорта
  -- Параметры:  
   --  p_type_act_ тип акста (кл. 134) 
    -- Входные:
  -- Выходные: 
  -- номер акта типа  --АПС/2013/10/01        
function get_traffict_act_number ( p_type_act_ number) return varchar2 as
    l_num number:=1;
    l_act varchar2(100);  
begin
    select upper(trim(SHORT_NAME3)) into  l_act from  KURS3.CLASSIFIER_KURS3 where ROW_NUM = p_type_act_  and  CLASSIFIER_NUM=134 and DELETED=0;
    if   l_act is not null then
       select  l_act ||'/'|| to_char(sysdate, 'yyyy')||'/'||to_char(sysdate, 'mm')||'/' into  l_act  from dual ; 
       --сквозной номр независимо от типа документа  
      -- select nvl(max(to_number(trim(substr(doc_num,13)))),0  )+1  into  l_num  from  TP_TRAFFIC_DOC  where substr(doc_num,4,9 ) = substr(l_act,4, 9 ) ;
      --сквозной номр зависимо от типа документа  
         select nvl(max(to_number(trim(substr(doc_num,13)))),0  )+1  into  l_num  from  TP_TRAFFIC_DOC  where substr(doc_num,1,12 ) = l_act  ;
          l_act:=l_act||case when ( l_num<=9) then '000'
                                     when ( l_num<=99) then '00'
                                     when ( l_num<=999) then '0'   
                              else '' end||to_char( l_num);
    end if;      
                 
    return ( l_act );
end   get_traffict_act_number;



-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 13.02.2013
  -- Описание :  процедура для получения атрибутов ТехПаспорта  по номеру ордера для представляемой площади
  -- Параметры:  
   --  p_order_id_ идентификатор выписки
    -- Входные:
  -- Выходные:
  --  po_cData   атрибуты техпаспорта
 procedure get_data_techpasport (p_order_id_ number, po_cdata  out kurs3.curstype)
as
    l_apart_id_ number:=0;
begin

    --площадь в ордере
    select  get_order_apart_id (orders.order_id, orders.document_type) into l_apart_id_   from orders where orders.order_id=p_order_id_;
        
    --сами данные по техпаспорту(номер и дата регистрации и  т.п. .....)
    OPEN  po_cdata for   select * from V_PASPORT_TECH where apart_id=l_apart_id_; 
    
end get_data_techpasport;


-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 13.02.2013
  -- Описание :  процедура передачи ТехПаспорта  гражданину
  -- Параметры:  
  --    p_tp_id_         ид - техпаспорта
  --    p_doc_num_    -номер документа передачи     
  --    p_date_num_   дата документа передачи
  -- Входные:
  -- Выходные:
  --    po_code_    --возврат 0-все ок, -1 нет ид, -2 не может передать, -3  тп не на месте,  -4 другие ошибки 
 procedure update_tp_from_rd ( p_tp_id_ in number, p_doc_num_ in varchar2, p_date_num_ in date, po_code_  out number)
as
    l_nsort_       number := 0;  
    l_wpl_id_     number := 0; 
    l_taker_id_   number := 20; --получатель(гражданин)
    l_wpl_id_tp_ number := 0;    
    l_tp_trf_id_   number := 0;        
    l_wpl_tp_     number  := 0;  
    l_nc_           number  := 0;
begin

     po_code_:=0;
     if  ( nvl( p_tp_id_, 0 ) = 0 )  then
       po_code_:= -1;
        return;     
     end if;                                               
                                  
     --место работы пользователя
     select WORKPLACE_ID into l_wpl_id_  from USERS where USER_ID=KURS3_VAR.GLOBAL_USER_ID;
     
     --может ли эта организация передать техпаспорт гражданину    
     select count(*) into l_nc_ from   TP_WORK_PLACE_LINK where FROM_WP = l_wpl_id_ and TO_WP = l_taker_id_;       
     
     if ( l_nc_ = 0) then
        po_code_:=-2; 
        return;
     end if; 
       
     -- послед. запись в движении
     select max(NSORT) into l_nsort_  from TP_TRAFFIC where  TP_ID=p_tp_id_ ;
     
     --последнее место нахождения                   
     select TO_WP into l_wpl_id_tp_  from TP_WORK_PLACE_LINK where  WORK_PLACE_LINK_ID in (
               select WORK_PLACE_LINK_ID  from TP_TRAFFIC where  TP_ID=p_tp_id_  and  NSORT=l_nsort_  );
        
    if ( l_wpl_id_ <> l_wpl_id_tp_) then
        --рабочее место пользователя и место нахождение паспорта разные
        po_code_:=-3; 
        return;
    end if;                            
      
    select WORK_PLACE_LINK_ID into l_wpl_tp_  from   TP_WORK_PLACE_LINK where FROM_WP = l_wpl_id_ and TO_WP = l_taker_id_;
       
    --передача тп       
     update_techpasport_traffic(  l_tp_trf_id_,  p_tp_id_,  l_wpl_tp_,  p_doc_num_,  p_date_num_, 1  );    
     
     return;  
     
    exception
        when others then  po_code_ := -4; 
    
end update_tp_from_rd;

-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 13.02.2013
  -- Описание :  роцедура удаления ТехПаспорта  (врозврать ТП в организацию выдавшую его)
  -- Параметры:  
  --    p_tp_id_         ид - техпаспорта
  -- Входные:
  -- Выходные:
  --    po_code_    --возврат 0-все ок, -1 нет ид, -2 тп не у гражданина , -3  другие ошибки 
procedure delete_tp_from_rd ( p_tp_id_ in number, po_code_  out number)
as
    l_nsort_       number := 0;  
    l_wpl_id_     number := 0; 
    l_taker_id_   number := 20; --получатель(гражданин)
    l_wpl_id_tp_ number := 0;    
    l_tp_trf_id_   number := 0;        
    l_wpl_tp_     number  := 0;  
    l_nc_           number  := 0;
begin

     po_code_:=0;
     if  ( nvl( p_tp_id_,0) = 0 )  then
       po_code_:= -1;
        return;     
     end if;            
     
     --проверка передан ли этот тп гражданину         
     -- послед. запись в движении
     select max(NSORT) into l_nsort_  from TP_TRAFFIC where  TP_ID=p_tp_id_ ;    
     
     select TO_WP into l_wpl_id_tp_  from TP_WORK_PLACE_LINK where  WORK_PLACE_LINK_ID in (
               select WORK_PLACE_LINK_ID  from TP_TRAFFIC where  TP_ID=p_tp_id_  and  NSORT=l_nsort_  );
         
    if ( l_taker_id_ <> l_wpl_id_tp_) then
         --ТП не передан гражданину
        po_code_:=-2; 
        return;
    end if;      
    
   select TP_TRAFFIC_ID into l_tp_trf_id_ from TP_TRAFFIC where  TP_ID=p_tp_id_  and  NSORT=l_nsort_  ;                
                                 
   delete_techpasport_traffic(  l_tp_trf_id_, 1);
   
    return;  
     
    exception
        when others then   po_code_:= -3; 
    
end delete_tp_from_rd;



-------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                 
   -- Автор  : ilonis
  -- Дата создания : 13.02.2013
  -- Описание :   Функция предназначена  представления v_hausing_lists (признак наличия техпаспорта) 1- ДА, 2-НЕТ  из 8 справочника
  -- Параметры:  
  -- Входные:    
  --     p_apart_id_ идентификатор помещения  
  -- Выходные: 
  -- 1- ДА, 2-НЕТ      
function get_techpasport_exists ( p_apart_id_ number ) return number as
    l_count number :=2;    
begin

 select count(*)  into   l_count  from TP_RELATION_APART where  APART_ID= p_apart_id_; 
   --  select count(*)  into   l_count  from  TP_PASPORT  where  APART_ID= p_apart_id_;      
    return ( case when (l_count>0) then 1 else 2 end );
end  get_techpasport_exists;


end pkg_techpasport;
/