-- Create table
create table U_CONSTRUCTION_Q
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
  full_address               VARCHAR2(4000),
  short_address              VARCHAR2(4000),
  source_address             VARCHAR2(1000),
  source_address_code        NUMBER(10),
  postal_code                NUMBER(10),
  country                    VARCHAR2(1000),
  country_code               NUMBER(10),
  subject_rf                 VARCHAR2(1000),
  okrug                      VARCHAR2(1000),
  okrug_code                 NUMBER(10),
  district                   VARCHAR2(1000),
  district_code              NUMBER(10),
  type_city                  VARCHAR2(1000),
  city                       VARCHAR2(1000),
  type_plan                  VARCHAR2(1000),
  plan                       VARCHAR2(1000),
  type_locality              VARCHAR2(1000),
  locality                   VARCHAR2(1000),
  street_code                VARCHAR2(1000),
  type_street                VARCHAR2(1000),
  street                     VARCHAR2(1000),
  type_house                 VARCHAR2(50),
  type_house_code            NUMBER(10),
  house                      VARCHAR2(10),
  type_corpus                VARCHAR2(50),
  corpus                     VARCHAR2(10),
  type_structure             VARCHAR2(50),
  structure                  VARCHAR2(50),
  location_note              VARCHAR2(4000),
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
  kat_sobstv                 VARCHAR2(255),
  kat_sobstv_code            NUMBER(10),
  osnovan_pogash_prava       VARCHAR2(1000),
  osnovan_pogash_prava_code  NUMBER(10),
  status_kadadtr             VARCHAR2(255),
  status_kadadtr_code        NUMBER(10),
  input_way                  VARCHAR2(1000),
  input_way_code             NUMBER(10),
  flag_rsm                   NUMBER(1),
  rsm_inclusion_date         DATE,
  rsm_exclusion_date         DATE,
  source_attribute           VARCHAR2(4000),
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
comment on table U_CONSTRUCTION_Q
  is '������������ ������ ���������� (������ 1150)';
-- Add comments to the columns 
comment on column U_CONSTRUCTION_Q.id
  is '���������� �������������  ������';
comment on column U_CONSTRUCTION_Q.emp_id
  is '������������� ������� (115000100)';
comment on column U_CONSTRUCTION_Q.kadastr_num
  is '����������� ����� �������  (115000200)';
comment on column U_CONSTRUCTION_Q.unom
  is '�������� ����� ������� (115000300)';
comment on column U_CONSTRUCTION_Q.purpose
  is '���������� ������� (115000400)';
comment on column U_CONSTRUCTION_Q.purpose_code
  is '���������� ������� ��� (ref 2014)';
comment on column U_CONSTRUCTION_Q.class
  is '����� ������� (115000500)';
comment on column U_CONSTRUCTION_Q.class_code
  is '����� ������� ��� (ref 2021)';
comment on column U_CONSTRUCTION_Q.status_egrn
  is '������ ������� (115000600)';
comment on column U_CONSTRUCTION_Q.status_egrn_code
  is '������ ������� ��� (ref 2016)';
comment on column U_CONSTRUCTION_Q.status_sost_bti
  is '��������� �������� (115000700)';
comment on column U_CONSTRUCTION_Q.status_sost_bti_code
  is '��������� �������� (ref 2043)';
comment on column U_CONSTRUCTION_Q.type_object
  is '��� �������, ������, ��������� � �.�. (115000800)';
comment on column U_CONSTRUCTION_Q.type_object_code
  is '��� �������, ��� ������, ��������� � �.�. (ref 2000)';
comment on column U_CONSTRUCTION_Q.name
  is '������������ (115000900)';
comment on column U_CONSTRUCTION_Q.mst
  is '�������� ���� (115001000)';
comment on column U_CONSTRUCTION_Q.mst_code
  is '�������� ���� ��� (ref 2013,2044,2045)';
comment on column U_CONSTRUCTION_Q.floors
  is '���������� ������  (115001100)';
comment on column U_CONSTRUCTION_Q.underground_floors
  is '���������� ��������� ������ (115001200)';
comment on column U_CONSTRUCTION_Q.year_build
  is '��� ���������� ������������� (115001300)';
comment on column U_CONSTRUCTION_Q.comissioning_year
  is '��� ����� � ������������ (115001400)';
comment on column U_CONSTRUCTION_Q.u_building_address_id
  is '������ �� ����� ������� (115001500)';
comment on column U_CONSTRUCTION_Q.note
  is '���������� (115001600)';
comment on column U_CONSTRUCTION_Q.is_architecture_monument
  is '�������: �������� �����������. 1 - ��, 0 - ��� (115001700)';
comment on column U_CONSTRUCTION_Q.linear
  is '����������/ �������� ������ (�������) (115001800)';
comment on column U_CONSTRUCTION_Q.aperture_count
  is '���������� ��������� �������� (115001900)';
comment on column U_CONSTRUCTION_Q.bearing_count
  is '���������� ���� (115002000)';
comment on column U_CONSTRUCTION_Q.emplacement_level
  is '������� ��������� (115002100)';
comment on column U_CONSTRUCTION_Q.single_track_tunnel_length
  is '����� ���������� �������� (115002200)';
comment on column U_CONSTRUCTION_Q.double_track_tunnel_length
  is '����� ���������� �������� (115002300)';
comment on column U_CONSTRUCTION_Q.diameter_or_size
  is '������� (���������� �������) (115002400)';
comment on column U_CONSTRUCTION_Q.undertrestle_closed_spaces
  is '�������������� �������� ������������ (115002500)';
comment on column U_CONSTRUCTION_Q.undertrestle_open_spaces
  is '�������������� �������� ������������ (115002600)';
comment on column U_CONSTRUCTION_Q.struct_type
  is '��� ���������� (������ ������� ������, ���������-������������,����) (115002700)';
comment on column U_CONSTRUCTION_Q.struct_type_code
  is '��� ���������� ���  (ref 11571)';
comment on column U_CONSTRUCTION_Q.junctions
  is '�������� ������� ����� (115002800)';
comment on column U_CONSTRUCTION_Q.full_address
  is '������ ����� ������� �� ��������� � ������� �������������� (115002900)';
comment on column U_CONSTRUCTION_Q.short_address
  is '�������� ����� ������� �� ��������� � ������� �������������� (��� ��������� �������, �������, ������) (115003000)';
comment on column U_CONSTRUCTION_Q.source_address
  is '�������� ������ (115003100)';
comment on column U_CONSTRUCTION_Q.source_address_code
  is '�������� ������ ��� (ref 2003)';
comment on column U_CONSTRUCTION_Q.postal_code
  is '�������� ������ (115003200)';
comment on column U_CONSTRUCTION_Q.country
  is '������ (115003300)';
comment on column U_CONSTRUCTION_Q.country_code
  is '������ ��� (ref 2005)';
comment on column U_CONSTRUCTION_Q.subject_rf
  is '������� �� (115003400)';
comment on column U_CONSTRUCTION_Q.okrug
  is '����� (115003500)';
comment on column U_CONSTRUCTION_Q.okrug_code
  is '����� ��� (ref )';
comment on column U_CONSTRUCTION_Q.district
  is '����� (115003600)';
comment on column U_CONSTRUCTION_Q.district_code
  is '����� ��� (ref )';
comment on column U_CONSTRUCTION_Q.type_city
  is '��� ������ (115003700)';
comment on column U_CONSTRUCTION_Q.city
  is '����� (115003800)';
comment on column U_CONSTRUCTION_Q.type_plan
  is '��� �������� ������������� ��������� (115003900)';
comment on column U_CONSTRUCTION_Q.plan
  is '������� ������������� ��������� (115004000)';
comment on column U_CONSTRUCTION_Q.type_locality
  is '��� ����������� ������ (115004100)';
comment on column U_CONSTRUCTION_Q.locality
  is '���������� ����� (115004200)';
comment on column U_CONSTRUCTION_Q.street_code
  is '������ �� ��� ����� (115004300)';
comment on column U_CONSTRUCTION_Q.type_street
  is '��� ����� (��., �����. � �.�.) (115004400)';
comment on column U_CONSTRUCTION_Q.street
  is '������������ ����� (115004500)';
comment on column U_CONSTRUCTION_Q.type_house
  is '��� ���� (115004600)';
comment on column U_CONSTRUCTION_Q.type_house_code
  is '��� ���� ���  (ref 2006)';
comment on column U_CONSTRUCTION_Q.house
  is '����� ���� (115004700)';
comment on column U_CONSTRUCTION_Q.type_corpus
  is '��� ������� (115004800)';
comment on column U_CONSTRUCTION_Q.corpus
  is '����� �������  (115004900)';
comment on column U_CONSTRUCTION_Q.type_structure
  is '��� ��������  (115005000)';
comment on column U_CONSTRUCTION_Q.structure
  is '����� ��������  (115005100)';
comment on column U_CONSTRUCTION_Q.location_note
  is '��������� � �������������� (115005200)';
comment on column U_CONSTRUCTION_Q.rsm_number
  is '���������� ����� (115005300)';
comment on column U_CONSTRUCTION_Q.date_created
  is '���� ���������� �� ����������� ���� (115005400)';
comment on column U_CONSTRUCTION_Q.date_removed
  is '���� ������ � ������������ ����� (115005500)';
comment on column U_CONSTRUCTION_Q.guid_fias
  is '��� ���� (115005600)';
comment on column U_CONSTRUCTION_Q.cadastral_cost
  is '����������� ���������, ���. (115005700)';
comment on column U_CONSTRUCTION_Q.cadcost_dtval
  is '���� ����������� ��������� (115005800)';
comment on column U_CONSTRUCTION_Q.cadcost_dtent
  is '���� �������� ��������� (115005900)';
comment on column U_CONSTRUCTION_Q.cadcost_dtappr
  is '���� ����������� ��������� (115006000)';
comment on column U_CONSTRUCTION_Q.status_prav_sost
  is '������ ��������� ��������� (115006100)';
comment on column U_CONSTRUCTION_Q.status_prav_sost_code
  is '������ ��������� ��������� ���  (ref 2001)';
comment on column U_CONSTRUCTION_Q.kat_sobstv
  is '��������� ������������  (115006200)';
comment on column U_CONSTRUCTION_Q.kat_sobstv_code
  is '��������� ������������ ���  (ref 2022)';
comment on column U_CONSTRUCTION_Q.osnovan_pogash_prava
  is '��������� ��������� ����� ������  (115006300)';
comment on column U_CONSTRUCTION_Q.osnovan_pogash_prava_code
  is '��������� ��������� ����� ������ ���  (ref 2027)';
comment on column U_CONSTRUCTION_Q.status_kadadtr
  is '������ �������� ���������� �� ���. ����  (115006400)';
comment on column U_CONSTRUCTION_Q.status_kadadtr_code
  is '������ �������� ���������� �� ���. ���� ��� (ref 2004)';
comment on column U_CONSTRUCTION_Q.input_way
  is '������ ����������� ��  (115006500)';
comment on column U_CONSTRUCTION_Q.input_way_code
  is '������ ����������� �� ���  (ref 2002)';
comment on column U_CONSTRUCTION_Q.flag_rsm
  is '������� ��������� �������  � ������������� �. ������ (115006600)';
comment on column U_CONSTRUCTION_Q.rsm_inclusion_date
  is '���� ��������� ������� � ������������� �. ������ (115006700)';
comment on column U_CONSTRUCTION_Q.rsm_exclusion_date
  is '���� ���������� ������� �� ������������� �. ������ (115006800)';
comment on column U_CONSTRUCTION_Q.source_attribute
  is 'JSON �������� �������� (115006900)';
-- Create/Recreate primary, unique and foreign key constraints 
alter table U_CONSTRUCTION_Q
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
alter table U_CONSTRUCTION_Q
  add constraint U_CONSTRUCTION_Q_O_FK foreign key (EMP_ID)
  references U_CONSTRUCTION_O (ID) on delete cascade;
  
