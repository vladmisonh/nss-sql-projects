-- ## Lahman Baseball Database Exercise
-- - this data has been made available [online](http://www.seanlahman.com/baseball-archive/statistics/) by Sean Lahman
-- - A data dictionary is included with the files for this project.

-- ### Use SQL queries to find answers to the *Initial Questions*. If time permits, choose one (or more) of the *Open-Ended Questions*. Toward the end of the bootcamp, we will revisit this data if time allows to combine SQL, Excel Power Pivot, and/or Python to answer more of the *Open-Ended Questions*.



-- **Initial Questions**

-- 1. What range of years for baseball games played does the provided database cover? 

SELECT 
	MIN(yearid), 
	MAX(yearid)
FROM teams;

-- Answer: 1871	2016

-- 2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?

SELECT 
	--p.playerid,
	p.namefirst,
	p.namelast,
	p.height,
	a.g_all,
	t.name AS team_name
FROM people AS p
	LEFT JOIN appearances AS a
		USING(playerid)
	LEFT JOIN teams AS t
		USING(teamid, yearid)
ORDER BY p.height ASC
LIMIT 1;

-- Answer: "Eddie"	"Gaedel"	43	1	"St. Louis Browns" 

-- 3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. 
-- Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?
	
SELECT
	--p.playerid,
	p.namefirst,
	p.namelast,
	--s1.schoolname,
	COALESCE(SUM(DISTINCT s2.salary)::NUMERIC,0)::MONEY AS total_salary
FROM people AS p
	LEFT JOIN collegeplaying AS c
		USING(playerid)
	LEFT JOIN schools AS s1
		USING(schoolid)
	LEFT JOIN salaries AS s2
		USING(playerid)
WHERE s1.schoolname = 'Vanderbilt University'
GROUP BY p.playerid, p.namefirst, p.namelast
ORDER BY total_salary DESC;

-- Answer: "David"	"Price"	"$81,851,296.00"

-- 4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", 
-- those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". 
-- Determine the number of putouts made by each of these three groups in 2016.

SELECT
	COUNT(playerid) AS count_of_players,
	CASE
			WHEN pos = 'OF'
				THEN 'Outfield'
			WHEN pos IN ('SS', '1B', '2B', '3B')
				THEN 'Infield'
			WHEN pos IN ('P', 'C')
				THEN 'Battery'
		END AS player_group,
	SUM(po) AS sum_of_putouts
FROM fielding
WHERE yearid = '2016'
GROUP BY player_group;

-- Answer: 
-- 354	"Outfield"	29560
-- 938	"Battery"	41424
-- 661	"Infield"	58934
   
-- 5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. 
-- Do the same for home runs per game. Do you see any trends?

SELECT 
	yearid/10*10 AS decade,
	ROUND(ROUND(SUM(so),2) / ROUND(SUM(g/2),2),2) AS avg_strikeouts,
	ROUND(ROUND(SUM(hr),2) / ROUND(SUM(g/2),2),2) AS avg_homeruns
FROM teams
WHERE yearid >= 1920
GROUP BY decade
ORDER BY decade;

-- Answer: the average strikeouts and home runs rate per game increases every decade.

-- 6. Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of stolen base attempts which are successful. 
-- (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted _at least_ 20 stolen bases.
	
SELECT
	p.playerid,
	p.namefirst,
	p.namelast,
	COALESCE(SUM(b.sb),0) AS stolen_bases,
	COALESCE(SUM(b.cs),0) AS caught_bases,
	COALESCE(SUM(b.sb),0) + COALESCE(SUM(b.cs),0) AS sum_stealing_bases_atm,
	ROUND(COALESCE(SUM(b.sb),0) * 100.0 / (COALESCE(SUM(b.sb),0) + COALESCE(SUM(b.cs),0)),2) AS success_pct
FROM batting AS b
	LEFT JOIN people AS p
		USING(playerid)
WHERE b.yearid = 2016
GROUP BY 1
HAVING COALESCE(SUM(b.sb),0) + COALESCE(SUM(b.cs),0) >= 20
ORDER BY 7 DESC;

-- Answer: "owingch01"	"Chris"	"Owings"	21	2	23	91.30

-- 7.  From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? 
-- Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year. 
-- How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?

(
SELECT 
	yearid, 
	teamid, 
	w AS num_wins, 
	'Did Not Win WS' AS result
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
	AND wswin = 'N'
ORDER by w DESC
LIMIT 1
)
UNION ALL
(
SELECT 
	yearid, 
	teamid, 
	w AS num_wins, 
	'Won WS' AS result
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
	AND wswin = 'Y'
	--AND yearid != 1981
ORDER by w ASC
LIMIT 1
);

-- Answer: 
-- 2001	"SEA"	116	"Did Not Win WS"
-- 1981	"LAN"	63	"Won WS"

WITH top_teams AS 
(
	SELECT 
		yearid,
		MAX(w) AS max_wins
	FROM teams
	WHERE yearid BETWEEN 1970 AND 2016
	GROUP BY yearid
	ORDER BY yearid ASC
)
SELECT 
    COUNT(*) AS times_most_wins_won_ws,
    ROUND(COUNT(*) * 100 / (2016. - 1970.), 2) AS percentage
FROM top_teams
LEFT JOIN teams
	USING(yearid)
WHERE teams.w = top_teams.max_wins
	AND wswin = 'Y';

-- Answer: 12	26.09


-- 8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 
-- (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. 
-- Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.

(
	SELECT 
		p.park_name,
		--t.teamid,
		t.name AS team_name,
		'high' AS high_low,
		ROUND(ROUND(SUM(h.attendance),2)/ROUND(SUM(h.games),2),2) AS avg_attendance
	FROM homegames AS h
	LEFT JOIN parks AS p
		USING(park)
	LEFT JOIN teams AS t
		ON h.team = t.teamid 
		AND h.year = t.yearid
	WHERE year = 2016
		AND h.games >= 10
	GROUP BY 1,2
	ORDER BY avg_attendance DESC
	LIMIT 5
)
UNION
(
	SELECT 
		p.park_name,
		--t.teamid,
		t.name AS team_name,
		'low' AS high_low,
		ROUND(ROUND(SUM(h.attendance),2)/ROUND(SUM(h.games),2),2) AS avg_attendance
	FROM homegames AS h
	LEFT JOIN parks AS p
		USING(park)
	LEFT JOIN teams AS t
		ON h.team = t.teamid 
		AND h.year = t.yearid
	WHERE year = 2016
		AND h.games >= 10
	GROUP BY 1, 2
	ORDER BY avg_attendance ASC
	LIMIT 5
)
ORDER BY avg_attendance DESC;

-- Answer:
-- "Dodger Stadium"	"Los Angeles Dodgers"	"high"	45719.90
-- "Busch Stadium III"	"St. Louis Perfectos"	"high"	42524.57
-- "Rogers Centre"	"Toronto Blue Jays"	"high"	41877.77
-- "AT&T Park"	"San Francisco Giants"	"high"	41546.37
-- "Wrigley Field"	"Chicago White Stockings"	"high"	39906.42
-- "U.S. Cellular Field"	"Chicago White Sox"	"low"	21559.17
-- "Marlins Park"	"Miami Marlins"	"low"	21405.21
-- "Progressive Field"	"Cleveland Naps"	"low"	19650.21
-- "Oakland-Alameda County Coliseum"	"Oakland Athletics"	"low"	18784.02
-- "Tropicana Field"	"Tampa Bay Rays"	"low"	15878.56


-- 9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? 
-- Give their full name and the teams that they were managing when they won the award.

SELECT 
    --a.playerid,
    CONCAT(p.namefirst, ' ', p.namelast) AS full_name,
    --t.teamid,
	t.name AS team_name,
    a.lgid
FROM awardsmanagers AS a
LEFT JOIN people AS p 
	USING (playerid)
LEFT JOIN managers AS m 
    USING(playerid, yearid)
JOIN teams AS t 
    USING(teamid, yearid)
WHERE a.playerid IN 
		(
		    SELECT playerid
		    FROM awardsmanagers
		    WHERE awardid = 'TSN Manager of the Year' AND lgid = 'AL'
			
		    INTERSECT
			
		    SELECT playerid
		    FROM awardsmanagers
		    WHERE awardid = 'TSN Manager of the Year' AND lgid = 'NL'
		)
GROUP BY 1,2,3
ORDER BY full_name;

-- Answer:
-- "Davey Johnson"	"Baltimore Orioles"	"AL"
-- "Davey Johnson"	"Washington Nationals"	"NL"
-- "Jim Leyland"	"Detroit Tigers"	"AL"
-- "Jim Leyland"	"Pittsburgh Pirates"	"NL"


-- 10. Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, 
-- and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.

WITH player_hr_max AS
(
	SELECT 
		b.playerid,
		COUNT(b.yearid) AS years_in_league,
		MAX(b.hr) AS max_hr_all_time
	FROM batting AS b
	-- WHERE b.playerid = 'avilemi01'
	GROUP BY playerid
)
SELECT
	--b.playerid,
	p2.namefirst,
	p2.namelast,
	b.yearid,
	SUM(b.hr) AS hr_2016,
	p1.max_hr_all_time
FROM batting AS b
LEFT JOIN player_hr_max AS p1
	USING(playerid)
LEFT JOIN people AS p2
	USING(playerid)
WHERE b.yearid = 2016
	AND b.hr >= 1
	AND p1.years_in_league >= 10
	--AND p2.namelast = 'Wainwright'
GROUP BY 1,2,3,5;


-- **Open-ended questions**

-- 11. Is there any correlation between number of wins and team salary? Use data from 2000 and later to answer this question. As you do this analysis, 
-- keep in mind that salaries across the whole league tend to increase together, so you may want to look on a year-by-year basis.

WITH wins_salary AS (
    SELECT
        yearid,
        teamid,
        SUM(s.salary) AS team_salary,
        t.w AS num_of_wins
    FROM salaries AS s
    LEFT JOIN teams AS t USING(yearid, teamid)
    WHERE yearid >= 2000
    GROUP BY yearid, teamid, t.w
	ORDER BY yearid, team_salary DESC
)
SELECT 
    yearid,
    ROUND(CAST(CORR(num_of_wins::DOUBLE PRECISION, team_salary::DOUBLE PRECISION) AS NUMERIC),2) AS correlation
FROM wins_salary
GROUP BY yearid
ORDER BY yearid;

-- Answer: 

-- 12. In this question, you will explore the connection between number of wins and attendance.
--     <ol type="a">
--       <li>Does there appear to be any correlation between attendance at home games and number of wins? </li>
--       <li>Do teams that win the world series see a boost in attendance the following year? What about teams that made the playoffs? 
-- Making the playoffs means either being a division winner or a wild card winner.</li>
--     </ol>


-- 13. It is thought that since left-handed pitchers are more rare, causing batters to face them less often, that they are more effective. 
-- Investigate this claim and present evidence to either support or dispute this claim. First, determine just how rare left-handed 
-- pitchers are compared with right-handed pitchers. Are left-handed pitchers more likely to win the Cy Young Award? Are they more likely to make it into the hall of fame?

WITH left_handed AS 
(
	SELECT 
		DISTINCT playerid,
		throws AS hand_throws
	FROM pitching
	LEFT JOIN people
	USING(playerid)
	WHERE throws='L'
		AND GS > 1
),
right_handed AS 
(
	SELECT 
		DISTINCT playerid,
		throws AS hand_throws
	FROM pitching
	LEFT JOIN people
	USING(playerid)
	WHERE throws='R'
		AND GS > 1
),
num_of_type_hands_pitchers AS
(
	SELECT
		(SELECT COUNT(*) FROM left_handed) AS total_left,
    	(SELECT COUNT(*) FROM right_handed) AS total_right
)
SELECT 
	*,
	--total_left+total_right AS total_pitchers,
	ROUND((total_left::NUMERIC / (total_left + total_right) * 100), 2) AS percent_left,
	ROUND((total_right::NUMERIC / (total_left + total_right) * 100), 2) AS percent_right
FROM num_of_type_hands_pitchers;

--------------------------------------------------------------------------------------------------

WITH CY_award_winners AS 
(
	SELECT 
		DISTINCT playerid, 
		throws AS hand_throws
	FROM people AS p
	LEFT JOIN awardsplayers AS a 
		USING(playerid)
	WHERE awardid = 'Cy Young Award' 
		AND throws IN ('L', 'R')
),
hall_of_fame_players AS
(
	SELECT
		DISTINCT playerid, 
		throws AS hand_throws
	FROM pitching
	LEFT JOIN people
		USING(playerid)
	LEFT JOIN halloffame AS h 
		USING(playerid)
	WHERE throws IN ('L', 'R')
		AND inducted = 'Y'
		AND GS > 1
),
num_of_award_winners AS
(
	SELECT
    	(SELECT COUNT(*) FROM CY_award_winners WHERE hand_throws = 'L') AS cy_young_left,
    	(SELECT COUNT(*) FROM CY_award_winners WHERE hand_throws = 'R') AS cy_young_right,
		(SELECT COUNT(*) FROM hall_of_fame_players WHERE hand_throws = 'L') AS hall_of_fame_left,
		(SELECT COUNT(*) FROM hall_of_fame_players WHERE hand_throws = 'R') AS hall_of_fame_right
)
SELECT 
	cy_young_left,
	cy_young_right,
	ROUND((cy_young_left::NUMERIC / (cy_young_left + cy_young_right) * 100), 2) AS percent_cy_young_left,
	ROUND((cy_young_right::NUMERIC / (cy_young_left + cy_young_right) * 100), 2) AS percent_cy_young_right,
	hall_of_fame_left,
	hall_of_fame_right,
	ROUND((hall_of_fame_left::NUMERIC / (hall_of_fame_left + hall_of_fame_right) * 100), 2) AS percent_hall_of_fame_left,
	ROUND((hall_of_fame_right::NUMERIC / (hall_of_fame_left + hall_of_fame_right) * 100), 2) AS percent_hall_of_fame_right
FROM num_of_award_winners;
