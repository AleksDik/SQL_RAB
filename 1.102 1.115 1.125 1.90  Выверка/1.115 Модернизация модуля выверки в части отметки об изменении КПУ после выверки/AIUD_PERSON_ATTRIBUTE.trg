CREATE OR REPLACE TRIGGER "AIUD_PERSON_ATTRIBUTE"
  AFTER INSERT OR UPDATE OR DELETE
  ON kurs3.person_attribute
  FOR EACH ROW
   --  28.11.2013 Dik          Проставить дату обновления инф. КПУ в пакете сканирования (Задача 1.115)
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
/
