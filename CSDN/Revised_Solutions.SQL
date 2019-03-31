/*1.Query student's info and scores if one scored higher for course 01 than 02*/

/*Solution1 (w/o JOIN)*/
SELECT Student.*, t1.Score AS Score01, t2.Score AS Score02
FROM Student, SC t1, SC t2
WHERE Student.SID = t1.SID
AND Student.SID = t2.SID
AND t1.CID = '01'
AND t2.CID = '02'
AND t1.Score > t2.Score;

/*Solution2 (w/ JOIN)*/
SELECT Student.*, t1.Score AS Score01, t2.Score AS Score02
FROM ((SELECT SID, Score FROM SC WHERE CID = '01') AS t1 
INNER JOIN (SELECT SID, Score FROM SC WHERE CID = '02') AS t2 
ON t1.SID = t2.SID AND t1.Score > t2.Score) AS t, Student 
WHERE Student.SID = t.SID;


/*2.Query student's info if one takes both course 01 & 02*/

/*Solution1 (w/o JOIN)*/
SELECT Student.*, t1.Score AS Score01, t2.Score AS Score02
FROM Student, SC t1, SC t2
WHERE Student.SID = t1.SID
AND Student.SID = t2.SID
AND t1.CID = '01'
AND t2.CID = '02';

/*Solution2 (w/ JOIN)*/
SELECT Student.*, t1.Score AS Score01, t2.Score AS Score02
FROM ((SELECT SID, Score FROM SC WHERE CID = '01') AS t1 
INNER JOIN (SELECT SID,Score FROM SC WHERE CID = '02') AS t2 
ON t1.SID = t2.SID), Student
WHERE Student.SID = t1.SID;


/*3.Query the cases that course 01 is included but course 02 MAY not (Null)*/

SELECT Student.*, t.Score_01, t.Score_02
FROM ((SELECT SID, Score AS Score_01 FROM SC WHERE CID = '01') t1 
LEFT JOIN (SELECT SID, Score AS Score_02 FROM SC WHERE CID = '02') t2 
ON t1.SID = t2.SID) t, Student
WHERE t.SID = Student.SID;


/*4.Query the case that course 02 is included but course 01 is not*/

/*Solution1 (w/ EXISTS)*/
SELECT Student.*, Score
FROM Student, SC
WHERE NOT EXISTS (SELECT Score FROM SC 
WHERE CID = '01' AND SID = Student.SID)
AND Student.SID = SC.SID
AND CID = '02';

/*Solution2 (w/ IN)*/
SELECT Student.*, Score
FROM SC, Student
WHERE SC.SID NOT IN (SELECT SID FROM SC WHERE CID = '01')
AND CID = '02'
AND SC.SID = Student.SID;


/*5.Query student's id, name and score if one's average point is equal or over 60*/

SELECT Student.SID, Student.SName, ROUND(AVG(Score), 1) AS Avg_Score
FROM Student, SC
WHERE Student.SID = SC.SID
GROUP BY 1
HAVING Avg_Score >= 60;


/*6.Query student's info if one has records in SC*/

/*Solution1 (w/ EXISTS)*/
SELECT *
FROM Student
WHERE EXISTS (SELECT Score FROM SC 
WHERE SID = Student.SID);

/*Solution2 (w/ IN)*/
SELECT *
FROM Student
WHERE SID IN (SELECT SID FROM SC);

/*Solution3 (w/o EXISTS or IN)*/
SELECT Student.*
FROM Student, SC
WHERE Student.SID = SC.SID;


/*7.Query all students' IDs, names, amounts of courses and SUMs of scores (Null)*/

SELECT Student.SID, Student.SName, t.Course_Num, t.Total_Score
FROM Student LEFT JOIN 
(SELECT Student.SID, SName, COUNT(CID) AS Course_Num, SUM(Score) AS Total_Score
FROM Student, SC
WHERE Student.SID = SC.SID
GROUP BY 1) t
ON t.SID = Student.SID;
/* So the LEFT JOIN is just for the Null output */


/*8.Query Student's info if one has score in SC*/
/*wrt. Q6*/


/*9.Query the number of teachers whose last name is 李*/
SELECT "李" AS T_LastName, COUNT(*) AS Num
FROM Teacher
WHERE TName LIKE '李%';


/*10.Query Student's info if one is taught by teacher 张三*/
SELECT Student.*
FROM Student, Teacher, Course, SC
WHERE TName = '张三'
AND Teacher.TID = Course.TID
AND Course.CID = SC.CID
AND SC.SID = Student.SID;


/*11.Query student's info if one doesn't learn all courses*/

/*Solution1 (w/ JOIN)*/
SELECT DISTINCT Student.*
FROM (SELECT Student.SID, Course.CID FROM Student, Course) t1 
LEFT JOIN (SELECT SC.SID, SC.CID FROM SC) t2 
ON t1.SID = t2.SID AND t1.CID = t2.CID, Student
WHERE t2.SID IS NULL
AND t1.SID = Student.SID;

/*Solution2 (w/ IN)*/
SELECT *
FROM Student
WHERE SID NOT IN (SELECT SID FROM SC
GROUP BY 1
HAVING COUNT(*) = (SELECT COUNT(*) FROM Course));

/*Solution3 (w/ EXISTS)*/
SELECT *
FROM Student
WHERE NOT EXISTS (SELECT SID FROM SC
WHERE SID = Student.SID
GROUP BY 1
HAVING COUNT(CID) = (SELECT COUNT(*) FROM Course))
 

/*12.Query student's info if one has at least one same course with sid 01*/

/*Solution1 (w/ IN)*/
SELECT DISTINCT Student.*
FROM Student, SC
WHERE CID IN (SELECT CID FROM SC
WHERE SID = '01')
AND Student.SID = SC.SID
AND Student.SID != '01';
                   
/*Solution2 (w/ double IN)*/
SELECT *
FROM Student
WHERE SID IN (SELECT SID FROM SC
WHERE CID IN (SELECT CID FROM SC
WHERE SID = '01')
GROUP BY SID)
AND SID != '01'


/*13.Query student's info if one has exactly the same course with sid 01*/
SELECT Student.*
FROM Student, SC
WHERE SC.CID IN (SELECT CID FROM SC WHERE SID = '01')
AND Student.SID != '01'
AND Student.SID = SC.SID
GROUP BY 1
HAVING COUNT(*) = (SELECT COUNT(*) FROM SC WHERE SID = '01');
/* This logic is tricky: all the cid are in the set of 01's cids and equal cnts */


/*14.Query student's name if one does not take any course taught by 张三*/

/* Solution1 (w/ IN)*/
SELECT SName
FROM Student
WHERE SID NOT IN (SELECT SID
FROM Course, Teacher, SC WHERE Teacher.TID = Course.TID
AND Course.CID = SC.CID AND TName = '张三');

/* Solution2 (w/ EXISTS)*/
SELECT SName
FROM Student
WHERE NOT EXISTS (SELECT SID
FROM Course, Teacher, SC
WHERE TName = '张三'
AND Course.TID = Teacher.TID
AND SC.CID = Course.CID
AND Student.SID = SC.SID);


/*15.Query student's IDs, names and average score if one failed at least twice*/

/*Solution1 (w/ CASE)*/
SELECT SC.SID, SName, ROUND(AVG(Score), 1) AS Avg_Score
FROM Student, SC
WHERE Student.SID = SC.SID
GROUP BY 1
HAVING SUM(CASE WHEN Score < 60 THEN 1 ELSE 0 END) >= 2;

/*Solution2 (w/o CASE)*/
SELECT SC.SID, SName, Round(AVG(Score),1) AS AvgS
FROM Student, SC
WHERE SC.SID = Student.SID
AND Score < 60
GROUP BY 1
HAVING COUNT(*) >= 2;


/*16.Query student's info if one failed course 01, descending the score*/

SELECT Student.*, Score
FROM Student, SC
WHERE Score < 60
AND CID = '01'
AND Student.SID = SC.SID
GROUP BY 1
ORDER BY Score DESC;


/*17.Query all students' points for all courses and average points in order*/

SELECT SC.*, t.Avg_Score
FROM SC LEFT JOIN
(SELECT SID, Round(AVG(Score), 1) AS Avg_Score FROM SC GROUP BY 1) AS t
ON SC.SID = t.SID
ORDER BY 1, 4 DESC;
/* Also can be done with Window Functions */


/*18.Query for all kinds of rate (version 1)*/

SELECT CID, COUNT(*) AS ClassSize, 
MAX(Score) AS Max, MIN(Score) AS Min, Round(AVG(Score), 1) AS AvgS,
Round(Cast(SUM(CASE WHEN Score >= 60 THEN 1 ELSE 0 END) AS Float) / COUNT(*), 2) AS DRate,  
Round(Cast(SUM(CASE WHEN Score BETWEEN 70 AND 79 THEN 1 ELSE 0 END) AS Float) / COUNT(*), 2) AS CRate,
Round(Cast(SUM(CASE WHEN Score BETWEEN 80 AND 89 THEN 1 ELSE 0 END) AS Float) / COUNT(*), 2) AS BRate,
Round(Cast(SUM(CASE WHEN Score >= 90 THEN 1 ELSE 0 END) AS Float) / COUNT(*), 2) AS ARate
FROM SC
GROUP BY 1
ORDER BY 2 DESC, 1;


/*19. Order by score of each course, giving the rank, which remains when two scores are equal*/

SELECT SC.CID, SC.SID, SC.Score, Rank
FROM SC LEFT JOIN (SELECT SID, CID, (SELECT COUNT(S2.Score) + 1
FROM SC S2 WHERE S2.CID = S1.CID AND S2.Score > S1.Score) AS Rank
FROM SC S1) t
ON SC.SID = t.SID
AND SC.CID = t.CID
ORDER BY 1, 4;


/*20. Order by score of each course, giving the rank, which merges when two scores are equal*/

SELECT SC.CID, SC.SID, SC.Score, Rank
FROM SC LEFT JOIN (SELECT SID, CID, (SELECT COUNT(DISTINCT S2.Score) + 1
FROM SC S2 WHERE S2.CID = S1.CID AND S2.Score > S1.Score) AS Rank
FROM SC S1) t
ON SC.SID = t.SID
AND SC.CID = t.CID
ORDER BY 1, 4;


/*21.Query student's total scores, ranking and remaining when two scores are equal*/

SELECT t1.*, COUNT(t2.SID) AS Rank
FROM (SELECT SID, SUM(Score) AS SUM_Score 
FROM SC GROUP BY 1) t1, (SELECT SID, SUM(Score) 
AS SUM_Score FROM SC GROUP BY 1) t2
WHERE t2.SUM_Score >= t1.SUM_Score
GROUP BY 1
ORDER BY Rank;


/*22.Query student's total scores, ranking and merging when two scores are equal*/

SELECT t1.*, COUNT(DISTINCT t2.SID) AS Rank
FROM (SELECT SID, SUM(Score) AS SUM_Score 
FROM SC GROUP BY 1) t1, (SELECT SID, SUM(Score) 
AS SUM_Score FROM SC GROUP BY 1) t2
WHERE t2.SUM_Score >= t1.SUM_Score
GROUP BY 1
ORDER BY Rank;

/* 19 - 22 are all about RANKING, which is very important, as MEDIAN */

/*23.Query for all kinds of rate (version 2)*/

SELECT Course.CID, CName,
Round(Cast(SUM(CASE WHEN Score <= 60 THEN 1 ELSE 0 END) AS Float) / COUNT(*), 2) AS FRate,  
Round(Cast(SUM(CASE WHEN Score BETWEEN 60 AND 69 THEN 1 ELSE 0 END) AS Float) / COUNT(*), 2) AS MRate,
Round(Cast(SUM(CASE WHEN Score BETWEEN 70 AND 84 THEN 1 ELSE 0 END) AS Float) / COUNT(*), 2) AS GRate,
Round(Cast(SUM(CASE WHEN Score >= 85 THEN 1 ELSE 0 END) AS Float) / COUNT(*), 2) AS ERate
FROM SC, Course
WHERE Course.CID = SC.CID
GROUP BY 1
ORDER BY 1;


/*24.Query top 3 for each course*/

SELECT CID, SID, Score
FROM SC AS t1
WHERE (SELECT COUNT(*) FROM SC AS t2 WHERE t1.CID = t2.CID AND t2.Score > t1.Score) < 3
ORDER BY 1, 3 DESC;


/*25.Query the class size for each course*/

SELECT CName, COUNT(*) AS ClassSize
FROM Course, SC
WHERE Course.CID = SC.CID
GROUP BY 1;


/*26.Query student's IDs and names if one just takes two courses*/

SELECT SID, SName
FROM Student, SC
WHERE Student.SID = SC.SID
GROUP BY 1
HAVING COUNT(*) = 2;


/*27.Query numbers of male and female*/

/*Solution1 (w/ CASE)*/
SELECT SUM(CASE WHEN SSEX ='男' THEN 1 ELSE 0 END) AS COUNT_Male,
SUM(CASE WHEN SSEX ='女' THEN 1 ELSE 0 END) AS COUNT_Female
FROM Student;

/*Solution2 (w/o CASE)*/
SELECT SSex, COUNT(*)
FROM Student
GROUP BY 1;


/*28.Query student's info if one's name contain 风*/

SELECT *
FROM Student
WHERE SName LIKE '%风%';


/*29.Query student's info if one has COUNTerparts with the same name*/

SELECT *
FROM Student LEFT JOIN (SELECT SName, COUNT(*) AS Num 
FROM Student GROUP BY 1) AS t
ON Student.SName = t.SName
WHERE t.Num > 1;


/*30.Query student's info if one was born in 1990*/

SELECT *
FROM Student
WHERE strftime('%Y', SAge) = '1990';


/*31.Query Average score for each course*/

SELECT CID, ROUND(AVG(Score), 1) AS Avg_Score
FROM SC
GROUP BY 1
ORDER BY 2 DESC, 1;


/*32.Query student's IDs, names, and average score if one scores more than 85 in average*/

SELECT SID, SName, ROUND(AVG(Score), 1) AS Avg_Score
FROM Student, SC
WHERE Student.SID = SC.SID
GROUP BY 1
HAVING Avg_Score > 85;


/*33.Query student's names and points of course 数学, if one scores less than 60*/

SELECT SName, Score
FROM Student, SC, Course
WHERE Course.CName = '数学'
AND SC.CID = Course.CID
AND Student.SID = SC.SID
AND Score < 60;


/*34.Query Score for each student (NUll included)*/

SELECT SName, CID, Score
FROM Student LEFT JOIN SC
USING(SID);


/*35.Query its course name, student name and score if any score higher than 70 */

SELECT CName, SName, Score
FROM Course, Student, SC
WHERE Score > 70
AND Course.CID = SC.CID
AND Student.SID = SC.SID;


/*36.Query failed courses*/

SELECT DISTINCT CID, CName, COUNT(Score) AS Num
FROM Course, SC
WHERE Course.CID = SC.CID
AND SC.Score < 60
GROUP BY 1;


/*37.Query student's IDs and names if scored over 80 in course 01*/

SELECT SID, SName
FROM Student, SC
WHERE Student.SID = SC.SID
AND SC.CID = '01'
AND SC.Score >= 80;


/*38.Query class size for each course*/

/*Solution1 (w/o JOIN)*/
SELECT CID, CName, COUNT(*) AS ClassSize
FROM SC, Course
WHERE SC.CID = Course.CID
GROUP BY 1;

/*Solution2 (w/ JOIN)*/
SELECT CID, CName, COUNT(*) AS ClassSize
FROM SC INNER JOIN Course
USING(CID)
GROUP BY 1;


/*39.Query top 1 student's info and score in course taught by 张三 (no equal scores)*/

SELECT Student.*, Score
FROM Student, Course, Teacher, SC
WHERE Student.SID = SC.SID
AND SC.CID = Course.CID
AND Course.TID = Teacher.TID
AND TName = '张三'
ORDER BY Score DESC 
LIMIT 1;


/*40.Query top 1 student's info and score in courses taught by 张三 (included equal scores)*/

SELECT Student.*, t1.Score
FROM Student, Course, Teacher, SC t1
WHERE Student.SID = t1.SID
AND t1.CID = Course.CID
AND Course.TID = Teacher.TID
AND TName = '张三'
AND t1.Score = (SELECT MAX(Score) FROM SC t2 WHERE t1.CID = t2.CID);
/* Or AND (SELECT COUNT(*) FROM SC t2 WHERE t1.CID = t2.CID AND t2.Score > t1.Score) = 0 */

                     
/*41.Query student's SID, CID and Score if ones have same score for different courses*/

/*Solution1 (w/ JOIN)*/
SELECT t1.*
FROM SC t1 INNER JOIN SC t2
ON t1.SID = t2.SID
AND t1.CID != t2.CID
AND t1.Score = t2.Score
GROUP BY 1, 2;

/*Solution2 (w/o JOIN)*/
SELECT t1.*
FROM SC t1, SC t2
WHERE t1.SID = t2.SID
AND t1.CID != t2.CID
AND t1.Score = t2.Score
GROUP BY 1, 2;


/*42.Query top 2 for each course*/

SELECT t1.CID, t1.SID, t1.Score
FROM SC t1
WHERE (SELECT COUNT(*) FROM SC t2 WHERE t1.CID = t2.CID AND t2.Score > t1.Score) < 2
ORDER BY 1, 3 DESC;


/*43.Query class size for each course (at least 5)*/

SELECT CID, CName, COUNT(*) AS ClassSize
FROM SC, Course
WHERE Course.CID = SC.CID
GROUP BY 1
HAVING ClassSize >= 5;


/*44.Query student's info if one takes more than two courses*/

SELECT Student.*, COUNT(*) AS ClassNum
FROM Student, SC
WHERE Student.SID = SC.SID
GROUP BY 1
HAVING ClassNum > 2;


/*45.Query student's info if one takes all courses*/

SELECT Student.*
FROM Student, SC
WHERE Student.SID = SC.SID
GROUP BY 1
HAVING COUNT(*) = (SELECT COUNT(*) FROM Course);


/*46-50.Time related problems*/

SELECT SName, (Date('now') - SAge) AS Age
FROM Student;

SELECT *
FROM Student
WHERE Strftime('%W', Date('Now')) = Strftime('%W', SAge);

SELECT *
FROM Student
WHERE Strftime('%m', Date('Now')) = Strftime('%m', Sage);

SELECT *
FROM Student
WHERE Strftime('%W', Date('Now')) = Strftime('%W',SAge) - 1;

SELECT *
FROM Student
WHERE Strftime('%m', Date('Now')) = Strftime('%m', Sage) - 1;
