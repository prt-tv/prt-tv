-- Data Cleaning

SELECT *
FROM layoffs;

-- first thing we want to do is create staging table. This is one we will work in and clean the data . we want table with the raw data in case something happens

CREATE TABLE layoffs_staging
LIKE layoffs;

-- 1. Remove Duplicate
-- 2. Standerdize The Data
-- 3. Null Values Or blank values
-- 4. Remove Any Columns

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

-- 1. Remove Duplicates

# FIRST lets check for duplicates

SELECT *
FROM layoffs_staging;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- these are the ones we want to delete where the row number is > 1 or 2 or greater essentially
WITH  duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num >1;


-- one solution which i think good one  is create a new column  and add the number in. Then delete where row numbers are over 2 then delete the column
-- so let's do it

ALTER TABLE layoffs_staging ADD row_num INT;
  
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL, 
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- now that we have this  we can delete row were row_num is greater then 2

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;


-- 2. Standerdize Data

SELECT company
FROM layoffs_staging2;

SELECT company , TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT `date` ,STR_TO_DATE(`date` , '%m/%d/%Y')
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date` , '%m/%d/%Y');


SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1 ;

SELECT DISTINCT COUNTRY
FROM layoffs_staging2
WHERE country LIKE 'United states%';

SELECT DISTINCT country , TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
WHERE country LIKE 'United States%';

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

  -- if we look at industry is look  like we some null and empty rows
SELECT  DISTINCT industry
FROM layoffs_staging2
WHERE industry IS NULL
AND industry = '';

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging
WHERE industry IS NULL
OR industry = '';

UPDATE layoffs_staging2
SET industry = null
WHERE industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'airbnb';

SELECT t1.industry , t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
