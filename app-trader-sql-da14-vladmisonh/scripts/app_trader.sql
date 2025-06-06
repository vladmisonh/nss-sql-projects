-- Based on research completed prior to launching App Trader as a company, you can assume the following:

-- a. App Trader will purchase apps for 10,000 times the price of the app. For apps that are priced from free up to $1.00, 
-- the purchase price is $10,000.   
-- - For example, an app that costs $2.00 will be purchased for $20,000.
-- - The cost of an app is not affected by how many app stores it is on. A $1.00 app on the Apple app store will cost 
-- the same as a $1.00 app on both stores. 

/*This query calculates the purchase price for apps from the App Store and Play Store. 
The price is 10,000 times the app's listed price, with a minimum of $10,000 for free or $1.00 apps. 
The results are ordered by the purchase price in descending order.*/

(
SELECT 
	a.name,
	'App Store' AS store_type,
	ROUND(a.price,2),
    CASE 
        WHEN CAST(a.price AS NUMERIC) < 1 THEN 10000
        ELSE CAST(a.price AS NUMERIC) * 10000 
    END AS purchase_price
FROM app_store_apps AS a
)
UNION ALL
(
SELECT 
	p.name,
	'Play Store' AS store_type,
	ROUND(CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC),2) AS price, 
    CASE 
        WHEN CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) < 1 THEN 10000
        ELSE CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) * 10000 
    END AS purchase_price
FROM play_store_apps AS p
)
ORDER BY purchase_price DESC;

-- - If an app is on both stores, it's purchase price will be calculated based off of the highest app price between 
-- the two stores. 

WITH combined_data AS (
	-- Apps only in the App Store
	SELECT 
		a.name,
		'App Store' AS store_type,
		ROUND(a.price,2),
	    CASE 
	        WHEN CAST(a.price AS NUMERIC) < 1 THEN 10000
	        ELSE CAST(a.price AS NUMERIC) * 10000 
	    END AS purchase_price
	FROM app_store_apps AS a
	WHERE a.name NOT IN (SELECT name FROM play_store_apps)
	
	UNION ALL
	
	-- Apps only in the Play Store
	SELECT 
		p.name,
		'Play Store' AS store_type,
		ROUND(CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC),2) AS price, 
	    CASE 
	        WHEN CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) < 1 THEN 10000
	        ELSE CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) * 10000 
	    END AS purchase_price
	FROM play_store_apps AS p
	WHERE p.name NOT IN (SELECT name FROM app_store_apps)
	
	UNION ALL
	
	-- Apps in both stores
	SELECT 
		p.name,
		'both' AS store_type,
		ROUND(CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC),2) AS price, 
	    CASE 
	        WHEN CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) < 1 THEN 10000
	        ELSE CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) * 10000 
	    END AS purchase_price
	FROM play_store_apps AS p
	JOIN app_store_apps AS a
		USING(name)
	WHERE p.name = a.name
	
)
, max_prices AS (
	SELECT DISTINCT ON (name) *
	FROM combined_data
	ORDER BY name, purchase_price DESC
)
SELECT *
FROM max_prices
-- FROM combined_data
-- WHERE name LIKE 'Cardiac diagnosis%'
-- WHERE store_type = 'both'
ORDER BY purchase_price DESC;


-- b. Apps earn $5000 per month, per app store it is on, from in-app advertising and in-app purchases, regardless of 
-- the price of the app.
-- - An app that costs $200,000 will make the same per month as an app that costs $1.00. 
-- - An app that is on both app stores will make $10,000 per month. 

WITH combined_data AS (
	-- Apps only in the App Store
	SELECT 
		a.name,
		'App Store' AS store_type,
		5000 AS earn_per_month,
		ROUND(a.price,2),
	    CASE 
	        WHEN CAST(a.price AS NUMERIC) < 1 THEN 10000
	        ELSE CAST(a.price AS NUMERIC) * 10000 
	    END AS purchase_price
	FROM app_store_apps AS a
	WHERE a.name NOT IN (SELECT name FROM play_store_apps)
	
	UNION ALL
	
	-- Apps only in the Play Store
	SELECT 
		p.name,
		'Play Store' AS store_type,
		5000 AS earn_per_month,
		ROUND(CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC),2) AS price, 
	    CASE 
	        WHEN CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) < 1 THEN 10000
	        ELSE CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) * 10000 
	    END AS purchase_price
	FROM play_store_apps AS p
	WHERE p.name NOT IN (SELECT name FROM app_store_apps)
	
	UNION ALL
	
	-- Apps in both stores
	SELECT 
		p.name,
		'both' AS store_type,
		10000 AS earn_per_month,
		ROUND(CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC),2) AS price, 
	    CASE 
	        WHEN CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) < 1 THEN 10000
	        ELSE CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) * 10000 
	    END AS purchase_price
	FROM play_store_apps AS p
	JOIN app_store_apps AS a
		USING(name)
	WHERE p.name = a.name
	
)
, max_prices AS (
	SELECT DISTINCT ON (name) *
	FROM combined_data
	ORDER BY name, purchase_price DESC
)
SELECT *
FROM max_prices
-- FROM combined_data
-- WHERE name LIKE 'Cardiac diagnosis%'
-- WHERE store_type = 'both'
ORDER BY earn_per_month DESC, purchase_price ASC;

-- c. App Trader will spend an average of $1000 per month to market an app regardless of the price of the app. 
-- If App Trader owns rights to the app in both stores, it can market the app for both stores for 
-- a single cost of $1000 per month.
-- - An app that costs $200,000 and an app that costs $1.00 will both cost $1000 a month for marketing, 
-- regardless of the number of stores it is in.

WITH combined_data AS (
	-- Apps only in the App Store
	SELECT 
		a.name,
		'App Store' AS store_type,
		5000 AS earn_per_month,
		1000 AS spend_per_month,
		ROUND(a.price,2),
	    CASE 
	        WHEN CAST(a.price AS NUMERIC) < 1 THEN 10000
	        ELSE CAST(a.price AS NUMERIC) * 10000 
	    END AS purchase_price
	FROM app_store_apps AS a
	WHERE a.name NOT IN (SELECT name FROM play_store_apps)
	
	UNION ALL
	
	-- Apps only in the Play Store
	SELECT 
		p.name,
		'Play Store' AS store_type,
		5000 AS earn_per_month,
		1000 AS spend_per_month,
		ROUND(CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC),2) AS price, 
	    CASE 
	        WHEN CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) < 1 THEN 10000
	        ELSE CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) * 10000 
	    END AS purchase_price
	FROM play_store_apps AS p
	WHERE p.name NOT IN (SELECT name FROM app_store_apps)
	
	UNION ALL
	
	-- Apps in both stores
	SELECT 
		p.name,
		'both' AS store_type,
		10000 AS earn_per_month,
		1000 AS spend_per_month,
		ROUND(CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC),2) AS price, 
	    CASE 
	        WHEN CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) < 1 THEN 10000
	        ELSE CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) * 10000 
	    END AS purchase_price
	FROM play_store_apps AS p
	JOIN app_store_apps AS a
		USING(name)
	WHERE p.name = a.name
	
)
, max_prices AS (
	SELECT DISTINCT ON (name) *
	FROM combined_data
	ORDER BY name, purchase_price DESC
)
SELECT *
FROM max_prices
-- FROM combined_data
-- WHERE name LIKE 'Cardiac diagnosis%'
-- WHERE store_type = 'both'
ORDER BY earn_per_month DESC, purchase_price ASC;

-- d. For every half point that an app gains in rating, its projected lifespan increases by one year. 
-- In other words, an app with a rating of 0 can be expected to be in use for 1 year, an app 
-- with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years.
    
-- - App store ratings should be calculated by taking the average of the scores from both app stores and rounding 
-- to the nearest 0.5.

-- e. App Trader would prefer to work with apps that are available in both the App Store and 
-- the Play Store since they can market both for the same $1000 per month.

WITH combined_data AS (
	-- Apps only in the App Store
	SELECT 
		a.name,
		'App Store' AS store_type,
		5000 AS earn_per_month,
		1000 AS spend_per_month,
		COALESCE(a.rating, 0) AS rating,
		COALESCE(ROUND(1 + (ROUND(a.rating * 2, 0) / 2) * 2, 2),0) AS lifespan_years,
		ROUND(a.price,2) AS price,
	    CASE 
	        WHEN CAST(a.price AS NUMERIC) < 1 THEN 10000
	        ELSE CAST(a.price AS NUMERIC) * 10000 
	    END AS purchase_price
	FROM app_store_apps AS a
	WHERE a.name NOT IN (SELECT name FROM play_store_apps)
	
	UNION ALL
	
	-- Apps only in the Play Store
	SELECT 
		p.name,
		'Play Store' AS store_type,
		5000 AS earn_per_month,
		1000 AS spend_per_month,
		COALESCE(p.rating,0) AS rating,
		COALESCE(ROUND(1 + (ROUND(p.rating * 2, 0) / 2) * 2, 2),0) AS lifespan_years,
		ROUND(CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC),2) AS price, 
	    CASE 
	        WHEN CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) < 1 THEN 10000
	        ELSE CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) * 10000 
	    END AS purchase_price
	FROM play_store_apps AS p
	WHERE p.name NOT IN (SELECT name FROM app_store_apps)
	
	UNION ALL
	
	-- Apps in both stores
	SELECT 
		p.name,
		'both' AS store_type,
		10000 AS earn_per_month,
		1000 AS spend_per_month,
		COALESCE(p.rating,0) AS rating,
		COALESCE(ROUND(1 + (ROUND(p.rating * 2, 0) / 2) * 2, 2),0) AS lifespan_years,
		ROUND(CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC),2) AS price, 
	    CASE 
	        WHEN CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) < 1 THEN 10000
	        ELSE CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) * 10000 
	    END AS purchase_price
	FROM play_store_apps AS p
	JOIN app_store_apps AS a
		USING(name)
	WHERE p.name = a.name
	
)
, max_prices AS (
	SELECT DISTINCT ON (name) *
	FROM combined_data
	ORDER BY name, purchase_price DESC
)
SELECT *
FROM max_prices
-- FROM combined_data
-- WHERE name LIKE 'Cardiac diagnosis%'
-- WHERE store_type = 'both'
ORDER BY earn_per_month DESC, purchase_price ASC;

-- #### 3. Deliverables

WITH combined_data AS (
	-- Apps only in the App Store
	SELECT 
		a.name,
		'App Store' AS store_type,
		CAST(a.review_count AS NUMERIC) AS review_count,
		5000 AS earn_per_month,
		1000 AS spend_per_month,
		COALESCE(a.rating, 0) AS rating,
		COALESCE(ROUND(1 + (ROUND(a.rating * 2, 0) / 2) * 2, 2),0) AS lifespan_years,
		ROUND(a.price,2) AS price,
	    CASE 
	        WHEN CAST(a.price AS NUMERIC) < 1 THEN 10000
	        ELSE CAST(a.price AS NUMERIC) * 10000 
	    END AS purchase_price
	FROM app_store_apps AS a
	WHERE a.name NOT IN (SELECT name FROM play_store_apps)
	
	UNION ALL
	
	-- Apps only in the Play Store
	SELECT 
		p.name,
		'Play Store' AS store_type,
		p.review_count,
		5000 AS earn_per_month,
		1000 AS spend_per_month,
		COALESCE(p.rating,0) AS rating,
		COALESCE(ROUND(1 + (ROUND(p.rating * 2, 0) / 2) * 2, 2),0) AS lifespan_years,
		ROUND(CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC),2) AS price, 
	    CASE 
	        WHEN CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) < 1 THEN 10000
	        ELSE CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) * 10000 
	    END AS purchase_price
	FROM play_store_apps AS p
	WHERE p.name NOT IN (SELECT name FROM app_store_apps)
	
	UNION ALL
	
	-- Apps in both stores
	SELECT 
		p.name,
		'both' AS store_type,
		p.review_count,
		10000 AS earn_per_month,
		1000 AS spend_per_month,
		COALESCE(GREATEST(p.rating, a.rating), 0) AS rating,
        COALESCE(ROUND(1 + (ROUND(GREATEST(p.rating, a.rating) * 2, 0) / 2) * 2, 2), 0) AS lifespan_years,
		ROUND(CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC),2) AS price, 
	    CASE 
	        WHEN CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) < 1 THEN 10000
	        ELSE CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC) * 10000 
	    END AS purchase_price
	FROM play_store_apps AS p
	JOIN app_store_apps AS a
		USING(name)
	WHERE p.name = a.name
	
)
, max_prices AS (
	SELECT DISTINCT ON (name) *
	FROM combined_data
	ORDER BY name, purchase_price DESC
)
SELECT *,
	(earn_per_month - spend_per_month)::MONEY AS profit_per_month,
	(((earn_per_month - spend_per_month) * 12) * lifespan_years)::MONEY AS life_time_profit,
	(((earn_per_month - spend_per_month) * 12) * lifespan_years - purchase_price)::MONEY AS total_profit
FROM max_prices
-- FROM combined_data
-- WHERE name LIKE 'Cardiac diagnosis%'
-- WHERE store_type = 'both'
--WHERE (((earn_per_month - spend_per_month) * 12) * lifespan_years - purchase_price)::MONEY = '$1,178,000.00'
ORDER BY total_profit DESC
LIMIT 10;

-- a. Develop some general recommendations as to the price range, genre, content rating, or anything else 
-- for apps that the company should target.

-- b. Develop a Top 10 List of the apps that App Trader should buy.


-- Query complete 00:00:00.071
WITH combined_data AS (
    SELECT 
        p.name,
        --'both' AS store_type,
        --p.review_count,
        10000 AS earn_per_month,
        1000 AS spend_per_month,
		
        ROUND(COALESCE((p.rating+a.rating)/2, 0),2) AS rating,

        COALESCE(ROUND(1 + (ROUND((p.rating+a.rating)/2 * 2, 0) / 2) * 2, 2), 0) AS lifespan_years,

        ROUND(
            GREATEST(
                CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC),
                CAST(a.price AS NUMERIC)
            ), 2
        ) AS price, 

        CASE 
            WHEN GREATEST(
                CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC),
                CAST(a.price AS NUMERIC)
            ) < 1 THEN 10000
            ELSE GREATEST(
                CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC),
                CAST(a.price AS NUMERIC)
            ) * 10000
        END AS purchase_price
    FROM play_store_apps AS p
    JOIN app_store_apps AS a USING(name)
    WHERE p.name = a.name
)
, max_prices AS (
    SELECT DISTINCT ON (name) *
    FROM combined_data
    ORDER BY name, purchase_price DESC, rating DESC, price DESC
)
SELECT *,
    (earn_per_month - spend_per_month)::MONEY AS profit_per_month,
    (((earn_per_month - spend_per_month) * 12) * lifespan_years)::MONEY AS life_time_profit,
    (((earn_per_month - spend_per_month) * 12) * lifespan_years - purchase_price)::MONEY AS total_profit
FROM max_prices
ORDER BY total_profit DESC
LIMIT 10;


-- Query complete 00:00:00.074
WITH combined_data AS (
    SELECT DISTINCT ON (name) name,
        -- 'both' AS store_type,
        -- p.review_count,

        10000 AS earn_per_month,  -- Monthly earnings fixed at 10,000
        1000 AS spend_per_month,  -- Monthly spending fixed at 1,000

        -- Calculate the average rating for the app in both stores
        ROUND(COALESCE((p.rating + a.rating) / 2, 0), 2) AS avg_rating,

        -- Calculate the lifespan_years based on the average rating
        COALESCE(ROUND(1 + (ROUND((p.rating + a.rating) / 2 * 2, 0) / 2) * 2, 2), 0) AS lifespan_years,

        -- Returning the highest application price between both stores
        ROUND(
            GREATEST(
                CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC),
                CAST(a.price AS NUMERIC)
            ), 2
        ) AS app_price,

        -- Calculate the purchase price by multiplying the app price by 10,000
        CASE 
            WHEN GREATEST(
                CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC),
                CAST(a.price AS NUMERIC)
            ) < 1 THEN 10000
            ELSE GREATEST(
                CAST(REGEXP_REPLACE(p.price, '[^0-9.]', '', 'g') AS NUMERIC),
                CAST(a.price AS NUMERIC)
            ) * 10000
        END AS purchase_price
    FROM play_store_apps AS p
    JOIN app_store_apps AS a USING(name)
    WHERE p.name = a.name
    ORDER BY name, purchase_price DESC, avg_rating DESC, app_price DESC
)
SELECT *,
	--Calculate monthly profit
    (earn_per_month - spend_per_month)::MONEY AS profit_per_month,
	-- Calculate lifetime profit (assuming 12 months per year)
    (((earn_per_month - spend_per_month) * 12) * lifespan_years)::MONEY AS life_time_profit,  
	-- Calculate total profit considering purchase price
    (((earn_per_month - spend_per_month) * 12) * lifespan_years - purchase_price)::MONEY AS total_profit  
FROM combined_data
ORDER BY total_profit DESC
LIMIT 10;


-- c. Submit a report based on your findings. All analysis work must be done using PostgreSQL, however you may 
-- export query results to create charts in Excel for your report. 