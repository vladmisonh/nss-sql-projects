-- 1. How many npi numbers appear in the prescriber table but not in the prescription table?

SELECT
	COUNT(npi)
FROM prescriber AS p1
	LEFT JOIN prescription AS p2
		USING(npi)
WHERE p2.npi IS NULL;

-- Answer: 4458

-- 2.
--     a. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Family Practice.

SELECT 
    d.generic_name,
    SUM(p2.total_claim_count) AS total_claims
FROM prescriber AS p
LEFT JOIN prescription AS p2 
    USING(npi)
LEFT JOIN drug AS d 
    ON p2.drug_name = d.drug_name
WHERE p.specialty_description = 'Family Practice'
	AND d.generic_name IS NOT NULL
GROUP BY d.generic_name
ORDER BY total_claims DESC
LIMIT 5;

-- Answer:
-- "LEVOTHYROXINE SODIUM"	406547
-- "LISINOPRIL"	311506
-- "ATORVASTATIN CALCIUM"	308523
-- "AMLODIPINE BESYLATE"	304343
-- "OMEPRAZOLE"	273570

--     b. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Cardiology.

SELECT 
    d.generic_name,
    SUM(p2.total_claim_count) AS total_claims
FROM prescriber AS p
LEFT JOIN prescription AS p2 
    USING(npi)
LEFT JOIN drug AS d 
    ON p2.drug_name = d.drug_name
WHERE p.specialty_description = 'Cardiology'
	AND d.generic_name IS NOT NULL
GROUP BY d.generic_name
ORDER BY total_claims DESC
LIMIT 5;

-- Answer:
-- "ATORVASTATIN CALCIUM"	120662
-- "CARVEDILOL"	106812
-- "METOPROLOL TARTRATE"	93940
-- "CLOPIDOGREL BISULFATE"	87025
-- "AMLODIPINE BESYLATE"	86928

--     c. Which drugs are in the top five prescribed by Family Practice prescribers and Cardiologists? Combine what you did for parts a and b into a single query to answer this question.

(SELECT * FROM(
	SELECT
	    d.generic_name,
		p.specialty_description,
	    SUM(p2.total_claim_count) AS total_claims
	FROM prescriber AS p
	LEFT JOIN prescription AS p2 
	    USING(npi)
	LEFT JOIN drug AS d 
	    ON p2.drug_name = d.drug_name
	WHERE p.specialty_description = 'Family Practice'
		AND d.generic_name IS NOT NULL
	GROUP BY 1,2
	ORDER BY total_claims DESC
	LIMIT 5
))
UNION
(SELECT * FROM(
	SELECT
	    d.generic_name,
		p.specialty_description,
	    SUM(p2.total_claim_count) AS total_claims
	FROM prescriber AS p
	LEFT JOIN prescription AS p2 
	    USING(npi)
	LEFT JOIN drug AS d 
	    ON p2.drug_name = d.drug_name
	WHERE p.specialty_description = 'Cardiology'
		AND d.generic_name IS NOT NULL
	GROUP BY 1,2
	ORDER BY total_claims DESC
	LIMIT 5
))
ORDER BY total_claims DESC;

-- 3. Your goal in this question is to generate a list of the top prescribers in each of the major metropolitan areas of Tennessee.
--     a. First, write a query that finds the top 5 prescribers in Nashville in terms of the total number of claims (total_claim_count) across all drugs. 
-- Report the npi, the total number of claims, and include a column showing the city.

SELECT 
	npi, 
	SUM(p2.total_claim_count) AS total_claims, 
	p1.nppes_provider_city
FROM prescriber AS p1
	LEFT JOIN prescription AS p2
		USING(npi)
WHERE p1.nppes_provider_city = 'NASHVILLE'
	AND p2.total_claim_count IS NOT NULL
GROUP BY 1,3
ORDER BY total_claims DESC
LIMIT 5;

--     b. Now, report the same for Memphis.

SELECT 
	npi, 
	SUM(p2.total_claim_count) AS total_claims, 
	p1.nppes_provider_city
FROM prescriber AS p1
	LEFT JOIN prescription AS p2
		USING(npi)
WHERE p1.nppes_provider_city = 'MEMPHIS'
	AND p2.total_claim_count IS NOT NULL
GROUP BY 1,3
ORDER BY total_claims DESC
LIMIT 5;
    
--     c. Combine your results from a and b, along with the results for Knoxville and Chattanooga.

(SELECT * FROM(
	SELECT 
		npi, 
		SUM(p2.total_claim_count) AS total_claims, 
		p1.nppes_provider_city
	FROM prescriber AS p1
		LEFT JOIN prescription AS p2
			USING(npi)
	WHERE p1.nppes_provider_city = 'NASHVILLE'
		AND p2.total_claim_count IS NOT NULL
	GROUP BY 1,3
	ORDER BY total_claims DESC
	LIMIT 5
))
UNION ALL
(SELECT * FROM(
	SELECT 
		npi, 
		SUM(p2.total_claim_count) AS total_claims, 
		p1.nppes_provider_city
	FROM prescriber AS p1
		LEFT JOIN prescription AS p2
			USING(npi)
	WHERE p1.nppes_provider_city = 'MEMPHIS'
		AND p2.total_claim_count IS NOT NULL
	GROUP BY 1,3
	ORDER BY total_claims DESC
	LIMIT 5
))
UNION ALL
(SELECT * FROM(
	SELECT 
		npi, 
		SUM(p2.total_claim_count) AS total_claims, 
		p1.nppes_provider_city
	FROM prescriber AS p1
		LEFT JOIN prescription AS p2
			USING(npi)
	WHERE p1.nppes_provider_city = 'KNOXVILLE'
		AND p2.total_claim_count IS NOT NULL
	GROUP BY 1,3
	ORDER BY total_claims DESC
	LIMIT 5
))
UNION ALL
(SELECT * FROM(
	SELECT 
		npi, 
		SUM(p2.total_claim_count) AS total_claims, 
		p1.nppes_provider_city
	FROM prescriber AS p1
		LEFT JOIN prescription AS p2
			USING(npi)
	WHERE p1.nppes_provider_city = 'CHATTANOOGA'
		AND p2.total_claim_count IS NOT NULL
	GROUP BY 1,3
	ORDER BY total_claims DESC
	LIMIT 5
))
ORDER BY total_claims DESC;

-- 4. Find all counties which had an above-average number of overdose deaths. Report the county name and number of overdose deaths.

-- 5.
--     a. Write a query that finds the total population of Tennessee.
    
--     b. Build off of the query that you wrote in part a to write a query that returns for each county that county's name, its population, and the percentage of the total population of Tennessee that is contained in that county.