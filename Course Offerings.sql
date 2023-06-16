USE MiamiDadeCollege
GO

--Course Offerings 

-- Total Number of Students for Each Class offering
-- (size of each class)
SELECT 
	COUNT(CLASS_NBR),
	CRSNAME,
	CLASS_DESCR,
	ENROLLMENT_TERM
FROM Enrollment_Sample
WHERE ENROLLMENT_TERM = 2197 --Fall Term
GROUP BY CLASS_NBR,CRSNAME,CLASS_DESCR, ENROLLMENT_TERM

--------------------------------------------------------------------------------------------
-- Total Students registered for each class during the academic year
SELECT 
	CRSNAME,
	CLASS_DESCR,
	COUNT(CLASS_NBR) AS 'Total Students' 	
FROM Enrollment_Sample
GROUP BY CRSNAME,CLASS_DESCR
ORDER BY [Total Students] DESC

--------------------------------------------------------------------------------------------
-- Total Students that registered for the top class by campus
SELECT 
	'COLLEGE WIDE' AS 'Location/Campus',
	CRSNAME,
	CLASS_DESCR,
	COUNT(CLASS_NBR) AS 'Total Students'
FROM Enrollment_Sample
WHERE CRSNAME LIKE 'ENC1101' 
--AND ENROLLMENT_TERM = 2197 --Fall Term
GROUP BY CRSNAME,CLASS_DESCR --CLASS_NBR
UNION ALL
SELECT 
	COURSE_CAMPUS,
	CRSNAME,
	CLASS_DESCR,
	COUNT(CLASS_NBR) AS 'Total Students'
FROM Enrollment_Sample
WHERE CRSNAME LIKE 'ENC1101' 
GROUP BY CRSNAME,CLASS_DESCR, COURSE_CAMPUS 
ORDER BY [Total Students] DESC
