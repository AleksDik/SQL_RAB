-- Create table
create table U_RSGS_TYPE_GF
(
  id                  NUMBER(10) not null,
  object_id           NUMBER(10),
  object_id_in_source NUMBER(10),
  cls_id              NUMBER(10) not null,
  cls_id_tree         NUMBER(10) not null,
  source              VARCHAR2(50) not null,
  source_code         NUMBER(10) not null,
  changes_user_id     NUMBER(10) not null,
  changes_date        DATE not null,
  is_actual           NUMBER(1) not null,
  date_from           DATE,
  date_to             DATE
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
comment on table U_RSGS_TYPE_GF
  is 'Помещение ручной ввод ';
-- Add comments to the columns 
comment on column U_RSGS_TYPE_GF.id
  is ' Уникальный идентификатор записи ';
comment on column U_RSGS_TYPE_GF.object_id
  is ' Уникальный идентификатор объекта ';
comment on column U_RSGS_TYPE_GF.object_id_in_source
  is 'Идентификатор объекта в источнике';
comment on column U_RSGS_TYPE_GF.cls_id
  is 'Идентификатор вида жилищного фонда';
comment on column U_RSGS_TYPE_GF.cls_id_tree
  is 'Идентификатор родительской записи в кл. фондов';
comment on column U_RSGS_TYPE_GF.source
  is 'Источник поступления данных';
comment on column U_RSGS_TYPE_GF.source_code
  is 'Источник поступления данных (2003)';
comment on column U_RSGS_TYPE_GF.changes_user_id
  is 'Пользователь';
comment on column U_RSGS_TYPE_GF.changes_date
  is 'Дата внесения изменений';
comment on column U_RSGS_TYPE_GF.is_actual
  is 'Признак актуальности записи';
-- Create/Recreate primary, unique and foreign key constraints 
alter table U_RSGS_TYPE_GF
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
