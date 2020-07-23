CREATE OR REPLACE TRIGGER "CHG_AFFAIR" 
  BEFORE UPDATE
  ON KURS3.AFFAIR   FOR EACH ROW
--
--  23.07.1999              Внесены изменения по закреплению за инспектором очередников
--  11.10.1999              Вставлена проверка на неизменность
--  02.12.1999              Добавлена старая категория
--  21.01.2000              Не изменять дела, снятые с учета
--  28.03.2000              Ограничения на изменение типа БП
--  12.05.2000              Ограничения на изменение типа БП
--  25.03.2003  Frolov      Добавил возможность создания БП для переселения
--  12.05.2003              Добавлена возможность создания БП для реконструкции (4 направление) на раз (временно) убрать
--  01.08.2008  Anissimova  проверка соответствия вида обеспечения 21 направлению учета
--  06.07.2010  Lvova       добавила вида обеспечения СН для 21 н/у, т.е. убрала СН (type2=1) из проверки соответствия вида обеспечения 21 н/у
--  24.10.2011  BlackHawk   Временно добавил веозможность выбора 8-ого типа для 21 направления
--16.10.2013 ilonis убрал проверку БП
--  18.11.2013 Dik          Проставить дату обновления инф. КПУ в пакете сканирования
DECLARE
  nn   NUMBER;
  ch_d BOOLEAN;
  ch_f BOOLEAN;
  ch_i BOOLEAN;
  tp   NUMBER;
BEGIN
  IF USERENV ('terminal') IN ('C-TARAKANOV','C-BOGACHENKOV') THEN
    RETURN;
  END IF;

  IF trigger_flags.affair_youngfam_recalc THEN
    RETURN;
  END IF;

  IF     :new.okrug_id = :old.okrug_id
     AND :new.affair_id = :old.affair_id
     AND NVL (:new.old_affair_id, 0) = NVL (:old.old_affair_id, 0)
     AND :new.affair_stage = :old.affair_stage
     AND :new.delo_category = :old.delo_category
     AND :new.reason = :old.reason
     AND :new.factory_id = :old.factory_id
     AND :new.stand_year = :old.stand_year
     AND :new.calc_year = :old.calc_year
     AND :new.delo_num = :old.delo_num
     AND NVL (:new.decision_num, ' ') = NVL (:old.decision_num, ' ')
     AND NVL (:new.delo_date, SYSDATE) = NVL (:old.delo_date, SYSDATE)
     AND :new.reg_person_cnt = :old.reg_person_cnt
     AND :new.person_in_family = :old.person_in_family
     AND :new.s_group = :old.s_group
     AND :new.year_in_city = :old.year_in_city
     AND :new.year_in_place = :old.year_in_place
     AND :new.build_id = :old.build_id
     AND :new.occupy_num = :old.occupy_num
     AND :new.more_family = :old.more_family
     AND :new.sqi = :old.sqi
     AND :new.sq_type = :old.sq_type
     AND :new.sqo = :old.sqo
     AND NVL (:new.plan_year, 0) = NVL (:old.plan_year, 0)
     AND :new.kk_num = :old.kk_num
     AND --:new.LAST_CHANGE=:old.LAST_CHANGE and
        NVL (:new.inspector, ' ') = NVL (:old.inspector, ' ')
     AND NVL (:new.ordered, 0) = NVL (:old.ordered, 0)
     AND :new.apart_id = :old.apart_id
     AND :new.sstatus = :old.sstatus
     AND :new.department_id = :old.department_id
     AND NVL (:new.comfortable, 0) = NVL (:old.comfortable, 0)
     AND :new.kitchen_sq = :old.kitchen_sq
     AND NVL (:new.toilet, 0) = NVL (:old.toilet, 0)
     AND NVL (:new.good, 0) = NVL (:old.good, 0)
     AND :new.status = :old.status
     AND NVL (:new.reason2, 0) = NVL (:old.reason2, 0)
     AND --:new.DATATIME=:old.DATATIME and
        NVL (:new.type2, 0) = NVL (:old.type2, 0)
     AND NVL (:new.notes, ' ') = NVL (:old.notes, ' ')
     AND NVL (:new.condition, 0) = NVL (:old.condition, 0)
     AND NVL (:new.society_group, 0) = NVL (:old.society_group, 0)
     AND NVL (:new.p1, 0) = NVL (:old.p1, 0)
     AND NVL (:new.p2, 0) = NVL (:old.p2, 0)
     AND --:new.P3=:old.P3 and
        NVL (:new.registration_date, SYSDATE) = NVL (:old.registration_date, SYSDATE) THEN
    NULL;
  ELSE
    IF :new.department_id IS NOT NULL AND :new.department_id <> :old.department_id THEN -- изменение ведомства
      ch_d   := TRUE;
    ELSE
      ch_d   := FALSE;
    END IF;

    IF :new.factory_id IS NOT NULL AND :new.factory_id <> :old.factory_id THEN -- изменение предприятия
      ch_f   := TRUE;
    ELSE
      ch_f   := FALSE;
    END IF;

    IF (ch_d OR ch_f) THEN
      IF is_municipality (:old.department_id, :old.factory_id) = 0 THEN -- ведомственные очередники
        IF is_municipality (:new.department_id, :new.factory_id) = 1 THEN
          raise_application_error (
            -20024
           ,'Ведомственные дела не могут переводится в префектуру или муниципалитет'
          );
        END IF;
      ELSE -- очередники муниципалитета
        IF is_municipality (:new.department_id, :new.factory_id) = 0 THEN
          raise_application_error (
            -20023
           ,'Эти дела могут переводится только в префектуру или муниципалитет'
          );
        END IF;
      END IF;
    END IF;

    IF :new.inspector IS NOT NULL AND :new.inspector <> NVL (:old.inspector, 'NULL') THEN -- изменение инспектора
      ch_i   := TRUE;
    ELSE
      ch_i   := FALSE;
    END IF;

    IF (ch_i) AND is_municipality (:old.department_id, :old.factory_id) = 0 THEN
      raise_application_error (-20018, 'Вы можете закреплять только муниципальных очередников');
    END IF;

    IF (ch_i) AND :old.status > 1 THEN
      raise_application_error (-20074
                              ,'Вы можете закреплять только очередников, состоящих на учете'
                              );
    END IF;

    --if :New.last_change is null and :Old.last_change is null then
    --  :New.last_change:=sysdate;
    --end if;
    IF :old.old_affair_id IS NULL THEN
      :new.old_affair_id   := :old.affair_id;
    END IF;

    /*
    IF :New.inspector is not null and is_municipality(:Old.department_id,:Old.factory_id)=0
    and :New.inspector<>:Old.inspector then
    raise_application_error(-20018,'Вы можете закреплять только муниципальных очередников');
    end if;
    */
    :new.p1   := set_p1 (:new.apart_id);

    IF :old.affair_stage = 0 AND :new.affair_stage > 0 THEN
      :new.p2   := set_p2 (:new.affair_id, :old.affair_stage);
    ELSE
      :new.p2   := set_p2 (:new.affair_id, :new.affair_stage);
    END IF;

    IF :new.status <> :old.status OR :new.status <= 1 THEN -- Не изменять дела, снятые с учета
      :new.last_change   := SYSDATE;
    END IF;

    IF :old.delo_category <> :new.delo_category AND :new.affair_stage = 1 AND :old.affair_stage = 1 THEN
      BEGIN
        SELECT direction_target.row_status
          INTO tp
          FROM direction_target
         WHERE direction_target.direction = :old.reason AND direction_target.target = :old.delo_category;

        IF tp = 4 THEN
          :new.delo_category_old   := :old.delo_category;
        END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          NULL;
      END;
    END IF;
              
--      --16.10.2013 ilonis  
    --IF (:new.type2 = 4) THEN -- Тип БП
    IF (:new.type2 = 4)  and (:old.reason<> 21)THEN -- Тип БП
       IF NOT (:new.reason = 97 OR :new.reason IN (4, 7, 8)) THEN --Разрешено для Переселения --Warning or New.Reason = 4 убрать      
        IF NOT (:new.department_id = 757 AND :new.factory_id BETWEEN 781 AND 790) THEN
          raise_application_error (-20171
                                  ,'В этом предприятии не может быть Безвозмезного Пользования'
                                  );
        END IF;
      END IF;
    END IF;

    ------------- 01.08.2008 Anissimova - проверка соответствия вида обеспечения 21 направлению учета
    ------------- 06.07.2010  Lvova - убрала СН (type2=1) из проверки соответствия вида обеспечения 21 н/у                
    --16.10.2013 ilonis
    --IF (:old.reason = 21 AND :new.type2 IN (3, 4, 5, 11, 12, 15)) OR (:new.type2 = 16 AND :old.reason <> 21) THEN  
    IF (:old.reason = 21 AND :new.type2 IN (3,  5, 11, 12, 15)) OR (:new.type2 = 16 AND :old.reason <> 21) THEN
      raise_application_error (-20310, 'Несоответствие вида обеспечения направлению учета');
    END IF;

    -------------------------------------------------------------------------------------------------
    IF :old.affair_stage = 0 AND :new.affair_stage = 1 THEN
      :new.creation_date   := SYSDATE;
    END IF;
  END IF;

  :new.young_family   := test_affair_young_fam_n (:new.affair_id, :new.affair_stage, NVL (:new.reason2_date, SYSDATE));

  -- журнализация изменения в деле (maltseva)
  IF ( (:new.delo_category <> :old.delo_category) OR (:new.s_group <> :old.s_group) OR (:new.type2 <> :old.type2)) AND (:new.affair_stage = 1) THEN
    kurs3.LOG (kurs3_var.access_log_type
              ,405
              ,get_user_unique_id (kurs3_var.global_user_id)
              ,kurs3_var.global_okrug_id
              ,'UPDATE_AFFAIR = ' || TO_CHAR (:old.affair_id)
              );
  END IF;
 --  18.11.2013 Dik  
/*	 «Дата заявления» - affair.decl_date;
•	«Номер решения» - affair.decision_num;
•	«Дата решения» - affair.delo_date.
*/
  if (NVL(:new.decl_date, cast('01.01.1800' as date))<>NVL(:old.decl_date, cast('01.01.1800' as date))) or 
     (NVL(:new.decision_num,' ')<>NVL(:old.decision_num,' ')) or
     (NVL(:new.delo_date, cast('01.01.1800' as date))<> NVL(:old.delo_date, cast('01.01.1800' as date)))
  then
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
             AND NVL(eda.object_rel_id,-1) = :new.AFFAIR_ID); 
  end if;   

-- / 18.11.2013 Dik   
  
  
END;
/
