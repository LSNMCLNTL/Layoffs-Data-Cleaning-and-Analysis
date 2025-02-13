-- Exploratory Data Analysis

-- Identified the earliest and latest layoff events.
SELECT MIN(date), MAX(date)
FROM layoffs_datacleaning2
ORDER BY date DESC;

-- Checking the maximum number of layoffs recorded for a single event
SELECT MAX(total_laid_off)
FROM layoffs_datacleaning2

SELECT *, MIN(total_laid_off)
FROM layoffs_datacleaning2


-- Check which companies laid off the most employees
SELECT company, SUM(total_laid_off) as total
FROM layoffs_datacleaning2
GROUP BY company
ORDER BY total desc

-- Check which industries laid off the most employees
SELECT industry, SUM(total_laid_off) as total
FROM layoffs_datacleaning2
GROUP BY industry
ORDER BY total desc;

-- Check which countries laid off the most employees
SELECT country, SUM(total_laid_off) as total
FROM layoffs_datacleaning2
GROUP BY country
ORDER BY total desc;

-- Check which stage of the company did they laid off the most employees

SELECT stage, SUM(total_laid_off) as total_gg
FROM layoffs_datacleaning2
WHERE stage <> 'Unknown'
GROUP BY stage
ORDER BY stage 


SELECT YEAR(date) as year, SUM(total_laid_off) as total_gg
FROM layoffs_datacleaning2
WHERE date IS NOT NULL 
GROUP BY YEAR
ORDER BY total_gg DESC

SELECT SUM(total_laid_off)
FROM layoffs_datacleaning2

-- Monthly rolling total
WITH rolling_total_date AS (
SELECT 
    SUBSTRING(date,1,7) as month_yr, 
    SUM(total_laid_off) as total_gg
FROM layoffs_datacleaning2
WHERE SUBSTRING(date,1,7) IS NOT NULL
GROUP BY month_yr
ORDER BY SUBSTRING(date,1,7) ASC
)
SELECT 
    rtd.month_yr, total_gg,
    SUM(total_gg) OVER (ORDER BY month_yr) AS rolling_total
FROM rolling_total_date rtd

-- Compared the number of layoffs of each company for the years 2021, 2022, 2023.
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

-- Top companies with the highest layoffs per year
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


