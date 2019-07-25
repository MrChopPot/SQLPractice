/* SELECT basics */

/* 1. Introducing the world table of countries */

SELECT population 
FROM world
WHERE name = 'Germany'

/* 2. Scandinavia */

SELECT name, population 
FROM world
WHERE name IN ('Sweden', 'Norway', 'Denmark')

/* 3. Just the right size */

SELECT name, area 
FROM world
WHERE area BETWEEN 200000 AND 250000

#######################

/* SELECT from WORLD */

/* 1. Introduction */

SELECT name, continent, population 
FROM world

/* 2. Large Countries */

SELECT name 
FROM world
WHERE population = 200000000

/* 3. Per capita GDP */

SELECT name, gdp/population 
FROM world
WHERE population >= 200000000

/* 4. South America In millions */

SELECT name, population/1000000
FROM world
WHERE continent = 'South America'

/* 5. France, Germany, Italy */

SELECT name, population 
FROM world
WHERE name IN ('France', 'Germany', 'Italy')

/* 6. United */

SELECT name 
FROM world
WHERE name LIKE '%United%'

/* 7. Two ways to be big */

SELECT name, population, area
FROM world
WHERE area > 3000000 OR population > 250000000

/* 8. One or the other (but not both) */

SELECT name, population, area
FROM world
WHERE area > 3000000 XOR population > 250000000

/* 9. Rounding */

SELECT name, ROUND(population/1000000,2), ROUND(gdp/1000000000,2)
FROM world
WHERE continent = 'South America'

/* 10. Trillion dollar economies */

SELECT name, ROUND(gdp/population, -3)
FROM world
WHERE gdp > 1000000000000

/* 11. Name and capital have the same length */

SELECT name, capital
FROM world
WHERE LENGTH(name) = LENGTH(capital)

/* 12. Matching name and capital */

SELECT name, capital
FROM world
WHERE LEFT(name, 1) = LEFT(capital, 1)
AND name <> capital

/* 13. All the vowels */

SELECT name FROM world
WHERE name LIKE '%a%' 
AND name LIKE '%e%' 
AND name LIKE '%i%' 
AND name LIKE '%o%' 
AND name LIKE '%u%' 
AND name NOT LIKE '% %'

#######################

/* SELECT from Nobel */

/* 1. Winners from 1950 */

SELECT yr, subject, winner
FROM nobel
WHERE yr = 1950

/* 2. 1962 Literature */

SELECT winner
FROM nobel
WHERE yr = 1962 AND subject = 'Literature'

/* 3. Albert Einstein */

SELECT yr, subject
FROM nobel
WHERE winner = 'Albert Einstein'

/* 4. Recent Peace Prizes */

SELECT winner
FROM nobel
WHERE subject = 'Peace' AND yr >= 2000

/* 5. Literature in the 1980's */

SELECT yr, subject, winner
FROM nobel
WHERE (yr >= 1980 AND yr <= 1989) AND subject = 'Literature'

/* 6. Only Presidents */

SELECT *
FROM nobel
WHERE winner IN ('Theodore Roosevelt', 'Woodrow Wilson', 'Jimmy Carter')

/* 7. John */

SELECT winner
FROM nobel
WHERE winner LIKE 'John%'

/* 8. Chemistry and Physics from different years */

SELECT *
FROM nobel
WHERE (subject = "Physics" AND yr = 1980) 
OR (subject = 'Chemistry' AND yr = 1984)

/* 9. Exclude Chemists and Medics */

SELECT *
FROM nobel
WHERE yr = 1980 AND subject NOT IN ('Chemistry', 'Medicine')

/* 10. Early Medicine, Late Literature */

SELECT *
FROM nobel
WHERE (subject  = 'Medicine' AND yr < 1910) 
OR (subject = 'Literature' AND yr >= 2004)

/* 11. Umlaut */

SELECT *
FROM nobel
WHERE winner LIKE 'PETER GRÜNBERG'

/* 12. Apostrophe */

SELECT *
FROM nobel
WHERE winner = 'Eugene O\'Neill'

/* 13. Knights of the realm */

SELECT winner, yr, subject
FROM nobel
WHERE winner LIKE 'Sir%'
ORDER BY yr DESC, winner

/* 14. Chemistry and Physics last */

SELECT winner, subject
FROM nobel
WHERE yr = 1984
ORDER BY subject IN ('Physics','Chemistry'), subject, winner

#######################

/* SELECT within SELECT */

/* 1. Bigger than Russia */

SELECT name
FROM world
WHERE population > (SELECT population 
    FROM world WHERE name='Russia')

/* 2. Richer than UK */

SELECT name
FROM world
WHERE gdp/population > (SELECT gdp/population FROM world 
    WHERE name = 'United Kingdom') AND continent = 'Europe'

/* 3. Neighbours of Argentina and Australia */

SELECT name, continent
FROM world
WHERE continent IN (SELECT continent FROM world 
    WHERE name IN ('Argentina', 'Australia'))
ORDER BY name

/* 4. Between Canada and Poland */

SELECT name, population
FROM world
WHERE population >
    (SELECT population FROM world WHERE name = 'Canada')
AND population <
    (SELECT population FROM world WHERE name = 'Poland')

/* 5. Percentages of Germany */

SELECT name, CONCAT(ROUND(population/(SELECT population 
    FROM world WHERE name = 'Germany'), 0), %)
FROM world
WHERE continent = 'Europe'

/* 6. Bigger than every country in Europe */

SELECT name
FROM world
WHERE gdp >= ALL(SELECT gdp FROM world 
    WHERE gdp >=0 AND continent = 'Europe') AND continent <> 'Europe'

/* 7. Largest in each continent */

SELECT continent, name, area
FROM world x
WHERE area >= ALL(SELECT area FROM world y
    WHERE y.continent=x.continent
    AND area>0)

/* 8. First country of each continent (alphabetically) */

SELECT continent, name
FROM world x
WHERE name <= ALL(SELECT name FROM world y WHERE y.continent = x.continent)

/* 9. Difficult Questions That Utilize Techniques Not Covered In Prior Sections */

SELECT name, continent, population
FROM world x
WHERE 25000000  > ALL(SELECT population FROM world y 
    WHERE x.continent = y.continent AND y.population > 0)

/* 10. Difficult Questions That Utilize Techniques Not Covered In Prior Sections */

SELECT name, continent
FROM world x
WHERE population > ALL(SELECT population*3 FROM world y 
    WHERE x.continent = y.continent AND population > 0 
    AND y.name != x.name)

#######################

/* SUM and COUNT */

/* 1. Total world population */

SELECT SUM(population)
FROM world

/* 2. List of continents */

SELECT DISTINCT continent
FROM world

/* 3. GDP of Africa */

SELECT SUM(gdp)
FROM world
WHERE continent = 'Africa'

/* 4. Count the big countries */

SELECT name
FROM world
WHERE area >= 1000000

/* 5. Baltic states population */

SELECT SUM(population)
FROM world
WHERE name IN ('Estonia', 'Latvia', 'Lithuania')

/* 6. Counting the countries of each continent */

SELECT continent, COUNT(name)
FROM world
GROUP BY 1

/* 7. Counting big countries in each continent */

SELECT continent, COUNT(name)
FROM world
WHERE population > 10000000
GROUP BY 1

/* 8. Counting big continents */

SELECT continent
FROM world
GROUP BY 1
HAVING SUM(population) > 100000000

#######################

/* The JOIN operation */

/* 1. Modify it to show the matchid and player name for all goals scored by Germany */

SELECT matchid, player
FROM goal 
WHERE teamid = 'GER'

/* 2. Show id, stadium, team1, team2 for just game 1012 */

SELECT id,stadium,team1,team2
FROM game
WHERE id = 1012

/* 3. Modify it to show the player, teamid, stadium and mdate for every German goal */

SELECT player, teamid, stadium, mdate
FROM game
JOIN goal
ON id = matchid
WHERE teamid = 'GER'
# ON (id=matchid AND teamid='GER')

/* 4. Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%' */

SELECT team1, team2, player
FROM game
JOIN goal ON id = matchid 
WHERE player LIKE 'Mario%'
# ON (id=matchid AND player LIKE 'Mario%')

/* 5. Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10 */

SELECT player, teamid, coach, gtime
FROM goal
JOIN eteam
ON teamid = id
WHERE gtime <= 10
# ON (teamid=id AND gtime<=10)

/* 6. List the the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach */

SELECT mdate, teamname
FROM game
JOIN eteam 
ON team1 = eteam.id 
WHERE coach = 'Fernando Santos'
# ON (team1=eteam.id AND coach LIKE '%Santos')

/* 7. Show the countries that are big by area or big 
by population */

SELECT player
FROM goal
JOIN game 
ON id = matchid
WHERE stadium = 'National Stadium, Warsaw'
# ON (id=matchid AND stadium = 'National Stadium, Warsaw')

/* 8. Instead show the name of all players who scored a goal against Germany */

SELECT DISTINCT(player)
FROM game
JOIN goal 
ON matchid = id
WHERE (team1 = 'GER' OR team2 = 'GER') 
AND teamid <> 'GER'

/* 9. Show teamname and the total number of goals scored */

SELECT teamname, COUNT(player)
FROM eteam
JOIN goal 
ON id = teamid
GROUP BY 1

/* 10. Show the stadium and the number of goals scored in each stadium */

SELECT stadium, COUNT(player) AS goals
FROM game
JOIN goal 
ON id = matchid
GROUP BY 1

/* 11. For every match involving 'POL', show the matchid, date and the number of goals scored */

SELECT matchid, mdate, COUNT(player) AS goals
FROM game
JOIN goal 
ON matchid = id 
WHERE team1 = 'POL' OR team2 = 'POL'
GROUP BY 1, 2

/* 12. For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER' */

SELECT id, mdate, COUNT(player)
FROM game
JOIN goal 
ON id = matchid 
WHERE (team1 = 'GER' OR team2 = 'GER') 
AND teamid = 'GER'
GROUP BY 1, 2

/* 13. List every match with the goals scored by each team as shown */

SELECT mdate, team1, SUM(CASE WHEN teamid = team1 THEN 1 ELSE 0 END) AS score1,
       team2, SUM(CASE WHEN teamid = team2 THEN 1 ELSE 0 END) AS score2 
FROM game 
LEFT JOIN goal 
ON id = matchid
GROUP BY mdate, team1, team2
ORDER BY mdate, matchid, team1, team2

#######################

/* More JOIN operations */

/* 1. 1962 movies */

SELECT id, title
FROM movie
WHERE yr = 1962

/* 2. When was Citizen Kane released? */

SELECT yr
FROM movie
WHERE title = 'Citizen Kane'

/* 3. List all of the Star Trek movies, include the id, title and yr */

SELECT player, teamid, stadium, mdate
FROM game
JOIN goal
ON id = matchid
WHERE teamid = 'GER'
# ON (id=matchid AND teamid='GER')

/* 4. What id number does the actor 'Glenn Close' have? */

SELECT id
FROM actor
WHERE name = 'Glenn Close'

/* 5. What is the id of the film 'Casablanca' */

SELECT id
FROM movie
WHERE title = 'Casablanca'

/* 6. Obtain the cast list for 'Casablanca' */

SELECT name
FROM casting
JOIN actor
ON actorid = id
WHERE movieid = 11768

/* 7. Obtain the cast list for the film 'Alien' */

SELECT name
FROM actor
JOIN casting 
ON id = actorid
WHERE movieid = (SELECT id FROM movie 
    WHERE title = 'Alien')

/* 8. Instead show the name of all players who scored a goal against Germany */

SELECT title
FROM movie
JOIN casting 
ON id = movieid 
WHERE actorid = (SELECT id FROM actor 
    WHERE name = 'Harrison Ford')

/* 9. List the films where 'Harrison Ford' has appeared - but not in the starring role */

SELECT title
FROM movie
JOIN casting 
ON id = movieid 
WHERE actorid = (SELECT id FROM actor WHERE name = 'Harrison Ford')
AND ord <> 1

/* 10. List the films together with the leading star for all 1962 films */

SELECT title, name
FROM movie, casting, actor
WHERE movieid = movie.id
AND actorid = actor.id
AND ord = 1
AND yr = 1962

/* 11. Busy years for John Travolta */

SELECT yr, COUNT(title) 
FROM movie 
JOIN casting ON movie.id = movieid
JOIN actor ON actorid = actor.id
WHERE name = 'John Travolta'
GROUP BY yr
HAVING COUNT(title) = (SELECT MAX(c) FROM
(SELECT yr, COUNT(title) AS c 
    FROM movie JOIN casting ON movie.id = movieid
         JOIN actor ON actorid = actor.id
    WHERE name = 'John Travolta'
    GROUP BY yr) AS t
)

/* 12. Lead actor in Julie Andrews movies */

SELECT title, name 
FROM movie
JOIN casting x ON movie.id = movieid
JOIN actor ON actor.id =actorid
WHERE ord=1 AND 
movieid IN (SELECT movieid FROM casting y
JOIN actor ON actor.id=actorid
WHERE name = 'Julie Andrews')

/* 13. Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles */

SELECT name
FROM actor
JOIN casting 
ON id = actorid
WHERE (SELECT COUNT(ord) FROM casting 
    WHERE actorid = actor.id AND ord=1) >= 30
GROUP BY 1

/* 14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title */

SELECT title, COUNT(actorid) as cast
FROM movie 
JOIN casting 
on id = movieid
WHERE yr = 1978
GROUP BY 1
ORDER BY 2 DESC, 1

/* 15. List all the people who have worked with 'Art Garfunkel' */

SELECT DISTINCT name
FROM actor 
JOIN casting 
ON id = actorid
WHERE movieid IN (SELECT movieid FROM casting 
    JOIN actor ON actorid = id
    WHERE name = 'Art Garfunkel')
AND name != 'Art Garfunkel'
GROUP BY 1

#######################

/* Using Null */

/* 1. List the teachers who have NULL for their department */

SELECT name
FROM teacher
WHERE dept IS NULL

/* 2. Note the INNER JOIN misses the teachers with no department and the departments with no teacher */

SELECT teacher.name, dept.name
FROM teacher 
JOIN dept
ON teacher.dept = dept.id

/* 3. Use a different JOIN so that all teachers are listed. */

SELECT teacher.name, dept.name
FROM teacher 
LEFT JOIN dept
ON teacher.dept = dept.id

/* 4. Use a different JOIN so that all departments are listed. */

SELECT teacher.name, dept.name
FROM teacher 
RIGHT JOIN dept
ON teacher.dept = dept.id

/* 5. Show teacher name and mobile number or '07986 444 2266' */

SELECT name, COALESCE(mobile, '07986 444 2266') AS 'mobile'
FROM teacher

/* 6. Use the COALESCE function and a LEFT JOIN to print the teacher name and department name */

SELECT COALESCE(teacher.name, 'NONE'), COALESCE(dept.name, 'None')
FROM teacher 
LEFT JOIN dept 
ON teacher.dept = dept.id

/* 7. Use COUNT to show the number of teachers and the number of mobile phones */

SELECT COUNT(name), COUNT(mobile)
FROM teacher

/* 8. Use COUNT and GROUP BY dept.name to show each department and the number of staff */

SELECT dept.name, COUNT(teacher.name)
FROM teacher 
RIGHT JOIN dept
ON teacher.dept = dept.id
GROUP BY 1

/* 9. Use CASE to show the name of each teacher followed by 'Sci' 
if the teacher is in dept 1 or 2 and 'Art' otherwise */

SELECT teacher.name,
CASE WHEN dept.id IN (1,2) THEN 'Sci'
     ELSE 'Art' END
FROM teacher 
LEFT JOIN dept 
ON teacher.dept = dept.id

/* 10. Use CASE to show the name of each teacher followed by 'Sci' if the teacher 
is in dept 1 or 2, show 'Art' if the teacher's dept is 3 and 'None' otherwise */

SELECT teacher.name,
CASE WHEN dept.id = 1 THEN 'Sci'
WHEN dept.id = 2 THEN 'Sci'
WHEN dept.id = 3 THEN 'Art'
ELSE 'None' END
FROM teacher 
LEFT JOIN dept 
ON dept.id = teacher.dept

#######################

/* Self join */

/* 1. How many stops are in the database */

SELECT COUNT(*)
FROM stops

/* 2. Find the id value for the stop 'Craiglockhart' */

SELECT id
FROM stops
WHERE name = 'Craiglockhart'

/* 3. Give the id and the name for the stops on the '4' 'LRT' service */

SELECT id, name
FROM stops
JOIN route ON id = stop
WHERE company = 'LRT' AND num = 4

/* 4. The query shown gives the number of routes that visit 
either London Road (149) or Craiglockhart (53) */

SELECT company, num, COUNT(*) AS visits
FROM route 
WHERE stop = 149 OR stop = 53
GROUP BY 1, 2
HAVING visits = 2

/* 5. Show teacher name and mobile number or '07986 444 2266' */

SELECT a.company, a.num, a.stop, b.stop
FROM route a, route b
WHERE a.company = b.company 
AND a.num = b.num
AND a.stop = 53 
AND b.stop = 149

/* 6. The query shown is similar to the previous one, however by joining two copies 
of the stops table we can refer to stops by name rather than by number */

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company = b.company AND a.num = b.num)
  JOIN stops stopa ON (a.stop = stopa.id)
  JOIN stops stopb ON (b.stop = stopb.id)
WHERE stopa.name = 'Craiglockhart'AND stopb.name = 'London Road'

/* 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith') */

SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON
  (a.company = b.company AND a.num = b.num)
  JOIN stops stopa ON (a.stop = stopa.id)
  JOIN stops stopb ON (b.stop = stopb.id)
WHERE stopa.name = 'Haymarket' AND stopb.name = 'Leith'

/* 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross' */

SELECT DISTINCT a.company, a.num
FROM route a
  JOIN route b ON (a.num=b.num AND a.company=b.company)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name = 'Craiglockhart' AND stopb.name = 'Tollcross'

/* 9. Give a distinct list of the stops which may be reached 
from 'Craiglockhart' by taking one bus */

SELECT stopa.name, a.company, a.num
FROM route a
  JOIN route b ON (a.num = b.num AND a.company = b.company)
  JOIN stops stopa ON (a.stop = stopa.id)
  JOIN stops stopb ON (b.stop = stopb.id)
WHERE stopb.name = 'Craiglockhart'

/* 10. Find the routes involving two buses that can go from Craiglockhart to Lochend */

SELECT DISTINCT a.num, a.company, stopb.name, c.num, c.company
FROM route a JOIN route b
ON (a.company = b.company AND a.num = b.num)
JOIN ( route c JOIN route d ON (c.company = d.company AND c.num= d.num))
JOIN stops stopa ON (a.stop = stopa.id)
JOIN stops stopb ON (b.stop = stopb.id)
JOIN stops stopc ON (c.stop = stopc.id)
JOIN stops stopd ON (d.stop = stopd.id)
WHERE  stopa.name = 'Craiglockhart' AND stopd.name = 'Sighthill'
            AND  stopb.name = stopc.name
ORDER BY LENGTH(a.num), b.num, stopb.id, LENGTH(c.num), d.num

