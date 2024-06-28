SELECT 
    EMP_user_info.user_login,
    EMP_user_info.user_id,
    user_roles.role_name,
    user_roles.description AS Role_description,
    EMP_user_info.creation_date,
    EMP_user_info.person_id,
    EMP_user_info.FULL_NAME,
    EMP_user_info.first_name,
    EMP_user_info.last_name,
    EMP_user_info.EMAIL_ADDRESS,
    EMP_user_info.location_code,
    EMP_user_info.location_name,
    EMP_user_info.town,
    EMP_user_info.country,
    EMP_user_info.department,
    EMP_user_info.ORGANIZATION_ID,
    EMP_user_info.ORGANIZATION_Units_Name,
    EMP_user_info.username,
    EMP_user_info.USER_GUID,
    EMP_user_info.START_DATE,
    EMP_user_info.active_flag
FROM (
    SELECT DISTINCT 
        pp.creation_date,
        ppf.first_name,
        ppf.last_name,
        ppf.FULL_NAME,
        hl.location_code,
        hl.location_name,
        hl.town_or_city AS town,
        hl.country,
        pd.name AS department,
        Email.EMAIL_ADDRESS,
        pu.person_id,
        pu.username,
        pu.active_flag,
        au.user_id,
        au.USER_GUID,
        pp.START_DATE,
        hr1.ORGANIZATION_ID, 
        hr1.NAME AS ORGANIZATION_Units_Name,
        au.user_login,
        pr.ROLE_GUID
    FROM per_persons pp
    JOIN per_users pu ON pp.person_id = pu.person_id
    JOIN per_all_people_f papf ON pu.person_id = papf.person_id
    JOIN per_person_names_f_v ppf ON papf.person_id = ppf.person_id
    JOIN per_all_assignments_m paaf ON ppf.person_id = paaf.person_id
    JOIN hr_locations_all_f_vl hl ON paaf.location_id = hl.location_id
    JOIN per_departments pd ON paaf.organization_id = pd.organization_id
    JOIN PER_EMAIL_ADDRESSES Email ON pu.person_id = Email.PERSON_ID
    JOIN hr_organization_units_f_tl hr1 ON paaf.organization_id = hr1.ORGANIZATION_ID
    JOIN ase_user_vl au ON pu.user_guid = au.user_guid
    LEFT JOIN PER_USER_ROLES pr ON au.user_id = pr.user_id
    WHERE TRUNC(SYSDATE) BETWEEN NVL(ppf.effective_start_date, TRUNC(SYSDATE)) 
                              AND NVL(ppf.effective_end_date, TRUNC(SYSDATE))
      AND TRUNC(SYSDATE) BETWEEN NVL(papf.effective_start_date, TRUNC(SYSDATE)) 
                              AND NVL(papf.effective_end_date, TRUNC(SYSDATE))
      AND TRUNC(SYSDATE) BETWEEN NVL(paaf.effective_start_date, TRUNC(SYSDATE)) 
                              AND NVL(paaf.effective_end_date, TRUNC(SYSDATE))
      AND TRUNC(SYSDATE) BETWEEN NVL(hl.effective_start_date, TRUNC(SYSDATE)) 
                              AND NVL(hl.effective_end_date, TRUNC(SYSDATE))
      AND TRUNC(SYSDATE) BETWEEN NVL(pd.effective_start_date, TRUNC(SYSDATE)) 
                              AND NVL(pd.effective_end_date, TRUNC(SYSDATE))
      AND TRUNC(SYSDATE) BETWEEN NVL(au.effective_start_date, TRUNC(SYSDATE)) 
                              AND NVL(au.effective_end_date, TRUNC(SYSDATE))
      AND hr1.SOURCE_LANG = 'US'
) EMP_user_info
LEFT JOIN (
    SELECT u.user_login,
           r.role_name,
           r.description,
           aurm.user_id
    FROM ase_user_vl u
    JOIN ase_user_role_mbr aurm ON u.user_id = aurm.user_id
    JOIN ase_role_vl r ON aurm.role_id = r.role_id
    WHERE r.effective_end_date IS NULL
      AND aurm.effective_end_date IS NULL
) user_roles ON EMP_user_info.user_login = user_roles.user_login
ORDER BY EMP_user_info.user_login;
