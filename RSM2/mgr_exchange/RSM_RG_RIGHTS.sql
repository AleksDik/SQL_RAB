CREATE OR REPLACE VIEW RSM_RG_RIGHTS AS
SELECT  ur.emp_id as id
        ,rghtbrd_type
        ,brd_condition
        ,reg_numb
        ,date_from
        ,date_to
        ,share_numerator
        ,share_denominator
        ,rghtbrd_id
        ,sbj_id_right
        ,obj_id
        ,comments
        ,state_numb
        ,state_date_from
        ,state_date_to
        ,create_user_id
        ,create_date
        ,modify_user_id
        ,modify_date
        ,sbj_id_burden
        ,regobj_id
        ,rgbrtp_id
        ,brd_curr_id
        ,brd_amount
        ,brd_period_text
        ,brd_period_date_from
        ,brd_period_date_to
        ,brd_space
        ,is_signed
        ,is_egrp
        ,issue_numb
        ,issue_date
    FROM u_right_q ur
    where ur.actual =1 
comment on column RSM_RG_RIGHTS.ID is '�������������';
comment on column RSM_RG_RIGHTS.RGHTBRD_TYPE is '���: ����� (RGHT); ����������� (BRD)';
comment on column RSM_RG_RIGHTS.BRD_CONDITION is '�����. - ������� �����������';
comment on column RSM_RG_RIGHTS.REG_NUMB is '��������������� ����� � ������� ���';
comment on column RSM_RG_RIGHTS.DATE_FROM is '����, � ������� ��������� �����/����������� (����������� ��� ���������� �������� ��������)';
comment on column RSM_RG_RIGHTS.DATE_TO is '����, �� ������� ����������� �����/����������� (����������� ��� ���������� �������� ��������)';
comment on column RSM_RG_RIGHTS.SHARE_NUMERATOR is '���� ������������� � ������� - ���������';
comment on column RSM_RG_RIGHTS.SHARE_DENOMINATOR is '���� ������������� � ������� - �����������';
comment on column RSM_RG_RIGHTS.RGHTBRD_ID is '�� �����, �� ������� ������������� �����������';
comment on column RSM_RG_RIGHTS.SBJ_ID_RIGHT is '�� ��������: ����� - ��� �����, ����������� - �� ���� �����������)';
comment on column RSM_RG_RIGHTS.OBJ_ID is '�� ������� �����';
comment on column RSM_RG_RIGHTS.COMMENTS is '�����������';
comment on column RSM_RG_RIGHTS.STATE_NUMB is '����� ��������������� ����������� (� ����)';
comment on column RSM_RG_RIGHTS.STATE_DATE_FROM is '���� ��������������� ����������� �������� �����/����������� (� ����)';
comment on column RSM_RG_RIGHTS.STATE_DATE_TO is '���� ��������������� ����������� �������� �����/����������� (� ����)';
comment on column RSM_RG_RIGHTS.CREATE_USER_ID is '������������, ��������� ������ � ��';
comment on column RSM_RG_RIGHTS.CREATE_DATE is '���� �������� ������ � ��';
comment on column RSM_RG_RIGHTS.MODIFY_USER_ID is '������������, ��������� ������������ ������ � ��';
comment on column RSM_RG_RIGHTS.MODIFY_DATE is '���� ���������� ��������� ������ � ��';
comment on column RSM_RG_RIGHTS.SBJ_ID_BURDEN is '�� ��������, � ��� ������ ������������� �����������';
comment on column RSM_RG_RIGHTS.REGOBJ_ID is '(NEW)�� �������� �������/������� �����';
comment on column RSM_RG_RIGHTS.RGBRTP_ID is '�� ���� �����/�����������';
comment on column RSM_RG_RIGHTS.BRD_CURR_ID is '�����. - ������ �� ������, � ������� �������� ����� �����������';
comment on column RSM_RG_RIGHTS.BRD_AMOUNT is '�����. - ����� �����������';
comment on column RSM_RG_RIGHTS.BRD_PERIOD_TEXT is '�����. - ���� - ��������� ��������';
comment on column RSM_RG_RIGHTS.BRD_PERIOD_DATE_FROM is '�����. - ���� - �';
comment on column RSM_RG_RIGHTS.BRD_PERIOD_DATE_TO is '�����. - ���� - ��';
comment on column RSM_RG_RIGHTS.BRD_SPACE is '�����. - ������������ �������';
comment on column RSM_RG_RIGHTS.IS_SIGNED is '�������, ��� ������ � �����/����������� ������(���) �������������';
comment on column RSM_RG_RIGHTS.IS_EGRP is '�������, ��� �����/����������� ���������������� � ����';
comment on column RSM_RG_RIGHTS.ISSUE_NUMB is '������� ���������� - ����� ��������� � �����/�����������';
comment on column RSM_RG_RIGHTS.ISSUE_DATE is '������� ���������� - ���� ���������� ��������� � �����/�����������';
