# PoetryKids Database – SQL Analysis Project  

This project explores the **PoetryKids Database**, a collection of poems written by children in grades 1 through 5.  
The analysis focuses on poetry themes, author demographics, emotional intensity, and literary patterns using advanced SQL queries.  

The project was completed as part of the **Nashville Software School (NSS) Data Analytics Bootcamp**, with emphasis on **SQL joins, grouping, CTEs, and exploratory analysis**.  
s
---

## Project Overview  

Using the PoetryKids dataset, the following research questions were explored【161†source】【162†source】:  

1. **Poet Demographics by Grade and Gender**  
   - Number of poets per grade (1st–5th).  
   - Male vs. Female poet distribution.  
   - Ratio and trend analysis across grade levels.  

2. **Popular Poetic Themes**  
   - Frequency of poems mentioning “love” vs. “death”.  
   - Average poem length by theme.  
   - Comparative analysis of emotional depth in both categories.  

3. **Emotional Intensity and Poem Length**  
   - Which emotions are associated with longer or shorter poems.  
   - Top 5 most intense poems expressing “Joy”.  
   - Misclassifications observed in emotional tagging.  

4. **Comparing Anger Across Grades**  
   - Top 5 most intense “Anger” poems in 1st vs. 5th grade.  
   - Gender breakdown of top angry poets.  
   - Example of a standout poem: *“CHEESE?”*.  

5. **Authors Named Emily**  
   - Distribution of poets named Emily by grade.  
   - Emotional intensity and themes in their poems.  
   - Exported report to Excel for visualization.  

---

## Data & Schema  

The database includes these main tables:  
- **poem** – Title, text, author, length, and poem-level metrics.  
- **author** – Author name, grade, and gender.  
- **poem_emotion** – Emotional classifications with intensity scores.  
- **emotion** – Emotion dictionary (e.g., Anger, Joy).  
- **grade** – Grade level (1st–5th).  
- **gender** – Gender classification (Male/Female).  

Entity-Relationship Diagram: `PoetryKids_erd.png`  

---

## Tools & Technologies Used  

- **PostgreSQL** – Querying and schema exploration  
- **pgAdmin 4** – SQL IDE for query execution  
- **SQL Queries** – Aggregations, joins, grouping, filtering  
- **Advanced SQL** – CTEs, window functions, keyword text analysis  
- **Excel** – Exporting results for visualization  

---

## Key Insights  

- **Demographics** – Number of poets increases with grade; girls consistently outnumber boys.  
- **Themes** – Children write about “love” far more often than “death”. Love poems are shorter, while death poems are longer on average.  
- **Emotions** – “Anger” is associated with the longest poems, “Joy” with shorter ones.  
- **Grade Comparisons** – 5th graders write angrier poems than 1st graders (higher intensity). Females appear more often in the top angry poems.  
- **Emily Authors** – Multiple “Emilys” were found, with their poem intensity decreasing as grade level increases.  

---

## Learning Outcomes  

This project strengthened skills in:  
- Handling normalized datasets (3NF) and designing efficient joins.  
- Using **text search functions** in SQL.  
- Writing **CTEs and window functions** for analytical tasks.  
- Translating literary and emotional questions into structured SQL queries.  
- Combining SQL analysis with **Excel visualizations** for storytelling.  

---

## Repository Contents  

- **poetrykids.tar** – PostgreSQL backup of the database  
- **PoetryKids_erd.png** – Entity Relationship Diagram  
- **VMISONH_assessment.sql** – SQL queries with answers as comments  
- **question_5.xlsx** – Excel export of the Emily analysis  
- **README_task.md** – Main project instructions  

---

This project demonstrates how **data analytics and SQL** can uncover insights from children’s poetry, highlighting both literary patterns and emotional expression across grades.  
