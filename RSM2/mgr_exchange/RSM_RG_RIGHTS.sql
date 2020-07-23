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
comment on column RSM_RG_RIGHTS.ID is 'Идентификатор';
comment on column RSM_RG_RIGHTS.RGHTBRD_TYPE is 'Тип: право (RGHT); обременение (BRD)';
comment on column RSM_RG_RIGHTS.BRD_CONDITION is 'обрем. - условия обременения';
comment on column RSM_RG_RIGHTS.REG_NUMB is 'Регистрационный номер в Реестре СЖС';
comment on column RSM_RG_RIGHTS.DATE_FROM is 'Дата, с которой действует право/обременение (заполняется при подписании операции открытия)';
comment on column RSM_RG_RIGHTS.DATE_TO is 'Дата, по которую действовало право/обременение (заполняется при подписании операции закрытия)';
comment on column RSM_RG_RIGHTS.SHARE_NUMERATOR is 'доля собственности в объекте - числитель';
comment on column RSM_RG_RIGHTS.SHARE_DENOMINATOR is 'доля собственности в объекте - знаменатель';
comment on column RSM_RG_RIGHTS.RGHTBRD_ID is 'Ид права, на которое накладывается обременение';
comment on column RSM_RG_RIGHTS.SBJ_ID_RIGHT is 'Ид субъекта: право - чье право, обременение - на кого обременение)';
comment on column RSM_RG_RIGHTS.OBJ_ID is 'Ид объекта права';
comment on column RSM_RG_RIGHTS.COMMENTS is 'комментарии';
comment on column RSM_RG_RIGHTS.STATE_NUMB is 'Номер государственной регистрации (в ЕГРП)';
comment on column RSM_RG_RIGHTS.STATE_DATE_FROM is 'Дата государственной регистрации открытия права/обременения (в ЕГРП)';
comment on column RSM_RG_RIGHTS.STATE_DATE_TO is 'Дата государственной регистрации закрытия права/обременения (в ЕГРП)';
comment on column RSM_RG_RIGHTS.CREATE_USER_ID is 'пользователь, создавший запись в БД';
comment on column RSM_RG_RIGHTS.CREATE_DATE is 'дата создания записи в БД';
comment on column RSM_RG_RIGHTS.MODIFY_USER_ID is 'пользователь, последним измененивший запись в БД';
comment on column RSM_RG_RIGHTS.MODIFY_DATE is 'дата последнего изменения записи в БД';
comment on column RSM_RG_RIGHTS.SBJ_ID_BURDEN is 'Ид субъекта, в чью пользу накладывается обременение';
comment on column RSM_RG_RIGHTS.REGOBJ_ID is '(NEW)ид Учетного Объекта/объекта права';
comment on column RSM_RG_RIGHTS.RGBRTP_ID is 'Ид вида права/обременения';
comment on column RSM_RG_RIGHTS.BRD_CURR_ID is 'обрем. - ссылка на валюту, в которой выражена сумма обременения';
comment on column RSM_RG_RIGHTS.BRD_AMOUNT is 'обрем. - сумма обременения';
comment on column RSM_RG_RIGHTS.BRD_PERIOD_TEXT is 'обрем. - срок - текстовое описание';
comment on column RSM_RG_RIGHTS.BRD_PERIOD_DATE_FROM is 'обрем. - срок - с';
comment on column RSM_RG_RIGHTS.BRD_PERIOD_DATE_TO is 'обрем. - срок - по';
comment on column RSM_RG_RIGHTS.BRD_SPACE is 'обрем. - обременяемая площадь';
comment on column RSM_RG_RIGHTS.IS_SIGNED is 'признак, что запись о праве/обременении должна(нет) подписываться';
comment on column RSM_RG_RIGHTS.IS_EGRP is 'признак, что право/обременение зарегистрировано в ЕГРП';
comment on column RSM_RG_RIGHTS.ISSUE_NUMB is 'договор управления - Номер документа о праве/обременении';
comment on column RSM_RG_RIGHTS.ISSUE_DATE is 'договор управления - Дата подписания документа о праве/обременении';
