-- Create table EP_CONSTRUCTION_Q
create table EP_CONSTRUCTION_Q
(
  id                         NUMBER(10) not null,
  emp_id                     NUMBER not null,
  actual                     NUMBER(1) not null,
  s_                         DATE not null,
  po_                        DATE not null,
  status                     NUMBER(1) not null,
  kadastr_num                VARCHAR2(50),
  unom                       NUMBER(10),
  purpose                    VARCHAR2(1000),
  purpose_code               NUMBER(10),
  class                      VARCHAR2(1000),
  class_code                 NUMBER(10),
  status_egrn                VARCHAR2(1000),
  status_egrn_code           NUMBER(10),
  status_sost_bti            VARCHAR2(1000),
  status_sost_bti_code       NUMBER(10),
  type_object                VARCHAR2(1000),
  type_object_code           NUMBER(10),
  name                       VARCHAR2(4000),
  mst                        VARCHAR2(1000),
  mst_code                   NUMBER(10),
  floors                     VARCHAR2(50),
  underground_floors         VARCHAR2(50),
  year_build                 NUMBER(10),
  comissioning_year          NUMBER(10),
  u_building_address_id      NUMBER(10),
  note                       VARCHAR2(4000),
  is_architecture_monument   NUMBER(1),
  linear                     NUMBER(1),
  aperture_count             NUMBER(10),
  bearing_count              NUMBER(10),
  emplacement_level          VARCHAR2(1000),
  single_track_tunnel_length VARCHAR2(1000),
  double_track_tunnel_length VARCHAR2(1000),
  diameter_or_size           VARCHAR2(1000),
  undertrestle_closed_spaces VARCHAR2(1000),
  undertrestle_open_spaces   VARCHAR2(1000),
  struct_type                VARCHAR2(255),
  struct_type_code           NUMBER(10),
  junctions                  VARCHAR2(4000),
  rsm_number                 VARCHAR2(100),
  date_created               DATE,
  date_removed               DATE,
  guid_fias                  VARCHAR2(100),
  cadastral_cost             NUMBER(10,2),
  cadcost_dtval              DATE,
  cadcost_dtent              DATE,
  cadcost_dtappr             DATE,
  status_prav_sost           VARCHAR2(255),
  status_prav_sost_code      NUMBER(10),
  changes_user_id            NUMBER(10) not null,
  chenges_date               DATE not null,
  id_old                     NUMBER,
  source                     VARCHAR2(255),
  source_code                NUMBER(10)
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
comment on table EP_CONSTRUCTION_Q
  is 'Сооружение ручной ввод и исторические системы (реестр 1650)';
-- Add comments to the columns 
comment on column EP_CONSTRUCTION_Q.id
  is 'Уникальный идентификатор  записи';
comment on column EP_CONSTRUCTION_Q.emp_id
  is 'Идентификатор объекта (165000100)';
comment on column EP_CONSTRUCTION_Q.kadastr_num
  is 'Кадастровый номер объекта  (165000200)';
comment on column EP_CONSTRUCTION_Q.unom
  is 'Условный номер объекта (165000300)';
comment on column EP_CONSTRUCTION_Q.purpose
  is 'Назначение объекта (165000400)';
comment on column EP_CONSTRUCTION_Q.purpose_code
  is 'Назначение объекта код (ref 2014)';
comment on column EP_CONSTRUCTION_Q.class
  is 'Класс объекта (165000500)';
comment on column EP_CONSTRUCTION_Q.class_code
  is 'Класс объекта код (ref 2021)';
comment on column EP_CONSTRUCTION_Q.status_egrn
  is 'Статус объекта (165000600)';
comment on column EP_CONSTRUCTION_Q.status_egrn_code
  is 'Статус объекта код (ref 2016)';
comment on column EP_CONSTRUCTION_Q.status_sost_bti
  is 'состояние строения (165000700)';
comment on column EP_CONSTRUCTION_Q.status_sost_bti_code
  is 'состояние строения (ref 2043)';
comment on column EP_CONSTRUCTION_Q.type_object
  is 'Вид объекта, здание, помещение и т.д. (165000800)';
comment on column EP_CONSTRUCTION_Q.type_object_code
  is 'Вид объекта, код здание, помещение и т.д. (ref 2000)';
comment on column EP_CONSTRUCTION_Q.name
  is 'Наименование (165000900)';
comment on column EP_CONSTRUCTION_Q.mst
  is 'Материал стен (165001000)';
comment on column EP_CONSTRUCTION_Q.mst_code
  is 'Материал стен код (ref 2013,2044,2045)';
comment on column EP_CONSTRUCTION_Q.floors
  is 'Количество этажей  (165001100)';
comment on column EP_CONSTRUCTION_Q.underground_floors
  is 'Количество подземных этажей (165001200)';
comment on column EP_CONSTRUCTION_Q.year_build
  is 'Год завершения строительства (165001300)';
comment on column EP_CONSTRUCTION_Q.comissioning_year
  is 'Год ввода в эксплуатацию (165001400)';
comment on column EP_CONSTRUCTION_Q.u_building_address_id
  is 'Ссылка на адрес объекта (165001500)';
comment on column EP_CONSTRUCTION_Q.note
  is 'Примечание (165001600)';
comment on column EP_CONSTRUCTION_Q.is_architecture_monument
  is 'Отметка: памятник архитектуры. 1 - да, 0 - нет (165001700)';
comment on column EP_CONSTRUCTION_Q.linear
  is 'Сооружение/ линейный объект (признак) (165001800)';
comment on column EP_CONSTRUCTION_Q.aperture_count
  is 'Количество пролетных строений (165001900)';
comment on column EP_CONSTRUCTION_Q.bearing_count
  is 'Количество опор (165002000)';
comment on column EP_CONSTRUCTION_Q.emplacement_level
  is 'Уровень заложения (165002100)';
comment on column EP_CONSTRUCTION_Q.single_track_tunnel_length
  is 'Длина однопутных тоннелей (165002200)';
comment on column EP_CONSTRUCTION_Q.double_track_tunnel_length
  is 'Длина двухпутных тоннелей (165002300)';
comment on column EP_CONSTRUCTION_Q.diameter_or_size
  is 'Диаметр (габаритные размеры) (165002400)';
comment on column EP_CONSTRUCTION_Q.undertrestle_closed_spaces
  is 'Постэстакадные закрытые пространства (165002500)';
comment on column EP_CONSTRUCTION_Q.undertrestle_open_spaces
  is 'Постэстакадные открытые пространства (165002600)';
comment on column EP_CONSTRUCTION_Q.struct_type
  is 'Тип сооружения (отльно стоящее здание, встроенно-пристроенное,иное) (165002700)';
comment on column EP_CONSTRUCTION_Q.struct_type_code
  is 'Тип сооружения код  (ref 11571)';
comment on column EP_CONSTRUCTION_Q.junctions
  is 'Описание узловых точек (165002800)';
comment on column EP_CONSTRUCTION_Q.rsm_number
  is 'реестровый номер (165002900)';
comment on column EP_CONSTRUCTION_Q.date_created
  is 'Дата постановка на кадастровый учет (165003000)';
comment on column EP_CONSTRUCTION_Q.date_removed
  is 'Дата снятия с кадастрового учета (165003100)';
comment on column EP_CONSTRUCTION_Q.guid_fias
  is 'Код ФИАС (165003200)';
comment on column EP_CONSTRUCTION_Q.cadastral_cost
  is 'Кадастровая стоимость, руб. (165003300)';
comment on column EP_CONSTRUCTION_Q.cadcost_dtval
  is 'Дата определения стоимости (165003400)';
comment on column EP_CONSTRUCTION_Q.cadcost_dtent
  is 'Дата внесения стоимости (165003500)';
comment on column EP_CONSTRUCTION_Q.cadcost_dtappr
  is 'Дата утверждения стоимости (165003600)';
comment on column EP_CONSTRUCTION_Q.status_prav_sost
  is 'Статус правового состояния (165003700)';
comment on column EP_CONSTRUCTION_Q.status_prav_sost_code
  is 'Статус правового состояния код  (ref 2001)';
comment on column EP_CONSTRUCTION_Q.id_old
  is 'Ссылка на объект в источнике (165003800)';
comment on column EP_CONSTRUCTION_Q.source
  is 'Источник данных (165003900)';
comment on column EP_CONSTRUCTION_Q.source_code
  is 'Источник данных код (ref 2003)';
-- Create/Recreate primary, unique and foreign key constraints 
alter table EP_CONSTRUCTION_Q
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
alter table EP_CONSTRUCTION_Q
  add constraint EP_CONSTRUCTION_Q_O_FK foreign key (EMP_ID)
  references EP_CONSTRUCTION_O (ID) on delete cascade;
  
