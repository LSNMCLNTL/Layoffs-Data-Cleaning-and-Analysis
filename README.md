# Layoffs Data Cleaning and Analysis

** Project Overview **
This project focuses on cleaning and analyzing a dataset containing information about layoffs across different companies, industries, and countries. The data is refined through structured SQL queries to remove inconsistencies, duplicates, and missing values, ensuring accuracy for further exploratory analysis
---

## Technologies Used
- **MySQL Workbench** for data cleaning and transformation.
- Used **layoffs.csv** for the database

## Data Cleaning Process
The data cleaning process follows these key steps:

### 1. **Removing Duplicates**
- A new table (`layoffs_datacleaning2`) is created to store cleaned data.
- Identified duplicate rows using `ROW_NUMBER()` based on key columns.
- Removed duplicates while retaining the first occurrence.

### 2. **Standardizing Data**
- Trimmed extra spaces in `company` names.
- Standardized `industry` values like changing "Crypto Currency" to "Crypto".
- Fixed inconsistencies in `country` names such as removing trailing period in "United States.

### 3. **Handling Null or Blank Values**
- Filled missing `industry` values by mapping them based on `company` names.
- Removed rows where both `total_laid_off` and `percentage_laid_off` were NULL.

### 4. **Fixing Date Format**
- Converted `date` column from `TEXT` to `DATE` format using `STR_TO_DATE()`.
- Ensured all dates follow `YYYY-MM-DD` format.

### 5. **Removing Unnecessary Columns**
- Dropped `row_num` after duplicate removal to keep the dataset clean.

---

## Exploratory Data Analysis (EDA)
After cleaning the dataset, an exploratory data analysis was conducted to derive insights and trends from the data.

### 1. **General Statistics**
- Identified the earliest and latest layoff events.
- Found the maximum number of layoffs recorded for a single event.
- Analyzed which companies had the highest total layoffs.

### 2. **Layoffs by Category**
- **Company-Level Analysis**: Summed up total layoffs per company and ranked them.
- **Industry-Level Analysis**: Aggregated layoffs per industry to see which sectors were most affected.
- **Country-Level Analysis**: Identified the countries with the highest number of layoffs.
- **Stage-Based Analysis**: Explored how layoffs varied across different company stages (e.g., startup, public, etc.).

### 3. **Layoffs Over Time**
- **Yearly Trends**: Summarized total layoffs per year and identified peak years.
- **Monthly Rolling Totals**: Created a rolling total of layoffs over time to visualize long-term trends.
- **Yearly Company Comparison**: Compared layoffs at the company level for the years 2021, 2022, and 2023 with the help of this query

```
SELECT 
    company,
    SUM(CASE WHEN YEAR(date) = 2021 THEN total_laid_off ELSE 0 END) AS layoffs_2021,
    SUM(CASE WHEN YEAR(date) = 2022 THEN total_laid_off ELSE 0 END) AS layoffs_2022,
    SUM(CASE WHEN YEAR(date) = 2023 THEN total_laid_off ELSE 0 END) AS layoffs_2023,
    SUM(total_laid_off)
FROM layoffs_datacleaning2
WHERE date IS NOT NULL
GROUP BY company
ORDER BY SUM(total_laid_off) DESC;
```
- **Top Companies Per Year**: Ranked the top five companies with the highest layoffs for each year with the help of this query
```
WITH companiess AS (
SELECT company, YEAR(date) as year, SUM(total_laid_off) as total_gg
FROM layoffs_datacleaning2
GROUP BY company
),
ranking_per_year AS(
SELECT *,
DENSE_RANK() OVER(PARTITION BY year ORDER BY total_gg DESC) as top_rank
FROM companiess
WHERE year IS NOT NULL and total_gg IS NOT NULL
)
SELECT * FROM ranking_per_year
WHERE top_rank <=5
```


---
## Author
Elson Benn M. Macalintal
**Data Analyst | Machine Learning Enthusiast**

