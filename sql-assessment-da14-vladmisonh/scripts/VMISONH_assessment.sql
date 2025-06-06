-- ### Assessment
-- **Write SQL Queries to answer the questions below. Save your queries to a `.sql` script along with the answers (as comments) 
-- to the questions posed.**

-- 1. The poetry in this database is the work of children in grades 1 through 5.  
--     a. How many poets from each grade are represented in the data?  

SELECT 
	--grade_id,
	g.name AS grade_name,
	COUNT(*) AS poets_in_grade
FROM author AS a
LEFT JOIN grade AS g
	ON a.grade_id = g.id
GROUP BY 1
ORDER BY poets_in_grade DESC;

-- Answer:
-- "5th Grade"	3464
-- "4th Grade"	3288
-- "3rd Grade"	2344
-- "2nd Grade"	1437
-- "1st Grade"	623

--     b. How many of the poets in each grade are Male and how many are Female? Only return the poets identified as Male or Female.  

SELECT 
    -- a.grade_id,
    g1.name AS grade_name,
    g2.name AS poets_gender,
    COUNT(*) AS poets_in_grade
FROM author AS a
LEFT JOIN grade AS g1 
	ON a.grade_id = g1.id
LEFT JOIN gender AS g2 
	ON a.gender_id = g2.id
WHERE g2.name IN ('Male', 'Female') 
GROUP BY 1,2
ORDER BY grade_name DESC;

-- Answer:
-- "5th Grade"	"Male"	757
-- "5th Grade"	"Female"	1294
-- "4th Grade"	"Male"	723
-- "4th Grade"	"Female"	1241
-- "3rd Grade"	"Female"	948
-- "3rd Grade"	"Male"	577
-- "2nd Grade"	"Male"	412
-- "2nd Grade"	"Female"	605
-- "1st Grade"	"Male"	163
-- "1st Grade"	"Female"	243

--     c. Do you notice any trends across all grades?

SELECT 
    g.name AS grade_name,
    SUM(CASE 
			WHEN g2.name = 'Female' THEN 1 
			ELSE 0 END) AS female_count,
    SUM(CASE 
			WHEN g2.name = 'Male' THEN 1 
			ELSE 0 END) AS male_count,
    ROUND(
        CAST(SUM(CASE 
					WHEN g2.name = 'Female' THEN 1 
					ELSE 0 END) AS DECIMAL) / 
        SUM(CASE WHEN g2.name = 'Male' THEN 1 ELSE 0 END), 2
    ) AS female_to_male_ratio
FROM author AS a
LEFT JOIN grade AS g 
    ON a.grade_id = g.id
LEFT JOIN gender AS g2 
    ON a.gender_id = g2.id
WHERE g2.name IN ('Male', 'Female') 
GROUP BY 1
ORDER BY grade_name DESC;

-- Answer:
-- The number of poets increases from the younger grades to the older ones
-- In all grades, the number of girls is higher than that of boys.

-- 2. Love and death have been popular themes in poetry throughout time. Which of these things do children write about more often? 
-- Which do they have the most to say about when they do? Return the **total number** of poems that mention **love** and **total number** 
-- that mention the word **death**, and return the **average character count** for poems that mention **love** and also for poems 
-- that mention the word **death**. Do this in a single query.

-- In the following query, I show the number of occurrences of these words separately for title and text 
WITH num_in_title AS 
(
	(
	SELECT 
		'death' AS key_word,
		COUNT(*) AS num_in_title,
		ROUND(AVG(LENGTH(text)),2) AS avg_text_length
	FROM poem
	WHERE LOWER(title) LIKE '%death%'
	)
	UNION
	(
	SELECT 
		'love' AS key_word,
		COUNT(*) AS num_in_title,
		ROUND(AVG(LENGTH(text)),2) AS avg_text_length
	FROM poem
	WHERE LOWER(title) LIKE '%love%'
	)
),
num_in_text AS 
(
	(
	SELECT 
		'death' AS key_word,
		COUNT(*) AS num_in_text,
		ROUND(AVG(LENGTH(text)),2) AS avg_text_length
	FROM poem
	WHERE LOWER(text) LIKE '%death%'
	)
	UNION
	(
	SELECT 
		'love' AS key_word,
		COUNT(*) AS num_in_text,
		ROUND(AVG(LENGTH(text)),2) AS avg_text_length
	FROM poem
	WHERE LOWER(text) LIKE '%love%'
	)
)
SELECT *
FROM num_in_title AS n1
LEFT JOIN num_in_text AS n2
	USING(key_word);

--====================================================

WITH keyword_stats_in_text AS (
    (
		SELECT 
	        'death' AS key_word,
	        COUNT(*) AS num_in_text,
	        ROUND(AVG(LENGTH(text)),2) AS avg_text_length
	    FROM poem
	    WHERE LOWER(text) LIKE '%death%'
    )
    UNION ALL
    (
	    SELECT 
	        'love' AS key_word,
	        COUNT(*) AS num_in_text,
	        ROUND(AVG(LENGTH(text)),2) AS avg_text_length
	    FROM poem
	    WHERE LOWER(title) LIKE '%love%'
	)
),
total_counts AS (
    SELECT 
		SUM(num_in_text) AS total 
	FROM keyword_stats_in_text
)
SELECT 
    ks.key_word, 
    ks.num_in_text, 
    ks.avg_text_length, 
    ROUND(ks.num_in_text / t.total * 100, 2) AS title_percentage
FROM keyword_stats_in_text AS ks
	CROSS JOIN total_counts AS t
ORDER BY ks.key_word;

-- Answer:
-- "death"	86	346.21	12.22
-- "love"	618	200.25	87.78
-- children write about love more often

-- 3. Do longer poems have more emotional intensity compared to shorter poems?  
-- a. Start by writing a query to return each emotion in the database with its average intensity and average character count.   
--      - Which emotion is associated the longest poems on average?  
--      - Which emotion has the shortest?  

SELECT 
	RANK() OVER (ORDER BY AVG(LENGTH(p.text)) DESC) AS rank,
	--pe.emotion_id,
	e.name,
	ROUND(AVG(LENGTH(text)),2) AS avg_text_length
FROM poem AS p
LEFT JOIN poem_emotion AS pe
	ON p.id = pe.poem_id
LEFT JOIN emotion AS e
	ON pe.emotion_id = e.id
WHERE pe.emotion_id IS NOT NULL
GROUP BY 2
ORDER BY avg_text_length DESC;

-- Answer:
-- 1	"Anger"	262.63
-- 4	"Joy"	221.73

--     b. Convert the query you wrote in part a into a CTE. Then find the 5 most intense poems that express joy and whether 
-- they are to be longer or shorter than the average joy poem.   
--      -  What is the most joyful poem about?  
--      -  Do you think these are all classified correctly?

WITH avg_length_by_emotion AS (
	SELECT 
		-- RANK() OVER (ORDER BY AVG(LENGTH(p.text)) DESC) AS rank,
		--pe.emotion_id,
		e.name AS emotion_name,
		ROUND(AVG(LENGTH(text)),2) AS avg_text_length
	FROM poem AS p
	LEFT JOIN poem_emotion AS pe
		ON p.id = pe.poem_id
	LEFT JOIN emotion AS e
		ON pe.emotion_id = e.id
	WHERE pe.emotion_id IS NOT NULL
	GROUP BY 1
	ORDER BY avg_text_length DESC
),
top_5_joy AS 
(
	SELECT 
		p.id AS poem_id,
		p.title,
		p.text,
		LENGTH(p.text) AS poem_length,
		pe.intensity_percent,
		e.name AS emotion_name
	FROM poem AS p
		LEFT JOIN poem_emotion AS pe
			ON p.id = pe.poem_id
		LEFT JOIN emotion AS e
			ON pe.emotion_id = e.id
	WHERE e.name LIKE 'Joy'
	ORDER BY intensity_percent DESC
	LIMIT 5
)
SELECT 
	t5.poem_id,
	t5.title,
	t5.text,
	t5.poem_length,
	a.avg_text_length,
	CASE 
		WHEN t5.poem_length > a.avg_text_length THEN 'Longer'
		WHEN t5.poem_length < a.avg_text_length THEN 'Shorter'
		ELSE 'Same'
	END AS length_comparison
FROM top_5_joy AS t5
JOIN avg_length_by_emotion AS a 
	ON t5.emotion_name = a.emotion_name;

-- Answer:
-- The most joyful poem among the 5 most intense poems expressing joy is "My Dog." It describes how the author rejoices for his dog.
-- According to the results, some of the poems may be misclassified. For example:
-- "Dark" is a poem about depression, although it was listed as a "Joy" poem due to its high intensity


-- 4. Compare the 5 most angry poems by 1st graders to the 5 most angry poems by 5th graders.  

-- 	a. Which group writes the angreist poems according to the intensity score?  

WITH top_5_angry_1st AS 
(
	SELECT 
		p.id AS poem_id,
		p.title,
		p.text,
		LENGTH(p.text) AS poem_length,
		pe.intensity_percent,
		e.name AS emotion_name,
		g.name AS grade_name
	FROM poem AS p
		LEFT JOIN poem_emotion AS pe
			ON p.id = pe.poem_id
		LEFT JOIN emotion AS e
			ON pe.emotion_id = e.id
		LEFT JOIN author AS a
			ON p.author_id = a.id
		LEFT JOIN grade AS g
			ON a.grade_id = g.id
	WHERE e.name LIKE 'Anger'
		AND g.name LIKE '%1%'
	ORDER BY intensity_percent DESC
	LIMIT 5
),
top_5_angry_5th AS 
(
	SELECT 
		p.id AS poem_id,
		p.title,
		p.text,
		LENGTH(p.text) AS poem_length,
		pe.intensity_percent,
		e.name AS emotion_name,
		g.name AS grade_name
	FROM poem AS p
		LEFT JOIN poem_emotion AS pe
			ON p.id = pe.poem_id
		LEFT JOIN emotion AS e
			ON pe.emotion_id = e.id
		LEFT JOIN author AS a
			ON p.author_id = a.id
		LEFT JOIN grade AS g
			ON a.grade_id = g.id
	WHERE e.name LIKE 'Anger'
		AND g.name LIKE '%5%'
	ORDER BY intensity_percent DESC
	LIMIT 5
),
combined_data AS (
	SELECT *
	FROM top_5_angry_1st
	UNION ALL
	SELECT *
	FROM top_5_angry_5th
)
SELECT *
FROM combined_data
ORDER BY intensity_percent DESC;

-- Answer:
-- 5th grade group writes the angriest poems according to the intensity score
	
--     b. Who shows up more in the top five for grades 1 and 5, males or females? 

WITH top_5_angry_1st AS 
(
	SELECT 
		p.id AS poem_id,
		p.title,
		p.text,
		LENGTH(p.text) AS poem_length,
		pe.intensity_percent,
		e.name AS emotion_name,
		g.name AS grade_name,
		a.gender_id
	FROM poem AS p
		LEFT JOIN poem_emotion AS pe
			ON p.id = pe.poem_id
		LEFT JOIN emotion AS e
			ON pe.emotion_id = e.id
		LEFT JOIN author AS a
			ON p.author_id = a.id
		LEFT JOIN grade AS g
			ON a.grade_id = g.id
	WHERE e.name LIKE 'Anger'
		AND g.name LIKE '%1%'
	ORDER BY intensity_percent DESC
	LIMIT 5
),
top_5_angry_5th AS 
(
	SELECT 
		p.id AS poem_id,
		p.title,
		p.text,
		LENGTH(p.text) AS poem_length,
		pe.intensity_percent,
		e.name AS emotion_name,
		g.name AS grade_name,
		a.gender_id
	FROM poem AS p
		LEFT JOIN poem_emotion AS pe
			ON p.id = pe.poem_id
		LEFT JOIN emotion AS e
			ON pe.emotion_id = e.id
		LEFT JOIN author AS a
			ON p.author_id = a.id
		LEFT JOIN grade AS g
			ON a.grade_id = g.id
	WHERE e.name LIKE 'Anger'
		AND g.name LIKE '%5%'
	ORDER BY intensity_percent DESC
	LIMIT 5
),
combined_data AS (
	SELECT *
	FROM top_5_angry_1st
	UNION ALL
	SELECT *
	FROM top_5_angry_5th
)
SELECT
	COUNT(CASE
			WHEN c.gender_id = 1 THEN 1
			ELSE NULL END) AS num_of_female,
	COUNT(CASE
			WHEN c.gender_id = 2 THEN 1
			ELSE NULL END) AS num_of_male
FROM combined_data AS c;

-- Answer: 
-- Female shows up more in the top five for grades 1 and 5

--     c. Which of these do you like the best?

-- Answer:
-- I like the poem called "CHEESE?", it conveys all possible experiences around this subject

-- 5. Emily Dickinson was a famous American poet, who wrote many poems in the 1800s, including one about a caterpillar that begins:

-- 	  	> A fuzzy fellow, without feet,
-- 		> Yet doth exceeding run!
-- 		> Of velvet, is his Countenance,
-- 		> And his Complexion, dun!

-- 	a. Examine the poets in the database with the name `emily`. Create a report showing the count of emilys by grade along 
-- with the distribution of emotions that characterize their work.  

SELECT 
	--a.grade_id,
	g.name AS grade,
	COUNT(DISTINCT a.id) AS num_of_emily,
	ROUND(AVG(p2.intensity_percent),2) AS avg_intensity
FROM author AS a
LEFT JOIN grade AS g
	ON a.grade_id = g.id
LEFT JOIN poem AS p1
	ON a.id = p1.author_id
LEFT JOIN poem_emotion AS p2
	ON p1.id = p2.poem_id
WHERE LOWER(a.name) LIKE '%emily%'
GROUP BY 1;

-- Answer:
-- "1st Grade"	1	47.00
-- "2nd Grade"	1	44.07
-- "3rd Grade"	2	42.83
-- "4th Grade"	3	44.40
-- "5th Grade"	4	44.09

-- 	b. Export this report to Excel and create a visualization that shows what you have found.

SELECT 
	--a.grade_id,
	g.name AS grade,
	COUNT(DISTINCT a.id) AS num_of_emily,
	COUNT(p1.author_id) AS total_num_of_poems,
	COUNT(p1.author_id)/COUNT(DISTINCT a.id) AS avg_num_of_poems,
	ROUND(AVG(p2.intensity_percent),2) AS avg_intensity
FROM author AS a
LEFT JOIN grade AS g
	ON a.grade_id = g.id
LEFT JOIN poem AS p1
	ON a.id = p1.author_id
LEFT JOIN poem_emotion AS p2
	ON p1.id = p2.poem_id
WHERE LOWER(a.name) LIKE '%emily%'
GROUP BY 1;

-- Answer:
-- The number of "emily" authors increases with each grade
-- The trend of avg number of poems per author increases by grades
-- The trend of avg intensity of poems per author decreases by grades