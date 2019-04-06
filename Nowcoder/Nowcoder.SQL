/* 1.查找最晚入职员工的所有信息 */

SELECT *
FROM employees
WHERE hire_date = (SELECT MAX(hire_date) FROM employees)

/* 2.查找入职员工时间排名倒数第三的员工所有信息 */

SELECT *
FROM employees
WHERE hire_date = (SELECT hire_date 
                   FROM employees 
                   ORDER BY 1 DESC 
                   LIMIT 2,1)

/* 3.查找各个部门当前领导、当前薪水详情以及其对应部门编号dept_no */

SELECT s.* ,d.dept_no
FROM salaries s, dept_manager d 
WHERE s.emp_no = d.emp_no
AND s.to_date = '9999-01-01'
AND d.to_date='9999-01-01';

/* 4.查找所有已经分配部门的员工的last_name和first_name */

SELECT last_name, first_name, dept_no
FROM employees e, dept_emp d
WHERE e.emp_no = d.emp_no

/* 5.查找所有员工的last_name和first_name以及对应部门编号dept_no，
也包括展示没有分配具体部门的员工 */

SELECT last_name, first_name, dept_no 
FROM employees e
LEFT JOIN dept_emp d
USING(emp_no)

/* 6.查找所有员工入职时候的薪水情况，给出emp_no以及salary，并按照emp_no进行逆序 */

SELECT e.emp_no, salary
FROM employees e, salaries s
WHERE e.emp_no = s.emp_no
AND e.hire_date = s.from_date
ORDER BY 1 DESC

/* 7.查找薪水涨幅超过15次的员工号emp_no以及其对应的涨幅次数t */

SELECT emp_no, COUNT(1) AS t
FROM salaries
GROUP BY 1
HAVING COUNT(1) > 15

/* 8.找出所有员工当前(to_date='9999-01-01')具体的薪水salary情况，
对于相同的薪水只显示一次,并按照逆序显示 */

SELECT DISTINCT salary
FROM salaries
WHERE to_date='9999-01-01'
ORDER BY 1 DESC

/* 9.获取所有部门当前manager的当前薪水情况，给出dept_no, emp_no以及salary */

SELECT dept_no, d.emp_no, salary
FROM dept_manager d, salaries s
WHERE d.to_date = '9999-01-01'
AND s.to_date = '9999-01-01'
AND d.emp_no = s.emp_no
GROUP BY 1, 2

/* 10.获取所有非manager的员工emp_no */

SELECT emp_no
FROM employees
WHERE emp_no NOT IN (SELECT emp_no FROM dept_manager)

/* 11.获取所有员工当前的manager，如果当前的manager是自己的话结果不显示 */

SELECT e.emp_no, m.emp_no AS manager_no
FROM dept_emp e, dept_manager m
WHERE e.to_date = '9999-01-01'
AND m.to_date = '9999-01-01'
AND e.dept_no = m.dept_no
AND e.emp_no != m.emp_no

/* 12.获取所有部门中当前员工薪水最高的相关信息，
给出dept_no, emp_no以及其对应的salary (Star) */

SELECT d.dept_no, d.emp_no, MAX(s.salary) AS salary
FROM dept_emp d, salaries s
WHERE d.emp_no = s.emp_no
AND d.to_date = '9999-01-01'
AND s.to_date = '9999-01-01'
GROUP BY 1

/* 13.从titles表获取按照title进行分组，每组个数大于等于2，
给出title以及对应的数目t */

SELECT title, COUNT(1) AS t
FROM titles
GROUP BY 1
HAVING COUNT(1) >= 2

/* 14.从titles表获取按照title进行分组，每组个数大于等于2，
给出title以及对应的数目t，注意对于重复的emp_no进行忽略 */

SELECT title, COUNT(DISTINCT emp_no) AS t
FROM titles
GROUP BY 1
HAVING t >= 2

/* 15.查找employees表所有emp_no为奇数，且last_name不为Mary的员工信息，
并按照hire_date逆序排列 */

SELECT *
FROM employees
WHERE emp_no % 2 = 1
AND last_name != 'Mary'
ORDER BY hire_date DESC

/* 16.统计出当前各个title类型对应的员工当前薪水对应的平均工资，
结果给出title以及平均工资avg */

SELECT title, AVG(salary) AS avg
FROM salaries s, titles t
WHERE s.emp_no = t.emp_no
AND s.to_date = '9999-01-01'
AND t.to_date = '9999-01-01'
GROUP BY 1

/* 17.获取当前（to_date='9999-01-01'）薪水第二多的员工的emp_no，
以及其对应的薪水salary */

SELECT emp_no, salary
FROM salaries
WHERE to_date = '9999-01-01'
AND salary = (SELECT salary 
              FROM salaries 
              ORDER BY salary DESC 
              LIMIT 1, 1)

/* 18.查找当前薪水(to_date='9999-01-01')排名第二多的员工编号emp_no、
薪水salary、last_name以及first_name，不准使用order by (Star) */

SELECT s.emp_no, MAX(s.salary) AS salary, e.last_name, e.first_name
FROM salaries s, employees e
WHERE s.to_date = '9999-01-01'
AND s.emp_no = e.emp_no
AND s.salary NOT IN (SELECT MAX(salary) 
                     FROM salaries 
                     WHERE to_date = '9999-01-01')

/* 19.查找所有员工的last_name和first_name以及对应的dept_name，
也包括暂时没有分配部门的员工 */

SELECT last_name, first_name, dept_name
FROM employees e LEFT JOIN dept_emp de
ON de.emp_no = e.emp_no
LEFT JOIN departments d
ON d.dept_no = de.dept_no

/* 20.查找员工编号emp_no为10001其自入职以来的薪水salary涨幅值growth */

SELECT ( 
(SELECT salary FROM salaries WHERE emp_no = 10001 
 ORDER BY to_date DESC LIMIT 1) -
(SELECT salary FROM salaries WHERE emp_no = 10001 
 ORDER BY to_date ASC LIMIT 1)
)
AS growth

/* 21.查找所有员工自入职以来的薪水涨幅情况，给出员工编号emp_no，
以及其对应的薪水涨幅growth，并按照growth进行升序 (Star) */

SELECT t1.emp_no, (t1.salary - t2.salary) AS growth
FROM 
(SELECT s.emp_no, s.salary FROM employees e 
    LEFT JOIN salaries s ON e.emp_no = s.emp_no 
    WHERE s.to_date = '9999-01-01') t1
INNER JOIN 
(SELECT s.emp_no, s.salary FROM employees e 
    LEFT JOIN salaries s ON e.emp_no = s.emp_no 
    WHERE s.from_date = e.hire_date) t2
ON t1.emp_no = t2.emp_no
ORDER BY 2

/* 22.统计各个部门对应员工涨幅的次数总和，给出部门编码dept_no、
部门名称dept_name以及次数sum */

SELECT d.dept_no, d.dept_name, COUNT(salary) AS sum
FROM departments d, dept_emp e, salaries s
WHERE d.dept_no = e.dept_no
AND e.emp_no = s.emp_no
GROUP BY 1

/* 23.对所有员工的当前(to_date='9999-01-01')薪水按照salary进行
按照1-N的排名，相同salary并列且按照emp_no升序排列 (Star) */

SELECT s1.emp_no, s1.salary, (COUNT(DISTINCT s2.salary) + 1) AS rank
FROM salaries s1, salaries s2
WHERE s1.to_date = '9999-01-01'
AND s2.to_date = '9999-01-01'
AND s2.salary > s1.salary
GROUP BY 1
ORDER BY 3, 1; -- Wrong one.

SELECT s1.emp_no, s1.salary, COUNT(DISTINCT s2.salary) AS rank
FROM salaries AS s1, salaries AS s2
WHERE s1.to_date = '9999-01-01' 
AND s2.to_date = '9999-01-01' 
AND s1.salary <= s2.salary
GROUP BY s1.emp_no
ORDER BY s1.salary DESC, s1.emp_no ASC; -- Right one.

/* 24.获取所有非manager员工当前的薪水情况，给出dept_no、emp_no以及salary，
当前表示to_date='9999-01-01' */

SELECT dept_no, d.emp_no, salary
FROM dept_emp d, salaries s
WHERE d.to_date = '9999-01-01'
AND s.to_date = '9999-01-01'
AND d.emp_no NOT IN (SELECT emp_no FROM dept_manager 
                     WHERE to_date = '9999-01-01')
AND d.emp_no = s.emp_no

/* 25.获取员工其当前的薪水比其manager当前薪水还高的相关信息，
emp_no，manager_no，emp_salary，manager_salary (Star) */

SELECT emp_no, manager_no, e.salary AS emp_salary, m.salary AS manager_salary
FROM (SELECT dept_no, emp_no AS manager_no, salary 
      FROM dept_manager d1, salaries s1 
      WHERE d1.emp_no = s1.emp_no
      AND d1.to_date = '9999-01-01'
      AND s1.to_date = '9999-01-01') m,
     (SELECT dept_no, emp_no, salary 
      FROM dept_emp d2, salaries s2
      WHERE d2.emp_no = s2.emp_no
      AND d2.to_date = '9999-01-01'
      AND s2.to_date = '9999-01-01') e
WHERE m.dept_no = e.dept_no
AND m.salary < e.salary; -- Wrong one

SELECT sem.emp_no AS emp_no, sdm.emp_no AS manager_no, 
sem.salary AS emp_salary, sdm.salary AS manager_salary
FROM (SELECT s.salary, s.emp_no, de.dept_no 
  FROM salaries s INNER JOIN dept_emp de
ON s.emp_no = de.emp_no AND s.to_date = '9999-01-01' ) AS sem, 
(SELECT s.salary, s.emp_no, dm.dept_no 
  FROM salaries s INNER JOIN dept_manager dm
ON s.emp_no = dm.emp_no AND s.to_date = '9999-01-01' ) AS sdm
WHERE sem.dept_no = sdm.dept_no AND sem.salary > sdm.salary; -- Right one

/* 26.汇总各个部门当前员工的title类型的分配数目，结果给出部门编号dept_no、dept_name、
其当前员工所有的title以及该类型title对应的数目count */

SELECT d.dept_no, dept_name, title, COUNT(title) AS count
FROM departments d, dept_emp e, titles t
WHERE d.dept_no = e.dept_no
AND e.emp_no = t.emp_no
AND e.to_date = '9999-01-01'
AND t.to_date = '9999-01-01'
GROUP BY 1, 3

/* 27.给出每个员工每年薪水涨幅超过5000的员工编号emp_no、薪水变更开始日期from_date
以及薪水涨幅值salary_growth，并按照salary_growth逆序排列 (Star) */

SELECT s2.emp_no, s2.from_date, (s2.salary - s1.salary) AS salary_growth
FROM salaries AS s1, salaries AS s2
WHERE s1.emp_no = s2.emp_no 
AND salary_growth > 5000
AND (strftime("%Y",s2.to_date) - strftime("%Y",s1.to_date) = 1 
     OR strftime("%Y",s2.from_date) - strftime("%Y",s1.from_date) = 1 )
ORDER BY salary_growth DESC; -- From the community

/* 28.查找描述信息中包括robot的电影对应的分类名称以及电影数目，
而且还需要该分类对应电影数量>=5部 */

SELECT c.name, COUNT(fc.film_id) 
FROM (SELECT category_id, COUNT(film_id) AS category_num 
  FROM film_category GROUP BY 1
  HAVING COUNT(film_id) >= 5) cc, film f, film_category fc, category c
WHERE f.description LIKE '%robot%'
AND f.film_id = fc.film_id
AND c.category_id = fc.category_id
AND c.category_id = cc.category_id

/* 29.使用join查询方式找出没有分类的电影id以及名称 */

SELECT f.film_id, f.title
FROM film f LEFT JOIN film_category fc
ON f.film_id = fc.film_id
WHERE fc.category_id IS NULL

/* 30.使用子查询的方式找出属于Action分类的所有电影对应的title, description */

SELECT title, description
FROM film
WHERE film_id IN
(SELECT film_id 
 FROM film_category
 WHERE category_id IN
 (SELECT category_id 
  FROM category
  WHERE name = 'Action'))

/* 31.获取select * from employees对应的执行计划 */

EXPLAIN SELECT * FROM employees

/* 32.将employees表的所有员工的last_name和first_name拼接起来作为Name，
中间以一个空格区分 */

SELECT last_name || ' ' || first_name AS Name
FROM employees

/* 33 - 48 和SELECT无关 */

/* 33.创建一个actor表，包含如下列信息 */

CREATE TABLE actor
(
actor_id smallint(5) NOT NULL PRIMARY KEY,
first_name varchar(45) NOT NULL,
last_name varchar(45) NOT NULL,
last_update timestamp NOT NULL DEFAULT (datetime('now','localtime'))
)

/* 34.对于表actor批量插入如下数据 */

INSERT INTO actor
VALUES (1, 'PENELOPE', 'GUINESS', '2006-02-15 12:34:33'),
(2, 'NICK', 'WAHLBERG', '2006-02-15 12:34:33')

/* 35.对于表actor批量插入如下数据,如果数据已经存在，请忽略，不使用replace操作 */

INSERT IGNORE INTO actor
VALUES(3,'ED','CHASE','2006-02-15 12:34:33')

/* 36.创建一个actor_name表，将actor表中的所有first_name以及last_name导入改表 */

CREATE TABLE actor_name AS
SELECT first_name, last_name FROM actor

/* 37.针对如下表actor结构创建索引 */

CREATE UNIQUE INDEX uniq_idx_firstname ON actor(first_name);
CREATE INDEX idx_lastname ON actor(last_name);

/* 38.针对actor表创建视图actor_name_view，只包含first_name以及last_name两列，
并对这两列重新命名，first_name为first_name_v，last_name修改为last_name_v */

CREATE VIEW actor_name_view AS
SELECT first_name AS first_name_v, last_name AS last_name_v
FROM actor

/* 39.针对salaries表emp_no字段创建索引idx_emp_no，
查询emp_no为10005, 使用强制索引 */

SELECT * 
FROM salaries 
INDEXED BY idx_emp_no 
WHERE emp_no = 10005

/* 40.现在在last_update后面新增加一列名字为create_date, 
类型为datetime, NOT NULL，默认值为'0000 00:00:00' */

ALTER TABLE actor 
ADD COLUMN create_date datetime 
NOT NULL DEFAULT '0000-00-00 00:00:00'

/* 41.构造一个触发器audit_log，在向employees_test表中
插入一条数据的时候，触发插入相关的数据到audit中 */

CREATE TRIGGER audit_log AFTER INSERT ON employees_test
BEGIN
    INSERT INTO audit VALUES (NEW.ID, NEW.NAME);
END;

/* 42.删除emp_no重复的记录，只保留最小的id对应的记录 */

DELETE FROM titles_test WHERE id NOT IN 
(SELECT MIN(id) FROM titles_test GROUP BY emp_no)

/* 43.将所有to_date为9999-01-01的全部更新为NULL,且 from_date更新为2001-01-01 */

UPDATE titles_test 
SET to_date = NULL, from_date = '2001-01-01'
WHERE to_date = '9999-01-01'

/* 44.将id=5以及emp_no=10001的行数据替换成id=5以及emp_no=10005，
其他数据保持不变，使用replace实现 */

REPLACE INTO titles_test 
VALUES (5, 10005, 'Senior Engineer', '1986-06-26', '9999-01-01')

/* 45.将titles_test表名修改为titles_2017 */

ALTER TABLE titles_test RENAME TO titles_2017

/* 46.在audit表上创建外键约束，其emp_no对应employees_test表的主键id */

DROP TABLE audit;
CREATE TABLE audit(
    EMP_no INT NOT NULL,
    create_date datetime NOT NULL,
    FOREIGN KEY(EMP_no) REFERENCES employees_test(ID))

/* 47.存在如下的视图：
create view emp_v as select * from employees where emp_no >10005;
如何获取emp_v和employees有相同的数据？ */

SELECT em.* FROM employees AS em, emp_v AS ev WHERE em.emp_no = ev.emp_no

/* 48.将所有获取奖金的员工当前的薪水增加10% */

UPDATE salaries SET salary = salary * 1.1 WHERE emp_no IN
(SELECT s.emp_no FROM salaries AS s INNER JOIN emp_bonus AS eb 
ON s.emp_no = eb.emp_no AND s.to_date = '9999-01-01')

/* 49.针对库中的所有表生成select count(*)对应的SQL语句 */

SELECT "select count(*) from " || name || ";" AS cnts
FROM sqlite_master WHERE type = 'table'

/* 50.将employees表中的所有员工的last_name和first_name通过(')连接起来 */

SELECT last_name || "'" || first_name FROM employees

/* 51.查找字符串'10,A,B' 中逗号','出现的次数cnt */

SELECT (length("10,A,B")-length(replace("10,A,B",",","")))/length(",") AS cnt

/* 52.获取Employees中的first_name，查询按照first_name最后两个字母，
按照升序进行排列 */

SELECT first_name
FROM employees
ORDER BY SUBSTR(first_name, LENGTH(first_name) - 1) 

/* 53.按照dept_no进行汇总，属于同一个部门的emp_no按照逗号进行连接，
结果给出dept_no以及连接出的结果employees (Star) */

SELECT dept_no, group_concat(emp_no) AS employees
FROM dept_emp GROUP BY dept_no

/* 54.查找排除当前最大、最小salary之后的员工的平均工资avg_salary */

SELECT AVG(salary) AS avg_salary
FROM salaries
WHERE salary NOT IN
(SELECT MAX(salary), MIN(salary) FROM salaries
WHERE to_date = '9999-01-01')
AND to_date = '9999-01-01'; -- Wrong one

SELECT AVG(salary) AS avg_salary
FROM salaries
WHERE to_date = '9999-01-01'
AND salary NOT IN (SELECT MAX(salary) FROM salaries 
  WHERE to_date = '9999-01-01')
AND salary NOT IN (SELECT MIN(salary) FROM salaries 
  WHERE to_date = '9999-01-01') -- Right one

/* 55.分页查询employees表，每5行一页，返回第2页的数据 */

SELECT *
FROM employees
LIMIT 5, 5

/* 56.获取所有员工的emp_no、部门编号dept_no以及对应的bonus类型
btype和recevied，没有分配具体的员工不显示 */

SELECT de.emp_no, de.dept_no, eb.btype, eb.recevied
FROM dept_emp de LEFT JOIN emp_bonus eb 
ON de.emp_no = eb.emp_no

/* 57.使用含有关键字exists查找未分配具体部门的员工的所有信息 */

SELECT *
FROM employees e
WHERE NOT EXISTS
(SELECT d.emp_no FROM dept_emp d WHERE d.emp_no = e.emp_no)

/* 58.获取employees中的行数据，且这些行也存在于emp_v中；不能使用intersect关键字 */

SELECT * FROM emp_v

/* 59.给出emp_no、first_name、last_name、奖金类型btype、对应的当前薪水情况salary
以及奖金金额bonus；bonus类型btype为1其奖金为薪水salary的10%，
btype为2其奖金为薪水的20%，其他类型均为薪水的30%；
当前薪水表示to_date='9999-01-01' */

SELECT e.emp_no, first_name, last_name, btype, salary, 
(CASE btype WHEN 1 THEN 0.1 * salary 
WHEN 2 THEN 0.2 * salary ELSE 0.3 * salary END) AS bonus
FROM emp_bonus b, salaries s, employees e
WHERE b.emp_no = s.emp_no
AND s.emp_no = e.emp_no
AND s.to_date = '9999-01-01'

/* 60.按照salary的累计和running_total，其中running_total为
前两个员工的salary累计和，其他以此类推 */

SELECT s1.emp_no, s1.salary, 
(SELECT SUM(s2.salary) 
 FROM salaries s2 WHERE s2.emp_no <= s1.emp_no 
 AND s2.to_date = '9999-01-01') AS running_total 
FROM salaries s1 
WHERE s1.to_date = '9999-01-01' 
ORDER BY 1

/* 61.对于employees表中，给出奇数行的first_name */

SELECT e1.first_name FROM 
  (SELECT e2.first_name, 
    (SELECT COUNT(*) FROM employees AS e3 
     WHERE e3.first_name <= e2.first_name) 
   AS rowid FROM employees AS e2) AS e1
WHERE e1.rowid % 2 = 1
