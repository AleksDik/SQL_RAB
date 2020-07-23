-- Скрипт доработки АРМ Выверки

/* 1) Новые процедуры в pkg_scan:
-- Получить количество связанных документов КПУ в деле
 FUNCTION get_LnkDocOfAffair_delo_count (p_delo_id IN NUMBER) RETURN NUMBER;
-- Проверить привязки КПУ к пакетам сканирования
 FUNCTION get_affair_delo_link (p_affair_id IN NUMBER, p_delo_id IN NUMBER := 0, p_mess OUT varchar2 )  RETURN NUMBER;
-- Распарсить адрес дела для поиска КПУ
 PROCEDURE parse_delo_adr (p_delo_id IN NUMBER, p_cur IN OUT kurs3.curstype);
-- Поиск по адресу
 PROCEDURE search_affair_for_addr (....
-- Получить принак изменения КПУ после выверки пакета
 FUNCTION get_is_affair_change_after (p_delo_id IN NUMBER) RETURN NUMBER;
*/
-- 2) Установить новую привелегию - Ok
/*
insert into PRIV_TYPES (
select max (t.priv_id)+1, 'Привязка нескольких пакетов к одному КПУ', NULL,NULL,0
from PRIV_TYPES t
where t.priv_id<800);
*/
--select * from PRIV_TYPES t where t.priv_id<800; -- проверить
select max (t.priv_id) from PRIV_TYPES t where t.priv_id<800; -- проверить
-- ================== OK ======= 

-- полученное значение priv_id прописать в pkg_scan.get_affair_delo_link.c_Priv_MORE_DELO = 122
-- дописать pkg_scan.get_room_delo добавить в запрос поле room.npp_bti - «№ п/п БТИ» 
-- добавить колонку  «№ п/п БТИ»  в dbgRooms на форме.

-- добавить атрибут FULL_NAME=«Требуется перерегистрация». OK
/*
select * -- max(t.sort_order)+1 as sort_order
 from scan.EA_LABEL_TYPE t where t.object_type_id = 6 group by t.object_type_id; 

insert into scan.EA_LABEL_TYPE 
 select max(l.label_type_id)+1 as label_type_id, 
       6 as object_type_id,
       'Требуется перерегистрация' as full_name,
       1 as status,
       81 as sort_order
from  scan.EA_LABEL_TYPE l;
commit; 
*/

-- Add columns 
alter table scan.EA_DELO add affair_change date;
-- Add comments to the columns 
comment on column scan.EA_DELO.affair_change
  is 'Дата изменения инф. в КПУ, инф. о комнатах, людях , льготах  ';
  
  
"CHG_AFFAIR" 
-- ========================== Изменеия в  TRIGGERs =============================================
/*
TRIGGER "CHG_AFFAIR"  BEFORE UPDATE ON   KURS3.AFFAIR 
*/ROOM_DELO

CREATE OR REPLACE TRIGGER "AID_ROOM_DELO" AFTER INSERT OR DELETE  ON KURS3.ROOM_DELO FOR EACH ROW
DECLARE
 v_affair_id ROOM_DELO.AFFAIR_ID%type;
begin
  if INSERTING 
    then v_affair_id := :new.affair_id;
    else v_affair_id := :old.affair_id ;
  END IF;  
   update scan.ea_delo d
    set d.affair_change = sysdate
    where d.delo_id in (
       SELECT ed.delo_id
        FROM scan.ea_delo ed, scan.ea_delo_attr eda
       WHERE ed.object_type_id = 6
             AND ed.delo_id = eda.delo_id
             and ed.status = 2 --выверено
             AND eda.object_type_id = 1
             AND eda.row_status = 1
             AND NVL(eda.object_rel_id,-1) = v_affair_id);
end; 
--------------------------------------------------------------------
CREATE OR REPLACE TRIGGER "ROOM#R_BIU" BEFORE INSERT OR UPDATE  ON ROOM FOR EACH ROW
begin 
  if :New.last_change is null then :New.last_change:=sysdate; end if; 
  
  IF UPDATING AND
    ( (:new.room_num<>:old.room_num) or 
      (:new.room_space<>:old.room_space) or 
      (nvl(:new.characteristic,-1)<>nvl(:old.characteristic,-1))
    )
  THEN  
    update scan.ea_delo d
    set d.affair_change = sysdate
    where d.delo_id in (
       SELECT ed.delo_id
        FROM scan.ea_delo ed, scan.ea_delo_attr eda
       WHERE ed.object_type_id = 6 -- Очередники СН
             AND ed.delo_id = eda.delo_id
             and ed.status = 2 --выверено
             AND eda.object_type_id = 1 --КПУ Курс-3
             AND eda.row_status = 1
             AND NVL(eda.object_rel_id,-1) in (select rd.affair_id from room_delo rd 
                                               where ((rd.building_id = :new.BUILDING_ID) or (rd.building_id = :old.BUILDING_ID))
                                               and  ((rd.apart_id = :new.APART_ID) or  (rd.apart_id =:old.APART_ID))
                                               and  ((rd.room_num = :new.ROOM_NUM) or  (rd.room_num =:old.ROOM_NUM))
                                               )
             );
  END IF;
end;
--------------------------------------------------------------------------  
CREATE OR REPLACE TRIGGER "PERSON#R_BIU" BEFORE INSERT OR UPDATE  ON PERSON FOR EACH ROW
begin 
  if :New.last_change is null then :New.last_change:=sysdate; end if; 
  if UPDATING then
    update scan.ea_delo d
    set d.affair_change = sysdate
    where d.delo_id in 
   ( SELECT ed.delo_id
        FROM scan.ea_delo ed, scan.ea_delo_attr eda
       WHERE ed.object_type_id = 6 -- Очередники СН
             AND ed.delo_id = eda.delo_id
             and ed.status = 2 --выверено
             AND eda.object_type_id = 1 --КПУ Курс-3
             AND eda.row_status = 1
             AND NVL(eda.object_rel_id,-1) in (select p.affair_id from person_relation_delo p where p.person_id=:new.person_id) 
    group by ed.delo_id) ;        
 /* (SELECT ed.delo_id
           FROM scan.ea_delo ed,scan.ea_document edd, scan.ea_document_attr eda
           WHERE ed.delo_id = edd.delo_id AND
                 ed.status = 2 and --выверено
                 ed.object_type_id = 6  and -- Очередники СН
                 eda.document_id = edd.document_id AND 
                 eda.row_status = 1 AND
                 eda.document_version = 0 and 
                 eda.object_type_id = 7 -- Люди в Курс-3
                 and eda.object_rel_id = :new.person_id 
   group by ed.delo_id);*/
  end if;
end;
--------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER "PASPORT_DATA#R_BIU" BEFORE INSERT OR UPDATE ON PASPORT_DATA FOR EACH ROW
begin 
  if :New.last_change is null then :New.last_change:=sysdate; end if; 
  update scan.ea_delo d
    set d.affair_change = sysdate
    where d.delo_id in 
    ( SELECT ed.delo_id
        FROM scan.ea_delo ed, scan.ea_delo_attr eda
       WHERE ed.object_type_id = 6 -- Очередники СН
             AND ed.delo_id = eda.delo_id
             and ed.status = 2 --выверено
             AND eda.object_type_id = 1 --КПУ Курс-3
             AND eda.row_status = 1
             AND NVL(eda.object_rel_id,-1) in (select p.affair_id from person_relation_delo p where p.person_id=:new.person_id)
    group by ed.delo_id);
 /* (SELECT ed.delo_id
           FROM scan.ea_delo ed,scan.ea_document edd, scan.ea_document_attr eda
           WHERE ed.delo_id = edd.delo_id AND
                 ed.status = 2 and --выверено
                 ed.object_type_id = 6  and -- Очередники СН
                 eda.document_id = edd.document_id AND 
                 eda.row_status = 1 AND
                 eda.document_version = 0 and 
                 eda.object_type_id = 7 -- Люди в Курс-3
                 and eda.object_rel_id = :new.person_id 
   group by ed.delo_id);*/
end;
----------------------------------------------------------------------   
CREATE OR REPLACE TRIGGER "CHG_PRD#PERMIT" 
AFTER INSERT OR UPDATE OR DELETE
ON person_relation_delo
for each row
  DECLARE
   v_affair_id person_relation_delo.AFFAIR_ID%type;
begin
 	IF INSERTING 
		THEN
      v_affair_id :=  :New.affair_id ;
			DELETE FROM affair_permit 
			 WHERE affair_id = :New.affair_id 
			   AND affair_stage = :New.affair_stage
			   AND permit_type in (select row_num from classifier where classifier_num = 72 and row_status = 1);
		ELSIF UPDATING 
		THEN
       v_affair_id :=  :New.affair_id ;
			IF nvl(:new.person_id, 0) <> nvl(:old.person_id, 0) 
			THEN
				DELETE FROM affair_permit 
				 WHERE affair_id = :Old.affair_id 
				   AND affair_stage = :Old.affair_stage
				   AND permit_type in (select row_num from classifier where classifier_num = 72 and row_status = 1);
			END IF;
 	ELSE
       v_affair_id := :Old.affair_id ; 
			DELETE FROM affair_permit 
			 WHERE affair_id = :Old.affair_id 
			   AND affair_stage = :Old.affair_stage
			   AND permit_type in (select row_num from classifier where classifier_num = 72 and row_status = 1);
		END IF;
    
    update scan.ea_delo d
    set d.affair_change = sysdate
    where d.delo_id in (
       SELECT ed.delo_id
        FROM scan.ea_delo ed, scan.ea_delo_attr eda
       WHERE ed.object_type_id = 6
             AND ed.delo_id = eda.delo_id
             and ed.status = 2 --выверено
             AND eda.object_type_id = 1
             AND eda.row_status = 1
             AND NVL(eda.object_rel_id,-1) = v_affair_id);
END;
--------------------------------------------------------------
CREATE OR REPLACE TRIGGER "AIUD_PERSON_ATTRIBUTE" 
  AFTER INSERT OR UPDATE OR DELETE
  ON kurs3.person_attribute
  FOR EACH ROW
-- 27.12.2013 Dik (задача 1.115)    
   DECLARE 
    v_person_id        person_attribute.PERSON_ID%type;
    v_attribute_value  person_attribute.Attribute_value%type;
    v_attribute_id     person_attribute.Attribute_id%type; 
    v_status           person_attribute.status%type;
BEGIN
  IF (INSERTING or UPDATING) THEN
    v_person_id        :=   :new.PERSON_ID;
    v_attribute_value  :=   :new.attribute_value;
    v_attribute_id     :=   NVL(:new.attribute_id,-1); 
    v_status           :=   NVL(:new.status,0);
  else
    v_person_id        :=   :old.PERSON_ID;
    v_attribute_value  :=   :old.attribute_value;
    v_attribute_id     :=   NVL(:old.attribute_id,-1); 
    v_status           :=   NVL(:old.status,0);
  END IF;
  if (v_attribute_id = 15)
     or ((v_attribute_id in (12,13,14)) and (v_attribute_value is not NULL)) 
     or ((v_attribute_id in (16,17,18,19,20,22,21,22,23,24,25,26,27)) and (v_status in (1,2,3)) )
  then
    update scan.ea_delo d
    set d.affair_change = sysdate
    where d.delo_id in 
     ( SELECT ed.delo_id
        FROM scan.ea_delo ed, scan.ea_delo_attr eda
       WHERE ed.object_type_id = 6 -- Очередники СН
             AND ed.delo_id = eda.delo_id
             and ed.status = 2 --выверено
             AND eda.object_type_id = 1 --КПУ Курс-3
             AND eda.row_status = 1
             AND NVL(eda.object_rel_id,-1) in (select p.affair_id from person_relation_delo p where p.person_id=v_person_id)
    group by ed.delo_id);
   /* (SELECT ed.delo_id
           FROM scan.ea_delo ed,scan.ea_document edd, scan.ea_document_attr eda
           WHERE ed.delo_id = edd.delo_id AND
                 ed.status = 2 and --выверено
                 ed.object_type_id = 6  and -- Очередники СН
                 eda.document_id = edd.document_id AND 
                 eda.row_status = 1 AND
                 eda.document_version = 0 and 
                 eda.object_type_id = 12 -- Льготы в Курс-3
                 and ((eda.object_rel_id >= v_person_id) and (eda.object_rel_id < (v_person_id+1)))
   group by ed.delo_id); */
  end if;  
END;
--------------------------------------------------------------------   

-- create or replace view V_KURS3_SCAN_VIVERKA_DATE as .....

-- ==============Добавление полей в список пакетов выверки List_Cod = 51 (V_KURS3_SCAN_LIST )=====================================
/* 
Изменения ДЖП     AFFAIR_CHANGE  
Дата выверки      VIVERKA_DATE
Изменения после выверки  IS_AFFAIR_CHANGE_AFTER
*/
 --==Поле Изменения ДЖП  ==========
-- Проверить --
select L.*, rowid
FROM LIST_FIELDS L
where L.LIST_COD = 51 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 51);
-- Завести   
insert into LIST_FIELDS 
SELECT 
 51 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 51) as FIELD_ID, 
'Изменения ДЖП' as FIELD_TITLE, 
80 as  FIELD_W, 
3 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'AFFAIR_CHANGE' as  FIELD_NAME,
'EA_DELO' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 51 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 51);  

 --==Поле Дата выверки  ==========
-- Завести   
insert into LIST_FIELDS 
SELECT 
 51 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 51) as FIELD_ID, 
'Дата выверки' as FIELD_TITLE, 
80 as  FIELD_W, 
3 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'VIVERKA_DATE' as  FIELD_NAME,
'V_KURS3_SCAN_LIST' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 51 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 51);  

 --==Поле Изменения после выверки  ==========
-- Завести   
insert into LIST_FIELDS 
SELECT 
 51 as LIST_COD, 
(select Max(FIELD_ID)+1 from LIST_FIELDS where LIST_COD = 51) as FIELD_ID, 
'Изменения после выверки' as FIELD_TITLE, 
40 as  FIELD_W, 
1 as FIELD_TYPE, 
NULL as DICT_NAME, 
NULL as DICT_FIELD, 
'IS_AFFAIR_CHANGE_AFTER' as  FIELD_NAME,
'V_KURS3_SCAN_LIST' as TABLE_NAME, 
1 as STATUS, 
sysdate as LAST_CHANGE, 
0 as DEFAULT_FIELD,
NULL as SORT_STRING, 
NULL as ALIGN,
NULL as GROUP_NUM
from dual;
commit;
-- Проверить --
select *
FROM LIST_FIELDS L
where L.LIST_COD = 51 and L.FIELD_ID=(select Max(FIELD_ID) from LIST_FIELDS where LIST_COD = 51);  

 -- =============Условия отбора =================== 
/* 
Дата изменения ДЖП     AFFAIR_CHANGE  
Изменения после выверки  IS_AFFAIR_CHANGE_AFTER
*/
-- =========================Дата изменения ДЖП     AFFAIR_CHANGE  =============================
-- Проверить --
select *
from LIST_CONDITIONS
where --COND_ID=6020 and 
LIST_COD = 51
order by COND_ID desc
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   --(select max(COND_ID)+1 from LIST_CONDITIONS where LIST_COD = 51) 
   20  as COND_ID, 
   51 as LIST_COD, 
   'Дата изменения ДЖП' as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP)+10 from LIST_CONDITIONS where LIST_COD = 51 )  as COND_GROUP, --16
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
--delete
from LIST_CONDITIONS
where COND_ID=20 and 
LIST_COD = 51

insert into LIST_CONDITIONS 
SELECT 
   --(select max(COND_ID)+1 from LIST_CONDITIONS where LIST_COD = 51) 
   21  as COND_ID, 
   51 as LIST_COD, 
   'Дата изменения ДЖП' as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 51 )  as COND_GROUP, --16
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   --(select max(COND_ID)+1 from LIST_CONDITIONS where LIST_COD = 51) 
   22  as COND_ID, 
   51 as LIST_COD, 
   'Дата изменения ДЖП' as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 51 )  as COND_GROUP, --16
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   --(select max(COND_ID)+1 from LIST_CONDITIONS where LIST_COD = 51) 
   23  as COND_ID, 
   51 as LIST_COD, 
   'Дата изменения ДЖП' as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 51 )  as COND_GROUP, --16
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   --(select max(COND_ID)+1 from LIST_CONDITIONS where LIST_COD = 51) 
   24  as COND_ID, 
   51 as LIST_COD, 
   'Дата изменения ДЖП' as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 51 )  as COND_GROUP, --16
   1 as STATUS from dual;
   commit;
insert into LIST_CONDITIONS 
SELECT 
   --(select max(COND_ID)+1 from LIST_CONDITIONS where LIST_COD = 51) 
   25  as COND_ID, 
   51 as LIST_COD, 
   'Дата изменения ДЖП' as COND_NAME, 
   1 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
   (select max(COND_GROUP) from LIST_CONDITIONS where LIST_COD = 51 )  as COND_GROUP, --16
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
from LIST_CONDITIONS
where LIST_COD = 51
order by COND_ID desc   
--  ==========================

-- Проверить --
select *
--delete
from OPERATION_TYPES
where --COND_ID < 7 and 
LIST_COD = 51

INSERT INTO OPERATION_TYPES 
(
SELECT 
20 as COND_ID, --!!
51 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
3 as FIELD_TYPE , -- date
'trunc(SCAN_EA_DELO'  as TABLE_NAME,
'AFFAIR_CHANGE)'  as FIELD_NAME, 
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
INSERT INTO OPERATION_TYPES 
(
SELECT 
21 as COND_ID, --!!
51 as LIST_COD,
1 as OPERATION_COD, 
'>' as OPERATION_NAME,   
3 as FIELD_TYPE , -- date
'trunc(SCAN_EA_DELO'  as TABLE_NAME,
'AFFAIR_CHANGE)'  as FIELD_NAME,  
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
INSERT INTO OPERATION_TYPES 
(
SELECT 
22 as COND_ID, --!!
51 as LIST_COD,
1 as OPERATION_COD, 
'>=' as OPERATION_NAME,   
3 as FIELD_TYPE , -- date
'trunc(SCAN_EA_DELO'  as TABLE_NAME,
'AFFAIR_CHANGE)'  as FIELD_NAME, 
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
INSERT INTO OPERATION_TYPES 
(
SELECT 
23 as COND_ID, --!!
51 as LIST_COD,
1 as OPERATION_COD, 
'<' as OPERATION_NAME,   
3 as FIELD_TYPE , -- date
'trunc(SCAN_EA_DELO'  as TABLE_NAME,
'AFFAIR_CHANGE)'  as FIELD_NAME, 
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
INSERT INTO OPERATION_TYPES 
(
SELECT 
24 as COND_ID, --!!
51 as LIST_COD,
1 as OPERATION_COD, 
'<=' as OPERATION_NAME,   
3 as FIELD_TYPE , -- date
'trunc(SCAN_EA_DELO'  as TABLE_NAME,
'AFFAIR_CHANGE)'  as FIELD_NAME, 
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;
INSERT INTO OPERATION_TYPES 
(
SELECT 
25 as COND_ID, --!!
51 as LIST_COD,
1 as OPERATION_COD, 
'<>' as OPERATION_NAME,   
3 as FIELD_TYPE , -- date
'trunc(SCAN_EA_DELO'  as TABLE_NAME,
'AFFAIR_CHANGE)'  as FIELD_NAME, 
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
NULL as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;

-- Проверить --
select *
--delete
from OPERATION_TYPES
where COND_ID > 0 and 
LIST_COD = 51

-- ========================Изменения после выверки  IS_AFFAIR_CHANGE_AFTER========================
-- Завести
insert into LIST_CONDITIONS 
SELECT 
   (select max(COND_ID)+1 from LIST_CONDITIONS where LIST_COD = 51)  as COND_ID,
 --  20  as COND_ID, 
   51 as LIST_COD, 
   'Изменения после выверки' as COND_NAME, 
   3 as COND_TYPE, 
   sysdate as  LAST_CHANGE,
--(select max(COND_GROUP)+10 from LIST_CONDITIONS where LIST_COD = 51 )  
   7 as COND_GROUP, --16
   1 as STATUS from dual;
   commit;
-- Проверить --
select *
--delete
from LIST_CONDITIONS
where 
LIST_COD = 51

INSERT INTO OPERATION_TYPES 
(
SELECT 
26 as COND_ID, --!!
51 as LIST_COD,
1 as OPERATION_COD, 
'=' as OPERATION_NAME,   
1 as FIELD_TYPE , 
'pkg_scan.get_is_affair_change_after(SCAN_EA_DELO'  as TABLE_NAME,
'delo_id)'  as FIELD_NAME, 
NULL as DICT_WHERE,
NULL as DICT_NAME,
NULL as DICT_FIELD_NAME,
'1' as FIELD_VALUE, 
sysdate as LAST_CHANGE, 
NULL as UNIQUE_COND_TBL 
from dual
);
commit;

-- Проверить --
select l.cond_name, o.* 
from LIST_CONDITIONS l , OPERATION_TYPES o
where l.cond_id=o.cond_id
and l.list_cod=o.list_cod
and l.cond_type=3
and l.LIST_COD = 51
order by l.COND_ID desc


/* «Изменено ДЖП» Данный признак отображается у пакета на экранной форме «Пакет» после указания статуса «Выверено»
добавить поле is_affair_change_after в V_VERIFY_DELO
*/

-- 7	Изменения в процедуру автоматической привязки КПУ к пакету сканирования (PROCEDURE link_kurs_with_scan)


--  ============  	Изменения в отчеты !!  =====================================

/* Изменить:
меню и формы ввода параметров: 
  PROCEDURE kursiv.on_form_command_kurs3
  PROCEDURE kursiv.do_for_kurs_datmod
  PROCEDURE kursiv.do_for_verify_rep
Запросы для отчетов    
  PROCEDURE KURS3.verify_rep_vyv_users
  PROCEDURE KURS3.verify_rep_vyv_result  
*/
  
-- ==============ОК ==================
Insert INTO LIST_RTF 
SELECT (select max(rtf_id)+1 from LIST_RTF) as  rtf_id,
       lr.rtf_name || ' с учетом изменений ДЖП' as rtf_name,
       'rdn_vyv_result_vc.xls' as file_name,
       1 as file_version, 
       NULL as rtf_template,
       sysdate as last_change 
FROM LIST_RTF lr WHERE lr.RTF_ID = 320;

--max(rtf_id)+1 = 364
-- проверить 
SELECT lr.* FROM LIST_RTF lr WHERE lr.RTF_ID = 364
-- ================================

-- в процедуре kursiv.do_for_verify_rep    
--    when (UPPER (form_name) = 'FRMVYVREPRESULTVC') then   v_TypeReport := '364;'
-- записать rdn_vyv_result_vc.xls в rtf_template

/* первоначальное заполнение изменений после выверки scan.ea_delo.affair_change
 
update  scan.ea_delo d 
set d.affair_change =
      (select max(af.last_change) from  affair af , scan.ea_delo_attr t where
             t.object_type_id = 1
             AND t.row_status = 1
             and  af.affair_stage=1
             AND NVL(t.object_rel_id,-1) = af.affair_id
             and t.delo_id = d.delo_id 
             group by af.affair_id
             ) 
where d.delo_id in (
       SELECT distinct ed.delo_id 
        FROM scan.ea_delo ed, scan.ea_delo_attr eda, affair a,V_KURS3_SCAN_VIVERKA_DATE v
       WHERE ed.object_type_id = 6
             AND ed.delo_id = eda.delo_id
             and ed.status = 2 --выверено
             AND eda.object_type_id = 1
             AND eda.row_status = 1
             AND NVL(eda.object_rel_id,-1) = a.affair_id
            and a.affair_stage=1
            and v.delo_id=eda.delo_id
            and v.viverka_date< a.last_change 
             );
commit;
          
   */             








