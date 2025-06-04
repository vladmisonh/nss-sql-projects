-- 1.	How many rows are in the data_analyst_jobs table?

SELECT 
	COUNT(*)
FROM data_analyst_jobs;

-- Answer: 1793

-- 2.	Write a query to look at just the first 10 rows. What company is associated with the job posting on the 10th row?

SELECT *
FROM data_analyst_jobs
LIMIT 10;

-- Answer: ExxonMobil

-- 3.	How many postings are in Tennessee? How many are there in either Tennessee or Kentucky?

SELECT COUNT(title) AS postings_in_TN
FROM data_analyst_jobs
WHERE location = 'TN';


SELECT COUNT(title) AS postings_in_TN_or_KY
FROM data_analyst_jobs
WHERE location IN ('TN', 'KY');

-- Answer: in TN - 21, in TN or KY - 27;

-- 4.	How many postings in Tennessee have a star rating above 4?

SELECT COUNT(title) AS postings_in_TN_rating_above_4
FROM data_analyst_jobs
WHERE location = 'TN'
	AND star_rating > 4;

-- Answer: 3

-- 5.	How many postings in the dataset have a review count between 500 and 1000?

SELECT COUNT(title) AS postings_review_count_500_to_1000
FROM data_analyst_jobs
WHERE review_count BETWEEN 500 AND 1000;

-- Answer: 151

-- 6.	Show the average star rating for companies in each state. The output should show the state as `state` and the average rating for the state as `avg_rating`. Which state shows the highest average rating?

SELECT location AS state,
	ROUND(AVG(star_rating),2) AS avg_rating
FROM data_analyst_jobs
GROUP BY location
ORDER BY avg_rating DESC;


SELECT location AS state,
	ROUND(AVG(star_rating),2) AS avg_rating
FROM data_analyst_jobs
WHERE star_rating IS NOT NULL
GROUP BY location
ORDER BY avg_rating DESC
LIMIT 1;

-- Answer: NE - 4.20

-- 7.	Select unique job titles from the data_analyst_jobs table. How many are there?

SELECT DISTINCT(title) AS uniq_title
FROM data_analyst_jobs;


SELECT COUNT(DISTINCT(title)) AS count_uniq_titles
FROM data_analyst_jobs;

-- Answer: 881

-- 8.	How many unique job titles are there for California companies?

SELECT COUNT(DISTINCT(title)) AS count_uniq_titles_for_CA
FROM data_analyst_jobs
WHERE location = 'CA';

-- Answer: 230

-- 9.	Find the name of each company and its average star rating for all companies that have more than 5000 reviews across all locations. How many companies are there with more that 5000 reviews across all locations?

SELECT company AS company_name, ROUND(AVG(star_rating),2) AS avg_rating
FROM data_analyst_jobs
WHERE review_count > 5000
	AND company IS NOT NULL
GROUP BY company
ORDER BY company_name;


SELECT COUNT(DISTINCT(company)) AS count_company_more_5000_reviews
FROM data_analyst_jobs
WHERE review_count > 5000;

-- Answer: 40

-- 10.	Add the code to order the query in #9 from highest to lowest average star rating. Which company with more than 5000 reviews across all locations in the dataset has the highest star rating? What is that rating?

SELECT company, ROUND(AVG(star_rating),2) AS avg_rating
FROM data_analyst_jobs
WHERE review_count > 5000
GROUP BY company
ORDER BY avg_rating DESC;

-- Answers: 
-- "General Motors"	4.20
-- "Unilever"	4.20
-- "Microsoft"	4.20
-- "Nike"	4.20
-- "American Express"	4.20
-- "Kaiser Permanente"	4.20

-- 11.	Find all the job titles that contain the word ‘Analyst’. How many different job titles are there? 

SELECT title
FROM data_analyst_jobs
WHERE LOWER(title) LIKE LOWER('%Analyst%');

SELECT COUNT(title)
FROM data_analyst_jobs
WHERE LOWER(title) LIKE LOWER('%Analyst%');

-- Answer: 1669

-- 12.	How many different job titles do not contain either the word ‘Analyst’ or the word ‘Analytics’? What word do these positions have in common?

SELECT title
FROM data_analyst_jobs
WHERE LOWER(title) NOT LIKE LOWER('%Analyst%')
	AND LOWER(title) NOT LIKE LOWER('%Analytics%');

SELECT COUNT(title)
FROM data_analyst_jobs
WHERE LOWER(title) NOT LIKE LOWER('%Analyst%')
	AND LOWER(title) NOT LIKE LOWER('%Analytics%');

-- Answer: 4

-- **BONUS:**
-- You want to understand which jobs requiring SQL are hard to fill. Find the number of jobs by industry (domain) that require SQL and have been posted longer than 3 weeks. 

SELECT domain AS industry, COUNT(title) AS count_jobs_SQL_skill
FROM data_analyst_jobs
WHERE skill LIKE '%SQL%'
	AND days_since_posting > 21
GROUP BY industry;

--  - Disregard any postings where the domain is NULL. 

SELECT domain AS industry, COUNT(title) AS count_jobs_SQL_skill
FROM data_analyst_jobs
WHERE skill LIKE '%SQL%'
	AND days_since_posting > 21
	AND domain IS NOT NULL
GROUP BY industry;

--  - Order your results so that the domain with the greatest number of `hard to fill` jobs is at the top. 

SELECT domain AS industry, COUNT(title) AS count_jobs_SQL_skill
FROM data_analyst_jobs
WHERE skill LIKE '%SQL%'
	AND days_since_posting > 21
	AND domain IS NOT NULL
GROUP BY industry
ORDER BY count_jobs_SQL_skill DESC;

--   - Which three industries are in the top 3 on this list? How many jobs have been listed for more than 3 weeks for each of the top 3?

SELECT domain AS industrie, COUNT(title) AS count_jobs_SQL_skill
FROM data_analyst_jobs
WHERE skill LIKE '%SQL%'
	AND days_since_posting > 21
	AND domain IS NOT NULL
GROUP BY industrie
ORDER BY count_jobs_SQL_skill DESC
LIMIT 3;

-- Answer:
-- "Internet and Software"	62
-- "Banks and Financial Services"	61
-- "Consulting and Business Services"	57