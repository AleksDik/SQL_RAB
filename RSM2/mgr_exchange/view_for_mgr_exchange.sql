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
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.ID is 'Идентификатор';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.OBJ_TYPE is 'Тип объекта(BLD-здание,APR-помещение=квартира,RM-комната,TNM-(tenement)многоквартирный дом, GRP-группа в договорах управления)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.NAME is 'Наименование объекта (храм Христа Спасителя, Театр оперы и балета, жилой дом, садовый участок, гараж и т.п.)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.OBJ_ID_PARENT is 'ид объекта, частью которого является данный объект';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_STREET is 'здание - Улица текстом';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_HOUSE_NUMB is 'здание - Номер дома';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_CORP_NUMB is 'здание - Номер корпуса';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_STROEN_NUMB is 'здание - Номер строения';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_SQUARE_LIVING is 'здание - Общая площадь жилых помещений';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_APART_COUNT is 'здание - Количество квартир';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_STOREY_COUNT is 'здание - Количество этажей';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.RM_NUMB is 'комната - Номер комнаты в квартире';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.RM_SQUARE is 'комната - Площадь комнаты';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.REG_NUMB is 'Номер объекта учета в реестре';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_NUMB is 'квартира - Номер квартиры';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_IND is 'квартира - Индекс квартиры';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_ROOM_COUNT is 'квартира - Количество комнат';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_SQUARE_LIVING is 'квартира - Жилая площадь';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.COMMENTS is 'комментарии';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_RIM is 'квартира - Признак римской цифры в номере помещения (0-арабская, 1-римская)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.RM_IND is 'комната - Индекс комнаты';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_UNKV is 'квартира - Уникальный номер квартиры в доме (часть составного ид-а в БД БТИ)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.RM_L is 'комната - Литера комнаты';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_SQUARE_ADJUSTED is 'квартира - Общая площадь (с летними) = Приведенная площадь (с учетом лоджий и балконов)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.CADASTRAL_NUMB is 'Кадастровый номер объекта';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.CONVENTIONAL_NUMB is 'Условный номер объекта в БД МКР';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.CONVENTIONAL_DATE is 'Дата получения (регистрации) Условного номера объекта в БД МКР';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_SQUARE_TOTAL is 'здание - Общая площадь';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_SQUARE_TOTAL is 'квартира - Общая площадь (без летних)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.CREATE_USER_ID is 'пользователь, создавший запись в БД';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.CREATE_DATE is 'дата создания записи в БД';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.MODIFY_USER_ID is 'пользователь, сделавший последнее изменение записи в БД';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.MODIFY_DATE is 'дата последнего изменения записи в БД';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.INVENTORY_FILE_ID is 'id файла описи в файловом архиве';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.INVENTORY_SIGN_FILE_ID is 'id файла подписи описи в файловом архиве';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.INVENTORY_CRTF_ID is 'id сертификата ЭЦП, подписавшего опись';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.CLOSE_DATE is 'дата закрытия объекта в РСЖС';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.IS_CLOSED is 'объект закрыт (0-нет, 1-да=объект не существует, -1=объект закрыт в связи с делением-объединением объектов для учета)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_UNOM is 'здание - Уникальный номер дома в БД БТИ';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.CLOSE_OCCS_ID is 'cause - причина ликвидации объекта';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_NUMB_FOR_DOC is 'квартира - Номер квартиры для документов (заполняется, если числовое поле не соответствует номеру квартиры)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_YEAR is 'здание - год постройки';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_NAME_ID is 'квартира - ид наименования помещения (KOD из BTI04_KLS_85 = TP из BTI_FKVA)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.IS_BTI_UPDATED is 'признак, что данные БТИ по данному объекту изменились';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.DATE_BTI_UPDATE is 'дата, когда выявлены изменения данных в БД БТИ';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.RM_ORDER_NUMB is 'комната - номер комнаты в квартире (NPP из BTI04_FKMN)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.APR_STOREY is 'квартира - этаж';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.RM_STOREY is 'комната - этаж';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.IS_HOSTEL is 'признак, что объект является общежитием';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.HOSTEL_ID is 'ид общежития в справочнике общежитий';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.IS_UNDWELLING is 'признак, что объект является нежилым (нежилье)';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_HAS_TSZH is 'здание - признак, что в доме имеется ТСЖ - товарищество собственников жилья';
comment on column mgr_exchange.SNPSH_MGR_RG_OBJECTS.BLD_UNAD is 'здание - Уникальный номер адреса по дому (часть составного ид-а в БД БТИ)';
*/
