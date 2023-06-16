USE MiamiDadeCollege;
GO

--151,388 Total Student enrollments for campuses

-- Total Students By Campus and Total Credits
-- Year 2019 - 2020


SELECT * 
--2019-2020
FROM (SELECT 'COLLEGE WIDE' AS 'Location/Campus',COUNT(Dummy_Student_ID) AS 'Students Head Count', SUM([Total Credits per Student]) AS 'Total Credits', AVG([Total Credits per Student]) AS 'Average Credits'
FROM (SELECT Dummy_Student_ID, SUM(CREDITS) AS 'Total Credits per Student' 
FROM Enrollment_Sample
GROUP BY Dummy_Student_ID) AS [College Wide Student Credits]
UNION ALL
SELECT COURSE_CAMPUS, COUNT(COURSE_CAMPUS) AS 'Number of Students',
		SUM([Credits By Campus]) AS [Credits By Campus], AVG([Credits By Campus]) AS 'Average Credits'
FROM (SELECT Dummy_Student_ID, COURSE_CAMPUS, SUM(CREDITS) AS 'Credits By Campus' FROM Enrollment_Sample
GROUP BY Dummy_Student_ID, COURSE_CAMPUS) AS [Students by Campus] 
GROUP BY COURSE_CAMPUS) AS Enrollment_Locations_1920

JOIN 
-- Fall 2019
(SELECT * FROM (SELECT 'COLLEGE WIDE' AS 'Location/Campus',COUNT(Dummy_Student_ID) AS 'Students Head Count', SUM([Total Credits per Student]) AS 'Total Credits', AVG([Total Credits per Student]) AS 'Average Credits'
FROM
(SELECT Dummy_Student_ID, SUM(CREDITS) AS 'Total Credits per Student' 
FROM Enrollment_Sample
WHERE ENROLLMENT_TERM = 2197
GROUP BY Dummy_Student_ID) AS [College Wide Student Credits]
UNION ALL
SELECT COURSE_CAMPUS, COUNT(COURSE_CAMPUS) AS 'Number of Students',
		SUM([Credits By Campus]) AS [Credits By Campus], AVG([Credits By Campus]) AS 'Average Credits'
FROM (SELECT Dummy_Student_ID, COURSE_CAMPUS, SUM(CREDITS) AS 'Credits By Campus' FROM Enrollment_Sample
WHERE ENROLLMENT_TERM = 2197
GROUP BY Dummy_Student_ID, COURSE_CAMPUS) AS [Students by Campus] 
GROUP BY COURSE_CAMPUS) AS Enrollment_Locations_fall_2019) AS Enrollment_2019
ON Enrollment_Locations_1920.[Location/Campus] = Enrollment_2019.[Location/Campus]

JOIN 
-- SPRING 2020
(SELECT * FROM (SELECT 'COLLEGE WIDE' AS 'Location/Campus',COUNT(Dummy_Student_ID) AS 'Students Head Count', SUM([Total Credits per Student]) AS 'Total Credits', AVG([Total Credits per Student]) AS 'Average Credits'
FROM
(SELECT Dummy_Student_ID, SUM(CREDITS) AS 'Total Credits per Student' 
FROM Enrollment_Sample
WHERE ENROLLMENT_TERM = 2203
GROUP BY Dummy_Student_ID) AS [College Wide Student Credits]
UNION ALL
SELECT COURSE_CAMPUS, COUNT(COURSE_CAMPUS) AS 'Number of Students',
		SUM([Credits By Campus]) AS [Credits By Campus], AVG([Credits By Campus]) AS 'Average Credits'
FROM (SELECT Dummy_Student_ID, COURSE_CAMPUS, SUM(CREDITS) AS 'Credits By Campus' FROM Enrollment_Sample
WHERE ENROLLMENT_TERM = 2203
GROUP BY Dummy_Student_ID, COURSE_CAMPUS) AS [Students by Campus] 
GROUP BY COURSE_CAMPUS) AS Enrollment_Locations_Spring_2020) AS Enrollment_Spring_2020
ON Enrollment_2019.[Location/Campus] = Enrollment_Spring_2020.[Location/Campus]

JOIN 
-- SUMMER 2020
(SELECT * FROM (SELECT 'COLLEGE WIDE' AS 'Location/Campus',COUNT(Dummy_Student_ID) AS 'Students Head Count', SUM([Total Credits per Student]) AS 'Total Credits', AVG([Total Credits per Student]) AS 'Average Credits'
FROM
(SELECT Dummy_Student_ID, SUM(CREDITS) AS 'Total Credits per Student' 
FROM Enrollment_Sample
WHERE ENROLLMENT_TERM = 2205
GROUP BY Dummy_Student_ID) AS [College Wide Student Credits]
UNION ALL
SELECT COURSE_CAMPUS, COUNT(COURSE_CAMPUS) AS 'Number of Students',
		SUM([Credits By Campus]) AS [Credits By Campus], AVG([Credits By Campus]) AS 'Average Credits'
FROM (SELECT Dummy_Student_ID, COURSE_CAMPUS, SUM(CREDITS) AS 'Credits By Campus' FROM Enrollment_Sample
WHERE ENROLLMENT_TERM = 2205
GROUP BY Dummy_Student_ID, COURSE_CAMPUS) AS [Students by Campus] 
GROUP BY COURSE_CAMPUS) AS Enrollment_Locations_Summer_2020) AS Enrollment_Summer_2020
ON Enrollment_Spring_2020.[Location/Campus] = Enrollment_Summer_2020.[Location/Campus]

