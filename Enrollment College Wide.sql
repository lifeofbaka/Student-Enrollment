USE MiamiDadeCollege;
GO

--SELECT  * FROM Enrollment_Sample
-- 503,454 entries in the table 

--Credits nulls continuing education
-- Academic Plan NULLs 
--Plan Description NULLS

-- College Wide Enrollment----------------------------------------------------------------------------------------
-- Terms 2205 2203 2197
Declare @Total float, @Fall_2019 float, @Spring_2020 float, @Summer_2020 float

-- 2019/2020 College Wide Enrollment
set @Total = (SELECT COUNT(DISTINCT Dummy_Student_ID)  FROM Enrollment_Sample)
-- 2197 College Wide Enrollment
Set @Fall_2019 = (SELECT COUNT(DISTINCT Dummy_Student_ID) FROM Enrollment_Sample WHERE ENROLLMENT_TERM = 2197)
-- 2203 College Wide Enrollment
Set @Spring_2020 = (SELECT COUNT(DISTINCT Dummy_Student_ID) FROM Enrollment_Sample WHERE ENROLLMENT_TERM = 2203)
-- 2205 College Wide Enrollment
Set @Summer_2020 = (SELECT COUNT(DISTINCT Dummy_Student_ID) FROM Enrollment_Sample WHERE ENROLLMENT_TERM = 2205)

SELECT DISTINCT 
	@Total AS 'Total_2019/20',
	CONVERT(VARCHAR(10),@Fall_2019) AS 'Fall_2019',
	CONVERT(VARCHAR(10),@Spring_2020) AS 'Spring_2020',
	CONVERT(VARCHAR(10),@Summer_2020) AS 'Summer_2020' FROM Enrollment_Sample
UNION ALL
SELECT DISTINCT
	NULL,
	NULL, 
	CONVERT(VARCHAR(10),cast(((@Spring_2020 - @Fall_2019)/@Fall_2019)*100 AS numeric(38,2)))+' %',
	CONVERT(VARCHAR(10),cast(((@Summer_2020 - @Spring_2020)/@Spring_2020)*100 AS numeric(38,2)))+' %'
FROM Enrollment_Sample

------------------------------------------------------------------------------------------------------------------
-- College Wide Enrolled Credits

Declare @Total_Credits float, @Fall_Credits float, @Spring_Credits float, @Summer_Credits float

set @Total_Credits = (SELECT SUM(CREDITS) FROM Enrollment_Sample)
set @Fall_Credits = (SELECT SUM(CREDITS) FROM Enrollment_Sample WHERE ENROLLMENT_TERM =2197)
set @Spring_Credits = (SELECT SUM(CREDITS) FROM Enrollment_Sample WHERE ENROLLMENT_TERM=2203)
set @Summer_Credits = (SELECT SUM(CREDITS) FROM Enrollment_Sample WHERE ENROLLMENT_TERM=2205)

SELECT 
	@Total_Credits AS 'Total Credits',
	@Fall_Credits AS 'Fall_2019',
	@Spring_Credits AS 'Spring_2020',
	@Summer_Credits AS 'Summer_2020'


------------------------------------------------------------------------------------------------------------------
--Collge Wide Credits by ACAD_CAREER
SELECT ACAD_CAREER, SUM(CREDITS) AS 'CREDITS' FROM Enrollment_Sample
GROUP BY ACAD_CAREER
------------------------------------------------------------------------------------------------------------------
-- Average Credits By ACAD_CAREER per semester
SELECT ACAD_CAREER, AVG(Credits) AS 'Average_Credits', ENROLLMENT_TERM FROM (SELECT ACAD_CAREER, SUM(CREDITS) AS 'Credits', ENROLLMENT_TERM 
FROM Enrollment_Sample 
GROUP BY ENROLLMENT_TERM, ACAD_CAREER) as AVG_CRED_ACAD
GROUP BY ENROLLMENT_TERM, ACAD_CAREER
ORDER BY ACAD_CAREER, ENROLLMENT_TERM


------------------------------------------------------------------------------------------------------------------
-- Number of Students for Fiscal Year 2019 - 2020
 --SELECT COUNT(DISTINCT Dummy_Student_ID) AS 'Number of Students' FROM Enrollment_Sample
 -- 101,608

 --College Wide Student Demographics

--Student age groups 
SELECT * FROM 
(SELECT COUNT(Dummy_Student_ID) AS '17 & Younger' FROM (SELECT DISTINCT Dummy_Student_ID, Min(AGE) AS 'AGE' FROM Enrollment_Sample GROUP BY Dummy_Student_ID) AS Student_AGE
WHERE AGE <= 17 or AGE IS NULL) AS AGE_GROUP_1
CROSS JOIN 
(SELECT COUNT(Dummy_Student_ID) AS '18 - 23' FROM (SELECT DISTINCT Dummy_Student_ID, Min(AGE) AS 'AGE' FROM Enrollment_Sample GROUP BY Dummy_Student_ID) AS Student_AGE
WHERE AGE BETWEEN 18 and 23) AS AGE_GROUP_2
CROSS JOIN 
(SELECT COUNT(Dummy_Student_ID) AS '24 - 35' FROM (SELECT DISTINCT Dummy_Student_ID, Min(AGE) AS 'AGE' FROM Enrollment_Sample GROUP BY Dummy_Student_ID) AS Student_AGE
WHERE AGE BETWEEN 24 and 35) AS AGE_GROUP_3
CROSS JOIN 
(SELECT COUNT(Dummy_Student_ID) AS '36 & Older' FROM (SELECT DISTINCT Dummy_Student_ID, Min(AGE) AS 'AGE' FROM Enrollment_Sample GROUP BY Dummy_Student_ID) AS Student_AGE
WHERE AGE >= 36) AS AGE_GROUP_4


---Student Ethnicities

-- Identify students with multipe Ethnicity values
SELECT Dummy_Student_ID, Count( Dummy_Student_ID) FROM (SELECT DISTINCT Dummy_Student_ID, ETHNICITY FROM Enrollment_Sample GROUP BY Dummy_Student_ID, ETHNICITY)subquery
GROUP BY Dummy_Student_ID
Having Count( Dummy_Student_ID) > 1

SELECT Dummy_Student_ID, ETHNICITY FROM Enrollment_Sample
WHERE Dummy_Student_ID = 35023

--Temp Table with updated values
SELECT *
INTO #Temp_enrollement_sample
FROM Enrollment_Sample

-- Update Ethnicity of students with multiple ethnicity values
UPDATE #Temp_enrollement_sample
SET ETHNICITY = 'TWO OR MORE'
WHERE Dummy_Student_ID IN (SELECT Dummy_Student_ID FROM 
(SELECT Dummy_Student_ID, Count( Dummy_Student_ID) AS 'Ethnicities' FROM 
(SELECT DISTINCT Dummy_Student_ID, ETHNICITY FROM Enrollment_Sample GROUP BY Dummy_Student_ID, ETHNICITY)subquery
GROUP BY Dummy_Student_ID
Having Count( Dummy_Student_ID) > 1)MultipleEthnicity)


--Number of Students by ethnicity
SELECT ETHNICITY, COUNT(DISTINCT Dummy_Student_ID) AS 'Number of Students'
FROM #Temp_enrollement_sample 
GROUP BY ETHNICITY
ORDER BY [Number of Students] DESC

----------

-- Students by Gender

-- Find Students with multiple assigned genders
SELECT Dummy_Student_ID, Count( Dummy_Student_ID) AS 'Genders' FROM (SELECT DISTINCT Dummy_Student_ID, SEX FROM Enrollment_Sample GROUP BY Dummy_Student_ID, SEX)subquery
GROUP BY Dummy_Student_ID
Having Count( Dummy_Student_ID) > 1

-- Validation test 
SELECT Dummy_Student_ID, MAX(ENROLLMENT_TERM), SEX FROM Enrollment_Sample
WHERE Dummy_Student_ID = 62389
GROUP BY Dummy_Student_ID,SEX, ENROLLMENT_TERM
ORDER BY ENROLLMENT_TERM DESC

--Students By Gender 
SELECT  SEX, COUNT (DISTINCT t.Dummy_Student_ID) AS 'Number of Student'   
FROM (SELECT Dummy_Student_ID, MAX(ENROLLMENT_TERM) AS 'Last_Enrolled' FROM Enrollment_Sample GROUP BY Dummy_Student_ID) as t
LEFT JOIN Enrollment_Sample as e ON t.Last_Enrolled = e.Dummy_Student_ID
 WHERE Last_Enrolled = ENROLLMENT_TERM 
 GROUP BY SEX
------------------------------------------------------------------------------------------------------------------

 -- College Enrollment by Campus Fiscal Year 19-20 (NON-CREDIT)
SELECT COUNT( DISTINCT Dummy_Student_ID) AS 'ENROLLED', SUM(CREDITS) AS 'ENROLLED_CREDITS', AVG(CREDITS) AS 'AVERAGE_CREDITS', COURSE_CAMPUS FROM Enrollment_Sample
WHERE ACAD_CAREER LIKE 'CEPD'
GROUP BY COURSE_CAMPUS
ORDER BY ENROLLED_CREDITS DESC
 
 -- College Enrollment by Campus Fiscal Year 19-20 (CREDIT)
SELECT COUNT( DISTINCT Dummy_Student_ID) AS 'ENROLLED', SUM(CREDITS) AS 'ENROLLED_CREDITS', AVG(CREDITS) AS 'AVERAGE_CREDITS', COURSE_CAMPUS FROM Enrollment_Sample
WHERE ACAD_CAREER != 'CEPD'
GROUP BY COURSE_CAMPUS
ORDER BY ENROLLED_CREDITS DESC

------------------------------------------------------------------------------------------------------------------
