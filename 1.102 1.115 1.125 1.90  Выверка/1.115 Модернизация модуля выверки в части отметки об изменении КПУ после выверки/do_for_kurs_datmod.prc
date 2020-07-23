CREATE OR REPLACE PROCEDURE kursiv.do_for_kurs_datmod (form_class_name IN     VARCHAR2
                                                      ,form_name       IN     VARCHAR2
                                                      ,form_handle     IN     NUMBER
                                                      ,form_event      IN     VARCHAR2
                                                      ,out_props       IN     VARCHAR2
                                                      ,qcommand        IN OUT pckg_tree.curstype
                                                      ) IS
  --
  --  31.03.2003  Cooller    Добавлено создание меню Шаблоны с подменю вызова шаблонов
  --  27.11.2007  AVL        Добавил формирование ф112-р
  --  06.11.2008  AVL        Добавил генерацию нового п. меню "ПФ", в нём п. меню "Список ПФ"
  --                         для вызова списка связанных экспликаций за два года.
  --                         Автозапуск этого списка при старте АРМа под SUPER, PLAN, ORDER
  --  20.07.2009  AVL        По письму УИТ-625/2009 переименовал п. меню "ПФ" в "Система оповещения"
  --                         Внёс доработки по вызову списка Адреса МО
  --  02.11.2009  BlackHawk  Убрал пункт меню "Договор аренды" (УИТ-1063/2009)
  --  23.04.2010  AVL        По письму УИТ-61/2010 доработал вывод 64 списка
  --  10.03.2011  BlackHawk  Добавил пункт меню miOrdersKpiList и его обработку
  --  29.03.2011  BlackHawk  Добавил пункт меню miOrdersKpiList для SUPER-а
  --  07.04.2011  BlackHawk  Список Уведомлений работает для PLAN-ов и 71-ой привилегии
  --  16.08.2011  BlackHawk  Добавил пункт меню miSubsidList и его обработку
  --  25.11.2011  BlackHawk  Добавил пункты меню для отчетов по Выверке
  --  17.12.2011  BlackHawk  Добавил пункт меню по ЛК для УР (по 99 привилегии)
  --   #D11032013 Дикан      Меню отчетов по ТП    
  --ilonis 29.08.2013 меню техпаспорт и просмотр тп
  --  28.11.2013 Dik          Добавил пункты меню ('MIVYVREPRESULTVC', 'MIVYVREPUSERSVC')  для вызова отчетов :
  --                         "По результатам  выверки с учетом изменений ДЖП"; "По операторам выверки с учетом изменений ДЖП"
  --

  o_id     NUMBER;
  a        VARCHAR2 (2000);
  b        VARCHAR2 (2000);
  c        VARCHAR2 (2000);
  n        NUMBER;
  cnt_w    NUMBER;
  sys_priv NUMBER := kurs3_var.sys_prv;
BEGIN  

  IF form_event = 'FormCreate' THEN
     
    OPEN qcommand FOR
        SELECT *
          FROM ( /*                SELECT 1 AS cmd_id,
                   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miReport;Caption=Отчеты;'
                   || 'ItemsAdd=N4;Visible=0;Enabled=0;MenuIndex=5;' AS cmd_lines
              FROM DUAL
             UNION
             */
                SELECT 2 AS cmd_id
                      ,'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miF116;CopyAction=MenuCommandAction;'
                       || 'Caption=Ф-116;ItemsAdd=N4;Visible=0;Enabled=0;MenuIndex=5;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                /*
           SELECT 3 AS cmd_id,
                  'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miStatPlanKPU;'
                  || 'CopyAction=MenuCommandAction;Caption=Отчеты по План-КПУ;ItemsAdd=miReport;'
                  || 'Visible=0;Enabled=0;MenuIndex=2;' AS cmd_lines
             FROM DUAL
           UNION
*/
                SELECT 4 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miPlanKPUPrior;'
                       || 'CopyAction=MenuCommandAction;Caption=Отчеты по ПЛАН_КПУ;ItemsAdd=N4;'
                       || 'Visible=0;Enabled=0;MenuIndex=6;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 25 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miCategory;'
                       || 'CopyAction=MenuCommandAction;Caption=Список льготников;ItemsAdd=n1;MenuIndex=3;'
                       || 'Visible=0;Enabled=0;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 5 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTestBTI;'
                       || 'Caption=БТИ;ItemsAdd=MainMenu1;'
                       || 'Visible=1;Enabled=1;MenuIndex=6;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTestRigthGrid;'
                       || 'CopyAction=MenuCommandAction;Caption=Данные БТИ;ItemsAdd=miTestBTI;'
                       || 'Visible=1;Enabled=1;'
                  FROM DUAL
                UNION ALL
                SELECT 5.1 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTestBTILIST;'
                       || 'CopyAction=MenuCommandAction;Caption=Список БТИ;ItemsAdd=miTestBTI;'
                       || 'Visible=1;Enabled=1;'
                         AS cmd_lines
                  FROM DUAL
                 WHERE (kurs3_var.number_version > 779)
                       OR (kurs3_var.number_version = 779
                           AND SUBSTR (kurs3_var.global_version, INSTR (kurs3_var.global_version, '.', 1, 2) + 1, 1) >= 4)
                -- AVL 26.11.2007 нач
                UNION ALL
                SELECT 5.2 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=mi_F112;'
                       || 'CopyAction=MenuCommandAction;Caption=Экспликация Ф-4;ItemsAdd=miTestBTI;'
                       || 'Visible=1;Enabled=1;'
                  FROM DUAL
                 WHERE (kurs3_var.number_version > 779)
                       OR (kurs3_var.number_version = 779
                           AND SUBSTR (kurs3_var.global_version, INSTR (kurs3_var.global_version, '.', 1, 2) + 1, 1) >= 4)
                -- AVL 26.11.2007 кон
                UNION ALL
                SELECT 5.05 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miLK;'
                       || 'Caption=Лимитная карта;ItemsAdd=MainMenu1;'
                       || 'Visible=0;Enabled=0;MenuIndex=7;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TMenuItem;Owner=Self;Name=mi_rep_lk;'
                       || 'CopyAction=MenuCommandAction;Caption=Отчеты по ЛК;ItemsAdd=miLK;'
                       || 'Visible=0;Enabled=0;' --                                            ||'Reset;'
                                                 --                        || 'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miF1AOP;'
                                                 --                        || 'CopyAction=MenuCommandAction;Caption=Форма Ф1-АОп;ItemsAdd=miLK;'
                                                 --                        || 'Visible=0;Enabled=0;'
                                                 --                                            ||'Reset;'
                                                 --                        || 'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miF1MOSP;'
                                                 --                        || 'CopyAction=MenuCommandAction;Caption=Форма Ф1-МОСп;ItemsAdd=miLK;'
                                                 --                        || 'Visible=0;Enabled=0;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miF2AOP;'
                       || 'CopyAction=MenuCommandAction;Caption=Форма Ф2-АОп;ItemsAdd=miLK;'
                       || 'Visible=0;Enabled=0;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TMenuItem;Owner=Self;Name=mi_LK_ur;'
                       || 'CopyAction=MenuCommandAction;Caption=ЛК для УР;ItemsAdd=miLK;'
                       || 'Visible=0;Enabled=0;'
                  FROM DUAL
                -- AVL 06.11.2008 нач
                UNION ALL
                SELECT 5.15 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=milinks;'
                       || 'Caption=Система оповещения;ItemsAdd=MainMenu1;'
                       || 'Visible=0;Enabled=0;MenuIndex=9;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TMenuItem;Owner=Self;Name=mi_link1;'
                       || 'CopyAction=MenuCommandAction;Caption=Список ПФ;ItemsAdd=milinks;'
                       || 'Visible=0;Enabled=0;'
                       || 'Reset;'
                       || 'CreateObject;ClassName=TMenuItem;Owner=Self;Name=mi_mosobl1;'
                       || 'CopyAction=MenuCommandAction;Caption=Список адресов МО;ItemsAdd=milinks;'
                       || 'Visible=0;Enabled=0;'
                  FROM DUAL
                -- AVL 06.11.2008 кон
                -------------  Агенство Учетных данных
                UNION ALL
                SELECT 23 AS cmd_id
                      ,'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miARS;'
                       || 'CopyAction=MenuCommandAction;Caption=Агентство: учетные данные;ItemsAdd=n1;MenuIndex=3;'
                         AS cmd_lines
                  FROM DUAL
                 WHERE (kurs3_var.number_version = 780)
                --         and get_user_priv(63)>0
                UNION ALL
                /*SELECT 23 AS cmd_id
                    , 'Object;Name=N2;Enable='||decode(kurs3_var.Get_User_Id_F,789,0,1)||';'
                    || 'reset;Object;Name=N5;Enable='||decode(kurs3_var.Get_User_Id_F,789,0,1)||';' AS cmd_lines
                FROM DUAL
         UNION ALL*/
                -------------  Справка в ордерах
                SELECT 23 AS cmd_id
                      ,'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miC6;'
                       || 'CopyAction=MenuCommandAction;Caption=Предложения о снятии: экспорт в Excel;ItemsAdd=n3;MenuIndex=3;'
                         AS cmd_lines
                  FROM DUAL
                --               WHERE (KURS3_VAR.NUMBER_VERSION >= 780)
                --          kurs3.get_user_priv(4)>0
                UNION ALL
                ---------------
                SELECT 6 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTmpl;'
                       || 'Caption=Шаблоны;ItemsAdd=MainMenu1;'
                       || 'Visible=1;Enabled=1;MenuIndex=5;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 7 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTmplSub1;'
                       || 'Caption=Улучшение условий;ItemsAdd=miTmpl;'
                       || 'Visible=1;Enabled=1;MenuIndex=1;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 8 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTmplSub2;'
                       || 'Caption=Переселение;ItemsAdd=miTmpl;'
                       || 'Visible=1;Enabled=1;MenuIndex=2;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 9 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTmplSub3;'
                       || 'Caption=Субсидии;ItemsAdd=miTmpl;'
                       || 'Visible=1;Enabled=1;MenuIndex=3;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 10 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTmplImp01;'
                       || 'CopyAction=MenuCommandAction;Caption=Повторное заселение;ItemsAdd=miTmplSub1;'
                       || 'Visible=1;Enabled=1;MenuIndex=1;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 11 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTmplImp02;'
                       || 'CopyAction=MenuCommandAction;Caption=Постановка на учет;ItemsAdd=miTmplSub1;'
                       || 'Visible=1;Enabled=1;MenuIndex=2;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 12 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTmplImp03;'
                       || 'CopyAction=MenuCommandAction;Caption=О разрешении выкупа;ItemsAdd=miTmplSub1;'
                       || 'Visible=1;Enabled=1;MenuIndex=3;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 13 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTmplImp04;'
                       || 'CopyAction=MenuCommandAction;Caption=Исключение из служебных;ItemsAdd=miTmplSub1;'
                       || 'Visible=1;Enabled=1;MenuIndex=4;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 14 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTmplImp05;'
                       || 'CopyAction=MenuCommandAction;Caption=О предоставлении ж/п;ItemsAdd=miTmplSub1;'
                       || 'Visible=1;Enabled=1;MenuIndex=5;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 15 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTmplImp06;'
                       || 'CopyAction=MenuCommandAction;Caption=Отказ в постановке;ItemsAdd=miTmplSub1;'
                       || 'Visible=1;Enabled=1;MenuIndex=6;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 16 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTmplImp07;'
                       || 'CopyAction=MenuCommandAction;Caption=Ликвидация общежития;ItemsAdd=miTmplSub1;'
                       || 'Visible=1;Enabled=1;MenuIndex=7;'
                         AS cmd_lines
                  FROM DUAL
                --                UNION ALL
                --                SELECT 17 AS cmd_id
                --                      ,    'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTmplImp08;'
                --                        || 'CopyAction=MenuCommandAction;Caption=Договор аренды;ItemsAdd=miTmplSub1;'
                --                        || 'Visible=1;Enabled=1;MenuIndex=8;' AS cmd_lines
                --                  FROM DUAL
                UNION ALL
                SELECT 18 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTmplImp09;'
                       || 'CopyAction=MenuCommandAction;Caption=Ликвидация статуса общежития;ItemsAdd=miTmplSub1;'
                       || 'Visible=1;Enabled=1;MenuIndex=9;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 19 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTmplImp10;'
                       || 'CopyAction=MenuCommandAction;Caption=Освобождение дома по договору;ItemsAdd=miTmplSub2;'
                       || 'Visible=1;Enabled=1;MenuIndex=1;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 20 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTmplImp11;'
                       || 'CopyAction=MenuCommandAction;Caption=Освобождение дома;ItemsAdd=miTmplSub2;'
                       || 'Visible=1;Enabled=1;MenuIndex=2;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 21 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTmplImp12;'
                       || 'CopyAction=MenuCommandAction;Caption=Принятие на учет;ItemsAdd=miTmplSub3;'
                       || 'Visible=1;Enabled=1;MenuIndex=1;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 22 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTmplImp13;'
                       || 'CopyAction=MenuCommandAction;Caption=Предоставление;ItemsAdd=miTmplSub3;'
                       || 'Visible=1;Enabled=1;MenuIndex=2;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 23 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miAdviceList;'
                       || 'CopyAction=MenuCommandAction;Caption=Список Уведомлений;ItemsAdd=N2;'
                       || 'Visible=0;Enabled=0;'
                         AS cmd_lines
                  FROM DUAL
                 WHERE ( (kurs3_var.number_version > 779)
                        OR (kurs3_var.number_version = 779
                            AND SUBSTR (kurs3_var.global_version, INSTR (kurs3_var.global_version, '.', 1, 2) + 1, 1) >= 4))
                UNION ALL
                SELECT 24 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miOrdersKpiList;'
                       || 'CopyAction=MenuCommandAction;Caption=Данные по КПИ;ItemsAdd=N3;'
                       || 'Visible=0;Enabled=0;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 25 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSubsidList;'
                       || 'CopyAction=MenuCommandAction;Caption=Список субсидийных дел;ItemsAdd=N1;'
                       || 'Visible=0;Enabled=0;MenuIndex=3;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 26 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miVyvRepUsers;ItemsAdd=N5;'
                       || 'CopyAction=MenuCommandAction;Caption=Отчет по операторам выверки;'
                       || 'Enabled=0;Visible=0;MenuIndex=1;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 27 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miVyvRepResult;ItemsAdd=N5;'
                       || 'CopyAction=MenuCommandAction;Caption=Отчет по результатам выверки;'
                       || 'Enabled=0;Visible=0;MenuIndex=2;'
                         AS cmd_lines
                  FROM DUAL
-- #D20.11.2013             
           UNION ALL
                SELECT 27.1 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miVyvRepUsersVC;ItemsAdd=N5;'
                       || 'CopyAction=MenuCommandAction;Caption=Отчет по операторам выверки с учетом изменений ДЖП;'
                       || 'Enabled=0;Visible=0;MenuIndex=3;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 27.2 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miVyvRepResultVC;ItemsAdd=N5;'
                       || 'CopyAction=MenuCommandAction;Caption=Отчет по результатам выверки с учетом изменений ДЖП;'
                       || 'Enabled=0;Visible=0;MenuIndex=4;'
                         AS cmd_lines
                  FROM DUAL
--/ #D20.11.2013                    
                  
-- #D11032013                   
   /*               UNION ALL
                SELECT 28 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTPReports;'
                       ||--'CopyAction=MenuCommandAction;
                       'Caption=Отчеты по техническим паспортам;ItemsAdd=N2;'
                       || 'Visible=0;Enabled=0;'
                       AS cmd_lines
                  FROM DUAL
               UNION ALL
                SELECT 29 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTPReport1;'
                       || 'CopyAction=MenuCommandAction;Caption=Предоставление ж/п;ItemsAdd=miTPReports;'
                       || 'Visible=1;Enabled=1;Tag=1;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 30 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTPReport2;'
                       || 'CopyAction=MenuCommandAction;Caption=Выдача жителям ТП;ItemsAdd=miTPReports;'
                       || 'Visible=1;Enabled=1;Tag=2;'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 31 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miTPReport3;'
                       || 'CopyAction=MenuCommandAction;Caption=Количество ТП в округах;ItemsAdd=miTPReports;'
                       || 'Visible=1;Enabled=1;Tag=3;'
                         AS cmd_lines
                  FROM DUAL
      */            
  -- /#D11032013                 
                  )
         WHERE UPPER (kurs3_var.product_name) = 'KURS3'
      ORDER BY cmd_id;
  ELSIF form_event = 'USER_LOGIN' THEN
    OPEN qcommand FOR
        SELECT *
          FROM (SELECT 1 AS cmd_id, 'Object;Name=miReport;Visible=0;Enabled=0;' AS cmd_lines       FROM DUAL     WHERE NVL (sys_priv, 0) = 0 AND NVL (kurs3_var.plan_priv, 0) = 0
                UNION ALL
                SELECT 2 AS cmd_id, 'Object;Name=miF116;Visible=0;Enabled=0;' AS cmd_lines               FROM DUAL       WHERE NVL (sys_priv, 0) = 0 AND NVL (kurs3_var.plan_priv, 0) = 0
                UNION ALL
                SELECT 3 AS cmd_id, 'Object;Name=miPlanKPUPrior;Visible=0;Enabled=0;' AS cmd_lines       FROM DUAL    WHERE NVL (sys_priv, 0) = 0 AND NVL (kurs3_var.plan_priv, 0) = 0 AND kurs3_var.global_factory IS NULL
                UNION ALL
                SELECT 4 AS cmd_id, 'Object;Name=miReport;Visible=1;Enabled=1;' AS cmd_lines
                  FROM DUAL
                 WHERE NVL (sys_priv, 0) = 1 OR NVL (kurs3_var.plan_priv, 0) = 1
                UNION ALL
                SELECT 5 AS cmd_id, 'Object;Name=miF116;Visible=1;Enabled=1;' AS cmd_lines
                  FROM DUAL
                 WHERE NVL (sys_priv, 0) = 1 OR NVL (kurs3_var.plan_priv, 0) = 1
                UNION ALL
                SELECT 5.05 AS cmd_id
                      ,   'Object;Name=miLK;Visible='
                       || DECODE (pr, '00', '0', '1')
                       || ';Enabled='
                       || DECODE (pr, '00', '0', '1')
                       || ';'
                       || 'Reset;Object;Name=miF2AOP;Visible='
                       || DECODE (pr, '00', '0', '1')
                       || ';Enabled='
                       || DECODE (pr, '00', '0', '1')
                       || ';'
                       || 'Reset;Object;Name=mi_rep_lk;Visible='
                       || DECODE (pr, '00', '0', '1')
                       || ';Enabled='
                       || DECODE (pr, '00', '0', '1')
                       || ';'
                       || 'Reset;Object;Name=milinks;Visible=' -- AVL 06.11.2008
                       || DECODE (LOWER (kurs3_var.global_user_name),  'plan', '1',  'super', '1',  'order', '1',  '0')
                       || ';Enabled='
                       || DECODE (LOWER (kurs3_var.global_user_name),  'plan', '1',  'super', '1',  'order', '1',  '0')
                       || ';'
                       || 'Reset;Object;Name=mi_link1;Visible=' -- AVL 06.11.2008
                       || DECODE (LOWER (kurs3_var.global_user_name),  'plan', '1',  'super', '1',  'order', '1',  '0')
                       || ';Enabled='
                       || DECODE (LOWER (kurs3_var.global_user_name),  'plan', '1',  'super', '1',  'order', '1',  '0')
                       || ';'
                       || 'Reset;Object;Name=mi_mosobl1;Visible=' -- AVL 20.07.2009
                       || DECODE (LOWER (kurs3_var.global_user_name),  'plan', '1',  'super', '1',  'order', '1',  '0')
                       || ';Enabled='
                       || DECODE (LOWER (kurs3_var.global_user_name),  'plan', '1',  'super', '1',  'order', '1',  '0')
                       || ';'
                       --                         || 'Reset;'
                       --                         || 'Object;Name=miFLK;Visible=1;Enabled=1;'
                       --                         || 'Reset;'
                       --                         || 'Object;Name=miF1AOP;Visible=1;Enabled=1;'
                       --                         || 'Reset;'
                       --                         || 'Object;Name=miF1MOSP;Visible=1;Enabled=1;'
                       || 'Reset;'
                       || 'Object;Name=mi_LK_ur;Visible='
                       || lk_ur_priv
                       || ';Enabled='
                       || lk_ur_priv
                       || ';'
                  FROM (SELECT NVL (sys_priv, 0) || NVL (kurs3_var.plan_priv, 0) AS pr, NVL (get_user_priv (99), 0) AS lk_ur_priv FROM DUAL)
                UNION ALL
                SELECT 6 AS cmd_id, 'Object;Name=miPlanKPUPrior;Visible=1;Enabled=1;' AS cmd_lines
                  FROM DUAL
                 WHERE NVL (sys_priv, 0) = 1 OR NVL (kurs3_var.plan_priv, 0) = 1 OR kurs3_var.global_factory IS NOT NULL
                UNION ALL
                SELECT 7 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miReportsUMG;'
                       || 'Caption=Отчеты УДЖ;ItemsAdd=MainMenu1;'
                       || 'Visible=1;Enabled=1;MenuIndex=5;'
                         AS cmd_lines
                  FROM active_menus, active_sessions
                 WHERE     active_menus.session_id(+) = active_sessions.session_id
                       AND active_sessions.session_id = USERENV ('SESSIONID')
                       AND 0 = (SELECT COUNT (active_menus.menu_handle)
                                  FROM active_menus
                                 WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_text = 'miReportsUMG')
                       AND get_user_priv (54) = 1
                       AND ROWNUM = 1
                UNION ALL
                SELECT 8 AS cmd_id, 'Object;Name=miReportsUMG;Visible=0;Enabled=0;Reset;Object;Name=miSourcesAparts;Visible=0;Enabled=0;' AS cmd_lines
                  FROM DUAL
                 WHERE get_user_priv (54) = 0
                       OR NOT EXISTS
                            (SELECT 1
                               FROM active_props
                              WHERE session_id = USERENV ('SESSIONID') AND prop_name = 'REP.BPL' AND TO_NUMBER (SUBSTR (prop_value, 7)) >= 6) --позднее версии '1.0.0.6'
                UNION ALL
                SELECT 9 AS cmd_id
                      , --22.07.2002 Begin
                       'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSummaryRep1;'
                       || DECODE (SIGN (kurs3_var.number_version - 775), 1, 'CopyAction=MenuCommandAction;', '')
                       || 'Caption=Отчеты УДЖ;ItemsAdd=MainMenu1;'
                       || 'Visible=1;Enabled=1;MenuIndex=6;'
                         AS cmd_lines
                  FROM active_menus, active_sessions
                 WHERE     active_menus.session_id(+) = active_sessions.session_id
                       AND active_sessions.session_id = USERENV ('SESSIONID')
                       AND 0 = (SELECT COUNT (active_menus.menu_handle)
                                  FROM active_menus
                                 WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_text = 'miSummaryRep1')
                       AND get_user_priv (55) = 1
                       AND ROWNUM = 1
                UNION ALL
                SELECT 10 AS cmd_id, 'Object;Name=miSummaryRep1;Visible=0;Enabled=0;' AS cmd_lines
                  FROM DUAL
                 WHERE get_user_priv (55) = 0
                       OR NOT EXISTS
                            (SELECT 1
                               FROM active_props
                              WHERE session_id = USERENV ('SESSIONID') AND prop_name = 'REP.BPL' AND TO_NUMBER (SUBSTR (prop_value, 7)) >= 6) --позднее версии '1.0.0.6'
                UNION ALL
                SELECT * -- для < 776 версий :
                  FROM (SELECT 11 AS cmd_id
                              , --22.07.2002 End
                               'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSummaryReports;'
                               || 'CopyAction=MenuCommandAction;Caption=Форма 1.П;ItemsAdd=miSummaryRep1;'
                               || 'Visible=1;Enabled=1;'
                                 AS cmd_lines
                          FROM active_menus, active_sessions
                         WHERE     active_menus.session_id(+) = active_sessions.session_id
                               AND active_sessions.session_id = USERENV ('SESSIONID')
                               AND 0 = (SELECT COUNT (active_menus.menu_handle)
                                          FROM active_menus
                                         WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_text = 'miSummaryReports')
                               AND get_user_priv (55) = 1
                               AND ROWNUM = 1
                        UNION ALL
                        SELECT 12 AS cmd_id
                              , --22.07.2002 End
                               'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSummaryReports_1;'
                               || 'CopyAction=MenuCommandAction;Caption=Форма 1.1.П;ItemsAdd=miSummaryRep1;'
                               || 'Visible=1;Enabled=1;'
                                 AS cmd_lines
                          FROM active_menus, active_sessions
                         WHERE     active_menus.session_id(+) = active_sessions.session_id
                               AND active_sessions.session_id = USERENV ('SESSIONID')
                               AND 0 = (SELECT COUNT (active_menus.menu_handle)
                                          FROM active_menus
                                         WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_text = 'miSummaryReports_1')
                               AND get_user_priv (55) = 1
                               AND ROWNUM = 1
                        UNION ALL
                        SELECT 13 AS cmd_id
                              , --22.07.2002 End
                               'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSummaryReports_2;'
                               || 'CopyAction=MenuCommandAction;Caption=Форма 1.2.П;ItemsAdd=miSummaryRep1;'
                               || 'Visible=1;Enabled=1;'
                                 AS cmd_lines
                          FROM active_menus, active_sessions
                         WHERE     active_menus.session_id(+) = active_sessions.session_id
                               AND active_sessions.session_id = USERENV ('SESSIONID')
                               AND 0 = (SELECT COUNT (active_menus.menu_handle)
                                          FROM active_menus
                                         WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_text = 'miSummaryReports_2')
                               AND get_user_priv (55) = 1
                               AND ROWNUM = 1
                        UNION ALL
                        SELECT 14 AS cmd_id
                              , --22.07.2002 End
                               'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSummaryReports_3;'
                               || 'CopyAction=MenuCommandAction;Caption=Форма 2.П;ItemsAdd=miSummaryRep1;'
                               || 'Visible=1;Enabled=1;'
                                 AS cmd_lines
                          FROM active_menus, active_sessions
                         WHERE     active_menus.session_id(+) = active_sessions.session_id
                               AND active_sessions.session_id = USERENV ('SESSIONID')
                               AND 0 = (SELECT COUNT (active_menus.menu_handle)
                                          FROM active_menus
                                         WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_text = 'miSummaryReports_3')
                               AND get_user_priv (55) = 1
                               AND ROWNUM = 1
                        UNION ALL
                        SELECT 15 AS cmd_id
                              , --22.07.2002 End
                               'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSummaryReports_4;'
                               || 'CopyAction=MenuCommandAction;Caption=Форма 2.1.П;ItemsAdd=miSummaryRep1;'
                               || 'Visible=1;Enabled=1;'
                                 AS cmd_lines
                          FROM active_menus, active_sessions
                         WHERE     active_menus.session_id(+) = active_sessions.session_id
                               AND active_sessions.session_id = USERENV ('SESSIONID')
                               AND 0 = (SELECT COUNT (active_menus.menu_handle)
                                          FROM active_menus
                                         WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_text = 'miSummaryReports_4')
                               AND get_user_priv (55) = 1
                               AND ROWNUM = 1
                        UNION ALL
                        SELECT 16 AS cmd_id
                              , --22.07.2002 End
                               'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSummaryReports_5;'
                               || 'CopyAction=MenuCommandAction;Caption=Форма 2.2.П;ItemsAdd=miSummaryRep1;'
                               || 'Visible=1;Enabled=1;'
                                 AS cmd_lines
                          FROM active_menus, active_sessions
                         WHERE     active_menus.session_id(+) = active_sessions.session_id
                               AND active_sessions.session_id = USERENV ('SESSIONID')
                               AND 0 = (SELECT COUNT (active_menus.menu_handle)
                                          FROM active_menus
                                         WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_text = 'miSummaryReports_5')
                               AND get_user_priv (55) = 1
                               AND ROWNUM = 1
                        UNION ALL
                        SELECT 17 AS cmd_id
                              , --22.07.2002 End
                               'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSummaryReports_6;'
                               || 'CopyAction=MenuCommandAction;Caption=Форма 2.3.П;ItemsAdd=miSummaryRep1;'
                               || 'Visible=1;Enabled=1;'
                                 AS cmd_lines
                          FROM active_menus, active_sessions
                         WHERE     active_menus.session_id(+) = active_sessions.session_id
                               AND active_sessions.session_id = USERENV ('SESSIONID')
                               AND 0 = (SELECT COUNT (active_menus.menu_handle)
                                          FROM active_menus
                                         WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_text = 'miSummaryReports_6')
                               AND get_user_priv (55) = 1
                               AND ROWNUM = 1
                        UNION ALL
                        SELECT 18 AS cmd_id
                              , --22.07.2002 End
                               'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSummaryReports_7;'
                               || 'CopyAction=MenuCommandAction;Caption=Форма 2.4.П;ItemsAdd=miSummaryRep1;'
                               || 'Visible=1;Enabled=1;'
                                 AS cmd_lines
                          FROM active_menus, active_sessions
                         WHERE     active_menus.session_id(+) = active_sessions.session_id
                               AND active_sessions.session_id = USERENV ('SESSIONID')
                               AND 0 = (SELECT COUNT (active_menus.menu_handle)
                                          FROM active_menus
                                         WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_text = 'miSummaryReports_7')
                               AND get_user_priv (55) = 1
                               AND ROWNUM = 1
                        UNION ALL
                        SELECT 19 AS cmd_id
                              , --22.07.2002 End
                               'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSummaryReports_9;'
                               || 'CopyAction=MenuCommandAction;Caption=Форма 2.1.1.П;ItemsAdd=miSummaryRep1;'
                               || 'Visible=1;Enabled=1;'
                                 AS cmd_lines
                          FROM active_menus, active_sessions
                         WHERE     active_menus.session_id(+) = active_sessions.session_id
                               AND active_sessions.session_id = USERENV ('SESSIONID')
                               AND 0 = (SELECT COUNT (active_menus.menu_handle)
                                          FROM active_menus
                                         WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_text = 'miSummaryReports_9')
                               AND get_user_priv (55) = 1
                               AND ROWNUM = 1
                        UNION ALL
                        SELECT 20 AS cmd_id
                              , --22.07.2002 End
                               'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miSummaryReports_8;'
                               || 'CopyAction=MenuCommandAction;Caption=Форма 2.3.1.П;ItemsAdd=miSummaryRep1;'
                               || 'Visible=1;Enabled=1;'
                                 AS cmd_lines
                          FROM active_menus, active_sessions
                         WHERE     active_menus.session_id(+) = active_sessions.session_id
                               AND active_sessions.session_id = USERENV ('SESSIONID')
                               AND 0 = (SELECT COUNT (active_menus.menu_handle)
                                          FROM active_menus
                                         WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_text = 'miSummaryReports_8')
                               AND get_user_priv (55) = 1
                               AND ROWNUM = 1)
                 WHERE kurs3_var.number_version < 776
                UNION ALL
                SELECT 21 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miUDGWorkForm;'
                       || 'CopyAction=MenuCommandAction;Caption=Плановые формы;ItemsAdd=miReportsUMG;'
                       || 'Visible=1;Enabled=1;'
                         AS cmd_lines
                  FROM active_menus, active_sessions
                 WHERE     active_menus.session_id(+) = active_sessions.session_id
                       AND active_sessions.session_id = USERENV ('SESSIONID')
                       AND 0 = (SELECT COUNT (active_menus.menu_handle)
                                  FROM active_menus
                                 WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_text = 'miUDGWorkForm')
                       AND get_user_priv (54) = 1
                       AND ROWNUM = 1
                UNION ALL
                SELECT 22 AS cmd_id
                      ,   'CreateObject;ClassName=TMenuItem;Owner=Self;Name=miUDGRepWorkForm;'
                       || 'CopyAction=MenuCommandAction;Caption=Отчетные формы;ItemsAdd=miReportsUMG;'
                       || 'Visible=1;Enabled=1;'
                         AS cmd_lines
                  FROM active_menus, active_sessions
                 WHERE     active_menus.session_id(+) = active_sessions.session_id
                       AND active_sessions.session_id = USERENV ('SESSIONID')
                       AND 0 = (SELECT COUNT (active_menus.menu_handle)
                                  FROM active_menus
                                 WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_text = 'miUDGRepWorkForm')
                       AND get_user_priv (54) = 1
                       AND ROWNUM = 1
                UNION ALL
                SELECT 23 AS cmd_id, 'Object;Name=miARS;Visible=' || get_user_priv (63) || ';Enabled=' || get_user_priv (63) || ';' AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 24 AS cmd_id
                      ,   'Object;Name=miC6;Visible='
                       || DECODE (get_user_priv (4), 1, 1, DECODE (get_user_unique_id (kurs3_var.global_user_id), 11, 1, 0))
                       || ';Enabled='
                       || DECODE (get_user_priv (4), 1, 1, DECODE (get_user_unique_id (kurs3_var.global_user_id), 11, 1, 0))
                       || ';'
                         AS cmd_lines
                  FROM DUAL
                UNION ALL
                SELECT 25 AS cmd_id, 'Object;Name=miCategory;Visible=0;Enabled=0;' AS cmd_lines
                  FROM DUAL
                 WHERE NVL (kurs3_var.global_municipality, 0) = 0
                UNION ALL
                SELECT 26 AS cmd_id, 'Object;Name=miCategory;Visible=1;Enabled=1;' AS cmd_lines
                  FROM DUAL
                 WHERE NVL (kurs3_var.global_municipality, 0) <> 0
                UNION ALL
                SELECT 28 AS cmd_id -- AVL 06.11.2008
                                   --, 'CreateObject;ClassName=TListsBGReports_K3;Owner=Application;List_Code=64;Name=frm_LinksList;' AS cmd_lines
                       , 'CreateObject;ClassName=TKursLists;Owner=Application;List_Code=64;Name=frm_LinksList;' -- AVL 23.04.2010
                  FROM DUAL
                 WHERE LOWER (kurs3_var.global_user_name) IN ('plan', 'super', 'order') /*AND USERENV ('TERMINAL') = 'C-TARAKANOV'*/
                UNION ALL
                SELECT 29 AS cmd_id, 'Object;Name=miAdviceList;Visible=' || pp || ';Enabled=' || pp || ';' AS cmd_lines
                  FROM (SELECT DECODE (kurs3_var.plan_priv, 1, 1, DECODE (get_user_priv (71), 1, 0)) AS pp FROM DUAL)
                UNION ALL
                SELECT 30 AS cmd_id, 'Object;Name=miOrdersKpiList;Visible=' || pp || ';Enabled=' || pp || ';' AS cmd_lines
                  FROM (SELECT DECODE (kurs3_var.order_priv, 1, 1, DECODE (get_user_unique_id (kurs3_var.global_user_id), 11, 1, 0)) AS pp FROM DUAL)
-- #D11032013                  
              UNION ALL
                SELECT 32 AS cmd_id, 'Object;Name=miTPReports;Visible=' || pp || ';Enabled=' || pp || ';' AS cmd_lines
                  FROM (SELECT DECODE (NVL(get_user_priv (113),0),0,0,1) AS pp FROM DUAL)
-- /#D11032013
   --ilonis 29.08.2013
                 UNION ALL                    
                 --меню технический паспорт
                SELECT 33 AS cmd_id, 'Object;Name=N37;Visible=1;Enabled='||case when ((get_user_priv(111)=1) or(get_user_priv(112)=1) or (get_user_priv(113)=1)  ) then 1 else 0 end ||';'  AS cmd_lines FROM DUAL        
                union all                  
                --меню просмотр тп
                SELECT 34 AS cmd_id, 'Object;Name=N72;Visible=1;Enabled='||case when ((get_user_priv(111)=1) or(get_user_priv(112)=1) or (get_user_priv(113)=1)  ) then 1 else 0 end||';'  AS cmd_lines FROM DUAL
                 union all
                --меню ввод данных о тп
                SELECT 35 AS cmd_id, 'Object;Name=N39;Visible=1;Enabled='||case when ((get_user_priv(111)=1) or(get_user_priv(112)=1)  ) then 1 else 0 end||';'  AS cmd_lines FROM DUAL
                UNION ALL
                  SELECT 31 AS cmd_id
                      ,   'Object;Name=miVyvRepUsers;Visible='
                       || pp
                       || ';Enabled='
                       || pp
                       || ';'
                       || 'Reset;'
                       || 'Object;Name=miVyvRepResult;Visible='
                       || pp
                       || ';Enabled='
                       || pp
                       || ';'
  --  28.11.2013 Dik                       
                       || 'Reset;'                       
                       ||'Object;Name=miVyvRepUsersVC;Visible='
                       || pp
                       || ';Enabled='--!
                       || pp
                       || ';'
                       || 'Reset;'
                       || 'Object;Name=miVyvRepResultVC;Visible='
                       || pp
                       || ';Enabled='--!
                       || pp
                       || ';'
  -- / 28.11.2013 Dik                          
                         AS cmd_lines
                  FROM (SELECT get_user_priv (90) AS pp FROM DUAL))

      ORDER BY cmd_id;
  ELSIF UPPER (form_event) = 'MENUCOMMANDACTION' THEN
    SELECT menu_text, TO_NUMBER (NVL (proc_name, 0))
      INTO a, n
      FROM active_menus
     WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_handle = do_for_kurs_datmod.form_handle;

    SELECT COUNT (*)
      INTO cnt_w
      FROM all_kurs_objects, screen_types
     WHERE     all_kurs_objects.session_id = USERENV ('SESSIONID')
           AND all_kurs_objects.screen_type = screen_types.screen_type
           AND all_kurs_objects.window_handle = n;
           
   
    IF UPPER (a) = 'MIPLANKPUPRIOR' THEN
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id
                        ,'CreateObject;ClassName=TfrmChild;Name=frmPlanKPUPrior;Caption=Отчеты по ПЛАНу КПУ;'
                         || 'Width=500;Owner=Application;FormStyle=1;Show=1;'
                           AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 0
                  UNION ALL
                  SELECT 1 AS cmd_id, 'Object;Name=frmPlanKPUPrior;Show=1;' AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 1)
        ORDER BY cmd_id;
    --     ELSIF SUBSTR (UPPER (a), 1, 7) = 'MIF1AOP' THEN   -- Форма для лимитной карты
    --       OPEN qcommand FOR
    --         SELECT   *
    --             FROM (SELECT 2 AS cmd_id
    --                         ,    'CreateObject;ClassName=TfrmChild;Name=frmAOp;Caption=Форма Ф1-АОп;'
    --                           || 'Width=400;Height=250;Owner=Application;Show=1;' AS cmd_lines
    --                     FROM DUAL)
    --         ORDER BY cmd_id;
    --     ELSIF SUBSTR (UPPER (a), 1, 7) = 'MIFLK' THEN   -- Форма для лимитной карты
    --       OPEN qcommand FOR
    --         SELECT   *
    --             FROM (SELECT 2 AS cmd_id
    --                         ,    'CreateObject;ClassName=TfrmChild;Name=frmFLK;Caption=Лимитная карта;'
    --                           || 'Width=400;Height=250;Owner=Application;Show=1;' AS cmd_lines
    --                     FROM DUAL)
    --         ORDER BY cmd_id;
    --     ELSIF SUBSTR (UPPER (a), 1, 8) = 'MIF1MOSP' THEN   -- Форма для лимитной карты
    --       OPEN qcommand FOR
    --         SELECT   *
    --             FROM (SELECT 2 AS cmd_id
    --                         ,    'CreateObject;ClassName=TfrmChild;Name=frmMOSp;Caption=Форма Ф1-МОСп;'
    --                           || 'Width=400;Height=250;Owner=Application;Show=1;' AS cmd_lines
    --                     FROM DUAL)
    --         ORDER BY cmd_id;
    -- AVL 26.11.2007 нач
    ELSIF UPPER (a) = 'MI_F112' THEN
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id
                        ,'CreateObject;ClassName=TfrmChild;Owner=Application;Name=frmF112;Caption=Экспликация Ф-4;'
                         || 'FormStyle=1;Top=1;Left=1;Width=290;Height=150;Show=1;'
                           AS cmd_lines
                    FROM DUAL
                   WHERE NOT EXISTS
                           (SELECT 1
                              FROM all_kurs_objects
                             WHERE session_id = USERENV ('SESSIONID') AND window_name = 'frmF112')
                  UNION ALL
                  SELECT 1 AS cmd_id, 'Window;Handle=' || TO_CHAR (window_handle) || ';Show=1;WindowState=0;'
                    FROM all_kurs_objects
                   WHERE session_id = USERENV ('SESSIONID') AND window_name = 'frmF112')
        ORDER BY cmd_id;
    -- AVL 26.11.2007 кон
    ELSIF SUBSTR (UPPER (a), 1, 7) = 'MIF2AOP' THEN -- Форма для отчета Ф2АОп для ЛК
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id
                        ,'CreateObject;ClassName=TfrmChild;Owner=Application;Name=frm2AOp;'
                         || 'Caption=Форма Ф2-АОп;Width=340;Height=230;Show=1;'
                           AS cmd_lines
                    FROM DUAL
                   WHERE NOT EXISTS
                           (SELECT 1
                              FROM all_kurs_objects
                             WHERE session_id = USERENV ('SESSIONID') AND window_name = 'frm2AOp')
                  UNION ALL
                  SELECT 1 AS cmd_id, 'Window;Handle=' || TO_CHAR (window_handle) || ';Show=1;WindowState=0;' AS cmd_lines
                    FROM all_kurs_objects
                   WHERE session_id = USERENV ('SESSIONID') AND window_name = 'frm2AOp')
        ORDER BY cmd_id;
    ELSIF SUBSTR (LOWER (a), 1, 9) = 'mi_rep_lk' THEN -- Форма для отчетов по ЛК
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id
                        ,   'CreateObject;ClassName=TfrmChild;Owner=Application;Name=frm_lk_rep;'
                         || 'Caption=Отчеты по ЛК;Width=410;Height='
                         || DECODE (sys_priv, 1, 220, 160)
                         || ';Show=1;'
                           AS cmd_lines
                    FROM DUAL
                   WHERE NOT EXISTS
                           (SELECT 1
                              FROM all_kurs_objects
                             WHERE session_id = USERENV ('SESSIONID') AND window_name = 'frm_lk_rep')
                  UNION ALL
                  SELECT 1 AS cmd_id, 'Window;Handle=' || TO_CHAR (window_handle) || ';Show=1;WindowState=0;' AS cmd_lines
                    FROM all_kurs_objects
                   WHERE session_id = USERENV ('SESSIONID') AND window_name = 'frm_lk_rep')
        ORDER BY cmd_id;
    ELSIF SUBSTR (LOWER (a), 1, 8) = 'mi_lk_ur' THEN -- Отчеты по ЛК для УР
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id, 'Window;Handle=' || TO_CHAR (window_handle) || ';Show=1;WindowState=0;' AS cmd_lines
                    FROM all_kurs_objects
                   WHERE session_id = USERENV ('SESSIONID') AND window_name = 'frm_lk_ur_rep'
                  UNION ALL
                  SELECT 2 AS cmd_id
                        ,'CreateObject;ClassName=TfrmChild;Owner=Application;Name=frm_lk_ur_rep;'
                         || 'Caption=Отчеты по ЛК для УР;Width=530;Height=220;Show=1;'
                           AS cmd_lines
                    FROM DUAL)
           WHERE ROWNUM < 2
        ORDER BY cmd_id;
    -- AVL 06.11.2008 нач
    ELSIF UPPER (a) = 'MI_LINK1' THEN
      UPDATE active_menus
         SET proc_name      =
               (SELECT window_handle
                  FROM active_sessions, all_kurs_objects
                 WHERE     active_sessions.session_id = USERENV ('SESSIONID')
                       AND active_sessions.session_id = all_kurs_objects.session_id
                       AND LOWER (all_kurs_objects.window_name) = 'frm_linkslist')
       WHERE active_menus.session_id = USERENV ('SESSIONID') AND LOWER (active_menus.menu_text) = 'mi_link1' -- AND menu_id = 1 AVL 23.04.2010
                                                                                                            AND proc_name IS NULL;

      SELECT TO_NUMBER (NVL (proc_name, 0))
        INTO n
        FROM active_menus
       WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_handle = do_for_kurs_datmod.form_handle;

      SELECT COUNT (*)
        INTO cnt_w
        FROM all_kurs_objects, screen_types
       WHERE     all_kurs_objects.session_id = USERENV ('SESSIONID')
             AND all_kurs_objects.screen_type = screen_types.screen_type
             AND all_kurs_objects.window_handle = n;

      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id, --'CreateObject;ClassName=TListsBGReports_K3;Owner=Application;List_Code=64;Name=frm_LinksList;' AS cmd_lines
                                     'CreateObject;ClassName=TKursLists;Owner=Application;List_Code=64;Name=frm_LinksList;' -- AVL 23.04.2010
                                                                                                                           AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 0
                  UNION ALL
                  SELECT 1 AS cmd_id, 'Object;Name=frm_LinksList;Show=1;' AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 1)
        ORDER BY cmd_id;
    -- AVL 06.11.2008 кон
    -- AVL 20.07.2009 нач
    ELSIF UPPER (a) = 'MI_MOSOBL1' THEN
      UPDATE active_menus
         SET proc_name      =
               (SELECT window_handle
                  FROM active_sessions, all_kurs_objects
                 WHERE     active_sessions.session_id = USERENV ('SESSIONID')
                       AND active_sessions.session_id = all_kurs_objects.session_id
                       AND LOWER (all_kurs_objects.window_name) = 'frm_mosobllist')
       WHERE active_menus.session_id = USERENV ('SESSIONID') AND LOWER (active_menus.menu_text) = 'mi_mosobl1' AND menu_id = 1 AND proc_name IS NULL;

      SELECT TO_NUMBER (NVL (proc_name, 0))
        INTO n
        FROM active_menus
       WHERE active_menus.session_id = USERENV ('SESSIONID') AND active_menus.menu_handle = do_for_kurs_datmod.form_handle;

      SELECT COUNT (*)
        INTO cnt_w
        FROM all_kurs_objects, screen_types
       WHERE     all_kurs_objects.session_id = USERENV ('SESSIONID')
             AND all_kurs_objects.screen_type = screen_types.screen_type
             AND all_kurs_objects.window_handle = n;

      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id --                        ,'CreateObject;ClassName=TLists_onFormCommand;Owner=Application;List_Code=64;Name=frm_LinksList;'
                                    , 'CreateObject;ClassName=TListsBGReports_K3;Owner=Application;List_Code=70;Name=frm_mosobllist;' AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 0
                  UNION ALL
                  SELECT 1 AS cmd_id, 'Object;Name=frm_mosobllist;Show=1;' AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 1)
        ORDER BY cmd_id;
    -- AVL 20.07.2009 кон
    ELSIF UPPER (a) = 'MITESTRIGTHGRID' THEN
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id
                        ,'CreateObject;ClassName=TfrmChild;Owner=Application;Name=frmTestRigthGrid;Caption=Данные БТИ;'
                         || 'FormStyle=1;Top=1;Left=1;Width=750;Height=600;Show=1;'
                           AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 0
                  UNION ALL
                  SELECT 1 AS cmd_id, 'Object;Name=frmTestRigthGrid;Show=1;' AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 1)
        ORDER BY cmd_id;
    ELSIF SUBSTR (UPPER (a), 1, 16) = 'MISUMMARYREPORTS' THEN -- остается для версий <=775
      a   := RTRIM (SUBSTR (UPPER (a), 18, 1));

      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id, 'LoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL
                  UNION ALL
                  SELECT 2 AS cmd_id
                        ,'CreateObject;ClassName=TfrmSummaryReports;Owner=Application;Name=frmWorkExcel;' || 'Caption='
                         || DECODE (a
                                   ,NULL, 'Форма 1.П;Template_id=93'
                                   ,'1', 'Форма 1.1.П;Template_id=90'
                                   ,'2', 'Форма 1.2.П;Template_id=91'
                                   ,'3', 'Форма 2.П;Template_id=96'
                                   ,'4', 'Форма 2.1.П;Template_id=97'
                                   ,'5', 'Форма 2.2.П;Template_id=98'
                                   ,'6', 'Форма 2.3.П;Template_id=99'
                                   ,'7', 'Форма 2.4.П;Template_id=100'
                                   ,'8', 'Форма 2.3.1.П;Template_id=101'
                                   ,'Форма 2.1.1.П;Template_id=102'
                                   )
                         || ';ShowModal=;Free=;'
                           AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 7 AS cmd_id, 'UnLoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL)
        ORDER BY cmd_id;
    --- //Шаблоны
    ELSIF SUBSTR (UPPER (a), 1, 9) = 'MITMPLIMP' THEN
      a   := RTRIM (SUBSTR (UPPER (a), 10, 2));

      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id, 'LoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL
                  UNION ALL
                  SELECT 2 AS cmd_id
                        ,'CreateObject;ClassName=TfmRepRTF;Owner=Application;Name=fmTemplRepRTF;' || 'Caption='
                         || DECODE (a
                                   ,'01', 'Шаблон 1;TypeReport=122'
                                   ,'02', 'Шаблон 2;TypeReport=123'
                                   ,'03', 'Шаблон 3;TypeReport=124'
                                   ,'04', 'Шаблон 4;TypeReport=125'
                                   ,'05', 'Шаблон 5;TypeReport=126'
                                   ,'06', 'Шаблон 6;TypeReport=127'
                                   ,'07', 'Шаблон 7;TypeReport=128'
                                   ,'08', 'Шаблон 8;TypeReport=129'
                                   ,'09', 'Шаблон 9;TypeReport=130'
                                   ,'10', 'Шаблон 10;TypeReport=131'
                                   ,'11', 'Шаблон 11;TypeReport=132'
                                   ,'12', 'Шаблон 12;TypeReport=133'
                                   ,'Шаблон 13;TypeReport=134'
                                   )
                         || ';StartReport=1;Free=;'
                           AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 7 AS cmd_id, 'UnLoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL)
        ORDER BY cmd_id;
    ELSIF SUBSTR (UPPER (a), 1, 13) = 'MISUMMARYREP1' THEN -- для версий >= 776
      a   := RTRIM (SUBSTR (UPPER (a), 18, 1));

      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id, 'LoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL
                  UNION ALL
                  SELECT 2 AS cmd_id
                        ,'CreateObject;ClassName=TfrmSummaryReports;Owner=Application;Name=frmWorkExcel;' || ';ShowModal=;Free=;' AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 7 AS cmd_id, 'UnLoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL)
        ORDER BY cmd_id;
    ELSIF UPPER (a) = 'MIUDGWORKFORM' THEN
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id, 'LoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL
                  UNION ALL
                  SELECT 2 AS cmd_id
                        ,'CreateObject;ClassName=TfrmWorkForm;Owner=Application;Name=frmWorkForm;'
                         || 'Caption=Работа с отчетами;Template_id=93;RepType=0;StartReport=1;Free=;'
                           AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 7 AS cmd_id, 'UnLoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL)
        ORDER BY cmd_id;
    ELSIF UPPER (a) = 'MIUDGREPWORKFORM' THEN
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id, 'LoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL
                  UNION ALL
                  SELECT 2 AS cmd_id
                        ,'CreateObject;ClassName=TfrmWorkForm;Owner=Application;Name=frmWorkForm;'
                         || 'Caption=Работа с отчетами;Template_id=108;RepType=1;StartReport=1;Free=;'
                           AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 7 AS cmd_id, 'UnLoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL)
        ORDER BY cmd_id;
    ELSIF UPPER (a) = 'MIARS' AND get_user_priv (63) = 1 THEN
      do_for_default ('#CREATE_LISTS_ARS', form_name, form_handle, form_event, out_props, qcommand);
    ELSIF UPPER (a) = 'MIBTIVIEW' THEN
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id, 'LoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL
                  UNION ALL
                  SELECT 2 AS cmd_id
                        ,'CreateObject;ClassName=TfrmWorkForm;Owner=Application;Name=frmWorkForm;'
                         || 'Caption=Работа с отчетами;Template_id=108;RepType=1;StartReport=1;Free=;'
                           AS cmd_lines
                    FROM DUAL
                  UNION ALL
                  SELECT 7 AS cmd_id, 'UnLoadPackage;PackageName=Rep.bpl;' AS cmd_lines FROM DUAL)
        ORDER BY cmd_id;
        
--#D11032013 miTPReport ==================
  ELSIF UPPER (a) = 'MITPREPORT1' THEN
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id, 'CreateObject;ClassName=TTPReportDialog;Owner=Application;Name=frm_TPReport;Caption=Отчет предоставление ж/п;Tag=1;ShowModal=;Free=;'
            AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 0)
   ORDER BY cmd_id;         
  ELSIF UPPER (a) = 'MITPREPORT2' THEN
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id, 'CreateObject;ClassName=TTPReportDialog;Owner=Application;Name=frm_TPReport;Caption=Отчет выдача жителям ТП;Tag=2;ShowModal=;Free=;'
            AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 0)
   ORDER BY cmd_id;
  ELSIF UPPER (a) = 'MITPREPORT3' THEN
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id, 'CreateObject;ClassName=TTPReportDialog;Owner=Application;Name=frm_TPReport;Caption=Отчет количество ТП в округах;Tag=3;ShowModal=;Free=;'
            AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 0)
   ORDER BY cmd_id; 
-- / #D11032013        
   
    ELSIF UPPER (a) = 'MIADVICELIST' THEN
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id, 'CreateObject;ClassName=TLists_onFormCommand;Owner=Application;List_Code=49;Name=frm_AdviceList;' AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 0
                  UNION ALL
                  SELECT 1 AS cmd_id, 'Object;Name=frm_AdviceList;Show=1;' AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 1)
        ORDER BY cmd_id;
    ELSIF UPPER (a) = 'MICATEGORY' THEN
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id, 'CreateObject;ClassName=TLists_onFormCommand;Owner=Application;List_Code=62;Name=frm_CategoryList;' AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 0
                  UNION ALL
                  SELECT 1 AS cmd_id, 'Object;Name=frm_CategoryList;Show=1;' AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 1)
        ORDER BY cmd_id;
    ELSIF UPPER (a) = 'MIORDERSKPILIST' THEN
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id, 'CreateObject;ClassName=TLists_onFormCommand;Owner=Application;List_Code=32;Name=frm_OrdersKpiList;' AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 0
                  UNION ALL
                  SELECT 1 AS cmd_id, 'Object;Name=frm_OrdersKpiList;Show=1;' AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 1)
        ORDER BY cmd_id;
    ELSIF UPPER (a) = 'MISUBSIDLIST' THEN
      OPEN qcommand FOR
          SELECT *
            FROM (SELECT 1 AS cmd_id
                        ,'CreateObject;ClassName=TLists_onFormCommand;Owner=Application;List_Code=33;Name=frm_SubsidList;RetProp=WindowState;'
                           AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 0
                  UNION ALL
                  SELECT 1 AS cmd_id, 'Object;Name=frm_SubsidList;Show=1;' AS cmd_lines
                    FROM DUAL
                   WHERE cnt_w = 1)
        ORDER BY cmd_id;
    ELSIF UPPER (a) IN ('MIVYVREPRESULT', 'MIVYVREPUSERS','MIVYVREPRESULTVC', 'MIVYVREPUSERSVC') THEN   --  28.11.2013 Dik
      do_for_verify_rep (form_class_name, form_name, form_handle, 'do:' || a, out_props, qcommand);
    ELSE
      do_for_default (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
    END IF;
  ELSE
    do_for_default (form_class_name, form_name, form_handle, form_event, out_props, qcommand);
  END IF;
END;
/
