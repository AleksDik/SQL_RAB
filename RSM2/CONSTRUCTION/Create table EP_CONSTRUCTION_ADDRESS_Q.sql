-- Create table
create table EP_CONSTRUCTION_ADDRESS_Q
(
  id                  NUMBER(10) not null,
  emp_id              NUMBER not null,
  actual              NUMBER(1) not null,
  s_                  DATE not null,
  po_                 DATE not null,
  status              NUMBER(1) not null,
  full_address        VARCHAR2(4000),
  short_address       VARCHAR2(4000),
  source_address      VARCHAR2(1000),
  source_address_code NUMBER(10),
  postal_code         NUMBER(10),
  country             VARCHAR2(1000),
  country_code        NUMBER(10),
  subject_rf          VARCHAR2(1000),
  okrug               VARCHAR2(1000),
  okrug_code          NUMBER(10),
  district            VARCHAR2(1000),
  district_code       NUMBER(10),
  type_city           VARCHAR2(1000),
  city                VARCHAR2(1000),
  type_plan           VARCHAR2(1000),
  plan                VARCHAR2(1000),
  type_locality       VARCHAR2(1000),
  locality            VARCHAR2(1000),
  street_code         VARCHAR2(1000),
  type_street         VARCHAR2(1000),
  street              VARCHAR2(1000),
  type_house          VARCHAR2(50),
  type_house_code     NUMBER(10),
  house               VARCHAR2(10),
  type_corpus         VARCHAR2(50),
  corpus              VARCHAR2(10),
  type_structure      VARCHAR2(50),
  structure           VARCHAR2(50),
  location_note       VARCHAR2(4000),
  changes_user_id     NUMBER(10) not null,
  chenges_date        DATE not null,
  fias_code           VARCHAR2(4000),
  ep_construction_id  NUMBER(10)
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
comment on table EP_CONSTRUCTION_ADDRESS_Q
  is 'Адрес сооружения (ручной ввод и исторические системы) (реестр 1651)';
-- Add comments to the columns 
comment on column EP_CONSTRUCTION_ADDRESS_Q.id
  is 'Уникальный идентификатор  записи';
comment on column EP_CONSTRUCTION_ADDRESS_Q.emp_id
  is 'Идентификатор объекта (165100100)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.full_address
  is 'Полный адрес объекта из источника в порядке приоритетности (165100200)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.short_address
  is 'Короткий адрес объекта из источника в порядке приоритетности (без почтового индекса, региона, города) (165100300)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.source_address
  is 'Источник адреса (165100400)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.source_address_code
  is 'Источник адреса код (ref 2003)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.postal_code
  is 'Почтовый индекс (165100500)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.country
  is 'Страна (165100600)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.country_code
  is 'Страна код (ref 2005)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.subject_rf
  is 'Субъект РФ (165100700)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.okrug
  is 'Округ (165100800)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.okrug_code
  is 'Округ код (ref )';
comment on column EP_CONSTRUCTION_ADDRESS_Q.district
  is 'Район (165100900)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.district_code
  is 'Район код (ref )';
comment on column EP_CONSTRUCTION_ADDRESS_Q.type_city
  is 'Тип города (165101000)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.city
  is 'Город (165101100)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.type_plan
  is 'Тип элемента планировочной структуры (165101200)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.plan
  is 'Элемент планировочной структуры (165101300)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.type_locality
  is 'Тип населенного пункта (165101400)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.locality
  is 'Населенный пункт (165101500)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.street_code
  is 'Ссылка на код улицы (165101600)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.type_street
  is 'Тип улицы (ул., бульв. И т.д.) (165101700)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.street
  is 'Наименование улицы (165101800)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.type_house
  is 'Тип дома (165101900)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.type_house_code
  is 'Тип дома код  (ref 2006)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.house
  is 'Номер дома (165102000)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.type_corpus
  is 'Тип корпуса (165102100)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.corpus
  is 'Номер корпуса  (165102200)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.type_structure
  is 'Тип строения  (165102300)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.structure
  is 'Номер строения  (165102400)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.location_note
  is 'Пояснение к местоположению (165102500)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.fias_code
  is 'Код /ФИАС (165102600)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.ep_construction_id
  is 'Ссылка на сооружение (165102700)';
-- Create/Recreate primary, unique and foreign key constraints 
alter table EP_CONSTRUCTION_ADDRESS_Q
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
alter table EP_CONSTRUCTION_ADDRESS_Q
  add constraint EP_CONSTRUCTION_ADDRESS_Q_O_FK foreign key (EMP_ID)
  references EP_CONSTRUCTION_ADDRESS_O (ID) on delete cascade;
  
