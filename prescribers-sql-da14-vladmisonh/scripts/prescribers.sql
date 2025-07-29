-- 1. 
--     a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.

SELECT
	npi,
	SUM(p2.total_claim_count) AS total_claims
FROM prescriber AS p1
	LEFT JOIN prescription AS p2
		USING(npi)
WHERE p2.total_claim_count IS NOT NULL
GROUP BY 1
ORDER BY total_claims DESC;

-- Answer: 1881634483	99707

--     b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.

SELECT
	npi,
	p1.nppes_provider_first_name,
	p1.nppes_provider_last_org_name,
	p1.specialty_description,
	SUM(p2.total_claim_count) AS total_claims
FROM prescriber AS p1
	LEFT JOIN prescription AS p2
		USING(npi)
WHERE p2.total_claim_count IS NOT NULL
GROUP BY 1,2,3,4
ORDER BY total_claims DESC;

-- Answer: 1881634483	"BRUCE"	"PENDLEY"	"Family Practice"	99707


-- 2. 
--     a. Which specialty had the most total number of claims (totaled over all drugs)?

SELECT
	p1.specialty_description,
	SUM(p2.total_claim_count) AS total_claims
FROM prescriber AS p1
	LEFT JOIN prescription AS p2
		USING(npi)
WHERE p2.total_claim_count IS NOT NULL
GROUP BY 1
ORDER BY total_claims DESC;

-- Answer: "Family Practice"	9752347

--     b. Which specialty had the most total number of claims for opioids?

SELECT
	p1.specialty_description,
	d.opioid_drug_flag,
	SUM(p2.total_claim_count) AS total_claims
FROM prescriber AS p1
	LEFT JOIN prescription AS p2
		USING(npi)
	LEFT JOIN drug AS d
		ON p2.drug_name = d.drug_name
WHERE p2.total_claim_count IS NOT NULL
	AND d.opioid_drug_flag = 'Y'
GROUP BY 1,2
ORDER BY total_claims DESC;

-- Answer: "Nurse Practitioner"	"Y"	900845

--     c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

(SELECT 
	DISTINCT specialty_description
FROM prescriber)
EXCEPT
(SELECT 
	DISTINCT p1.specialty_description
FROM prescriber AS p1
	INNER JOIN prescription AS p2 
		USING(npi))
ORDER BY specialty_description ASC;


-- variant with NOT IN

SELECT DISTINCT 
	specialty_description
FROM prescriber
WHERE specialty_description NOT IN (
	SELECT DISTINCT 
		p1.specialty_description
	FROM prescriber AS p1
		INNER JOIN prescription AS p2 
			USING(npi))
ORDER BY specialty_description ASC;

--     d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* 
-- For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

SELECT
	p1.specialty_description,
	SUM(p2.total_claim_count) AS total_claims,
	SUM(CASE
			WHEN d.opioid_drug_flag = 'Y'
				THEN p2.total_claim_count
			ELSE 0
		END )  AS opioids_claims,
	ROUND((SUM(CASE
			WHEN d.opioid_drug_flag = 'Y'
				THEN p2.total_claim_count
			ELSE 0 END) * 100 / SUM(p2.total_claim_count)),2) AS percentage_of_opioids
FROM prescriber AS p1
	LEFT JOIN prescription AS p2
		USING(npi)
	LEFT JOIN drug AS d
		ON p2.drug_name = d.drug_name
WHERE p2.total_claim_count IS NOT NULL
GROUP BY 1
ORDER BY percentage_of_opioids DESC;

-- Answer: "Case Manager/Care Coordinator"	50	36	72.00

-- 3. 
--     a. Which drug (generic_name) had the highest total drug cost?

SELECT 
	d.generic_name,
	SUM(p.total_drug_cost)::MONEY AS total_drug_cost
FROM drug AS d
	LEFT JOIN prescription AS p
		USING(drug_name)
WHERE p.total_drug_cost IS NOT NULL
GROUP BY 1
ORDER BY total_drug_cost DESC;

-- Answer: "INSULIN GLARGINE,HUM.REC.ANLOG"	"$104,264,066.35"

--     b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.**

SELECT 
	d.generic_name,
	SUM(p.total_day_supply) AS total_day_supply,
	SUM(p.total_drug_cost) AS total_drug_cost,
	ROUND(SUM(p.total_drug_cost) / SUM(p.total_day_supply),2) AS cost_per_day
FROM drug AS d
	LEFT JOIN prescription AS p
		USING(drug_name)
WHERE p.total_drug_cost IS NOT NULL
GROUP BY 1
ORDER BY cost_per_day DESC;

-- Answer: "C1 ESTERASE INHIBITOR"	1070	3739884.35	3495.22

-- 4. 
--     a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs. 
-- **Hint:** You may want to use a CASE expression for this. See https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/ 

SELECT
	drug_name,
	opioid_drug_flag,
	antibiotic_drug_flag,
	CASE
		WHEN opioid_drug_flag = 'Y'
			THEN 'opioid'
		WHEN antibiotic_drug_flag = 'Y'
			THEN 'antibiotic'
		ELSE 'neither'
	END AS drug_type
FROM drug;

--     b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. 
-- Hint: Format the total costs as MONEY for easier comparision.

SELECT
	CASE
		WHEN d.opioid_drug_flag = 'Y'
			THEN 'opioid'
		WHEN d.antibiotic_drug_flag = 'Y'
			THEN 'antibiotic'
		ELSE 'neither'
	END AS drug_type,
	SUM(p.total_drug_cost) :: MONEY AS total_drug_cost
FROM drug AS d
	LEFT JOIN prescription AS p
		USING(drug_name)
WHERE d.opioid_drug_flag = 'Y'
	OR d.antibiotic_drug_flag = 'Y'
GROUP BY drug_type
ORDER BY total_drug_cost DESC;

-- Answer: "opioid"	"$105,080,626.37"

-- 5. 
--     a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.

SELECT 
	COUNT(*)
FROM cbsa AS c
	LEFT JOIN fips_county AS f
		USING(fipscounty)
WHERE f.state = 'TN';

-- Answer: 42

--     b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.

(SELECT 
	'Largest' AS type,
	c.cbsaname,
	SUM(p.population) AS total_population
FROM cbsa AS c
LEFT JOIN population AS p
	USING(fipscounty)
WHERE p.population IS NOT NULL
GROUP BY c.cbsaname
ORDER BY total_population DESC
LIMIT 1)
UNION
(SELECT 
	'Smallest' AS type,
	c.cbsaname,
	SUM(p.population) AS total_population
FROM cbsa AS c
LEFT JOIN population AS p
	USING(fipscounty)
WHERE p.population IS NOT NULL
GROUP BY c.cbsaname
ORDER BY total_population ASC
LIMIT 1)
ORDER BY total_population DESC;

-- Answer: 
-- "Largest"	"Nashville-Davidson--Murfreesboro--Franklin, TN"	1830410
-- "Smallest"	"Morristown, TN"	116352

--     c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

SELECT 
    f.county,
    p.population
FROM population AS p
	LEFT JOIN fips_county AS f 
		USING(fipscounty)
	LEFT JOIN cbsa AS c 
		USING(fipscounty)
WHERE c.fipscounty IS NULL  
ORDER BY p.population DESC 
LIMIT 1;

-- Answer: "SEVIER"	95523

-- 6. 
--     a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

SELECT 
	p.drug_name,
	p.total_claim_count
FROM prescription AS p
WHERE total_claim_count >= 3000;

--     b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

SELECT 
	p.drug_name,
	p.total_claim_count,
	CASE
		WHEN d.opioid_drug_flag = 'Y'
			THEN 'opioid'
		ELSE 'not opioid'
	END AS drug_type
FROM prescription AS p
	LEFT JOIN drug AS d
		USING(drug_name)
WHERE total_claim_count >= 3000;

--     c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.

SELECT 
	p2.nppes_provider_first_name,
	p2.nppes_provider_last_org_name,
	p1.drug_name,
	p1.total_claim_count,
	CASE
		WHEN d.opioid_drug_flag = 'Y'
			THEN 'opioid'
		ELSE 'not opioid'
	END AS drug_type
FROM prescription AS p1
	LEFT JOIN drug AS d
		USING(drug_name)
	LEFT JOIN prescriber AS p2
		USING(npi)
WHERE total_claim_count >= 3000;

-- 7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. **Hint:** The results from all 3 parts will have 637 rows.

--     a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

SELECT 
	npi,
	d.drug_name
FROM prescriber AS p1
	CROSS JOIN drug AS d
WHERE p1.specialty_description = 'Pain Management'
	AND p1.nppes_provider_city = 'NASHVILLE'
	AND d.opioid_drug_flag = 'Y';

--     b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).

SELECT 
	p1.npi,
	d.drug_name,
	p2.total_claim_count
FROM prescriber AS p1
	CROSS JOIN drug AS d
	LEFT JOIN prescription AS p2 
    	USING(npi,drug_name)
WHERE p1.specialty_description = 'Pain Management'
	AND p1.nppes_provider_city = 'NASHVILLE'
	AND d.opioid_drug_flag = 'Y';

--     c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.

SELECT 
	p1.npi,
	d.drug_name,
	COALESCE(p2.total_claim_count,0)
FROM prescriber AS p1
	CROSS JOIN drug AS d
	LEFT JOIN prescription AS p2 
    	USING(npi,drug_name)
WHERE p1.specialty_description = 'Pain Management'
	AND p1.nppes_provider_city = 'NASHVILLE'
	AND d.opioid_drug_flag = 'Y';