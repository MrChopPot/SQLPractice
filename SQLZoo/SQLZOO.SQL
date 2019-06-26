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
WHERE (yr >=1980 AND yr <=1989) AND subject = 'Literature'

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
WHERE (subject = "Physics" AND yr = '1980') 
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

/* 13. List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises */

SELECT mdate, team1, SUM(CASE WHEN teamid = team1 THEN 1 ELSE 0 END) AS score1,
       team2, SUM(CASE WHEN teamid = team2 THEN 1 ELSE 0 END) AS score2 
FROM game 
LEFT JOIN goal 
ON id = matchid
GROUP BY mdate, team1, team2
ORDER BY mdate, matchid, team1, team2

#######################

/* More JOIN operations */

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

/* 13. List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises */

SELECT mdate, team1, SUM(CASE WHEN teamid = team1 THEN 1 ELSE 0 END) AS score1,
       team2, SUM(CASE WHEN teamid = team2 THEN 1 ELSE 0 END) AS score2 
FROM game 
LEFT JOIN goal 
ON id = matchid
GROUP BY mdate, team1, team2
ORDER BY mdate, matchid, team1, team2
