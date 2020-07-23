-- Create table
create table U_CONSTRUCTION_REL_EXT_Q
(
  id                    NUMBER(10) not null,
  emp_id                NUMBER not null,
  actual                NUMBER(1) not null,
  s_                    DATE not null,
  po_                   DATE not null,
  status                NUMBER(1) not null,
  kadastr_num           VARCHAR2(50),
  unom                  NUMBER(10),
  changes_user_id       NUMBER(10) not null,
  chenges_date          DATE not null,
  u_construction_rel_id NUMBER(10),
  id_in_source          NUMBER(10),
  source                VARCHAR2(255) not null,
  source_code           NUMBER(10) not null,
  date_edit_in_source   DATE
)
tablespace IZK_DEV_DATA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table U_CONSTRUCTION_REL_EXT_Q
  is 'Объединенный объект сооружение множественные связи (реестр 1152)';
-- Add comments to the columns 
comment on column U_CONSTRUCTION_REL_EXT_Q.id
  is 'Уникальный идентификатор  записи';
comment on column U_CONSTRUCTION_REL_EXT_Q.emp_id
  is 'Идентификатор объекта (115200100)';
comment on column U_CONSTRUCTION_REL_EXT_Q.kadastr_num
  is 'Кадастровый номер объекта  (115200200)';
comment on column U_CONSTRUCTION_REL_EXT_Q.unom
  is 'Условный номер объекта (115200300)';
comment on column U_CONSTRUCTION_REL_EXT_Q.u_construction_rel_id
  is 'Ссылка на запись в реестре связей сооружения
 (115200400)';
comment on column U_CONSTRUCTION_REL_EXT_Q.id_in_source
  is 'Ссылка на иобъект в источнике
 (115200500)';
comment on column U_CONSTRUCTION_REL_EXT_Q.source
  is 'Источник данных  (115200600)';
comment on column U_CONSTRUCTION_REL_EXT_Q.source_code
  is 'Источник данных код
(ref 2003)';
comment on column U_CONSTRUCTION_REL_EXT_Q.date_edit_in_source
  is 'Дата записи сведений об объекте в источнике
 (115200700)';
-- Create/Recreate primary, unique and foreign key constraints 
alter table U_CONSTRUCTION_REL_EXT_Q
  add primary key (ID)
  using index 
  tablespace IZK_DEV_DATA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table U_CONSTRUCTION_REL_EXT_Q
  add constraint U_CONSTRUCTION_REL_EXT_Q_O_FK foreign key (EMP_ID)
  references U_CONSTRUCTION_REL_EXT_O (ID) on delete cascade;
