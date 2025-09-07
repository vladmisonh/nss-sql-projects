# Movie Database Analysis – SQL Joins Project  

This project explores a **PostgreSQL movie database** using SQL queries to analyze worldwide grosses, IMDb ratings, distributors, and film series. The database was built from a backup file and explored through joins, aggregations, and advanced SQL techniques.  

The project was completed as part of the **Nashville Software School (NSS) Data Analytics Bootcamp**, focusing on **SQL joins, grouping, filtering, and advanced queries**.  

---

## Project Overview  

Using the provided movie database schema (`movies.backup`), this project addressed analytical questions such as:  

- What is the **lowest grossing movie** and its revenue?  
- Which year had the **highest average IMDb rating**?  
- What is the **highest grossing G-rated movie** and who distributed it?  
- Which distributors released the most movies, and which had the **highest average budgets**?  
- How many movies were distributed by companies headquartered **outside California**?  
- Which movies over 2 hours had higher average IMDb ratings compared to those under 2 hours?  

A **bonus analysis** extended queries to:  
- Compare worldwide grosses of movies vs. their **sequels**.  
- Analyze **movie series** (using titles with colons) for number of installments and average ratings.  
- Explore string functions to count occurrences of words like “the” in titles.  
- Identify each distributor’s **highest rated movie**.  
- Detect distributors releasing movies in **consecutive years**.  

---

## Data & Schema  

The database includes the following core tables (see `movies_erd.png` for full ERD):  
- **specs** – Film titles, release years, runtime, MPAA ratings.  
- **rating** – IMDb ratings.  
- **revenue** – Worldwide grosses and budgets.  
- **distributors** – Film distributors and headquarters locations.  

---

## Tools & Technologies Used  

- **PostgreSQL** – Database engine  
- **pgAdmin 4** – Query execution and results exploration  
- **SQL Joins** – INNER JOIN, LEFT JOIN, and self-joins  
- **String Functions** – `TRIM`, `SPLIT_PART`, `LENGTH`, `REPLACE`  
- **Aggregations & Grouping** – `AVG`, `SUM`, `COUNT`  
- **Advanced SQL** – DISTINCT ON, LATERAL joins, OFFSET/LIMIT for ranking  

---

## Key Insights  

- **Lowest Grossing Film** – “Semi-Tough” (1977) with worldwide gross of $37M.  
- **Highest Avg IMDb Year** – 1991 with an average rating of 7.45.  
- **Top G-Rated Film** – “Toy Story 4” by Walt Disney, grossing $1.07B.  
- **Top Distributors by Budget** – Disney, Sony, Lionsgate, DreamWorks, Warner Bros.  
- **Outside CA Distributors** – Only 2 films, with “Dirty Dancing” (Vestron Pictures, Chicago) being top-rated.  
- **Runtime Analysis** – Films over 2 hours had higher average ratings (7.26) compared to shorter films (6.92).  
- **Sequels** – Analysis suggested sequels often generated **higher grosses** than originals.  
- **Series Analysis** – “Star Wars” had the most installments (9), while “Lord of the Rings” had the highest average IMDb rating (8.8).  

---

## Learning Outcomes  

This project improved my ability to:  
- Write complex SQL queries with multiple joins.  
- Perform **advanced text processing** in SQL.  
- Use **self-joins** to analyze relationships between sequels and series.  
- Apply **aggregation and ranking functions** to summarize large datasets.  
- Translate real-world movie industry questions into database queries.  

---

## Repository Contents  

- **movies.backup** – PostgreSQL backup file of the movie database  
- **movies_erd.png** – Entity Relationship Diagram (ERD) of database schema  
- **movies.sql** – SQL scripts answering main project tasks  
- **movies_bonus.sql** – SQL scripts answering bonus tasks  
- **movies_erd_schema.pgerd** – ERD schema source file  
- **README_task.md** – Project instructions  
- **README_task_bonus.md** – Bonus tasks instructions  

---

This analysis demonstrates how **SQL joins and advanced queries** can unlock insights from complex relational databases, applied here to the movie industry.  
