# Lahman Baseball Database – SQL Analysis Project  

This project explores the **Lahman Baseball Database**, a comprehensive dataset containing player, team, and game statistics from **1871 to 2016**.  
The goal was to practice advanced SQL queries, including joins, aggregations, window functions, correlated subqueries, and recursive CTEs.  

The project was completed as part of the **Nashville Software School (NSS) Data Analytics Bootcamp**, focusing on SQL analysis of real-world sports data.  

---

## Project Overview  

Using the Lahman database, I worked through structured exercises and open-ended analysis【144†source】:  

- Identify the shortest player in baseball history and his team.  
- List Vanderbilt University players and their total MLB salaries.  
- Group putouts by **Infield, Outfield, and Battery** positions (2016).  
- Track strikeouts and home runs per game by decade since 1920.  
- Identify the most successful base stealers in 2016.  
- Compare World Series winners vs. teams with the most wins (1970–2016).  
- Evaluate correlations between **team salaries, wins, and attendance**.  
- Analyze left-handed vs. right-handed pitchers for effectiveness and Hall of Fame presence.  
- Use **LATERAL joins and recursive CTEs** to explore league records, player careers, and All-Star game connections【145†source】【146†source】【148†source】【149†source】.  

---

## Data & Schema  

The Lahman Database includes:  
- **People** – Player biographical info  
- **Batting, Pitching, Fielding** – Career and seasonal stats  
- **Teams** – Team records, wins/losses, attendance, payroll  
- **Awards & Hall of Fame** – Player and manager honors  
- **Salaries** – Historical player salary data  
- **All-Star Games** – Participation and starting positions  
- **Parks & Home Games** – Ballpark and attendance data  

Entity-Relationship Diagram: `lahman_baseball_ERD.png`  

---

## Tools & Technologies Used  

- **PostgreSQL** – Database engine  
- **pgAdmin 4** – SQL IDE for query execution  
- **Advanced SQL Features** –  
  - Window Functions (`RANK`, `ROW_NUMBER`, `DENSE_RANK`)  
  - Correlated Subqueries  
  - LATERAL Joins  
  - Recursive CTEs  
- **Excel / Power Pivot (planned extension)** – For deeper exploration of open-ended questions  

---

## Key Insights  

- **Shortest Player** – Eddie Gaedel, 3’7”, who played for the **St. Louis Browns** in one game.  
- **Vanderbilt’s Top Earner** – David Price, with $81M in career MLB salary.  
- **Putouts (2016)** – Infielders led with 58,934; Battery positions 41,424; Outfield 29,560.  
- **Decade Trends** – Strikeouts and home runs per game steadily increased since 1920.  
- **Top Stealer (2016)** – Chris Owings, 91.3% stolen base success rate.  
- **Wins vs. WS Titles** – The 2001 Mariners had 116 wins but no title, while 1981 Dodgers won WS with only 63 wins due to strike-shortened season.  
- **Attendance Leaders (2016)** – Dodger Stadium topped with 45,720 average attendance per game.  
- **Cross-League Managers** – Davey Johnson and Jim Leyland both won TSN Manager of the Year in AL and NL.  
- **Pitcher Analysis** – Left-handed pitchers are rarer but not disproportionately represented in awards and HOF.  

---

## Learning Outcomes  

This project strengthened my SQL expertise in:  
- Writing **complex joins** across large historical datasets.  
- Using **window functions** for rankings and moving averages.  
- Leveraging **LATERAL joins** for flexible subqueries.  
- Applying **recursive CTEs** for network-style problems.  
- Translating real-world baseball questions into structured SQL queries.  

---

## Repository Contents  

- **lahman.backup** – PostgreSQL backup of full database  
- **lahman.sql** – SQL scripts for initial exercises  
- **lahman_bonus_1.sql** – Correlated subqueries and LATERAL join tasks  
- **lahman_bonus_2.sql** – Window function and recursive CTE tasks  
- **lahman.xlsx** – Spreadsheet version for pivot analysis  
- **data_dictionary.txt** – Data dictionary of all tables and fields  
- **lahman_baseball_ERD.png** – Database schema diagram  
- **README_task.md** – Initial project tasks  
- **README_task_bonus_1.md** – Bonus subquery & LATERAL tasks  
- **README_task_bonus_2_window.md** – Bonus window & recursive tasks  

---

This project demonstrates how **advanced SQL techniques** can unlock insights from one of the richest open datasets in sports history – Major League Baseball.  
