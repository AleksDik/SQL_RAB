DROP VIEW KURS3.V_PASPORT_TRAFFIC_EDIT;

CREATE OR REPLACE FORCE VIEW KURS3.V_PASPORT_TRAFFIC_EDIT
(TP_TRAFFIC_ID, TP_ID, USER_ID, LAST_CHANGE, WORK_PLACE_LINK_ID, 
 NSORT, TRAFFIC_DOC_ID, DOC_NUM, DOC_DATE, SIGN_ID, 
 SENDER_ID, TAKER_ID, DOC_TYPE_ID, SENDER_NAME, TAKER_NAME, 
 DOC_NAME, STATUS, USER_NAME, WORKPLACE_ID, WORKPLACE_SENDER_ID, 
 WORKPLACE_TAKER_ID)
AS 
SELECT TPT.TP_TRAFFIC_ID,  TPT.TP_ID,  TPT.USER_ID,  TPT.LAST_CHANGE,  TPT.WORK_PLACE_LINK_ID,  TPT.NSORT,    TPT.TRAFFIC_DOC_ID  ,
          TD.DOC_NUM, TD.DOC_DATE,TD.SIGN_ID,
          WP.FROM_WP SENDER_ID, WP.TO_WP TAKER_ID,  WP.DOC_TYPE_ID ,
          SCL.NAME AS SENDER_NAME,
          TCL.NAME AS TAKER_NAME,
          DCL.NAME AS DOC_NAME,
          STCL.NAME AS STATUS,
          US.NAME AS USER_NAME,
          US.WORKPLACE_ID,
          SCL.ROW_NUM AS WORKPLACE_SENDER_ID,
          TCL.ROW_NUM AS WORKPLACE_TAKER_ID
         FROM KURS3.TP_TRAFFIC TPT
          LEFT OUTER JOIN KURS3.TP_TRAFFIC_DOC TD ON TD.TRAFFIC_DOC_ID = TPT.TRAFFIC_DOC_ID 
          LEFT OUTER JOIN KURS3.TP_WORK_PLACE_LINK WP     ON WP.WORK_PLACE_LINK_ID = TPT.WORK_PLACE_LINK_ID
          LEFT OUTER JOIN KURS3.CLASSIFIER_KURS3 SCL ON     SCL.ROW_NUM = WP.FROM_WP AND SCL.CLASSIFIER_NUM = 132   AND SCL.DELETED = 0
          LEFT OUTER JOIN KURS3.CLASSIFIER_KURS3 TCL ON     TCL.ROW_NUM = WP.TO_WP   AND TCL.CLASSIFIER_NUM = 132    AND TCL.DELETED = 0
          LEFT OUTER JOIN KURS3.CLASSIFIER_KURS3 DCL  ON     DCL.ROW_NUM = WP.DOC_TYPE_ID   AND DCL.CLASSIFIER_NUM = 134   AND DCL.DELETED = 0
          LEFT OUTER JOIN KURS3.CLASSIFIER_KURS3 STCL  ON     STCL.ROW_NUM = WP.STATUS_ID AND STCL.CLASSIFIER_NUM = 135    AND STCL.DELETED = 0
          LEFT OUTER JOIN KURS3.USERS US   ON US.USER_ID = TPT.USER_ID;


DROP SYNONYM O31.V_PASPORT_TRAFFIC_EDIT;

CREATE OR REPLACE SYNONYM O31.V_PASPORT_TRAFFIC_EDIT FOR KURS3.V_PASPORT_TRAFFIC_EDIT;

DROP SYNONYM O51.V_PASPORT_TRAFFIC_EDIT;

CREATE OR REPLACE SYNONYM O51.V_PASPORT_TRAFFIC_EDIT FOR KURS3.V_PASPORT_TRAFFIC_EDIT;

DROP SYNONYM O52.V_PASPORT_TRAFFIC_EDIT;

CREATE OR REPLACE SYNONYM O52.V_PASPORT_TRAFFIC_EDIT FOR KURS3.V_PASPORT_TRAFFIC_EDIT;

DROP SYNONYM O53.V_PASPORT_TRAFFIC_EDIT;

CREATE OR REPLACE SYNONYM O53.V_PASPORT_TRAFFIC_EDIT FOR KURS3.V_PASPORT_TRAFFIC_EDIT;

DROP SYNONYM O54.V_PASPORT_TRAFFIC_EDIT;

CREATE OR REPLACE SYNONYM O54.V_PASPORT_TRAFFIC_EDIT FOR KURS3.V_PASPORT_TRAFFIC_EDIT;

DROP SYNONYM O55.V_PASPORT_TRAFFIC_EDIT;

CREATE OR REPLACE SYNONYM O55.V_PASPORT_TRAFFIC_EDIT FOR KURS3.V_PASPORT_TRAFFIC_EDIT;

DROP SYNONYM O56.V_PASPORT_TRAFFIC_EDIT;

CREATE OR REPLACE SYNONYM O56.V_PASPORT_TRAFFIC_EDIT FOR KURS3.V_PASPORT_TRAFFIC_EDIT;

DROP SYNONYM O57.V_PASPORT_TRAFFIC_EDIT;

CREATE OR REPLACE SYNONYM O57.V_PASPORT_TRAFFIC_EDIT FOR KURS3.V_PASPORT_TRAFFIC_EDIT;

DROP SYNONYM O58.V_PASPORT_TRAFFIC_EDIT;

CREATE OR REPLACE SYNONYM O58.V_PASPORT_TRAFFIC_EDIT FOR KURS3.V_PASPORT_TRAFFIC_EDIT;

DROP SYNONYM O59.V_PASPORT_TRAFFIC_EDIT;

CREATE OR REPLACE SYNONYM O59.V_PASPORT_TRAFFIC_EDIT FOR KURS3.V_PASPORT_TRAFFIC_EDIT;

DROP SYNONYM O60.V_PASPORT_TRAFFIC_EDIT;

CREATE OR REPLACE SYNONYM O60.V_PASPORT_TRAFFIC_EDIT FOR KURS3.V_PASPORT_TRAFFIC_EDIT;

DROP SYNONYM O61.V_PASPORT_TRAFFIC_EDIT;

CREATE OR REPLACE SYNONYM O61.V_PASPORT_TRAFFIC_EDIT FOR KURS3.V_PASPORT_TRAFFIC_EDIT;

DROP SYNONYM O62.V_PASPORT_TRAFFIC_EDIT;

CREATE OR REPLACE SYNONYM O62.V_PASPORT_TRAFFIC_EDIT FOR KURS3.V_PASPORT_TRAFFIC_EDIT;

DROP SYNONYM O63.V_PASPORT_TRAFFIC_EDIT;

CREATE OR REPLACE SYNONYM O63.V_PASPORT_TRAFFIC_EDIT FOR KURS3.V_PASPORT_TRAFFIC_EDIT;


DROP SYNONYM KURSIV.V_PASPORT_TRAFFIC_EDIT;

CREATE OR REPLACE SYNONYM KURSIV.V_PASPORT_TRAFFIC_EDIT FOR KURS3.V_PASPORT_TRAFFIC_EDIT;

DROP SYNONYM KURS3_ADM.V_PASPORT_TRAFFIC_EDIT;

CREATE OR REPLACE SYNONYM KURS3_ADM.V_PASPORT_TRAFFIC_EDIT FOR KURS3.V_PASPORT_TRAFFIC_EDIT;


GRANT SELECT ON KURS3.V_PASPORT_TRAFFIC_EDIT TO KURS3_ADM;

GRANT SELECT ON KURS3.V_PASPORT_TRAFFIC_EDIT TO OKRUG;
