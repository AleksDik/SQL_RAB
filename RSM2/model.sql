select vp.* from KURS_V_PERSON_AFFAIR_3 vp where vp.AFFAIR_ID = 224098

SELECT
  *
FROM
  KURS3.CLASSIFIER_KURS3
WHERE
  AFFAIR_ID =4221
  
  
   :AFFAIR_ID AND
  AFFAIR_STAGE = :AFFAIR_STAGE


select * from all_tab_columns a
where a.TABLE_NAME = 'CLASSIFIER';

select v.* from  KURS3.V_AFFAIR_ANNOUN  v where AFFAIR_ID = 625304

select
'[Display(Name = " )]'||chr(13)||
'public '||
 case a.DATA_TYPE 
   when 'NUMBER' then 'Decimal' || decode (a.NULLABLE,'Y','?','')
   when 'CHAR' then 'String'
   when 'VARCHAR2' then 'String' 
   when 'DATE' then 'DateTime'|| decode (a.NULLABLE,'Y','?','')
   else a.DATA_TYPE
 end
 || ' ' ||a.COLUMN_NAME||' { get; set; }'||chr(13) as CLASS_STR,
 a.NULLABLE, 
 a.* from ALL_tab_columns a
where a.TABLE_NAME = 'V_AFFAIR_ANNOUN';
