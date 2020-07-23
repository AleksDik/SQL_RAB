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
  is '���������� ������ ���� � ������������ ������� (������ 1650)';
-- Add comments to the columns 
comment on column EP_CONSTRUCTION_Q.id
  is '���������� �������������  ������';
comment on column EP_CONSTRUCTION_Q.emp_id
  is '������������� ������� (165000100)';
comment on column EP_CONSTRUCTION_Q.kadastr_num
  is '����������� ����� �������  (165000200)';
comment on column EP_CONSTRUCTION_Q.unom
  is '�������� ����� ������� (165000300)';
comment on column EP_CONSTRUCTION_Q.purpose
  is '���������� ������� (165000400)';
comment on column EP_CONSTRUCTION_Q.purpose_code
  is '���������� ������� ��� (ref 2014)';
comment on column EP_CONSTRUCTION_Q.class
  is '����� ������� (165000500)';
comment on column EP_CONSTRUCTION_Q.class_code
  is '����� ������� ��� (ref 2021)';
comment on column EP_CONSTRUCTION_Q.status_egrn
  is '������ ������� (165000600)';
comment on column EP_CONSTRUCTION_Q.status_egrn_code
  is '������ ������� ��� (ref 2016)';
comment on column EP_CONSTRUCTION_Q.status_sost_bti
  is '��������� �������� (165000700)';
comment on column EP_CONSTRUCTION_Q.status_sost_bti_code
  is '��������� �������� (ref 2043)';
comment on column EP_CONSTRUCTION_Q.type_object
  is '��� �������, ������, ��������� � �.�. (165000800)';
comment on column EP_CONSTRUCTION_Q.type_object_code
  is '��� �������, ��� ������, ��������� � �.�. (ref 2000)';
comment on column EP_CONSTRUCTION_Q.name
  is '������������ (165000900)';
comment on column EP_CONSTRUCTION_Q.mst
  is '�������� ���� (165001000)';
comment on column EP_CONSTRUCTION_Q.mst_code
  is '�������� ���� ��� (ref 2013,2044,2045)';
comment on column EP_CONSTRUCTION_Q.floors
  is '���������� ������  (165001100)';
comment on column EP_CONSTRUCTION_Q.underground_floors
  is '���������� ��������� ������ (165001200)';
comment on column EP_CONSTRUCTION_Q.year_build
  is '��� ���������� ������������� (165001300)';
comment on column EP_CONSTRUCTION_Q.comissioning_year
  is '��� ����� � ������������ (165001400)';
comment on column EP_CONSTRUCTION_Q.u_building_address_id
  is '������ �� ����� ������� (165001500)';
comment on column EP_CONSTRUCTION_Q.note
  is '���������� (165001600)';
comment on column EP_CONSTRUCTION_Q.is_architecture_monument
  is '�������: �������� �����������. 1 - ��, 0 - ��� (165001700)';
comment on column EP_CONSTRUCTION_Q.linear
  is '����������/ �������� ������ (�������) (165001800)';
comment on column EP_CONSTRUCTION_Q.aperture_count
  is '���������� ��������� �������� (165001900)';
comment on column EP_CONSTRUCTION_Q.bearing_count
  is '���������� ���� (165002000)';
comment on column EP_CONSTRUCTION_Q.emplacement_level
  is '������� ��������� (165002100)';
comment on column EP_CONSTRUCTION_Q.single_track_tunnel_length
  is '����� ���������� �������� (165002200)';
comment on column EP_CONSTRUCTION_Q.double_track_tunnel_length
  is '����� ���������� �������� (165002300)';
comment on column EP_CONSTRUCTION_Q.diameter_or_size
  is '������� (���������� �������) (165002400)';
comment on column EP_CONSTRUCTION_Q.undertrestle_closed_spaces
  is '�������������� �������� ������������ (165002500)';
comment on column EP_CONSTRUCTION_Q.undertrestle_open_spaces
  is '�������������� �������� ������������ (165002600)';
comment on column EP_CONSTRUCTION_Q.struct_type
  is '��� ���������� (������ ������� ������, ���������-������������,����) (165002700)';
comment on column EP_CONSTRUCTION_Q.struct_type_code
  is '��� ���������� ���  (ref 11571)';
comment on column EP_CONSTRUCTION_Q.junctions
  is '�������� ������� ����� (165002800)';
comment on column EP_CONSTRUCTION_Q.rsm_number
  is '���������� ����� (165002900)';
comment on column EP_CONSTRUCTION_Q.date_created
  is '���� ���������� �� ����������� ���� (165003000)';
comment on column EP_CONSTRUCTION_Q.date_removed
  is '���� ������ � ������������ ����� (165003100)';
comment on column EP_CONSTRUCTION_Q.guid_fias
  is '��� ���� (165003200)';
comment on column EP_CONSTRUCTION_Q.cadastral_cost
  is '����������� ���������, ���. (165003300)';
comment on column EP_CONSTRUCTION_Q.cadcost_dtval
  is '���� ����������� ��������� (165003400)';
comment on column EP_CONSTRUCTION_Q.cadcost_dtent
  is '���� �������� ��������� (165003500)';
comment on column EP_CONSTRUCTION_Q.cadcost_dtappr
  is '���� ����������� ��������� (165003600)';
comment on column EP_CONSTRUCTION_Q.status_prav_sost
  is '������ ��������� ��������� (165003700)';
comment on column EP_CONSTRUCTION_Q.status_prav_sost_code
  is '������ ��������� ��������� ���  (ref 2001)';
comment on column EP_CONSTRUCTION_Q.id_old
  is '������ �� ������ � ��������� (165003800)';
comment on column EP_CONSTRUCTION_Q.source
  is '�������� ������ (165003900)';
comment on column EP_CONSTRUCTION_Q.source_code
  is '�������� ������ ��� (ref 2003)';
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
  
