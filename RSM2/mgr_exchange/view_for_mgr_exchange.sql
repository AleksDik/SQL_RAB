SELECT  ub.emp_id as id
        ,'BLD' as obj_type
        ,null as name
        ,null as obj_id_parent
        ,ub.street as bld_street
        ,ub.house as bld_house_numb
        ,ub.corpus as bld_corp_numb
        ,ub.structure as bld_stroen_numb
        ,ub.total_area_residential_prem as bld_square_living
        ,ub.kwq as bld_apart_count
        ,ub.floors as bld_storey_count
        ,NULL as rm_numb
        ,NULL as rm_square
        ,ub.rsm_number as reg_numb
        ,NULL as apr_numb
        ,NULL as apr_ind
        ,NULL as apr_room_count
        ,NULL as apr_square_living
        ,ub.note as comments
        ,NULL as apr_rim
        ,NULL as rm_ind
        ,NULL as apr_unkv
        ,NULL as rm_l
        ,NULL as apr_square_adjusted
        ,ub.kadastr_num as cadastral_numb
        ,NULL as conventional_numb
        ,NULL as conventional_date
        ,ub.site_area as bld_square_total
        ,NULL as apr_square_total
        ,NULL as create_user_id
        ,NULL as create_date
        ,NULL as modify_user_id
        ,NULL as modify_date
        ,NULL as inventory_file_id
        ,NULL as inventory_sign_file_id
        ,NULL as inventory_crtf_id
        ,NULL as close_date  --ep
        ,NULL as is_closed   --ep
        ,ub.unom as bld_unom
        ,NULL as close_occs_id --ep
        ,NULL as apr_numb_for_doc
        ,ub.year_build as bld_year
        ,NULL as apr_name_id
        ,NULL as is_bti_updated
        ,NULL as date_bti_update
        ,NULL as rm_order_numb
        ,NULL as apr_storey
        ,NULL as rm_storey
        ,NULL as is_hostel
        ,NULL as hostel_id
        ,decode(NVL(ub.purpose_code,0),20140002,0,1) as is_undwelling
        ,NULL as bld_has_tszh
        ,NULL as bld_unad
    FROM u_building_q ub
    where ub.actual =1 ;
    /*
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.ID is '�������������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.OBJ_TYPE is '��� �������(BLD-������,APR-���������=��������,RM-�������,TNM-(tenement)��������������� ���, GRP-������ � ��������� ����������)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.NAME is '������������ ������� (���� ������ ���������, ����� ����� � ������, ����� ���, ������� �������, ����� � �.�.)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.OBJ_ID_PARENT is '�� �������, ������ �������� �������� ������ ������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_STREET is '������ - ����� �������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_HOUSE_NUMB is '������ - ����� ����';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_CORP_NUMB is '������ - ����� �������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_STROEN_NUMB is '������ - ����� ��������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_SQUARE_LIVING is '������ - ����� ������� ����� ���������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_APART_COUNT is '������ - ���������� �������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_STOREY_COUNT is '������ - ���������� ������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.RM_NUMB is '������� - ����� ������� � ��������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.RM_SQUARE is '������� - ������� �������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.REG_NUMB is '����� ������� ����� � �������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_NUMB is '�������� - ����� ��������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_IND is '�������� - ������ ��������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_ROOM_COUNT is '�������� - ���������� ������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_SQUARE_LIVING is '�������� - ����� �������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.COMMENTS is '�����������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_RIM is '�������� - ������� ������� ����� � ������ ��������� (0-��������, 1-�������)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.RM_IND is '������� - ������ �������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_UNKV is '�������� - ���������� ����� �������� � ���� (����� ���������� ��-� � �� ���)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.RM_L is '������� - ������ �������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_SQUARE_ADJUSTED is '�������� - ����� ������� (� �������) = ����������� ������� (� ������ ������ � ��������)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.CADASTRAL_NUMB is '����������� ����� �������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.CONVENTIONAL_NUMB is '�������� ����� ������� � �� ���';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.CONVENTIONAL_DATE is '���� ��������� (�����������) ��������� ������ ������� � �� ���';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_SQUARE_TOTAL is '������ - ����� �������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_SQUARE_TOTAL is '�������� - ����� ������� (��� ������)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.CREATE_USER_ID is '������������, ��������� ������ � ��';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.CREATE_DATE is '���� �������� ������ � ��';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.MODIFY_USER_ID is '������������, ��������� ��������� ��������� ������ � ��';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.MODIFY_DATE is '���� ���������� ��������� ������ � ��';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.INVENTORY_FILE_ID is 'id ����� ����� � �������� ������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.INVENTORY_SIGN_FILE_ID is 'id ����� ������� ����� � �������� ������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.INVENTORY_CRTF_ID is 'id ����������� ���, ������������ �����';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.CLOSE_DATE is '���� �������� ������� � ����';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.IS_CLOSED is '������ ������ (0-���, 1-��=������ �� ����������, -1=������ ������ � ����� � ��������-������������ �������� ��� �����)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_UNOM is '������ - ���������� ����� ���� � �� ���';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.CLOSE_OCCS_ID is 'cause - ������� ���������� �������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_NUMB_FOR_DOC is '�������� - ����� �������� ��� ���������� (�����������, ���� �������� ���� �� ������������� ������ ��������)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_YEAR is '������ - ��� ���������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_NAME_ID is '�������� - �� ������������ ��������� (KOD �� BTI04_KLS_85 = TP �� BTI_FKVA)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.IS_BTI_UPDATED is '�������, ��� ������ ��� �� ������� ������� ����������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.DATE_BTI_UPDATE is '����, ����� �������� ��������� ������ � �� ���';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.RM_ORDER_NUMB is '������� - ����� ������� � �������� (NPP �� BTI04_FKMN)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_STOREY is '�������� - ����';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.RM_STOREY is '������� - ����';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.IS_HOSTEL is '�������, ��� ������ �������� ����������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.HOSTEL_ID is '�� ��������� � ����������� ���������';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.IS_UNDWELLING is '�������, ��� ������ �������� ������� (�������)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_HAS_TSZH is '������ - �������, ��� � ���� ������� ��� - ������������ ������������� �����';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_UNAD is '������ - ���������� ����� ������ �� ���� (����� ���������� ��-� � �� ���)';
*/
