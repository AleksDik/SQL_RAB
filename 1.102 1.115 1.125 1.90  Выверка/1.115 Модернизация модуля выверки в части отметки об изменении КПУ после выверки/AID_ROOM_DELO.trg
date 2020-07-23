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
/
