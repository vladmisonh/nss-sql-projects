-- ## Question 1: Rankings
-- #### Question 1a: Warmup Question
-- Write a query which retrieves each teamid and number of wins (w) for the 2016 season. 
-- Apply three window functions to the number of wins (ordered in descending order) - ROW_NUMBER, RANK, AND DENSE_RANK. 
-- Compare the output from these three functions. What do you notice?

SELECT 
	teamid,
	w AS num_of_wins,
	ROW_NUMBER() OVER (ORDER BY w DESC) AS row_num,
	RANK() OVER (ORDER BY w DESC) AS rank_num,
	DENSE_RANK() OVER (ORDER BY w DESC) AS dense_rank_num
FROM teams
WHERE yearid = 2016;

-- Answer:
-- ROW_NUMBER() is always unique (1, 2, 3, 4, …).
-- RANK() skips numbers with the same values (1, 1, 3, 4, ...).
-- DENSE_RANK() does not skip (1, 1, 2, 3, ...).

-- #### Question 1b: 
-- Which team has finished in last place in its division (i.e. with the least number of wins) the most number of times? 
-- A team's division is indicated by the divid column in the teams table.

WITH last_place_teams AS (
    SELECT
        teamid,
        divid,
        yearid,
        w AS num_of_wins,
        RANK() OVER (PARTITION BY divid, yearid ORDER BY w ASC) AS rank_in_division
    FROM teams
)
SELECT
    teamid,
    COUNT(*) AS num_of_last_places
FROM last_place_teams
WHERE rank_in_division = 1
GROUP BY teamid
ORDER BY num_of_last_places DESC
LIMIT 1;

-- Answer: "PHI"	19

-- ## Question 2: Cumulative Sums
-- #### Question 2a: 
-- Barry Bonds has the record for the highest career home runs, with 762. Write a query which returns, for each season of Bonds' career 
-- the total number of seasons he had played and his total career home runs at the end of that season. (Barry Bonds' playerid is bondsba01.)

SELECT 
    yearid,
    COUNT(*) OVER (PARTITION BY playerid ORDER BY yearid) AS total_seasons_played,
    SUM(hr) OVER (PARTITION BY playerid ORDER BY yearid) AS total_home_runs_at_end_of_season
FROM batting
WHERE playerid = 'bondsba01'
ORDER BY yearid;

-- #### Question 2b:
-- How many players at the end of the 2016 season were on pace to beat Barry Bonds' record? For this question, 
-- we will consider a player to be on pace to beat Bonds' record if they have more home runs than Barry Bonds had the same number of seasons into his career. 

WITH bonds_home_runs AS (
    SELECT 
        yearid,
        SUM(hr) OVER (ORDER BY yearid) AS total_home_runs_at_end_of_season,
        COUNT(*) OVER (ORDER BY yearid) AS seasons_played
    FROM batting
    WHERE playerid = 'bondsba01'
),
players_home_runs AS (
    SELECT 
        playerid,
        yearid,
        SUM(hr) OVER (PARTITION BY playerid ORDER BY yearid) AS total_home_runs_at_end_of_season,
        COUNT(*) OVER (PARTITION BY playerid ORDER BY yearid) AS seasons_played
    FROM batting
    WHERE yearid <= 2016
)
SELECT 
    p.playerid,
    p.total_home_runs_at_end_of_season,
    p.seasons_played
FROM players_home_runs AS p
JOIN bonds_home_runs AS b 
	ON p.seasons_played = b.seasons_played
WHERE p.total_home_runs_at_end_of_season > b.total_home_runs_at_end_of_season
ORDER BY p.total_home_runs_at_end_of_season DESC;


-- #### Question 2c: 
-- Were there any players who 20 years into their career who had hit more home runs at that point into their career than Barry Bonds had hit 20 years into his career? 

WITH bonds_home_runs_20_years AS (
    SELECT 
        SUM(hr) AS bonds_home_runs_20_years
    FROM batting AS b
	LEFT JOIN people AS p
		USING(playerid)
    WHERE playerid = 'bondsba01'
    	AND yearid <= EXTRACT(YEAR FROM debut::date) + 20
),
players_home_runs_20_years AS (
    SELECT 
        p.playerid,
        SUM(b.hr) AS total_home_runs_20_years
    FROM batting AS b
    LEFT JOIN people AS p
        ON b.playerid = p.playerid
    WHERE yearid <= EXTRACT(YEAR FROM debut::date) + 20
    GROUP BY p.playerid
	ORDER BY total_home_runs_20_years DESC
)
SELECT 
    p.playerid,
    p.total_home_runs_20_years,
    b.bonds_home_runs_20_years
FROM players_home_runs_20_years AS p
JOIN bonds_home_runs_20_years AS b 
    ON p.total_home_runs_20_years > b.bonds_home_runs_20_years
ORDER BY p.total_home_runs_20_years DESC;

-- Answer: no

-- ## Question 3: Anomalous Seasons
-- Find the player who had the most anomalous season in terms of number of home runs hit. To do this, find the player who has the largest gap between 
-- the number of home runs hit in a season and the 5-year moving average number of home runs if we consider the 5-year window 
-- centered at that year (the window should include that year, the two years prior and the two years after).

-- ## Question 4: Players Playing for one Team
-- For this question, we'll just consider players that appear in the batting table.
-- #### Question 4a: 
-- Warmup: How many players played at least 10 years in the league and played for exactly one team? (For this question, exclude any players who played in the 2016 season). 
-- Who had the longest career with a single team? (You can probably answer this question without needing to use a window function.)

-- #### Question 4b: 
-- Some players start and end their careers with the same team but play for other teams in between. For example, Barry Zito started his career with the Oakland Athletics, 
-- moved to the San Francisco Giants for 7 seasons before returning to the Oakland Athletics for his final season. 
-- How many players played at least 10 years in the league and start and end their careers with the same team but played for at least one other team 
-- during their career? For this question, exclude any players who played in the 2016 season.

-- ## Question 5: Streaks
-- #### Question 5a: 
-- How many times did a team win the World Series in consecutive years?

-- #### Question 5b: 
-- What is the longest steak of a team winning the World Series? Write a query that produces this result rather than scanning the output of your previous answer.

-- #### Question 5c: 
-- A team made the playoffs in a year if either divwin, wcwin, or lgwin will are equal to 'Y'. Which team has the longest streak of making the playoffs? 

-- #### Question 5d: 
-- The 1994 season was shortened due to a strike. If we don't count a streak as being broken by this season, does this change your answer for the previous part?

-- ## Question 6: Manager Effectiveness
-- Which manager had the most positive effect on a team's winning percentage? To determine this, calculate the average winning percentage in the three years 
-- before the manager's first full season and compare it to the average winning percentage for that manager's 2nd through 4th full season. 
-- Consider only managers who managed at least 4 full years at the new team and teams that had been in existence for at least 3 years prior to the manager's first full season.