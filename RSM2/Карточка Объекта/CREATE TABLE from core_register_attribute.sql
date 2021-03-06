-- CREATE TABLE from core_register_attribute --
declare
 v_count NUMBER := 0;
 c_table_name varchar2(50) := '';
 c_table_name_o varchar2(50) := '';
 c_core_register_id number := 0;
 v_column     varchar2(35) := '';
  v_TEST number := 1; -- 1 - test ;  0 -run 
 c_create_table varchar2(500) :=  
'   create table #TB
(
  ID     NUMBER(10) not null,
  EMP_ID NUMBER(10) not null,
  ACTUAL NUMBER(10) not null,
  STATUS NUMBER(10) not null,
  S_     DATE not null,
  PO_    DATE not null
  )
tablespace IZK_DEV_DATA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  )'  ;
  
 c_create_table_o varchar2(500) :=   
' create table #TB
(
  ID            NUMBER(10) not null,
  INFO          VARCHAR2(100),
  DELETED       NUMBER(10) default 0 not null,
  "UID"           VARCHAR2(50),
  ENDDATECHANGE DATE
)
tablespace IZK_DEV_DATA
  pctfree 10
  initrans 1
  maxtrans 255';
  
 c_alter_table_o varchar2(500) :=  
' alter table #TB
  add constraint #TB_PK primary key (ID)
  using index 
  tablespace IZK_DEV_DATA
  pctfree 10
  initrans 2
  maxtrans 255
  ';
 c_alter varchar2(500) :='';
 c_alter_table  varchar2(100) :=' alter table #TB add #CL ';
 v_alter_table  varchar2(100) :='';
 c_comment      varchar2(1000) :=' comment on column #TB.#CL is ';
 v_comment      varchar2(1000) :='';
 v_field_name   user_tab_columns.COLUMN_NAME%type :='';
 v_type  varchar2(100) := '';
 c_nn          varchar2(20) :=' not null';
 v_nn          varchar2(20) :='';
 c_alter_table_m  varchar2(100) :=' alter table #TB modify #CL ';
 BEGIN  
   
c_core_register_id := 1600;
v_TEST := 0;  --RUN

 select count(*) into v_count from core_register  cr
 where cr.registerid = c_core_register_id;
 
 if v_count <> 1 then 
     dbms_output.put_line(TO_CHAR(v_count)||' ������ � core_register � ����� '||TO_CHAR(c_core_register_id)); 
     return;
 end if;
 
 select UPPER(TRIM(cr.quant_table)), UPPER(TRIM(cr.object_table)) into c_table_name, c_table_name_o  from core_register cr
 where cr.registerid = c_core_register_id;
 
   select count(*) into v_count from user_tab_columns tc where UPPER(tc.table_name) = c_table_name_o;
  
  if v_count<1 then 
      dbms_output.put_line('�������� �������  '||c_table_name_o);
      c_create_table_o := REPLACE( c_create_table_o, '#TB', c_table_name_o); 
      c_alter  := REPLACE( c_alter_table_o, '#TB', c_table_name_o); 
      if v_TEST = 0 then
        dbms_output.put_line(c_create_table_o);
       EXECUTE IMMEDIATE c_create_table_o;
        dbms_output.put_line(c_alter);
       EXECUTE IMMEDIATE c_alter; 
      else 
        dbms_output.put_line(c_create_table_o);
      end if;
  end if;
 
 --return;
 
  select count(*) into v_count from user_tab_columns tc where UPPER(tc.table_name) = c_table_name;
  
  if v_count<1 then 
      dbms_output.put_line('�������� ������� '||c_table_name);
      c_create_table := REPLACE( c_create_table, '#TB', c_table_name); 
      c_alter  := REPLACE( c_alter_table_o, '#TB', c_table_name);    
      if v_TEST = 0 then
         dbms_output.put_line(c_create_table);
       EXECUTE IMMEDIATE c_create_table;
         dbms_output.put_line(c_alter);
       EXECUTE IMMEDIATE c_alter; 
      else 
        dbms_output.put_line(c_create_table);
      end if;
    else 
       dbms_output.put_line('�������� ����� ������� '||c_table_name);  
  end if;
 
  
  for Rec in (
    select * from core_register_attribute cra
    where cra.registerid = c_core_register_id
    order by cra.id
  )                     
    loop
      v_count :=0;
      v_alter_table := '';
      v_comment := '';
      v_field_name := UPPER(TRIM(rec.value_field));
      v_nn := '';
      if rec.is_nullable is null then
        v_nn := c_nn;
      end if;  
      
      select count(*) into v_count from user_tab_columns tc 
      where UPPER(tc.table_name) = c_table_name 
       and  UPPER(tc.COLUMN_NAME) = v_field_name;
      
      if v_count = 0 then
         dbms_output.put_line('�������� ���� '||v_field_name||' ������� '||c_table_name);
         case rec.type when 1 then v_type := 'number';
                       when 2 then v_type := 'number';
                       when 3 then v_type := 'number(1)';
                       when 4 then v_type := 'varchar2(255)';
                       when 5 then v_type := 'DATE';
                     else  v_type := 'number'; 
         end case;
         v_alter_table := REPLACE (REPLACE( c_alter_table, '#TB', c_table_name), '#CL', v_field_name) || v_type || v_nn;   
         v_comment     := REPLACE (REPLACE( c_comment, '#TB', c_table_name), '#CL', v_field_name) ||''''||TRIM(rec.name)||'''';
        if v_TEST = 0 then
         EXECUTE IMMEDIATE v_alter_table;
         EXECUTE IMMEDIATE v_comment;
        else
         dbms_output.put_line(v_alter_table );
         dbms_output.put_line(v_comment );
        end if;            
      else
        dbms_output.put_line('���� '||v_field_name||' ��� ���� � ������� '||c_table_name); 
        if  v_nn is not null then 
          v_alter_table := REPLACE (REPLACE( c_alter_table_m, '#TB', c_table_name), '#CL', v_field_name) || v_type || v_nn;  
          dbms_output.put_line(v_alter_table);  
          begin  
            EXECUTE IMMEDIATE v_alter_table;
            exception
            when others then  dbms_output.put_line(sqlerrm);
          end;  
        end if;   
      end if; 
      
      v_field_name := UPPER(TRIM(REPLACE(rec.code_field,' ')));
      if  v_field_name is not NULL then
          select count(*) into v_count from user_tab_columns tc 
          where UPPER(tc.table_name) = c_table_name 
          and  UPPER(tc.COLUMN_NAME) = v_field_name;
       if v_count = 0 then
          dbms_output.put_line('�������� ���� '||v_field_name||' ������� '||c_table_name);
           v_type := 'number';
         v_alter_table := REPLACE (REPLACE( c_alter_table, '#TB', c_table_name), '#CL', v_field_name) || v_type || v_nn;   
         v_comment     := REPLACE (REPLACE( c_comment, '#TB', c_table_name), '#CL', v_field_name) ||''''||TRIM(rec.name)||' ���''';
          if v_TEST = 0 then
           EXECUTE IMMEDIATE v_alter_table;
           EXECUTE IMMEDIATE v_comment;
          else
           dbms_output.put_line(v_alter_table );
           dbms_output.put_line(v_comment );
          end if;            
       else
        dbms_output.put_line('���� '||v_field_name||' ��� ���� � ������� '||c_table_name);  
      end if; 
          
    end if; 
 
  end loop; 
  
 END;
