-- Create table
create table U_OBJECT_MANUAL_CHARACT
(
  id                          NUMBER(10) not null,
  object_id                   NUMBER(10) not null,
  object_type                 VARCHAR2(50) not null,
  object_type_code            NUMBER(10) not null,
  relig_flag                  NUMBER(1),
  relig_doc_num               VARCHAR2(50),
  relig_doc_date              DATE,
  go_building_flag            NUMBER(1),
  go_premise_flag             NUMBER(1),
  go_premise_full_part        VARCHAR2(50),
  go_premise_full_part_code   NUMBER(10),
  go_doc_num                  VARCHAR2(50),
  go_doc_date                 DATE,
  cult_heritage_flag          NUMBER(1),
  cult_heritage_reg_type      VARCHAR2(50),
  cult_heritage_reg_type_code NUMBER(10),
  cult_heritage_condition     NUMBER(1),
  cult_heritage_doc_num       VARCHAR2(50),
  cult_heritage_doc_date      DATE,
  parking_space_flag          NUMBER(1),
  parking_space_doc_num       VARCHAR2(50),
  parking_space_doc_date      DATE,
  fkr_improve_date            DATE,
  fkr_improve_doc_num         VARCHAR2(50),
  fkr_improve_doc_date        DATE,
  unauthorized_osz_flag       NUMBER(1),
  unauthorized_extension_flag NUMBER(1),
  unauthorized_doc_num        VARCHAR2(50),
  unauthorized_doc_date       DATE,
  changes_user_id             NUMBER(10),
  changes_date                DATE
)
tablespace IZK_DEV_DATA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table U_OBJECT_MANUAL_CHARACT
  is '������ ������������� ������� ����� (1920)';
-- Add comments to the columns 
comment on column U_OBJECT_MANUAL_CHARACT.id
  is '���������� ������������� ������
';
comment on column U_OBJECT_MANUAL_CHARACT.object_id
  is '���������� ������������� ������� (192000100)';
comment on column U_OBJECT_MANUAL_CHARACT.object_type
  is '��� ������� (192000200)
';
comment on column U_OBJECT_MANUAL_CHARACT.object_type_code
  is '��� ������� ���';
comment on column U_OBJECT_MANUAL_CHARACT.relig_flag
  is '������ ������������ ���������� - �������������� (0 - ���; 1 - ��) (192000300)';
comment on column U_OBJECT_MANUAL_CHARACT.relig_doc_num
  is '������ ������������ ���������� - ����� ��������� �� ���������� (192000400)
';
comment on column U_OBJECT_MANUAL_CHARACT.relig_doc_date
  is '������ ������������ ���������� - ���� ��������� �� ���������� (192000500)
';
comment on column U_OBJECT_MANUAL_CHARACT.go_building_flag
  is '�� � �� - �������������� ������ (0 - ���; 1 - ��) (192000600)
';
comment on column U_OBJECT_MANUAL_CHARACT.go_premise_flag
  is '�� � �� - �������������� ��������� (0 - ���; 1 - ��) (192000700)
';
comment on column U_OBJECT_MANUAL_CHARACT.go_premise_full_part
  is '�� � �� - ��������� ��������� ��� �������� (192000800)
';
comment on column U_OBJECT_MANUAL_CHARACT.go_premise_full_part_code
  is '�� � �� - ��������� ��������� ��� �������� (���)
';
comment on column U_OBJECT_MANUAL_CHARACT.go_doc_num
  is '�� � �� - ����� ��������� (192000900)
';
comment on column U_OBJECT_MANUAL_CHARACT.go_doc_date
  is '�� � �� - ���� ��������� (192001000)';
comment on column U_OBJECT_MANUAL_CHARACT.cult_heritage_flag
  is '������ ����������� �������� - ������� � ������� ����������� �������� (0 - ���; 1 - ��) (192001100)
';
comment on column U_OBJECT_MANUAL_CHARACT.cult_heritage_reg_type
  is '������ ����������� �������� - ��� ������� � ������� ��� (192001200)
';
comment on column U_OBJECT_MANUAL_CHARACT.cult_heritage_reg_type_code
  is '������ ����������� �������� - ��� ������� � ������� ��� (���)
';
comment on column U_OBJECT_MANUAL_CHARACT.cult_heritage_condition
  is '������ ����������� �������� - ��������� (0 - ����; 1 - ��) (192001300)
';
comment on column U_OBJECT_MANUAL_CHARACT.cult_heritage_doc_num
  is '������ ����������� �������� - ����� ��������� (192001400)
';
comment on column U_OBJECT_MANUAL_CHARACT.cult_heritage_doc_date
  is '������ ����������� �������� - ���� ��������� (192001500)
';
comment on column U_OBJECT_MANUAL_CHARACT.parking_space_flag
  is '������-����� - ������� (0 - ���; 1 - ��) (192001600)
';
comment on column U_OBJECT_MANUAL_CHARACT.parking_space_doc_num
  is '������-����� - ����� ���� ������� (192001700)
';
comment on column U_OBJECT_MANUAL_CHARACT.parking_space_doc_date
  is '������-����� - ���� ���� ������� (192001800)
';
comment on column U_OBJECT_MANUAL_CHARACT.fkr_improve_date
  is '���� ������������ ������� - ���� ������� (192001900)
';
comment on column U_OBJECT_MANUAL_CHARACT.fkr_improve_doc_num
  is '���� ������������ ������� - ����� ��������� (192002000)
';
comment on column U_OBJECT_MANUAL_CHARACT.fkr_improve_doc_date
  is '���� ������������ ������� - ���� ��������� (192002100)
';
comment on column U_OBJECT_MANUAL_CHARACT.unauthorized_osz_flag
  is '��������� - ��������� ������� ������ (0 - ���; 1 - ��) (192002200)
';
comment on column U_OBJECT_MANUAL_CHARACT.unauthorized_extension_flag
  is '��������� - ���������� (0 - ���; 1 - ��) (192002300)
';
comment on column U_OBJECT_MANUAL_CHARACT.unauthorized_doc_num
  is '��������� - ����� ��������� (192002400)
';
comment on column U_OBJECT_MANUAL_CHARACT.unauthorized_doc_date
  is '��������� - ���� ��������� (192002500)
';
comment on column U_OBJECT_MANUAL_CHARACT.changes_user_id
  is '������������
';
comment on column U_OBJECT_MANUAL_CHARACT.changes_date
  is '���� �������� ���������';
-- Create/Recreate indexes 
create unique index I_U_OBJECT_MANUAL_CHARACT_OBJECT_ID on U_OBJECT_MANUAL_CHARACT (OBJECT_ID)
  tablespace IZK_DEV_DATA
  pctfree 10
  initrans 2
  maxtrans 255;
-- Create/Recreate primary, unique and foreign key constraints 
alter table U_OBJECT_MANUAL_CHARACT
  add constraint U_OBJECT_MANUAL_CHARACT_PK primary key (ID)
  using index 
  tablespace IZK_DEV_DATA
  pctfree 10
  initrans 2
  maxtrans 255;
