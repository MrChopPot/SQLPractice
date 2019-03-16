/* Easy */

/* 1. Revising the SELECT Query I */
SELECT *
FROM CITY
WHERE COUNTRYCODE = 'USA'
AND POPULATION > 100000;

/* 2. Revising the SELECT Query II */
SELECT NAME
FROM CITY
WHERE COUNTRYCODE = 'USA'
AND POPULATION > 120000;

/* 3. SELECT All */
SELECT *
FROM CITY;

/* 4. SELECT By ID */
SELECT *
FROM CITY
WHERE ID = 1661; 
/* The type of ID is NUMBER*/

/* 5. Japanese Cities' Attributes */
SELECT *
FROM CITY
WHERE COUNTRYCODE = 'JPN';

/* 6. Japanese Cities' Names */
SELECT NAME
FROM CITY
WHERE COUNTRYCODE = 'JPN';

/* 7. Weather Observation Station 1 */
SELECT CITY, STATE
FROM STATION;

/* 8. Weather Observation Station 3 */
SELECT DISTINCT CITY
FROM STATION
WHERE ID % 2 = 0; /* OperatORs in SQL */

/* 9. Weather Observation Station 4 */
SELECT COUNT(CITY) - COUNT(DISTINCT CITY) 
FROM STATION;
/* The difference among COUNT *, COUNT Col AND COUNT DISTINCT Col */

/* 10. Weather Observation Station 5 */
(SELECT CITY, LENGTH(CITY) AS LEN
FROM STATION
ORDER BY LEN, CITY
LIMIT 1)
UNION
(SELECT CITY, LENGTH(CITY) AS LEN
FROM STATION
ORDER BY LEN DESC, CITY
LIMIT 1);
/* All kinds of JOIN & Set Operation */

/* 11. Weather Observation Station 6 */
SELECT DISTINCT CITY
FROM STATION
WHERE CITY RLIKE '^[aeiou]';

/* 12. Weather Observation Station 7 */
SELECT DISTINCT CITY
FROM STATION
WHERE CITY RLIKE '[aeiou]$';

/* 13. Weather Observation Station 8 */
SELECT DISTINCT CITY
FROM STATION
WHERE CITY RLIKE '^[aeiou]'
AND CITY RLIKE '[aeiou]$';

/* 14. Weather Observation Station 9 */
SELECT DISTINCT CITY
FROM STATION
WHERE CITY NOT RLIKE '^[aeiou]';

/* 15. Weather Observation Station 10 */
SELECT DISTINCT CITY
FROM STATION
WHERE CITY NOT RLIKE '[aeiou]$';

/* 16. Weather Observation Station 11 */
SELECT DISTINCT CITY
FROM STATION
WHERE CITY NOT RLIKE '^[aeiou]'
OR CITY NOT RLIKE '[aeiou]$';

/* 17. Weather Observation Station 12 */
SELECT DISTINCT CITY
FROM STATION
WHERE CITY NOT RLIKE '^[aeiou]'
AND CITY NOT RLIKE '[aeiou]$';

/* 11-17: RLIKE (MYSQL) & RegEx */

/* 18. Higher Than 75 Marks */
SELECT Name
FROM STUDENTS
WHERE Marks > 75
ORDER BY RIGHT(Name, 3), ID;
/* RIGHT */

/* 19. Employee Names */
SELECT name
FROM Employee
ORDER BY name;

/* 20. Employee Salaries */
SELECT name
FROM Employee
WHERE months < 10
AND salary > 2000;

/* 21. Type of Triangle */
SELECT (CASE 
        WHEN NOT (a + b > c AND b + c > a AND c + a > b) THEN "Not A Triangle"
        WHEN a = b AND b = c THEN "Equilateral"
        WHEN a = b OR b = c OR c = a THEN "Isosceles"
ELSE "Scalene" END) FROM Triangles;


/* 22. Revising Aggregations - The COUNT Function */
SELECT COUNT(*)
FROM CITY
WHERE POPULATION > 100000;

/* 23. Revising Aggregations - The SUM Function */
SELECT SUM(POPULATION)
FROM CITY
WHERE DISTRICT = "CAlifornia";

/* 24. Revising Aggregations - Averages */
SELECT AVG(POPULATION)
FROM CITY
WHERE DISTRICT = "California"; 

/* 25. Average Population */
SELECT ROUND(AVG(POPULATION), 0)
FROM CITY;

/* 26. Japan Population */
SELECT SUM(POPULATION)
FROM CITY
WHERE COUNTRYCODE = "JPN";

/* 27. Population Density Difference */
SELECT MAX(POPULATION) - MIN(POPULATION)
FROM CITY;

/* 28. The Blunder */
SELECT CEILING(AVG(SALARY) - AVG(REPLACE(SALARY,'0',''))) 
FROM Employees;
/* CEILING, REPLACE */

/* 29. Top Earners (Star) */
SELECT (salary * months) AS earnings, COUNT(*) 
FROM Employee 
GROUP BY 1 
ORDER BY earnings DESC 
LIMIT 1;
/* What if there is more than 1 top earners? */
SELECT MAX(salary * months) AS earnings, COUNT(*) 
FROM Employee 
WHERE salary * months = (SELECT MAX(salary * months) FROM Employee)
GROUP BY salary * months;

/* 30. Weather Observation Station 2 */
SELECT ROUND(SUM(LAT_N), 2) AS LAT, ROUND(SUM(LONG_W), 2) AS LONG
FROM STATION;

/* 31. Weather Observation Station 13 */
SELECT TRUNCATE(SUM(LAT_N), 4)
FROM STATION
WHERE LAT_N BETWEEN 38.788 AND 137.2345;

/* 32. Weather Observation Station 14 */
SELECT TRUNCATE(MAX(LAT_N), 4)
FROM STATION
WHERE LAT_N < 137.2345;

/* 31-32: RLIKE (MYSQL) & RegEx */

/* 33. Weather Observation Station 15 */
SELECT ROUND(LONG_W, 4)
FROM STATION
WHERE LAT_N = (SELECT MAX(LAT_N) FROM STATION WHERE LAT_N < 137.2345);

/* 34. Weather Observation Station 16 */
SELECT ROUND(MIN(LAT_N), 4)
FROM STATION
WHERE LAT_N > 38.778;

/* 35. Weather Observation Station 17 */
SELECT ROUND(LONG_W, 4)
FROM STATION
WHERE LAT_N = (SELECT MIN(LAT_N) FROM STATION WHERE LAT_N > 38.778);

/* 36. Asian Population */
SELECT SUM(CITY.POPULATION)
FROM COUNTRY, CITY
WHERE COUNTRY.CODE = CITY.COUNTRYCODE
AND COUNTRY.CONTINENT = 'Asia';

/* 37. African Cities */
SELECT CITY.NAME
FROM COUNTRY, CITY
WHERE COUNTRY.CODE = CITY.COUNTRYCODE
AND COUNTRY.CONTINENT = 'Africa';

/* 38. Average Population of Each Continent */
SELECT COUNTRY.CONTINENT, FLOOR(AVG(CITY.POPULATION))
FROM CITY, COUNTRY
WHERE COUNTRY.CODE = CITY.COUNTRYCODE
GROUP BY COUNTRY.CONTINENT;
/* FLOOR */

/* 39. Draw The Triangle 1 */
DECLARE @i INT = 20
WHILE (@i > 0) 
BEGIN
   PRINT REPLICATE('* ', @i) 
   SET @i = @i - 1
END;

/* 40. Draw The Triangle 2 */
DECLARE @i INT = 1
WHILE (@i <= 20) 
BEGIN
   PRINT REPLICATE('* ', @i) 
   SET @i = @i + 1
END;

/* 39-40 for MS SQL, but MySQL can also set variables */


/* Medium */

/* 41. The PADS */
SELECT CONCAT(NAME,'(',SUBSTR(OCCUPATION,1,1),')') AS N
FROM OCCUPATIONS
ORDER BY N;

SELECT CONCAT('There are a total of ',COUNT(OCCUPATION),' ',LOWER(OCCUPATION),'s.')
FROM OCCUPATIONS
GROUP BY OCCUPATION
ORDER BY COUNT(OCCUPATION), OCCUPATION;

/* CONCAT (pay attention to the " " inside), SUBSTR, LOWER */

/* 42. Occupations (Star) */
SELECT
    [Doctor], [Professor], [Singer], [Actor]
FROM
(
    SELECT ROW_NUMBER() OVER (PARTITION BY OCCUPATION ORDER BY NAME) [RowNumber], * 
    FROM OCCUPATIONS
) AS tempTable
PIVOT
(
    MAX(NAME) FOR OCCUPATION IN ([Doctor], [Professor], [Singer], [Actor])
) AS pivotTable;

/* PIVOT in MS SQL: ROW_NUMBER() is used to Broaden the table */

/* 43. Binary Tree Nodes */
SELECT N, 
(CASE WHEN P IS NULL THEN 'Root'
WHEN N IN (SELECT P FROM BST) THEN 'Inner'
ELSE 'Leaf' END) AS D
FROM BST
ORDER BY N;

/* 44. New Companies */
SELECT c.company_code, c.founder, 
    COUNT(DISTINCT l.lead_manager_code), COUNT(DISTINCT s.senior_manager_code), 
    COUNT(DISTINCT m.manager_code), COUNT(DISTINCT e.employee_code) 
FROM Company c, Lead_Manager l, Senior_Manager s, Manager m, Employee e 
WHERE c.company_code = l.company_code 
AND l.lead_manager_code = s.lead_manager_code 
AND s.senior_manager_code = m.senior_manager_code 
AND m.manager_code = e.manager_code 
GROUP BY c.company_code /* omit c.founder here is ok*/
ORDER BY c.company_code;
/* Combined query w/o (INNER) JOIN */

/* 45. Weather Observation Station 18 */
SELECT ROUND(ABS(MAX(LAT_N) - MIN(LAT_N)) + ABS(MAX(LONG_W) - MIN(LONG_W)), 4)
FROM STATION;
/* ABS */

/* 46. Weather Observation Station 19 */
SELECT ROUND(SQRT(POWER((MAX(LAT_N) - MIN(LAT_N)), 2) + POWER((MAX(LONG_W) - MIN(LONG_W)), 2)), 4)
FROM STATION;
/* POWER */

/* 47. Weather Observation Station 20 (Star) */
SELECT IF((SELECT MOD(COUNT(LAT_N),2) FROM STATION) = 0,
            (SELECT ROUND(S.LAT_N, 4) Median
                FROM STATION S
                WHERE ((SELECT COUNT(LAT_N) FROM STATION WHERE S.LAT_N > LAT_N) + 1) =
                      (SELECT COUNT(LAT_N) FROM STATION WHERE S.LAT_N < LAT_N)
                    OR
                      (SELECT COUNT(LAT_N) FROM STATION WHERE S.LAT_N > LAT_N) =
                      ((SELECT COUNT(LAT_N) FROM STATION WHERE S.LAT_N < LAT_N) + 1)
             ),
            (SELECT ROUND(S.LAT_N, 4) Median
                FROM STATION S
                WHERE (SELECT COUNT(LAT_N) FROM STATION WHERE S.LAT_N > LAT_N) = 
                      (SELECT COUNT(LAT_N) FROM STATION WHERE S.LAT_N < LAT_N)
             ));
/* Find Median! */

/* 48. The Report (Star) */
SELECT (CASE WHEN g.Grade >= 8 THEN s.Name ELSE NULL END), g.Grade, s.Marks 
FROM Students s INNER JOIN Grades g 
ON s.Marks BETWEEN Min_Mark AND Max_Mark 
ORDER BY g.Grade DESC,s.Name, s.Marks;
/* Quick JOIN on other conditions: could also be done w/o JOIN */

/* 49. Top Competitors */
SELECT
    h.hacker_id
    ,h.name
FROM
    Hackers AS h
    JOIN Submissions AS s ON s.hacker_id = h.hacker_id
    JOIN Challenges AS c ON c.challenge_id = s.challenge_id
    JOIN Difficulty AS d ON d.difficulty_level = c.difficulty_level
WHERE
    s.score = d.score
GROUP BY
    h.hacker_id
    ,h.name
HAVING
    COUNT(1) > 1
ORDER BY
    COUNT(1) DESC
    ,h.hacker_id;
/* Must use JOIN */

/* 50. Ollivander's Inventory */
SELECT w.id, p.age, w.coins_needed, w.power 
FROM WANDs AS w JOIN WANDs_Property AS p 
ON w.code = p.code
WHERE p.is_evil = 0 
AND w.coins_needed = (SELECT MIN(coins_needed) FROM WANDs AS w1 JOIN WANDs_Property AS p1 
                      ON w1.code = p1.code WHERE w1.power = w.power AND p1.age = p.age) 
ORDER BY w.power DESC, p.age DESC
/* Using subquery to get min after GROUP BY */

/* 51. Challenges */
SELECT c.hacker_id, h.name, COUNT(c.hacker_id) AS c_count
FROM Hackers h
    INNER JOIN Challenges c 
    ON c.hacker_id = h.hacker_id
GROUP BY c.hacker_id, h.name
HAVING
    c_count = 
        (SELECT MAX(temp1.cnt)
        FROM (SELECT COUNT(hacker_id) AS cnt
             FROM Challenges
             GROUP BY hacker_id) temp1)
    OR c_count IN
        (SELECT t.cnt
         FROM (SELECT COUNT(*) AS cnt 
               FROM challenges
               GROUP BY hacker_id) t
         GROUP BY t.cnt
         HAVING count(t.cnt) = 1)
ORDER BY c_count DESC, c.hacker_id;

/* 52. Contest Leaderboard */
SELECT h.hacker_id, name, SUM(m_score) AS s_score
FROM Hackers h INNER JOIN 
(SELECT hacker_id, MAX(score) AS m_score FROM Submissions GROUP BY challenge_id, hacker_id) m
USING(hacker_id)
GROUP BY h.hacker_id, name
HAVING s_score > 0
ORDER BY s_score DESC, hacker_id;

/* 53. Projects */
SELECT Start_Date, MIN(End_Date)
FROM 
    (SELECT Start_Date FROM Projects WHERE Start_Date NOT IN (SELECT End_Date FROM Projects)) a,
    (SELECT End_Date FROM Projects WHERE End_Date NOT IN (SELECT Start_Date FROM Projects)) b 
WHERE Start_Date < End_Date
GROUP BY Start_Date 
ORDER BY DATEDIFF(MIN(End_Date), Start_Date), Start_Date;

/* 54. Placements */
SELECT S.Name
FROM Students S, Friends F, Packages P1, Packages P2
WHERE P2.Salary > P1.Salary
AND S.ID = F.ID
AND S.ID = P1.ID
AND F.Friend_ID = P2.ID
ORDER BY P2.Salary;
/* Combine multiple tables */

/* 55. Symmetric Pairs */
SELECT x, y FROM functions f1 
WHERE EXISTS (SELECT * FROM functions f2 
WHERE f2.y = f1.x AND f2.x = f1.y AND f2.x > f1.x) AND (x != y) 
UNION
SELECT x, y FROM functions f1 
WHERE ((SELECT COUNT(*) FROM functions 
WHERE x = f1.x AND y = f1.x) > 1) AND x = y
ORDER BY x;

/* 56. Print Prime Numbers (Star) */
SELECT GROUP_CONCAT(NUMB SEPARATOR '&')
FROM (
    SELECT @num := @num + 1 as NUMB FROM
    information_schema.tables t1,
    information_schema.tables t2,
    (SELECT @num := 1) temp1
) tempNum1
WHERE NUMB <= 1000 AND NOT EXISTS(
        SELECT * FROM (
            SELECT @nu := @nu + 1 AS NUMA FROM
                information_schema.tables t1,
                information_schema.tables t2,
                (SELECT @nu := 1) temp2
                LIMIT 1000
            ) tempNum2
        WHERE FLOOR(NUMB / NUMA) = (NUMB / NUMA) AND NUMA < NUMB AND NUMA > 1
    );

/* Hard */

/* 57. Interviews (Star) */
SELECT con.contest_id,
        con.hacker_id, 
        con.name, 
        SUM(total_submissions), 
        SUM(total_accepted_submissions), 
        SUM(total_views), SUM(total_unique_views)
FROM contests con 
JOIN colleges col ON con.contest_id = col.contest_id 
JOIN challenges cha ON col.college_id = cha.college_id 
LEFT JOIN
(SELECT challenge_id, SUM(total_views) AS total_views, SUM(total_unique_views) AS total_unique_views
FROM view_stats GROUP BY challenge_id) vs ON cha.challenge_id = vs.challenge_id 
LEFT JOIN
(SELECT challenge_id, SUM(total_submissions) AS total_submissions, SUM(total_accepted_submissions) AS total_accepted_submissions FROM submission_stats GROUP BY challenge_id) ss on cha.challenge_id = ss.challenge_id
    GROUP BY con.contest_id, con.hacker_id, con.name
        HAVING SUM(total_submissions)!=0 OR
                SUM(total_accepted_submissions)!=0 OR
                SUM(total_views)!=0 OR
                SUM(total_unique_views)!=0
            ORDER BY contest_id;

/* 58. 15 Days of Learning SQL (Star) */
SELECT
submission_date,

(SELECT COUNT(distinct hacker_id)  
 FROM Submissions s2  
 WHERE s2.submission_date = s1.submission_date AND (SELECT COUNT(distinct s3.submission_date) FROM Submissions s3 
  WHERE s3.hacker_id = s2.hacker_id AND s3.submission_date < s1.submission_date) = dateDIFF(s1.submission_date , '2016-03-01')),

(SELECT hacker_id  FROM submissions s2 where s2.submission_date = s1.submission_date 
GROUP BY hacker_id ORDER BY count(submission_id) DESC , hacker_id LIMIT 1) AS shit,
(SELECT name FROM hackers WHERE hacker_id = shit)
FROM 
(SELECT DISTINCT submission_date FROM submissions) s1;

