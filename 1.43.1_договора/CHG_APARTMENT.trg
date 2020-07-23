CREATE OR REPLACE TRIGGER KURS3."CHG_APARTMENT" 
BEFORE  INSERT OR UPDATE ON apartment FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.CREATION_DATE:=SYSDATE;
    END IF;
   :NEW.STATUS_BTI:=test_Apart_From_BTI_2b(:NEW.APART_ID,:NEW.APARTMENT_NUM,:NEW.APARTMENT_IDX,:NEW.BUILDING_ID,
	   	  		  					                                    :NEW.LIVING_SPACE,:NEW.TOTAL_SPACE,:NEW.KITCHEN_SPACE,:NEW.ROOM_COUNT,
										                                :NEW.ROOM_STOREY_NUM);
    IF :NEW.VERSION<0 AND NVL(:OLD.VERSION,-100)=0 THEN
        :NEW.VERSION:=0;	  						   -- Запретить изменение версии
    END IF;
   --ilonis 27.02.2013  для техпаспортов
   pkg_techpasport.update_tp_relation_apart( :NEW.APART_ID, :NEW.BUILDING_ID  ,:NEW.APARTMENT_NUM ,:NEW.APARTMENT_IDX,0  );

END;
/