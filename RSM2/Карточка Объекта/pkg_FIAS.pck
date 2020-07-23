CREATE OR REPLACE PACKAGE pkg_FIAS IS

  TYPE curstype IS REF CURSOR; -- тип ссылка на курсор 

  -- Автор  : Dik
  -- Дата создания :08.10.2019
  -- Описание : Получить адрес фиас по состовляющим кодам 
  procedure Get_FIAS_ADDDRES(p_search_param varchar2,
                             p_mode         number := 0,
                             p_data         in out curstype);

  -- Автор  : Dik
  -- Дата создания :08.11.2019
  -- Описание : Получить список объектов адреса фиас по коду пред. объекта 
  procedure Get_FIAS_FULL_ADDDRES(p_aoguid_1_region varchar2,
                                  p_aoguid_3_area   varchar2,
                                  p_aoguid_4_city   varchar2,
                                  p_aoguid_6_place  varchar2,
                                  p_aoguid_65_plan  varchar2,
                                  p_aoguid_7_street varchar2,
                                  p_data            in out curstype);
END pkg_FIAS;
/
CREATE OR REPLACE PACKAGE BODY pkg_FIAS IS

  -- Автор  : Dik
  -- Дата создания :08.10.2019
  -- Описание : Получить адрес фиас по состовляющим кодам 

  procedure Get_FIAS_FULL_ADDDRES(p_aoguid_1_region varchar2,
                                  p_aoguid_3_area   varchar2,
                                  p_aoguid_4_city   varchar2,
                                  p_aoguid_6_place  varchar2,
                                  p_aoguid_65_plan  varchar2,
                                  p_aoguid_7_street varchar2,
                                  p_data            in out curstype) as
  
  begin
    OPEN p_data FOR
      select fa.aoid,
             fa.aolevel,
             fa.aoguid,
             fa.aoguid_1_region,
             fa.aoguid_3_area,
             fa.aoguid_4_city,
             fa.aoguid_6_place,
             fa.aoguid_65_plan,
             fa.aoguid_7_street,
             fa.update_date,
             fa2.postalcode,
             fa.offname         as fias_full_addr,
             fa.aoid            as fias_record_id
        from u_fias_addrobj fa
        join fias_addrob77 fa2
          on fa2.aoid = fa.aoid
       where NVL(fa.aoguid_1_region, '#') = NVL(p_aoguid_1_region, '#')
         and NVL(fa.aoguid_3_area, '#') = NVL(p_aoguid_3_area, '#')
         and NVL(fa.aoguid_4_city, '#') = NVL(p_aoguid_4_city, '#')
         and NVL(fa.aoguid_6_place, '#') = NVL(p_aoguid_6_place, '#')
         and NVL(fa.aoguid_65_plan, '#') = NVL(p_aoguid_65_plan, '#')
         and NVL(fa.aoguid_7_street, '#') = NVL(p_aoguid_7_street, '#')
      
      ;
  end Get_FIAS_FULL_ADDDRES;

  -- Автор  : Dik
  -- Дата создания :08.11.2019
  -- Описание : Получить список объектов адреса фиас по коду пред. объекта 
  procedure Get_FIAS_ADDDRES(p_search_param varchar2,
                             p_mode         number := 0,
                             p_data         in out curstype) as
    v_search_param varchar2(500) := null;
    v_aoguid       u_fias_addrobj.aoguid%type := NULL;
    I              integer := 1;
    v_prev_level   integer;
    v_level        integer;
    c_level_l_region constant integer := 1; --регион РФ
    c_level_3_area   constant integer := 3; --Округ   
    c_level_4_city   constant integer := 4; --Город
    c_level_6_place  constant integer := 6; --н/п 
    c_level_65_plan  constant integer := 65; --Элемент планировочной структуры
    c_level_7_street constant integer := 7; --Улица
  begin
  
    case
      when p_mode = 0 then
        -- поиск адреса
        if (trim(p_search_param) is null) then
          return;
        end if;
        v_search_param := ' ' || lower(TRIM(p_search_param)) || ' ';
        v_search_param := replace(v_search_param, ' ', '%');
        v_search_param := replace(v_search_param, '%%', '%');
      
        OPEN p_data FOR
          select fa.aoid,
                 fa.aolevel,
                 fa.aoguid,
                 fa.aoguid_1_region,
                 fa.aoguid_3_area,
                 fa.aoguid_4_city,
                 fa.aoguid_6_place,
                 fa.aoguid_65_plan,
                 fa.aoguid_7_street,
                 fa.update_date,
                 fa2.postalcode,
                 fa.offname         as fias_full_addr,
                 fa.aoid            as fias_record_id
            from u_fias_addrobj fa, fias_addrob77 fa2
           where lower(fa.offname) like v_search_param
             and fa2.aoid = fa.aoid
           order by fa.offname;
        return;
        --регион  
      when p_mode = 1 then
        --список регионов 
      
        OPEN p_data FOR
          select fa.offname as fias_full_addr, fa.aoguid as fias_record_id
            from u_fias_addrobj fa
           where fa.aoguid = fa.aoguid_1_region;
        return;
      
      when p_mode = 3 then
        --регион заданный
        if (trim(p_search_param) is null) then
          return;
        end if;
        v_search_param := TRIM(p_search_param);
      
        OPEN p_data FOR
          select fa.offname as fias_full_addr, fa.aoguid as fias_record_id
            from u_fias_addrobj fa
           where fa.aoguid = fa.aoguid_1_region
             and fa.aoguid = v_search_param;
        return;
        --   из адреса (Округ, город, н.п., план.стр., улица)
      when p_mode in (2, 4, 6, 9, 14, 19) then
        if (trim(p_search_param) is null) then
          return;
        end if;
        v_search_param := TRIM(p_search_param);
        select case p_mode
                 when 2 then
                  fa.aoguid_1_region
                 when 4 then
                  fa.aoguid_3_area
                 when 6 then
                  fa.aoguid_4_city
                 when 9 then
                  fa.aoguid_6_place
                 when 14 then
                  fa.aoguid_65_plan
                 when 19 then
                  fa.aoguid_7_street
                 else
                  fa.aoguid_1_region
               end as aoguid,
               decode(p_mode,
                      2,
                      c_level_l_region,
                      4,
                      c_level_3_area,
                      6,
                      c_level_4_city,
                      9,
                      c_level_6_place,
                      14,
                      c_level_65_plan,
                      19,
                      c_level_7_street) as l
          into v_aoguid, v_level
          from u_fias_addrobj fa
         where fa.aoid = v_search_param;
      
        OPEN p_data FOR
          select Decode(NVL(trim(v.scname), '#'),
                        '#',
                        '',
                        trim(v.scname) || ' ') || fa2.offname as fias_full_addr,
                 fa2.aoguid as fias_record_id
            from fias_addrob77 fa2
            left join v_fias_socrbase_link v
              on v.shortname = fa2.shortname
             and v.aolevel = fa2.aolevel
             and rownum = 1
           where fa2.aoguid = v_aoguid
             and fa2.aolevel = v_level
             and fa2.actstatus = 1
             and fa2.livestatus = 1
             and fa2.nextid is null;
        return;
      when p_mode in (30) then
        -- почтовый индекс по коду адреса
        if (trim(p_search_param) is null) then
          return;
        end if;
        v_search_param := TRIM(p_search_param);
        if p_mode = 31 then
          select fa.aoid
            into v_search_param
            from u_fias_addrobj fa
           where fa.aoguid = v_search_param;
        end if;
        OPEN p_data FOR
          select fa2.postalcode as postalcode, fa2.aoid as fias_record_id
            from fias_addrob77 fa2
           where fa2.aoid = v_search_param;
        return;
        --Округ    
      when p_mode = 5 then
        --список Округов по региону
        if (trim(p_search_param) is null) then
          return;
        end if;
        v_search_param := TRIM(p_search_param);
        v_level        := c_level_3_area;
        v_prev_level   := c_level_l_region;
        -- Город   
      when p_mode in (7, 8) then
        if (trim(p_search_param) is null) then
          return;
        end if;
        v_search_param := TRIM(p_search_param);
        v_level        := c_level_4_city;
        select decode(p_mode, 7, c_level_3_area, 8, c_level_l_region)
          into v_prev_level
          from dual;
        --Населенный пункт  
      when p_mode in (10, 11, 12) then
        if (trim(p_search_param) is null) then
          return;
        end if;
        v_search_param := TRIM(p_search_param);
        v_level        := c_level_6_place;
        select decode(p_mode,
                      10,
                      c_level_4_city,
                      11,
                      c_level_3_area,
                      12,
                      c_level_l_region)
          into v_prev_level
          from dual;
        -- Элемент планировочной структуры
      when p_mode in (15, 16, 17, 18) then
        if (trim(p_search_param) is null) then
          return;
        end if;
        v_search_param := TRIM(p_search_param);
        v_level        := c_level_65_plan;
        select decode(p_mode,
                      15,
                      c_level_6_place,
                      16,
                      c_level_4_city,
                      17,
                      c_level_3_area,
                      18,
                      c_level_l_region)
          into v_prev_level
          from dual;
        ---улица   
      else
        v_level := 7;
        if (trim(p_search_param) is null) then
          return;
        end if;
        v_search_param := TRIM(p_search_param);
        case p_mode
          when 20 then
            v_prev_level := c_level_65_plan;
          when 21 then
            v_prev_level := c_level_6_place;
          when 22 then
            v_prev_level := c_level_4_city;
          when 23 then
            v_prev_level := c_level_3_area;
          when 24 then
            v_prev_level := c_level_l_region;
          else
            return;
        end case;
    end case;
  
    OPEN p_data FOR
      select --Decode(NVL(trim(v.scname),'#'),'#','',trim(v.scname)||' ')||
       fa.offname as fias_full_addr, fa.aoguid as fias_record_id
        from fias_addrob77 fa2, fias_addrob77 fa
        left join v_fias_socrbase_link v
          on v.shortname = fa.shortname
         and v.aolevel = fa.aolevel
         and rownum = 1
       where fa2.aoguid = v_search_param
         and fa2.aolevel = v_prev_level
         and fa2.actstatus = 1
         and fa2.livestatus = 1
         and fa2.nextid is null
         and fa.parentguid = fa2.aoguid
         and fa.aolevel = v_level
         and fa.actstatus = 1
         and fa.livestatus = 1
         and fa.nextid is null
       order by fa.offname;
  
  end Get_FIAS_ADDDRES;

END pkg_FIAS;
/
