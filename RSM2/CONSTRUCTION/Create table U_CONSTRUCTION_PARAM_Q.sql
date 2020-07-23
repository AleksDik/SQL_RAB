-- Create table
create table U_CONSTRUCTION_PARAM_Q
(
  id                       NUMBER(10) not null,
  emp_id                   NUMBER not null,
  actual                   NUMBER(1) not null,
  s_                       DATE not null,
  po_                      DATE not null,
  status                   NUMBER(1) not null,
  changes_user_id          NUMBER(10) not null,
  chenges_date             DATE not null,
  object_id                NUMBER(10) not null,
  register_object          NUMBER(10) not null,
  param_construction       VARCHAR2(100),
  param_construction_code  NUMBER(10),
  param_construction_value NUMBER(10,1),
  unit                     VARCHAR2(100),
  unit_code                NUMBER(10)
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
comment on table U_CONSTRUCTION_PARAM_Q
  is 'Параметры сооружения (объединенный объект) (реестр 1153)';
-- Add comments to the columns 
comment on column U_CONSTRUCTION_PARAM_Q.id
  is 'Уникальный идентификатор  записи';
comment on column U_CONSTRUCTION_PARAM_Q.emp_id
  is 'Идентификатор объекта (115300100)';
comment on column U_CONSTRUCTION_PARAM_Q.object_id
  is 'Ссылка на объект
 (115300200)';
comment on column U_CONSTRUCTION_PARAM_Q.register_object
  is 'Номер реестра объекта
 (115300300)';
comment on column U_CONSTRUCTION_PARAM_Q.param_construction
  is 'Параметр (глубина залегания, протяженность, глубина, объекм, высота, площадь, площадь застройки)(115300400)';
comment on column U_CONSTRUCTION_PARAM_Q.param_construction_code
  is 'Параметр код (ref 95)';
comment on column U_CONSTRUCTION_PARAM_Q.param_construction_value
  is 'Значение параметра
(115300500)';
comment on column U_CONSTRUCTION_PARAM_Q.unit
  is 'Единицы измерения 
(115300600)';
comment on column U_CONSTRUCTION_PARAM_Q.unit_code
  is 'Единицы измерения код
(ref 12007)';
-- Create/Recreate primary, unique and foreign key constraints 
alter table U_CONSTRUCTION_PARAM_Q
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
alter table U_CONSTRUCTION_PARAM_Q
  add constraint U_CONSTRUCTION_PARAM_Q_O_FK foreign key (EMP_ID)
  references U_CONSTRUCTION_PARAM_O (ID) on delete cascade;
  
