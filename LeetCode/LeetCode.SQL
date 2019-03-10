/* Easy */

/* 1. Combine Two Tables */
SELECT FirstName, LastName, City, State
FROM Person
LEFT JOIN Address
ON Address.PersonId = Person.PersonId;

/* 2. Second Highest Salary */
SELECT MAX(Salary) As SecondHighestSalary
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
ON Address.PersonId = Person.PersonId;

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
ON e.empid = b.empid
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
ORDER BY a.seat_id;
/* JOIN ON other conditions, 1 for True */

/* 15. Sales Person */
SELECT s.name
FROM salesperson s
WHERE s.sales_id NOT IN 
(SELECT o.sales_id FROM orders o, company c 
WHERE o.com_id = c.com_id AND c.name = 'RED');

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
    GROUP BY num
    HAVING COUNT(num) = 1) AS t;

/* 19. Not Boring Movies */
SELECT *
FROM cinema
WHERE id % 2 = 1
AND description != "boring"
ORDER BY rating DESC；

/* 20. Swap Salary */
UPDATE salary
SET sex = CASE sex 
WHEN 'm' THEN 'f' ELSE 'm' END;


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
ORDER BY s1.Score DESC;

/* 33. Consecutive Numbers */
Select DISTINCT l1.Num AS ConsecutiveNums 
from Logs l1, Logs l2, Logs l3 
where l1.Id=l2.Id-1 and l2.Id=l3.Id-1 
and l1.Num=l2.Num and l2.Num=l3.Num;
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
FROM Employee AS t1 JOIN
(SELECT ManagerId FROM Employee GROUP BY ManagerId 
    HAVING COUNT(ManagerId) >= 5) AS t2
ON t1.Id = t2.ManagerId;

/* 36. Winning Candidate */
SELECT name AS 'Name'
FROM Candidate JOIN (SELECT Candidateid FROM Vote 
    GROUP BY Candidateid ORDER BY COUNT(*) DESCLIMIT 1) AS winner 
WHERE Candidate.id = winner.Candidateid;

/* 37. Get Highest Answer Rate Question */
SELECT question_id AS 'survey_log'
FROM survey_log
GROUP BY question_id
ORDER BY COUNT(answer_id) / COUNT(IF(action = 'show', 1, 0)) DESC
LIMIT 1;

/* 38. Count Student Number in Departments */
SELECT dept_name, COUNT(student_id) AS student_number
FROM department d LEFT JOIN student s
ON d.dept_id = s.dept_id
GROUP BY d.dept_name
ORDER BY student_number DESC , d.dept_name;

/* 39. Investments in 2016 */


/* 40. Friend Requests II: Who Has Most Friend? */


/* 41. Tree Node */
SELECT t.id, (CASE t.p_id 
WHEN IS NULL THEN 'Root' 
WHEN t.id IN (SELECT p_id FROM tree) THEN 'Inner'
ELSE 'Leaf' END) AS Type
FROM tree t
ORDER BY t.id；

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
GROUP BY f1.follower 
ORDER BY f1.follower;

/* 44. Exchange Seats */
SELECT IF(id < (SELECT COUNT(*) FROM seat), 
    IF(id % 2 = 0, id - 1, id + 1), 
    IF(id % 2 = 0, id - 1, id)) AS id, student
FROM seat
ORDER BY id;
/* Pay attention to the IFs */


/* Hard */

/* 45. Department Top Three Salaries */
