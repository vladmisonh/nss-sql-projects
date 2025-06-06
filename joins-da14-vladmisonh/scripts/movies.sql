-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT
	s.film_title,
	s.release_year,
	r.worldwide_gross
FROM specs AS s
	INNER JOIN revenue AS r
	USING(movie_id)
ORDER BY r.worldwide_gross ASC
LIMIT 1;

-- Answer: "Semi-Tough"	1977	37187139

-- 2. What year has the highest average imdb rating?

SELECT 
	s.release_year,
	ROUND(AVG(r.imdb_rating),2)
FROM specs AS s
	INNER JOIN rating AS r
	USING(movie_id)
GROUP BY 1
ORDER BY AVG(r.imdb_rating) DESC
LIMIT 1;

-- Answer: 1991	7.45

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT 
	s.film_title,
	d.company_name,
	r.worldwide_gross,
	s.mpaa_rating
FROM specs AS s
	INNER JOIN distributors as d
	ON s.domestic_distributor_id = d.distributor_id
	INNER JOIN revenue AS r
	USING(movie_id)
WHERE s.mpaa_rating = 'G'
ORDER BY r.worldwide_gross DESC
LIMIT 1;

-- Answer: 	"Toy Story 4"	"Walt Disney "	1073394593	"G"

-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies 
-- table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT
	d.company_name AS distributor,
	COUNT(s.film_title) AS number_of_movies
FROM distributors as d
	LEFT JOIN specs AS s
	ON d.distributor_id = s.domestic_distributor_id
GROUP BY 1
ORDER BY number_of_movies DESC;

-- 5. Write a query that returns the five distributors with the highest average movie budget.

SELECT
	d.company_name AS distributor,
	ROUND(AVG(r.film_budget),2) AS avg_movie_budget
FROM specs AS s
	INNER JOIN distributors AS d
	ON d.distributor_id = s.domestic_distributor_id
	INNER JOIN revenue AS r
	USING(movie_id)
GROUP BY 1
ORDER BY avg_movie_budget DESC
LIMIT 5;

-- Answer: 
-- "Walt Disney "	148735526.32
-- "Sony Pictures"	139129032.26
-- "Lionsgate"	122600000.00
-- "DreamWorks"	121352941.18
-- "Warner Bros."	103430985.92

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT 
	COUNT(DISTINCT(s.film_title)) AS count_of_movies_company_not_CA
FROM specs AS s
	INNER JOIN distributors AS d
	ON d.distributor_id = s.domestic_distributor_id
WHERE d.headquarters NOT LIKE '%CA';


SELECT 
	s.film_title,
	d.company_name AS distributor,
	d.headquarters,
	r.imdb_rating
FROM specs AS s
	INNER JOIN distributors AS d
	ON d.distributor_id = s.domestic_distributor_id
	INNER JOIN rating AS r
	USING(movie_id)
WHERE d.headquarters NOT LIKE '%CA'
GROUP BY 1,2,3,4
ORDER BY r.imdb_rating DESC;

-- Answer: 2 movies,
-- "Dirty Dancing"	"Vestron Pictures"	"Chicago, Illinois"	7.0

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT 
	ROUND(AVG(r.imdb_rating),2) AS avg_rating_movies_over_2_hour
FROM specs AS s
	INNER JOIN rating AS r
	USING(movie_id)
WHERE s.length_in_min > 120;

SELECT 
	ROUND(AVG(r.imdb_rating),2) AS avg_rating_movies_under_2_hour
FROM specs AS s
	INNER JOIN rating AS r
	USING(movie_id)
WHERE s.length_in_min < 120;

-- Answer: a higher average rating have a movies over 2 hour - 7.26 against 6.92
	