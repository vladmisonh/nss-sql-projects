# Medicare Part D Prescribers – SQL Analysis Project  

This project analyzes data derived from the **Medicare Part D Prescriber Public Use File**, focusing on prescriber behavior, specialties, drug costs, opioid use, and geographic trends.  
The project was completed as part of the **Nashville Software School (NSS) Data Analytics Bootcamp**, with an emphasis on **PostgreSQL, joins, aggregations, CASE logic, and advanced grouping sets**.  

---

## Project Overview  

The analysis explored prescriber and prescription data across multiple dimensions:  

1. **Top Prescribers & Specialties**  
   - Highest total claims overall and by specialty.  
   - Specialties with the highest proportion of opioid claims.  
   - Detection of specialties with no prescription activity.  

2. **Drug-Level Analysis**  
   - Drugs with the highest total cost and cost per day.  
   - Categorization of drugs into **opioid, antibiotic, or neither**.  
   - Comparison of total spending on opioids vs. antibiotics.  

3. **Geographic Analysis (Tennessee Focus)**  
   - Number of **Core-Based Statistical Areas (CBSAs)** in Tennessee.  
   - Largest and smallest CBSAs by population.  
   - Largest Tennessee county not in a CBSA (Sevier County).  
   - Pivot analysis of opioid prescriptions across Nashville, Memphis, Knoxville, and Chattanooga.  

4. **Prescriber-Drug Relationships**  
   - Identification of prescribers with high-claim drugs (≥3000 claims).  
   - Linking prescribers to opioid vs. non-opioid prescribing.  
   - Full list of Nashville **Pain Management Specialists** with opioid prescribing patterns (637 combinations).  

5. **Bonus & Advanced Queries**  
   - Crosstab queries using PostgreSQL **tablefunc** extension for opioid claim counts by city and drug type.  
   - Grouping sets, rollups, and cubes to compare opioid vs. non-opioid prescribing.  
   - Top prescribers in Tennessee metropolitan areas.  
   - Overdose analysis by Tennessee counties.  

---

## Data & Schema  

The database includes the following tables:  
- **prescriber** – Provider demographics, specialty, and location.  
- **prescription** – Drug claims, day supply, and costs.  
- **drug** – Drug dictionary with opioid/antibiotic flags.  
- **cbsa / fips_county / population** – County and metro area population data.  
- **overdose_deaths** – Tennessee overdose death counts by county.  

Entity-Relationship Diagram: `ERD.png`  

---

## Tools & Technologies Used  

- **PostgreSQL** – Querying and relational joins  
- **pgAdmin 4** – SQL IDE for query execution  
- **SQL Features** –  
  - Joins (INNER, LEFT, CROSS)  
  - Aggregations and Grouping  
  - CASE expressions for drug classification  
  - CTEs for readability and modular queries  
  - GROUPING SETS, ROLLUP, CUBE  
  - Crosstab pivoting with `tablefunc`  

---

## Key Insights  

- **Top Prescriber** – Dr. Bruce Pendley (Family Practice) with 99,707 claims.  
- **Top Specialty** – Family Practice, with over 9.7M total claims.  
- **Top Opioid Specialty** – Nurse Practitioners led in opioid prescribing (900,845 claims).  
- **Top Cost Drug** – *Insulin Glargine* with $104M in total costs.  
- **Highest Cost per Day** – *C1 Esterase Inhibitor* at $3,495/day.  
- **Spending Comparison** – More was spent on **opioids ($105M)** than antibiotics.  
- **Tennessee Geography** – 42 CBSAs in TN; largest: Nashville metro (1.83M population); smallest: Morristown (116K).  
- **County Analysis** – Sevier County (95K) identified as the largest non-CBSA county.  
- **High-Volume Prescriptions** – Over 3,000-claim drugs linked to opioid classifications and prescriber details.  
- **City Comparisons** – Pivot analysis revealed differences in opioid prescribing patterns across TN metros.  

---

## Learning Outcomes  

This project strengthened my SQL expertise in:  
- Writing **complex join queries** across multiple healthcare datasets.  
- Using **CASE, COALESCE, GROUPING SETS, ROLLUP, and CUBE** for advanced analysis.  
- Building **crosstab pivot tables** in PostgreSQL.  
- Connecting healthcare prescribing behavior with public health indicators.  
- Exploring both **provider-level and geographic-level** perspectives.  

---

## Repository Contents  

- **prescribers.backup** – PostgreSQL backup of full database  
- **prescribers.sql** – Main SQL scripts answering project tasks  
- **prescribers_bonus.sql** – Advanced analysis queries  
- **prescribers_bonus_2.sql** – Grouping sets, rollups, and crosstab pivots  
- **ERD.png** – Entity Relationship Diagram of schema  
- **prescribers_erd_schema.pgerd** – ERD schema source file  
- **README_task.md** – Main project tasks  
- **README_Bonus_task.md** – Bonus task descriptions  

---

This project demonstrates how **SQL analysis of healthcare data** can uncover insights into prescribing patterns, opioid usage, and regional trends – providing valuable context for both healthcare providers and policymakers.  
