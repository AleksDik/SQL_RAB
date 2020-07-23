
declare
  obj json;
  p_in varchar2(1000) :=
 '{"l":[{"pname":"p1","pval":2.34},{"pname":"p_id","pval":345},{"pname":"pstr","pval":"тестовая строка, тест"},{"pname":"pq","pval":2.34},{"ar":[17,23,56,78]} ]}';
  /* 
'{
  "func" : {"ftype" : "procedure",
             "fpkg" : "",
             "fname": "set_xxxx",
             "params": [{"pname":"p2","pval":234.1},{"pname":"p_id","pval":345},{"pname":"pstr","pval":"тестовая строка1, 20.07.2009 тест"},{"pname":"pq","pval":2.34}]
             } ,
  "func1" : {"ftype" : "function",
             "fpkg" : "",
             "fname": "get_x",
             "params": [{"pname":"p1","pval":234},{"pname":"p_id","pval":345},{"pname":"pstr","pval":"тестовая строка, тест"},{"pname":"pq1","pval":"'||TO_CHAR(sysdate,'DD.MM.YYYY')||'"}]
             } 
}'; */
c integer;
i integer;
j integer;
 jv    json_value := json_value.makenull;
 JL json_list;
 JO json;
 vn number := null;
 ve varchar2(2000) := NULL;
 vs varchar2(2000) := NULL;
 p_key varchar2(50) :='l' ;
 v_b boolean := NULL;
 vd date ;
begin
--dbms_output.put_line(to_char(sysdate));

 vs := PKG_K3_UTILS.get_param_value_from_json(p_json_str => p_in,p_value_name => p_key, a_err => ve);
 jv := PKG_K3_UTILS.get_json_value_from_list_i( vs, 'pval',  5);


--dbms_output.put_line('i:  '||i);
dbms_output.put_line('a_err:  '||ve);
--dbms_output.put_line('a_number:  '||vn);
dbms_output.put_line('a_string:  '||vs);

jv.print;
--dbms_output.put_line('a_date:  '||TO_CHAR(vd,'DD.MM.YYYY'));
--if v_b then dbms_output.put_line('a_bool:  true'); elsif (v_b is not null) then dbms_output.put_line('a_bool:  false'); end if;
return;


--------------------------------------------------
--jv := json_value(p_in); 
--dbms_output.put_line(to_char(sysdate));
begin
   JL :=  json_list(p_in)  ;
 --jv.print; 
   jv:= json_ac.array_to_json_value(JL);
 --vs := json_ac.jv_get_type(jv);
  -- dbms_output.put_line('type:     '||vs);
   exception 
  when OTHERS then jv  := json_value.makenull;
 end;
if jv.is_null then 
   begin
      JO := json(p_in);
      jv := json_ac.object_to_json_value(JO);
    exception 
    when OTHERS then jv  := json_value.makenull;   
   end;
end if;
 
if jv.is_null then 
   dbms_output.put_line('Неверный формат json ');
   return;
elsif json_value.is_array(jv) then
   jv := PKG_K3_UTILS.get_json_value_from_list(p_in,p_key); 
elsif  json_value.is_object(jv) then
   jv := PKG_K3_UTILS.get_json_value_from_obj(p_in ,p_key);
end if; 

  
if jv.is_null then 
   dbms_output.put_line('jv = NULL'); 
elsif json_ext.is_date(jv) then  
    vd := json_ext.to_date2 (jv);
       dbms_output.put_line('OUT d :     '||vd);       
elsif  json_ac.jv_is_string(jv) then
   vs :=  json_ac.jv_get_string(jv); 
   dbms_output.put_line('OUT:     '||vs);
elsif  json_ac.jv_is_number(jv) then  
    vn :=  json_ac.jv_get_number(jv);
       dbms_output.put_line('OUT n :     '||vn); 
elsif  json_ac.jv_is_bool(jv) then  
    v_b :=  json_ac.jv_get_bool(jv);
    --  dbms_output.put_line(''||v_b);
 
end if;

 return;
 
 -------------------------------
  obj := json();
  obj := json(p_in);
  c:=obj.count;
  dbms_output.put_line('c='||c);
For i in 1..c 
loop  
 jv := obj.get(i);

 if  json_ac.jv_is_object(jv) then
     JO:=json(jv);
     p_in := json_ac.object_to_char(JO,false);
    -- jv := get_json_value_from_obj(p_in,p_value_name);
    -- JO.print;
     --  j:=jo.count;
     --  dbms_output.put_line('j='||j);
       dbms_output.put_line(p_in);
  elsif json_ac.jv_is_array(jv) then
        JL :=  json_list(jv);
       
         -- jv := get_json_value_from_list(p_in,p_value_name); 
        dbms_output.put_line(p_in);
  elsif json_ac.jv_is_array(jv) then   
    p_in := json_ac.jv_get_type(jv); 
     dbms_output.put_line(p_in);   
 end if;
 
 
end loop; 
 return;
obj :=json(jv);
--obj.print;

jv := obj.get('params');
JL :=  json_list(jv);
--dbms_output.put_line(JL.count);
jv := jl.get(4);
 obj := json(jv);

jv := obj.get('pval');
if json_ac.jv_is_number(jv) then
  vn := json_ac.jv_get_number(jv);
  dbms_output.put_line('vn='||vn);
elsif
   json_ac.jv_is_string(jv) then  
p_in :=json_ac.jv_get_string(jv);
--json_ac.jv_get_type(jv);
--p_in := json_ext.get_string(obj);
-- := json(jv);
--dbms_output.put_line(jv.get_string);
--p_in := json_ext.get_string(obj,'pval');
dbms_output.put_line(p_in);
end if;

exception 
  when OTHERS then--SQLERRM||' ; '||
    dbms_output.put_line( DBMS_UTILITY.FORMAT_ERROR_STACK || ' BACKTRACE: '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
end;


/*
SELECT  A.PACKAGE_NAME, A.OBJECT_NAME, A.ARGUMENT_NAME, A.DATA_TYPE,a.in_out, a.SEQUENCE
FROM USER_ARGUMENTS A
    ,ALL_OBJECTS    O
WHERE A.OBJECT_ID = O.OBJECT_ID
      AND O.OBJECT_NAME = 'PKG_K3_UTILS'      -- pkg
      AND A.OBJECT_NAME = 'GET_COUNT_KPU' -- procedure
      order by a.SEQUENCE;

*/



