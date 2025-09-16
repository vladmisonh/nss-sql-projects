# App Trader – SQL Analysis Project  

This project analyzes applications from the **Apple App Store** and **Google Play Store** to identify which apps App Trader should purchase, market, and monetize.  
The project was developed as part of the **Nashville Software School (NSS) Data Analytics Bootcamp**, focusing on **SQL analysis, profitability modeling, and business recommendations**.  

---

## Project Overview  

App Trader is a broker company that acquires rights to apps to generate revenue through in-app purchases and advertising.  
Since App Store and Play Store datasets are stored separately and lack referential integrity, all analysis was done in **PostgreSQL** with business assumptions applied【198†source】.  

The analysis explored:  

1. **Purchase Pricing Model**  
   - Apps are acquired for **10,000× the listed price**.  
   - Minimum purchase price is **$10,000** for free or low-cost apps【198†source】.  
   - For dual-platform apps, the **highest app price** is used for valuation.  

2. **Earnings and Costs**  
   - Apps earn **$5,000/month per platform** from ads and in-app purchases.  
   - Dual-platform apps earn **$10,000/month**.  
   - Marketing cost is fixed at **$1,000/month per app**, regardless of platform count【198†source】.  

3. **Lifespan Model**  
   - For every **0.5 increase in average rating**, an app’s lifespan increases by **1 year**.  
   - Lifespan = `1 + (rating × 2)` years (rounded to nearest 0.5)【198†source】.  

4. **Profitability Calculation**  
   - Profit per Month = Earnings – Marketing Costs.  
   - Lifetime Profit = Monthly Profit × Lifespan (in years).  
   - Total Profit = Lifetime Profit – Purchase Price【200†source】.  

5. **Deliverables**  
   - A **Top 10 List of Apps** App Trader should buy, based on profitability.  
   - General recommendations on **price range, genre, and content rating**【199†source】.  
   - Presentation report with insights and visualizations (`App Trader.pptx`).  

---

## Key Findings  

- **Target Free & Low-Cost Apps** – Balanced investment with high potential ROI.  
- **Games Dominated the Top 10** – Casual and family-friendly games proved most profitable.  
- **Content Rating** – “Everyone” rated games are safer and more accessible to larger audiences.  
- **Dual-Platform Apps** – Availability on both stores maximized revenue while minimizing marketing costs.  
- **Profitability Drivers** – High ratings extended lifespan, significantly improving long-term returns【199†source】.  

---

## Tools & Technologies  

- **PostgreSQL** – Main analysis and queries  
- **pgAdmin 4** – SQL IDE  
- **Excel** – Exported query results for charts and financial modeling  
- **PowerPoint** – Final presentation with recommendations (`App Trader.pptx`)  

---

## 📚 Learning Outcomes  

This project strengthened my skills in:  
- **SQL query optimization** (joins, aggregations, CASE, CTEs).  
- Designing **profitability models** with business rules.  
- Translating client assumptions into structured SQL logic.  
- Presenting insights with a mix of **data analysis and storytelling**.  

---

## Repository Contents  

- **app_store_backup.backup** – PostgreSQL backup of source database  
- **app_trader.sql** – SQL queries implementing business rules and profitability models  
- **App Trader.pptx** – Final presentation with recommendations and visuals  
- **README_task.md** – Project instructions and requirements  

---

This project demonstrates how **SQL and business logic** can be combined to drive strategic investment recommendations in the mobile app market.  
