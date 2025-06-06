-- 1.	Find the total worldwide gross and average imdb rating by decade. Then alter your query so it returns JUST the second highest average imdb rating and its decade. 
-- This should result in a table with just one row.

SELECT
	FLOOR(s.release_year/10)*10 AS decade,
	SUM(r1.worldwide_gross),
	ROUND(AVG(r2.imdb_rating),2) AS avg_imdb_rating
FROM specs AS s
	INNER JOIN revenue AS r1
	USING(movie_id)
	INNER JOIN rating AS r2
	USING(movie_id)
GROUP BY 1
ORDER BY avg_imdb_rating DESC
LIMIT 1 OFFSET 1;

-- 2.	Our goal in this question is to compare the worldwide gross for movies compared to their sequels.   
-- 	a.	Start by finding all movies whose titles end with a space and then the number 2.  

SELECT s.film_title
FROM specs AS s
WHERE s.film_title LIKE '% 2'
	OR s.film_title LIKE '% II';

-- 	b.	For each of these movies, create a new column showing the original film’s name by removing the last two characters of the film title. 
-- For example, for the film “Cars 2”, the original title would be “Cars”. Hint: You may find the string functions listed in Table 9-10 
-- of https://www.postgresql.org/docs/current/functions-string.html to be helpful for this. 

SELECT 
    s.film_title, 
    TRIM(LEFT(s.film_title, LENGTH(s.film_title) - 2)) AS original_film
FROM specs AS s
WHERE s.film_title LIKE '% 2'
   OR s.film_title LIKE '% II';

-- 	c.	Bonus: This method will not work for movies like “Harry Potter and the Deathly Hallows: Part 2”, where the original title should be “Harry Potter and the Deathly Hallows: Part 1”. 
-- Modify your query to fix these issues.  

SELECT 
    s.film_title, 
    CASE 
        WHEN s.film_title LIKE '%Vol. 2' 
            THEN TRIM(LEFT(s.film_title, LENGTH(s.film_title) - 2)) || ' 1'
		WHEN s.film_title LIKE '%Part 2' 
            THEN TRIM(LEFT(s.film_title, LENGTH(s.film_title) - 2)) || ' 1'
        WHEN s.film_title LIKE '%Part II' 
            THEN TRIM(FROM LEFT(s.film_title, LENGTH(s.film_title) - 2)) || ' I'
        ELSE TRIM(FROM LEFT(s.film_title, LENGTH(s.film_title) - 2))
    END AS original_film
FROM specs AS s
WHERE s.film_title LIKE '% 2'
   OR s.film_title LIKE '% II';

-- 	d.	Now, build off of the query you wrote for the previous part to pull in worldwide revenue for both the original movie and its sequel. 
-- Do sequels tend to make more in revenue? Hint: You will likely need to perform a self-join on the specs table in order to get the movie_id values for both the original films and their sequels. 
-- Bonus: A common data entry problem is trailing whitespace. In this dataset, it shows up in the film_title field, where the movie “Deadpool” is recorded as “Deadpool “. 
-- One way to fix this problem is to use the TRIM function. Incorporate this into your query to ensure that you are matching as many sequels as possible.

SELECT 
    sequel.film_title AS sequel_title, 
	r_sequel.worldwide_gross AS sequel_revenue,
    original.film_title AS original_title,
	r_original.worldwide_gross AS original_revenue
FROM specs AS sequel
	LEFT JOIN revenue AS r_sequel
		ON sequel.movie_id = r_sequel.movie_id
	LEFT JOIN specs AS original
		ON (
			CASE 
		        WHEN sequel.film_title LIKE '%Vol. 2' 
		            THEN TRIM(LEFT(sequel.film_title, LENGTH(sequel.film_title) - 2)) || ' 1'
				WHEN sequel.film_title LIKE '%Part 2' 
		            THEN TRIM(FROM LEFT(sequel.film_title, LENGTH(sequel.film_title) - 2)) || ' 1'
		        WHEN sequel.film_title LIKE '%Part II' 
		            THEN TRIM(LEFT(sequel.film_title, LENGTH(sequel.film_title) - 2)) || ' I'
		        ELSE TRIM(FROM LEFT(sequel.film_title, LENGTH(sequel.film_title) - 2))
		    END = original.film_title
			)
	LEFT JOIN revenue AS r_original
		ON original.movie_id = r_original.movie_id
WHERE sequel.film_title LIKE '% 2'
   OR sequel.film_title LIKE '% II';

-- 3.	Sometimes movie series can be found by looking for titles that contain a colon. For example, Transformers: Dark of the Moon is part of the Transformers series of films.  
-- 	a.	Write a query which, for each film will extract the portion of the film name that occurs before the colon. For example, “Transformers: Dark of the Moon” should result in “Transformers”.  
-- If the film title does not contain a colon, it should return the full film name. For example, “Transformers” should result in “Transformers”. 
-- Your query should return two columns, the film_title and the extracted value in a column named series. Hint: You may find the split_part function useful for this task.

SELECT 
	film_title,
	SPLIT_PART(film_title, ':', 1) AS series
FROM specs;

-- 	b.	Keep only rows which actually belong to a series. Your results should not include “Shark Tale” but should include both “Transformers” and “Transformers: Dark of the Moon”. 
-- Hint: to accomplish this task, you could use a WHERE clause which checks whether the film title either contains a colon or is in the list of series values for films that do contain a colon.  

SELECT 
	film_title,
	SPLIT_PART(film_title, ':', 1) AS series
FROM specs
WHERE film_title LIKE '%:%';

-- 	c.	Which film series contains the most installments?  

SELECT 
    SPLIT_PART(film_title, ':', 1) AS series,
    COUNT(*) AS installment_count
FROM specs
WHERE film_title LIKE '%:%'
GROUP BY series
ORDER BY installment_count DESC
LIMIT 1;

-- Answer: "Star Wars"	9

-- 	d.	Which film series has the highest average imdb rating? Which has the lowest average imdb rating?

SELECT 	
	series,
	ROUND(AVG(rating.imdb_rating),2) AS avg_series_imdb_rating
FROM (
		SELECT 
			movie_id,
		    SPLIT_PART(film_title, ':', 1) AS series
		FROM specs
		WHERE film_title LIKE '%:%'
		) AS series_title
	INNER JOIN rating
	USING (movie_id)
GROUP BY series
ORDER BY avg_series_imdb_rating DESC
LIMIT 1;

-- Answer: "The Lord of the Rings"	8.80

-- 4.	How many film titles contain the word “the” either upper or lowercase? How many contain it twice? three times? four times? 
-- Hint: Look at the sting functions and operators here: https://www.postgresql.org/docs/current/functions-string.html 

SELECT 
    film_title,
    (LENGTH(LOWER(film_title)) - LENGTH(REPLACE(LOWER(film_title), 'the ', ''))) / LENGTH('the ') AS occurrences
FROM specs;


SELECT 
    occurrences,
    COUNT(*) AS film_count
FROM (
    SELECT 
        (LENGTH(LOWER(film_title)) - LENGTH(REPLACE(LOWER(film_title), 'the', ''))) / LENGTH('the') AS occurrences
    FROM specs
) AS sub
GROUP BY occurrences
ORDER BY occurrences;

-- Answer:
-- 0	284
-- 1	128
-- 2	12
-- 3	3
-- 4	3

-- 5.	For each distributor, find its highest rated movie. Report the company name, the film title, and the imdb rating. 
-- Hint: you may find the LATERAL keyword useful for this question. This keyword allows you to join two or more tables together and to reference columns provided by preceding FROM items in later items. 
-- See this article for examples of lateral joins in postgres: https://www.cybertec-postgresql.com/en/understanding-lateral-joins-in-postgresql/ 

SELECT 
    d.company_name AS distributor_name, 
    s.film_title, 
    r.imdb_rating
FROM distributors AS d
	JOIN specs AS s 
		ON d.distributor_id = s.domestic_distributor_id
	JOIN rating AS r 
		ON s.movie_id = r.movie_id
WHERE r.imdb_rating = (
    SELECT 
		MAX(r2.imdb_rating) 
    FROM specs AS s2
    JOIN rating AS r2 
		ON s2.movie_id = r2.movie_id
    WHERE s2.domestic_distributor_id = d.distributor_id
)
ORDER BY d.company_name;


-- 6.	Follow-up: Another way to answer 5 is to use DISTINCT ON so that your query returns only one row per company. 
-- You can read about DISTINCT ON on this page: https://www.postgresql.org/docs/current/sql-select.html. 

SELECT DISTINCT ON (d.company_name) 
    d.company_name AS distributor_name, 
    s.film_title, 
    r.imdb_rating
FROM distributors AS d
	JOIN specs AS s 
		ON d.distributor_id = s.domestic_distributor_id
	JOIN rating AS r 
		ON s.movie_id = r.movie_id
ORDER BY d.company_name, r.imdb_rating DESC;


-- 7.	Which distributors had movies in the dataset that were released in consecutive years? 
-- For example, Orion Pictures released Dances with Wolves in 1990 and The Silence of the Lambs in 1991. 
-- Hint: Join the specs table to itself and think carefully about what you want to join ON. 

SELECT DISTINCT 
    d.company_name AS distributor_name, 
	s1.film_title,
    s1.release_year AS year_1, 
	s2.film_title,
    s2.release_year AS year_2
FROM specs AS s1
	JOIN specs AS s2 
	    ON s1.domestic_distributor_id = s2.domestic_distributor_id
	    AND s1.release_year = s2.release_year - 1
	JOIN distributors AS d 
	    ON s1.domestic_distributor_id = d.distributor_id
ORDER BY d.company_name, s1.release_year;
