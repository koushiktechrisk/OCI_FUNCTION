create or replace PROCEDURE PROC_USER_DATA_SYNC_FROM_FUSION 
(
    p_created_by IN VARCHAR2 DEFAULT '150'
) 
IS
    l_body VARCHAR2(4000);
    p_init_loop NUMBER := 1;
    p_loop_max NUMBER;
    l_data CLOB;
    sync_id NUMBER;
BEGIN
    SELECT NVL(MAX(SYNC_ID), 0) + 1 INTO sync_id FROM USER_DATA_SYNC_HEADER;
    INSERT INTO USER_DATA_SYNC_HEADER(SYNC_ID, SYNCED_BY, SYNCED_AT)
    VALUES(sync_id, p_created_by, CURRENT_TIMESTAMP);

    SELECT clob_resp INTO l_data
    FROM PETROFAC_USER_TEMP_XML
    WHERE id = (SELECT MAX(id) FROM PETROFAC_USER_TEMP_XML);

INSERT INTO USER_DATA_SYNC_DETAILS (
    USER_LOGIN, USER_ID, ROLE_NAME, ROLE_DESCRIPTION,CREATION_DATE, PERSON_ID, FULL_NAME, FIRST_NAME, LAST_NAME, EMAIL_ADDRESS, LOCATION_CODE, LOCATION_NAME, TOWN, COUNTRY,
    DEPARTMENT, ORGANIZATION_ID, USERNAME, USER_GUID,START_DATE, ACTIVE_FLAG,SYNC_ID
)
SELECT
    atts.USER_LOGIN,
    atts.USER_ID, 
    atts.ROLE_NAME,   
    atts.ROLE_DESCRIPTION,
    atts.CREATION_DATE,
    atts.PERSON_ID,
    atts.FULL_NAME,
    atts.FIRST_NAME,
    atts.LAST_NAME,
    atts.EMAIL_ADDRESS,
    atts.LOCATION_CODE,
    atts.LOCATION_NAME,
    atts.TOWN,
    atts.COUNTRY,
    atts.DEPARTMENT,
    atts.ORGANIZATION_ID,
    atts.USERNAME,
    atts.USER_GUID,
    atts.START_DATE,
    atts.ACTIVE_FLAG,
    sync_id
FROM PETROFAC_USER_TEMP_XML, XMLTABLE('/DATA_DS/G_1' 
    PASSING XMLType(PETROFAC_USER_TEMP_XML.clob_resp)
    COLUMNS 
        USER_LOGIN VARCHAR2(1000) PATH './USER_LOGIN',
        USER_ID NVARCHAR2(10000) PATH './USER_ID',
        ROLE_NAME VARCHAR2(2000) PATH './ROLE_NAME',
        ROLE_DESCRIPTION VARCHAR2(2000) PATH './ROLE_DESCRIPTION',
        CREATION_DATE NVARCHAR2(10000) PATH './CREATION_DATE',                
        PERSON_ID NVARCHAR2(10000) PATH './PERSON_ID',                
        FULL_NAME VARCHAR2(2000) PATH './FULL_NAME',
        FIRST_NAME VARCHAR2(2000) PATH './FIRST_NAME',
        LAST_NAME VARCHAR2(2000) PATH './LAST_NAME',
        EMAIL_ADDRESS VARCHAR2(1000) PATH './EMAIL_ADDRESS',
        LOCATION_CODE VARCHAR2(1000) PATH './LOCATION_CODE',
        LOCATION_NAME VARCHAR2(2000) PATH './LOCATION_NAME',
        TOWN VARCHAR2(2000) PATH './TOWN',
        COUNTRY VARCHAR2(2000) PATH './COUNTRY',
        DEPARTMENT VARCHAR2(1000) PATH './DEPARTMENT',
        ORGANIZATION_ID NVARCHAR2(10000) PATH './ORGANIZATION_ID',
        USERNAME VARCHAR2(2000) PATH './USERNAME',
        USER_GUID NVARCHAR2(10000) PATH './USER_GUID',
        START_DATE NVARCHAR2(10000) PATH './START_DATE', 
        ACTIVE_FLAG VARCHAR2(2) PATH './ACTIVE_FLAG'
        
) atts;


EXCEPTION 
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error merging data calling PROC_USER_DATA_SYNC_FROM_FUSION: ' || SQLERRM);

END;
/