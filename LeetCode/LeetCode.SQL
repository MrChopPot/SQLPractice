/* Easy */

/* 1. Combine Two Tables */
SELECT FirstName, LastName, City, State
FROM Person
LEFT JOIN Address
USING(PersonId);
/* https://stackoverflow.com/questions/11366006/mysql-on-vs-using */

/* 2. Second Highest Salary */
SELECT MAX(Salary) AS SecondHighestSalary
FROM Employee
WHERE Salary < (SELECT MAX(Salary) FROM Employee);
/* This method can be promoted to other scenarios */

/* 3. Employees Earning More Than Their Managers */
SELECT e1.NAME AS Employee
FROM Employee e1, Employee e2
WHERE e1.ManagerId = e2.Id
AND e1.Salary > e2.Salary;

/* 4. Duplicate Emails */
SELECT DISTINCT p1.Email
FROM Person p1, Person p2
WHERE p1.Email = p2.Email
AND p1.Id < p2.Id;

/* 5. Customers Who Never Order */
SELECT FirstName, LastName, City, State
FROM Person
LEFT JOIN Address
USING(PersonId);

/* 6. Delete Duplicate Emails */
DELETE p1
FROM Person p1, Person p2
WHERE p1.Email = p2.Email 
AND p1.Id > p2.Id;

/* 7. Rising Temperature */
SELECT w1.Id
FROM Weather w1, Weather w2
WHERE TO_DAYS(w1.RecordDate) - TO_DAYS(w2.RecordDate) = 1
AND w1.Temperature > w2.Temperature;
/* TO_DAYS */

/* 8. Employee Bonus */
SELECT name, bonus
FROM Employee e LEFT JOIN Bonus b
USING(empid)
WHERE bonus < 1000 OR bonus IS NULL;

/* 9. Find Customer Referee */
SELECT name 
FROM customer 
WHERE referee_id != 2 
OR referee_id IS NULL;

/* 10. Customer Placing the Largest Number of Orders */
SELECT customer_number
FROM orders
GROUP BY 1
ORDER BY COUNT(*) DESC
LIMIT 1;

/* 11. Big Countries */
SELECT name, population, area
FROM world
WHERE population > 25000000
OR area > 3000000;

/* 12. Classes More Than 5 Students */
SELECT class
FROM courses
GROUP BY 1
HAVING COUNT(DISTINCT student) >= 5;

/* 13. Friend Requests I: Overall Acceptance Rate (Star) */
SELECT COALESCE(ROUND(COUNT(DISTINCT requester_id, accepter_id) 
    / COUNT(DISTINCT sender_id, send_to_id), 2), 0) 
AS accept_rate
FROM friend_request, request_accepted
/* COALESCE, COUNT (DISTINCT Col1, Col2) */

/* 14. Consecutive Available Seats (Star) */
SELECT DISTINCT c1.seat_id
FROM cinema c1 INNER JOIN cinema c2
ON ABS(c1.seat_id - c2.seat_id) = 1
AND c1.free = 1
AND c2.free = 1
ORDER BY 1;
/* JOIN ON other conditions, could also be done w/o JOIN; 1 for True */

/* 15. Sales Person */
SELECT name
FROM salesperson s
WHERE s.sales_id NOT IN
(SELECT o.sales_id 
    FROM orders o, company c 
    WHERE o.com_id = c.com_id 
    AND c.name = 'RED');

/* 16. Triangle Judgement */
SELECT *, IF(x + y > z AND x + z > y AND y + z > x, 
    'Yes', 'No') AS triangle 
FROM triangle;

/* 17. Shortest Distance in a Line */
SELECT MIN(ABS(p1.x - p2.x)) AS shortest
FROM point p1 INNER JOIN point p2 
ON p1.x != p2.x;
/* JOIN ON other conditions */

/* 18. Biggest Single Numbe */
SELECT MAX(num) AS num
FROM (SELECT num FROM number 
    GROUP BY 1
    HAVING COUNT(1) = 1) AS t;

/* 19. Not Boring Movies */
SELECT *
FROM cinema
WHERE id % 2 = 1
AND description != "boring"
ORDER BY rating DESC；

/* 20. Swap Salary */
UPDATE salary
SET sex = CASE sex 
WHEN 'm' THEN 'f' 
ELSE 'm' END;
/* Good use of SET & CASE */


/* Medium */

/* 31. Nth Highest Salary (Star) */
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
DECLARE start INT unsigned DEFAULT N - 1;
RETURN (SELECT Salary FROM Employee 
    GROUP BY salary ORDER BY Salary DESC LIMIT start, 1);
END;
/* Create function */

/* 32. Rank Scores */
SELECT s1.Score, COUNT(DISTINCT s2.Score) AS Rank
FROM Scores s1, (SELECT Score FROM Scores) s2
WHERE s1.Score <= s2.Score
GROUP BY s1.Id, s1.Score
ORDER BY 1 DESC;

/* 33. Consecutive Numbers */
SELECT DISTINCT l1.Num AS ConsecutiveNums 
FROM Logs l1, Logs l2, Logs l3 
WHERE l1.Id = l2.Id-1 
AND l2.Id = l3.Id-1 
AND l1.Num = l2.Num 
AND l2.Num = l3.Num;
/* This just need the total number, so the solution could be simple */

/* 34. Department Highest Salary */
SELECT d.Name AS Department, e.Name AS Employee, Salary
FROM Employee e, Department d, 
(SELECT DepartmentId, Max(Salary) AS max FROM Employee GROUP BY 1) t
WHERE e.DepartmentId = d.Id
AND t.DepartmentId = e.DepartmentId
AND Salary = t.max;

/* 35. Managers with at Least 5 Direct Reports */
SELECT Name
FROM Employee t1 INNER JOIN
(SELECT ManagerId 
    FROM Employee 
    GROUP BY ManagerId 
    HAVING COUNT(ManagerId) >= 5) t2
ON t1.Id = t2.ManagerId;

/* 36. Winning Candidate */
SELECT name AS 'Name'
FROM Candidate, (SELECT Candidateid FROM Vote 
    GROUP BY Candidateid ORDER BY COUNT(*) DESC LIMIT 1) AS winner 
WHERE Candidate.id = winner.Candidateid;
/* If there exists multiple 1st */
SELECT name AS 'Name'
FROM Candidate
WHERE id IN (SELECT Candidateid FROM Vote GROUP BY Candidateid
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM Vote GROUP BY Candidateid));

/* 37. Get Highest Answer Rate Question (Star) */
/* Solution 1 */
SELECT question_id as survey_log
FROM
(SELECT question_id,
        SUM(case when action = "answer" THEN 1 ELSE 0 END) as num_answer,
        SUM(case when action = "show" THEN 1 ELSE 0 END) as num_show,    
    FROM survey_log
    GROUP BY 1) as tbl
ORDER BY (num_answer / num_show) DESC
LIMIT 1;
/* Solution 2 */
SELECT question_id AS survey_log
FROM survey_log
GROUP BY 1
ORDER BY COUNT(answer_id) / COUNT(IF(action = "show", 1, 0)) DESC
LIMIT 1;

/* 38. Count Student Number in Departments */
SELECT dept_name, COUNT(student_id) AS student_number
FROM department d LEFT JOIN student s
USING(dept_id)
GROUP BY 1
ORDER BY 2 DESC , 1;

/* 39. Investments in 2016 */
SELECT SUM(insurance.TIV_2016) AS TIV_2016
FROM insurance
WHERE TIV_2015 IN (SELECT TIV_2015 FROM insurance 
    GROUP BY TIV_2015 HAVING COUNT(*) > 1)
AND CONCAT(LAT, LON) IN (SELECT CONCAT(LAT, LON) FROM insurance 
    GROUP BY LAT, LON HAVING COUNT(*) = 1);
/* Using CONCAT to apply the limitation to multiple columns */

/* 40. Friend Requests II: Who Has Most Friend? */
SELECT id, num
FROM (SELECT id, COUNT(*) AS num FROM 
(SELECT requester_id AS id FROM request_accepted 
    UNION ALL 
    SELECT accepter_id AS id FROM request_accepted) idTable
GROUP BY id, num) tempTable
ORDER BY 2 DESC
LIMIT 1;
/* Here exists an assumption that only one top */

/* 41. Tree Node */
SELECT t.id, (CASE t.p_id 
WHEN IS NULL THEN 'Root' 
WHEN t.id IN (SELECT p_id FROM tree) THEN 'Inner'
ELSE 'Leaf' END) AS Type
FROM tree t
ORDER BY 1；

/* 42. Shortest Distance in a Plane */
SELECT ROUND(SQRT(MIN((POW(p1.x - p2.x, 2) + POW(p1.y - p2.y, 2)))),2) AS shortest
FROM point_2d p1 INNER JOIN point_2d p2 
ON (p1.x <= p2.x AND p1.y < p2.y)
OR (p1.x <= p2.x AND p1.y > p2.y)
OR (p1.x < p2.x AND p1.y = p2.y);

/* 43. Second Degree Follower */
SELECT f1.follower, COUNT(DISTINCT f2.follower) AS num 
FROM follow f1 INNER JOIN follow f2 
ON f1.follower = f2.followee
GROUP BY 1 
ORDER BY 1;

/* 44. Exchange Seats */
SELECT IF(id < (SELECT COUNT(*) FROM seat), 
    IF(id % 2 = 0, id - 1, id + 1), 
    IF(id % 2 = 0, id - 1, id)) AS id, student
FROM seat
ORDER BY 1;
/* Pay attention to the IFs */


/* Hard */

/* 45. Department Top Three Salaries */
SELECT d.Name AS Department, e1.Name AS Employee, e1.Salary
FROM Employee e1 
INNER JOIN Department d
ON e1.DepartmentId = d.Id
WHERE (SELECT COUNT(DISTINCT e2.Salary) 
                  FROM Employee e2 
                  WHERE e2.Salary > e1.Salary 
                  AND e1.DepartmentId = e2.DepartmentId) < 3 /* N */
ORDER BY e1.DepartmentId, 3 DESC;
/* Classic method to get the top N of each group */

/* 46. Trips and Users */
SELECT t.Request_at AS Day, 
ROUND(COUNT(CASE t.Status WHEN "completed" THEN NULL ELSE 1 END) / COUNT(*), 2)
AS 'Cancellation Rate'
FROM Trips t INNER JOIN Users u
ON u.Users_id = t.Client_id
WHERE u.Banned = "No"
AND t.Request_at BETWEEN '2013-10-01' AND '2013-10-03' /* Here Request_at is Datetime */
GROUP BY 1
/* Here you can use INNER JOIN + ON or , + AND */

/* 47. Median Employee Salary (Star) */
SELECT e1.Id, e1.Company, e1.Salary
FROM Employee e1, Employee e2
WHERE e1.Company = e2.Company
GROUP BY e1.Company, e1.Salary
HAVING SUM(CASE WHEN e1.Salary = e2.Salary THEN 1 
    ELSE 0 END) >= ABS(SUM(SIGN(e1.Salary - e2.Salary)))
ORDER BY 1;
/* Find median! SIGN: 1 if >0, 0 if 0, -1 if <0 */

/* 48. Find Median Given Frequency of Numbers (Star) */
SELECT AVG(Number) AS median 
FROM (SELECT Number, Frequency, AccFreq, SumFreq 
    FROM (SELECT Number, Frequency, @curFreq := @curFreq + Frequency AS AccFreq
        FROM Numbers n, (SELECT @curFreq := 0) r ORDER BY 1) t1, 
        (SELECT SUM(Frequency) AS SumFreq FROM Numbers) t2) t
WHERE AccFreq BETWEEN SumFreq / 2 AND SumFreq / 2 + Frequency

/* 49. Find Cumulative Salary of an Employee (Star) */
SELECT E1.id, E1.month,
    (IFNULL(E1.salary, 0) + IFNULL(E2.salary, 0) + IFNULL(E3.salary, 0)) AS Salary
FROM (SELECT id, MAX(month) AS month FROM Employee GROUP BY id
    HAVING COUNT(*) > 1) AS maxmonth
        LEFT JOIN
    Employee E1 ON (maxmonth.id = E1.id
        AND maxmonth.month > E1.month)
        LEFT JOIN
    Employee E2 ON (E2.id = E1.id
        AND E2.month = E1.month - 1)
        LEFT JOIN
    Employee E3 ON (E3.id = E1.id
        AND E3.month = E1.month - 2)
ORDER BY 1, 2 DESC;

/* 50. Human Traffic of Stadium */
SELECT s1.* 
FROM stadium AS s1, stadium AS s2, stadium AS s3
 WHERE 
 ((s1.id + 1 = s2.id
 AND s1.id + 2 = s3.id)
 OR 
 (s1.id - 1 = s2.id
 AND s1.id + 1 = s3.id)
 OR
 (s1.id - 2 = s2.id
 AND s1.id - 1 = s3.id))
 AND s1.people >= 100 
 AND s2.people >= 100
 AND s3.people >= 100
GROUP BY s1.id;
/* Output all the info that meets the requirement (So not only s1.id) */

/* 51. Average Salary: Departments VS Company */
SELECT pay_month, department_id,
CASE
  WHEN department_avg > company_avg THEN 'higher'
  WHEN department_avg < company_avg THEN 'lower'
  ELSE 'same'
END AS comparison
FROM
(
  SELECT DATE_FORMAT(pay_date, '%Y-%m') AS pay_month, department_id, AVG(amount) AS department_avg
  FROM salary s, employee e WHERE s.employee_id = e.employee_id
  GROUP BY 1, 2
) AS ds
INNER JOIN
(
  SELECT DATE_FORMAT(pay_date, '%Y-%m') AS pay_month, AVG(amount) AS company_avg
  FROM salary 
  GROUP BY 1
) AS cs
USING(pay_month);
/* DATE_FORMAT gets the month, complex JOIN */

/* 52. Students Report By Geography (Star) */
SELECT 
    America, Asia, Europe
FROM
    (SELECT @am := 0, @as := 0, @eu := 0) t, /* INIT */
    (SELECT 
        @am := @am + 1 AS amid, name AS America
    FROM
        student
    WHERE
        continent = 'America'
    ORDER BY America) t1
        LEFT JOIN
    (SELECT 
        @as := @as + 1 AS asid, name AS Asia
    FROM
        student
    WHERE
        continent = 'Asia'
    ORDER BY Asia) t2 
    ON asid = amid
        LEFT JOIN
    (SELECT 
        @eu := @eu + 1 AS euid, name AS Europe
    FROM
        student
    WHERE
        continent = 'Europe'
    ORDER BY Europe) t3 
    ON amid = euid;


