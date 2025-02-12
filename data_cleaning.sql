-- Data Cleaning

SELECT * FROM layoffs;

/*Goals for data cleaning
1. Remove Duplicates
2. Standardize Data 
3. Null values or blank values
4. Remove any columns (if irrelevant)
*/

--Create another table
CREATE TABLE layoffs_datacleaning AS
SELECT * FROM layoffs;

WITH duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) as row_num
FROM layoffs_datacleaning
)
SELECT * from duplicate_cte
WHERE row_num > 1;

SELECT *,
ROW_NUMBER() OVER (PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) as row_num
FROM layoffs_datacleaning

CREATE TABLE layoffs_datacleaning2 AS
SELECT *,
ROW_NUMBER() OVER (PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) as row_num
FROM layoffs_datacleaning

SELECT * 
FROM layoffs_datacleaning2

DELETE 
from layoffs_datacleaning2
WHERE row_num > 1;

UPDATE layoffs_datacleaning2
SET company = TRIM(company);


UPDATE layoffs_datacleaning2
SET industry = 'Crypto'
WHERE industry = 'Crypto Currency';

SELECT DISTINCT industry
FROM layoffs_datacleaning2

SELECT DISTINCT country
FROM layoffs_datacleaning2
ORDER BY country ASC

--We have found that there are two United States: United States and United States.
UPDATE layoffs_datacleaning2
SET country = TRIM(TRAILING '.' FROM COUNTRY)

--change date format from mm/dd/yyy to yyyy/mm/dd
UPDATE layoffs_datacleaning2
SET date = STR_TO_DATE(date, '%m/%d/%Y')

SELECT date
FROM layoffs_datacleaning2

-- change data type of 'date' column from text to date 
ALTER TABLE layoffs_datacleaning2 
MODIFY COLUMN date DATE;

SELECT company, industry
FROM layoffs_datacleaning2
WHERE industry is null or industry = ''

SELECT t1.industry, t2.industry
FROm layoffs_datacleaning2 t1 
JOIN layoffs_datacleaning2 t2 
    ON t1.company = t2.company

UPDATE layoffs_datacleaning2 t1
JOIN layoffs_datacleaning2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry ='')
AND t2.industry IS NOT NULL

-- Check if there are many null values in these columns
DELETE
FROM layoffs_datacleaning2
WHERE total_laid_off IS NULL and percentage_laid_off IS NULL

-- Check if they have been deleted in the table
SELECT *
FROM layoffs_datacleaning2
WHERE total_laid_off IS NULL and percentage_laid_off IS NULL


SELECT * FROM layoffs_datacleaning2

ALTER TABLE layoffs_datacleaning2
DROP COLUMN row_num

SELECT * FROM layoffs_datacleaning2
