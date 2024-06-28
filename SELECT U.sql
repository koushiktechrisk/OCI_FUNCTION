SELECT  U.ID,
        U.USER_LOGIN,
        R.ROLE_NAME,
        R.ROLE_DESCRIPTION,
        U.CREATION_DATE,
        P.FULL_NAME,
        P.FIRST_NAME,
        P.LAST_NAME,
        P.EMAIL_ADDRESS,
        L.LOCATION_CODE,
        L.LOCATION_NAME,
        L.TOWN,
        L.COUNTRY,
        D.DEPARTMENT,
        O.ORGANIZATION_UNITS_NAME,
        U.USERNAME,
        U.USER_GUID,
        R.ROLE_GUID,
        UR.START_DATE,
        U.ACTIVE_FLAG,
        U.SYNC_ID,
        U.USER_ID,
        P.PERSON_ID,
        O.ORGANIZATION_ID
FROM PER_USERS U , 
     PER_USER_ROLES UR , 
     PER_ROLES R , 
     HR_LOCATIONS L , 
     HR_ALL_ORGANIZATION_UNITS O , 
     PER_PEOPLE P , 
     HR_DEPARTMENTS D , 
WHERE   U.USER_ID = UR.USER_ID
    AND UR.ROLE_ID = R.ROLE_ID
    AND U.LOCATION_ID = L.LOCATION_ID
    AND U.ORGANIZATION_ID = O.ORGANIZATION_ID
    AND U.PERSON_ID = P.PERSON_ID
    AND P.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE 
    U.ACTIVE_FLAG = 'Y'
ORDER BY 
    U.CREATION_DATE DESC;