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

