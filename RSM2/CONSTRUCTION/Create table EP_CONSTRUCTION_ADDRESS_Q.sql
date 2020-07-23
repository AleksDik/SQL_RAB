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
  is '����� ���������� (������ ���� � ������������ �������) (������ 1651)';
-- Add comments to the columns 
comment on column EP_CONSTRUCTION_ADDRESS_Q.id
  is '���������� �������������  ������';
comment on column EP_CONSTRUCTION_ADDRESS_Q.emp_id
  is '������������� ������� (165100100)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.full_address
  is '������ ����� ������� �� ��������� � ������� �������������� (165100200)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.short_address
  is '�������� ����� ������� �� ��������� � ������� �������������� (��� ��������� �������, �������, ������) (165100300)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.source_address
  is '�������� ������ (165100400)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.source_address_code
  is '�������� ������ ��� (ref 2003)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.postal_code
  is '�������� ������ (165100500)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.country
  is '������ (165100600)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.country_code
  is '������ ��� (ref 2005)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.subject_rf
  is '������� �� (165100700)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.okrug
  is '����� (165100800)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.okrug_code
  is '����� ��� (ref )';
comment on column EP_CONSTRUCTION_ADDRESS_Q.district
  is '����� (165100900)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.district_code
  is '����� ��� (ref )';
comment on column EP_CONSTRUCTION_ADDRESS_Q.type_city
  is '��� ������ (165101000)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.city
  is '����� (165101100)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.type_plan
  is '��� �������� ������������� ��������� (165101200)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.plan
  is '������� ������������� ��������� (165101300)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.type_locality
  is '��� ����������� ������ (165101400)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.locality
  is '���������� ����� (165101500)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.street_code
  is '������ �� ��� ����� (165101600)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.type_street
  is '��� ����� (��., �����. � �.�.) (165101700)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.street
  is '������������ ����� (165101800)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.type_house
  is '��� ���� (165101900)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.type_house_code
  is '��� ���� ���  (ref 2006)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.house
  is '����� ���� (165102000)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.type_corpus
  is '��� ������� (165102100)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.corpus
  is '����� �������  (165102200)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.type_structure
  is '��� ��������  (165102300)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.structure
  is '����� ��������  (165102400)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.location_note
  is '��������� � �������������� (165102500)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.fias_code
  is '��� /���� (165102600)';
comment on column EP_CONSTRUCTION_ADDRESS_Q.ep_construction_id
  is '������ �� ���������� (165102700)';
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
  
