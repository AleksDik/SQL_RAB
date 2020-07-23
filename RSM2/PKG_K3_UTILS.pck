create or replace package PKG_K3_UTILS is

  -- Author  : DIKAN
  -- Created : 18.03.2019 16:48:13
  -- Purpose : 
c_section_name constant varchar2(10) := 'pname';
c_section_val constant varchar2(10) := 'pval';

  -- Public function and procedure declarations
procedure GET_CLASSIFIER_KURS3  (p_cl_num in NUMBER, p_row_num in NUMBER := -1, p_outfield in NUMBER :=0, CUR_CLASSIFIER in out SYS_REFCURSOR );
function GET_CLASSIFIER_KURS3_STR  (p_cl_num in NUMBER, p_row_num in NUMBER, p_outfield in NUMBER :=0 ) return varchar2;
function GET_OKRUG_NAME  (p_oid in NUMBER, p_outfield in NUMBER :=0 ) return varchar2;
procedure GET_CLASSIFIER_FOR_FIND  (p_cl_num in NUMBER,  p_outfield in NUMBER :=0, CUR_CLASSIFIER  in out SYS_REFCURSOR );


--ilonis 05/06/2020
--количество 
function get_count_decl return NUMBER;
function get_count_kpu return NUMBER;
function get_count_porder return NUMBER;
function get_count_order return NUMBER;
function get_count_livingspace return NUMBER;

function get_json_value_from_obj(p_in varchar2,p_value_name varchar2) return json_value;
function get_json_value_from_list(p_in varchar2, p_value_name varchar2, p_section_name varchar2 := c_section_name, p_section_val varchar2 := c_section_val ) return json_value;
function get_json_value_from_list_i(p_in varchar2, p_value_name varchar2, p_pos number, p_section_name varchar2 := c_section_name, p_section_val varchar2 := c_section_val ) return json_value;


-- Author  : DIKAN
-- Created : 06.07.2020
-- return:
-- (-1) -ошибка текст в a_err, 0 - возвращаемое значение не задано (NULL); 
-- 1- возвращаемое значение number в a_number; 2 - varchar2 в a_string; 3 -  date в a_date ; 4 - boolean в a_bool;
-- 5 - json array в a_string; 6 - json object в a_string;
function get_param_value_from_json(p_json_str in varchar2, p_value_name in varchar2, 
                                   a_number out number,
                                   a_string out varchar2, 
                                   a_date   out date, 
                                   a_bool   out boolean,
                                   a_err    out varchar2)  return integer;
                                   
function get_param_value_from_json(p_json_str in varchar2, p_value_name in varchar2, a_err out varchar2)  return varchar2;
function get_number_from_json (p_json_str in varchar2, p_value_name in varchar2) return number;
function get_string_from_json (p_json_str in varchar2, p_value_name in varchar2) return varchar2;
function get_date_from_json (p_json_str in varchar2, p_value_name in varchar2) return date;
function get_bool_from_json (p_json_str in varchar2, p_value_name in varchar2) return boolean;
function GetResultJsonStr( p_ResultType number, p_message varchar2:=null, p_errmessage varchar2:=null, p_id varchar2:=null) return varchar2; 

                                   
end PKG_K3_UTILS;
/
create or replace package body PKG_K3_UTILS is

 
procedure GET_CLASSIFIER_KURS3  (p_cl_num in NUMBER, p_row_num in NUMBER := -1,  p_outfield in NUMBER :=0, CUR_CLASSIFIER  in out SYS_REFCURSOR )
as
 
 begin
  if p_cl_num < 101 then 
    OPEN CUR_CLASSIFIER FOR 
    SELECT  cl.CLASSIFIER_NUM
            ,cl.ROW_NUM
            ,cl.LAST_CHANGE
            ,cl.ROW_STATUS
            , case p_outfield 
                         when 1 then Trim(cl.short_name1)
                         when 2 then Trim(cl.short_name2)
                         when 3 then Trim(cl.short_name3)
            else  Trim(cl.name)
            end  as name             
            ,cl.SHORT_NAME1
            ,cl.SHORT_NAME2
            ,cl.SHORT_NAME3
            ,cl.DELETED
    FROM  KURS3.CLASSIFIER cl
    where  cl.CLASSIFIER_NUM = p_cl_num
      and  Cl.DELETED = 0
      and  cl.row_num = DECODE(p_row_num,-1,cl.row_num,p_row_num)
    order by cl.row_num;  
 else
    OPEN CUR_CLASSIFIER FOR 
    SELECT  cl.CLASSIFIER_NUM
            ,cl.ROW_NUM
            ,cl.LAST_CHANGE
            ,cl.ROW_STATUS
            , case p_outfield 
                         when 1 then Trim(cl.short_name1)
                         when 2 then Trim(cl.short_name2)
                         when 3 then Trim(cl.short_name3)
            else  Trim(cl.name)
            end  as name             
            ,cl.SHORT_NAME1
            ,cl.SHORT_NAME2
            ,cl.SHORT_NAME3
            ,cl.DELETED
    FROM  KURS3.CLASSIFIER_KURS3 cl
    where  cl.CLASSIFIER_NUM = p_cl_num
      and  Cl.DELETED = 0
      and  cl.row_num = DECODE(p_row_num,-1,cl.row_num,p_row_num)
    order by cl.row_num;  
 end if;  
end  GET_CLASSIFIER_KURS3;



procedure GET_CLASSIFIER_FOR_FIND  (p_cl_num in NUMBER,  p_outfield in NUMBER :=0, CUR_CLASSIFIER  in out SYS_REFCURSOR )
as
 
 begin

  if p_cl_num < 101 then 
    OPEN CUR_CLASSIFIER FOR 
        SELECT 
           a.ROW_NUM  as ItemID
          ,a.ROW_NUM  as Code
          ,a.v_name as SName
          ,a.v_name as value
          ,a.v_name as full_name
          , null as ParentID 
          , null as subject_rf_id
          , null as short_name
          , null as name_for_sort 
    FROM (
    SELECT   cl.ROW_NUM
            , case p_outfield 
                         when 1 then Trim(cl.short_name1)
                         when 2 then Trim(cl.short_name2)
                         when 3 then Trim(cl.short_name3)
            else  Trim(cl.name)
            end  as v_name             
    FROM  KURS3.CLASSIFIER cl
    where  cl.CLASSIFIER_NUM = p_cl_num
      and  Cl.DELETED = 0
      order by cl.row_num) a
      ;  
 else
    OPEN CUR_CLASSIFIER FOR 
    SELECT a.ROW_NUM  as ItemID
          ,a.ROW_NUM  as Code
          ,a.v_name as SName
          ,a.v_name as value
          ,a.v_name as full_name
          , null as ParentID 
          , null as subject_rf_id
          , null as short_name
          , null as name_for_sort 
    FROM (
    SELECT   cl.ROW_NUM
            , case p_outfield 
                         when 1 then Trim(cl.short_name1)
                         when 2 then Trim(cl.short_name2)
                         when 3 then Trim(cl.short_name3)
            else  Trim(cl.name)
            end  as v_name             
    FROM  KURS3.CLASSIFIER_KURS3 cl
    where  cl.CLASSIFIER_NUM = p_cl_num
      and  Cl.DELETED = 0
     order by cl.row_num) a ;  
 end if;  
end  GET_CLASSIFIER_FOR_FIND;   


function GET_CLASSIFIER_KURS3_STR  (p_cl_num in NUMBER, p_row_num in NUMBER, p_outfield in NUMBER :=0 ) return varchar2
as
  v_CUR SYS_REFCURSOR;
  v_row KURS3.CLASSIFIER_KURS3%rowtype;
  v_RET KURS3.CLASSIFIER_KURS3.NAME%type := null;
 begin       
   GET_CLASSIFIER_KURS3(p_cl_num, p_row_num , p_outfield, v_CUR );
   loop
       fetch v_CUR into v_row;
       EXIT WHEN v_CUR%NOTFOUND; 
       v_RET := v_row.name;                  
    end loop;
  close v_CUR;    
  return(v_RET);
 
 end  GET_CLASSIFIER_KURS3_STR;  
 
function GET_OKRUG_NAME  (p_oid in NUMBER, p_outfield in NUMBER :=0 ) return varchar2
as
  v_CUR SYS_REFCURSOR;
  v_row KURS3.Area%rowtype;
  v_RET KURS3.Area.NAME%type := null;
 begin       
  
  OPEN v_CUR FOR 
    SELECT *
    FROM  KURS3.AREA a
    where  a.okrug_id = p_oid
      and  a.deleted = 0
    order by a.okrug_id;  
    loop
       fetch v_CUR into v_row;
       EXIT WHEN v_CUR%NOTFOUND; 
       case p_outfield when 1 then v_RET := v_row.short_name1;
                       when 2 then v_RET := v_row.short_name2;
                       when 3 then v_RET := v_row.short_name3;
        else  v_RET := v_row.name;  
       end case;                  
      end loop;
  
  close v_CUR;    
  return(Trim(v_RET));
 
 end  GET_OKRUG_NAME;  
 
 
 --ilonis 05/06/2020
--количество 
function get_count_decl return NUMBER
as
    l_ret number;
begin
    select count(*) into l_ret  from kurs3.affair af where AF.AFFAIR_STAGE=0;
    return (l_ret);
end get_count_decl;

function get_count_kpu return NUMBER
as
    l_ret number;
begin
    select count(*) into l_ret  from kurs3.affair af where AF.AFFAIR_STAGE=1 and status <>5;  
    return (l_ret);
end get_count_kpu;

function get_count_porder return NUMBER
as
    l_ret number;
begin
    select count(*) into l_ret  from kurs3.orders o where O.ORDER_STAGE=2 and O.CANCEL_DATE is not null;
    return (l_ret);
end get_count_porder;

function get_count_order return NUMBER
as
    l_ret number;
begin
    select count(*) into l_ret  from kurs3.orders o where O.ORDER_STAGE<2 and O.CANCEL_DATE is not null;
    return (l_ret);
end get_count_order;


function get_count_livingspace return NUMBER
as
    l_ret number;
begin
    select count(*) into l_ret  from kurs3.free_space fs where fs.LAST IN (1, 2);
    return (l_ret);
end get_count_livingspace;



function get_json_value_from_obj(p_in varchar2, p_value_name varchar2) return json_value
as 
  obj json; 
  JO  json;
  jv json_value :=null;
  JL json_list;  
  v_in varchar2(2000) := NULL;
 
c integer;
i integer;


begin
  obj := json(p_in);
  if  obj.exist(p_value_name) then
       jv := json_ext.get_json_value( obj, p_value_name);  
  return (jv);
  end if; 
  c:=obj.count;
For i in 1..c 
loop  
 jv := obj.get(i);
 if  (jv.is_object) then
     JO:=json(jv);
     if  JO.exist(p_value_name) then
       jv := json_ext.get_json_value( jo, p_value_name);  
       return (jv);
     end if; 
     v_in := json_ac.object_to_char(JO,false);
     jv := get_json_value_from_obj(v_in,p_value_name);
     if not (jv.is_null) then
        return (jv);
     end if;   
  elsif json_ac.jv_is_array(jv) then
        JL :=  json_list(jv);
        v_in := json_ac.array_to_char(JL,false);
        jv := get_json_value_from_list(v_in,p_value_name);
        if not (jv.is_null) then
           return (jv);
        end if; 
 end if;
  jv := json_value.makenull;
end loop; 

return(jv);

  exception 
  when OTHERS then  
    jv := json_value.makenull;
    return(jv);
end get_json_value_from_obj;



function get_json_value_from_list(p_in varchar2, p_value_name varchar2, p_section_name varchar2 := c_section_name, p_section_val varchar2 := c_section_val ) return json_value
as 
  JO    json; 
  List  json_list;
  JL    json_list;  
  jv    json_value := json_value.makenull;
  v_in  varchar2(2000) := NULL;
 
c integer;
i integer;


begin
  List := json_list(p_in);
  c := json_ac.array_count(List);
For i in 1..c 
loop  
 jv := json_ac.array_get(List,i);
 if  (jv.is_object) then
     JO:=json(jv);
     if  JO.exist(p_value_name) then
       jv :=  JO.get(p_value_name);  
       return (jv);
     elsif  JO.exist(p_section_name) then 
           jv :=  JO.get(p_section_name);
           if (lower(p_value_name)=lower(jv.get_string)) then
              jv := json_ext.get_json_value( JO, p_section_val);
              return (jv);
           end if;  
     end if;
     v_in := json_ac.object_to_char(JO,false);
     jv := get_json_value_from_obj(v_in,p_value_name);
     if not (jv.is_null) then
        return (jv);
     end if;
        
  elsif json_ac.jv_is_array(jv) then
        JL :=  json_list(jv);
        v_in := json_ac.array_to_char(JL,false);
       -- dbms_output.put_line('i='||i||'  '||v_in);        
        jv := get_json_value_from_list(v_in,p_value_name,p_section_name,p_section_val);
        if not (jv.is_null) then
         return (jv);
        end if; 
 end if;
  jv := json_value.makenull;
end loop; 

return(jv);

  exception 
  when OTHERS then
   -- dbms_output.put_line( DBMS_UTILITY.FORMAT_ERROR_STACK || ' BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    jv := json_value.makenull;
    return(jv);
end get_json_value_from_list;

function get_json_value_from_list_i(p_in varchar2, p_value_name varchar2, p_pos number, p_section_name varchar2 := c_section_name, p_section_val varchar2 := c_section_val ) return json_value
as 
  JO    json; 
  List  json_list;
  JL    json_list;  
  jv    json_value := json_value.makenull;
  v_in  varchar2(2000) := NULL;
 
c integer;

begin
  List := json_list(p_in);
  c := json_ac.array_count(List);
  if ( p_pos < 1) or (p_pos > c) then
      return (jv);
  end if;
 jv := json_ac.array_get(List,p_pos);
 if  (jv.is_object) then
     JO:=json(jv);
     if  JO.exist(p_value_name) then
       jv :=  JO.get(p_value_name);  
       return (jv);
     elsif  JO.exist(p_section_name) then 
           jv :=  JO.get(p_section_name);
           if (lower(p_value_name)=lower(jv.get_string)) then
              jv := json_ext.get_json_value( JO, p_section_val);
              return (jv);
           end if;  
     end if;
     v_in := json_ac.object_to_char(JO,false);
     jv := get_json_value_from_obj(v_in,p_value_name);
     if not (jv.is_null) then
        return (jv);
     end if;
        
  elsif json_ac.jv_is_array(jv) then
        JL :=  json_list(jv);
        v_in := json_ac.array_to_char(JL,false);
       -- dbms_output.put_line('i='||i||'  '||v_in);        
        jv := get_json_value_from_list(v_in,p_value_name,p_section_name,p_section_val);
        if not (jv.is_null) then
         return (jv);
        end if; 
 end if;
  jv := json_value.makenull;

return(jv);

  exception 
  when OTHERS then
    raise;
   -- dbms_output.put_line( DBMS_UTILITY.FORMAT_ERROR_STACK || ' BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
   -- jv := json_value.makenull;
  --  return(jv);
end get_json_value_from_list_i;

function get_param_value_from_json(p_json_str in varchar2, p_value_name in varchar2, 
                                   a_number out number,
                                   a_string out varchar2, 
                                   a_date   out date, 
                                   a_bool   out boolean,
                                   a_err    out varchar2)  return integer
as 
  JO    json; 
  JL    json_list;  
  jv    json_value := json_value.makenull;
  v_result integer := -1;  -- (-1) -ошибка текст в a_err, 0 - возвращаемое значение не задано (NULL); 
                           -- 1- возвращаемое значение number; 2 - varchar2; 3 -  date ; 4 - boolean;
                           -- 5 - json array в a_string; 6 - json object в a_string;

begin
  a_number  := NULL;
  a_string  := NULL;
  a_date    := NULL;
  a_bool    := NULL;
  a_err     := NULL;

  begin
   JL :=  json_list(p_json_str)  ;
   jv:= json_ac.array_to_json_value(JL);
   exception 
    when OTHERS then jv  := json_value.makenull;
  end;
  if jv.is_null then 
   begin
      JO := json(p_json_str);
      jv := json_ac.object_to_json_value(JO);
    exception 
    when OTHERS 
       then jv  := json_value.makenull;
            a_err := DBMS_UTILITY.FORMAT_ERROR_STACK || ' BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
   end;
  end if; 
  
  if jv.is_null then 
   a_err := 'Ќеверный формат json. '||a_err;
   return(v_result);
  elsif json_value.is_array(jv) then
     jv := PKG_K3_UTILS.get_json_value_from_list(p_json_str,p_value_name); 
  elsif  json_value.is_object(jv) then
     jv := PKG_K3_UTILS.get_json_value_from_obj(p_json_str ,p_value_name);
  end if; 
  
if json_ac.jv_is_null(jv) then 
    a_err := p_value_name || ' = NULL';
    v_result := 0;
elsif  json_ac.jv_is_bool(jv) then  
    a_bool :=  json_ac.jv_get_bool(jv);
    v_result := 4;
elsif json_ext.is_date(jv) then  
    a_string :=  json_ac.jv_get_string(jv);
    a_date := TO_DATE(a_string,'DD.MM.YYYY');
   --  a_date := json_ext.to_date2 (jv);
    v_result := 3;
elsif  json_ac.jv_is_string(jv) then
   a_string :=  json_ac.jv_get_string(jv);
   v_result := 2; 
elsif  json_ac.jv_is_number(jv) then  
    a_number :=  json_ac.jv_get_number(jv);
    v_result := 1; 
 
elsif json_value.is_array(jv) then 
 a_string := json_ac.jv_to_char(jv);
 v_result := 5;
-- a_err :=  p_value_name || || ' is array';
 elsif  json_value.is_object(jv) then  
 a_string := json_ac.jv_to_char(jv);
 v_result := 6;  
--a_err :=  p_value_name || ' is object';      
end if;

    return (v_result);
    
exception 
  when OTHERS then
     a_err := DBMS_UTILITY.FORMAT_ERROR_STACK || ' BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
     return (-1);
     
end get_param_value_from_json;



function get_param_value_from_json(p_json_str in varchar2, p_value_name in varchar2, a_err out varchar2)  return varchar2
as 
  JO    json; 
  JL    json_list;  
  jv    json_value := json_value.makenull;
  v_result varchar2(2000) := '';
begin
  a_err     := NULL;

  begin
   JL :=  json_list(p_json_str)  ;
   jv:= json_ac.array_to_json_value(JL);
   exception 
    when OTHERS then jv  := json_value.makenull;
  end;
  if jv.is_null then 
   begin
      JO := json(p_json_str);
      jv := json_ac.object_to_json_value(JO);
    exception 
    when OTHERS 
       then jv  := json_value.makenull;
            a_err := DBMS_UTILITY.FORMAT_ERROR_STACK || ' BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
   end;
  end if; 
  
  if jv.is_null then 
   a_err := 'Ќеверный формат json. '||a_err;
   return(NULL);
  elsif json_value.is_array(jv) then
     jv := PKG_K3_UTILS.get_json_value_from_list(p_json_str,p_value_name); 
  elsif  json_value.is_object(jv) then
     jv := PKG_K3_UTILS.get_json_value_from_obj(p_json_str ,p_value_name);
  end if; 
  
if json_ac.jv_is_null(jv) then 
    v_result := NULL;
elsif  json_ac.jv_is_string(jv) then
   v_result :=  json_ac.jv_get_string(jv);
elsif json_value.is_array(jv) then 
 v_result := json_ac.jv_to_char(jv);
 a_err :=  p_value_name ||  'array';
 elsif  json_value.is_object(jv) then  
 v_result := json_ac.jv_to_char(jv);
 a_err :=  p_value_name || 'object';      
else v_result :=  json_ac.jv_to_char(jv);
     
end if;

    return (v_result);
    
exception 
  when OTHERS then
     a_err := DBMS_UTILITY.FORMAT_ERROR_STACK || ' BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
     return (NULL);
     
end get_param_value_from_json;

function get_number_from_json (p_json_str in varchar2, p_value_name in varchar2) return number
is 
 s_result varchar2(2000);
 i_result number := 0;
 
 l_number  number;
 l_string  varchar2(2000); 
 l_date    date; 
 l_bool    boolean;
 l_err     varchar2(2000) := NULL;
  
 BEGIN
   i_result := get_param_value_from_json(p_json_str,p_value_name,l_number,l_string,l_date,l_bool,l_err);
   if i_result < 0 then
         raise_application_error( -20111, l_err );
   elsif i_result = 1  then  -- 1- возвращаемое значение number;
         return(l_number);
   elsif i_result = 0  then  
         return(NULL);
   else
        s_result := p_value_name||'не правильный тип ('||i_result||')';
         raise_application_error( -20111, s_result );
   end if; 
end get_number_from_json;   


function get_string_from_json (p_json_str in varchar2, p_value_name in varchar2) return varchar2
is 
 s_result varchar2(2000);
 i_result number := 0;
 
 l_number  number;
 l_string  varchar2(2000); 
 l_date    date; 
 l_bool    boolean;
 l_err     varchar2(2000) := NULL;
  
 BEGIN
   i_result := get_param_value_from_json(p_json_str,p_value_name,l_number,l_string,l_date,l_bool,l_err);
   if i_result < 0 then
         raise_application_error( -20111, l_err );
   elsif i_result = 2  then  -- возвращаемое значение --  2 - varchar2;
         return(l_string);
   elsif i_result = 0  then  
         return(NULL);
   else
        s_result := p_value_name||'не правильный тип ('||i_result||')';
         raise_application_error( -20111, s_result );
   end if; 
end get_string_from_json;
 
function get_date_from_json (p_json_str in varchar2, p_value_name in varchar2) return date
is 
 s_result varchar2(2000);
 i_result number := 0;
 
 l_number  number;
 l_string  varchar2(2000); 
 l_date    date; 
 l_bool    boolean;
 l_err     varchar2(2000) := NULL;
  
 BEGIN
   i_result := get_param_value_from_json(p_json_str,p_value_name,l_number,l_string,l_date,l_bool,l_err);
   if i_result < 0 then
         raise_application_error( -20111, l_err );
   elsif i_result = 3  then  -- возвращаемое значение --  3 -  date ; 4 - boolean;
         return(l_date);
   elsif i_result = 0  then  
         return(NULL);
   else
        s_result := p_value_name||'не правильный тип ('||i_result||')';
         raise_application_error( -20111, s_result );
   end if; 
end get_date_from_json;

function get_bool_from_json (p_json_str in varchar2, p_value_name in varchar2) return boolean
is 
 s_result varchar2(2000);
 i_result number := 0;
 
 l_number  number;
 l_string  varchar2(2000); 
 l_date    date; 
 l_bool    boolean;
 l_err     varchar2(2000) := NULL;
  
 BEGIN
   i_result := get_param_value_from_json(p_json_str,p_value_name,l_number,l_string,l_date,l_bool,l_err);
   if i_result < 0 then
         raise_application_error( -20111, l_err );
   elsif i_result = 4  then  -- возвращаемое значение --   4 - boolean;
         return(l_bool);
   elsif i_result = 0  then  
         return(NULL);
   else
        s_result := p_value_name||'не правильный тип ('||i_result||')';
         raise_application_error( -20111, s_result );
   end if; 
end get_bool_from_json;

function GetResultJsonStr( p_ResultType number, p_message varchar2:=null, p_errmessage varchar2:=null, p_id varchar2:=null) return varchar2 
  /*     {
  "ResultType": 0 -все хорошо 1-ошибка,
  "ResultMessage": "“екст —ообщени€",
   "ErrMessage": "“екст ошибки тех.",
  "ResultId":  ид 
  }  */   
is 
    l_result varchar2(2000):=null;
    obj json := json(); 
begin
  obj.put('ResultType',p_ResultType);
  obj.put('ResultMessage',p_message);
  obj.put('ErrMessage',p_errmessage);
  obj.put('ResultId',p_id);
  
  l_result :=  json_ac.object_to_char(obj,false);
  return (l_result);
                         
end GetResultJsonStr;




end PKG_K3_UTILS;
/
