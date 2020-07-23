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
  is '��������� ������ ���� ';
-- Add comments to the columns 
comment on column U_RSGS_TYPE_GF.id
  is ' ���������� ������������� ������ ';
comment on column U_RSGS_TYPE_GF.object_id
  is ' ���������� ������������� ������� ';
comment on column U_RSGS_TYPE_GF.object_id_in_source
  is '������������� ������� � ���������';
comment on column U_RSGS_TYPE_GF.cls_id
  is '������������� ���� ��������� �����';
comment on column U_RSGS_TYPE_GF.cls_id_tree
  is '������������� ������������ ������ � ��. ������';
comment on column U_RSGS_TYPE_GF.source
  is '�������� ����������� ������';
comment on column U_RSGS_TYPE_GF.source_code
  is '�������� ����������� ������ (2003)';
comment on column U_RSGS_TYPE_GF.changes_user_id
  is '������������';
comment on column U_RSGS_TYPE_GF.changes_date
  is '���� �������� ���������';
comment on column U_RSGS_TYPE_GF.is_actual
  is '������� ������������ ������';
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
