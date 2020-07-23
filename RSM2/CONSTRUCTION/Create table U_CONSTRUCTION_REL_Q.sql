-- Create table
create table U_CONSTRUCTION_REL_Q
(
  id                     NUMBER(10) not null,
  emp_id                 NUMBER not null,
  actual                 NUMBER(1) not null,
  s_                     DATE not null,
  po_                    DATE not null,
  status                 NUMBER(1) not null,
  kadastr_num            VARCHAR2(50),
  unom                   NUMBER(10),
  changes_user_id        NUMBER(10) not null,
  chenges_date           DATE not null,
  u_construction_id      NUMBER(10),
  ehd_building_parcel_id NUMBER(10),
  bti_fsks_id            NUMBER(10),
  construction_id        NUMBER(10),
  alt_construction_id    NUMBER(10),
  egrp_object_id         NUMBER(10),
  ep_building_id         NUMBER(10),
  flag_ext               NUMBER(1)
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
  is '������������ ������ ���������� ����� (������ 1151)';
-- Add comments to the columns 
comment on column U_CONSTRUCTION_REL_Q.id
  is '���������� �������������  ������';
comment on column U_CONSTRUCTION_REL_Q.emp_id
  is '������������� ������� (115100100)';
comment on column U_CONSTRUCTION_REL_Q.kadastr_num
  is '����������� ����� �������  (115100200)';
comment on column U_CONSTRUCTION_REL_Q.unom
  is '�������� ����� ������� (115100300)';
comment on column U_CONSTRUCTION_REL_Q.u_construction_id
  is '������ �� ������  (115100400)';
comment on column U_CONSTRUCTION_REL_Q.ehd_building_parcel_id
  is '������ �� ������  �� ��������� �����   (115100500)';
comment on column U_CONSTRUCTION_REL_Q.bti_fsks_id
  is '����� ��� ������ �� ��������� ���  (115100600)';
comment on column U_CONSTRUCTION_REL_Q.construction_id
  is '������ �� ������ �� ������ ����������� ��������� �������� ����� ���1  (115100700)';
comment on column U_CONSTRUCTION_REL_Q.alt_construction_id
  is '������ �� ������ ����������� ����� ���1  (115100800)';
comment on column U_CONSTRUCTION_REL_Q.egrp_object_id
  is '����� �� ������ �� ������ ������� (115100900)';
comment on column U_CONSTRUCTION_REL_Q.ep_building_id
  is '������ �� ������ ������� ����� � ������������ ������ (115101000)';
comment on column U_CONSTRUCTION_REL_Q.flag_ext
  is '������� ��������������� ������ �� ������� � ��������� (115101100)';
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
