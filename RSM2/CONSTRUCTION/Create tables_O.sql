-- Create table_o

select *
from all_tab_columns a
LEFT JOIN user_col_comments c ON (a.table_name  = c.table_name AND a.column_name = c.column_name)
where a.TABLE_NAME in ('U_CONSTRUCTION_O',
'U_CONSTRUCTION_REL_O',
'U_CONSTRUCTION_REL_EXT_O',
'U_CONSTRUCTION_PARAM_O',
'EP_CONSTRUCTION_O',
'EP_CONSTRUCTION_ADDRESS_O',
'EP_CONSTRUCTION_PARAM_O'
)
order by a.TABLE_NAME;
------------------------------------
create table U_CONSTRUCTION_O
(
  id            NUMBER(10) not null,
  info          VARCHAR2(100),
  deleted       NUMBER(10) default 0 not null,
  "UID"           VARCHAR2(50),
  enddatechange DATE
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
 
comment on table U_CONSTRUCTION_O
  is 'Объединенный объект сооружение (колонка Object реестра 1150)';
alter table U_CONSTRUCTION_O
  add constraint U_CONSTRUCTION_O_PK primary key (ID)
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
----------------------------------------------------------------------------------------

create table U_CONSTRUCTION_REL_O
(
  id            NUMBER(10) not null,
  info          VARCHAR2(100),
  deleted       NUMBER(10) default 0 not null,
  "UID"           VARCHAR2(50),
  enddatechange DATE
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
 
comment on table U_CONSTRUCTION_REL_O
  is 'Объединенный объект сооружение связи (колонка Object реестра 1151)';
alter table U_CONSTRUCTION_REL_O
  add constraint U_CONSTRUCTION_REL_O_PK primary key (ID)
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
----------------------------------------------------------------------------------------
create table U_CONSTRUCTION_REL_EXT_O
(
  id            NUMBER(10) not null,
  info          VARCHAR2(100),
  deleted       NUMBER(10) default 0 not null,
  "UID"           VARCHAR2(50),
  enddatechange DATE
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
 
comment on table U_CONSTRUCTION_REL_EXT_O
  is 'Объединенный объект сооружение множественные связи (колонка Object реестра 1152)';
alter table U_CONSTRUCTION_REL_EXT_O
  add constraint U_CONSTRUCTION_REL_EXT_O_PK primary key (ID)
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
----------------------------------------------------------------------------------------
create table U_CONSTRUCTION_PARAM_O
(
  id            NUMBER(10) not null,
  info          VARCHAR2(100),
  deleted       NUMBER(10) default 0 not null,
  "UID"           VARCHAR2(50),
  enddatechange DATE
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
 
comment on table U_CONSTRUCTION_PARAM_O
  is 'Параметры сооружения (объединенный объект)(колонка Object реестра 1153)';
alter table U_CONSTRUCTION_PARAM_O
  add constraint U_CONSTRUCTION_PARAM_O_PK primary key (ID)
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
----------------------------------------------------------------------------------------
create table EP_CONSTRUCTION_O
(
  id            NUMBER(10) not null,
  info          VARCHAR2(100),
  deleted       NUMBER(10) default 0 not null,
  "UID"           VARCHAR2(50),
  enddatechange DATE
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
 
comment on table EP_CONSTRUCTION_O
  is 'Сооружение ручной ввод и исторические системы (колонка Object реестра 1650)';
alter table EP_CONSTRUCTION_O
  add constraint EP_CONSTRUCTION_O_PK primary key (ID)
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
----------------------------------------------------------------------------------------

create table EP_CONSTRUCTION_ADDRESS_O
(
  id            NUMBER(10) not null,
  info          VARCHAR2(100),
  deleted       NUMBER(10) default 0 not null,
  "UID"           VARCHAR2(50),
  enddatechange DATE
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
 
comment on table EP_CONSTRUCTION_ADDRESS_O
  is 'Адрес сооружения ручной ввод и исторические системы (колонка Object реестра 1651)';
alter table EP_CONSTRUCTION_ADDRESS_O
  add constraint EP_CONSTRUCTION_ADDRESS_O_PK primary key (ID)
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
----------------------------------------------------------------------------------------

create table EP_CONSTRUCTION_PARAM_O
(
  id            NUMBER(10) not null,
  info          VARCHAR2(100),
  deleted       NUMBER(10) default 0 not null,
  "UID"           VARCHAR2(50),
  enddatechange DATE
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
 
comment on table EP_CONSTRUCTION_PARAM_O
  is 'Параметры сооружения ручной ввод и исторические системы (колонка Object реестра 1653)';
alter table EP_CONSTRUCTION_PARAM_O
  add constraint EP_CONSTRUCTION_PARAM_O_PK primary key (ID)
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
----------------------------------------------------------------------------------------
