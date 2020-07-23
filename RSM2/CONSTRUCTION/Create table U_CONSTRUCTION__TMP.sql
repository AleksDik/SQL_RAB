-- Create table U_CONSTRUCTION_REL_Q
create table U_CONSTRUCTION_REL_Q
(
  id                         NUMBER(10) not null,
  emp_id                     NUMBER not null,
  actual                     NUMBER(1) not null,
  s_                         DATE not null,
  po_                        DATE not null,
  status                     NUMBER(1) not null,
  kadastr_num                VARCHAR2(50),
  unom                       NUMBER(10),
  changes_user_id            NUMBER(10) not null,
  chenges_date               DATE not null
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
comment on table U_CONSTRUCTION_REL_Q
  is 'Объединенный объект сооружение связи(реестр 1151)';
-- Add comments to the columns 
comment on column U_CONSTRUCTION_REL_Q.id
  is 'Уникальный идентификатор  записи';
comment on column U_CONSTRUCTION_REL_Q.emp_id
  is 'Идентификатор объекта (1151000100)';
comment on column U_CONSTRUCTION_REL_Q.kadastr_num
  is 'Кадастровый номер объекта  (1151000200)';
comment on column U_CONSTRUCTION_REL_Q.unom
  is 'Условный номер объекта (1151000300)';
-- Create/Recreate primary, unique and foreign key constraints 
alter table U_CONSTRUCTION_REL_Q
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
alter table U_CONSTRUCTION_REL_Q
  add constraint U_CONSTRUCTION_REL_Q_O_FK foreign key (EMP_ID)
  references U_CONSTRUCTION_REL_O (ID) on delete cascade;
  
