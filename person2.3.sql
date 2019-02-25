SELECT DISTINCT
gcoffice.offid AS HOSPCODE, 
c.CID AS CID,
b.HN AS PID,
c.town_id AS HID,
( 
		CASE 
			WHEN DATEDIFF( NOW(), c.BIRTHDATE ) / 365.25 >= '20' AND sex='1' AND MARRIAGE = '4' THEN '831' 
			WHEN DATEDIFF( NOW(), c.BIRTHDATE ) / 365.25< '20' AND sex='1' AND MARRIAGE = '4' THEN '832' 
			WHEN DATEDIFF( NOW(), c.BIRTHDATE ) / 365.25 >= '15' AND sex='1' THEN '003' 
			WHEN DATEDIFF( NOW(), c.BIRTHDATE ) / 365.25 < '15' AND sex='1' THEN '001' 
			WHEN DATEDIFF( NOW(), c.BIRTHDATE ) / 365.25 < '15' AND sex='2' THEN '002' 
			WHEN DATEDIFF( NOW(), c.BIRTHDATE ) / 365.25 >= '15' AND sex='2' AND MARRIAGE ='1' THEN '004' 
			ELSE '005'
		END 
	 ) AS PRENAME, 
	trim(FNAME), 	trim(LNAME), b.HN, c.SEX, 
	DATE_FORMAT( c.BIRTHDATE, '%Y%m%d' ) AS BIRTH, 
	( 
		CASE 
			WHEN c.marriage = '4' THEN '6' 
			ELSE c.marriage
		END 
	 ) AS MSTSATUS,
( 
		CASE
			WHEN c.oc_id > '901' OR c.oc_id IN( '818', '507', '821', '718', '705', '404', '708', '216', '801', '504' ) THEN '000'
			WHEN c.oc_id IN( '501', '502', '503' ) THEN '001'
			WHEN c.oc_id IN( '403', '209', '207', '702', '709', '707', '816', '819', '803' ) THEN '002'
			WHEN c.oc_id IN( '401', '602', '606', '601' ) THEN '003'
			WHEN c.oc_id IN( '201', '106', '208', '110', '111', '112', '108', '805', '113', '203', '114', '102' ) THEN '004'
			WHEN c.oc_id IN( '302', '303' ) THEN '005'
			WHEN c.oc_id IN( '206', '210', '213', '214' ) THEN '006'
			WHEN c.oc_id IN( '202', '204', '205' ) THEN '007'
			WHEN c.oc_id IN( '402', '405' ) THEN '010'
			WHEN c.oc_id = '901' THEN '013'
			WHEN c.oc_id = '713' THEN '014'
			WHEN c.oc_id = '900' THEN '015'
		END 
	 ) AS OCCUPATION_OLD, '6111' AS OLLUPATION_NEW, 
	( 
		CASE 
			WHEN c.natn_id > '' THEN CONCAT( '0', c.natn_id )
			ELSE '099'
		END 
	 ) AS RACE, 
	( 
		CASE 
			WHEN c.natn_id > '' THEN CONCAT( '0', c.natn_id )
			ELSE '099'
		END 
	 ) AS NATION, 
	( 
		CASE 
			WHEN c.religion > '00' THEN c.religion
			ELSE '01'
		END 
	 ) AS RELIGION, 
	( 
		CASE 
			WHEN RIGHT( c.educate, 2 ) BETWEEN '01' AND '06' THEN RIGHT( c.educate, 2 )
			WHEN RIGHT( c.educate, 2 ) BETWEEN '07' AND '08' THEN '06'
			ELSE '00'
		END
	 ) AS EDUCATION, 
	'' AS FSTATUS, 
	trim(FATHER)as FATHER, trim(MOTHER) AS MOTHER, 
	'' AS COUPLE, 
	'' AS VSTATUS, 
	'' AS MOVEIN, 
	CASE 
	WHEN c.CID IN (SELECT cid FROM mbase_data.deaths ) THEN '1'
	ELSE '9'
  END AS DISCHARGE, 
	'' AS DDISCHARGE, 
	( 
		CASE 
			WHEN c.BG_ID IN( '01', '05', '09' ) THEN '1'
			WHEN c.BG_ID IN( 02, 06, 10 ) THEN '2'
			WHEN c.BG_ID IN( 03, 07, 11 ) THEN '3'
			WHEN c.BG_ID IN( 04, 08, 12 ) THEN '4'
			ELSE '0'
		END 
	 ) AS ABOGROUP, 
	( 
		CASE 
			WHEN c.BG_ID IN( 09, 10, 11, 12 ) THEN '1'
			WHEN c.BG_ID IN( 05, 06, 07, 08 ) THEN '2'
			ELSE '0'
		END 
	 ) AS RHGROUP, 
	'' AS LABOR, 
	'' AS PASSPORT, 
	'4'  AS TYPEAREA, 
	DATE_FORMAT( NOW(), '%Y%m%d%H%i%s' ) AS D_UPDATE,
	TELEPHONE AS TELEPHONE,
	'' AS MOBILE 

FROM mbase_data.gcoffice,mbase_data.opd_visits a
INNER JOIN mbase_data.cid_hn b ON a.HN = b.HN
INNER JOIN mbase_data.population c ON b.CID = c.CID

WHERE 
1 = 1	
AND LEFT( c.cid, 5 ) > 00000 
AND a.REG_DATETIME  >= '2019.02.01 00:01'
AND a.IS_CANCEL = 0
AND a.visit_id NOT IN( SELECT visit_id FROM mbase_data.ipd_reg )
ORDER BY 
	c.cid