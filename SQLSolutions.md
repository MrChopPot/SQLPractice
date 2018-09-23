/*Q1: 查询" 01 "课程比" 02 "课程成绩高的学生的信息及课程分数*/

SELECT Student.*, t1.Score AS Score01, t2.Score AS Score02
FROM ((SELECT SID, SC.Score FROM SC WHERE CID = '01') AS t1 
INNER JOIN(SELECT SID, SC.Score FROM SC WHERE CID = '02') AS t2 
ON t1.SID = t2.SID AND t1.Score > t2.Score), Student
WHERE t1.SID = Student.SID

/*Q2: 查询同时存在"01"课程和"02"课程的情况*/

SELECT Student.*, t1.Score AS Score01, t2.Score AS Score02
FROM ((SELECT SID, SC.Score FROM SC WHERE CID = '01') AS t1 
INNER JOIN(SELECT SID, SC.Score FROM SC WHERE CID = '02') AS t2 
ON t1.SID = t2.SID), Student
WHERE t1.SID = Student.SID

/*Q3: 查询存在"01"课程但可能不存在"02"课程的情况（不存在时显示为 null）*/

SELECT Student.*, t1.Score AS Score01, t2.Score AS Score02
FROM ((SELECT SID, SC.Score FROM SC WHERE CID = '01') AS t1 
LEFT JOIN(SELECT SID, SC.Score FROM SC WHERE CID = '02') AS t2 
ON t1.SID = t2.SID), Student
WHERE t1.SID = Student.SID

/*Q4: 查询不存在" 01 "课程但存在" 02 "课程的情况*/

SELECT Student.*, SC.Score AS Score
FROM SC, Student
WHERE SC.SID not in (SELECT SID FROM SC WHERE SC.CID='01')
AND SC.CID='02'
AND SC.SID = Student.SID

/*Q5: 查询平均成绩大于等于 60 分的同学的学生编号，学生姓名和平均成绩*/

SELECT Student.*, AvgS
FROM Student INNER JOIN(
SELECT SID ,Round(Avg(Score), 1) AS AvgS
FROM SC 
GROUP BY SID
HAVING Avg(Score) >= 60) AS t1
ON Student.SID = t1.SID

/*Q6: 查询在 SC 表存在成绩的学生信息*/

SELECT Distinct Student.*
FROM (Student INNER JOIN SC ON Student.SID = SC.SID) AS t1
WHERE SC.Score is not NULL

/*Q7: 查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩(没成绩的显示为Null)*/

SELECT SID, SName, ClassSum, ScoreSum
FROM Student, (SELECT SID, Count(*) AS ClassSum, Sum(Score) AS ScoreSum 
FROM SC GROUP BY SID) AS t1
WHERE Student.SID = t1.SID

/*Q8: 查有成绩的学生信息*/

SELECT *
FROM Student
WHERE Exists(SELECT * FROM SC WHERE Student.SID = SC.SID)

/*Q9: 查询「李」姓老师的数量*/

SELECT Count(*)
FROM Teacher
WHERE TName Like '李%'

/*Q10: 查询学过「张三」老师授课的同学的信息*/

/*Solution1*/
SELECT *
FROM Student WHERE SID in 
(SELECT SID FROM SC WHERE CID in 
(SELECT CID FROM Course WHERE TID in 
(SELECT TID FROM Teacher WHERE Teacher.TName = '张三')))

/*Solution2*/
SELECT Student.*
FROM Student, Course, Teacher, SC
WHERE Teacher.TName = '张三'
AND Teacher.TID = Course.TID
AND Course.CID = SC.CID
AND SC.SID = Student.SID

/*Q11: 查询没有学全所有课程的同学的信息*/

/*Solution1*/
SELECT *
FROM Student
WHERE SID not in (SELECT SID FROM SC
GROUP BY SID
Having Count(CID) is not 
(SELECT DISTINCT Count(*) FROM Course))

/*Solution2*/
SELECT DISTINCT Student.*
FROM (SELECT Student.SID, Course.CID
FROM Student, Course) AS t1 LEFT JOIN 
(SELECT SC.SID, SC.CID FROM SC) AS t2 
ON t1.SID = t2.SID AND t1.CID = t2.CID, Student
WHERE t2.SID is NULL
AND t1.SID = Student.SID

/*Q12: 查询至少有一门课与学号为"01"的同学所学相同的同学的信息*/
/*Solution1*/
SELECT *
FROM Student
WHERE SID in (SELECT SID FROM SC
WHERE SC.CID in (SELECT CID FROM SC
WHERE SID = '01'))

/*Solution2*/
SELECT Student.*
FROM Student, SC
WHERE SC.CID in (SELECT CID FROM SC
WHERE SID = '01'))
AND Student.SID = SC.SID

/*Q13: 查询和"01"号的同学学习的课程完全相同的其他同学的信息*/

SELECT *
FROM Student 
WHERE Student.SID not in (
SELECT t1.SID
FROM
(SELECT Student.SID, t.CID
FROM Student, (SELECT CID FROM SC WHERE SID = '01') AS t ) AS t1 
LEFT JOIN SC ON t1.SID = SC.SID AND t1.CID = SC.CID
WHERE SC.CID is NULL)
AND Student.SID != '01'

/*Q14: 查询没学过"张三"老师讲授的任一门课程的学生姓名*/

SELECT Student.SName
FROM Student
WHERE Student.SID not in
(SELECT SC.SID
FROM Course, Teacher, SC
WHERE Teacher.TName = '张三'
AND Course.TID = Teacher.TID
AND SC.CID = Course.CID)

/*Q15: 查询两门及以上不及格课程的同学的学号，姓名及其平均成绩*/
SELECT Student.SID, Student.SName, Round(Avg(SC.Score),1) AS AvgS
FROM Student, SC
WHERE SC.SID = Student.SID
AND SC.Score < 60
GROUP BY SC.SID
HAVING Count(*) >= 2

/*Q16: 检索"01"课程分数小于 60，按分数降序排列的学生信息*/

SELECT Student.*, SC.Score
FROM Student, SC
WHERE SC.CID = '01'
AND SC.Score < 60
AND Student.SID = SC.SID
ORDER BY 2 DESC

/*Q17: 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩*/

SELECT SC.SID, SC.CID, SC.Score, t1.AvgS
FROM SC LEFT JOIN (SELECT SC.SID, Avg(SC.Score) AS AvgS
FROM SC GROUP BY SC.SID) AS t1 ON SC.SID = t1.SID 
ORDER BY t1.AvgS DESC

/*Q18: 查询各科成绩最高分、最低分和平均分：
以如下形式显示：课程ID，课程name，最高分，最低分,平均分，及格率&中等率&优良率
（优秀率：及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90）
要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列*/

SELECT SC.CID, Count(*) AS ClassSize, 
Max(SC.Score) AS Max, Min(SC.Score) AS Min, Round(Avg(SC.Score), 1) AS AvgS,
Round(Cast(Sum(CASE WHEN SC.Score >= 60 THEN 1 ELSE 0 END) AS Float) / Count(*), 2) AS PassRate,  
Round(Cast(Sum(CASE WHEN SC.Score BETWEEN 70 AND 79 THEN 1 ELSE 0 END) AS Float) / Count(*), 2) AS MediumRate,
Round(Cast(Sum(CASE WHEN SC.Score BETWEEN 80 AND 89 THEN 1 ELSE 0 END) AS Float) / Count(*), 2) AS GoodRate,
Round(Cast(Sum(CASE WHEN SC.Score >= 90 THEN 1 ELSE 0 END) AS Float) / Count(*), 2) AS ExcellentRate
FROM SC
GROUP BY CID
ORDER BY Count(*) DESC, CID ASC

/*Q23: 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比*/

SELECT Course.CID, Course.CName,
Round(Cast(Sum(CASE WHEN SC.Score <= 60 THEN 1 ELSE 0 END) AS Float) / Count(*), 2) AS FailRate,  
Round(Cast(Sum(CASE WHEN SC.Score BETWEEN 60 AND 69 THEN 1 ELSE 0 END) AS Float) / Count(*), 2) AS MediumRate,
Round(Cast(Sum(CASE WHEN SC.Score BETWEEN 70 AND 84 THEN 1 ELSE 0 END) AS Float) / Count(*), 2) AS GoodRate,
Round(Cast(Sum(CASE WHEN SC.Score >= 85 THEN 1 ELSE 0 END) AS Float) / Count(*), 2) AS ExcellentRate
FROM SC, Course
WHERE Course.CID = SC.CID
GROUP BY Course.CID
ORDER BY Course.CID ASC

/*Q24: 查询各科成绩前三名的记录*/

SELECT *
FROM SC AS t1
WHERE (SELECT Count(*) FROM SC AS t2 WHERE t1.CID = t2.CID AND t2.Score > t1.Score) < 3
ORDER BY t1.CID, t1.Score DESC

/*Q25: 查询每门课程被选修的学生数*/

SELECT Course.CName, Count(SC.Score) AS ClassSize
FROM Course, SC
WHERE Course.CID = SC.CID
GROUP BY CName

/*Q26: 查询出只选修两门课程的学生学号和姓名*/

SELECT Student.SID, Student.SName
FROM Student, SC
WHERE Student.SID = SC.SID
GROUP BY SC.SID
HAVING Count(*) = 2

/*Q27: 查询男生、女生人数*/

SELECT Count(*) AS CountT, Count(Case When SSex = '男' THEN SSex END) AS CountM, 
Count(Case When SSex = '女' THEN SSex END) AS CountF
FROM Student

/*Q28: 查询名字中含有「风」字的学生信息*/

SELECT *
FROM Student
WHERE SName Like '%风%'

/*Q30: 查询 1990 年出生的学生名单*/

SELECT *
FROM Student
WHERE SAge Like '1990%'

/*Q31: 查询每门课程的平均成绩，降序排列；平均成绩相同时，按课程编号升序排列*/

SELECT CID, Round(Avg(Score), 1) AS AvgS
FROM SC
GROUP BY 1
ORDER BY 2 DESC, 1

/*Q32: 查询平均成绩大于等于 85 的所有学生的学号、姓名和平均成绩*/

SELECT Student.SName, Student.SID, t.AvgS
FROM Student INNER JOIN
(SELECT SID, Round(Avg(Score), 1) AS AvgS FROM SC
GROUP BY 1 HAVING AvgS >= 85 ) AS t
ON Student.SID = t.SID

/*Q33: 查询课程名称为「数学」，且分数低于 60 的学生姓名和分数*/

SELECT Student.SName, t.Score
FROM Student INNER JOIN
(SELECT SC.SID, SC.Score FROM Course, SC 
WHERE Course.CName = '数学' AND Course.CID = SC.CID) AS t
ON Student.SID = t.SID
GROUP BY 1
HAVING t.Score < 60

/*Q34: 查询所有学生的课程及分数情况（存在学生没成绩，没选课的情况）*/

SELECT Student.SName, SC.CID, SC.Score
FROM Student, SC
WHERE Student.SID = SC.SID

/*Q35: 查询任何一门课程成绩在 70 分以上的姓名、课程名称和分数*/

SELECT Student.SName, Course.CName, SC.Score
FROM Student, Course, SC
WHERE SC.Score > 70
AND Course.CID = SC.CID
AND Student.SID = SC.SID

/*Q36: 查询不及格的课程*/

SELECT DISTINCT Course.CName, Count(SC.Score) AS Num
FROM Course, SC
WHERE Course.CID = SC.CID
AND SC.Score < 60
GROUP BY 1

/*Q37: 查询课程编号为“01”且课程成绩在80分以上的学生的学号和姓名*/

SELECT Student.SID, Student.SName
FROM Student, SC
WHERE Student.SID = SC.SID
AND SC.CID = '01'
AND SC.Score >= 80

/*Q38: 求每门课程的学生人数*/

SELECT Course.CID, Course.CName, Count(*) AS ClassSize
FROM SC, Course
WHERE Course.CID = SC.CID
GROUP BY SC.CID

/*Q39: 成绩不重复，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩*/

SELECT Student.*, SC.Score
FROM Student, Course, Teacher, SC
WHERE Student.SID = SC.SID
AND SC.CID = Course.CID
AND Course.TID = Teacher.TID
AND Teacher.TName = '张三'
ORDER BY SC.Score DESC LIMIT 1

/*Q40: 成绩有重复的情况下，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩*/

SELECT Student.*, t1.Score
FROM Student, Course, Teacher, SC AS t1
WHERE Student.SID = t1.SID
AND t1.CID = Course.CID
AND Course.TID = Teacher.TID
AND Teacher.TName = '张三'
AND (SELECT Count(*) FROM SC AS t2 WHERE t1.CID = t2.CID AND t2.Score > t1.Score) = 0

/*Q41: 查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩*/

SELECT t1.*
FROM SC t1 INNER JOIN SC t2
ON t1.SID = t2.SID
AND t1.CID != t2.CID
AND t1.Score = t2.Score
GROUP BY t1.SID, t1.CID

/*Q42: 查询每门课成绩最好的前两名*/

SELECT *
FROM SC AS t1
WHERE (SELECT Count(*) FROM SC AS t2 WHERE t1.CID = t2.CID AND t2.Score > t1.Score) < 2
ORDER BY t1.CID, t1.Score DESC

/*Q43: 统计每门课程的学生选修人数（超过 5 人的课程才统计）*/

SELECT Course.CID, Course.CName, Count(*) AS ClassSize
FROM SC, Course
WHERE Course.CID = SC.CID
GROUP BY SC.CID
HAVING ClassSize > 5

/*Q44: 检索至少选修两门课程的学生学号*/

SELECT SID, Count(*) AS ClassNum
FROM SC
GROUP BY SID
HAVING ClassNum >= 2

/*Q45: 查询选修了全部课程的学生信息*/

SELECT Student.*
FROM Student, SC
WHERE Student.SID = SC.SID
GROUP BY SC.SID
HAVING COUNT(*) = (SELECT Count(*) FROM Course)

/*Q46: 查询各学生的年龄，按照出生日期来算，当前月日 < 出生年月的月日，则年龄减一*/

SELECT Student.SName, (date('now') - SAge) AS Age
FROM Student

/*Q47: 查询本周过生日的学生*/

SELECT *
FROM Student
WHERE Strftime('%W', 'Now') = Strftime('%W', SAge)

/*Q48: 查询本月过生日的学生*/

SELECT *
FROM Student
WHERE Strftime('%m', Date('Now')) = Strftime('%m', Sage)

/*Q49: 查询下周过生日的学生*/

SELECT *
FROM Student
WHERE Strftime('%W', Date('Now')) = Strftime('%W',SAge) - 1

/*Q50: 查询下月过生日的学生*/

SELECT *
FROM Student
WHERE Strftime('%m', Date('Now')) = Strftime('%m', Sage) - 1