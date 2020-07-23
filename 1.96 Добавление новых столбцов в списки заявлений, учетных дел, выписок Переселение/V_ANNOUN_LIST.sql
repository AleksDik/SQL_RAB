CREATE OR REPLACE VIEW V_ANNOUN_LIST
(okrug_id, affair_id, name, affair_num, reg_person_cnt, occupy_num, sqi, sqo, plan_year, last_change, user_id, list_cod, list_num, address, last_name, note, category, reason, factory, status_bti, read_only, street_name, building_num, building_idx, house_num, house_idx, construction_num, construction_idx, apartment_num, creation_date, decl_date,RELOC_GROUP_NAME,RELOC_YESNO)
AS
SELECT        
--       
--		  18.08.1999  	  Исправлена категория дела       
--		  19.08.1999  	  Исправлена категория дела   
--		  03.05.2000	  Добавлено предприятие   
--		  03.05.2000	  Добавлено НАПРАВЛЕНИЕ УЧЕТА   
--		  03.05.2000	  Добавлено СООТВЕТСТВИЕ БТИ   
--		  11.07.2000	  Добавлено ДАТА СОЗДАНИЯ
--		  2004.08.10	  Добавлена дата заявления	   (ddiner)   
-- #D22.08.2013 / (Дикан) зад. 1.96: Добавлены поля инф. о Переселении (RELOC_GROUP_NAME,RELOC_YESNO); В последней постановке 1.96 поле RELOC_PROGRAM_YEAR вычеркнуто!       
--       
        Affair.Okrug_ID,        
        Affair.Affair_ID,        
        AREA.SHORT_NAME3,        
        to_char(Affair.stand_year,'0000')||'-'||to_char(Delo_Num,'00000'),        
        Affair.REG_PERSON_CNT,        
        Affair.OCCUPY_NUM,        
        Affair.Sqi,        
        Affair.SqO,        
        Affair.PLAN_YEAR,        
        Affair.LAST_CHANGE,        
        Affairs_list.User_id,        
        Affairs_list.List_Cod,        
        Affairs_list.List_num,        
        substr(Addr_Apartment(Affair.build_Id,Affair.Apart_id),1,200),        
        substr(Get_Person1b(Affair.Affair_id),1,200),        
        Affairs_list.Note,        
        substr(Get_KATEG_all(Affair.DELO_CATEGORY,affair.REASON),1,200),        
		SUBSTR(GET_REASON_SH3(AFFAIR.REASON),1,60),              
SUBSTR(GET_FACTORY_NAME_SH(AFFAIR.DEPARTMENT_ID,AFFAIR.FACTORY_ID),1,40),      
SUBSTR(Get_Status_BTI_SH_1(APARTMENT.STATUS_BTI),1,70),     
		Get_Read_Only(2,Affair.affair_id),             
				street.FULL_NAME,building.BUILDING_NUM,building.BUILDING_IDX,building.HOUSE_NUM,building.HOUSE_IDX,      
				building.CONSTRUCTION_NUM,building.CONSTRUCTION_IDX,APARTMENT_NUM,  
				AFFAIR.CREATION_DATE
		,DECL_DATE  ,
-- #D22.08.2013
         case when NVL(RELOC.reloc_apart_id,0) = 0 then NULL else  GET_relocation_program(RELOC.reloc_apart_id) end as RELOC_GROUP_NAME,
         case when NVL(RELOC.reloc_apart_id,0) = 0 then 'НЕТ' else 'ДА' end as RELOC_YESNO
-- / #D22.08.2013      
FROM        
   Affair,        
   AREA,        
   Affairs_list,     
	 building,     
	 street,     
	 apartment,
-- #D22.08.2013
  (SELECT reloc_apart_id , reloc_building_id
   FROM v_relocation_from_emig
   group by reloc_apart_id , reloc_building_id
   ) RELOC
 -- / #D22.08.2013        
WHERE        
    Affair.Okrug_Id=Area.Okrug_Id and        
    Affairs_List.Affair_Id=Affair.Affair_Id and        
    affair.AFFAIR_STAGE=0 and     
		building.STREET=street.STREET_ID and      
		affair.BUILD_ID=building.BUILDING_ID and     
		affair.APART_ID=apartment.APART_ID 
-- #D22.08.2013
    AND affair.apart_id = RELOC.reloc_apart_id(+);     
--GRANT SELECT ON V_ANNOUN_LIST TO OKRUG;;
