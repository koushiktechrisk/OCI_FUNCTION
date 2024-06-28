SELECT *
FROM
  (SELECT 
    EMP_user_info.user_login,
    EMP_user_info.user_id,
    user_roles.role_name,
	user_roles.description "Role_description",
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
	EMP_user_info.NAME ORGANIZATION_Units_Name,
    EMP_user_info.username,
	EMP_user_info.USER_GUID,
	EMP_user_info.START_DATE,
	--user_info.DATE_OF_BIRTH,
    EMP_user_info.active_flag
  FROM
    (SELECT DISTINCT 
	  pp.creation_date creation_date,
      ppf.first_name first_name,
      ppf.last_name last_name,
	  ppf.FULL_NAME,
      hl.location_code location_code,
      hl.location_name location_name,
      hl.town_or_city town,
      hl.country country,
      pd.name department,
	  Email.EMAIL_ADDRESS,
	  pu.person_id,
      pu.username username,
      pu.active_flag active_flag,
      au.user_id user_id,
	  au.USER_GUID,
	  pp.START_DATE,
	  pp.DATE_OF_BIRTH,
	  hr1.ORGANIZATION_ID, 
	  hr1.NAME,
      au.user_login user_login,
      pr.ROLE_GUID
    FROM per_persons pp,
         PER_USER_ROLES pr,
        --  fusion.ase_user fu,
		 per_all_people_f papf,
		 per_person_names_f_v ppf,
		 hr_locations_all_f_vl hl,
		 per_departments pd,
		 PER_EMAIL_ADDRESSES Email,
		 per_all_assignments_m paaf,
		 per_users pu,
		 hr_organization_units_f_tl hr1,
		 ase_user_vl au
    WHERE au.user_guid              = pu.user_guid
      AND pr.ROLE_GUID              = xxxxxxxxxxxxxxxxxx
	  AND pu.person_id              = Email.PERSON_ID
	  AND hr1.ORGANIZATION_ID       = pd.ORGANIZATION_ID
      AND pu.person_id              = papf.person_id
      AND papf.person_id            = pp.person_id
      AND pp.person_id              = ppf.person_id
      AND ppf.person_id             = paaf.person_id
      AND paaf.location_id          = hl.location_id
      AND paaf.organization_id      = pd.organization_id
      AND TRUNC(sysdate) BETWEEN NVL(ppf.effective_start_date,TRUNC(sysdate)) AND NVL(ppf.effective_end_date,TRUNC(sysdate))
      AND TRUNC(sysdate) BETWEEN NVL(papf.effective_start_date,TRUNC(sysdate)) AND NVL(papf.effective_end_date,TRUNC(sysdate))
      AND TRUNC(sysdate) BETWEEN NVL(paaf.effective_start_date,TRUNC(sysdate)) AND NVL(paaf.effective_end_date,TRUNC(sysdate))
      AND TRUNC(sysdate) BETWEEN NVL(hl.effective_start_date,TRUNC(sysdate)) AND NVL(hl.effective_end_date,TRUNC(sysdate))
      AND TRUNC(sysdate) BETWEEN NVL(pd.effective_start_date,TRUNC(sysdate)) AND NVL(pd.effective_end_date,TRUNC(sysdate))
      AND TRUNC(sysdate) BETWEEN NVL(au.effective_start_date,TRUNC(sysdate)) AND NVL(au.effective_end_date,TRUNC(sysdate))
      AND   hr1.SOURCE_LANG ='US'
    )EMP_user_info
  LEFT JOIN
    (SELECT u.user_login user_login,
      r.role_name role_name,
      r.description description,
      aurm.user_id user_id
    FROM ase_user_vl u,
      ase_role_vl r,
      ase_user_role_mbr aurm
    WHERE r.role_id              = aurm.role_id
    AND aurm.user_id             =u.user_id
    AND r.effective_end_date    IS NULL
    AND aurm.effective_end_date IS NULL
    )user_roles
  ON EMP_user_info.user_login = user_roles.user_login
  ) qrslt
WHERE 1 = 1
ORDER BY user_login