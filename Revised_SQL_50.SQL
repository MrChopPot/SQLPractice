/*1.Query student's info and scores if one scored course 01 higher than 02*/
/*Solution1 (Without JOIN)*/
SELECT Student.*, t1.Score AS Score01, t2.Score AS Score02
FROM Student, SC t1, SC t2
WHERE Student.SID = t1.SID
AND Student.SID = t2.SID
AND t1.CID = '01'
AND t2.CID = '02'
AND t1.Score > t2.Score
GROUP BY 1;
/*Solution2 (With JOIN)*/
SELECT Student.*, t1.Score AS Score01, t2.Score AS Score02
FROM ((SELECT SID, Score FROM SC WHERE CID = '01') AS t1 
INNER JOIN (SELECT SID,Score FROM SC WHERE CID = '02') AS t2 
ON t1.SID = t2.SID AND t1.Score > t2.Score) AS t, Student 
WHERE Student.SID = t.SID;

/*2.Query student's info if one takes both course 01 & 02*/
/*Solution1 (Without JOIN)*/
SELECT Student.*, t1.Score AS Score01, t2.Score AS Score02
FROM Student, SC t1, SC t2
WHERE Student.SID = t1.SID
AND Student.SID = t2.SID
AND t1.CID = '01'
AND t2.CID = '02';
/*Solution2 (With JOIN)*/
SELECT Student.*, t1.Score AS Score01, t2.Score AS Score02
FROM ((SELECT SID, Score FROM SC WHERE CID = '01') AS t1 
INNER JOIN (SELECT SID,Score FROM SC WHERE CID = '02') AS t2 
ON t1.SID = t2.SID), Student
WHERE Student.SID = t1.SID;

/*3.Query the situation that course 01 is included 
but course 02 may not (Null to represent)*/
SELECT Student.*, t1.Score AS Score01, t2.Score AS Score02
FROM ((SELECT SID, Score FROM SC WHERE CID = '01') AS t1 
LEFT JOIN (SELECT SID,Score FROM SC WHERE CID = '02') AS t2 
ON t1.SID = t2.SID), Student
WHERE Student.SID = t1.SID;

/*4.Query the situation that course 02 is included but course 01 is not*/
/*Solution1 (w/ EXISTS)*/
SELECT Student.*, Score
FROM Student, SC
WHERE NOT EXISTS (SELECT Score FROM SC 
WHERE CID = '01' AND SC.SID = Student.SID)
AND Student.SID = SC.SID
AND CID = '02';
/*Solution2 (w/o EXISTS)*/
SELECT Student.*, Score
FROM SC, Student
WHERE SC.SID NOT IN (SELECT SID FROM SC WHERE CID='01')
AND CID='02'
AND SC.SID = Student.SID;

/*5.Query student's id, name and score if one's average points is over 60*/
SELECT Student.SId, Student.SName, ROUND(AVG(Score), 1) AS Avg_Score
FROM Student, SC
WHERE Student.SID = SC.SID
GROUP BY 1
HAVING Avg_Score > 60;

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

/*7.Query all students' IDs, names, amounts of course 
and sums of scores (Null represents no)*/
SELECT Student.SID, Student.SName, t.Course_Num, t.Total_Score
FROM Student LEFT JOIN (SELECT Student.SID, SName, COUNT(CID) AS Course_Num, SUM(Score) AS Total_Score
FROM Student, SC
WHERE Student.SID = SC.SID
GROUP BY 1) t
ON t.SID = Student.SID;

/*8.Query Student's info if one has score in SC*/
/*Reference to 6*/

/*9.Query the number of teachers whose last name is 李*/
SELECT Count(*)
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
/*Solution2 (w/o JOIN)*/
SELECT *
FROM Student
WHERE SID NOT IN (SELECT SID FROM SC
GROUP BY 1
HAVING COUNT(*) = (SELECT COUNT(*) FROM Course));

/*12.Query student's info if one has at least one same course with sid 01*/
/* Solution 1*/
SELECT DISTINCT Student.*
FROM Student, SC
WHERE CID IN(SELECT CID FROM SC
WHERE SID = '01')
AND Student.SID = SC.SID
AND Student.SID != '01';
                   
/* Solution 2*/
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
HAVING Count(*) = (SELECT Count(*) FROM SC WHERE SID = '01');

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
WHERE NOT EXISTS (SELECT SC.SID
FROM Course, Teacher, SC
WHERE Teacher.TName = '张三'
AND Course.TID = Teacher.TID
AND SC.CID = Course.CID
AND Student.SID = SC.SID)

/*15.Query student's IDs, names and average score if one failed at least twice*/
/*Solution1 (w/ CASE)*/
SELECT SC.SID, SName, ROUND(AVG(Score), 1) AS Avg_Score
FROM Student, SC
WHERE Student.SID = SC.SID
GROUP BY 1
HAVING SUM(CASE WHEN Score < 60 THEN 1 ELSE 0 END) >= 2;
/*Solution2 (w/o CASE)*/
SELECT SC.SID, SName, Round(Avg(Score),1) AS AvgS
FROM Student, SC
WHERE SC.SID = Student.SID
AND Score < 60
GROUP BY 1
HAVING Count(*) >= 2;

/*16.Query student's info if one failed course 01, descending the score*/
SELECT Student.*, Score
FROM Student, SC
WHERE Score < 60
AND CID = '01'
AND Student.SID = SC.SID
GROUP BY SC.SID
ORDER BY Score DESC;

/*17.Query all students' points for all courses and average points, descending*/
SELECT SC.*, t.Avg_Score
FROM SC LEFT JOIN
(SELECT SID, Round(Avg(Score), 1) AS Avg_Score FROM SC GROUP BY SID) AS t
ON SC.SID = t.SID
ORDER BY 4 DESC;

/*18.Query for all kinds of rate (version 1)*/
SELECT SC.CID, Count(*) AS ClassSize, 
Max(SC.Score) AS Max, Min(SC.Score) AS Min, Round(Avg(SC.Score), 1) AS AvgS,
Round(Cast(Sum(CASE WHEN SC.Score >= 60 THEN 1 ELSE 0 END) AS Float) / Count(*), 2) AS PassRate,  
Round(Cast(Sum(CASE WHEN SC.Score BETWEEN 70 AND 79 THEN 1 ELSE 0 END) AS Float) / Count(*), 2) AS MediumRate,
Round(Cast(Sum(CASE WHEN SC.Score BETWEEN 80 AND 89 THEN 1 ELSE 0 END) AS Float) / Count(*), 2) AS GoodRate,
Round(Cast(Sum(CASE WHEN SC.Score >= 90 THEN 1 ELSE 0 END) AS Float) / Count(*), 2) AS ExcellentRate
FROM SC
GROUP BY 1
ORDER BY 1 ASC;

/*19. Order by score of each course, giving the rank, which remains when two scores are equal*/
SELECT SC.CID, SC.SID, SC.Score, t.Rank
FROM SC LEFT JOIN (SELECT SID, CID, (SELECT COUNT(*) + 1 
FROM SC t2 WHERE t2.Score > t1.Score AND t2.CID = t1.CID)
AS Rank FROM SC t1) t
ON SC.SID = t.SID
AND SC.CID = t.CID
ORDER BY 1, 3 DESC;

/*20. Order by score of each course, giving the rank, which merges when two scores are equal*/
SELECT SC.CID, SC.SID, SC.Score, t.Rank
FROM SC LEFT JOIN (SELECT SID, CID, (SELECT COUNT(DISTINCT t2.Score) + 1 
FROM SC t2 WHERE t2.Score > t1.Score AND t2.CID = t1.CID)
AS Rank FROM SC t1) t
ON SC.SID = t.SID
AND SC.CID = t.CID
ORDER BY 1, 3 DESC;

/*21.Query student's total scores, ranking and remaining when two scores are equal*/
SELECT t1.*, COUNT(t2.SID) AS Rank
FROM (SELECT SID, SUM(Score) AS Sum_Score 
FROM SC GROUP BY 1) t1, (SELECT SID, SUM(Score) 
AS Sum_Score FROM SC GROUP BY 1) t2
WHERE t2.Sum_Score >= t1.Sum_Score
GROUP BY 1
ORDER BY Rank;

/*22.Query student's total scores, ranking and merging when two scores are equal*/
SELECT t1.*, COUNT(DISTINCT t2.SID) AS Rank
FROM (SELECT SID, SUM(Score) AS Sum_Score 
FROM SC GROUP BY 1) t1, (SELECT SID, SUM(Score) 
AS Sum_Score FROM SC GROUP BY 1) t2
WHERE t2.Sum_Score >= t1.Sum_Score
GROUP BY 1
ORDER BY Rank;

/*23.Query for all kinds of rate (version 2)*/
SELECT Course.CID, CName,
Round(Cast(Sum(CASE WHEN Score <= 60 THEN 1 ELSE 0 END) AS Float) / Count(*), 2) AS FailRate,  
Round(Cast(Sum(CASE WHEN Score BETWEEN 60 AND 69 THEN 1 ELSE 0 END) AS Float) / Count(*), 2) AS MediumRate,
Round(Cast(Sum(CASE WHEN Score BETWEEN 70 AND 84 THEN 1 ELSE 0 END) AS Float) / Count(*), 2) AS GoodRate,
Round(Cast(Sum(CASE WHEN Score >= 85 THEN 1 ELSE 0 END) AS Float) / Count(*), 2) AS ExcellentRate
FROM SC, Course
WHERE Course.CID = SC.CID
GROUP BY 1
ORDER BY 1 ASC;

/*24.Query top 3 for each course*/
SELECT CID, SID, Score
FROM SC AS t1
WHERE (SELECT Count(*) FROM SC AS t2 WHERE t1.CID = t2.CID AND t2.Score > t1.Score) < 3
ORDER BY 1, 3 DESC;

/*25.Query the class size for each course*/
SELECT CName, Count(*) AS ClassSize
FROM Course, SC
WHERE Course.CID = SC.CID
GROUP BY 1;

/*26.Query student's IDs and names if one just takes two courses*/
SELECT Student.SID, SName
FROM Student, SC
WHERE Student.SID = SC.SID
GROUP BY 1
HAVING COUNT(*) = 2;

/*27.Query numbers of male and female*/
/*Solution1 (w/ CASE)*/
SELECT SUM(CASE WHEN SSEX ='男' THEN 1 ELSE 0 END) AS Count_Male,
SUM(CASE WHEN SSEX ='女' THEN 1 ELSE 0 END) AS Count_Female
FROM Student;
/*Solution2 (w/o CASE)*/
SELECT SSex, COUNT(*)
FROM Student
GROUP BY SSex;

/*28.Query student's info if one's name contain 风*/
SELECT *
FROM Student
WHERE SName LIKE '%风%';

/*29.Query student's info if one has counterpart with the same name*/
SELECT *
FROM Student LEFT JOIN (SELECT SName, COUNT(*) AS Num 
FROM Student GROUP BY SName) AS t1
ON Student.SName = t1.SName
WHERE t1.Num > 1;

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
SELECT Student.SName, SC.CID, SC.Score
FROM Student LEFT JOIN SC
ON Student.SID = SC.SID;

/*35.Query its course name, student name and score if any score higher than 70 */
SELECT CName, SName, Score
FROM Course, Student, SC
WHERE Score > 70
AND Course.CID = SC.CID
AND Student.SID = SC.SID;

/*36.Query failed course*/
SELECT DISTINCT Course.*
FROM Course, SC
WHERE Score < 60
AND Course.CID = SC.CID;

/*37.Query student's IDs and names if scored over 80 in course 01*/
SELECT SC.SID, SName
FROM Student, SC
WHERE CID = '01'
AND Student.SID = SC.SID
AND Score >= 80;

/*38.Query class size for each course*/
SELECT Course.*, COUNT(*) AS Class_Size
FROM SC, Course
WHERE Course.CID = SC.CID
GROUP BY 1;

/*39.Query top 1 student's info and score in course taught by 张三 (no equal scores)*/
SELECT Student.*, SC.Score
FROM Student, Course, Teacher, SC
WHERE Student.SID = SC.SID
AND SC.CID = Course.CID
AND Course.TID = Teacher.TID
AND Teacher.TName = '张三'
ORDER BY SC.Score DESC LIMIT 1;

/*40.Query top 1 student's info and score in course taught by 张三 (included equal scores)*/
SELECT Student.*, t1.Score
FROM Student, Course, Teacher, SC AS t1
WHERE Student.SID = t1.SID
AND t1.CID = Course.CID
AND Course.TID = Teacher.TID
AND Teacher.TName = '张三'
AND (SELECT Count(*) FROM SC AS t2 WHERE t1.CID = t2.CID AND t2.Score > t1.Score) = 0;

/*41.Query student's SID, CID and Score if ones have same score for different courses*/
SELECT t1.*
FROM SC t1 INNER JOIN SC t2
ON t1.SID = t2.SID
AND t1.CID != t2.CID
AND t1.Score = t2.Score
GROUP BY t1.SID, t1.CID;

/*42.Query top 2 for each course*/
SELECT *
FROM SC AS t1
WHERE (SELECT Count(*) FROM SC AS t2 WHERE t1.CID = t2.CID AND t2.Score > t1.Score) < 2
ORDER BY t1.CID, t1.Score DESC;

/*43.Query class size for each course (at least 5)*/
SELECT Course.CID, Course.CName, Count(*) AS Class_Size
FROM SC, Course
WHERE Course.CID = SC.CID
GROUP BY SC.CID
HAVING Class_Size > 5;

/*44.Query student's info if one takes more than two courses*/
SELECT SID, Count(*) AS ClassNum
FROM SC
GROUP BY SID
HAVING ClassNum >= 2;

/*45.Query student's info if one takes all courses*/
SELECT Student.*
FROM Student, SC
WHERE Student.SID = SC.SID
GROUP BY SC.SID
HAVING COUNT(*) = (SELECT Count(*) FROM Course);

/*46-50.Time related problems*/
SELECT Student.SName, (date('now') - SAge) AS Age
FROM Student;

SELECT *
FROM Student
WHERE Strftime('%W', 'Now') = Strftime('%W', SAge);

SELECT *
FROM Student
WHERE Strftime('%m', Date('Now')) = Strftime('%m', Sage);

SELECT *
FROM Student
WHERE Strftime('%W', Date('Now')) = Strftime('%W',SAge) - 1;

SELECT *
FROM Student
WHERE Strftime('%m', Date('Now')) = Strftime('%m', Sage) - 1;
