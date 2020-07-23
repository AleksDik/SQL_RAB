create or replace function get_uhud_usl_strinfo(p_affair_id in AFFAIR_EXT_DATA.AFFAIR_ID%Type,p_mode in number := 0, p_format in number := 0) return VARCHAR2 is
/* Вернуть строку Ухудшение жил. условий за последние 5 лет по заданному ID КПУ для подстановки в get_affair_text
p_mode - пока резерв: 
p_format - тип форматирования - пока резерв 
0 - rtf, 1 - txt, 2 - html               
19.06.2013 Дикан А.
*/ 
  tempStr VARCHAR2(1000) := ' ';
  c_months_between constant number := 60; -- за последние 5 лет
  Res VARCHAR2(1000):=' Ухудшение жил. условий за последние 5 лет ';
  i binary_integer := 0;
  v_CR  varchar2(10) :='\par ';-- UTL_TCP.crlf;
  v_Bold  varchar2(3) := '{\b';
-- c_uhud_data_type_id constant  number := 6; --Факт ухудшения жилищных условий
--  с_classifier_uhud_num constant number := 140;-- Код справочника -Причины ухудшения жилищных условий (переселение)
  v_BoldEnd  varchar2(4) := '}';
--  c_Priv constant integer := 114; -- код привелегии "Отображение результатов выверки"
--  v_user_id  who_work.user_id%Type; -- код текущего пользователя
  v_data_cl_str CLASSIFIER_KURS3.NAME%Type :=NULL;
  v_data_s AFFAIR_EXT_DATA.DATA_S%Type     :=NULL;
  v_data_d AFFAIR_EXT_DATA.DATA_D%Type     :=NULL;
  c_pref_cl constant varchar2(25) :='{\b Причина ухудшения:}  ';
  c_pref_d constant varchar2(25)  :='{\b Дата ухудшения:}  ';
  c_pref_s constant varchar2(20)  :='{\b Примечание:}  ';  
begin
 -- Проверить права - резерв--- 
/*    select ww.user_id into v_user_id from who_work ww
    where ww.uni_session_id =userenv('SESSIONID')
    and ww.login_date = (select max(ww1.login_date) from who_work ww1 where ww1.uni_session_id = userenv('SESSIONID'));

    IF get_user_priv_1 (v_user_id, c_Priv) = 0 THEN
     Res := '';
     return(Res);
    END IF;
*/    
-- ------------------
-- Проверить наличие доп инф. -Ухудшение жил. условий за последние 5 лет --- 
  SELECT count(*) into i
  FROM AFFAIR_EXT_DATA ae
  where ae.data_type_id = pkg_affair.c_uhud_data_type_id
  and ae.affair_id=p_affair_id
  and ae.data_version=0;
 -- and months_between(trunc(Sysdate,'dd'),trunc(ae.data_d,'dd')) < c_months_between;

IF i = 0 THEN
 Res := '';
 return(Res);
END IF; 
-----------------------------
  case p_format 
    when 1 then  begin v_CR := UTL_TCP.crlf; v_Bold := ''; v_BoldEnd:='';end;
    when 2 then  begin v_CR := '<BR/>'; v_Bold := '<b>'; v_BoldEnd:='</b>';end;
    else NULL;
  end case;  
-- получить данные----
SELECT cl.name ,ae.data_s,ae.data_d
into v_data_cl_str,v_data_s,v_data_d
FROM AFFAIR_EXT_DATA ae
    left join CLASSIFIER_KURS3 cl on cl.row_num = ae.data_n and cl.classifier_num = pkg_affair.с_classifier_uhud_num
where ae.data_type_id=pkg_affair.c_uhud_data_type_id
  and ae.affair_id=p_affair_id
  and ae.data_version=0
--  and months_between(trunc(Sysdate,'dd'),trunc(ae.data_d,'dd')) <= c_months_between
  and  ROWNUM=1;
----------------------
-- формирование результата ------ NVL2( string1, value_if_NOT_null, value_if_null )
select NVL2( v_data_cl_str, v_CR||c_pref_cl||v_data_cl_str, ' ' ) into tempStr from dual ;
select NVL2( v_data_d, tempStr||v_CR||c_pref_d||to_char(v_data_d, 'dd.mm.yyyy'), tempStr ) into tempStr from dual ;
select NVL2( v_data_s, tempStr||v_CR||c_pref_s||v_data_s, tempStr )into tempStr from dual ;
select NVL2( Trim(tempStr),v_CR||v_Bold||Res||v_BoldEnd||tempStr, '' )into Res from dual ;

return(Res);

end get_uhud_usl_strinfo;
/
